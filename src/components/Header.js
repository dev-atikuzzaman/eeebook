import React from "react";
import { SUBJECT_META, SUBJECT_ORDER } from "./constants";

export default function Header({
  search, setSearch,
  selectedLetter, setSelectedLetter,
  selectedSubject, setSelectedSubject,
  availableLetters, alphabet,
  subjectCounts,
  view, setView,
  favorites, isOnline, loading,
  onOpenQuiz, onExportPdf, exporting,
}) {
  return (
    <header className="sticky top-0 z-50 border-b border-amber-500/20 bg-gray-950/95 backdrop-blur-xl">
      <div className="max-w-7xl mx-auto px-4 py-3 space-y-3">

        {/* Top row */}
        <div className="flex items-center gap-3">
          {/* Logo */}
          <div className="relative flex-shrink-0">
            <div className="w-11 h-11 rounded-2xl bg-gradient-to-br from-amber-400 via-orange-400 to-red-500 flex items-center justify-center text-2xl shadow-lg shadow-amber-500/30">
              ⚡
            </div>
            {/* Online indicator */}
            <span className={`absolute -top-0.5 -right-0.5 w-3 h-3 rounded-full border-2 border-gray-950 ${isOnline ? "bg-green-400" : "bg-red-400"}`} />
          </div>

          {/* Title */}
          <div className="flex-1 min-w-0">
            <h1 className="text-lg sm:text-xl font-extrabold tracking-tight bg-gradient-to-r from-amber-400 via-orange-400 to-yellow-400 bg-clip-text text-transparent leading-none">
              ElectroDict
            </h1>
            <p className="text-[11px] text-gray-500 mt-0.5 truncate">
              ৮০/২০ নীতিতে A–Z ইলেকট্রিক্যাল ও ইলেকট্রনিক্স অভিধান
              {!isOnline && <span className="ml-2 text-red-400">● Offline</span>}
              {loading  && <span className="ml-2 text-cyan-400 animate-pulse">● Syncing…</span>}
            </p>
          </div>

          {/* Controls */}
          <div className="flex items-center gap-2 flex-shrink-0">
            <button
              onClick={onOpenQuiz}
              title="কুইজ মোড"
              className="w-8 h-8 rounded-lg bg-gray-900 border border-gray-700 text-gray-400 hover:text-purple-400 hover:border-purple-500/50 transition flex items-center justify-center text-sm"
            >
              🧠
            </button>
            <button
              onClick={onExportPdf}
              disabled={exporting}
              title="PDF এক্সপোর্ট"
              className="w-8 h-8 rounded-lg bg-gray-900 border border-gray-700 text-gray-400 hover:text-red-400 hover:border-red-500/50 transition flex items-center justify-center text-sm disabled:opacity-40"
            >
              {exporting ? (
                <span className="w-3.5 h-3.5 border-2 border-gray-500 border-t-red-400 rounded-full animate-spin" />
              ) : (
                "📄"
              )}
            </button>
            <button
              onClick={() => setView((v) => (v === "grid" ? "list" : "grid"))}
              title="Toggle view"
              className="w-8 h-8 rounded-lg bg-gray-900 border border-gray-700 text-gray-400 hover:text-amber-400 hover:border-amber-500/50 transition flex items-center justify-center text-sm"
            >
              {view === "grid" ? "☰" : "⊞"}
            </button>
            <div className="flex items-center gap-1 bg-gray-900 border border-gray-800 rounded-lg px-2 py-1">
              <span className="text-yellow-400 text-sm">⭐</span>
              <span className="text-xs text-gray-400 font-semibold">{favorites.length}</span>
            </div>
          </div>
        </div>

        {/* Search bar */}
        <div className="relative">
          <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-amber-400 text-base pointer-events-none">
            🔍
          </span>
          <input
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="টার্ম, ট্যাগ, বিষয় বা সংজ্ঞা সার্চ করুন…"
            className="w-full pl-10 pr-10 py-2.5 rounded-xl bg-gray-900 border border-gray-700 focus:border-amber-500/70 focus:ring-2 focus:ring-amber-500/20 outline-none text-sm text-white placeholder-gray-500 transition-all"
          />
          {search && (
            <button
              onClick={() => setSearch("")}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-white text-lg leading-none transition"
            >
              ✕
            </button>
          )}
        </div>

        {/* Subject filter row */}
        <div className="flex gap-1.5 overflow-x-auto pb-0.5 scrollbar-hide">
          <button
            onClick={() => setSelectedSubject("ALL")}
            className={`flex-shrink-0 px-3 py-1.5 rounded-xl text-xs font-bold transition ${
              selectedSubject === "ALL"
                ? "bg-amber-500 text-gray-950 shadow-md shadow-amber-500/30"
                : "bg-gray-900 text-gray-400 hover:bg-gray-800 border border-gray-800"
            }`}
          >
            সব বিষয়
          </button>
          {SUBJECT_ORDER.map((id) => {
            const meta = SUBJECT_META[id];
            const isActive = selectedSubject === id;
            const count = subjectCounts[id] || 0;
            return (
              <button
                key={id}
                onClick={() => setSelectedSubject(id)}
                className={`flex-shrink-0 flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition whitespace-nowrap ${
                  isActive
                    ? `bg-gradient-to-r ${meta.gradient} text-white shadow-md`
                    : "bg-gray-900 text-gray-400 hover:bg-gray-800 border border-gray-800"
                }`}
              >
                <span>{meta.emoji}</span>
                <span>{meta.bn}</span>
                <span className={`text-[10px] ${isActive ? "text-white/70" : "text-gray-600"}`}>{count}</span>
              </button>
            );
          })}
        </div>

        {/* A–Z alphabet filter */}
        <div className="flex gap-1 overflow-x-auto pb-0.5 scrollbar-hide">
          {/* ALL button */}
          <button
            onClick={() => setSelectedLetter("ALL")}
            className={`flex-shrink-0 px-3 py-1 rounded-lg text-xs font-bold transition ${
              selectedLetter === "ALL"
                ? "bg-amber-500 text-gray-950 shadow-md shadow-amber-500/30"
                : "bg-gray-900 text-gray-400 hover:bg-gray-800 border border-gray-800"
            }`}
          >
            ALL
          </button>

          {alphabet.map((l) => {
            const hasTerms = availableLetters.has(l);
            const isActive = selectedLetter === l;
            return (
              <button
                key={l}
                onClick={() => hasTerms && setSelectedLetter(l)}
                disabled={!hasTerms}
                className={`flex-shrink-0 w-7 h-7 rounded-lg text-xs font-bold transition ${
                  isActive
                    ? "bg-amber-500 text-gray-950 shadow-md shadow-amber-500/30"
                    : hasTerms
                    ? "bg-gray-900 text-gray-300 hover:bg-gray-800 border border-gray-800 hover:border-amber-500/40"
                    : "bg-gray-900/30 text-gray-700 cursor-not-allowed border border-gray-900"
                }`}
              >
                {l}
              </button>
            );
          })}
        </div>
      </div>
    </header>
  );
}
