// গুরুত্বের (Importance) রঙ — Critical→Low, ৮০/২০ নীতিতে কতটা must-know তা নির্দেশ করে
export const IMPORTANCE_COLORS = {
  critical: { bg: "bg-red-500/20",    text: "text-red-400",    border: "border-red-500/40",    dot: "bg-red-400",    label: "অপরিহার্য" },
  high:     { bg: "bg-orange-500/20", text: "text-orange-400", border: "border-orange-500/40", dot: "bg-orange-400", label: "গুরুত্বপূর্ণ" },
  medium:   { bg: "bg-yellow-500/20", text: "text-yellow-400", border: "border-yellow-500/40", dot: "bg-yellow-400", label: "মাঝারি" },
  low:      { bg: "bg-green-500/20",  text: "text-green-400",  border: "border-green-500/40",  dot: "bg-green-400",  label: "সহায়ক" },
};

// প্রতিটি বিষয়ের (subject) মেটাডেটা ও সিগনেচার গ্রেডিয়েন্ট
export const SUBJECT_META = {
  circuit:           { name: "Electrical Circuit",     bn: "ইলেকট্রিক্যাল সার্কিট",     book: "Sadiku — Fundamentals of Electric Circuits",        gradient: "from-amber-400 to-orange-600",   emoji: "⚡"  },
  electronics:       { name: "Electronics Circuit",     bn: "ইলেকট্রনিক্স সার্কিট",       book: "Sedra & Smith — Microelectronic Circuits",          gradient: "from-blue-500 to-indigo-600",    emoji: "🔌" },
  power:             { name: "Power System",            bn: "পাওয়ার সিস্টেম",             book: "Stevenson & Sadat — Power System Analysis",         gradient: "from-red-500 to-rose-700",       emoji: "🏭" },
  machines:          { name: "Electrical Machines",      bn: "ইলেকট্রিক্যাল মেশিন",        book: "Chapman / Hubert / Wildi — Electric Machinery",     gradient: "from-emerald-500 to-teal-700",   emoji: "⚙️" },
  communication:     { name: "Communication System",     bn: "কমিউনিকেশন সিস্টেম",         book: "Lathi / Haykin / Sanjay Sharma",                    gradient: "from-fuchsia-500 to-purple-700", emoji: "📡" },
  control:           { name: "Control System",           bn: "কন্ট্রোল সিস্টেম",           book: "Nise — Control Systems Engineering",                gradient: "from-cyan-500 to-sky-700",       emoji: "🎛️" },
  digital:           { name: "Digital Electronics",      bn: "ডিজিটাল ইলেকট্রনিক্স",       book: "Mano — Digital Design",                             gradient: "from-lime-500 to-green-700",     emoji: "🔢" },
  powerElectronics:  { name: "Power Electronics",        bn: "পাওয়ার ইলেকট্রনিক্স",        book: "Rashid — Power Electronics",                        gradient: "from-rose-500 to-pink-700",      emoji: "🔋" },
  signals:           { name: "Signals & Systems",        bn: "সিগন্যাল ও সিস্টেম",         book: "Oppenheim & Willsky / Proakis",                     gradient: "from-violet-500 to-indigo-800",  emoji: "〰️" },
  electromagnetic:   { name: "Electromagnetic Theory",   bn: "তড়িৎ-চুম্বকীয় তত্ত্ব",      book: "Hayt — Engineering Electromagnetics",               gradient: "from-teal-400 to-cyan-800",      emoji: "🧲" },
};

// শুধু গ্রেডিয়েন্ট লুকআপ (কার্ড/মোডালে দ্রুত ব্যবহারের জন্য)
export const SUBJECT_GRADIENTS = Object.fromEntries(
  Object.entries(SUBJECT_META).map(([id, m]) => [id, m.gradient])
);

// Header-এর subject filter চিপ-এ প্রদর্শনের ক্রম
export const SUBJECT_ORDER = [
  "circuit", "electronics", "power", "machines", "communication",
  "control", "digital", "powerElectronics", "signals", "electromagnetic",
];

// মোডালের ৫টি ট্যাব — সংজ্ঞা, অ্যানালজি, ব্যবহার, সূত্র, প্রয়োগ
export const TAB_LIST = [
  { id: "definition", label: "📖 সংজ্ঞা"    },
  { id: "analogy",    label: "🎯 অ্যানালজি" },
  { id: "usecase",    label: "💡 ব্যবহার"    },
  { id: "relation",   label: "🧮 সূত্র"      },
  { id: "application",label: "🌍 প্রয়োগ"     },
];
