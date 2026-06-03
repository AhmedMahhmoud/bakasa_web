/**
 * Deploy: from repo root run `firebase deploy --only functions`
 *
 * Required environment variables (Firebase Console → Functions → your function → Edit → Runtime env):
 *   GMAIL_USER           — Gmail address used to send (e.g. bakasagame@gmail.com)
 *   GMAIL_APP_PASSWORD   — Google Account → App passwords (not your normal password)
 *   ORDER_NOTIFY_EMAIL   — Inbox that receives orders (default: same as GMAIL_USER)
 *
 * Optional:
 *   ORDER_FORM_SECRET    — If set, client must send header X-Order-Secret with the same value
 *                          (set matching ORDER_FORM_SECRET / dart-define in Flutter).
 */

const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();

const MAX = {
  name: 200,
  phone: 60,
  governorate: 100,
  city: 120,
  street: 250,
  building: 80,
  floor: 80,
  apartment: 80,
  notes: 2000,
  promoCode: 80,
  moneyEgp: 1_000_000,
  percent: 100,
  quantity: 1_000_000,
};

function trim(str, max) {
  if (typeof str !== "string") return "";
  const t = str.trim();
  return t.length > max ? t.slice(0, max) : t;
}

/** @param {unknown} v */
function parseBoundedInt(v, max) {
  const n = typeof v === "number" ? v : Number(v);
  if (!Number.isFinite(n) || n < 0 || n > max) return null;
  return Math.round(n);
}

function normalizePromo(raw) {
  return trim(raw, MAX.promoCode).toLowerCase().replace(/\s+/g, "");
}

/** Match Flutter PromoCodeService: Firestore `==` on strings is case-sensitive. */
function promoDartNormalize(raw) {
  let t = trim(String(raw ?? ""), MAX.promoCode);
  t = t.toLowerCase().replace(/\s+/g, " ").trim();
  return t.length > MAX.promoCode ? t.slice(0, MAX.promoCode) : t;
}

function promoQueryCandidates(raw) {
  const trimmed = trim(String(raw ?? ""), MAX.promoCode);
  const lower = promoDartNormalize(raw);
  const upper = lower ? lower.toUpperCase() : "";
  /** @type {string[]} */
  const out = [];
  const push = (s) => {
    if (!s || s.length > MAX.promoCode) return;
    if (!out.includes(s)) out.push(s);
  };
  push(trimmed);
  push(lower);
  push(upper);
  return out;
}

