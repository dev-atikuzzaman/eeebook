import React, { useState, useMemo, useCallback } from "react";
import { SUBJECT_META, SUBJECT_ORDER, SUBJECT_GRADIENTS } from "./constants";

const SIZE_OPTIONS = [10, 20, 30];

function shuffle(arr) {
  const a = [...arr];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

function buildQuestions(pool, allTerms, count) {
  const targets = shuffle(pool).slice(0, Math.min(count, pool.length));
  return targets.map((term) => {
    const type = Math.random() < 0.5 ? "term-from-def" : "def-from-term";
    // একই বিষয় থেকে distractor বাছাই — সম্ভব হলে (আরও কঠিন ও অর্থবহ প্রশ্ন)
    const sameSubjectPool = allTerms.filter((t) => t.subject === term.subject && t.id !== term.id);
    const otherPool = allTerms.filter((t) => t.id !== term.id);
    const distractorSource = sameSubjectPool.length >= 3 ? sameSubjectPool : otherPool;
    const distractors = shuffle(distractorSource).slice(0, 3);
    const options = shuffle([term, ...distractors]);
    return { term, type, options };
  });
}

export default function QuizMode({ terms, onClose, onViewTerm }) {
  const [stage, setStage] = useState("setup"); // setup | playing | results
  const [subject, setSubject] = useState("ALL");
  const [size, setSize] = useState(10);
  const [questions, setQuestions] = useState([]);
  const [qIndex, setQIndex] = useState(0);
  const [selected, setSelected] = useState(null);
  const [answers, setAnswers] = useState([]); // { question, chosen, correct }
  const [bestScore, setBestScore] = useState(() => {
    try { return Number(localStorage.getItem("eeeQuizBest") || 0); } catch { return 0; }
  });

  const pool = useMemo(
    () => (subject === "ALL" ? terms : terms.filter((t) => t.subject === subject)),
    [terms, subject]
  );

  const startQuiz = useCallback(() => {
    const qs = buildQuestions(pool, terms, size);
    setQuestions(qs);
    setQIndex(0);
    setSelected(null);
    setAnswers([]);
    setStage("playing");
  }, [pool, terms, size]);

  const currentQ = questions[qIndex];
  const score = answers.filter((a) => a.correct).length;

  const chooseOption = (opt) => {
    if (selected) return; // একবার উত্তর দিলে লক
    const correct = opt.id === currentQ.term.id;
    setSelected(opt.id);
    setAnswers((prev) => [...prev, { question: currentQ, chosenId: opt.id, correct }]);
  };

  const nextQuestion = () => {
    if (qIndex + 1 >= questions.length) {
      const finalScore = answers.filter((a) => a.correct).length;
      const finalPct = Math.round((finalScore / questions.length) * 100);
      if (finalPct > bestScore) {
        setBestScore(finalPct);
        try { localStorage.setItem("eeeQuizBest", String(finalPct)); } catch {}
      }
      setStage("results");
    } else {
      setQIndex((i) => i + 1);
      setSelected(null);
    }
  };

  const restart = () => setStage("setup");

  return (
    <div className="fixed inset-0 z-[110] flex items-end sm:items-center justify-center p-0 sm:p-4">
      <div className="absolute inset-0 bg-black/80 backdrop-blur-sm" onClick={onClose} />
      <div className="relative w-full sm:max-w-xl max-h-[92vh] overflow-y-auto bg-gray-900 border border-gray-700/80 rounded-t-3xl sm:rounded-2xl shadow-2xl flex flex-col">

        {/* ── SETUP ── */}
        {stage === "setup" && (
          <div className="p-6">
            <div className="flex items-start justify-between mb-1">
              <div>
                <h2 className="text-2xl font-extrabold bg-gradient-to-r from-amber-400 via-orange-400 to-yellow-400 bg-clip-text text-transparent">
                  🧠 কুইজ মোড
                </h2>
                <p className="text-xs text-gray-500 mt-1">নিজের EEE জ্ঞান যাচাই করুন — ৮০/২০ নীতির গুরুত্বপূর্ণ টার্ম দিয়ে</p>
              </div>
              <button onClick={onClose} className="w-9 h-9 rounded-xl bg-gray-800 text-gray-400 hover:text-white flex items-center justify-center flex-shrink-0">✕</button>
            </div>

            {bestScore > 0 && (
              <div className="mt-3 inline-flex items-center gap-2 text-xs px-3 py-1.5 rounded-full bg-yellow-500/10 border border-yellow-500/30 text-yellow-400">
                🏆 সর্বোচ্চ স্কোর: {bestScore}%
              </div>
            )}

            <div className="mt-6">
              <h3 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">বিষয় বেছে নিন</h3>
              <div className="flex flex-wrap gap-2">
                <button
                  onClick={() => setSubject("ALL")}
                  className={`px-3 py-1.5 rounded-xl text-xs font-bold transition ${
                    subject === "ALL" ? "bg-amber-500 text-gray-950" : "bg-gray-800 text-gray-400 border border-gray-700"
                  }`}
                >
                  সব বিষয় ({terms.length})
                </button>
                {SUBJECT_ORDER.map((id) => {
                  const meta = SUBJECT_META[id];
                  const cnt = terms.filter((t) => t.subject === id).length;
                  const active = subject === id;
                  return (
                    <button
                      key={id}
                      onClick={() => setSubject(id)}
                      className={`px-3 py-1.5 rounded-xl text-xs font-bold transition whitespace-nowrap ${
                        active ? `bg-gradient-to-r ${meta.gradient} text-white` : "bg-gray-800 text-gray-400 border border-gray-700"
                      }`}
                    >
                      {meta.emoji} {meta.bn} ({cnt})
                    </button>
                  );
                })}
              </div>
            </div>

            <div className="mt-6">
              <h3 className="text-xs font-bold text-gray-400 uppercase tracking-widest mb-2">প্রশ্ন সংখ্যা</h3>
              <div className="flex gap-2">
                {SIZE_OPTIONS.map((n) => (
                  <button
                    key={n}
                    onClick={() => setSize(n)}
                    className={`flex-1 py-2.5 rounded-xl text-sm font-bold transition ${
                      size === n ? "bg-amber-500 text-gray-950" : "bg-gray-800 text-gray-400 border border-gray-700"
                    }`}
                  >
                    {n}টি
                  </button>
                ))}
              </div>
              {pool.length < size && (
                <p className="text-[11px] text-gray-500 mt-2">
                  এই বিষয়ে মাত্র {pool.length}টি টার্ম আছে — কুইজে {pool.length}টি প্রশ্ন থাকবে।
                </p>
              )}
            </div>

            <button
              onClick={startQuiz}
              disabled={pool.length === 0}
              className="w-full mt-7 py-3.5 rounded-2xl bg-gradient-to-r from-amber-400 via-orange-400 to-yellow-400 text-gray-950 font-extrabold text-sm shadow-lg shadow-amber-500/20 hover:brightness-110 transition disabled:opacity-40"
            >
              🚀 কুইজ শুরু করুন
            </button>
          </div>
        )}

        {/* ── PLAYING ── */}
        {stage === "playing" && currentQ && (
          <div className="p-5 flex flex-col">
            {/* Progress */}
            <div className="flex items-center justify-between mb-3">
              <span className="text-xs font-bold text-gray-400">প্রশ্ন {qIndex + 1} / {questions.length}</span>
              <span className="text-xs font-bold text-amber-400">স্কোর: {score}</span>
            </div>
            <div className="w-full h-1.5 bg-gray-800 rounded-full overflow-hidden mb-5">
              <div
                className="h-full bg-gradient-to-r from-amber-400 to-orange-500 transition-all duration-300"
                style={{ width: `${((qIndex + (selected ? 1 : 0)) / questions.length) * 100}%` }}
              />
            </div>

            {/* Question */}
            <div className="bg-gray-800/60 rounded-2xl p-4 border border-gray-700/60 mb-4">
              <span className={`text-[10px] font-bold uppercase tracking-widest bg-gradient-to-r ${SUBJECT_GRADIENTS[currentQ.term.subject]} bg-clip-text text-transparent`}>
                {SUBJECT_META[currentQ.term.subject]?.bn}
              </span>
              {currentQ.type === "term-from-def" ? (
                <>
                  <p className="text-[11px] text-gray-500 mt-2 mb-1">এই সংজ্ঞাটি কোন টার্মের?</p>
                  <p className="text-gray-100 text-sm leading-relaxed font-medium">{currentQ.term.short}</p>
                </>
              ) : (
                <>
                  <p className="text-[11px] text-gray-500 mt-2 mb-1">এই টার্মের সঠিক সংজ্ঞা কোনটি?</p>
                  <p className="text-white text-xl font-extrabold">{currentQ.term.term}</p>
                </>
              )}
            </div>

            {/* Options */}
            <div className="space-y-2.5">
              {currentQ.options.map((opt) => {
                const isCorrect = opt.id === currentQ.term.id;
                const isChosen = selected === opt.id;
                let style = "bg-gray-800 border-gray-700 text-gray-200 hover:border-amber-500/40";
                if (selected) {
                  if (isCorrect) style = "bg-green-500/15 border-green-500/60 text-green-300";
                  else if (isChosen) style = "bg-red-500/15 border-red-500/60 text-red-300";
                  else style = "bg-gray-800/50 border-gray-800 text-gray-500";
                }
                return (
                  <button
                    key={opt.id}
                    onClick={() => chooseOption(opt)}
                    className={`w-full text-left px-4 py-3 rounded-xl border text-sm font-medium transition ${style}`}
                  >
                    {currentQ.type === "term-from-def" ? opt.term : opt.short}
                    {selected && isCorrect && <span className="float-right">✅</span>}
                    {selected && isChosen && !isCorrect && <span className="float-right">❌</span>}
                  </button>
                );
              })}
            </div>

            {selected && (
              <button
                onClick={nextQuestion}
                className="w-full mt-5 py-3 rounded-2xl bg-gradient-to-r from-amber-400 via-orange-400 to-yellow-400 text-gray-950 font-extrabold text-sm shadow-lg hover:brightness-110 transition"
              >
                {qIndex + 1 >= questions.length ? "ফলাফল দেখুন →" : "পরবর্তী প্রশ্ন →"}
              </button>
            )}
          </div>
        )}

        {/* ── RESULTS ── */}
        {stage === "results" && (
          <div className="p-6">
            <div className="text-center">
              <div className="text-5xl mb-2">
                {score / questions.length >= 0.9 ? "🏆" : score / questions.length >= 0.7 ? "🎉" : score / questions.length >= 0.5 ? "📘" : "💪"}
              </div>
              <h2 className="text-3xl font-extrabold text-white">{score} / {questions.length}</h2>
              <p className="text-amber-400 font-bold text-sm mt-1">{Math.round((score / questions.length) * 100)}% সঠিক</p>
              <p className="text-gray-400 text-xs mt-2">
                {score / questions.length >= 0.9 ? "চমৎকার! আপনি এই বিষয়ে দক্ষ।" :
                 score / questions.length >= 0.7 ? "ভালো করেছেন! আরেকটু ঝালিয়ে নিলেই পারফেক্ট।" :
                 score / questions.length >= 0.5 ? "মোটামুটি — সংজ্ঞাগুলো আবার পড়ে নিন।" :
                 "আরও অনুশীলন দরকার — সংজ্ঞা ও অ্যানালজি ট্যাব থেকে রিভিশন দিন।"}
              </p>
            </div>

            {/* Review list */}
            <div className="mt-6 space-y-2 max-h-64 overflow-y-auto scrollbar-hide">
              {answers.map((a, i) => (
                <button
                  key={i}
                  onClick={() => onViewTerm(a.question.term.id)}
                  className={`w-full text-left flex items-center gap-2 px-3 py-2.5 rounded-xl border text-xs transition ${
                    a.correct ? "bg-green-500/8 border-green-500/25" : "bg-red-500/8 border-red-500/25"
                  }`}
                >
                  <span>{a.correct ? "✅" : "❌"}</span>
                  <span className="flex-1 text-gray-300 truncate">{a.question.term.term}</span>
                  <span className="text-gray-600">বিস্তারিত →</span>
                </button>
              ))}
            </div>

            <div className="flex gap-2 mt-6">
              <button onClick={startQuiz} className="flex-1 py-3 rounded-2xl bg-gray-800 text-gray-200 font-bold text-sm border border-gray-700 hover:bg-gray-700 transition">
                🔁 আবার খেলুন
              </button>
              <button onClick={restart} className="flex-1 py-3 rounded-2xl bg-gradient-to-r from-amber-400 via-orange-400 to-yellow-400 text-gray-950 font-extrabold text-sm hover:brightness-110 transition">
                ⚙️ নতুন কুইজ
              </button>
            </div>
            <button onClick={onClose} className="w-full mt-2 py-2.5 text-xs text-gray-500 hover:text-gray-300 transition">
              বন্ধ করুন
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
