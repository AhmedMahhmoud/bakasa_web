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

const {onRequest} = require("firebase-functions/v2/https");
const nodemailer = require("nodemailer");

const MAX = {name: 200, phone: 60, location: 4000};

function trim(str, max) {
  if (typeof str !== "string") return "";
  const t = str.trim();
  return t.length > max ? t.slice(0, max) : t;
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
      res.status(405).json({success: false, message: "Method not allowed"});
      return;
    }

    const expectedSecret = process.env.ORDER_FORM_SECRET;
    if (expectedSecret) {
      const sent = req.get("X-Order-Secret") || "";
      if (sent !== expectedSecret) {
        res.status(403).json({success: false, message: "Forbidden"});
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
    const location = trim(body.location, MAX.location);

    if (!name || !phone || !location) {
      res.status(400).json({success: false, message: "Missing name, phone, or location"});
      return;
    }

    const gmailUser = process.env.GMAIL_USER || "";
    const gmailPass = process.env.GMAIL_APP_PASSWORD || "";
    const to = process.env.ORDER_NOTIFY_EMAIL || gmailUser || "bakasagame@gmail.com";

    if (!gmailUser || !gmailPass) {
      console.error("GMAIL_USER or GMAIL_APP_PASSWORD not set");
      res.status(500).json({success: false, message: "Email not configured on server"});
      return;
    }

    const orderRef = new Date().toISOString();
    const payload = {name, phone, location};
    const text =
      "New Bakasa box order\n\n" +
      `Order ref: ${orderRef}\n\n` +
      `Name: ${name}\n` +
      `Phone: ${phone}\n` +
      `Location / delivery: ${location}\n\n` +
      "---\n" +
      "Request JSON:\n" +
      JSON.stringify(payload, null, 0) +
      "\n\n" +
      "— Sent from Bakasa web order form (server)";

    try {
      const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {user: gmailUser, pass: gmailPass},
      });

      await transporter.sendMail({
        from: `"Bakasa orders" <${gmailUser}>`,
        to,
        subject: `Bakasa order — ${name}`,
        text,
      });

      res.status(200).json({success: true});
    } catch (err) {
      console.error("sendMail error", err);
      res.status(500).json({
        success: false,
        message: err.message || "Failed to send email",
      });
    }
  },
);
