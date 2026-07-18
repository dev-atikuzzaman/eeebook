# ⚡ ElectroDict — EEE টেকনিক্যাল ডিকশনারি (PWA)

> ৮০/২০ নীতিতে A–Z ইলেকট্রিক্যাল ও ইলেকট্রনিক্স ইঞ্জিনিয়ারিং শব্দভাণ্ডার | ১০ বিষয়ে ৪০০ টার্ম | Supabase Real-time | PWA

CSHelp (সাইবার সিকিউরিটি ডিকশনারি)-এর একই আর্কিটেকচার ও ডিজাইন লজিক অনুসরণ করে তৈরি, EEE-এর জন্য পুনর্নির্মিত।

## 📚 কভারেজ (১০ বিষয় × ৪০ টার্ম = ৪০০ টার্ম)

| বিষয় | রেফারেন্স বই |
|---|---|
| ⚡ Electrical Circuit | Sadiku — Fundamentals of Electric Circuits |
| 🔌 Electronics Circuit | Sedra & Smith — Microelectronic Circuits |
| 🏭 Power System | Stevenson & Sadat — Power System Analysis |
| ⚙️ Electrical Machines | Chapman / Hubert / Wildi |
| 📡 Communication System | Lathi / Haykin / Sanjay Sharma |
| 🎛️ Control System | Nise — Control Systems Engineering |
| 🔢 Digital Electronics | Mano — Digital Design |
| 🔋 Power Electronics | Rashid — Power Electronics |
| 〰️ Signals & Systems | Oppenheim & Willsky / Proakis |
| 🧲 Electromagnetic Theory | Hayt — Engineering Electromagnetics |

প্রতিটি টার্মে থাকছে: সংজ্ঞা, সহজ বাংলা অ্যানালজি, ব্যবহার ক্ষেত্র (use case), বাস্তব উদাহরণ, সূত্র ও চলকের সম্পর্ক, এবং রিয়েল-লাইফ অ্যাপ্লিকেশন — সম্পূর্ণ বাংলায়। ছবির বদলে প্রতিটি টার্মের জন্য কাস্টম ভেক্টর ইঞ্জিনিয়ারিং আইকন ব্যবহার করা হয়েছে (কপিরাইট-মুক্ত, অফলাইনেও কাজ করে)।

## ⚡ DEPLOY করার ধাপ (১৫ মিনিট)

### ধাপ ১ — Supabase সেটআপ