async function reservePromoCodeIfAny(code) {
  if (code === null || code === undefined || !String(code).trim()) {
    return { ok: true, promoCode: "", discountPercent: 0, quantityLeft: null, docRef: null };
  }

  return db.runTransaction(async (tx) => {
    let doc = null;
    for (const candidate of promoQueryCandidates(code || "")) {
      const query = db
        .collection("promo_codes")
        .where("code", "==", candidate)
        .limit(1);
      const snap = await tx.get(query);
      if (!snap.empty) {
        doc = snap.docs[0];
        break;
      }
    }
    if (!doc) {
      return { ok: false, message: "Promo code is invalid." };
    }
    const data = doc.data() || {};
    if (data.active === false) {
      return { ok: false, message: "Promo code is not active." };
    }
    const quantity = parseBoundedInt(data.quantity, MAX.quantity);
    if (quantity === null || quantity <= 0) {
      return { ok: false, message: "Promo code has expired (fully used)." };
    }

    const discountPercent = parseBoundedInt(
      data.discount_percent ?? data.discountPercent,
      MAX.percent,
    ) ?? 0;

    tx.update(doc.ref, {
      quantity: quantity - 1,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    const storedCodeRaw = typeof data.code === "string" ? data.code.trim() : "";
    const promoResponseCode = storedCodeRaw
      ? promoDartNormalize(storedCodeRaw)
      : promoDartNormalize(String(code ?? ""));

    return {
      ok: true,
      promoCode: promoResponseCode || normalizePromo(String(code ?? "")),
      discountPercent,
      quantityLeft: quantity - 1,
      docRef: doc.ref,
    };
  });
}

exports.submitOrder = onRequest(
  {
    cors: true,
    invoker: "public",
    region: "us-central1",
    maxInstances: 5,
  },
  async (req, res) => {
    if (req.method === "OPTIONS") {
      res.status(204).send("");
      return;
    }
    if (req.method !== "POST") {
      res.status(405).json({ success: false, message: "Method not allowed" });
      return;
    }

    const expectedSecret = process.env.ORDER_FORM_SECRET;
    if (expectedSecret) {
      const sent = req.get("X-Order-Secret") || "";
      if (sent !== expectedSecret) {
        res.status(403).json({ success: false, message: "Forbidden" });
        return;
      }
    }

    let body = req.body;
    if (typeof body === "string") {
      try {
        body = JSON.parse(body || "{}");
      } catch (_) {
        body = {};
      }
    }
    if (!body || typeof body !== "object") body = {};
    const name = trim(body.name, MAX.name);
    const phone = trim(body.phone, MAX.phone);
    const governorate = trim(body.governorate, MAX.governorate);
    const city = trim(body.city, MAX.city);
    const street = trim(body.street, MAX.street);
    const buildingNumber = trim(body.buildingNumber, MAX.building);
    const floorNumber = trim(body.floorNumber, MAX.floor);
    const apartmentNumber = trim(body.apartmentNumber, MAX.apartment);
    const notesOrLandmark = trim(body.notesOrLandmark, MAX.notes);
    const promoCodeInput = normalizePromo(body.promoCode || "");

    const listPriceEgpInput = parseBoundedInt(body.originalPriceEgp, MAX.moneyEgp);
    const itemAfterDiscountInput = parseBoundedInt(
      body.itemPriceAfterDiscountEgp,
      MAX.moneyEgp,
    );
    const deliveryCostInput = parseBoundedInt(body.deliveryCostEgp, MAX.moneyEgp);
    const finalPriceInput = parseBoundedInt(body.finalPriceEgp, MAX.moneyEgp);

    if (!name || !phone || !governorate || !street || !buildingNumber || !floorNumber || !apartmentNumber) {
      res.status(400).json({ success: false, message: "Missing required delivery details." });
      return;
    }

    const gmailUser = process.env.GMAIL_USER || "";
    const gmailPass = process.env.GMAIL_APP_PASSWORD || "";
    const to = process.env.ORDER_NOTIFY_EMAIL || gmailUser || "bakasagame@gmail.com";

    if (!gmailUser || !gmailPass) {
      console.error("GMAIL_USER or GMAIL_APP_PASSWORD not set");
      res.status(500).json({ success: false, message: "Email not configured on server" });
      return;
    }

    const promoReservation = await reservePromoCodeIfAny(promoCodeInput);
    if (!promoReservation.ok) {
      res.status(400).json({ success: false, message: promoReservation.message || "Invalid promo code" });
      return;
    }

    const discountPct = promoReservation.discountPercent || 0;
    const listPriceEgp = listPriceEgpInput ?? 250;
    const itemAfterDiscountEgp = itemAfterDiscountInput ??
      Math.round((listPriceEgp * (100 - discountPct)) / 100);
    const deliveryCostEgp = deliveryCostInput ?? 0;
    const finalPriceEgp = finalPriceInput ?? (itemAfterDiscountEgp + deliveryCostEgp);

    const orderRef = new Date().toISOString();
    const textLines = [
      "New Bakasa box order",
      "",
      `Order ref: ${orderRef}`,
      "",
      `Name: ${name}`,
      `Phone: ${phone}`,
      `Governorate: ${governorate}`,
      `City: ${city}`,
      `Street: ${street}`,
      `Building no.: ${buildingNumber}`,
      `Floor no.: ${floorNumber}`,
      `Apartment no.: ${apartmentNumber}`,
    ];
    if (notesOrLandmark) {
      textLines.push(`Notes / landmark: ${notesOrLandmark}`);
    }
    if (promoReservation.promoCode) {
      textLines.push("", `Promo code: ${promoReservation.promoCode}`);
      if (discountPct > 0) {
        textLines.push(`Promo discount: ${discountPct}%`);
      }
      if (promoReservation.quantityLeft !== null) {
        textLines.push(`Promo quantity left: ${promoReservation.quantityLeft}`);
      }
    }
    textLines.push("", "Pricing");
    textLines.push(`List price (EGP): ${listPriceEgp}`);
    textLines.push(`Item after discount (EGP): ${itemAfterDiscountEgp}`);
    textLines.push(`Delivery fee (EGP): ${deliveryCostEgp}`);
    textLines.push(`Total to pay (EGP): ${finalPriceEgp}`);
    textLines.push("", "— Sent from Bakasa Web Store");

    const text = textLines.join("\n");

    try {
      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: { user: gmailUser, pass: gmailPass },
      });

      await transporter.sendMail({
        from: `"Bakasa orders" <${gmailUser}>`,
        to,
        subject: `Bakasa order — ${name}`,
        text,
      });

      res.status(200).json({ success: true });
    } catch (err) {
      if (promoReservation.docRef) {
        try {
          await promoReservation.docRef.update({
            quantity: admin.firestore.FieldValue.increment(1),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        } catch (rollbackErr) {
          console.error("promo rollback failed", rollbackErr);
        }
      }
      console.error("sendMail error", err);
      res.status(500).json({
        success: false,
        message: err.message || "Failed to send email",
      });
    }
  },
);
