import React, { useState, useEffect } from "react";
import { IMPORTANCE_COLORS, SUBJECT_GRADIENTS, SUBJECT_META, TAB_LIST } from "./constants";
import Icon from "./icons";
import { exportTermToPdf } from "../lib/pdfExport";

export default function TermModal({ term, isFav, onFav, onClose, activeTab, setActiveTab }) {
  const [copied, setCopied] = useState(false);
  const [exportingPdf, setExportingPdf] = useState(false);
  const importance = IMPORTANCE_COLORS[term.importance] || IMPORTANCE_COLORS.medium;
  const grad = SUBJECT_GRADIENTS[term.subject] || "from-gray-500 to-gray-600";
  const subjectMeta = SUBJECT_META[term.subject];

  // Close on Escape key
  useEffect(() => {
    const handler = (e) => { if (e.key === "Escape") onClose(); };
    document.addEventListener("keydown", handler);
    return () => document.removeEventListener("keydown", handler);
  }, [onClose]);

  // Prevent body scroll when modal open
  useEffect(() => {
    document.body.style.overflow = "hidden";
    return () => { document.body.style.overflow = ""; };
  }, []);

  const copyRelation = () => {
    navigator.clipboard.writeText(term.relation || "").then(() => {
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    });
  };

  const handleExportPdf = async () => {
    if (exportingPdf) return;
    setExportingPdf(true);
    try {
      await exportTermToPdf(term);
    } catch (e) {
      console.error("PDF export failed:", e);
    } finally {
      setExportingPdf(false);
    }
  };

  const importanceWidth = { critical: "100%", high: "75%", medium: "50%", low: "25%" };

  return (
    <div className="fixed inset-0 z-[100] flex items-end sm:items-center justify-center p-0 sm:p-4">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/75 backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Modal panel */}
      <div className="relative w-full sm:max-w-2xl max-h-[92vh] overflow-y-auto bg-gray-900 border border-gray-700/80 rounded-t-3xl sm:rounded-2xl shadow-2xl shadow-black/50 flex flex-col">

        {/* ── HERO HEADER ── */}
        <div className={`relative bg-gradient-to-br ${grad} p-5 flex-shrink-0 rounded-t-3xl sm:rounded-t-2xl overflow-hidden`}>
          {/* Decorative icon watermark */}
          <div className="absolute -right-4 -bottom-6 opacity-15 pointer-events-none">
            <Icon name={term.icon} className="w-40 h-40 text-white" />
          </div>
          <div className="absolute inset-0 opacity-10" style={{
            backgroundImage: "radial-gradient(circle, #fff 1px, transparent 1px)",
            backgroundSize: "16px 16px",
          }} />

          <div className="relative">
            {/* Badges row */}
            <div className="flex items-center gap-2 mb-2 flex-wrap">
              <span className="text-xs px-2.5 py-1 rounded-full bg-black/30 text-white/90 font-medium backdrop-blur">
                {subjectMeta?.emoji} {subjectMeta?.bn}
              </span>
              <span className={`text-xs px-2.5 py-1 rounded-full bg-black/30 font-semibold backdrop-blur ${importance.text}`}>
                ● {importance.label}
              </span>
              <span className="text-xs px-2.5 py-1 rounded-full bg-black/30 text-white/70 backdrop-blur font-mono">
                {term.letter}
              </span>
            </div>

            {/* Title */}
            <div className="flex items-start justify-between gap-3">
              <div>
                <h2 className="text-2xl sm:text-3xl font-extrabold text-white leading-tight">{term.term}</h2>
                <p className="text-white/75 text-sm mt-1 font-medium">{term.short}</p>
              </div>
              <div className="flex gap-2 flex-shrink-0">
                <button
                  onClick={handleExportPdf}
                  disabled={exportingPdf}
                  title="PDF এক্সপোর্ট"
                  className="w-10 h-10 rounded-xl bg-black/25 backdrop-blur flex items-center justify-center text-white/70 hover:text-white transition disabled:opacity-50"
                >
                  {exportingPdf ? (
                    <span className="w-4 h-4 border-2 border-white/40 border-t-white rounded-full animate-spin" />
                  ) : (
                    <span className="text-lg">📄</span>
                  )}
                </button>
                <button
                  onClick={onFav}
                  className={`w-10 h-10 rounded-xl bg-black/25 backdrop-blur flex items-center justify-center text-xl transition-transform hover:scale-110 ${isFav ? "text-yellow-400" : "text-white/60 hover:text-yellow-400"}`}
                >
                  {isFav ? "★" : "☆"}
                </button>
                <button
                  onClick={onClose}
                  className="w-10 h-10 rounded-xl bg-black/25 backdrop-blur flex items-center justify-center text-white/80 hover:text-white transition text-lg"
                >
                  ✕
                </button>
              </div>
            </div>

            {/* Tags */}
            <div className="flex flex-wrap gap-1.5 mt-3">
              {term.tags?.map((tag) => (
                <span key={tag} className="text-[11px] px-2 py-0.5 bg-black/25 text-white/80 rounded-full backdrop-blur">
                  #{tag}
                </span>
              ))}
            </div>
          </div>
        </div>

        {/* ── TAB NAV ── */}
        <div className="flex border-b border-gray-800 overflow-x-auto scrollbar-hide flex-shrink-0 bg-gray-900">
          {TAB_LIST.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-shrink-0 px-5 py-3.5 text-sm font-semibold transition-all whitespace-nowrap ${
                activeTab === tab.id
                  ? "text-amber-400 border-b-2 border-amber-400 bg-amber-500/5"
                  : "text-gray-500 hover:text-gray-300 hover:bg-gray-800/50"
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        {/* ── TAB CONTENT ── */}
        <div className="p-5 overflow-y-auto flex-1">

          {/* DEFINITION TAB */}
          {activeTab === "definition" && (
            <div className="space-y-4">
              <div className="bg-gray-800/60 rounded-2xl p-4 border border-gray-700/60">
                <h4 className="text-xs font-bold text-amber-400 uppercase tracking-widest mb-3">📖 সংজ্ঞা</h4>
                <p className="text-gray-200 leading-relaxed text-sm">{term.definition}</p>
              </div>

              {/* Importance meter */}
              <div className={`rounded-2xl p-4 border ${importance.border} ${importance.bg}`}>
                <h4 className={`text-xs font-bold ${importance.text} uppercase tracking-widest mb-3`}>🎯 গুরুত্বের মাত্রা (৮০/২০)</h4>
                <div className="flex items-center gap-3">
                  <div className="flex-1 bg-gray-800 rounded-full h-2.5 overflow-hidden">
                    <div
                      className={`h-full rounded-full ${importance.dot} transition-all duration-700`}
                      style={{ width: importanceWidth[term.importance] || "50%" }}
                    />
                  </div>
                  <span className={`text-sm font-bold ${importance.text} min-w-[80px] text-right`}>
                    {importance.label}
                  </span>
                </div>
              </div>

              {/* Book reference */}
              {term.book && (
                <div className="bg-gray-800/40 rounded-2xl p-3.5 border border-gray-700/40 flex items-center gap-2.5">
                  <span className="text-lg">📘</span>
                  <p className="text-xs text-gray-400">
                    <span className="text-gray-500">রেফারেন্স বই: </span>
                    <span className="text-gray-300 font-medium">{term.book}</span>
                  </p>
                </div>
              )}
            </div>
          )}

          {/* ANALOGY TAB */}
          {activeTab === "analogy" && (
            <div className="space-y-4">
              <div className="bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-2xl p-5 border border-purple-500/25">
                <div className="flex justify-center mb-4">
                  <Icon name={term.icon} className="w-14 h-14 text-purple-300" />
                </div>
                <h4 className="text-sm font-bold text-purple-400 mb-3 text-center">সহজ অ্যানালজি দিয়ে বুঝুন</h4>
                <p className="text-gray-200 text-base leading-relaxed text-center">{term.analogy}</p>
              </div>

              <div className="bg-gray-800/40 rounded-2xl p-4 border border-gray-700/40">
                <h4 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">📝 কেন এই অ্যানালজি?</h4>
                <p className="text-gray-400 text-xs leading-relaxed">
                  এই উপমাটি <span className="text-white font-semibold">{term.term}</span>-এর মূল ধারণাকে
                  দৈনন্দিন জীবনের সাথে তুলনা করে সহজে বোধগম্য করে তোলে।
                  ইঞ্জিনিয়ারিং-এর জটিল কনসেপ্ট বাস্তব জীবনের উদাহরণে বোঝা অনেক সহজ।
                </p>
              </div>
            </div>
          )}

          {/* USE CASE TAB */}
          {activeTab === "usecase" && (
            <div className="space-y-4">
              <div className="bg-yellow-500/8 rounded-2xl p-4 border border-yellow-500/25">
                <h4 className="text-xs font-bold text-yellow-400 uppercase tracking-widest mb-3">⚙️ ব্যবহার ক্ষেত্র</h4>
                <p className="text-gray-300 text-sm leading-relaxed">{term.useCase}</p>
              </div>

              <div className="bg-cyan-500/8 rounded-2xl p-4 border border-cyan-500/20">
                <h4 className="text-xs font-bold text-cyan-400 uppercase tracking-widest mb-3">💬 বাস্তব উদাহরণ</h4>
                <p className="text-gray-300 text-sm leading-relaxed">{term.example}</p>
              </div>

              {/* Subject info */}
              <div className="bg-gray-800/40 rounded-2xl p-4 border border-gray-700/40">
                <h4 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-3">
                  🏷️ বিষয়: {subjectMeta?.bn}
                </h4>
                <div className="flex flex-wrap gap-2">
                  {term.tags?.map((tag) => (
                    <span key={tag} className="text-xs px-3 py-1 bg-gray-800 text-gray-300 rounded-lg border border-gray-700">
                      #{tag}
                    </span>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* RELATION / FORMULA TAB */}
          {activeTab === "relation" && (
            <div className="space-y-3">
              {/* Header */}
              <div className="flex items-center justify-between">
                <h4 className="text-xs font-bold text-amber-400 uppercase tracking-widest">
                  🧮 সূত্র ও চলকের সম্পর্ক
                </h4>
                <button
                  onClick={copyRelation}
                  className={`flex items-center gap-1.5 text-xs px-3 py-1.5 rounded-lg border transition ${
                    copied
                      ? "bg-green-500/30 text-green-300 border-green-500/50"
                      : "bg-gray-800 text-gray-400 border-gray-700 hover:bg-gray-700 hover:text-white"
                  }`}
                >
                  {copied ? "✅ Copied!" : "📋 কপি করুন"}
                </button>
              </div>

              {/* Formula block */}
              <div className="bg-gray-950 rounded-2xl border border-gray-800 overflow-hidden">
                {/* Traffic lights */}
                <div className="flex items-center gap-2 px-4 py-2.5 border-b border-gray-800 bg-gray-900/80">
                  <div className="flex gap-1.5">
                    <div className="w-3 h-3 rounded-full bg-red-500/80" />
                    <div className="w-3 h-3 rounded-full bg-yellow-500/80" />
                    <div className="w-3 h-3 rounded-full bg-green-500/80" />
                  </div>
                  <span className="text-xs text-gray-500 font-mono ml-1">
                    {term.term.toLowerCase().replace(/\s+/g, "_")}.formula
                  </span>
                </div>

                {/* Relation text */}
                <pre className="p-4 text-xs sm:text-sm text-amber-300 overflow-x-auto leading-relaxed font-mono whitespace-pre-wrap scrollbar-hide">
                  {term.relation}
                </pre>
              </div>

              <p className="text-[11px] text-gray-600 text-center">
                সূত্রগুলো শিক্ষামূলক উদ্দেশ্যে সরলীকৃত। নির্ভুল ডেরিভেশনের জন্য রেফারেন্স বই দেখুন।
              </p>
            </div>
          )}

          {/* APPLICATION TAB */}
          {activeTab === "application" && (
            <div className="space-y-4">
              <div className="bg-gradient-to-br from-emerald-500/10 to-teal-500/10 rounded-2xl p-5 border border-emerald-500/25">
                <h4 className="text-sm font-bold text-emerald-400 mb-3">🌍 রিয়েল-লাইফ অ্যাপ্লিকেশন</h4>
                <p className="text-gray-200 text-sm leading-relaxed">{term.application}</p>
              </div>

              {term.book && (
                <div className="bg-gray-800/40 rounded-2xl p-3.5 border border-gray-700/40 flex items-center gap-2.5">
                  <span className="text-lg">📘</span>
                  <p className="text-xs text-gray-400">
                    <span className="text-gray-500">আরও পড়ুন: </span>
                    <span className="text-gray-300 font-medium">{term.book}</span>
                  </p>
                </div>
              )}
            </div>
          )}
        </div>

        {/* ── BOTTOM NAV (mobile friendly) ── */}
        <div className="flex border-t border-gray-800 flex-shrink-0 bg-gray-900 rounded-b-3xl sm:rounded-b-2xl">
          {TAB_LIST.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`flex-1 py-3 text-xs font-semibold transition ${
                activeTab === tab.id ? "text-amber-400" : "text-gray-600 hover:text-gray-400"
              }`}
            >
              {tab.label.split(" ")[0]}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
