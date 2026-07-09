import React from "react";
import { IMPORTANCE_COLORS, SUBJECT_GRADIENTS, SUBJECT_META } from "./constants";
import Icon from "./icons";

export default function TermCard({ term, isFav, compact, onSelect, onFav }) {
  const importance = IMPORTANCE_COLORS[term.importance] || IMPORTANCE_COLORS.medium;
  const grad = SUBJECT_GRADIENTS[term.subject] || "from-gray-500 to-gray-600";
  const subjectBn = SUBJECT_META[term.subject]?.bn || term.subject;

  if (compact) {
    return (
      <div
        onClick={onSelect}
        className="flex items-center gap-3 bg-gray-900/80 border border-gray-800 rounded-2xl px-4 py-3 cursor-pointer hover:border-amber-500/40 hover:bg-gray-900 transition-all group"
      >
        {/* Letter badge */}
        <div className={`w-10 h-10 rounded-xl bg-gradient-to-br ${grad} flex items-center justify-center font-extrabold text-white text-base flex-shrink-0 shadow-md`}>
          {term.letter}
        </div>

        {/* Info */}
        <div className="flex-1 min-w-0">
          <div className="font-bold text-white truncate text-sm">{term.term}</div>
          <div className="text-xs text-amber-400 truncate">{term.short}</div>
        </div>

        {/* Right side */}
        <div className="flex items-center gap-2 flex-shrink-0">
          <span className={`hidden sm:inline text-xs px-2 py-0.5 rounded-full border ${importance.bg} ${importance.text} ${importance.border}`}>
            {importance.label}
          </span>
          <span className={`inline-block w-2 h-2 rounded-full sm:hidden ${importance.dot}`} />
          <button
            onClick={(e) => { e.stopPropagation(); onFav(); }}
            className={`text-lg transition-transform hover:scale-125 ${isFav ? "text-yellow-400" : "text-gray-700 hover:text-yellow-400"}`}
          >
            {isFav ? "★" : "☆"}
          </button>
        </div>
      </div>
    );
  }

  // Grid card
  return (
    <div
      onClick={onSelect}
      className="relative group bg-gray-900/80 border border-gray-800 rounded-2xl overflow-hidden cursor-pointer hover:border-amber-500/50 hover:shadow-xl hover:shadow-amber-500/10 hover:-translate-y-0.5 transition-all duration-200"
    >
      {/* Top gradient bar */}
      <div className={`h-1 w-full bg-gradient-to-r ${grad}`} />

      {/* Icon header */}
      <div className={`relative h-24 overflow-hidden bg-gradient-to-br ${grad} flex items-center justify-center`}>
        <div className="absolute inset-0 opacity-10" style={{
          backgroundImage: "radial-gradient(circle, #fff 1px, transparent 1px)",
          backgroundSize: "14px 14px",
        }} />
        <Icon name={term.icon} className="w-12 h-12 text-white/90 relative z-10 group-hover:scale-110 transition-transform duration-300" />

        {/* Overlaid importance badge */}
        <div className="absolute top-2 right-2">
          <span className={`flex items-center gap-1 text-[10px] px-2 py-0.5 rounded-full border font-semibold backdrop-blur ${importance.bg} ${importance.text} ${importance.border}`}>
            <span className={`w-1.5 h-1.5 rounded-full ${importance.dot}`} />
            {importance.label}
          </span>
        </div>
      </div>

      <div className="p-4">
        {/* Header */}
        <div className="flex items-start justify-between gap-2 mb-2">
          <div className="flex items-center gap-2">
            <div className={`w-8 h-8 rounded-lg bg-gradient-to-br ${grad} flex items-center justify-center font-extrabold text-white text-sm shadow`}>
              {term.letter}
            </div>
            <span className="text-[10px] text-gray-500 bg-gray-800 px-2 py-0.5 rounded-full border border-gray-700">
              {subjectBn}
            </span>
          </div>
          <button
            onClick={(e) => { e.stopPropagation(); onFav(); }}
            className={`text-xl flex-shrink-0 transition-transform hover:scale-125 ${isFav ? "text-yellow-400" : "text-gray-700 group-hover:text-gray-500"}`}
          >
            {isFav ? "★" : "☆"}
          </button>
        </div>

        {/* Term name */}
        <h3 className="font-extrabold text-white text-base leading-tight">{term.term}</h3>
        <p className="text-xs text-amber-400 font-medium mt-0.5 mb-2">{term.short}</p>

        {/* Analogy */}
        <p className="text-xs text-gray-400 leading-relaxed line-clamp-2">{term.analogy}</p>

        {/* Tags */}
        <div className="flex flex-wrap gap-1 mt-3">
          {term.tags?.slice(0, 3).map((tag) => (
            <span key={tag} className="text-[10px] px-2 py-0.5 bg-gray-800 text-gray-400 rounded-full border border-gray-700/60">
              #{tag}
            </span>
          ))}
          {(term.tags?.length || 0) > 3 && (
            <span className="text-[10px] px-2 py-0.5 bg-gray-800 text-gray-500 rounded-full">
              +{term.tags.length - 3}
            </span>
          )}
        </div>

        {/* Footer */}
        <div className="mt-3 pt-3 border-t border-gray-800/60 flex items-center justify-between">
          <div className={`flex items-center gap-1 text-[10px] px-2 py-0.5 rounded-full border ${importance.bg} ${importance.text} ${importance.border}`}>
            <span className={`w-1.5 h-1.5 rounded-full ${importance.dot}`} />
            {importance.label}
          </div>
          <span className="text-xs text-amber-400 opacity-0 group-hover:opacity-100 group-hover:translate-x-1 transition-all duration-200">
            বিস্তারিত →
          </span>
        </div>
      </div>
    </div>
  );
}