1. [supabase.com](https://supabase.com) → **New Project** তৈরি করুন
2. **SQL Editor** → `supabase_setup.sql`-এর সম্পূর্ণ কনটেন্ট paste করুন → **Run** (schema + প্রথম ২০০ টার্ম একসাথে insert হবে)
3. তারপর **SQL Editor**-এ আবার নতুন query খুলে `supabase_additional_terms.sql`-এর সম্পূর্ণ কনটেন্ট paste করে **Run** করুন (বাকি ২০০ টার্ম যোগ হবে, মোট ৪০০)
4. **Project Settings → API** থেকে নিন:
   - `Project URL` → `REACT_APP_SUPABASE_URL`
   - `anon public key` → `REACT_APP_SUPABASE_ANON_KEY`

> Supabase সেটআপ না করলেও অ্যাপ পুরোপুরি কাজ করবে — তখন `src/data/terms.js`-এর বিল্ট-ইন ৪০০ টার্ম অফলাইন-ফার্স্ট ফলব্যাক হিসেবে ব্যবহৃত হবে।
>
> **আগে থেকেই `supabase_setup.sql` চালিয়ে থাকলে** (প্রথম ২০০ টার্ম ইতিমধ্যে Supabase-এ আছে), শুধু `supabase_additional_terms.sql` চালালেই নতুন ২০০ টার্ম যোগ হয়ে যাবে — schema আবার তৈরি করার দরকার নেই, `ON CONFLICT DO NOTHING` থাকায় পুরনো ডেটা প্রভাবিত হবে না।

### ধাপ ২ — GitHub-এ Push

```bash
git init
git add .
git commit -m "⚡ ElectroDict EEE Dictionary PWA"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/electrodict-eee.git
git push -u origin main
```

### ধাপ ৩ — Vercel Deploy

1. [vercel.com](https://vercel.com) → **Add New Project** → GitHub repo import
2. **Settings → Environment Variables** → দুটো variable যোগ করুন:
   ```
   REACT_APP_SUPABASE_URL      = https://xxxx.supabase.co
   REACT_APP_SUPABASE_ANON_KEY = eyJhbGc...
   ```
3. **Deploy** বাটনে ক্লিক করুন ✅

### ধাপ ৪ — PWA Install (Optional)

Chrome/Edge-এ URL-এ গিয়ে address bar-এর ⊕ বোতামে ক্লিক করুন, বা মোবাইলে "Add to Home Screen"।

---

## 🏗️ Project Structure

```
electrodict-eee/
├── public/
│   ├── index.html          # PWA HTML
│   ├── manifest.json       # PWA manifest
│   ├── sw.js                # Service Worker (offline)
│   ├── favicon.ico / logo192.png / logo512.png
├── src/
│   ├── App.js               # Main app + Supabase real-time + Quiz/PDF handlers
│   ├── index.js             # Entry point
│   ├── index.css            # Tailwind + custom styles
│   ├── lib/
│   │   ├── supabase.js      # Supabase client
│   │   └── pdfExport.js     # jsPDF + html2canvas ভিত্তিক PDF জেনারেশন (lazy-loaded)
│   ├── data/
│   │   └── terms.js         # SUBJECTS + SEED_TERMS (৪০০ টার্ম, অফলাইন ফলব্যাক)
│   └── components/
│       ├── Header.js        # Search + Subject filter + A-Z filter + Quiz/PDF বাটন
│       ├── StatsBar.js      # Stats dashboard
│       ├── TermCard.js      # Grid/List card (কাস্টম আইকন সহ)
│       ├── TermModal.js     # Detail modal (৫ ট্যাব + একক-টার্ম PDF এক্সপোর্ট)
│       ├── QuizMode.js      # Setup → Playing → Results — multiple-choice কুইজ
│       ├── icons.js         # ৫৮টি কাস্টম SVG ইঞ্জিনিয়ারিং আইকন
│       └── constants.js     # Importance রঙ, Subject গ্রেডিয়েন্ট/হেক্স, ট্যাব লিস্ট
├── supabase_setup.sql       # DB schema + প্রথম ২০০ টার্ম seed data
├── supabase_additional_terms.sql  # অতিরিক্ত ২০০ টার্ম (ব্যাচ ২, মোট ৪০০-এর জন্য incremental)
├── Vercel.json               # Vercel config
├── tailwind.config.js
├── package.json
└── .env.example
```

## ✨ ফিচার

- 🔴 **Real-time** — Supabase Realtime subscription (INSERT/UPDATE/DELETE সাথে সাথে UI-তে আপডেট)
- 📱 **PWA** — Install করুন, অফলাইনে কাজ করে
- 🔍 **Smart Search** — term, tag, বিষয়, সংজ্ঞা, সূত্র, প্রয়োগ, রেফারেন্স বই — সব খোঁজে
- 🏷️ **Subject Filter** — ১০টি বিষয় দিয়ে ফিল্টার, প্রতিটির নিজস্ব রঙ
- 🔤 **A–Z Filter** — অক্ষর দিয়ে ফিল্টার
- ⭐ **Favorites** — localStorage-এ persist, হেডারে লাইভ কাউন্টার
- 🧮 **৫-Tab Detail** — সংজ্ঞা, অ্যানালজি, ব্যবহার, সূত্র, প্রয়োগ
- 🧠 **Quiz Mode** — বিষয় ও প্রশ্ন-সংখ্যা বেছে নিয়ে multiple-choice কুইজ, সেরা স্কোর localStorage-এ সংরক্ষিত, ভুল উত্তরের টার্ম থেকে সরাসরি বিস্তারিত দেখার শর্টকাট
- 📄 **PDF Export** — হেডার থেকে বর্তমান ফিল্টার অনুযায়ী পুরো লিস্টের "Study Sheet" PDF, অথবা মোডাল থেকে একটি টার্মের সম্পূর্ণ ৫-সেকশন ডিটেইল PDF (lazy-loaded jsPDF + html2canvas, তাই প্রাথমিক bundle ছোট থাকে)
- 🎨 **কাস্টম SVG আইকন** — প্রতিটি টার্মের জন্য প্রাসঙ্গিক ইঞ্জিনিয়ারিং সিম্বল
- 🌐 **Online/Offline** indicator
- 📊 **Stats Dashboard**
- 🎨 **কালারফুল ডার্ক থিম** — প্রতিটি বিষয়ের নিজস্ব গ্রেডিয়েন্ট (Dribbble-inspired)

## 📦 Dependencies

```bash
npm install
```

Main: `react`, `react-dom`, `@supabase/supabase-js`, `jspdf`, `html2canvas`
Dev: `tailwindcss`, `autoprefixer`, `postcss`

## 🔧 Local Development

```bash
cp .env.example .env.local
# .env.local-এ আপনার Supabase keys বসান (ঐচ্ছিক)

npm install
npm start
```

## 📝 নতুন টার্ম যোগ করা

একটি একক সোর্স-অফ-ট্রুথ পদ্ধতি ব্যবহার করা হয়েছে: `src/data/terms.js`-এর `SEED_TERMS` অ্যারেতে বা সরাসরি Supabase টেবিলে (`eee_terms`) নতুন সারি insert করলে তা রিয়েল-টাইমে সব ব্যবহারকারীর কাছে পৌঁছে যাবে। প্রতিটি টার্মের ফিল্ড: `term, letter, subject, book, importance, icon, short, definition, analogy, useCase/use_case, example, relation, application, tags`।

`icon` ফিল্ডে `src/components/icons.js`-এ সংজ্ঞায়িত যেকোনো একটি key ব্যবহার করুন (না মিললে ডিফল্ট আইকন দেখাবে)।
