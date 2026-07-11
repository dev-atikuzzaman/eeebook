import { SUBJECT_META, SUBJECT_ACCENT_HEX, IMPORTANCE_HEX } from "../components/constants";

// A4 @ 96dpi
const PAGE_W = 794;
const PAGE_H = 1123;

const IMPORTANCE_BN = { critical: "অপরিহার্য", high: "গুরুত্বপূর্ণ", medium: "মাঝারি", low: "সহায়ক" };

function escapeHtml(str = "") {
  return String(str)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

// অফস্ক্রিন প্রিন্ট-ফ্রেন্ডলি (সাদা পটভূমি) কনটেইনার তৈরি করে HTML বসিয়ে দেয়
function createPrintNode(innerHTML) {
  const node = document.createElement("div");
  node.style.position = "fixed";
  node.style.top = "0";
  node.style.left = "-99999px";
  node.style.width = PAGE_W + "px";
  node.style.background = "#ffffff";
  node.style.zIndex = "-1";
  node.innerHTML = `
    <style>
      .ed-pdf { font-family: 'Inter', 'Noto Sans Bengali', sans-serif; color: #1f2937; padding: 36px 40px; }
      .ed-pdf h1 { font-size: 22px; font-weight: 800; margin: 0 0 4px; color: #92400e; }
      .ed-pdf .ed-sub { font-size: 11px; color: #6b7280; margin-bottom: 18px; }
      .ed-pdf .ed-rule { height: 2px; background: linear-gradient(90deg,#fbbf24,#f97316); border-radius: 2px; margin-bottom: 20px; }
      .ed-entry { padding: 14px 0; border-bottom: 1px solid #e5e7eb; break-inside: avoid; }
      .ed-entry:last-child { border-bottom: none; }
      .ed-term-row { display: flex; align-items: baseline; gap: 8px; flex-wrap: wrap; }
      .ed-term-name { font-size: 15px; font-weight: 800; color: #111827; }
      .ed-badge { font-size: 9px; font-weight: 700; padding: 2px 8px; border-radius: 999px; color: #fff; }
      .ed-short { font-size: 11.5px; font-weight: 600; margin: 3px 0 6px; }
      .ed-def { font-size: 11.5px; line-height: 1.6; color: #374151; margin-bottom: 6px; }
      .ed-formula { font-size: 10.5px; line-height: 1.5; color: #92400e; background: #fffbeb; border: 1px solid #fde68a; border-radius: 6px; padding: 6px 10px; }
      .ed-label { font-size: 9px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.06em; color: #9ca3af; margin: 10px 0 4px; }
      .ed-section { font-size: 12px; line-height: 1.7; color: #374151; margin-bottom: 4px; }
      .ed-footer { margin-top: 24px; font-size: 9.5px; color: #9ca3af; text-align: center; }
      .ed-tag { display: inline-block; font-size: 9.5px; color: #6b7280; background: #f3f4f6; border-radius: 999px; padding: 2px 8px; margin: 2px 3px 0 0; }
    </style>
    ${innerHTML}
  `;
  return node;
}

async function nodeToPdfPages(node, pdf, isFirstCall) {
  const html2canvas = (await import("html2canvas")).default;
  document.body.appendChild(node);
  let canvas;
  try {
    canvas = await html2canvas(node, { scale: 2, backgroundColor: "#ffffff", useCORS: true });
  } finally {
    document.body.removeChild(node);
  }

  const scaleFactor = canvas.width / PAGE_W;
  const pageHeightCanvasPx = PAGE_H * scaleFactor;
  const totalPages = Math.max(1, Math.ceil(canvas.height / pageHeightCanvasPx));

  for (let i = 0; i < totalPages; i++) {
    const sliceHeight = Math.min(pageHeightCanvasPx, canvas.height - i * pageHeightCanvasPx);
    const sliceCanvas = document.createElement("canvas");
    sliceCanvas.width = canvas.width;
    sliceCanvas.height = sliceHeight;
    const ctx = sliceCanvas.getContext("2d");
    if (ctx) {
      ctx.fillStyle = "#ffffff";
      ctx.fillRect(0, 0, sliceCanvas.width, sliceCanvas.height);
      ctx.drawImage(canvas, 0, i * pageHeightCanvasPx, canvas.width, sliceHeight, 0, 0, canvas.width, sliceHeight);
    }
    const imgData = sliceCanvas.toDataURL("image/jpeg", 0.93);
    const isVeryFirstPage = isFirstCall && i === 0;
    if (!isVeryFirstPage) pdf.addPage([PAGE_W, PAGE_H], "portrait");
    pdf.addImage(imgData, "JPEG", 0, 0, PAGE_W, sliceHeight / scaleFactor);
  }
}

function entryHTML(term) {
  const accent = SUBJECT_ACCENT_HEX[term.subject] || "#6b7280";
  const meta = SUBJECT_META[term.subject];
  const impHex = IMPORTANCE_HEX[term.importance] || IMPORTANCE_HEX.medium;
  const tags = (term.tags || []).map((t) => `<span class="ed-tag">#${escapeHtml(t)}</span>`).join("");
  return `
    <div class="ed-entry">
      <div class="ed-term-row">
        <span class="ed-term-name">${escapeHtml(term.term)}</span>
        <span class="ed-badge" style="background:${accent}">${escapeHtml(meta?.bn || term.subject)}</span>
        <span class="ed-badge" style="background:${impHex}">${IMPORTANCE_BN[term.importance] || ""}</span>
      </div>
      <div class="ed-short" style="color:${accent}">${escapeHtml(term.short)}</div>
      <div class="ed-def">${escapeHtml(term.definition)}</div>
      <div class="ed-formula">🧮 ${escapeHtml(term.relation)}</div>
      <div style="margin-top:6px">${tags}</div>
    </div>
  `;
}

/**
 * একাধিক টার্মকে (বর্তমান ফিল্টার অনুযায়ী) একটি রেফারেন্স-শীট PDF হিসেবে এক্সপোর্ট করে।
 */
export async function exportTermsToPdf(terms, { title = "ElectroDict — Study Sheet", subtitle = "" } = {}) {
  const { jsPDF } = await import("jspdf");
  const pdf = new jsPDF({ unit: "px", format: [PAGE_W, PAGE_H] });

  const dateStr = new Date().toLocaleDateString("bn-BD", { year: "numeric", month: "long", day: "numeric" });
  const CHUNK = 10; // প্রতি ব্যাচে এতগুলো এন্ট্রি রেন্ডার করে ক্যানভাস সাইজ যুক্তিসঙ্গত রাখা হয়
  const chunks = [];
  for (let i = 0; i < terms.length; i += CHUNK) chunks.push(terms.slice(i, i + CHUNK));

  for (let c = 0; c < chunks.length; c++) {
    const isFirst = c === 0;
    const header = isFirst
      ? `<h1>⚡ ${escapeHtml(title)}</h1>
         <div class="ed-sub">${escapeHtml(subtitle)} · মোট ${terms.length}টি টার্ম · জেনারেট: ${dateStr}</div>
         <div class="ed-rule"></div>`
      : "";
    const body = chunks[c].map(entryHTML).join("");
    const footer = c === chunks.length - 1 ? `<div class="ed-footer">ElectroDict — ৮০/২০ নীতিতে EEE অভিধান</div>` : "";
    const node = createPrintNode(`<div class="ed-pdf">${header}${body}${footer}</div>`);
    await nodeToPdfPages(node, pdf, c === 0);
  }

  pdf.save(`electrodict-${Date.now()}.pdf`);
}

/**
 * একটি একক টার্মের সম্পূর্ণ ৫-সেকশন ডিটেইল একটি "স্টাডি শিট" PDF হিসেবে এক্সপোর্ট করে।
 */
export async function exportTermToPdf(term) {
  const { jsPDF } = await import("jspdf");
  const accent = SUBJECT_ACCENT_HEX[term.subject] || "#f59e0b";
  const meta = SUBJECT_META[term.subject];
  const impHex = IMPORTANCE_HEX[term.importance] || IMPORTANCE_HEX.medium;
  const tags = (term.tags || []).map((t) => `<span class="ed-tag">#${escapeHtml(t)}</span>`).join("");

  const html = `
    <div class="ed-pdf">
      <div class="ed-term-row" style="margin-bottom:2px">
        <span class="ed-badge" style="background:${accent}">${meta?.emoji || ""} ${escapeHtml(meta?.bn || term.subject)}</span>
        <span class="ed-badge" style="background:${impHex}">${IMPORTANCE_BN[term.importance] || ""}</span>
        <span class="ed-badge" style="background:#6b7280">${escapeHtml(term.letter)}</span>
      </div>
      <h1 style="font-size:26px;margin-top:10px">${escapeHtml(term.term)}</h1>
      <div class="ed-sub" style="font-weight:600;color:${accent};font-size:12.5px">${escapeHtml(term.short)}</div>
      <div class="ed-rule"></div>

      <div class="ed-label">📖 সংজ্ঞা</div>
      <div class="ed-section">${escapeHtml(term.definition)}</div>

      <div class="ed-label">🎯 অ্যানালজি</div>
      <div class="ed-section">${escapeHtml(term.analogy)}</div>

      <div class="ed-label">💡 ব্যবহার ক্ষেত্র</div>
      <div class="ed-section">${escapeHtml(term.useCase)}</div>

      <div class="ed-label">💬 বাস্তব উদাহরণ</div>
      <div class="ed-section">${escapeHtml(term.example)}</div>

      <div class="ed-label">🧮 সূত্র ও চলকের সম্পর্ক</div>
      <div class="ed-formula">${escapeHtml(term.relation)}</div>

      <div class="ed-label">🌍 রিয়েল-লাইফ অ্যাপ্লিকেশন</div>
      <div class="ed-section">${escapeHtml(term.application)}</div>

      <div style="margin-top:12px">${tags}</div>

      ${term.book ? `<div class="ed-footer" style="text-align:left;margin-top:18px">📘 রেফারেন্স বই: ${escapeHtml(term.book)}</div>` : ""}
      <div class="ed-footer">ElectroDict — ৮০/২০ নীতিতে EEE অভিধান</div>
    </div>
  `;

  const pdf = new jsPDF({ unit: "px", format: [PAGE_W, PAGE_H] });
  const node = createPrintNode(html);
  await nodeToPdfPages(node, pdf, true);
  const safeName = term.term.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
  pdf.save(`electrodict-${safeName || "term"}.pdf`);
}
