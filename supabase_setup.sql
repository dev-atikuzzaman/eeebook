-- ═══════════════════════════════════════════════════════════════
-- ElectroDict — EEE টেকনিক্যাল ডিকশনারি — Supabase Schema + Seed Data
-- ৮০/২০ নীতিতে ১০ বিষয়ে ২০০টি গুরুত্বপূর্ণ EEE টার্ম, সম্পূর্ণ বাংলায়।
-- Run this whole file once in Supabase SQL Editor (or via `psql`).
-- ═══════════════════════════════════════════════════════════════

-- 1) Table
CREATE TABLE IF NOT EXISTS public.eee_terms (
  id            SERIAL PRIMARY KEY,
  term          TEXT NOT NULL UNIQUE,
  letter        CHAR(1) NOT NULL,
  subject       TEXT NOT NULL,
  book          TEXT,
  importance    TEXT NOT NULL DEFAULT 'medium' CHECK (importance IN ('critical','high','medium','low')),
  icon          TEXT,
  short         TEXT,
  definition    TEXT,
  analogy       TEXT,
  use_case      TEXT,
  example       TEXT,
  relation      TEXT,
  application   TEXT,
  tags          TEXT[] DEFAULT '{}',
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_eee_terms_letter  ON public.eee_terms(letter);
CREATE INDEX IF NOT EXISTS idx_eee_terms_subject ON public.eee_terms(subject);

-- 2) Row Level Security — public read, no public write
ALTER TABLE public.eee_terms ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public read access" ON public.eee_terms;
CREATE POLICY "Public read access"
  ON public.eee_terms FOR SELECT
  USING (true);

-- 3) Realtime
ALTER PUBLICATION supabase_realtime ADD TABLE public.eee_terms;

-- 4) updated_at auto-touch trigger
CREATE OR REPLACE FUNCTION public.touch_updated_at()
RETURNS TRIGGER AS $trg$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$trg$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_eee_terms_updated_at ON public.eee_terms;
CREATE TRIGGER trg_eee_terms_updated_at
  BEFORE UPDATE ON public.eee_terms
  FOR EACH ROW EXECUTE FUNCTION public.touch_updated_at();

-- 5) Seed data (200 terms)

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q0$Ohm's Law$Q0$,
  $Q1$O$Q1$,
  $Q2$circuit$Q2$,
  $Q3$Sadiku, Ch.2$Q3$,
  $Q4$critical$Q4$,
  $Q5$formula$Q5$,
  $Q6$ভোল্টেজ, কারেন্ট ও রেজিস্ট্যান্সের মূল সম্পর্ক$Q6$,
  $Q7$Ohm's Law বলে যে, একটি রোধকের (resistor) দুই প্রান্তের মধ্যে ভোল্টেজ (V) তার মধ্য দিয়ে প্রবাহিত কারেন্টের (I) সরাসরি সমানুপাতিক, এবং সমানুপাতিক ধ্রুবকটিই হলো রেজিস্ট্যান্স (R)। তাপমাত্রা স্থির থাকলে এই সম্পর্ক রৈখিক (linear) হয়।$Q7$,
  $Q8$🚰 পানির পাইপের মতো ভাবো — ভোল্টেজ হলো পানির চাপ, কারেন্ট হলো পানির প্রবাহ, আর রেজিস্ট্যান্স হলো পাইপের সংকীর্ণতা। পাইপ সরু হলে (রেজিস্ট্যান্স বেশি) একই চাপে কম পানি প্রবাহিত হয়।$Q8$,
  $Q9$যেকোনো সার্কিট ডিজাইনে রোধের মান নির্ধারণ, LED-এর জন্য সঠিক current-limiting resistor বাছাই, এবং fault diagnosis-এ ভোল্টেজ ড্রপ হিসাব করতে ব্যবহৃত হয়।$Q9$,
  $Q10$একটি 12V ব্যাটারির সাথে 4Ω রোধ যুক্ত করলে সার্কিটে প্রবাহিত কারেন্ট হবে I = V/R = 12/4 = 3A।$Q10$,
  $Q11$V = I × R  (V = ভোল্টেজ in Volt, I = কারেন্ট in Ampere, R = রেজিস্ট্যান্স in Ohm)। R স্থির থাকলে V বাড়লে I সমানুপাতিক হারে বাড়ে; V স্থির থাকলে R বাড়লে I ব্যস্তানুপাতিক হারে কমে।$Q11$,
  $Q12$ইলেকট্রনিক ডিভাইসের সুরক্ষা সার্কিট, হিটার ও বাল্বের ডিজাইন, ভোল্টেজ ডিভাইডার তৈরি, এবং মাল্টিমিটার দিয়ে রোধ পরিমাপে এই সূত্র ভিত্তি হিসেবে কাজ করে।$Q12$,
  ARRAY[$Q13$Basic Law$Q13$,$Q14$V-I Relation$Q14$,$Q15$DC Circuit$Q15$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q16$Kirchhoff's Current Law (KCL)$Q16$,
  $Q17$K$Q17$,
  $Q18$circuit$Q18$,
  $Q19$Sadiku, Ch.2$Q19$,
  $Q20$critical$Q20$,
  $Q21$junction$Q21$,
  $Q22$নোডে কারেন্টের সংরক্ষণ সূত্র$Q22$,
  $Q23$KCL বলে যে, একটি নোড (junction) এ প্রবেশকারী মোট কারেন্ট, সেই নোড থেকে বের হওয়া মোট কারেন্টের সমান। এটি চার্জ সংরক্ষণ নীতির (conservation of charge) সরাসরি ফলাফল।$Q23$,
  $Q24$🚦 একটি রাস্তার মোড়ের মতো — যত গাড়ি মোড়ে ঢোকে, ঠিক ততগুলো গাড়িই বিভিন্ন রাস্তা দিয়ে বের হয়ে যায়, কোনো গাড়ি মোড়ে জমা থাকে না।$Q24$,
  $Q25$জটিল multi-loop সার্কিটে অজানা কারেন্ট বের করতে Node Voltage পদ্ধতির মূল ভিত্তি হিসেবে ব্যবহৃত হয়।$Q25$,
  $Q26$একটি নোডে তিনটি শাখা থাকলে, দুটি শাখায় কারেন্ট প্রবেশ করছে 5A ও 3A, তাহলে তৃতীয় শাখা দিয়ে 8A কারেন্ট বের হয়ে যাবে।$Q26$,
  $Q27$ΣI_in = ΣI_out, অথবা একটি নোডের সব কারেন্টের বীজগাণিতিক যোগফল শূন্য (Σ I = 0)। প্রবেশকারী কারেন্টকে ধনাত্মক ও নির্গমনকারী কারেন্টকে ঋণাত্মক ধরা হয়।$Q27$,
  $Q28$পাওয়ার গ্রিডে লোড ব্যালেন্স চেক করা, PCB ডিজাইনে current distribution বিশ্লেষণ, এবং সার্কিট সিমুলেশন সফটওয়্যার (SPICE) এর ভিত্তি সূত্র।$Q28$,
  ARRAY[$Q29$Node Law$Q29$,$Q30$Conservation$Q30$,$Q31$Circuit Analysis$Q31$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q32$Kirchhoff's Voltage Law (KVL)$Q32$,
  $Q33$K$Q33$,
  $Q34$circuit$Q34$,
  $Q35$Sadiku, Ch.2$Q35$,
  $Q36$critical$Q36$,
  $Q37$loop$Q37$,
  $Q38$লুপে ভোল্টেজের সংরক্ষণ সূত্র$Q38$,
  $Q39$KVL বলে যে, একটি বদ্ধ লুপ (closed loop) বরাবর ঘুরে এলে সব ভোল্টেজ রাইজ ও ড্রপের বীজগাণিতিক যোগফল শূন্য হয়। এটি শক্তি সংরক্ষণ নীতির ফলাফল।$Q39$,
  $Q40$⛰️ পাহাড়ে হাইকিং করার মতো — তুমি যেখান থেকে শুরু করেছ, ঘুরে আবার সেখানেই ফিরে এলে মোট উচ্চতা পরিবর্তন শূন্য, যতই ওঠানামা করো না কেন।$Q40$,
  $Q41$সিরিজ সার্কিটে প্রতিটি উপাদানের ভোল্টেজ ড্রপ হিসাব এবং Mesh Current পদ্ধতিতে সার্কিট বিশ্লেষণের মূল ভিত্তি।$Q41$,
  $Q42$একটি লুপে 10V সোর্স থাকলে এবং দুটি রোধে যথাক্রমে 6V ও 4V ড্রপ হলে, 10 − 6 − 4 = 0, যা KVL নিশ্চিত করে।$Q42$,
  $Q43$Σ V = 0 (একটি বদ্ধ লুপে)। সোর্স ভোল্টেজ = সব রোধের ভোল্টেজ ড্রপের যোগফল, অর্থাৎ V_source = I×R₁ + I×R₂ + ... + I×Rₙ।$Q43$,
  $Q44$মাল্টি-লুপ সার্কিট ডিজাইনে ভোল্টেজ ব্যালেন্স যাচাই, ব্যাটারি চার্জিং সার্কিট বিশ্লেষণ, এবং ইলেকট্রিক্যাল নিরাপত্তা পরীক্ষায় ব্যবহৃত হয়।$Q44$,
  ARRAY[$Q45$Loop Law$Q45$,$Q46$Conservation$Q46$,$Q47$Circuit Analysis$Q47$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q48$Resistor$Q48$,
  $Q49$R$Q49$,
  $Q50$circuit$Q50$,
  $Q51$Sadiku, Ch.2$Q51$,
  $Q52$critical$Q52$,
  $Q53$resistor$Q53$,
  $Q54$কারেন্ট প্রবাহে বাধা দানকারী উপাদান$Q54$,
  $Q55$Resistor একটি প্যাসিভ ইলেকট্রনিক উপাদান যা সার্কিটে কারেন্ট প্রবাহে একটি নির্দিষ্ট মাত্রার বাধা (resistance) সৃষ্টি করে এবং বৈদ্যুতিক শক্তিকে তাপে রূপান্তরিত করে।$Q55$,
  $Q56$🧱 রাস্তায় স্পিড ব্রেকারের মতো — গাড়ির (কারেন্টের) গতি কমিয়ে দেয়, বেশি স্পিড ব্রেকার (বেশি রেজিস্ট্যান্স) মানে গাড়ি আরও কম চলবে।$Q56$,
  $Q57$কারেন্ট সীমিত রাখা, ভোল্টেজ ডিভাইডার তৈরি, LED প্রোটেকশন, এবং পুল-আপ/পুল-ডাউন কনফিগারেশনে ব্যবহৃত হয়।$Q57$,
  $Q58$একটি 220Ω রোধ 5V সোর্সের সাথে ব্যবহার করলে LED-এর মধ্য দিয়ে প্রায় 20mA নিরাপদ কারেন্ট প্রবাহিত হয়, যা LED পুড়ে যাওয়া থেকে রক্ষা করে।$Q58$,
  $Q59$R = ρL/A (ρ = রেজিস্টিভিটি, L = দৈর্ঘ্য, A = ক্রস-সেকশনাল এরিয়া)। দৈর্ঘ্য বাড়লে রেজিস্ট্যান্স বাড়ে, ক্রস-সেকশন এরিয়া বাড়লে রেজিস্ট্যান্স কমে।$Q59$,
  $Q60$ইলেকট্রনিক ডিভাইসের সুরক্ষা, তাপ উৎপাদনকারী যন্ত্র (হিটার, টোস্টার), ভলিউম কন্ট্রোল (পটেনশিওমিটার), এবং সেন্সর সার্কিটে ব্যাপকভাবে ব্যবহৃত হয়।$Q60$,
  ARRAY[$Q61$Passive Element$Q61$,$Q62$Ohmic$Q62$,$Q63$Component$Q63$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q64$Capacitor$Q64$,
  $Q65$C$Q65$,
  $Q66$circuit$Q66$,
  $Q67$Sadiku, Ch.6$Q67$,
  $Q68$critical$Q68$,
  $Q69$capacitor$Q69$,
  $Q70$চার্জ সঞ্চয়কারী উপাদান$Q70$,
  $Q71$Capacitor দুটি পরিবাহী প্লেটের মাঝে একটি ডাইইলেকট্রিক (অন্তরক) স্থাপন করে তৈরি একটি উপাদান, যা ইলেকট্রিক ফিল্ডের মাধ্যমে বৈদ্যুতিক চার্জ ও শক্তি সঞ্চয় করে।$Q71$,
  $Q72$🪣 পানির বালতির মতো — চার্জ হলো পানি যা বালতিতে (ক্যাপাসিটরে) জমা হয়, বালতি যত বড় (ক্যাপাসিট্যান্স বেশি) তত বেশি পানি জমতে পারে।$Q72$,
  $Q73$পাওয়ার সাপ্লাইতে ভোল্টেজ স্মুথিং, টাইমিং সার্কিট, সিগন্যাল ফিল্টারিং এবং এনার্জি স্টোরেজে ব্যবহৃত হয়।$Q73$,
  $Q74$একটি ক্যামেরা ফ্ল্যাশে ক্যাপাসিটর ধীরে ধীরে চার্জ হয় এবং মুহূর্তেই বিশাল কারেন্ট রিলিজ করে তীব্র আলো তৈরি করে।$Q74$,
  $Q75$Q = CV এবং I = C(dV/dt) (Q = চার্জ, C = ক্যাপাসিট্যান্স in Farad, V = ভোল্টেজ)। DC স্টেডি-স্টেটে ক্যাপাসিটর ওপেন সার্কিটের মতো আচরণ করে, কারণ dV/dt = 0 হলে I = 0।$Q75$,
  $Q76$মোবাইল ফোন ও কম্পিউটারের পাওয়ার সাপ্লাই, স্পিকার ক্রসওভার সার্কিট, টাচস্ক্রিন প্রযুক্তি, এবং মোটর স্টার্টিং সার্কিটে ব্যবহৃত হয়।$Q76$,
  ARRAY[$Q77$Passive Element$Q77$,$Q78$Energy Storage$Q78$,$Q79$Component$Q79$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q80$Inductor$Q80$,
  $Q81$I$Q81$,
  $Q82$circuit$Q82$,
  $Q83$Sadiku, Ch.6$Q83$,
  $Q84$high$Q84$,
  $Q85$inductor$Q85$,
  $Q86$চৌম্বক ফিল্ডে শক্তি সঞ্চয়কারী কয়েল$Q86$,
  $Q87$Inductor একটি কুণ্ডলী আকৃতির উপাদান যা তার মধ্য দিয়ে প্রবাহিত কারেন্টের পরিবর্তনের বিরোধিতা করে এবং চৌম্বক ফিল্ডের মাধ্যমে শক্তি সঞ্চয় করে।$Q87$,
  $Q88$🏋️ ভারী ফ্লাইহুইলের মতো — একবার ঘুরতে শুরু করলে হঠাৎ থামানো কঠিন, তেমনি ইন্ডাক্টরে কারেন্ট হঠাৎ পরিবর্তন করা কঠিন — এটি পরিবর্তন প্রতিরোধ করে।$Q88$,
  $Q89$পাওয়ার সাপ্লাইতে ফিল্টারিং, ট্রান্সফরমার ডিজাইন, RF সার্কিটে টিউনিং, এবং মোটর ও রিলেতে ব্যবহৃত হয়।$Q89$,
  $Q90$একটি সুইচিং পাওয়ার সাপ্লাইতে ইন্ডাক্টর কারেন্ট রিপল কমিয়ে স্মুথ DC আউটপুট তৈরি করতে সাহায্য করে।$Q90$,
  $Q91$V = L(dI/dt) (L = ইন্ডাকট্যান্স in Henry)। কারেন্ট দ্রুত পরিবর্তন হলে ভোল্টেজ বেশি উৎপন্ন হয়; DC স্টেডি-স্টেটে ইন্ডাক্টর শর্ট সার্কিটের মতো আচরণ করে।$Q91$,
  $Q92$ওয়্যারলেস চার্জিং, রেডিও টিউনার, EMI ফিল্টার, এবং ইলেকট্রিক মোটরের চৌম্বক কোর ডিজাইনে ব্যবহৃত হয়।$Q92$,
  ARRAY[$Q93$Passive Element$Q93$,$Q94$Magnetic Storage$Q94$,$Q95$Coil$Q95$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q96$Series Circuit$Q96$,
  $Q97$S$Q97$,
  $Q98$circuit$Q98$,
  $Q99$Sadiku, Ch.2$Q99$,
  $Q100$high$Q100$,
  $Q101$wire$Q101$,
  $Q102$একই পথে একের পর এক সংযুক্ত উপাদান$Q102$,
  $Q103$Series Circuit এমন একটি সার্কিট যেখানে উপাদানগুলো একটি মাত্র পথে পরপর সংযুক্ত থাকে, ফলে সব উপাদানের মধ্য দিয়ে একই কারেন্ট প্রবাহিত হয়, কিন্তু ভোল্টেজ ভাগ হয়ে যায়।$Q103$,
  $Q104$🚂 ট্রেনের বগির মতো — সব বগি একই লাইনে একের পর এক যুক্ত, একটি বগি থেমে গেলে (broken হলে) পুরো ট্রেনই থেমে যায়।$Q104$,
  $Q105$স্ট্রিং লাইট (একটি বাল্ব নষ্ট হলে সব নিভে যায়), ভোল্টেজ ডিভাইডার সার্কিট, এবং ব্যাটারি সিরিজ কানেকশনে ব্যবহৃত হয়।$Q105$,
  $Q106$তিনটি 2Ω রোধ সিরিজে যুক্ত করলে মোট রেজিস্ট্যান্স হবে 2+2+2 = 6Ω, এবং একই কারেন্ট সবগুলোর মধ্য দিয়ে প্রবাহিত হবে।$Q106$,
  $Q107$R_total = R₁ + R₂ + ... + Rₙ, এবং I একই থাকে সব উপাদানে, কিন্তু V প্রতিটি উপাদানে তার রেজিস্ট্যান্স অনুপাতে ভাগ হয় (Voltage Divider: V_x = V_total × Rₓ/R_total)।$Q107$,
  $Q108$পুরনো ক্রিসমাস লাইট, ফিউজ প্রোটেকশন সার্কিট, এবং মাল্টি-সেল ব্যাটারি প্যাক (যেমন ল্যাপটপ ব্যাটারি) ডিজাইনে ব্যবহৃত হয়।$Q108$,
  ARRAY[$Q109$Circuit Topology$Q109$,$Q110$Voltage Divider$Q110$,$Q111$Basic Circuit$Q111$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q112$Parallel Circuit$Q112$,
  $Q113$P$Q113$,
  $Q114$circuit$Q114$,
  $Q115$Sadiku, Ch.2$Q115$,
  $Q116$high$Q116$,
  $Q117$network$Q117$,
  $Q118$একাধিক পথে বিভক্ত সমান্তরাল সংযোগ$Q118$,
  $Q119$Parallel Circuit এমন একটি সার্কিট যেখানে উপাদানগুলো একই দুটি নোডের মধ্যে একাধিক আলাদা শাখায় সংযুক্ত থাকে, ফলে সবার ভোল্টেজ সমান থাকে কিন্তু কারেন্ট শাখায় শাখায় ভাগ হয়ে যায়।$Q119$,
  $Q120$🛣️ মহাসড়কের একাধিক লেনের মতো — একটি লেন বন্ধ থাকলেও অন্য লেন দিয়ে গাড়ি (কারেন্ট) চলতেই থাকে, কোনো লেন প্রভাবিত হয় না।$Q120$,
  $Q121$বাসাবাড়ির ওয়্যারিং সিস্টেমে (একটি বাল্ব নষ্ট হলেও অন্যগুলো জ্বলতে থাকে), এবং একাধিক লোড একসাথে চালাতে ব্যবহৃত হয়।$Q121$,
  $Q122$দুটি 4Ω রোধ প্যারালালে যুক্ত করলে মোট রেজিস্ট্যান্স হবে (4×4)/(4+4) = 2Ω, যা প্রতিটি একক রোধের চেয়ে কম।$Q122$,
  $Q123$1/R_total = 1/R₁ + 1/R₂ + ... + 1/Rₙ, এবং V একই থাকে সব শাখায়, কিন্তু I প্রতিটি শাখায় তার রেজিস্ট্যান্স অনুযায়ী ভাগ হয় (Current Divider)।$Q123$,
  $Q124$গৃহস্থালী বৈদ্যুতিক ওয়্যারিং, সার্ভার রুমের রিডানডেন্ট পাওয়ার সাপ্লাই, এবং সোলার প্যানেল ব্যাংক কানেকশনে ব্যবহৃত হয়।$Q124$,
  ARRAY[$Q125$Circuit Topology$Q125$,$Q126$Current Divider$Q126$,$Q127$Basic Circuit$Q127$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q128$Thevenin's Theorem$Q128$,
  $Q129$T$Q129$,
  $Q130$circuit$Q130$,
  $Q131$Sadiku, Ch.4$Q131$,
  $Q132$high$Q132$,
  $Q133$blockdiagram$Q133$,
  $Q134$জটিল সার্কিটকে সরল সোর্সে রূপান্তর$Q134$,
  $Q135$Thevenin's Theorem অনুযায়ী, যেকোনো জটিল লিনিয়ার দুই-টার্মিনাল সার্কিটকে একটি একক ভোল্টেজ সোর্স (V_th) এবং একটি সিরিজ রেজিস্ট্যান্স (R_th) দিয়ে প্রতিস্থাপন করা যায়, নির্দিষ্ট লোডের দৃষ্টিকোণ থেকে।$Q135$,
  $Q136$📦 একটি ব্ল্যাক বক্সের মতো — ভেতরে যত জটিল সার্কিটই থাকুক না কেন, বাইরে থেকে দেখলে এটি শুধু একটি সাধারণ ব্যাটারি ও রোধের মতো আচরণ করে।$Q136$,
  $Q137$জটিল সার্কিটে একটি নির্দিষ্ট রোধের ওপর প্রভাব বিশ্লেষণ করতে, বারবার পুরো সার্কিট সমাধান না করে সরলীকরণে ব্যবহৃত হয়।$Q137$,
  $Q138$একটি জটিল রেজিস্টর নেটওয়ার্ককে সরল করে দেখা গেল V_th = 10V এবং R_th = 2Ω — এখন যেকোনো লোড রোধ যুক্ত করে সহজেই কারেন্ট বের করা যায়।$Q138$,
  $Q139$V_th = Open-circuit ভোল্টেজ (লোড খুলে ফেলে পরিমাপ), R_th = সব স্বাধীন সোর্স শূন্য করে দেখা রেজিস্ট্যান্স। I_load = V_th/(R_th + R_load)।$Q139$,
  $Q140$পাওয়ার সাপ্লাই ডিজাইনে ইন্টারনাল রেজিস্ট্যান্স বিশ্লেষণ, সেন্সর সার্কিট ইন্টারফেসিং, এবং ব্যাটারি মডেলিংয়ে ব্যবহৃত হয়।$Q140$,
  ARRAY[$Q141$Network Theorem$Q141$,$Q142$Circuit Simplification$Q142$,$Q143$Equivalent Circuit$Q143$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q144$Norton's Theorem$Q144$,
  $Q145$N$Q145$,
  $Q146$circuit$Q146$,
  $Q147$Sadiku, Ch.4$Q147$,
  $Q148$medium$Q148$,
  $Q149$blockdiagram$Q149$,
  $Q150$জটিল সার্কিটকে সরল কারেন্ট সোর্সে রূপান্তর$Q150$,
  $Q151$Norton's Theorem অনুযায়ী, যেকোনো জটিল লিনিয়ার দুই-টার্মিনাল সার্কিটকে একটি কারেন্ট সোর্স (I_N) এবং একটি প্যারালাল রেজিস্ট্যান্স (R_N) দিয়ে প্রতিস্থাপন করা যায়, যা Thevenin equivalent-এরই বিকল্প রূপ।$Q151$,
  $Q152$🔄 Thevenin-এর যমজ ভাই — একই ব্ল্যাক বক্সকে দুইভাবে দেখানো যায়, একটি ভোল্টেজ সোর্স হিসেবে, অন্যটি কারেন্ট সোর্স হিসেবে — দুটোই একই বাহ্যিক আচরণ দেখায়।$Q152$,
  $Q153$কারেন্ট-প্রধান বিশ্লেষণে (যেমন ট্রানজিস্টর মডেলিং), যেখানে কারেন্ট সোর্স ধারণা বেশি স্বাভাবিক, সেখানে ব্যবহৃত হয়।$Q153$,
  $Q154$যদি Thevenin equivalent হয় V_th=10V, R_th=2Ω, তাহলে Norton equivalent হবে I_N = V_th/R_th = 5A এবং R_N = R_th = 2Ω।$Q154$,
  $Q155$I_N = V_th / R_th, R_N = R_th (Thevenin ও Norton রেজিস্ট্যান্স সবসময় সমান)। I_N = Short-circuit কারেন্ট (আউটপুট টার্মিনাল শর্ট করে পরিমাপ করা কারেন্ট)।$Q155$,
  $Q156$ট্রানজিস্টর ও ডায়োড মডেলিং, কারেন্ট সোর্স ভিত্তিক বায়াসিং সার্কিট ডিজাইন, এবং সোলার সেল ইকুইভ্যালেন্ট সার্কিট বিশ্লেষণে ব্যবহৃত হয়।$Q156$,
  ARRAY[$Q157$Network Theorem$Q157$,$Q158$Current Source$Q158$,$Q159$Equivalent Circuit$Q159$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q160$Superposition Theorem$Q160$,
  $Q161$S$Q161$,
  $Q162$circuit$Q162$,
  $Q163$Sadiku, Ch.4$Q163$,
  $Q164$medium$Q164$,
  $Q165$blockdiagram$Q165$,
  $Q166$একাধিক সোর্সের প্রভাব আলাদাভাবে যোগ করা$Q166$,
  $Q167$Superposition Theorem বলে যে, একাধিক স্বাধীন সোর্সযুক্ত লিনিয়ার সার্কিটে যেকোনো উপাদানের মধ্য দিয়ে মোট কারেন্ট বা ভোল্টেজ হলো প্রতিটি সোর্স আলাদাভাবে (অন্যগুলো শূন্য ধরে) কাজ করলে যে প্রভাব পড়ত তাদের যোগফল।$Q167$,
  $Q168$🎨 রঙ মেশানোর মতো — প্রতিটি রঙের (সোর্সের) প্রভাব আলাদাভাবে দেখে তারপর মিশিয়ে চূড়ান্ত ফলাফল (মোট প্রভাব) বের করা।$Q168$,
  $Q169$একাধিক ভোল্টেজ ও কারেন্ট সোর্সসম্বলিত সার্কিটে জটিল সমীকরণ এড়িয়ে ধাপে ধাপে বিশ্লেষণ করতে ব্যবহৃত হয়।$Q169$,
  $Q170$দুটি সোর্স থাকা সার্কিটে প্রথমে শুধু ভোল্টেজ সোর্স সক্রিয় রেখে (কারেন্ট সোর্স ওপেন করে) কারেন্ট বের করা হয়, তারপর উল্টোভাবে, শেষে দুটি ফলাফল যোগ করা হয়।$Q170$,
  $Q171$I_total = I₁ (শুধু সোর্স-১ সক্রিয়) + I₂ (শুধু সোর্স-২ সক্রিয়)। ভোল্টেজ সোর্স শূন্য করলে শর্ট সার্কিট হয়, কারেন্ট সোর্স শূন্য করলে ওপেন সার্কিট হয়।$Q171$,
  $Q172$অডিও মিক্সার সার্কিট বিশ্লেষণ, পাওয়ার সিস্টেমে একাধিক জেনারেটরের প্রভাব বিশ্লেষণ, এবং EMI/নয়েজ বিশ্লেষণে ব্যবহৃত হয়।$Q172$,
  ARRAY[$Q173$Network Theorem$Q173$,$Q174$Linear Circuit$Q174$,$Q175$Multiple Sources$Q175$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q176$Node Voltage Method$Q176$,
  $Q177$N$Q177$,
  $Q178$circuit$Q178$,
  $Q179$Sadiku, Ch.3$Q179$,
  $Q180$high$Q180$,
  $Q181$junction$Q181$,
  $Q182$নোড ভোল্টেজ ব্যবহার করে সার্কিট সমাধান$Q182$,
  $Q183$Node Voltage Method (Nodal Analysis) হলো একটি পদ্ধতিমালা যেখানে সার্কিটের প্রতিটি নোডের ভোল্টেজকে রেফারেন্স নোড (গ্রাউন্ড) এর সাপেক্ষে অজানা রাশি ধরে, KCL প্রয়োগ করে সমীকরণ সমাধান করা হয়।$Q183$,
  $Q184$🗺️ একটি শহরের বিভিন্ন এলাকার উচ্চতা (সমুদ্রপৃষ্ঠ থেকে) জানার মতো — একটি রেফারেন্স পয়েন্ট (সমুদ্রপৃষ্ঠ = গ্রাউন্ড) ধরে বাকি সব জায়গার উচ্চতা (ভোল্টেজ) নির্ণয় করা।$Q184$,
  $Q185$কম্পিউটার-এইডেড সার্কিট সিমুলেশন (SPICE) এর মূল ভিত্তি, বিশেষ করে যেসব সার্কিটে নোড সংখ্যা লুপ সংখ্যার চেয়ে কম, সেখানে বেশি কার্যকর।$Q185$,
  $Q186$তিনটি নোডবিশিষ্ট একটি সার্কিটে একটিকে গ্রাউন্ড (0V) ধরে বাকি দুইটি নোডে KCL সমীকরণ লিখে V₁ ও V₂ সমাধান করা হয়।$Q186$,
  $Q187$প্রতিটি নন-রেফারেন্স নোডে: Σ(কারেন্ট বের হচ্ছে) = 0, যেখানে প্রতিটি শাখার কারেন্ট = (V_নোড − V_প্রতিবেশী)/R আকারে লেখা হয়।$Q187$,
  $Q188$সার্কিট সিমুলেশন সফটওয়্যার (LTspice, PSpice), পাওয়ার গ্রিড লোড ফ্লো বিশ্লেষণের ভিত্তি, এবং বড় IC ডিজাইনে ব্যবহৃত হয়।$Q188$,
  ARRAY[$Q189$Circuit Analysis$Q189$,$Q190$KCL$Q190$,$Q191$Nodal Analysis$Q191$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q192$Mesh Current Method$Q192$,
  $Q193$M$Q193$,
  $Q194$circuit$Q194$,
  $Q195$Sadiku, Ch.3$Q195$,
  $Q196$high$Q196$,
  $Q197$loop$Q197$,
  $Q198$লুপ কারেন্ট ব্যবহার করে সার্কিট সমাধান$Q198$,
  $Q199$Mesh Current Method (Mesh Analysis) হলো একটি পদ্ধতি যেখানে সার্কিটের প্রতিটি স্বাধীন লুপে (mesh) একটি কাল্পনিক লুপ কারেন্ট ধরে, KVL প্রয়োগ করে সমীকরণ সমাধান করা হয় — এটি শুধুমাত্র প্ল্যানার সার্কিটের জন্য প্রযোজ্য।$Q199$,
  $Q200$🌀 একাধিক ঘূর্ণায়মান চাকার মতো — প্রতিটি লুপে একটি নিজস্ব কাল্পনিক 'ঘূর্ণন কারেন্ট' প্রবাহিত হচ্ছে, আর সাধারণ শাখার প্রকৃত কারেন্ট হলো পাশাপাশি দুই ঘূর্ণনের যোগ-বিয়োগ।$Q200$,
  $Q201$যেসব সার্কিটে লুপ সংখ্যা নোড সংখ্যার চেয়ে কম, সেখানে Node Voltage-এর চেয়ে দ্রুত সমাধানে ব্যবহৃত হয়, বিশেষত সিরিজ-প্রধান সার্কিটে।$Q201$,
  $Q202$দুটি লুপবিশিষ্ট একটি সার্কিটে প্রতিটি লুপে KVL প্রয়োগ করে I₁ ও I₂ (মেশ কারেন্ট) বের করা হয়, তারপর মাঝের রোধের প্রকৃত কারেন্ট = I₁ − I₂।$Q202$,
  $Q203$প্রতিটি মেশে: Σ V (ওই লুপে) = 0, যেখানে ভাগাভাগি করা রোধের ভোল্টেজ ড্রপে দুই মেশ কারেন্টের পার্থক্য ব্যবহৃত হয় — R(I_mesh − I_adjacent_mesh)।$Q203$,
  $Q204$অ্যানালগ ফিল্টার ডিজাইন যাচাই, ট্রান্সমিশন লাইন মডেলিং, এবং ম্যানুয়াল সার্কিট বিশ্লেষণে দ্রুত সমাধানের জন্য ব্যবহৃত হয়।$Q204$,
  ARRAY[$Q205$Circuit Analysis$Q205$,$Q206$KVL$Q206$,$Q207$Loop Analysis$Q207$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q208$RMS Value$Q208$,
  $Q209$R$Q209$,
  $Q210$circuit$Q210$,
  $Q211$Sadiku, Ch.9$Q211$,
  $Q212$high$Q212$,
  $Q213$wavesine$Q213$,
  $Q214$AC সিগন্যালের কার্যকর মান$Q214$,
  $Q215$RMS (Root Mean Square) Value হলো একটি পরিবর্তনশীল (AC) সিগন্যালের সেই সমতুল্য DC মান, যা একই রোধে একই পরিমাণ গড় শক্তি (তাপ) উৎপন্ন করে। এটি বর্গের গড়ের বর্গমূল নিয়ে বের করা হয়।$Q215$,
  $Q216$🏃 একজন দৌড়বিদের গড় গতির মতো — সে কখনো দ্রুত কখনো ধীরে দৌড়ায় (AC-এর মতো ওঠানামা), কিন্তু RMS হলো সেই সমান গতি যা একই সময়ে একই দূরত্ব অতিক্রম করাবে।$Q216$,
  $Q217$AC পাওয়ার হিসাব, মাল্টিমিটারে AC ভোল্টেজ পরিমাপ, এবং বৈদ্যুতিক যন্ত্রপাতির রেটিং নির্ধারণে ব্যবহৃত হয়।$Q217$,
  $Q218$বাংলাদেশের ঘরোয়া AC সাপ্লাই 220V বলতে RMS ভোল্টেজ বোঝায়; এর পিক ভোল্টেজ আসলে 220×√2 ≈ 311V।$Q218$,
  $Q219$V_RMS = V_peak/√2 (সাইন ওয়েভের জন্য)। P_avg = V_RMS × I_RMS (সিঙ্গেল-ফেজ রেজিস্টিভ লোডে), যা DC পাওয়ার সূত্রের অনুরূপ।$Q219$,
  $Q220$বৈদ্যুতিক যন্ত্রের নেমপ্লেট রেটিং, পাওয়ার মিটার ডিজাইন, এবং অডিও অ্যামপ্লিফায়ারের আউটপুট পাওয়ার নির্ধারণে ব্যবহৃত হয়।$Q220$,
  ARRAY[$Q221$AC Analysis$Q221$,$Q222$Effective Value$Q222$,$Q223$Power$Q223$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q224$Power Factor$Q224$,
  $Q225$P$Q225$,
  $Q226$circuit$Q226$,
  $Q227$Sadiku, Ch.11$Q227$,
  $Q228$critical$Q228$,
  $Q229$gauge$Q229$,
  $Q230$প্রকৃত পাওয়ার ব্যবহারের দক্ষতা নির্দেশক$Q230$,
  $Q231$Power Factor হলো Real Power (kW) এবং Apparent Power (kVA)-এর অনুপাত, যা ভোল্টেজ ও কারেন্টের মধ্যকার ফেজ কোণের কোসাইন (cos θ) দ্বারা নির্ধারিত হয়। এটি লোডের দক্ষতা পরিমাপ করে।$Q231$,
  $Q232$🍺 এক গ্লাস বিয়ারের মতো — গ্লাসের মোট পরিমাণ (Apparent Power) এর মধ্যে বিয়ার (Real Power, প্রকৃত কাজ) কতটুকু আর ফেনা (Reactive Power, অপচয়) কতটুকু তা Power Factor বলে দেয়।$Q232$,
  $Q233$শিল্প কারখানায় পাওয়ার বিল কমাতে Power Factor Correction (ক্যাপাসিটর ব্যাংক) স্থাপন, এবং ট্রান্সফরমার সাইজিং-এ ব্যবহৃত হয়।$Q233$,
  $Q234$একটি মোটরের Power Factor 0.8 হলে, প্রতি 100 kVA বিদ্যুৎ সরবরাহের মধ্যে মাত্র 80 kW প্রকৃত কাজে ব্যবহৃত হয়, বাকিটা রিয়্যাক্টিভ পাওয়ার হিসেবে অপচয় হয়।$Q234$,
  $Q235$PF = cos θ = P(Real, kW)/S(Apparent, kVA)। PF = 1 হলে সম্পূর্ণ রেজিস্টিভ লোড (আদর্শ); ইন্ডাক্টিভ লোডে (মোটর) PF সাধারণত < 1 এবং কারেন্ট ভোল্টেজের থেকে পিছিয়ে (lagging) থাকে।$Q235$,
  $Q236$শিল্প ও গৃহস্থালী বিদ্যুৎ বিলিং সিস্টেম, ক্যাপাসিটর ব্যাংক দিয়ে Power Factor Correction, এবং ট্রান্সমিশন লাইন দক্ষতা বৃদ্ধিতে ব্যবহৃত হয়।$Q236$,
  ARRAY[$Q237$AC Power$Q237$,$Q238$Efficiency$Q238$,$Q239$Reactive Power$Q239$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q240$Resonance$Q240$,
  $Q241$R$Q241$,
  $Q242$circuit$Q242$,
  $Q243$Sadiku, Ch.14$Q243$,
  $Q244$medium$Q244$,
  $Q245$wavesine$Q245$,
  $Q246$সর্বোচ্চ শক্তি স্থানান্তরের বিশেষ কম্পাঙ্ক$Q246$,
  $Q247$Resonance এমন একটি অবস্থা যেখানে একটি RLC সার্কিটে ইন্ডাক্টিভ রিয়্যাক্ট্যান্স (X_L) ও ক্যাপাসিটিভ রিয়্যাক্ট্যান্স (X_C) পরস্পর সমান ও বিপরীত হয়ে বাতিল হয়ে যায়, ফলে সার্কিট সম্পূর্ণ রেজিস্টিভ আচরণ করে।$Q247$,
  $Q248$🎸 গিটারের তারের মতো — প্রতিটি তারের একটি নির্দিষ্ট প্রাকৃতিক কম্পাঙ্ক আছে, সেই কম্পাঙ্কে টোকা দিলে সর্বোচ্চ শব্দ (সাড়া) পাওয়া যায়, অন্য কম্পাঙ্কে কম।$Q248$,
  $Q249$রেডিও টিউনার (নির্দিষ্ট চ্যানেল সিলেক্ট করা), ওয়্যারলেস পাওয়ার ট্রান্সফার, এবং ফিল্টার ডিজাইনে ব্যবহৃত হয়।$Q249$,
  $Q250$একটি রেডিও রিসিভারের টিউনিং সার্কিট নির্দিষ্ট রেজোন্যান্ট ফ্রিকোয়েন্সিতে সেট করে শুধুমাত্র সেই স্টেশনের সিগন্যাল গ্রহণ করে, বাকিগুলো বাদ দেয়।$Q250$,
  $Q251$f_r = 1/(2π√(LC)) — এই কম্পাঙ্কে X_L = X_C, ফলে ইমপিডেন্স সিরিজ RLC-তে সর্বনিম্ন (শুধু R) এবং কারেন্ট সর্বোচ্চ হয়।$Q251$,
  $Q252$রেডিও ও টেলিভিশন টিউনার, MRI মেশিনের RF কয়েল, ওয়্যারলেস চার্জার, এবং মেটাল ডিটেক্টর ডিজাইনে ব্যবহৃত হয়।$Q252$,
  ARRAY[$Q253$RLC Circuit$Q253$,$Q254$Frequency Response$Q254$,$Q255$AC Analysis$Q255$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q256$Time Constant (RC/RL)$Q256$,
  $Q257$T$Q257$,
  $Q258$circuit$Q258$,
  $Q259$Sadiku, Ch.7$Q259$,
  $Q260$medium$Q260$,
  $Q261$clock$Q261$,
  $Q262$সার্কিটের চার্জ/ডিসচার্জ হওয়ার গতির পরিমাপ$Q262$,
  $Q263$Time Constant (τ) হলো একটি RC বা RL সার্কিটের ভোল্টেজ বা কারেন্ট তার চূড়ান্ত মানের প্রায় ৬৩.২% পৌঁছাতে যে সময় লাগে, তার পরিমাপ — এটি সার্কিটের transient response-এর গতি নির্দেশ করে।$Q263$,
  $Q264$☕ গরম চা ঠান্ডা হওয়ার মতো — প্রথমে দ্রুত ঠান্ডা হয়, তারপর ধীরে ধীরে ঘরের তাপমাত্রার কাছাকাছি পৌঁছায়; Time Constant বলে দেয় এই প্রক্রিয়া কতটা দ্রুত ঘটবে।$Q264$,
  $Q265$টাইমার সার্কিট ডিজাইন (যেমন 555 timer), ডিবাউন্স সার্কিট, এবং ফ্ল্যাশ ফটোগ্রাফিতে চার্জিং সময় নির্ধারণে ব্যবহৃত হয়।$Q265$,
  $Q266$একটি R=1kΩ ও C=1000μF সমন্বিত RC সার্কিটে τ = RC = 1 সেকেন্ড, অর্থাৎ 1 সেকেন্ডে ক্যাপাসিটর তার চূড়ান্ত ভোল্টেজের ৬৩.২% এ পৌঁছাবে।$Q266$,
  $Q267$RC সার্কিটে τ = RC (সেকেন্ড); RL সার্কিটে τ = L/R। প্রায় 5τ সময় পরে সার্কিট প্রায় সম্পূর্ণভাবে (৯৯%+) স্টেডি-স্টেটে পৌঁছায়।$Q267$,
  $Q268$ক্যামেরা ফ্ল্যাশ চার্জিং, হার্ট পেসমেকার সার্কিট, উইন্ডশিল্ড ওয়াইপার ডিলে টাইমার, এবং ডিজিটাল সার্কিটের নয়েজ ফিল্টারে ব্যবহৃত হয়।$Q268$,
  ARRAY[$Q269$Transient Response$Q269$,$Q270$RC Circuit$Q270$,$Q271$RL Circuit$Q271$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q272$Maximum Power Transfer Theorem$Q272$,
  $Q273$M$Q273$,
  $Q274$circuit$Q274$,
  $Q275$Sadiku, Ch.4$Q275$,
  $Q276$medium$Q276$,
  $Q277$gauge$Q277$,
  $Q278$সর্বোচ্চ শক্তি স্থানান্তরের শর্ত$Q278$,
  $Q279$Maximum Power Transfer Theorem বলে যে, একটি সোর্স থেকে লোডে সর্বোচ্চ পাওয়ার স্থানান্তরিত হয় তখনই, যখন লোড রেজিস্ট্যান্স (R_L) সোর্সের Thevenin রেজিস্ট্যান্সের (R_th) সমান হয়।$Q279$,
  $Q280$🤝 একটি টাগ-অফ-ওয়ার (দড়ি টানাটানি) খেলার মতো — যখন দুই পক্ষের শক্তি ঠিক সমান থাকে, তখনই সর্বোচ্চ শক্তি (কাজ) সিস্টেমের মধ্য দিয়ে স্থানান্তরিত হয়, একপক্ষ অনেক বেশি শক্তিশালী হলে তা অপচয় হয়।$Q280$,
  $Q281$অডিও স্পিকার ইম্পিডেন্স ম্যাচিং, অ্যান্টেনা ডিজাইন, এবং RF সার্কিটে সোর্স ও লোডের মধ্যে সর্বোচ্চ শক্তি স্থানান্তরে ব্যবহৃত হয়।$Q281$,
  $Q282$যদি একটি অ্যামপ্লিফায়ারের আউটপুট ইম্পিডেন্স 8Ω হয়, তাহলে সর্বোচ্চ পাওয়ার পেতে 8Ω ইম্পিডেন্সের স্পিকার ব্যবহার করা উচিত।$Q282$,
  $Q283$R_L = R_th শর্তে P_max = V_th²/(4×R_th)। এই শর্তে দক্ষতা (efficiency) মাত্র ৫০%, তাই পাওয়ার সিস্টেমে (দক্ষতা গুরুত্বপূর্ণ) এই শর্ত এড়ানো হয়।$Q283$,
  $Q284$অডিও সিস্টেম স্পিকার ম্যাচিং, রেডিও ট্রান্সমিটার অ্যান্টেনা ম্যাচিং নেটওয়ার্ক, এবং সোলার প্যানেল Maximum Power Point Tracking (MPPT)-এর ধারণাগত ভিত্তি।$Q284$,
  ARRAY[$Q285$Network Theorem$Q285$,$Q286$Power Transfer$Q286$,$Q287$Impedance Matching$Q287$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q288$Delta-Wye Transformation$Q288$,
  $Q289$D$Q289$,
  $Q290$circuit$Q290$,
  $Q291$Sadiku, Ch.2$Q291$,
  $Q292$medium$Q292$,
  $Q293$network$Q293$,
  $Q294$ত্রিভুজ ও তারকা সংযোগের রূপান্তর কৌশল$Q294$,
  $Q295$Delta-Wye (Δ-Y) Transformation হলো তিনটি রোধের ত্রিভুজ (Delta/Π) সংযোগকে সমতুল্য তারকা (Wye/Y/T) সংযোগে, বা এর বিপরীতে রূপান্তর করার একটি গাণিতিক পদ্ধতি, যা সার্কিটকে সহজে বিশ্লেষণযোগ্য করে তোলে।$Q295$,
  $Q296$🔺➡️⭐ একটি ত্রিভুজাকার রাস্তার নেটওয়ার্ককে একটি কেন্দ্রীয় চত্বর (তারকা) দিয়ে প্রতিস্থাপন করার মতো — বাইরে থেকে গাড়ি চলাচলের অভিজ্ঞতা একই থাকে, কিন্তু ভেতরের গঠন সহজ হয়ে যায়।$Q296$,
  $Q297$তিন-ফেজ পাওয়ার সিস্টেম বিশ্লেষণ (Delta ও Wye ট্রান্সফরমার কানেকশন), এবং জটিল ব্রিজ সার্কিট সরলীকরণে ব্যবহৃত হয়।$Q297$,
  $Q298$একটি Wheatstone Bridge সার্কিটে Delta-Wye রূপান্তর ব্যবহার করে জটিল নেটওয়ার্ককে সিরিজ-প্যারালাল আকারে সহজে সমাধান করা যায়।$Q298$,
  $Q299$Δ থেকে Y: R_a = (R_ab×R_ca)/(R_ab+R_bc+R_ca) (এবং একইভাবে R_b, R_c)। সবগুলো রোধ সমান হলে (ব্যালেন্সড): R_Y = R_Δ/3।$Q299$,
  $Q300$তিন-ফেজ ট্রান্সফরমার ও মোটর ওয়াইন্ডিং কানেকশন, পাওয়ার গ্রিড বিশ্লেষণ, এবং ইন্টিগ্রেটেড সার্কিট লেআউট অপটিমাইজেশনে ব্যবহৃত হয়।$Q300$,
  ARRAY[$Q301$Network Transformation$Q301$,$Q302$Three-Phase$Q302$,$Q303$Circuit Simplification$Q303$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q304$Impedance$Q304$,
  $Q305$I$Q305$,
  $Q306$circuit$Q306$,
  $Q307$Sadiku, Ch.9$Q307$,
  $Q308$critical$Q308$,
  $Q309$phasor$Q309$,
  $Q310$AC সার্কিটের মোট বাধা (জটিল সংখ্যা)$Q310$,
  $Q311$Impedance (Z) হলো AC সার্কিটে কারেন্ট প্রবাহে মোট বাধা, যা রেজিস্ট্যান্স (R, বাস্তব অংশ) এবং রিয়্যাক্ট্যান্স (X, কাল্পনিক অংশ) নিয়ে গঠিত একটি জটিল (complex) রাশি — এটি Ohm's Law-এর AC সংস্করণে ব্যবহৃত হয়।$Q311$,
  $Q312$🌊 সাঁতার কাটার মতো — শুধু পানির ঘর্ষণ (রেজিস্ট্যান্স) নয়, ঢেউয়ের সাথে তাল মিলিয়ে চলাও (রিয়্যাক্ট্যান্স/ফেজ) একটা বাধা তৈরি করে — দুটো মিলিয়েই মোট 'কষ্ট' (ইমপিডেন্স) নির্ধারিত হয়।$Q312$,
  $Q313$AC সার্কিট বিশ্লেষণ, ফিল্টার ডিজাইন, অডিও ইম্পিডেন্স ম্যাচিং, এবং অ্যান্টেনা ও ট্রান্সমিশন লাইন ডিজাইনে ব্যবহৃত হয়।$Q313$,
  $Q314$একটি সিরিজ RL সার্কিটে R=3Ω এবং X_L=4Ω হলে, মোট ইমপিডেন্স Z = 3+j4, যার মান |Z| = √(3²+4²) = 5Ω।$Q314$,
  $Q315$Z = R + jX (জটিল আকারে), |Z| = √(R² + X²), phase θ = tan⁻¹(X/R)। X_L = 2πfL (ইন্ডাক্টিভ) এবং X_C = 1/(2πfC) (ক্যাপাসিটিভ) — ফ্রিকোয়েন্সির সাথে বিপরীতভাবে পরিবর্তিত হয়।$Q315$,
  $Q316$অডিও স্পিকার ও হেডফোন ডিজাইন, RF ও মাইক্রোওয়েভ ইঞ্জিনিয়ারিং, মেডিকেল ইমেজিং (বায়ো-ইমপিডেন্স), এবং পাওয়ার লাইন কমিউনিকেশনে ব্যবহৃত হয়।$Q316$,
  ARRAY[$Q317$AC Circuit$Q317$,$Q318$Complex Number$Q318$,$Q319$Reactance$Q319$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q320$Diode$Q320$,
  $Q321$D$Q321$,
  $Q322$electronics$Q322$,
  $Q323$Sedra & Smith, Ch.4$Q323$,
  $Q324$critical$Q324$,
  $Q325$diode$Q325$,
  $Q326$একমুখী কারেন্ট প্রবাহকারী সেমিকন্ডাক্টর$Q326$,
  $Q327$Diode একটি দুই-টার্মিনাল সেমিকন্ডাক্টর উপাদান (P-N জাংশন) যা কারেন্টকে শুধুমাত্র একদিকে (ফরওয়ার্ড বায়াস) প্রবাহিত হতে দেয় এবং বিপরীত দিকে (রিভার্স বায়াস) বাধা দেয়।$Q327$,
  $Q328$🚪 একমুখী দরজার মতো — শুধু একদিক থেকে ঢোকা যায়, উল্টো দিক থেকে ঠেলে ঢোকার চেষ্টা করলে দরজা খোলে না।$Q328$,
  $Q329$AC থেকে DC রূপান্তর (rectification), সিগন্যাল ডিমডুলেশন, এবং সার্কিট প্রোটেকশনে (রিভার্স পোলারিটি প্রোটেকশন) ব্যবহৃত হয়।$Q329$,
  $Q330$একটি মোবাইল চার্জারের ভেতরে ডায়োড ব্রিজ AC মেইন সাপ্লাইকে DC-তে রূপান্তরিত করে যা ফোনের ব্যাটারি চার্জ করতে ব্যবহৃত হয়।$Q330$,
  $Q331$Shockley Diode Equation: I = I_S(e^(V/nV_T) − 1)। সাধারণত সিলিকন ডায়োডের ফরওয়ার্ড ভোল্টেজ ড্রপ প্রায় 0.7V এবং জার্মেনিয়ামের জন্য প্রায় 0.3V।$Q331$,
  $Q332$পাওয়ার সাপ্লাই রেকটিফায়ার, LED (আলো নির্গমনকারী ডায়োড), সোলার সেল, এবং RF সিগন্যাল ডিটেকশনে ব্যবহৃত হয়।$Q332$,
  ARRAY[$Q333$Semiconductor$Q333$,$Q334$P-N Junction$Q334$,$Q335$Rectification$Q335$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q336$Rectifier$Q336$,
  $Q337$R$Q337$,
  $Q338$electronics$Q338$,
  $Q339$Sedra & Smith, Ch.4$Q339$,
  $Q340$high$Q340$,
  $Q341$bridge$Q341$,
  $Q342$AC কে DC তে রূপান্তরকারী সার্কিট$Q342$,
  $Q343$Rectifier একটি সার্কিট যা ডায়োড ব্যবহার করে Alternating Current (AC) কে Direct Current (DC)-তে রূপান্তরিত করে। এটি Half-Wave (একটি ডায়োড) বা Full-Wave (ব্রিজ, চারটি ডায়োড) হতে পারে।$Q343$,
  $Q344$🚦 একমুখী ট্রাফিক ভালভের মতো — উভয় দিকের ট্র্যাফিক (AC-এর ধনাত্মক ও ঋণাত্মক অংশ) কে একই দিকে (DC) প্রবাহিত করতে বাধ্য করে।$Q344$,
  $Q345$মোবাইল চার্জার, ল্যাপটপ অ্যাডাপ্টার, এবং ইন্ডাস্ট্রিয়াল পাওয়ার সাপ্লাইতে AC মেইন থেকে DC তৈরিতে ব্যবহৃত হয়।$Q345$,
  $Q346$একটি Full-Wave Bridge Rectifier 220V AC ইনপুট নিয়ে একটি পালসেটিং DC আউটপুট তৈরি করে, যা পরে ক্যাপাসিটর দিয়ে স্মুথ করা হয়।$Q346$,
  $Q347$Half-Wave: V_dc = V_peak/π। Full-Wave Bridge: V_dc = 2V_peak/π (প্রায় দ্বিগুণ দক্ষ)। Ripple ফ্যাক্টর কমাতে আউটপুটে ফিল্টার ক্যাপাসিটর যোগ করা হয়।$Q347$,
  $Q348$মোবাইল ও ল্যাপটপ চার্জার, ব্যাটারি চার্জিং সার্কিট, ইলেকট্রোপ্লেটিং শিল্প, এবং DC মোটর ড্রাইভ সাপ্লাইতে ব্যবহৃত হয়।$Q348$,
  ARRAY[$Q349$AC-DC Conversion$Q349$,$Q350$Diode Circuit$Q350$,$Q351$Power Supply$Q351$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q352$Zener Diode$Q352$,
  $Q353$Z$Q353$,
  $Q354$electronics$Q354$,
  $Q355$Sedra & Smith, Ch.4$Q355$,
  $Q356$high$Q356$,
  $Q357$zener$Q357$,
  $Q358$স্থির ভোল্টেজ রেগুলেশনের বিশেষ ডায়োড$Q358$,
  $Q359$Zener Diode একটি বিশেষভাবে ডিজাইনকৃত ডায়োড যা রিভার্স বায়াসে একটি নির্দিষ্ট ব্রেকডাউন ভোল্টেজে (Zener Voltage) পৌঁছালে নিয়ন্ত্রিতভাবে কারেন্ট প্রবাহিত হতে দেয়, ফলে আউটপুটে স্থির ভোল্টেজ বজায় থাকে।$Q359$,
  $Q360$🚰 প্রেসার রিলিফ ভালভের মতো — একটি নির্দিষ্ট চাপে (ভোল্টেজে) পৌঁছালে ভালভ খুলে অতিরিক্ত চাপ ছেড়ে দেয়, ফলে সিস্টেমের চাপ সবসময় নিরাপদ সীমার মধ্যে থাকে।$Q360$,
  $Q361$রেফারেন্স ভোল্টেজ তৈরি, ভোল্টেজ রেগুলেটর সার্কিট, এবং সেন্সিটিভ সার্কিটকে ওভার-ভোল্টেজ থেকে সুরক্ষায় ব্যবহৃত হয়।$Q361$,
  $Q362$একটি 5.1V Zener ডায়োড ব্যবহার করে সহজ শান্ট রেগুলেটর তৈরি করা যায়, যা ইনপুট ভোল্টেজ ওঠানামা করলেও আউটপুটে স্থির 5.1V বজায় রাখে।$Q362$,
  $Q363$রেজিস্ট্যান্স R_s = (V_in − V_Z)/I_Z দিয়ে সিরিজে বসিয়ে কারেন্ট সীমিত করা হয়। Zener সবসময় রিভার্স বায়াসে কাজ করে, সাধারণ ডায়োডের বিপরীত।$Q363$,
  $Q364$ভোল্টেজ রেফারেন্স সার্কিট, সারজ প্রোটেকশন (Overvoltage protection), সাধারণ পাওয়ার সাপ্লাই রেগুলেশন, এবং ব্যাটারি চার্জার সার্কিটে ব্যবহৃত হয়।$Q364$,
  ARRAY[$Q365$Voltage Regulation$Q365$,$Q366$Breakdown$Q366$,$Q367$Reference Voltage$Q367$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q368$BJT (Bipolar Junction Transistor)$Q368$,
  $Q369$B$Q369$,
  $Q370$electronics$Q370$,
  $Q371$Sedra & Smith, Ch.5$Q371$,
  $Q372$critical$Q372$,
  $Q373$bjt$Q373$,
  $Q374$কারেন্ট নিয়ন্ত্রিত তিন-টার্মিনাল অ্যামপ্লিফায়িং উপাদান$Q374$,
  $Q375$BJT একটি তিন-টার্মিনাল (Base, Collector, Emitter) সেমিকন্ডাক্টর উপাদান যা ছোট বেস কারেন্ট দিয়ে বড় কালেক্টর কারেন্ট নিয়ন্ত্রণ করে — এটি কারেন্ট-নিয়ন্ত্রিত ডিভাইস এবং সিগন্যাল অ্যামপ্লিফিকেশন বা সুইচিং-এ ব্যবহৃত হয়।$Q375$,
  $Q376$🚰 পানির কল/ভালভের মতো — একটি ছোট হাতের চাপ (Base কারেন্ট) দিয়ে বিশাল পানির প্রবাহ (Collector কারেন্ট) নিয়ন্ত্রণ করা যায়।$Q376$,
  $Q377$অডিও সিগন্যাল অ্যামপ্লিফিকেশন, ডিজিটাল সুইচিং সার্কিট, এবং পাওয়ার কন্ট্রোল সার্কিটে (রিলে ড্রাইভার) ব্যবহৃত হয়।$Q377$,
  $Q378$একটি NPN ট্রানজিস্টরের বেসে মাত্র 1mA কারেন্ট দিলে, β=100 হলে কালেক্টরে 100mA কারেন্ট প্রবাহিত হয় — এটাই অ্যামপ্লিফিকেশন।$Q378$,
  $Q379$I_C = β × I_B (β = current gain, সাধারণত 50-300), এবং I_E = I_B + I_C। Active region-এ কাজ করতে হলে Base-Emitter জাংশন ফরওয়ার্ড বায়াস ও Base-Collector জাংশন রিভার্স বায়াস থাকতে হয়।$Q379$,
  $Q380$অডিও অ্যামপ্লিফায়ার, রেডিও ট্রান্সমিটার, ডিজিটাল লজিক সার্কিট (পুরনো TTL), এবং মোটর ড্রাইভার সার্কিটে ব্যবহৃত হয়।$Q380$,
  ARRAY[$Q381$Transistor$Q381$,$Q382$Current Amplifier$Q382$,$Q383$Active Device$Q383$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q384$MOSFET$Q384$,
  $Q385$M$Q385$,
  $Q386$electronics$Q386$,
  $Q387$Sedra & Smith, Ch.5$Q387$,
  $Q388$critical$Q388$,
  $Q389$mosfet$Q389$,
  $Q390$ভোল্টেজ নিয়ন্ত্রিত সুইচিং/অ্যামপ্লিফায়িং ট্রানজিস্টর$Q390$,
  $Q391$MOSFET (Metal-Oxide-Semiconductor Field-Effect Transistor) একটি তিন-টার্মিনাল (Gate, Drain, Source) ভোল্টেজ-নিয়ন্ত্রিত ডিভাইস, যেখানে Gate-এ ভোল্টেজ প্রয়োগ করে Drain-Source-এর মধ্যকার কারেন্ট প্রবাহ নিয়ন্ত্রণ করা হয় — Gate প্রায় কোনো কারেন্ট টানে না।$Q391$,
  $Q392$🎚️ টাচ-সেন্সিটিভ ডিমার সুইচের মতো — শুধু আঙুল ছোঁয়ালেই (ভোল্টেজ প্রয়োগ) আলোর তীব্রতা (কারেন্ট) নিয়ন্ত্রিত হয়, কোনো যান্ত্রিক শক্তি (কারেন্ট) খরচ হয় না।$Q392$,
  $Q393$মাইক্রোপ্রসেসর ও মেমোরি চিপ ডিজাইন (CMOS), পাওয়ার সুইচিং (DC-DC কনভার্টার), এবং হাই-ইনপুট-ইমপিডেন্স অ্যামপ্লিফায়ারে ব্যবহৃত হয়।$Q393$,
  $Q394$আধুনিক CPU-তে বিলিয়ন বিলিয়ন MOSFET একসাথে সুইচ হিসেবে কাজ করে বাইনারি ০ ও ১ প্রক্রিয়া করে, যা কম্পিউটিং-এর ভিত্তি।$Q394$,
  $Q395$Saturation region-এ: I_D = k(V_GS − V_th)² (V_th = থ্রেশহোল্ড ভোল্টেজ)। MOSFET-এর Gate ইনসুলেটেড (অক্সাইড লেয়ার) হওয়ায় ইনপুট ইমপিডেন্স প্রায় অসীম, তাই স্ট্যাটিক পাওয়ার লস কম।$Q395$,
  $Q396$কম্পিউটার প্রসেসর ও RAM, মোবাইল ফোন চিপ, ইলেকট্রিক গাড়ির মোটর কন্ট্রোলার, এবং সোলার ইনভার্টারে ব্যবহৃত হয়।$Q396$,
  ARRAY[$Q397$Field-Effect Transistor$Q397$,$Q398$Voltage-Controlled$Q398$,$Q399$Switching$Q399$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q400$Operational Amplifier (Op-Amp)$Q400$,
  $Q401$O$Q401$,
  $Q402$electronics$Q402$,
  $Q403$Sedra & Smith, Ch.2$Q403$,
  $Q404$critical$Q404$,
  $Q405$opamp$Q405$,
  $Q406$অতি উচ্চ গেইনসম্পন্ন সর্বজনীন অ্যামপ্লিফায়ার IC$Q406$,
  $Q407$Operational Amplifier একটি উচ্চ-গেইন DC-কাপল্ড ডিফারেনশিয়াল অ্যামপ্লিফায়ার IC, যার দুটি ইনপুট (Inverting ও Non-inverting) এবং একটি আউটপুট থাকে — বাহ্যিক ফিডব্যাক রেজিস্ট্যান্স দিয়ে এর কার্যকারিতা (গেইন, ফিল্টার ইত্যাদি) নিয়ন্ত্রণ করা যায়।$Q407$,
  $Q408$⚖️ একটি অতি সংবেদনশীল দাঁড়িপাল্লার মতো — দুই পাল্লার (দুই ইনপুটের) সামান্যতম পার্থক্যও বিশাল আউটপুট তৈরি করে, তাই বাহ্যিক রেজিস্ট্যান্স দিয়ে একে 'বশে' রাখতে হয় (ফিডব্যাক)।$Q408$,
  $Q409$সিগন্যাল অ্যামপ্লিফিকেশন, অ্যানালগ ফিল্টার ডিজাইন, ভোল্টেজ কম্প্যারেটর, এবং ইন্সট্রুমেন্টেশন সার্কিটে (সেন্সর ইন্টারফেস) ব্যবহৃত হয়।$Q409$,
  $Q410$একটি Inverting Amplifier সার্কিটে R_f=10kΩ ও R_in=1kΩ ব্যবহার করলে গেইন হবে −10, অর্থাৎ 0.1V ইনপুট দিলে আউটপুটে −1V পাওয়া যাবে।$Q410$,
  $Q411$আদর্শ Op-Amp-এর জন্য দুটি নিয়ম: (১) দুই ইনপুট টার্মিনালের মধ্যে কারেন্ট প্রবাহ শূন্য, (২) ভার্চুয়াল শর্ট — V+ = V−। Inverting gain = −R_f/R_in; Non-inverting gain = 1 + R_f/R_in।$Q411$,
  $Q412$মেডিকেল ইকুইপমেন্ট (ECG অ্যামপ্লিফায়ার), অডিও মিক্সার, ওয়েদার স্টেশন সেন্সর সার্কিট, এবং অ্যানালগ কম্পিউটার সার্কিটে ব্যবহৃত হয়।$Q412$,
  ARRAY[$Q413$Amplifier IC$Q413$,$Q414$Feedback$Q414$,$Q415$Analog Design$Q415$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q416$Amplifier Gain$Q416$,
  $Q417$A$Q417$,
  $Q418$electronics$Q418$,
  $Q419$Sedra & Smith, Ch.1$Q419$,
  $Q420$critical$Q420$,
  $Q421$gauge$Q421$,
  $Q422$আউটপুট ও ইনপুট সিগন্যালের অনুপাত$Q422$,
  $Q423$Amplifier Gain হলো একটি অ্যামপ্লিফায়ারের আউটপুট সিগন্যালের (ভোল্টেজ, কারেন্ট বা পাওয়ার) সাথে ইনপুট সিগন্যালের অনুপাত, যা সাধারণত dB (ডেসিবেল) এককে প্রকাশ করা হয়।$Q423$,
  $Q424$🔊 মেগাফোনের মতো — মুখে বলা ছোট শব্দকে (ইনপুট) মেগাফোন বহুগুণে বড় করে (আউটপুট) দূরে পৌঁছে দেয়, এই বৃদ্ধির অনুপাতই গেইন।$Q424$,
  $Q425$অডিও সিস্টেম ডিজাইনে স্পিকার পাওয়ার নির্ধারণ, মাইক্রোফোন প্রি-অ্যামপ্লিফায়ার ডিজাইন, এবং সিগন্যাল চেইন বিশ্লেষণে ব্যবহৃত হয়।$Q425$,
  $Q426$একটি অ্যামপ্লিফায়ারে 10mV ইনপুট দিয়ে 1V আউটপুট পেলে ভোল্টেজ গেইন = 1/0.01 = 100 (বা 40 dB)।$Q426$,
  $Q427$A_v = V_out/V_in (ভোল্টেজ গেইন), Gain(dB) = 20log₁₀(V_out/V_in)। একাধিক স্টেজ ক্যাসকেড করলে মোট গেইন (dB-তে) প্রতিটি স্টেজের গেইনের যোগফল হয়।$Q427$,
  $Q428$হিয়ারিং এইড, মোবাইল ফোন মাইক্রোফোন সার্কিট, স্টেজ সাউন্ড সিস্টেম, এবং রেডিও রিসিভার সংবেদনশীলতা বৃদ্ধিতে ব্যবহৃত হয়।$Q428$,
  ARRAY[$Q429$Amplification$Q429$,$Q430$Decibel$Q430$,$Q431$Signal Processing$Q431$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q432$Biasing$Q432$,
  $Q433$B$Q433$,
  $Q434$electronics$Q434$,
  $Q435$Sedra & Smith, Ch.5$Q435$,
  $Q436$high$Q436$,
  $Q437$battery$Q437$,
  $Q438$ট্রানজিস্টরকে সঠিক অপারেটিং পয়েন্টে স্থাপন$Q438$,
  $Q439$Biasing হলো একটি DC ভোল্টেজ/কারেন্ট সরবরাহের প্রক্রিয়া, যা ট্রানজিস্টরকে তার সক্রিয় (active) অঞ্চলে একটি স্থিতিশীল অপারেটিং পয়েন্টে (Q-point) স্থাপন করে, যাতে এটি AC সিগন্যালকে বিকৃতি ছাড়াই অ্যামপ্লিফাই করতে পারে।$Q439$,
  $Q440$🎹 পিয়ানোর একটি চাবি অর্ধেক চাপে রাখার মতো — সম্পূর্ণ ছেড়ে দিলে বা সম্পূর্ণ চেপে ধরলে বাজানো যায় না, ঠিক মাঝামাঝি অবস্থানে (Q-point) রাখলেই উপরে-নিচে বাজানো (সিগন্যাল অ্যামপ্লিফাই) সম্ভব হয়।$Q440$,
  $Q441$অ্যামপ্লিফায়ার ডিজাইনে ট্রানজিস্টরকে সঠিক অপারেটিং পয়েন্টে রাখতে, এবং তাপমাত্রা পরিবর্তনেও স্থিতিশীল আচরণ নিশ্চিত করতে ব্যবহৃত হয়।$Q441$,
  $Q442$Voltage Divider Biasing পদ্ধতিতে দুটি রোধ দিয়ে বেসে একটি স্থির DC ভোল্টেজ তৈরি করা হয়, যা তাপমাত্রা পরিবর্তনেও Q-point স্থিতিশীল রাখে।$Q442$,
  $Q443$Q-point নির্ধারিত হয় I_C(Q) ও V_CE(Q) দ্বারা, যা DC Load Line-এর ওপর অবস্থিত। সঠিক বায়াসিং-এ Q-point Load Line-এর মাঝামাঝি থাকা উচিত সর্বোচ্চ সিমেট্রিক্যাল সুইং পেতে।$Q443$,
  $Q444$অডিও অ্যামপ্লিফায়ার ডিজাইন, RF ট্রান্সমিটার সার্কিট, এবং তাপমাত্রা-স্থিতিশীল ইলেকট্রনিক ডিভাইস ডিজাইনে ব্যবহৃত হয়।$Q444$,
  ARRAY[$Q445$Q-Point$Q445$,$Q446$DC Operating Point$Q446$,$Q447$Transistor Design$Q447$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q448$Common Emitter Amplifier$Q448$,
  $Q449$C$Q449$,
  $Q450$electronics$Q450$,
  $Q451$Sedra & Smith, Ch.5$Q451$,
  $Q452$medium$Q452$,
  $Q453$bjt$Q453$,
  $Q454$সর্বাধিক ব্যবহৃত ভোল্টেজ অ্যামপ্লিফায়ার কনফিগারেশন$Q454$,
  $Q455$Common Emitter Amplifier একটি BJT অ্যামপ্লিফায়ার কনফিগারেশন যেখানে Emitter টার্মিনাল ইনপুট ও আউটপুট উভয়ের জন্য কমন (সাধারণ), এটি উচ্চ ভোল্টেজ ও কারেন্ট গেইন দেয়, কিন্তু আউটপুট ইনপুটের সাপেক্ষে 180° ফেজ-শিফটেড (উল্টানো) থাকে।$Q455$,
  $Q456$🔄 একটি আয়নার মতো — ইনপুট সিগন্যাল বড় হয়ে ফিরে আসে ঠিকই, কিন্তু উল্টো দিকে (ফেজ ইনভার্টেড) — উপরে গেলে আউটপুট নিচে যায়।$Q456$,
  $Q457$অডিও প্রি-অ্যামপ্লিফায়ার, RF অ্যামপ্লিফায়ার স্টেজ, এবং সাধারণ সিগন্যাল অ্যামপ্লিফিকেশন সার্কিটে ব্যাপকভাবে ব্যবহৃত হয়।$Q457$,
  $Q458$গিটার প্রি-অ্যামপ্লিফায়ার সার্কিটে Common Emitter কনফিগারেশন ব্যবহার করে দুর্বল পিকআপ সিগন্যালকে শক্তিশালী করা হয় পরবর্তী স্টেজের জন্য।$Q458$,
  $Q459$Voltage Gain A_v ≈ −R_C/r_e (r_e = emitter-এর ছোট-সিগন্যাল রেজিস্ট্যান্স)। ঋণাত্মক চিহ্ন 180° ফেজ ইনভার্শন নির্দেশ করে। ইনপুট ইমপিডেন্স মাঝারি, আউটপুট ইমপিডেন্স তুলনামূলক বেশি।$Q459$,
  $Q460$রেডিও রিসিভার IF অ্যামপ্লিফায়ার, অডিও মিক্সিং কনসোল, এবং সেন্সর সিগন্যাল কন্ডিশনিং সার্কিটে ব্যবহৃত হয়।$Q460$,
  ARRAY[$Q461$Amplifier Configuration$Q461$,$Q462$Phase Inversion$Q462$,$Q463$BJT Circuit$Q463$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q464$Feedback (Negative Feedback)$Q464$,
  $Q465$F$Q465$,
  $Q466$electronics$Q466$,
  $Q467$Sedra & Smith, Ch.10$Q467$,
  $Q468$high$Q468$,
  $Q469$feedbackloop$Q469$,
  $Q470$আউটপুটের একাংশ ইনপুটে ফিরিয়ে স্থিতিশীলতা বৃদ্ধি$Q470$,
  $Q471$Negative Feedback হলো একটি কৌশল যেখানে অ্যামপ্লিফায়ারের আউটপুটের একটি অংশ ইনপুট সিগন্যালের বিপরীতমুখী (out of phase) করে ফিরিয়ে দেওয়া হয়, যার ফলে গেইন কিছুটা কমলেও স্থিতিশীলতা, ব্যান্ডউইথ ও লিনিয়ারিটি উল্লেখযোগ্যভাবে বৃদ্ধি পায়।$Q471$,
  $Q472$🌡️ থার্মোস্ট্যাট সিস্টেমের মতো — ঘর বেশি গরম হলে সিস্টেম নিজে থেকে ঠান্ডা করার কাজ শুরু করে (আউটপুট ফিরিয়ে ইনপুট সংশোধন), ফলে তাপমাত্রা সবসময় নিয়ন্ত্রিত থাকে।$Q472$,
  $Q473$অডিও অ্যামপ্লিফায়ারে distortion কমাতে, Op-Amp সার্কিটে গেইন নিয়ন্ত্রণ করতে, এবং তাপমাত্রা পরিবর্তনে স্থিতিশীল আউটপুট বজায় রাখতে ব্যবহৃত হয়।$Q473$,
  $Q474$একটি Op-Amp Inverting Amplifier-এ ফিডব্যাক রোধ (R_f) আউটপুটের একাংশ ইনভার্টিং ইনপুটে ফিরিয়ে দেয়, যা সঠিক ও পূর্বনির্ধারিত গেইন নিশ্চিত করে।$Q474$,
  $Q475$Closed-loop gain A_f = A/(1+Aβ), যেখানে A = open-loop gain, β = feedback factor। Aβ অনেক বড় হলে A_f ≈ 1/β, অর্থাৎ গেইন প্রায় সম্পূর্ণভাবে ফিডব্যাক নেটওয়ার্ক দ্বারা নির্ধারিত হয়, ট্রানজিস্টরের অস্থির প্যারামিটার নয়।$Q475$,
  $Q476$হাই-ফাই অডিও সিস্টেম, ভোল্টেজ রেগুলেটর IC, রোবোটিক্স মোটর কন্ট্রোল, এবং ইন্ডাস্ট্রিয়াল প্রসেস কন্ট্রোল সিস্টেমে ব্যবহৃত হয়।$Q476$,
  ARRAY[$Q477$Stability$Q477$,$Q478$Gain Control$Q478$,$Q479$Distortion Reduction$Q479$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q480$Frequency Response$Q480$,
  $Q481$F$Q481$,
  $Q482$electronics$Q482$,
  $Q483$Sedra & Smith, Ch.1$Q483$,
  $Q484$high$Q484$,
  $Q485$bode$Q485$,
  $Q486$কম্পাঙ্কের সাথে গেইনের পরিবর্তনের লেখচিত্র$Q486$,
  $Q487$Frequency Response হলো একটি সার্কিট বা সিস্টেমের গেইন (এবং ফেজ) ইনপুট সিগন্যালের কম্পাঙ্কের (frequency) সাথে কীভাবে পরিবর্তিত হয় তার বর্ণনা — এটি সাধারণত Bode Plot (dB vs log frequency) দিয়ে প্রদর্শন করা হয়।$Q487$,
  $Q488$🎧 হেডফোনের সাউন্ড কোয়ালিটির মতো — কিছু হেডফোন বেস (নিম্ন কম্পাঙ্ক) ভালো দেয়, কিছু ট্রেবল (উচ্চ কম্পাঙ্ক) ভালো দেয় — এই তারতম্যই ফ্রিকোয়েন্সি রেসপন্স।$Q488$,
  $Q489$অডিও ইকুয়ালাইজার ডিজাইন, ফিল্টার সার্কিট বিশ্লেষণ, এবং যোগাযোগ ব্যবস্থায় ব্যান্ডউইথ নির্ধারণে ব্যবহৃত হয়।$Q489$,
  $Q490$একটি অ্যামপ্লিফায়ারের ফ্রিকোয়েন্সি রেসপন্স গ্রাফে 20Hz থেকে 20kHz পর্যন্ত সমান গেইন (ফ্ল্যাট রেসপন্স) দেখালে বোঝা যায় এটি সব অডিও ফ্রিকোয়েন্সি সমানভাবে অ্যামপ্লিফাই করে।$Q490$,
  $Q491$Gain(dB) = 20log₁₀(V_out/V_in), X-অক্ষ log(frequency)। −3dB পয়েন্ট (যেখানে পাওয়ার অর্ধেক হয়) ব্যান্ডউইথের সীমানা নির্ধারণ করে।$Q491$,
  $Q492$অডিও ইকুয়ালাইজার ও স্পিকার ডিজাইন, বায়োমেডিকেল সিগন্যাল প্রসেসিং যন্ত্র, এবং যোগাযোগ সিস্টেমের চ্যানেল ডিজাইনে ব্যবহৃত হয়।$Q492$,
  ARRAY[$Q493$Bode Plot$Q493$,$Q494$Bandwidth$Q494$,$Q495$AC Analysis$Q495$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q496$Cutoff Frequency$Q496$,
  $Q497$C$Q497$,
  $Q498$electronics$Q498$,
  $Q499$Sedra & Smith, Ch.1$Q499$,
  $Q500$medium$Q500$,
  $Q501$filter$Q501$,
  $Q502$গেইন ৭০.৭% এ নেমে যাওয়ার কম্পাঙ্ক সীমা$Q502$,
  $Q503$Cutoff Frequency (f_c) হলো সেই কম্পাঙ্ক, যেখানে সার্কিটের আউটপুট পাওয়ার তার সর্বোচ্চ মানের অর্ধেকে (বা ভোল্টেজ গেইন 0.707 বা −3dB এ) নেমে আসে — এটি একটি ফিল্টার বা অ্যামপ্লিফায়ারের কার্যকর ব্যান্ডউইথের সীমানা চিহ্নিত করে।$Q503$,
  $Q504$🏔️ পাহাড়ের বেস ক্যাম্পের মতো — এই বিন্দু পর্যন্ত সব সুবিধা (পূর্ণ গেইন) পাওয়া যায়, এরপর ধীরে ধীরে সুবিধা কমতে থাকে (গেইন হ্রাস)।$Q504$,
  $Q505$লো-পাস ও হাই-পাস ফিল্টার ডিজাইন, অডিও ক্রসওভার নেটওয়ার্ক (স্পিকারে বেস/ট্রেবল ভাগ করা), এবং যোগাযোগ চ্যানেল ডিজাইনে ব্যবহৃত হয়।$Q505$,
  $Q506$একটি সাধারণ RC লো-পাস ফিল্টারে R=1.6kΩ ও C=1000pF হলে, f_c = 1/(2πRC) ≈ 100kHz-এর ওপরের সিগন্যাল ক্রমশ দুর্বল হয়ে যাবে।$Q506$,
  $Q507$RC ফিল্টারে f_c = 1/(2πRC)। এই কম্পাঙ্কে X_C = R, এবং আউটপুট পাওয়ার ইনপুটের অর্ধেক (−3dB) হয়ে যায়।$Q507$,
  $Q508$স্পিকার ক্রসওভার নেটওয়ার্ক, রেডিও রিসিভার চ্যানেল সিলেকশন, এবং বায়োমেডিকেল সেন্সরের নয়েজ ফিল্টারে ব্যবহৃত হয়।$Q508$,
  ARRAY[$Q509$Filter Design$Q509$,$Q510$-3dB Point$Q510$,$Q511$Bandwidth Limit$Q511$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q512$Differential Amplifier$Q512$,
  $Q513$D$Q513$,
  $Q514$electronics$Q514$,
  $Q515$Sedra & Smith, Ch.8$Q515$,
  $Q516$medium$Q516$,
  $Q517$opamp$Q517$,
  $Q518$দুই সিগন্যালের পার্থক্য অ্যামপ্লিফাইকারী সার্কিট$Q518$,
  $Q519$Differential Amplifier দুটি ইনপুট সিগন্যালের মধ্যকার পার্থক্যকে অ্যামপ্লিফাই করে এবং সাধারণ (কমন) অংশকে দমন করে — এটি Op-Amp ও ইনস্ট্রুমেন্টেশন সার্কিটের একটি মৌলিক বিল্ডিং ব্লক।$Q519$,
  $Q520$⚖️ একটি ওজন পরিমাপক দাঁড়িপাল্লার মতো — দুই পাশের সাধারণ ওজন (কমন সিগন্যাল, যেমন নয়েজ) বাদ দিয়ে শুধু পার্থক্যটুকু (প্রকৃত সিগন্যাল) দেখায়।$Q520$,
  $Q521$মেডিকেল সিগন্যাল অ্যামপ্লিফিকেশন (ECG, EEG), সেন্সর ব্রিজ সার্কিট আউটপুট রিড করতে, এবং নয়েজ-প্রতিরোধী যোগাযোগে ব্যবহৃত হয়।$Q521$,
  $Q522$ECG মেশিনে শরীরের সিগন্যাল খুবই দুর্বল কিন্তু আশেপাশে প্রচুর বৈদ্যুতিক নয়েজ থাকে — Differential Amplifier শুধু হৃদস্পন্দনের পার্থক্য সিগন্যাল বের করে নয়েজ বাতিল করে দেয়।$Q522$,
  $Q523$V_out = A_d(V₁−V₂) + A_cm×V_cm, যেখানে A_d = differential gain (বড়), A_cm = common-mode gain (ছোট হওয়া উচিত)। CMRR = A_d/A_cm যত বেশি, নয়েজ দমন তত ভালো।$Q523$,
  $Q524$হাসপাতালের ECG ও EEG মেশিন, স্ট্রেইন গেজ ব্রিজ সেন্সর সার্কিট, এবং অডিও মাইক্রোফোন প্রিঅ্যামপ্লিফায়ারে ব্যবহৃত হয়।$Q524$,
  ARRAY[$Q525$CMRR$Q525$,$Q526$Noise Rejection$Q526$,$Q527$Instrumentation$Q527$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q528$Oscillator$Q528$,
  $Q529$O$Q529$,
  $Q530$electronics$Q530$,
  $Q531$Sedra & Smith, Ch.17$Q531$,
  $Q532$medium$Q532$,
  $Q533$wavesine$Q533$,
  $Q534$স্থায়ী পর্যায়ক্রমিক সিগন্যাল তৈরিকারী সার্কিট$Q534$,
  $Q535$Oscillator একটি ইলেকট্রনিক সার্কিট যা বাহ্যিক AC ইনপুট ছাড়াই একটি স্থিতিশীল, পুনরাবৃত্তমূলক (periodic) সিগন্যাল (সাইন, স্কয়ার বা ট্রায়াঙ্গুলার ওয়েভ) উৎপন্ন করে — এটি positive feedback ব্যবহার করে কাজ করে।$Q535$,
  $Q536$🎸 একটি দোলনার মতো — একবার সঠিক ধাক্কা (স্টার্ট-আপ শর্ত) দিলে, সঠিক সময়ে সঠিক পরিমাণ শক্তি (positive feedback) যোগ করলে এটি নিজে থেকেই স্থায়ীভাবে দুলতে থাকে।$Q536$,
  $Q537$ঘড়ি ও মাইক্রোপ্রসেসরের ক্লক সিগন্যাল তৈরি, রেডিও ট্রান্সমিটার ক্যারিয়ার ওয়েভ উৎপাদন, এবং সিগন্যাল জেনারেটর সার্কিটে ব্যবহৃত হয়।$Q537$,
  $Q538$কম্পিউটারের মাদারবোর্ডে একটি ক্রিস্টাল অসিলেটর (সাধারণত 4-33 MHz) CPU-কে নিয়মিত টাইমিং পালস সরবরাহ করে, যা সব প্রসেসিং সিঙ্ক্রোনাইজ করে।$Q538$,
  $Q539$Barkhausen Criterion অনুযায়ী oscillation-এর শর্ত: Loop gain Aβ = 1 (magnitude) এবং phase shift = 0° (বা 360°-এর গুণিতক)। ক্রিস্টাল অসিলেটরে f = 1/(2π√(LC))।$Q539$,
  $Q540$কম্পিউটার ক্লক জেনারেটর, রেডিও ও টিভি ট্রান্সমিটার, ডিজিটাল ঘড়ি (কোয়ার্টজ ক্রিস্টাল), এবং সিগন্যাল টেস্টিং যন্ত্রে ব্যবহৃত হয়।$Q540$,
  ARRAY[$Q541$Signal Generation$Q541$,$Q542$Positive Feedback$Q542$,$Q543$Clock Circuit$Q543$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q544$Clipper & Clamper Circuit$Q544$,
  $Q545$C$Q545$,
  $Q546$electronics$Q546$,
  $Q547$Sedra & Smith, Ch.4$Q547$,
  $Q548$low$Q548$,
  $Q549$diode$Q549$,
  $Q550$সিগন্যালের অংশ কাটা বা স্তর সরানোর সার্কিট$Q550$,
  $Q551$Clipper Circuit সিগন্যালের একটি নির্দিষ্ট অংশ (ভোল্টেজ লেভেলের ওপরে বা নিচে) কেটে ফেলে, আর Clamper Circuit সম্পূর্ণ সিগন্যালের আকৃতি অপরিবর্তিত রেখে শুধু তার DC রেফারেন্স লেভেল ওপরে বা নিচে সরিয়ে দেয় — উভয়ই ডায়োড ব্যবহার করে কাজ করে।$Q551$,
  $Q552$✂️ Clipper হলো ছবি ক্রপ করার মতো (একটি অংশ কেটে বাদ দেওয়া), আর Clamper হলো পুরো ছবিটাকে উপরে-নিচে সরিয়ে নেওয়ার মতো (আকৃতি একই থাকে, শুধু অবস্থান বদলায়)।$Q552$,
  $Q553$সিগন্যাল প্রোটেকশন (ওভার-ভোল্টেজ থেকে সার্কিট রক্ষা), ওয়েভফর্ম শেপিং, এবং টিভি সিগন্যালে DC রিস্টোরেশনে ব্যবহৃত হয়।$Q553$,
  $Q554$পুরনো টিভি সিগন্যালে Clamper সার্কিট ব্যবহার করে ভিডিও সিগন্যালের সিঙ্ক পালসকে একটি নির্দিষ্ট রেফারেন্স লেভেলে ধরে রাখা হতো, যাতে ছবি স্থিতিশীল থাকে।$Q554$,
  $Q555$Clipper-এ ডায়োড রেফারেন্স ভোল্টেজের সাথে সিরিজ/প্যারালালে বসানো হয় যা নির্দিষ্ট লেভেলের ওপরে কাটে (V_out ≤ V_ref)। Clamper-এ একটি ক্যাপাসিটর ও ডায়োড মিলে DC লেভেল শিফট করে, কিন্তু peak-to-peak amplitude অপরিবর্তিত থাকে।$Q555$,
  $Q556$সিগন্যাল প্রোটেকশন সার্কিট (ইনপুট ভোল্টেজ সীমিতকরণ), পুরনো অ্যানালগ টিভি রিসিভার, এবং ওয়েভফর্ম জেনারেটর টেস্টিং সার্কিটে ব্যবহৃত হয়।$Q556$,
  ARRAY[$Q557$Waveform Shaping$Q557$,$Q558$Diode Application$Q558$,$Q559$Signal Protection$Q559$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q560$Load Line$Q560$,
  $Q561$L$Q561$,
  $Q562$electronics$Q562$,
  $Q563$Sedra & Smith, Ch.5$Q563$,
  $Q564$medium$Q564$,
  $Q565$gauge$Q565$,
  $Q566$ট্রানজিস্টরের অপারেটিং সীমা নির্দেশক রেখা$Q566$,
  $Q567$Load Line একটি সরলরেখা যা ট্রানজিস্টরের I-V ক্যারেক্টারিস্টিক কার্ভের ওপর সার্কিটের বাহ্যিক সাপ্লাই ভোল্টেজ ও লোড রেজিস্ট্যান্স দ্বারা নির্ধারিত সব সম্ভাব্য অপারেটিং পয়েন্ট (I_C, V_CE) দেখায় — এই রেখা ও ক্যারেক্টারিস্টিক কার্ভের ছেদবিন্দুই প্রকৃত Q-point।$Q567$,
  $Q568$🎯 একটি খেলার মাঠের সীমানার মতো — খেলোয়াড় (অপারেটিং পয়েন্ট) মাঠের বাইরে যেতে পারে না, সীমানার মধ্যেই থেকে খেলতে হয়, আর Load Line সেই সীমানা নির্ধারণ করে।$Q568$,
  $Q569$অ্যামপ্লিফায়ার ডিজাইনে Q-point গ্রাফিক্যালি নির্ধারণ, এবং ট্রানজিস্টরের সর্বোচ্চ নিরাপদ অপারেটিং রেঞ্জ যাচাই করতে ব্যবহৃত হয়।$Q569$,
  $Q570$একটি সার্কিটে V_CC=10V ও R_C=1kΩ হলে, Load Line-এর দুই প্রান্ত হবে V_CE=10V (I_C=0, cutoff) এবং I_C=10mA (V_CE=0, saturation) — এই দুই বিন্দু যোগ করলেই Load Line পাওয়া যায়।$Q570$,
  $Q571$DC Load Line সমীকরণ: I_C = (V_CC − V_CE)/R_C। এই রেখা ও ট্রানজিস্টরের আউটপুট ক্যারেক্টারিস্টিক কার্ভের ছেদবিন্দুতে প্রকৃত Q-point (I_CQ, V_CEQ) পাওয়া যায়।$Q571$,
  $Q572$অ্যামপ্লিফায়ার ডিজাইন যাচাই, পাওয়ার ট্রানজিস্টর সিলেকশন, এবং ট্রানজিস্টর ডেটাশিট বিশ্লেষণে গ্রাফিক্যাল টুল হিসেবে ব্যবহৃত হয়।$Q572$,
  ARRAY[$Q573$Q-Point$Q573$,$Q574$Graphical Analysis$Q574$,$Q575$Transistor Characteristics$Q575$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q576$Small-Signal Model$Q576$,
  $Q577$S$Q577$,
  $Q578$electronics$Q578$,
  $Q579$Sedra & Smith, Ch.5$Q579$,
  $Q580$medium$Q580$,
  $Q581$circuit$Q581$,
  $Q582$ছোট AC সিগন্যালের জন্য সরলীকৃত ট্রানজিস্টর মডেল$Q582$,
  $Q583$Small-Signal Model হলো একটি রৈখিক (linear) সমতুল্য সার্কিট যা ট্রানজিস্টরের অ-রৈখিক আচরণকে Q-point-এর চারপাশে ছোট AC সিগন্যালের জন্য সরলীকৃত করে (রেজিস্টর ও নির্ভরশীল সোর্স দিয়ে) প্রকাশ করে, যা হাতে-কলমে AC বিশ্লেষণ সহজ করে।$Q583$,
  $Q584$🔬 একটি ম্যাপের ছোট অংশকে জুম করার মতো — বড় জটিল মানচিত্রের (পুরো I-V কার্ভ) একটি ছোট অংশকে (Q-point-এর কাছে) প্রায় সরলরেখা (লিনিয়ার) হিসেবে ধরে নেওয়া যায়, যা হিসাব সহজ করে।$Q584$,
  $Q585$অ্যামপ্লিফায়ারের ভোল্টেজ গেইন, ইনপুট ও আউটপুট ইমপিডেন্স হাতে-কলমে হিসাব করতে ব্যবহৃত হয়, বিশেষত সার্কিট সিমুলেশনের আগে দ্রুত যাচাইয়ের জন্য।$Q585$,
  $Q586$BJT-এর জন্য Hybrid-π মডেলে ট্রানজিস্টরকে একটি ইনপুট রেজিস্ট্যান্স (r_π) এবং একটি ভোল্টেজ-নিয়ন্ত্রিত কারেন্ট সোর্স (g_m×v_π) দিয়ে প্রতিস্থাপন করে সহজে গেইন হিসাব করা যায়।$Q586$,
  $Q587$BJT-তে transconductance g_m = I_C/V_T (V_T ≈ 26mV at room temp), এবং r_π = β/g_m। MOSFET-এ g_m = 2I_D/(V_GS−V_th)। এই প্যারামিটারগুলো দিয়ে গেইন সূত্র তৈরি হয়।$Q587$,
  $Q588$সার্কিট সিমুলেশন সফটওয়্যারের অভ্যন্তরীণ গণনা, RF অ্যামপ্লিফায়ার ডিজাইন, এবং একাডেমিক সার্কিট বিশ্লেষণে ব্যাপকভাবে ব্যবহৃত হয়।$Q588$,
  ARRAY[$Q589$Linear Approximation$Q589$,$Q590$Hybrid-π Model$Q590$,$Q591$AC Analysis$Q591$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q592$Darlington Pair$Q592$,
  $Q593$D$Q593$,
  $Q594$electronics$Q594$,
  $Q595$Sedra & Smith, Ch.6$Q595$,
  $Q596$low$Q596$,
  $Q597$bjt$Q597$,
  $Q598$অতি উচ্চ কারেন্ট গেইনের জন্য দুটি ট্রানজিস্টরের সংযোগ$Q598$,
  $Q599$Darlington Pair হলো দুটি BJT ট্রানজিস্টরের একটি সংযোগ, যেখানে প্রথমটির Emitter দ্বিতীয়টির Base-এ যুক্ত থাকে, ফলে সামগ্রিক কারেন্ট গেইন দুটি পৃথক গেইনের গুণফলের প্রায় সমান হয় — একটি অতি উচ্চ কারেন্ট গেইনসম্পন্ন 'সুপার-ট্রানজিস্টর' তৈরি হয়।$Q599$,
  $Q600$🔊🔊 দুটি মেগাফোন একটার পর একটা লাগানোর মতো — প্রথমটি ছোট শব্দকে বড় করে, দ্বিতীয়টি সেই বড় শব্দকে আরও বহুগুণ বড় করে — চূড়ান্ত ফলাফল অবিশ্বাস্য রকম জোরালো।$Q600$,
  $Q601$উচ্চ কারেন্ট প্রয়োজন এমন লোড (মোটর, রিলে, সোলেনয়েড) ড্রাইভ করতে দুর্বল কন্ট্রোল সিগন্যাল দিয়ে ব্যবহৃত হয়।$Q601$,
  $Q602$একটি মাইক্রোকন্ট্রোলারের পিন থেকে মাত্র কয়েক mA কারেন্ট দিয়ে Darlington Pair ব্যবহার করে একটি বড় DC মোটর (কয়েক amp প্রয়োজন) সরাসরি চালানো সম্ভব।$Q602$,
  $Q603$β_total ≈ β₁ × β₂ (দুই ট্রানজিস্টরের গেইনের গুণফল)। যদি β₁=β₂=100 হয়, তাহলে β_total ≈ 10,000, কিন্তু V_BE(total) = V_BE1 + V_BE2 ≈ 1.4V।$Q603$,
  $Q604$রোবোটিক্স মোটর ড্রাইভার, অডিও পাওয়ার অ্যামপ্লিফায়ার আউটপুট স্টেজ, এবং টাচ-সেন্সিটিভ সুইচ সার্কিটে ব্যবহৃত হয়।$Q604$,
  ARRAY[$Q605$Current Gain$Q605$,$Q606$Transistor Pair$Q606$,$Q607$High-Gain Circuit$Q607$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q608$Voltage Regulator$Q608$,
  $Q609$V$Q609$,
  $Q610$electronics$Q610$,
  $Q611$Sedra & Smith, Ch.4$Q611$,
  $Q612$high$Q612$,
  $Q613$chip$Q613$,
  $Q614$স্থির আউটপুট ভোল্টেজ বজায় রাখা সার্কিট$Q614$,
  $Q615$Voltage Regulator একটি সার্কিট বা IC যা ইনপুট ভোল্টেজ বা লোড কারেন্ট পরিবর্তিত হলেও আউটপুটে একটি নির্দিষ্ট, স্থির ভোল্টেজ বজায় রাখে — এটি Linear (যেমন 7805) বা Switching (যেমন Buck Converter) ধরনের হতে পারে।$Q615$,
  $Q616$🚰 পানির ট্যাংকের প্রেসার কন্ট্রোলারের মতো — উৎসের চাপ (ইনপুট ভোল্টেজ) ওঠানামা করলেও, বাড়িতে সরবরাহকৃত পানির চাপ (আউটপুট ভোল্টেজ) সবসময় সমান রাখে।$Q616$,
  $Q617$মোবাইল ফোন ও কম্পিউটার পাওয়ার সাপ্লাই, মাইক্রোকন্ট্রোলার সার্কিটে স্থির 3.3V/5V সরবরাহ, এবং ব্যাটারি-চালিত ডিভাইসে ব্যবহৃত হয়।$Q617$,
  $Q618$একটি 7805 IC ব্যবহার করে 9V ব্যাটারি থেকে স্থির 5V আউটপুট পাওয়া যায়, যা আরডুইনো বা অন্য মাইক্রোকন্ট্রোলার চালাতে ব্যবহৃত হয়।$Q618$,
  $Q619$Linear Regulator-এ: V_out = নির্দিষ্ট ও স্থির, অতিরিক্ত ভোল্টেজ তাপ হিসেবে অপচয় হয় (P_loss = (V_in−V_out)×I_load), তাই দক্ষতা কম। Switching Regulator-এ PWM ব্যবহার করে দক্ষতা ৯০%+ পাওয়া যায়।$Q619$,
  $Q620$মোবাইল চার্জার, ল্যাপটপ পাওয়ার অ্যাডাপ্টার, সোলার চার্জ কন্ট্রোলার, এবং গাড়ির ইলেকট্রনিক সিস্টেমে ব্যবহৃত হয়।$Q620$,
  ARRAY[$Q621$Power Supply$Q621$,$Q622$Linear Regulator$Q622$,$Q623$Switching Regulator$Q623$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q624$CMOS$Q624$,
  $Q625$C$Q625$,
  $Q626$electronics$Q626$,
  $Q627$Sedra & Smith, Ch.7$Q627$,
  $Q628$high$Q628$,
  $Q629$chip$Q629$,
  $Q630$কম-পাওয়ার ডিজিটাল সার্কিট প্রযুক্তি$Q630$,
  $Q631$CMOS (Complementary Metal-Oxide-Semiconductor) একটি প্রযুক্তি যেখানে NMOS ও PMOS ট্রানজিস্টর একসাথে জোড়ায় ব্যবহার করে লজিক গেট তৈরি করা হয় — স্টেডি-স্টেটে একটি ট্রানজিস্টর সবসময় বন্ধ থাকায় স্ট্যাটিক পাওয়ার খরচ প্রায় শূন্য।$Q631$,
  $Q632$🚪🚪 দুটি দরজার মধ্যে একটি খোলা ও অন্যটি বন্ধ রাখার সিস্টেমের মতো — কখনোই দুটো দরজাই একসাথে খোলা থাকে না, ফলে সরাসরি 'শর্টকাট' (কারেন্ট লিকেজ) হয় না, শক্তি সাশ্রয় হয়।$Q632$,
  $Q633$স্মার্টফোন প্রসেসর, কম্পিউটার RAM/CPU, এবং ব্যাটারি-চালিত সব ডিজিটাল ডিভাইসে বহুল ব্যবহৃত প্রযুক্তি।$Q633$,
  $Q634$একটি CMOS ইনভার্টার (NOT গেট)-এ ইনপুট HIGH হলে NMOS অন ও PMOS অফ হয় (আউটপুট LOW), ইনপুট LOW হলে উল্টো হয় (আউটপুট HIGH) — কখনোই দুটোই একসাথে অন হয় না।$Q634$,
  $Q635$Static power ≈ 0 (আদর্শ অবস্থায়), Dynamic power P = C×V²×f (C = ক্যাপাসিট্যান্স, V = সাপ্লাই ভোল্টেজ, f = সুইচিং ফ্রিকোয়েন্সি)। কম ভোল্টেজ ও কম ফ্রিকোয়েন্সিতে পাওয়ার খরচ কমে।$Q635$,
  $Q636$স্মার্টফোন ও ল্যাপটপ প্রসেসর, ডিজিটাল ক্যামেরা সেন্সর (CMOS ইমেজ সেন্সর), এবং IoT ডিভাইসের লো-পাওয়ার চিপ ডিজাইনে ব্যবহৃত হয়।$Q636$,
  ARRAY[$Q637$Digital IC$Q637$,$Q638$Low Power$Q638$,$Q639$NMOS-PMOS$Q639$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q640$Per Unit System$Q640$,
  $Q641$P$Q641$,
  $Q642$power$Q642$,
  $Q643$Stevenson & Sadat, Ch.3$Q643$,
  $Q644$critical$Q644$,
  $Q645$gauge$Q645$,
  $Q646$পাওয়ার সিস্টেম বিশ্লেষণের স্বাভাবিকীকৃত একক পদ্ধতি$Q646$,
  $Q647$Per Unit System হলো একটি পদ্ধতি যেখানে ভোল্টেজ, কারেন্ট, পাওয়ার ও ইমপিডেন্সের প্রকৃত মানকে একটি নির্বাচিত বেস মানের অনুপাত হিসেবে প্রকাশ করা হয় — এটি বিভিন্ন ভোল্টেজ লেভেলের ট্রান্সফরমার সংযুক্ত সিস্টেম বিশ্লেষণ সহজ করে।$Q647$,
  $Q648$💱 বিভিন্ন দেশের মুদ্রাকে ডলারে রূপান্তরের মতো — টাকা, রুপি, ইউরো আলাদা আলাদা হিসাব করার বদলে সবকিছু একই একক (ডলার/পার-ইউনিট) এ রূপান্তর করলে তুলনা ও হিসাব অনেক সহজ হয়ে যায়।$Q648$,
  $Q649$একাধিক ভোল্টেজ লেভেল (11kV, 132kV, 400kV) সম্বলিত পাওয়ার গ্রিডে লোড ফ্লো ও ফল্ট বিশ্লেষণ সহজ করতে ব্যবহৃত হয়, ট্রান্সফরমার টার্নস রেশিও বারবার হিসাবের প্রয়োজন হয় না।$Q649$,
  $Q650$যদি বেস ভোল্টেজ 132kV এবং প্রকৃত ভোল্টেজ 125.4kV হয়, তাহলে Per Unit ভোল্টেজ = 125.4/132 = 0.95 pu।$Q650$,
  $Q651$Actual Value = Per Unit Value × Base Value। Base impedance Z_base = (V_base)²/S_base। বেস পাওয়ার (S_base) সাধারণত পুরো সিস্টেমে একই রাখা হয়, বেস ভোল্টেজ প্রতিটি জোনে ট্রান্সফরমার রেশিও অনুযায়ী পরিবর্তিত হয়।$Q651$,
  $Q652$পাওয়ার গ্রিড লোড ফ্লো স্টাডি, শর্ট সার্কিট বিশ্লেষণ, এবং প্রোটেকশন রিলে সেটিং ক্যালকুলেশনে ব্যাপকভাবে ব্যবহৃত হয়।$Q652$,
  ARRAY[$Q653$Base Quantities$Q653$,$Q654$Power System Analysis$Q654$,$Q655$Normalization$Q655$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q656$Transmission Line$Q656$,
  $Q657$T$Q657$,
  $Q658$power$Q658$,
  $Q659$Stevenson & Sadat, Ch.4$Q659$,
  $Q660$critical$Q660$,
  $Q661$tower$Q661$,
  $Q662$উচ্চ-ভোল্টেজে বিদ্যুৎ পরিবহনের সঞ্চালন লাইন$Q662$,
  $Q663$Transmission Line হলো উচ্চ-ভোল্টেজ বৈদ্যুতিক পরিবাহী তার, যা পাওয়ার প্ল্যান্ট থেকে সাবস্টেশন পর্যন্ত দীর্ঘ দূরত্বে বিদ্যুৎ শক্তি পরিবহন করে — এর রেজিস্ট্যান্স (R), ইন্ডাক্ট্যান্স (L), ক্যাপাসিট্যান্স (C) ও কন্ডাক্ট্যান্স (G) বিতরণকৃত প্যারামিটার হিসেবে বিবেচিত হয়।$Q663$,
  $Q664$🛣️ একটি হাইওয়ের মতো — শহরের বাইরে থেকে (পাওয়ার প্ল্যান্ট) শহরে (লোড সেন্টার) মালামাল (বিদ্যুৎ) পৌঁছাতে যেমন প্রশস্ত ও উঁচু গতির রাস্তা দরকার, তেমনি বিদ্যুৎ পরিবহনে উচ্চ ভোল্টেজ লাইন প্রয়োজন যাতে লস কম হয়।$Q664$,
  $Q665$পাওয়ার প্ল্যান্ট থেকে শহরে বিদ্যুৎ সরবরাহ, আন্তঃআঞ্চলিক গ্রিড সংযোগ, এবং নবায়নযোগ্য শক্তি কেন্দ্র থেকে গ্রিডে বিদ্যুৎ যুক্ত করতে ব্যবহৃত হয়।$Q665$,
  $Q666$বাংলাদেশে 230kV ও 400kV ট্রান্সমিশন লাইন দিয়ে বড় পাওয়ার প্ল্যান্ট থেকে বিভিন্ন গ্রিড সাবস্টেশনে বিদ্যুৎ সরবরাহ করা হয়, যা পরে ডিস্ট্রিবিউশন লাইনে নামানো হয়।$Q666$,
  $Q667$উচ্চ ভোল্টেজে কম কারেন্টে একই পাওয়ার (P=VI) পরিবহন করা যায়, ফলে I²R লস (তাপ অপচয়) কমে যায় — এই কারণেই দীর্ঘ দূরত্বে অতি উচ্চ ভোল্টেজ ব্যবহার করা হয়।$Q667$,
  $Q668$জাতীয় বিদ্যুৎ গ্রিড নেটওয়ার্ক, HVDC (High Voltage DC) আন্তর্জাতিক সংযোগ, এবং অফশোর উইন্ড ফার্ম থেকে বিদ্যুৎ সংগ্রহে ব্যবহৃত হয়।$Q668$,
  ARRAY[$Q669$Power Transmission$Q669$,$Q670$HV Line$Q670$,$Q671$Grid Infrastructure$Q671$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q672$Load Flow Analysis$Q672$,
  $Q673$L$Q673$,
  $Q674$power$Q674$,
  $Q675$Stevenson & Sadat, Ch.9$Q675$,
  $Q676$high$Q676$,
  $Q677$network$Q677$,
  $Q678$গ্রিডের ভোল্টেজ ও পাওয়ার প্রবাহ গণনা পদ্ধতি$Q678$,
  $Q679$Load Flow Analysis (Power Flow Study) হলো একটি পদ্ধতি যা স্টেডি-স্টেট অবস্থায় পাওয়ার সিস্টেমের প্রতিটি বাসের (bus) ভোল্টেজ ম্যাগনিচিউড, ফেজ অ্যাঙ্গেল এবং প্রতিটি লাইনে প্রবাহিত রিয়েল ও রিয়্যাক্টিভ পাওয়ার নির্ণয় করে — সাধারণত Gauss-Seidel বা Newton-Raphson পদ্ধতিতে সমাধান করা হয়।$Q679$,
  $Q680$🩺 শরীরের স্বাস্থ্য পরীক্ষার মতো — যেমন ডাক্তার রক্তচাপ, হার্টবিট বিভিন্ন জায়গায় মেপে শরীরের সামগ্রিক অবস্থা বোঝেন, তেমনি Load Flow প্রতিটি বাসে ভোল্টেজ মেপে পুরো গ্রিডের 'স্বাস্থ্য' যাচাই করে।$Q680$,
  $Q681$নতুন পাওয়ার প্ল্যান্ট বা লাইন গ্রিডে যুক্ত করার আগে ভোল্টেজ স্ট্যাবিলিটি যাচাই, এবং দৈনন্দিন গ্রিড অপারেশন প্ল্যানিং-এ ব্যবহৃত হয়।$Q681$,
  $Q682$একটি নতুন শিল্প এলাকা গ্রিডে যুক্ত করার আগে Load Flow Analysis চালিয়ে দেখা হয় কোনো বাসের ভোল্টেজ নিরাপদ সীমার (সাধারণত ±৫%) বাইরে যাচ্ছে কিনা।$Q682$,
  $Q683$প্রতিটি বাসে Power Balance সমীকরণ: P_i = ΣV_iV_j(G_ij cos θ_ij + B_ij sin θ_ij)। চার ধরনের বাস থাকে: Slack, PV (generator), ও PQ (load) বাস, যাদের জানা ও অজানা ভেরিয়েবল ভিন্ন।$Q683$,
  $Q684$জাতীয় গ্রিড অপারেশন সেন্টার, নতুন সাবস্টেশন প্ল্যানিং, এবং স্মার্ট গ্রিড রিয়েল-টাইম মনিটরিং সিস্টেমে ব্যবহৃত হয়।$Q684$,
  ARRAY[$Q685$Power Flow$Q685$,$Q686$Newton-Raphson$Q686$,$Q687$Grid Planning$Q687$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q688$Three-Phase System$Q688$,
  $Q689$T$Q689$,
  $Q690$power$Q690$,
  $Q691$Stevenson & Sadat, Ch.2$Q691$,
  $Q692$critical$Q692$,
  $Q693$phasor$Q693$,
  $Q694$১২০° ফেজ পার্থক্যযুক্ত তিন AC সাপ্লাই$Q694$,
  $Q695$Three-Phase System হলো একটি AC পাওয়ার সাপ্লাই ব্যবস্থা, যেখানে তিনটি সাইনুসয়েডাল ভোল্টেজ সোর্স একই ম্যাগনিচিউড কিন্তু পরস্পর থেকে ১২০° ফেজ ব্যবধানে থাকে — এটি একক-ফেজের তুলনায় বেশি দক্ষ ও স্থির পাওয়ার সরবরাহ দেয়।$Q695$,
  $Q696$🚴 তিনজন সাইকেল আরোহীর মতো, যারা একই গতিতে চলছে কিন্তু প্যাডেলিং-এর তাল ১২০° করে আলাদা — যখন একজনের পায়ের শক্তি সর্বনিম্ন, তখন অন্যরা পূরণ করে, ফলে সামগ্রিক গতি (পাওয়ার) সবসময় স্থির (constant) থাকে।$Q696$,
  $Q697$শিল্প কারখানার ভারী মোটর চালানো, জাতীয় গ্রিড পাওয়ার ট্রান্সমিশন, এবং বড় বিল্ডিং-এর পাওয়ার ডিস্ট্রিবিউশনে ব্যবহৃত হয়।$Q697$,
  $Q698$বাংলাদেশের শিল্প কারখানায় 3-phase 400V সাপ্লাই দিয়ে বড় ইন্ডাকশন মোটর চালানো হয়, কারণ single-phase-এ এত বড় মোটর কার্যকরভাবে স্টার্ট করা কঠিন।$Q698$,
  $Q699$Balanced 3-phase system-এ instantaneous total power সবসময় constant থাকে (single-phase-এর মতো pulsating নয়)। Star (Y) সংযোগে: V_line = √3 × V_phase; Delta (Δ) সংযোগে: I_line = √3 × I_phase।$Q699$,
  $Q700$শিল্প কারখানার ভারী মেশিনারি, বৈদ্যুতিক পাওয়ার গ্রিড ট্রান্সমিশন, ডেটা সেন্টার পাওয়ার ডিস্ট্রিবিউশন, এবং বড় HVAC সিস্টেমে ব্যবহৃত হয়।$Q700$,
  ARRAY[$Q701$AC Power$Q701$,$Q702$Balanced System$Q702$,$Q703$Star-Delta$Q703$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q704$Power Factor Correction$Q704$,
  $Q705$P$Q705$,
  $Q706$power$Q706$,
  $Q707$Stevenson & Sadat, Ch.2$Q707$,
  $Q708$high$Q708$,
  $Q709$capacitor$Q709$,
  $Q710$ক্যাপাসিটর যোগ করে পাওয়ার ফ্যাক্টর উন্নত করা$Q710$,
  $Q711$Power Factor Correction হলো একটি প্রক্রিয়া, যেখানে ইন্ডাক্টিভ লোডের (মোটর, ট্রান্সফরমার) সৃষ্ট ল্যাগিং রিয়্যাক্টিভ পাওয়ার প্রশমিত করতে সমান্তরালে ক্যাপাসিটর ব্যাংক যুক্ত করা হয়, যা Power Factor-কে ১-এর কাছাকাছি নিয়ে আসে এবং সিস্টেমের দক্ষতা বাড়ায়।$Q711$,
  $Q712$🎒 ভারী ব্যাকপ্যাক থেকে অপ্রয়োজনীয় ওজন কমানোর মতো — একই কাজ (real power) করতে এখন কম শক্তি (apparent power) খরচ হয়, ফলে পথ চলা (বিদ্যুৎ পরিবহন) সহজ হয়।$Q712$,
  $Q713$শিল্প কারখানায় বিদ্যুৎ বিল কমাতে, ট্রান্সফরমার ও ক্যাবলের ওভারলোডিং প্রতিরোধ করতে, এবং ইউটিলিটি কোম্পানির পেনাল্টি এড়াতে ব্যবহৃত হয়।$Q713$,
  $Q714$একটি কারখানার PF 0.7 থেকে ক্যাপাসিটর ব্যাংক যোগ করে 0.95-এ উন্নত করলে একই লোডের জন্য প্রয়োজনীয় কারেন্ট উল্লেখযোগ্যভাবে কমে যায়, ফলে বিদ্যুৎ বিলও কমে।$Q714$,
  $Q715$প্রয়োজনীয় ক্যাপাসিটর: Q_c = P(tanθ₁ − tanθ₂), যেখানে θ₁ ও θ₂ যথাক্রমে সংশোধনের আগে ও পরের পাওয়ার ফ্যাক্টর কোণ। ক্যাপাসিটর লিডিং রিয়্যাক্টিভ পাওয়ার দিয়ে ইন্ডাক্টিভ ল্যাগিং রিয়্যাক্টিভ পাওয়ার বাতিল করে।$Q715$,
  $Q716$টেক্সটাইল ও গার্মেন্টস কারখানার মোটর লোড, সাবস্টেশন ক্যাপাসিটর ব্যাংক, এবং বড় HVAC সিস্টেমে বিদ্যুৎ সাশ্রয়ে ব্যবহৃত হয়।$Q716$,
  ARRAY[$Q717$Reactive Power$Q717$,$Q718$Capacitor Bank$Q718$,$Q719$Energy Efficiency$Q719$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q720$Transformer (Power)$Q720$,
  $Q721$T$Q721$,
  $Q722$power$Q722$,
  $Q723$Stevenson & Sadat, Ch.3$Q723$,
  $Q724$critical$Q724$,
  $Q725$transformer$Q725$,
  $Q726$ভোল্টেজ স্তর পরিবর্তনকারী চৌম্বকীয় যন্ত্র$Q726$,
  $Q727$Power Transformer একটি স্ট্যাটিক ইলেকট্রিক্যাল যন্ত্র, যা মিউচুয়াল ইনডাকশনের মাধ্যমে একই ফ্রিকোয়েন্সিতে AC ভোল্টেজের মাত্রা পরিবর্তন (স্টেপ-আপ বা স্টেপ-ডাউন) করে, দুই বা ততোধিক ওয়াইন্ডিং একটি সাধারণ চৌম্বক কোরে জড়ানো থাকে।$Q727$,
  $Q728$⚙️ সাইকেলের গিয়ারের মতো — কম RPM-এ বেশি টর্ক অথবা বেশি RPM-এ কম টর্ক পাওয়া যায় গিয়ার পরিবর্তনে, একইভাবে ট্রান্সফরমার কম ভোল্টেজে বেশি কারেন্ট বা বেশি ভোল্টেজে কম কারেন্টে রূপান্তর করে — পাওয়ার প্রায় অপরিবর্তিত থাকে।$Q728$,
  $Q729$পাওয়ার প্ল্যান্টের জেনারেটর ভোল্টেজকে ট্রান্সমিশনের জন্য স্টেপ-আপ করা, এবং সাবস্টেশনে ভোল্টেজ স্টেপ-ডাউন করে বাসাবাড়িতে সরবরাহযোগ্য করা।$Q729$,
  $Q730$একটি জেনারেটিং স্টেশনে 11kV-কে ট্রান্সফরমার দিয়ে 230kV-তে স্টেপ-আপ করে ট্রান্সমিশন লাইনে পাঠানো হয়, পরে বিতরণ সাবস্টেশনে তা 11kV বা 400V-তে স্টেপ-ডাউন করা হয়।$Q730$,
  $Q731$V₁/V₂ = N₁/N₂ = I₂/I₁ (N = ওয়াইন্ডিং টার্ন সংখ্যা, আদর্শ ট্রান্সফরমারে)। প্রকৃত পাওয়ার সংরক্ষিত থাকে: V₁I₁ ≈ V₂I₂ (কপার ও কোর লস বাদে)।$Q731$,
  $Q732$জাতীয় গ্রিড ভোল্টেজ স্তরায়ন, বিতরণ সাবস্টেশন, মোবাইল চার্জার (ছোট ট্রান্সফরমার), এবং শিল্প কারখানার পাওয়ার সরবরাহে ব্যবহৃত হয়।$Q732$,
  ARRAY[$Q733$Voltage Conversion$Q733$,$Q734$Mutual Induction$Q734$,$Q735$Grid Equipment$Q735$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q736$Short Circuit Analysis (Fault Analysis)$Q736$,
  $Q737$S$Q737$,
  $Q738$power$Q738$,
  $Q739$Stevenson & Sadat, Ch.10$Q739$,
  $Q740$high$Q740$,
  $Q741$spark$Q741$,
  $Q742$সিস্টেমে ত্রুটির সময় কারেন্ট গণনা পদ্ধতি$Q742$,
  $Q743$Short Circuit Analysis হলো একটি পদ্ধতি যা পাওয়ার সিস্টেমে বিভিন্ন ধরনের ত্রুটি (fault) — যেমন সিঙ্গেল লাইন-টু-গ্রাউন্ড, লাইন-টু-লাইন, বা থ্রি-ফেজ ফল্ট — ঘটলে সৃষ্ট বিশাল ফল্ট কারেন্ট গণনা করে, যা প্রোটেকশন ইকুইপমেন্ট ডিজাইনের জন্য অত্যাবশ্যক।$Q743$,
  $Q744$🌊 বাঁধ ভাঙার মতো — স্বাভাবিক প্রবাহের (normal current) বদলে হঠাৎ বিশাল পরিমাণ পানি (কারেন্ট) অনিয়ন্ত্রিতভাবে বেরিয়ে আসে, যা দ্রুত বন্ধ (সার্কিট ব্রেকার ট্রিপ) না করলে ব্যাপক ক্ষতি করতে পারে।$Q744$,
  $Q745$সার্কিট ব্রেকারের ইন্টারাপ্টিং ক্যাপাসিটি নির্ধারণ, প্রোটেকশন রিলে সেটিং ক্যালিব্রেশন, এবং সাবস্টেশন ইকুইপমেন্ট রেটিং নির্বাচনে ব্যবহৃত হয়।$Q745$,
  $Q746$একটি 132kV সাবস্টেশনে থ্রি-ফেজ ফল্ট বিশ্লেষণে দেখা গেল ফল্ট কারেন্ট 25kA পর্যন্ত পৌঁছাতে পারে, তাই সার্কিট ব্রেকারের রেটিং কমপক্ষে 25kA হতে হবে।$Q746$,
  $Q747$সিমেট্রিক্যাল থ্রি-ফেজ ফল্ট কারেন্ট: I_fault = V/Z_th (Thevenin ইমপিডেন্স ফল্ট পয়েন্ট থেকে দেখা)। আনসিমেট্রিক্যাল ফল্টের জন্য Positive, Negative ও Zero Sequence নেটওয়ার্ক ব্যবহার করা হয় (Symmetrical Components পদ্ধতি)।$Q747$,
  $Q748$সার্কিট ব্রেকার ও ফিউজ সিলেকশন, প্রোটেকশন রিলে কো-অর্ডিনেশন স্টাডি, এবং নতুন সাবস্টেশন ডিজাইনে ব্যবহৃত হয়।$Q748$,
  ARRAY[$Q749$Fault Current$Q749$,$Q750$Protection Design$Q750$,$Q751$Symmetrical Components$Q751$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q752$Grounding (Earthing)$Q752$,
  $Q753$G$Q753$,
  $Q754$power$Q754$,
  $Q755$Stevenson & Sadat, Ch.10$Q755$,
  $Q756$high$Q756$,
  $Q757$ground$Q757$,
  $Q758$নিরাপত্তার জন্য বৈদ্যুতিক সিস্টেমকে মাটির সাথে সংযোগ$Q758$,
  $Q759$Grounding (Earthing) হলো বৈদ্যুতিক সিস্টেমের একটি বিন্দু (সাধারণত নিউট্রাল বা যন্ত্রের বডি) কে সরাসরি মাটির সাথে নিম্ন-ইমপিডেন্স সংযোগে যুক্ত করার প্রক্রিয়া, যা ফল্ট কারেন্টের জন্য একটি নিরাপদ পথ তৈরি করে এবং বৈদ্যুতিক শক থেকে রক্ষা করে।$Q759$,
  $Q760$🛡️ বজ্রপাত রক্ষা দণ্ডের মতো — অতিরিক্ত বৈদ্যুতিক শক্তিকে নিরাপদে মাটিতে পাঠিয়ে দেয়, যাতে সেই শক্তি মানুষ বা যন্ত্রপাতির মধ্য দিয়ে ক্ষতিকরভাবে প্রবাহিত না হয়।$Q760$,
  $Q761$বাসাবাড়ি ও শিল্প কারখানার বৈদ্যুতিক ওয়্যারিং, সাবস্টেশন ইকুইপমেন্ট প্রোটেকশন, এবং ইলেকট্রনিক ডিভাইসে স্ট্যাটিক ডিসচার্জ প্রতিরোধে ব্যবহৃত হয়।$Q761$,
  $Q762$একটি ওয়াশিং মেশিনের ধাতব বডি যদি ভুলবশত লাইভ তারের সংস্পর্শে আসে, তাহলে সঠিক আর্থিং থাকলে ফল্ট কারেন্ট মাটিতে চলে যাবে এবং সার্কিট ব্রেকার ট্রিপ করবে, ব্যবহারকারী শক খাবে না।$Q762$,
  $Q763$Ground Resistance R_g যত কম, ফল্ট কারেন্ট মাটিতে যাওয়া তত সহজ (I_fault = V/R_g)। ভালো আর্থিং সিস্টেমে R_g সাধারণত 1-5Ω-এর নিচে রাখা হয় (মাটির প্রকৃতি ও প্রয়োগ অনুযায়ী)।$Q763$,
  $Q764$গৃহস্থালী বৈদ্যুতিক নিরাপত্তা (RCD/ELCB সহ), লাইটনিং প্রোটেকশন সিস্টেম, ডেটা সেন্টার ইকুইপমেন্ট গ্রাউন্ডিং, এবং টেলিকম টাওয়ার প্রোটেকশনে ব্যবহৃত হয়।$Q764$,
  ARRAY[$Q765$Safety$Q765$,$Q766$Fault Protection$Q766$,$Q767$Earth Resistance$Q767$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q768$Reactive Power$Q768$,
  $Q769$R$Q769$,
  $Q770$power$Q770$,
  $Q771$Stevenson & Sadat, Ch.2$Q771$,
  $Q772$critical$Q772$,
  $Q773$wavesine$Q773$,
  $Q774$চৌম্বক/বৈদ্যুতিক ফিল্ড বজায় রাখতে ব্যবহৃত অ-কার্যকরী পাওয়ার$Q774$,
  $Q775$Reactive Power (Q, একক VAR) হলো সেই পাওয়ার যা ইন্ডাক্টর ও ক্যাপাসিটরের চৌম্বক ও বৈদ্যুতিক ফিল্ড তৈরি ও বজায় রাখতে প্রয়োজন হয়, কিন্তু কোনো প্রকৃত কাজ (তাপ, আলো, যান্ত্রিক শক্তি) সম্পাদন করে না — এটি সোর্স ও লোডের মধ্যে দোদুল্যমান থাকে।$Q775$,
  $Q776$🍺 বিয়ারের গ্লাসে ফেনার মতো — গ্লাস পূর্ণ মনে হলেও ফেনা (রিয়্যাক্টিভ পাওয়ার) আসল বিয়ার (রিয়েল পাওয়ার) নয়, তবু জায়গা দখল করে রাখে এবং পরিবহন ক্যাপাসিটি খরচ করে।$Q776$,
  $Q777$গ্রিড ভোল্টেজ স্ট্যাবিলিটি বজায় রাখতে, মোটর ও ট্রান্সফরমারের চৌম্বকীকরণে, এবং Power Factor Correction ক্যালকুলেশনে ব্যবহৃত হয়।$Q777$,
  $Q778$একটি ইন্ডাকশন মোটর 10kW প্রকৃত কাজ করলেও, চৌম্বক ফিল্ড তৈরি করতে অতিরিক্ত 6kVAR রিয়্যাক্টিভ পাওয়ার গ্রিড থেকে টানে, যা সরাসরি কোনো যান্ত্রিক কাজ করে না।$Q778$,
  $Q779$Q = VI sin θ (θ = ভোল্টেজ ও কারেন্টের ফেজ পার্থক্য)। Power Triangle: S² = P² + Q² (S = Apparent Power, P = Real Power)। ইন্ডাক্টিভ লোডে Q ধনাত্মক (lagging), ক্যাপাসিটিভ লোডে Q ঋণাত্মক (leading)।$Q779$,
  $Q780$গ্রিড ভোল্টেজ কন্ট্রোল (Reactive Power Compensation), শিল্প কারখানার মোটর লোড ম্যানেজমেন্ট, এবং সাবস্টেশন ক্যাপাসিটর/রিয়্যাক্টর ব্যাংক ডিজাইনে ব্যবহৃত হয়।$Q780$,
  ARRAY[$Q781$VAR$Q781$,$Q782$AC Power$Q782$,$Q783$Power Triangle$Q783$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q784$Real Power (Active Power)$Q784$,
  $Q785$R$Q785$,
  $Q786$power$Q786$,
  $Q787$Stevenson & Sadat, Ch.2$Q787$,
  $Q788$critical$Q788$,
  $Q789$bulb$Q789$,
  $Q790$প্রকৃত কাজে ব্যবহৃত হওয়া পাওয়ার$Q790$,
  $Q791$Real Power (P, একক Watt) হলো সেই পাওয়ার যা প্রকৃতপক্ষে তাপ, আলো, বা যান্ত্রিক গতিতে রূপান্তরিত হয়ে প্রকৃত কাজ সম্পাদন করে — এটি Power Triangle-এ অনুভূমিক (রেজিস্টিভ) অংশ প্রতিনিধিত্ব করে।$Q791$,
  $Q792$🍺 বিয়ারের গ্লাসে প্রকৃত বিয়ারের মতো — এটাই আসল জিনিস যা আপনি চান (উপভোগ করতে/ব্যবহার করতে), ফেনা (Reactive Power) নয়।$Q792$,
  $Q793$বিদ্যুৎ বিলিং (সাধারণত Real Power-এর ভিত্তিতে চার্জ করা হয়), পাওয়ার প্ল্যান্টের জেনারেশন ক্যাপাসিটি পরিকল্পনা, এবং যন্ত্রপাতির প্রকৃত শক্তি খরচ পরিমাপে ব্যবহৃত হয়।$Q793$,
  $Q794$একটি 100W বাল্ব জ্বললে সেটি সম্পূর্ণ Real Power হিসেবে আলো ও তাপে রূপান্তরিত হয়, কারণ বাল্ব একটি বিশুদ্ধ রেজিস্টিভ লোড (Power Factor = 1)।$Q794$,
  $Q795$P = VI cos θ (θ = ভোল্টেজ-কারেন্ট ফেজ পার্থক্য, cos θ = Power Factor)। রেজিস্টিভ লোডে θ=0 তাই P=VI (সর্বোচ্চ); বিশুদ্ধ রিয়্যাক্টিভ লোডে θ=90° তাই P=0।$Q795$,
  $Q796$বিদ্যুৎ বিল হিসাব (kWh মিটার), পাওয়ার প্ল্যান্ট জেনারেশন ক্যাপাসিটি প্ল্যানিং, এবং শিল্প কারখানার এনার্জি অডিটে ব্যবহৃত হয়।$Q796$,
  ARRAY[$Q797$Watt$Q797$,$Q798$AC Power$Q798$,$Q799$Power Triangle$Q799$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q800$Apparent Power$Q800$,
  $Q801$A$Q801$,
  $Q802$power$Q802$,
  $Q803$Stevenson & Sadat, Ch.2$Q803$,
  $Q804$medium$Q804$,
  $Q805$gauge$Q805$,
  $Q806$রিয়েল ও রিয়্যাক্টিভ পাওয়ারের ভেক্টর যোগফল$Q806$,
  $Q807$Apparent Power (S, একক VA) হলো একটি AC সার্কিটের ভোল্টেজ ও কারেন্টের সরল গুণফল (RMS মান), যা Real Power (P) ও Reactive Power (Q)-এর ভেক্টর যোগফল হিসেবে প্রকাশিত হয় — এটি ট্রান্সফরমার ও জেনারেটরের রেটিং নির্ধারণে ব্যবহৃত হয়।$Q807$,
  $Q808$🍺 বিয়ারের গ্লাসের মোট পরিমাণের মতো — বিয়ার (Real Power) ও ফেনা (Reactive Power) মিলিয়ে যে মোট আয়তন (Apparent Power) দেখা যায়, গ্লাসকে সেই পুরো আয়তনের জন্যই ডিজাইন করতে হয়।$Q808$,
  $Q809$ট্রান্সফরমার, জেনারেটর ও UPS-এর রেটিং (kVA-তে) নির্ধারণ, এবং ক্যাবল সাইজিং-এ ব্যবহৃত হয়, কারণ ক্যাবলকে Apparent কারেন্টই বহন করতে হয়।$Q809$,
  $Q810$একটি ট্রান্সফরমারের রেটিং 100 kVA হলে, যদি লোড PF=0.8 হয়, তাহলে সর্বোচ্চ Real Power সরবরাহ করা যাবে মাত্র 80 kW, বাকি ক্যাপাসিটি রিয়্যাক্টিভ পাওয়ারের জন্য 'আটকে' থাকবে।$Q810$,
  $Q811$S = √(P² + Q²) = V_rms × I_rms। এককঃ VA (Volt-Ampere), বড় সিস্টেমে kVA বা MVA ব্যবহার করা হয়।$Q811$,
  $Q812$ট্রান্সফরমার ও জেনারেটর নেমপ্লেট রেটিং, UPS সাইজিং, এবং ইলেকট্রিক্যাল ইনস্টলেশনে ক্যাবল ও সার্কিট ব্রেকার নির্বাচনে ব্যবহৃত হয়।$Q812$,
  ARRAY[$Q813$VA$Q813$,$Q814$Power Triangle$Q814$,$Q815$Equipment Rating$Q815$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q816$Voltage Regulation$Q816$,
  $Q817$V$Q817$,
  $Q818$power$Q818$,
  $Q819$Stevenson & Sadat, Ch.4$Q819$,
  $Q820$medium$Q820$,
  $Q821$gauge$Q821$,
  $Q822$নো-লোড ও ফুল-লোড ভোল্টেজের শতকরা পার্থক্য$Q822$,
  $Q823$Voltage Regulation হলো একটি ট্রান্সফরমার বা ট্রান্সমিশন লাইনের নো-লোড আউটপুট ভোল্টেজ ও ফুল-লোড আউটপুট ভোল্টেজের মধ্যে শতকরা পার্থক্য, যা লোড প্রয়োগে ভোল্টেজ কতটা 'ড্রপ' করে তা নির্দেশ করে।$Q823$,
  $Q824$🚿 শাওয়ারের পানির চাপের মতো — বাসায় একটি কল খোলা থাকলে চাপ ভালো থাকে, কিন্তু একসাথে অনেকগুলো কল খুললে (বেশি লোড) চাপ কমে যায় — এই কমে যাওয়ার শতকরা হারই Voltage Regulation।$Q824$,
  $Q825$ট্রান্সফরমার ডিজাইন যাচাই, ট্রান্সমিশন লাইনের কর্মক্ষমতা মূল্যায়ন, এবং দূরবর্তী গ্রাহকদের জন্য পর্যাপ্ত ভোল্টেজ নিশ্চিত করতে ব্যবহৃত হয়।$Q825$,
  $Q826$একটি ট্রান্সফরমারের নো-লোড ভোল্টেজ 415V এবং ফুল-লোড ভোল্টেজ 400V হলে, Voltage Regulation = (415−400)/400 × 100% = 3.75%।$Q826$,
  $Q827$%VR = [(V_NL − V_FL)/V_FL] × 100%। কম Voltage Regulation (ভালো) মানে লোড পরিবর্তনেও ভোল্টেজ স্থিতিশীল থাকে; উচ্চ রেজিস্ট্যান্স ও রিয়্যাক্ট্যান্সসম্পন্ন লাইনে Regulation বেশি হয়।$Q827$,
  $Q828$দীর্ঘ ট্রান্সমিশন লাইন ডিজাইন, গ্রামীণ বিদ্যুতায়ন প্রকল্প পরিকল্পনা, এবং ট্রান্সফরমার মানোন্নয়নে ব্যবহৃত হয়।$Q828$,
  ARRAY[$Q829$Transformer Performance$Q829$,$Q830$Line Performance$Q830$,$Q831$Voltage Drop$Q831$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q832$Economic Load Dispatch$Q832$,
  $Q833$E$Q833$,
  $Q834$power$Q834$,
  $Q835$Stevenson & Sadat, Ch.7$Q835$,
  $Q836$low$Q836$,
  $Q837$gauge$Q837$,
  $Q838$সর্বনিম্ন খরচে জেনারেটরের মধ্যে লোড বণ্টন$Q838$,
  $Q839$Economic Load Dispatch (ELD) হলো একটি অপটিমাইজেশন পদ্ধতি, যা মোট চাহিদা পূরণ করতে গিয়ে একাধিক পাওয়ার জেনারেটিং ইউনিটের মধ্যে সর্বনিম্ন সামগ্রিক জ্বালানি খরচে লোড বণ্টন নির্ধারণ করে।$Q839$,
  $Q840$🚕 একাধিক ট্যাক্সি ড্রাইভারের মধ্যে যাত্রী ভাগ করে দেওয়ার মতো — যে ড্রাইভারের তেল খরচ কম (দক্ষ), তাকে বেশি যাত্রী (লোড) দেওয়া হয়, যাতে সামগ্রিক খরচ সর্বনিম্ন হয়।$Q840$,
  $Q841$জাতীয় গ্রিড কন্ট্রোল সেন্টারে দৈনন্দিন জেনারেশন শিডিউলিং এবং একাধিক পাওয়ার প্ল্যান্ট পরিচালনায় খরচ অপটিমাইজেশনে ব্যবহৃত হয়।$Q841$,
  $Q842$যদি একটি গ্যাস প্ল্যান্টের প্রতি ইউনিট উৎপাদন খরচ কয়লা প্ল্যান্টের চেয়ে কম হয়, তাহলে ELD অ্যালগরিদম গ্যাস প্ল্যান্টকে বেশি লোড বরাদ্দ করবে (নিরাপত্তা সীমার মধ্যে থেকে)।$Q842$,
  $Q843$অপটিমাইজেশন শর্ত: dC₁/dP₁ = dC₂/dP₂ = ... = λ (সব প্ল্যান্টের Incremental Cost সমান হতে হবে, যাকে বলা হয় Equal Incremental Cost Criterion), শর্তসাপেক্ষে ΣP_i = P_demand।$Q843$,
  $Q844$জাতীয় লোড ডিসপ্যাচ সেন্টার (NLDC), স্মার্ট গ্রিড এনার্জি ম্যানেজমেন্ট সিস্টেম, এবং মাইক্রোগ্রিড অপটিমাইজেশনে ব্যবহৃত হয়।$Q844$,
  ARRAY[$Q845$Optimization$Q845$,$Q846$Grid Operation$Q846$,$Q847$Cost Minimization$Q847$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q848$Circuit Breaker$Q848$,
  $Q849$C$Q849$,
  $Q850$power$Q850$,
  $Q851$Stevenson & Sadat, Ch.10$Q851$,
  $Q852$high$Q852$,
  $Q853$switch$Q853$,
  $Q854$ফল্ট কারেন্ট স্বয়ংক্রিয়ভাবে বিচ্ছিন্নকারী সুইচ$Q854$,
  $Q855$Circuit Breaker একটি স্বয়ংক্রিয় বৈদ্যুতিক সুইচিং যন্ত্র, যা স্বাভাবিক অবস্থায় কারেন্ট প্রবাহিত হতে দেয়, কিন্তু ওভারলোড বা শর্ট সার্কিট ফল্ট সনাক্ত হলে দ্রুত সার্কিট বিচ্ছিন্ন করে দেয়, যাতে ইকুইপমেন্ট ও মানুষের ক্ষতি না হয়।$Q855$,
  $Q856$🚨 জরুরি ব্রেকের মতো — যখন বিপদ দেখা দেয় (ফল্ট কারেন্ট), স্বয়ংক্রিয়ভাবে সিস্টেম থামিয়ে দেয়, মানুষের হস্তক্ষেপ ছাড়াই — একবার সমস্যা সমাধান হলে আবার চালু (রিসেট) করা যায়, ফিউজের মতো পুড়ে যায় না।$Q856$,
  $Q857$বাসাবাড়ির ডিস্ট্রিবিউশন বোর্ডে ওভারলোড প্রোটেকশন, সাবস্টেশনে ট্রান্সমিশন লাইন প্রোটেকশন, এবং শিল্প কারখানার মোটর প্রোটেকশনে ব্যবহৃত হয়।$Q857$,
  $Q858$একটি বাসার MCB (Miniature Circuit Breaker) 16A রেটিং-এর হলে, কারেন্ট এই সীমা ছাড়ালে স্বয়ংক্রিয়ভাবে ট্রিপ করে বিদ্যুৎ সংযোগ বিচ্ছিন্ন করে দেবে।$Q858$,
  $Q859$Breaking Capacity (kA) নির্ধারণ করে ব্রেকার সর্বোচ্চ কত ফল্ট কারেন্ট নিরাপদে বিচ্ছিন্ন করতে পারে। Interruption Time (সাধারণত কয়েক মিলিসেকেন্ড) যত কম, প্রোটেকশন তত দ্রুত।$Q859$,
  $Q860$গৃহস্থালী MCB/MCCB, উচ্চ-ভোল্টেজ সাবস্টেশন সার্কিট ব্রেকার (SF6, Vacuum), এবং শিল্প কারখানার মোটর প্রোটেকশন প্যানেলে ব্যবহৃত হয়।$Q860$,
  ARRAY[$Q861$Protection Device$Q861$,$Q862$Overload Protection$Q862$,$Q863$Switchgear$Q863$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q864$Relay Protection$Q864$,
  $Q865$R$Q865$,
  $Q866$power$Q866$,
  $Q867$Stevenson & Sadat, Ch.10$Q867$,
  $Q868$high$Q868$,
  $Q869$sensor$Q869$,
  $Q870$ফল্ট সনাক্ত করে ব্রেকার ট্রিপ করার সংকেত ব্যবস্থা$Q870$,
  $Q871$Relay Protection হলো একটি সেন্সিং ব্যবস্থা, যা কারেন্ট ট্রান্সফরমার (CT) ও পটেনশিয়াল ট্রান্সফরমার (PT) থেকে সংকেত নিয়ে অস্বাভাবিক অবস্থা (ওভারকারেন্ট, আন্ডার-ভোল্টেজ, রিভার্স পাওয়ার) সনাক্ত করে এবং সার্কিট ব্রেকারকে ট্রিপ করার নির্দেশ পাঠায়।$Q871$,
  $Q872$🧠 মানুষের স্নায়ুতন্ত্রের মতো — শরীরে ব্যথা (ফল্ট) অনুভব করলে মস্তিষ্ক (রিলে) দ্রুত সংকেত পাঠায় হাত সরিয়ে নিতে (ব্রেকার ট্রিপ করতে), যাতে বড় ক্ষতি এড়ানো যায়।$Q872$,
  $Q873$ট্রান্সমিশন লাইন ও ট্রান্সফরমার প্রোটেকশন, জেনারেটর প্রোটেকশন, এবং সিলেক্টিভ ফল্ট আইসোলেশনে (শুধু সমস্যাযুক্ত অংশ বিচ্ছিন্ন করা) ব্যবহৃত হয়।$Q873$,
  $Q874$একটি Overcurrent Relay নির্দিষ্ট সীমার (যেমন 500A) বেশি কারেন্ট সনাক্ত করলে একটি নির্দিষ্ট বিলম্বের পর ব্রেকারকে ট্রিপ সিগন্যাল পাঠায়, যাতে সাময়িক surge-এ ভুল ট্রিপ না হয়।$Q874$,
  $Q875$Time-Current Characteristic অনুযায়ী রিলে অপারেট করে: t = k/((I/I_pickup)^α − 1)। এই বৈশিষ্ট্যের মাধ্যমে বিভিন্ন লেভেলের রিলে কো-অর্ডিনেট করা হয় (Selectivity), যাতে শুধু সমস্যাযুক্ত সেকশন বিচ্ছিন্ন হয়।$Q875$,
  $Q876$জাতীয় গ্রিড প্রোটেকশন স্কিম, পাওয়ার ট্রান্সফরমার ডিফারেনশিয়াল প্রোটেকশন, এবং জেনারেটর সিনক্রোনাইজেশন প্রোটেকশনে ব্যবহৃত হয়।$Q876$,
  ARRAY[$Q877$Protection Scheme$Q877$,$Q878$CT-PT$Q878$,$Q879$Grid Safety$Q879$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q880$Corona Effect$Q880$,
  $Q881$C$Q881$,
  $Q882$power$Q882$,
  $Q883$Stevenson & Sadat, Ch.5$Q883$,
  $Q884$low$Q884$,
  $Q885$spark$Q885$,
  $Q886$উচ্চ-ভোল্টেজ লাইনে বায়ু আয়নীকরণজনিত শক্তি অপচয়$Q886$,
  $Q887$Corona Effect হলো একটি ঘটনা যেখানে অতি উচ্চ-ভোল্টেজ ট্রান্সমিশন লাইনের কন্ডাক্টরের চারপাশে বৈদ্যুতিক ফিল্ড এত তীব্র হয় যে এটি আশেপাশের বাতাসকে আয়নিত করে ফেলে, যার ফলে সামান্য নীল আভা, হিসিং শব্দ এবং শক্তি অপচয় হয়।$Q887$,
  $Q888$⚡ বজ্রপাতের ছোট সংস্করণের মতো — যখন বৈদ্যুতিক চাপ (ফিল্ড ইনটেনসিটি) খুব বেশি হয়ে যায়, তখন বাতাসও 'ভেঙে পড়ে' (আয়নিত হয়) এবং সেই দিয়েই সামান্য বিদ্যুৎ 'ফাঁস' হতে থাকে।$Q888$,
  $Q889$অতি উচ্চ ভোল্টেজ (400kV+) ট্রান্সমিশন লাইন ডিজাইনে কন্ডাক্টর সাইজ ও বান্ডলিং নির্ধারণে বিবেচনা করা হয়, যাতে করোনা লস কমানো যায়।$Q889$,
  $Q890$বৃষ্টির রাতে উচ্চ-ভোল্টেজ ট্রান্সমিশন লাইনের কাছে গেলে মাঝেমধ্যে হালকা হিসহিস শব্দ শোনা যায় — এটি করোনা ডিসচার্জের কারণে ঘটে, বৃষ্টির ফোঁটা ফিল্ড ইনটেনসিটি আরও বাড়িয়ে দেয়।$Q890$,
  $Q891$করোনা লস কমাতে বৃহৎ ব্যাসের বা বান্ডল কন্ডাক্টর ব্যবহার করা হয়, যা কন্ডাক্টর পৃষ্ঠের ইলেকট্রিক ফিল্ড গ্রেডিয়েন্ট কমায় (Critical Disruptive Voltage-এর নিচে রাখতে)। আবহাওয়া (বৃষ্টি, কুয়াশা) করোনা লস বাড়িয়ে দেয়।$Q891$,
  $Q892$অতি-উচ্চ-ভোল্টেজ (EHV) ট্রান্সমিশন লাইন ডিজাইন, বান্ডল কন্ডাক্টর নির্বাচন, এবং রেডিও ইন্টারফারেন্স (RI) নিয়ন্ত্রণে ব্যবহৃত হয়।$Q892$,
  ARRAY[$Q893$EHV Line$Q893$,$Q894$Power Loss$Q894$,$Q895$Conductor Design$Q895$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q896$Ferranti Effect$Q896$,
  $Q897$F$Q897$,
  $Q898$power$Q898$,
  $Q899$Stevenson & Sadat, Ch.5$Q899$,
  $Q900$low$Q900$,
  $Q901$wavesine$Q901$,
  $Q902$লম্বা লাইনে হালকা লোডে প্রাপক প্রান্তে ভোল্টেজ বৃদ্ধি$Q902$,
  $Q903$Ferranti Effect হলো একটি ঘটনা যেখানে দীর্ঘ ট্রান্সমিশন লাইনে হালকা লোড বা নো-লোড অবস্থায়, লাইনের ক্যাপাসিটিভ প্রভাবের কারণে প্রাপক প্রান্তের (receiving end) ভোল্টেজ প্রেরক প্রান্তের (sending end) ভোল্টেজের চেয়ে বেশি হয়ে যায় — যা স্বাভাবিক ভোল্টেজ ড্রপের বিপরীত।$Q903$,
  $Q904$🎈 একটি স্প্রিং টানার মতো — খুব হালকা ওজন (লোড) থাকলে স্প্রিং স্বাভাবিক দৈর্ঘ্যের চেয়েও বেশি প্রসারিত (ভোল্টেজ বৃদ্ধি) হয়ে যেতে পারে, ভারী ওজনে যেমন সংকুচিত (ভোল্টেজ ড্রপ) হওয়ার কথা তার উল্টো।$Q904$,
  $Q905$রাতের বেলা কম লোডের সময় দীর্ঘ EHV ট্রান্সমিশন লাইনে ভোল্টেজ নিয়ন্ত্রণে, এবং শান্ট রিয়্যাক্টর স্থাপনের প্রয়োজনীয়তা নির্ধারণে বিবেচনা করা হয়।$Q905$,
  $Q906$গভীর রাতে যখন বিদ্যুতের চাহিদা কম থাকে, তখন একটি দীর্ঘ 400kV লাইনের প্রাপক প্রান্তে ভোল্টেজ প্রেরক প্রান্তের চেয়ে কয়েক শতাংশ বেশি হয়ে যেতে পারে, যা ইকুইপমেন্টের জন্য ঝুঁকিপূর্ণ।$Q906$,
  $Q907$V_R > V_S ঘটে যখন লাইন লম্বা (সাধারণত 200km+) এবং লোড হালকা থাকে, কারণ লাইনের distributed ক্যাপাসিট্যান্স চার্জিং কারেন্ট তৈরি করে যা ইন্ডাক্টিভ রিয়্যাক্ট্যান্সে ভোল্টেজ বাড়িয়ে দেয়।$Q907$,
  $Q908$EHV ট্রান্সমিশন লাইনে শান্ট রিয়্যাক্টর ইনস্টলেশন সিদ্ধান্ত, রাত্রিকালীন গ্রিড ভোল্টেজ ম্যানেজমেন্ট, এবং লং-ডিসট্যান্স পাওয়ার করিডোর ডিজাইনে ব্যবহৃত হয়।$Q908$,
  ARRAY[$Q909$EHV Line$Q909$,$Q910$Voltage Rise$Q910$,$Q911$Line Charging$Q911$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q912$Load Shedding$Q912$,
  $Q913$L$Q913$,
  $Q914$power$Q914$,
  $Q915$Stevenson & Sadat, Ch.11$Q915$,
  $Q916$medium$Q916$,
  $Q917$switch$Q917$,
  $Q918$গ্রিড রক্ষায় ইচ্ছাকৃত সাময়িক বিদ্যুৎ বিচ্ছিন্নকরণ$Q918$,
  $Q919$Load Shedding হলো একটি নিয়ন্ত্রিত প্রক্রিয়া, যেখানে বিদ্যুৎ চাহিদা উৎপাদন ক্ষমতা ছাড়িয়ে গেলে সমগ্র গ্রিড ভেঙে পড়া (blackout) এড়াতে ইচ্ছাকৃতভাবে নির্দিষ্ট এলাকার বিদ্যুৎ সরবরাহ সাময়িকভাবে বন্ধ রাখা হয়।$Q919$,
  $Q920$🛟 নৌকা ডুবে যাওয়া থেকে বাঁচাতে অতিরিক্ত মালামাল ফেলে দেওয়ার মতো — পুরো নৌকা (গ্রিড) ডুবে যাওয়ার চেয়ে কিছু মালামাল (কিছু এলাকার লোড) ফেলে দিয়ে বাকি সবাইকে নিরাপদ রাখা ভালো।$Q920$,
  $Q921$গ্রীষ্মকালে অতিরিক্ত চাহিদার সময়, জেনারেশন ঘাটতিতে, বা জরুরি রক্ষণাবেক্ষণের সময় গ্রিড ফ্রিকোয়েন্সি ও স্থিতিশীলতা বজায় রাখতে ব্যবহৃত হয়।$Q921$,
  $Q922$বাংলাদেশে গ্রীষ্মকালে বিদ্যুৎ চাহিদা উৎপাদন ক্ষমতা ছাড়িয়ে গেলে, নির্দিষ্ট এলাকায় পালাক্রমে (rotational) কিছু সময়ের জন্য লোড শেডিং করা হয়, যা 'লোডশেডিং' নামে পরিচিত।$Q922$,
  $Q923$Under-Frequency Load Shedding (UFLS) স্কিমে, যখন গ্রিড ফ্রিকোয়েন্সি নির্দিষ্ট সীমার (যেমন 49Hz) নিচে নামে, তখন স্বয়ংক্রিয়ভাবে ধাপে ধাপে লোড বিচ্ছিন্ন করা হয় ফ্রিকোয়েন্সি পুনরুদ্ধার করতে।$Q923$,
  $Q924$জাতীয় গ্রিড ফ্রিকোয়েন্সি স্থিতিশীলতা রক্ষা, জরুরি ব্ল্যাকআউট প্রতিরোধ ব্যবস্থা, এবং স্মার্ট গ্রিড ডিমান্ড রেসপন্স সিস্টেমে ব্যবহৃত হয়।$Q924$,
  ARRAY[$Q925$Grid Stability$Q925$,$Q926$UFLS$Q926$,$Q927$Demand Management$Q927$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q928$Grid Synchronization$Q928$,
  $Q929$G$Q929$,
  $Q930$power$Q930$,
  $Q931$Stevenson & Sadat, Ch.6$Q931$,
  $Q932$medium$Q932$,
  $Q933$wavesine$Q933$,
  $Q934$জেনারেটরকে গ্রিডের সাথে সমন্বয় করে সংযুক্তকরণ$Q934$,
  $Q935$Grid Synchronization হলো একটি প্রক্রিয়া, যেখানে একটি জেনারেটরকে ইতিমধ্যে চলমান পাওয়ার গ্রিডে সংযুক্ত করার আগে তার ভোল্টেজ ম্যাগনিচিউড, ফ্রিকোয়েন্সি, ফেজ সিকোয়েন্স এবং ফেজ অ্যাঙ্গেল গ্রিডের সাথে মিলিয়ে নেওয়া হয়, যাতে সংযোগের সময় বিশাল কারেন্ট surge বা যান্ত্রিক ধাক্কা না লাগে।$Q935$,
  $Q936$🏃 চলন্ত ট্রেনে লাফিয়ে ওঠার মতো — নিরাপদে উঠতে হলে তোমার গতি ট্রেনের গতির সাথে মিলিয়ে নিতে হয়, নাহলে ধাক্কায় পড়ে যাবে — একইভাবে জেনারেটরকে গ্রিডের 'গতির' (ফ্রিকোয়েন্সি, ফেজ) সাথে মিলিয়ে নিতে হয়।$Q936$,
  $Q937$নতুন পাওয়ার প্ল্যান্ট গ্রিডে যুক্ত করার সময়, এবং রক্ষণাবেক্ষণের পর জেনারেটর পুনরায় সংযোগ করার সময় ব্যবহৃত হয়।$Q937$,
  $Q938$একটি নতুন গ্যাস টারবাইন জেনারেটর গ্রিডে যুক্ত করার আগে সিনক্রোস্কোপ যন্ত্র দিয়ে যাচাই করা হয় যে এর ভোল্টেজ, ফ্রিকোয়েন্সি ও ফেজ গ্রিডের সাথে যথাযথভাবে মিলছে কিনা।$Q938$,
  $Q939$সিনক্রোনাইজেশনের চারটি শর্ত: (১) সমান ভোল্টেজ ম্যাগনিচিউড, (২) সমান ফ্রিকোয়েন্সি, (৩) একই ফেজ সিকোয়েন্স, (৪) শূন্য ফেজ অ্যাঙ্গেল পার্থক্য — সবগুলো মিললেই ব্রেকার বন্ধ করে সংযোগ দেওয়া নিরাপদ।$Q939$,
  $Q940$পাওয়ার প্ল্যান্ট কমিশনিং, রিনিউয়েবল এনার্জি (সোলার/উইন্ড) ইনভার্টার গ্রিড-টাই কানেকশন, এবং ইমার্জেন্সি ব্যাকআপ জেনারেটর সিস্টেমে ব্যবহৃত হয়।$Q940$,
  ARRAY[$Q941$Generator Connection$Q941$,$Q942$Frequency Matching$Q942$,$Q943$Grid Operation$Q943$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q944$Insulator (Transmission)$Q944$,
  $Q945$I$Q945$,
  $Q946$power$Q946$,
  $Q947$Stevenson & Sadat, Ch.4$Q947$,
  $Q948$low$Q948$,
  $Q949$tower$Q949$,
  $Q950$টাওয়ার থেকে কন্ডাক্টরকে বিদ্যুৎ-নিরোধী রাখার যন্ত্র$Q950$,
  $Q951$Insulator হলো সিরামিক, গ্লাস বা পলিমার দিয়ে তৈরি একটি যন্ত্র, যা ট্রান্সমিশন লাইনের উচ্চ-ভোল্টেজ কন্ডাক্টরকে গ্রাউন্ডেড টাওয়ার বা পোল থেকে বৈদ্যুতিকভাবে বিচ্ছিন্ন রাখে, একই সাথে যান্ত্রিকভাবে কন্ডাক্টরকে সমর্থন করে।$Q951$,
  $Q952$🧤 রাবারের গ্লাভসের মতো — বিদ্যুতায়িত তার (কন্ডাক্টর) ধরে রাখতে হলেও (যান্ত্রিক সাপোর্ট), শরীরে (টাওয়ারে) কারেন্ট যেন না পৌঁছায় তা নিশ্চিত করে।$Q952$,
  $Q953$ওভারহেড ট্রান্সমিশন ও ডিস্ট্রিবিউশন লাইনে কন্ডাক্টর সাপোর্ট, এবং সাবস্টেশন বাসবার আইসোলেশনে ব্যবহৃত হয়।$Q953$,
  $Q954$একটি 132kV ট্রান্সমিশন টাওয়ারে সাধারণত একাধিক ডিস্ক-আকৃতির সিরামিক ইনসুলেটর চেইন আকারে জোড়া লাগিয়ে ব্যবহার করা হয়, যাতে প্রয়োজনীয় ইনসুলেশন লেভেল পাওয়া যায়।$Q954$,
  $Q955$Flashover Voltage (যে ভোল্টেজে ইনসুলেটরের পৃষ্ঠ দিয়ে আর্ক তৈরি হয়) সবসময় অপারেটিং ভোল্টেজের চেয়ে যথেষ্ট বেশি রাখা হয় (নিরাপত্তা মার্জিন সহ), এবং প্রয়োজনীয় ডিস্ক সংখ্যা লাইন ভোল্টেজের সাথে সমানুপাতিক বাড়ে।$Q955$,
  $Q956$উচ্চ-ভোল্টেজ ট্রান্সমিশন টাওয়ার, সাবস্টেশন বাসবার সাপোর্ট, এবং রেলওয়ে ইলেকট্রিফিকেশন ওভারহেড লাইনে ব্যবহৃত হয়।$Q956$,
  ARRAY[$Q957$Line Hardware$Q957$,$Q958$Dielectric$Q958$,$Q959$Overhead Line$Q959$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q960$DC Motor$Q960$,
  $Q961$D$Q961$,
  $Q962$machines$Q962$,
  $Q963$Chapman, Ch.8$Q963$,
  $Q964$critical$Q964$,
  $Q965$motor$Q965$,
  $Q966$DC বিদ্যুৎকে যান্ত্রিক ঘূর্ণন শক্তিতে রূপান্তরকারী যন্ত্র$Q966$,
  $Q967$DC Motor একটি ইলেকট্রিক্যাল মেশিন যা Direct Current বিদ্যুৎ শক্তিকে ঘূর্ণন যান্ত্রিক শক্তিতে রূপান্তরিত করে, মূলত পরিবাহীর মধ্য দিয়ে কারেন্ট প্রবাহিত হওয়া ও চৌম্বক ফিল্ডের মিথস্ক্রিয়ায় সৃষ্ট বলের (Lorentz Force) মাধ্যমে টর্ক উৎপন্ন করে।$Q967$,
  $Q968$🏊 সাঁতারুর হাতের মতো — যখন হাত (পরিবাহী কারেন্ট) পানির (চৌম্বক ফিল্ডের) মধ্য দিয়ে সঠিক দিকে ঠেলা দেয়, তখন শরীর (রোটর) সামনে এগিয়ে যায় (ঘোরে)।$Q968$,
  $Q969$ইলেকট্রিক গাড়ি, রোবোটিক্স, লিফট/এলিভেটর, এবং যেসব অ্যাপ্লিকেশনে সূক্ষ্ম গতি নিয়ন্ত্রণ প্রয়োজন সেখানে ব্যবহৃত হয়।$Q969$,
  $Q970$একটি টয় কারে ছোট DC মোটর ব্যাটারি থেকে কারেন্ট নিয়ে ঘুরতে থাকে এবং গিয়ারের মাধ্যমে চাকা ঘুরিয়ে গাড়ি চালায়।$Q970$,
  $Q971$টর্ক T = k×φ×I_a (φ = চৌম্বক ফ্লাক্স, I_a = আর্মেচার কারেন্ট)। গতি N ∝ (V − I_a×R_a)/φ — অর্থাৎ ভোল্টেজ বাড়ালে গতি বাড়ে, ফ্লাক্স কমালেও (ফিল্ড উইকেনিং) গতি বাড়ে।$Q971$,
  $Q972$ইলেকট্রিক ভেহিকেল ট্র্যাকশন মোটর, ইন্ডাস্ট্রিয়াল কনভেয়র বেল্ট, রোবোটিক আর্ম, এবং CNC মেশিনের সার্ভো ড্রাইভে ব্যবহৃত হয়।$Q972$,
  ARRAY[$Q973$Rotating Machine$Q973$,$Q974$Torque$Q974$,$Q975$Electromechanical Energy Conversion$Q975$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q976$DC Generator$Q976$,
  $Q977$D$Q977$,
  $Q978$machines$Q978$,
  $Q979$Chapman, Ch.8$Q979$,
  $Q980$high$Q980$,
  $Q981$generator$Q981$,
  $Q982$যান্ত্রিক শক্তিকে DC বিদ্যুতে রূপান্তরকারী যন্ত্র$Q982$,
  $Q983$DC Generator একটি ইলেকট্রিক্যাল মেশিন যা যান্ত্রিক ঘূর্ণন শক্তিকে ইলেকট্রোম্যাগনেটিক ইনডাকশনের মাধ্যমে (Faraday's Law) Direct Current বিদ্যুৎ শক্তিতে রূপান্তরিত করে, কমিউটেটরের সাহায্যে AC-কে DC-তে রূপান্তরিত করা হয়।$Q983$,
  $Q984$🚲 সাইকেলের ডায়নামোর মতো — প্যাডেল ঘোরালে (যান্ত্রিক শক্তি) বাতির জন্য বিদ্যুৎ তৈরি হয়, যত জোরে প্যাডেল ঘোরাবে তত বেশি বিদ্যুৎ (EMF) উৎপন্ন হবে।$Q984$,
  $Q985$ব্যাটারি চার্জিং সিস্টেম, পুরনো গাড়ির ইলেকট্রিক্যাল সিস্টেম, এবং ইলেকট্রোপ্লেটিং শিল্পে DC পাওয়ার সরবরাহে ব্যবহৃত হতো।$Q985$,
  $Q986$একটি ছোট হাইড্রো-পাওয়ার সেটআপে জলের প্রবাহে টারবাইন ঘুরিয়ে DC জেনারেটর দিয়ে ব্যাটারি চার্জ করা হয়, যা প্রত্যন্ত এলাকায় বিদ্যুৎ সরবরাহে ব্যবহৃত হয়।$Q986$,
  $Q987$Generated EMF: E = k×φ×N (φ = ফ্লাক্স, N = ঘূর্ণন গতি RPM)। ঘূর্ণন গতি বা চৌম্বক ফ্লাক্স বাড়ালে উৎপন্ন ভোল্টেজও সমানুপাতিক হারে বাড়ে।$Q987$,
  $Q988$পুরনো অটোমোবাইল চার্জিং সিস্টেম, ওয়েল্ডিং মেশিন পাওয়ার সোর্স, এবং শিল্প কারখানার DC মোটর সরবরাহে ঐতিহাসিকভাবে ব্যবহৃত হয়েছে (বর্তমানে বেশিরভাগ ক্ষেত্রে রেকটিফায়ার/AC জেনারেটর দিয়ে প্রতিস্থাপিত)।$Q988$,
  ARRAY[$Q989$Rotating Machine$Q989$,$Q990$EMF Generation$Q990$,$Q991$Electromechanical Energy Conversion$Q991$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q992$Induction Motor$Q992$,
  $Q993$I$Q993$,
  $Q994$machines$Q994$,
  $Q995$Chapman, Ch.6$Q995$,
  $Q996$critical$Q996$,
  $Q997$motor$Q997$,
  $Q998$সবচেয়ে ব্যাপকভাবে ব্যবহৃত AC মোটর$Q998$,
  $Q999$Induction Motor একটি AC মোটর যেখানে স্টেটরের ঘূর্ণায়মান চৌম্বক ফিল্ড রোটরে ইলেকট্রোম্যাগনেটিকভাবে কারেন্ট ইনডিউস করে (রোটরে সরাসরি বৈদ্যুতিক সংযোগ ছাড়াই), এবং এই ইনডিউসড কারেন্ট চৌম্বক ফিল্ডের সাথে মিথস্ক্রিয়া করে টর্ক তৈরি করে।$Q999$,
  $Q1000$🥏 একটি চুম্বকের ওপর ঘূর্ণায়মান ফ্রিসবি প্লেটের মতো (Arago's disk) — উপরে ঘুরন্ত চুম্বক (স্টেটর ফিল্ড) নিচের ধাতব ডিস্কে (রোটর) স্রোত প্ররোচিত করে এবং ডিস্ককেও ঘুরাতে বাধ্য করে, কোনো সরাসরি সংযোগ ছাড়াই।$Q1000$,
  $Q1001$শিল্প কারখানার পাম্প, ফ্যান, কম্প্রেসর, এবং কনভেয়র বেল্ট চালাতে সবচেয়ে বেশি ব্যবহৃত মোটর — এর দৃঢ়তা ও কম রক্ষণাবেক্ষণ খরচের কারণে।$Q1001$,
  $Q1002$একটি এয়ার কন্ডিশনারের কম্প্রেসর সাধারণত একটি সিঙ্গেল-ফেজ ইন্ডাকশন মোটর দিয়ে চালিত হয়, যা AC মেইন সাপ্লাই থেকে সরাসরি চলে।$Q1002$,
  $Q1003$Slip s = (N_s − N_r)/N_s (N_s = সিঙ্ক্রোনাস স্পিড, N_r = রোটর স্পিড)। রোটর কখনোই সিঙ্ক্রোনাস স্পিডে পৌঁছাতে পারে না (s>0), কারণ তাহলে আপেক্ষিক গতি শূন্য হয়ে ইনডাকশন বন্ধ হয়ে যাবে।$Q1003$,
  $Q1004$শিল্প কারখানার পাম্প ও কম্প্রেসর, বাসাবাড়ির ফ্যান ও রেফ্রিজারেটর, ইলেকট্রিক ট্রেন ট্র্যাকশন মোটর, এবং কনভেয়র সিস্টেমে সর্বাধিক ব্যবহৃত হয়।$Q1004$,
  ARRAY[$Q1005$AC Motor$Q1005$,$Q1006$Slip$Q1006$,$Q1007$Electromagnetic Induction$Q1007$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1008$Synchronous Motor$Q1008$,
  $Q1009$S$Q1009$,
  $Q1010$machines$Q1010$,
  $Q1011$Chapman, Ch.7$Q1011$,
  $Q1012$high$Q1012$,
  $Q1013$motor$Q1013$,
  $Q1014$সিঙ্ক্রোনাস স্পিডে ঘূর্ণনরত ধ্রুব-গতির AC মোটর$Q1014$,
  $Q1015$Synchronous Motor একটি AC মোটর যা সবসময় সরবরাহ ফ্রিকোয়েন্সি দ্বারা নির্ধারিত সিঙ্ক্রোনাস স্পিডে ঘোরে (লোড পরিবর্তনেও গতি অপরিবর্তিত থাকে), এর রোটরে বাহ্যিক DC এক্সাইটেশন বা পার্মানেন্ট ম্যাগনেট ব্যবহার করে চৌম্বক ফিল্ড স্টেটর ফিল্ডের সাথে 'লক' হয়ে যায়।$Q1015$,
  $Q1016$💃 নাচের জুটির মতো — রোটর (নর্তক) সবসময় স্টেটরের ঘূর্ণায়মান চৌম্বক ফিল্ডের (তার সঙ্গীর) সাথে একই তালে (একই গতিতে) 'নাচে', একটুও পিছিয়ে বা এগিয়ে না গিয়ে — কিন্তু বেশি চাপ দিলে (ওভারলোড) জুটি 'তাল হারিয়ে ফেলে' (স্টেপ-আউট)।$Q1016$,
  $Q1017$যেসব অ্যাপ্লিকেশনে সঠিক ও ধ্রুব গতি প্রয়োজন (যেমন ঘড়ি, রেকর্ড প্লেয়ার), এবং পাওয়ার ফ্যাক্টর কারেকশনের জন্য (Synchronous Condenser হিসেবে) ব্যবহৃত হয়।$Q1017$,
  $Q1018$সিমেন্ট কারখানায় বড় সিঙ্ক্রোনাস মোটর ব্যবহার করা হয় কারণ এটি একই সাথে যান্ত্রিক লোড চালায় এবং ওভার-এক্সাইটেশনের মাধ্যমে প্ল্যান্টের পাওয়ার ফ্যাক্টর উন্নত করে।$Q1018$,
  $Q1019$N_s = 120f/P (f = ফ্রিকোয়েন্সি Hz, P = পোল সংখ্যা)। এই গতি লোড নির্বিশেষে স্থির থাকে, যতক্ষণ না মোটর তার Pull-out Torque সীমা অতিক্রম করে (তখন সিঙ্ক্রোনিজম হারিয়ে থেমে যায়)।$Q1019$,
  $Q1020$সিমেন্ট মিল ও রোলিং মিল ড্রাইভ, পাওয়ার ফ্যাক্টর কারেকশন (Synchronous Condenser), এবং সুনির্দিষ্ট টাইমিং যন্ত্রপাতিতে ব্যবহৃত হয়।$Q1020$,
  ARRAY[$Q1021$AC Motor$Q1021$,$Q1022$Constant Speed$Q1022$,$Q1023$DC Excitation$Q1023$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1024$Synchronous Generator (Alternator)$Q1024$,
  $Q1025$S$Q1025$,
  $Q1026$machines$Q1026$,
  $Q1027$Chapman, Ch.4$Q1027$,
  $Q1028$critical$Q1028$,
  $Q1029$generator$Q1029$,
  $Q1030$পাওয়ার প্ল্যান্টের প্রধান বিদ্যুৎ উৎপাদক যন্ত্র$Q1030$,
  $Q1031$Synchronous Generator (Alternator) একটি AC জেনারেটর যা যান্ত্রিক শক্তিকে (টারবাইন থেকে) সিঙ্ক্রোনাস স্পিডে ঘুরিয়ে তিন-ফেজ AC বিদ্যুৎ শক্তিতে রূপান্তরিত করে — এটি বিশ্বের প্রায় সব পাওয়ার প্ল্যান্টে ব্যবহৃত প্রধান বিদ্যুৎ উৎপাদক যন্ত্র।$Q1031$,
  $Q1032$🎡 একটি বিশাল প্রদক্ষিণকারী চাকার মতো — বাষ্প বা পানির শক্তি (টারবাইন) চাকাকে (রোটরকে) নির্দিষ্ট গতিতে ঘুরায়, আর সেই ঘূর্ণন চৌম্বক ফিল্ড কয়েলে (স্টেটর) বিদ্যুৎ প্ররোচিত করে।$Q1032$,
  $Q1033$কয়লা, গ্যাস, পারমাণবিক ও জলবিদ্যুৎ কেন্দ্রে প্রধান বিদ্যুৎ উৎপাদনে, এবং ব্যাকআপ ডিজেল জেনারেটরে ব্যবহৃত হয়।$Q1033$,
  $Q1034$বাংলাদেশের একটি গ্যাস টারবাইন পাওয়ার প্ল্যান্টে টারবাইন 3000 RPM-এ ঘুরে 2-পোল অল্টারনেটর চালায়, যা 50Hz ফ্রিকোয়েন্সির বিদ্যুৎ উৎপন্ন করে।$Q1034$,
  $Q1035$f = (N×P)/120 (N = ঘূর্ণন গতি RPM, P = পোল সংখ্যা)। বাংলাদেশে 50Hz পেতে হলে 2-পোল জেনারেটরকে 3000 RPM-এ ঘুরতে হবে, বা 4-পোল জেনারেটরকে 1500 RPM-এ।$Q1035$,
  $Q1036$তাপবিদ্যুৎ ও জলবিদ্যুৎ কেন্দ্র, উইন্ড টারবাইন জেনারেটর, শিপ ও এয়ারক্রাফট পাওয়ার সিস্টেম, এবং ব্যাকআপ ডিজেল জেনারেটরে ব্যবহৃত হয়।$Q1036$,
  ARRAY[$Q1037$AC Generator$Q1037$,$Q1038$Power Plant$Q1038$,$Q1039$Frequency Generation$Q1039$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1040$Slip (Induction Motor)$Q1040$,
  $Q1041$S$Q1041$,
  $Q1042$machines$Q1042$,
  $Q1043$Chapman, Ch.6$Q1043$,
  $Q1044$medium$Q1044$,
  $Q1045$gauge$Q1045$,
  $Q1046$সিঙ্ক্রোনাস ও রোটর গতির আপেক্ষিক পার্থক্য$Q1046$,
  $Q1047$Slip হলো ইন্ডাকশন মোটরে সিঙ্ক্রোনাস স্পিড (স্টেটর চৌম্বক ফিল্ডের গতি) এবং প্রকৃত রোটর গতির মধ্যকার আপেক্ষিক পার্থক্য, যা শতকরা বা ভগ্নাংশ আকারে প্রকাশ করা হয় — এই পার্থক্যই রোটরে কারেন্ট ইনডিউস করে টর্ক তৈরি করে।$Q1047$,
  $Q1048$🏃 দৌড় প্রতিযোগিতায় পেছনে থাকা দৌড়বিদের মতো — সামনের দৌড়বিদকে (সিঙ্ক্রোনাস ফিল্ড) কখনো পুরোপুরি ধরতে পারে না (রোটর), সবসময় কিছুটা পিছিয়ে থাকে (স্লিপ), আর এই 'পিছিয়ে থাকা'ই তাকে এগিয়ে যাওয়ার শক্তি (টর্ক) দেয়।$Q1048$,
  $Q1049$ইন্ডাকশন মোটরের কর্মক্ষমতা বিশ্লেষণ, টর্ক-স্পিড ক্যারেক্টারিস্টিক নির্ধারণ, এবং ভেরিয়েবল ফ্রিকোয়েন্সি ড্রাইভ (VFD) ডিজাইনে ব্যবহৃত হয়।$Q1049$,
  $Q1050$একটি 4-পোল, 50Hz মোটরের সিঙ্ক্রোনাস স্পিড 1500 RPM, কিন্তু পূর্ণ লোডে এটি হয়তো 1450 RPM-এ ঘোরে — তাহলে Slip = (1500−1450)/1500 = 0.033 বা 3.3%।$Q1050$,
  $Q1051$s = (N_s − N_r)/N_s। No-load-এ s ≈ 0 (প্রায় সিঙ্ক্রোনাস), Full-load-এ s সাধারণত 2-5%, এবং Starting-এ (N_r=0) s=1 (সর্বোচ্চ)।$Q1051$,
  $Q1052$মোটর কর্মক্ষমতা মনিটরিং, VFD স্পিড কন্ট্রোল অ্যালগরিদম, এবং ইন্ডাকশন মোটর ফল্ট ডায়াগনসিসে (bearing/rotor বার সমস্যা) ব্যবহৃত হয়।$Q1052$,
  ARRAY[$Q1053$Induction Motor$Q1053$,$Q1054$Rotor Speed$Q1054$,$Q1055$Performance Parameter$Q1055$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1056$Armature Reaction$Q1056$,
  $Q1057$A$Q1057$,
  $Q1058$machines$Q1058$,
  $Q1059$Chapman, Ch.8$Q1059$,
  $Q1060$low$Q1060$,
  $Q1061$fieldlines$Q1061$,
  $Q1062$আর্মেচার কারেন্টের নিজস্ব চৌম্বক ফিল্ড বিকৃতিকরণ প্রভাব$Q1062$,
  $Q1063$Armature Reaction হলো একটি ঘটনা যেখানে আর্মেচার (রোটর) ওয়াইন্ডিং-এর মধ্য দিয়ে প্রবাহিত কারেন্ট নিজস্ব একটি চৌম্বক ফিল্ড তৈরি করে, যা মেইন ফিল্ড (স্টেটর/পোল থেকে) কে বিকৃত ও দুর্বল করে দেয়, ফলে মেশিনের কর্মক্ষমতা প্রভাবিত হয়।$Q1063$,
  $Q1064$🎤 মাইক্রোফোনের ফিডব্যাক স্কুইলের মতো — মূল শব্দ সিস্টেমের (মেইন ফিল্ড) সাথে স্পিকার থেকে ফিরে আসা শব্দ (আর্মেচারের নিজস্ব ফিল্ড) মিশে মূল সিগন্যালকে বিকৃত করে ফেলে।$Q1064$,
  $Q1065$DC মেশিন ডিজাইনে কমিউটেশন সমস্যা বিশ্লেষণ এবং ইন্টারপোল/কম্পেনসেটিং ওয়াইন্ডিং ডিজাইনের প্রয়োজনীয়তা নির্ধারণে বিবেচনা করা হয়।$Q1065$,
  $Q1066$একটি ভারী লোডে চলা DC জেনারেটরে আর্মেচার রিঅ্যাকশনের কারণে নিউট্রাল প্লেন সরে যায়, যার ফলে ব্রাশের কাছে স্পার্কিং বেড়ে যেতে পারে।$Q1066$,
  $Q1067$আর্মেচার MMF (Magnetomotive Force) মূল ফিল্ড MMF-এর সাথে যুক্ত হয়ে ফলস্বরূপ ফ্লাক্স বিতরণকে অসমমিত করে দেয় — এর প্রভাবে কিছু অংশে ফ্লাক্স বাড়ে, কিছু অংশে কমে (নেট ফ্লাক্স সাধারণত সামান্য কমে যায়, স্যাচুরেশনের কারণে)।$Q1067$,
  $Q1068$বড় DC মোটর ও জেনারেটর ডিজাইনে ইন্টারপোল (commutating pole) সংযোজন, এবং শিল্প কারখানার DC ড্রাইভ মেইনটেন্যান্সে ব্যবহৃত হয়।$Q1068$,
  ARRAY[$Q1069$DC Machine$Q1069$,$Q1070$Flux Distortion$Q1070$,$Q1071$Commutation$Q1071$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1072$Back EMF$Q1072$,
  $Q1073$B$Q1073$,
  $Q1074$machines$Q1074$,
  $Q1075$Chapman, Ch.8$Q1075$,
  $Q1076$high$Q1076$,
  $Q1077$battery$Q1077$,
  $Q1078$মোটরে ঘূর্ণনের ফলে সৃষ্ট বিরোধী ভোল্টেজ$Q1078$,
  $Q1079$Back EMF (Counter EMF) হলো একটি DC মোটরে আর্মেচার ঘোরার সময় নিজেই Faraday's Law অনুযায়ী উৎপন্ন একটি ভোল্টেজ, যা প্রয়োগকৃত সাপ্লাই ভোল্টেজের বিপরীত দিকে কাজ করে এবং কারেন্ট প্রবাহ স্বয়ংক্রিয়ভাবে সীমিত রাখে।$Q1079$,
  $Q1080$🚴 উজানে সাইকেল চালানোর মতো — যত জোরে প্যাডেল করো (মোটর ঘুরে), স্রোত (Back EMF) তত বেশি বাধা দেয়, এবং এই স্বয়ংক্রিয় ব্যালেন্সই তোমাকে একটি নির্দিষ্ট গতিতে স্থির রাখে।$Q1080$,
  $Q1081$DC মোটরের স্টার্টিং কারেন্ট বিশ্লেষণ, স্পিড কন্ট্রোল ডিজাইন, এবং মোটরের স্বয়ংক্রিয় স্পিড রেগুলেশন ব্যাখ্যায় ব্যবহৃত হয়।$Q1081$,
  $Q1082$একটি DC মোটর স্টার্ট করার মুহূর্তে (গতি শূন্য) Back EMF শূন্য থাকে, তাই সাপ্লাই ভোল্টেজের পুরোটাই সরাসরি আর্মেচার রেজিস্ট্যান্সে পড়ে বিশাল স্টার্টিং কারেন্ট তৈরি করে — এজন্য স্টার্টার প্রয়োজন হয়।$Q1082$,
  $Q1083$E_b = V − I_a×R_a, এবং E_b = k×φ×N। গতি বাড়ার সাথে Back EMF বাড়ে, ফলে নেট ভোল্টেজ (V−E_b) কমে যায় এবং কারেন্ট স্বয়ংক্রিয়ভাবে কমে স্টেডি-স্টেটে পৌঁছায়।$Q1083$,
  $Q1084$DC মোটর স্টার্টার ডিজাইন (স্টার্টিং কারেন্ট সীমিতকরণ), স্পিড সেন্সরলেস কন্ট্রোল অ্যালগরিদম, এবং ব্রাশলেস DC মোটর কন্ট্রোলারে ব্যবহৃত হয়।$Q1084$,
  ARRAY[$Q1085$DC Motor$Q1085$,$Q1086$Counter EMF$Q1086$,$Q1087$Self-Regulation$Q1087$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1088$Torque-Speed Characteristic$Q1088$,
  $Q1089$T$Q1089$,
  $Q1090$machines$Q1090$,
  $Q1091$Chapman, Ch.6$Q1091$,
  $Q1092$high$Q1092$,
  $Q1093$gauge$Q1093$,
  $Q1094$গতির সাথে টর্কের পরিবর্তনের লেখচিত্র$Q1094$,
  $Q1095$Torque-Speed Characteristic হলো একটি লেখচিত্র যা দেখায় একটি মোটরের আউটপুট টর্ক তার ঘূর্ণন গতির সাথে কীভাবে পরিবর্তিত হয় — এটি একটি মোটর নির্দিষ্ট লোড অ্যাপ্লিকেশনের জন্য উপযুক্ত কিনা তা নির্ধারণে গুরুত্বপূর্ণ।$Q1095$,
  $Q1096$🚗 গাড়ির গিয়ার সিস্টেমের মতো — প্রথম গিয়ারে (কম গতি) বেশি টর্ক (শক্তি) পাওয়া যায় পাহাড় ওঠার জন্য, কিন্তু উচ্চ গিয়ারে (বেশি গতি) টর্ক কমে যায় — প্রতিটি মোটরেরও নিজস্ব এমন একটি বৈশিষ্ট্য থাকে।$Q1096$,
  $Q1097$সঠিক অ্যাপ্লিকেশনের জন্য মোটর নির্বাচন করতে (যেমন হাই-স্টার্টিং-টর্ক দরকার নাকি কনস্ট্যান্ট-স্পিড), এবং VFD/ড্রাইভ টিউনিং-এ ব্যবহৃত হয়।$Q1097$,
  $Q1098$ইন্ডাকশন মোটরের Torque-Speed কার্ভে স্টার্টিং টর্ক তুলনামূলক কম কিন্তু breakdown টর্কের কাছাকাছি (প্রায় ৮০% স্পিডে) সর্বোচ্চ টর্ক পাওয়া যায়, তারপর সিঙ্ক্রোনাস স্পিডের কাছে টর্ক দ্রুত শূন্যে নেমে আসে।$Q1098$,
  $Q1099$DC Shunt মোটরে টর্ক-স্পিড প্রায় সমতল (flat) থাকে; DC Series মোটরে কম গতিতে অতি উচ্চ টর্ক থাকে (হাইপারবোলিক কার্ভ); ইন্ডাকশন মোটরে একটি নির্দিষ্ট বিন্দুতে সর্বোচ্চ (breakdown/pull-out) টর্ক থাকে।$Q1099$,
  $Q1100$ইলেকট্রিক ভেহিকেল মোটর সিলেকশন (হাই-টর্ক স্টার্টিং দরকার), ক্রেন ও লিফট মোটর ডিজাইন, এবং ফ্যান/পাম্প অ্যাপ্লিকেশনে মোটর ম্যাচিং-এ ব্যবহৃত হয়।$Q1100$,
  ARRAY[$Q1101$Motor Selection$Q1101$,$Q1102$Performance Curve$Q1102$,$Q1103$Mechanical Load$Q1103$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1104$Starting Methods of Motor (Starter)$Q1104$,
  $Q1105$S$Q1105$,
  $Q1106$machines$Q1106$,
  $Q1107$Chapman, Ch.6$Q1107$,
  $Q1108$medium$Q1108$,
  $Q1109$switch$Q1109$,
  $Q1110$মোটরের বিশাল স্টার্টিং কারেন্ট নিয়ন্ত্রণের কৌশল$Q1110$,
  $Q1111$Starter হলো একটি যন্ত্র বা কৌশল, যা মোটর চালু করার মুহূর্তে (যখন Back EMF শূন্য থাকে) সৃষ্ট অতিরিক্ত উচ্চ স্টার্টিং কারেন্টকে (সাধারণত রেটেড কারেন্টের 5-8 গুণ) নিয়ন্ত্রিত মাত্রায় সীমিত রাখে, যাতে ওয়াইন্ডিং ও সাপ্লাই সিস্টেম ক্ষতিগ্রস্ত না হয়।$Q1111$,
  $Q1112$🚗 গাড়ির ক্লাচ ধীরে ছাড়ার মতো — হঠাৎ পুরোপুরি ক্লাচ ছেড়ে দিলে ইঞ্জিন ঝাঁকুনি খেয়ে বন্ধ হয়ে যেতে পারে বা গাড়ি ঝটকা মারে, ধীরে ধীরে ছাড়লে (স্টার্টার) মসৃণভাবে গতি পায়।$Q1112$,
  $Q1113$বড় ইন্ডাকশন মোটর (5HP-এর বেশি) চালু করতে Star-Delta Starter, Auto-transformer Starter, বা Soft Starter ব্যবহৃত হয়, যাতে গ্রিডে ভোল্টেজ ডিপ না হয়।$Q1113$,
  $Q1114$একটি বড় পানির পাম্প মোটরে Star-Delta Starter ব্যবহার করে প্রথমে Star কনফিগারেশনে (কম ভোল্টেজ, কম স্টার্টিং কারেন্ট) চালু করে, তারপর নির্দিষ্ট গতিতে পৌঁছালে Delta-তে স্যুইচ করা হয় স্বাভাবিক অপারেশনের জন্য।$Q1114$,
  $Q1115$Star-Delta Starter-এ স্টার্টিং কারেন্ট Direct-On-Line (DOL)-এর তুলনায় ১/৩ ভাগে নেমে আসে, কিন্তু স্টার্টিং টর্কও একই অনুপাতে কমে যায় (কারণ T ∝ V²)।$Q1115$,
  $Q1116$শিল্প কারখানার বড় পাম্প ও কম্প্রেসর মোটর, লিফট/এলিভেটর মোটর, এবং কনভেয়র সিস্টেম স্টার্টআপে ব্যবহৃত হয়।$Q1116$,
  ARRAY[$Q1117$Motor Control$Q1117$,$Q1118$Inrush Current$Q1118$,$Q1119$Star-Delta$Q1119$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1120$Single-Phase Induction Motor$Q1120$,
  $Q1121$S$Q1121$,
  $Q1122$machines$Q1122$,
  $Q1123$Chapman, Ch.9$Q1123$,
  $Q1124$medium$Q1124$,
  $Q1125$motor$Q1125$,
  $Q1126$একক-ফেজ সাপ্লাইয়ে চালিত ছোট মোটর$Q1126$,
  $Q1127$Single-Phase Induction Motor একটি AC মোটর যা একক-ফেজ সাপ্লাই দিয়ে চলে, কিন্তু একক-ফেজ সাপ্লাই নিজে থেকে ঘূর্ণায়মান চৌম্বক ফিল্ড তৈরি করতে পারে না, তাই স্টার্টিং টর্ক পেতে একটি সহায়ক (auxiliary) ওয়াইন্ডিং ও ক্যাপাসিটর প্রয়োজন হয়।$Q1127$,
  $Q1128$🌀 একজনকে দোলনায় ধাক্কা দেওয়ার মতো — একবার শুরুতে (auxiliary winding দিয়ে) সঠিক দিকে ধাক্কা দিলে, এরপর সে নিজে থেকেই দুলতে (ঘুরতে) থাকতে পারে, কিন্তু প্রাথমিক ধাক্কা ছাড়া দোলনা নিজে থেকে শুরু হবে না।$Q1128$,
  $Q1129$গৃহস্থালী যন্ত্রপাতি (ফ্যান, রেফ্রিজারেটর কম্প্রেসর, ওয়াশিং মেশিন) যেখানে সিঙ্গেল-ফেজ AC সাপ্লাই ব্যবহার্য, সেখানে ব্যবহৃত হয়।$Q1129$,
  $Q1130$একটি সিলিং ফ্যানে Capacitor-Start-Capacitor-Run মোটর ব্যবহার করা হয়, যেখানে ক্যাপাসিটর সহায়ক ওয়াইন্ডিং-এ ফেজ শিফট তৈরি করে ফ্যান শুরু করতে সাহায্য করে।$Q1130$,
  $Q1131$একক-ফেজ ফিল্ড আসলে দুটি বিপরীতমুখী ঘূর্ণায়মান ফিল্ডে (forward ও backward) বিভক্ত করা যায় (Double Revolving Field Theory), যা স্টার্টিং-এ নেট টর্ক শূন্য করে — এজন্যই বাহ্যিক সহায়তা ছাড়া এটি নিজে থেকে শুরু হতে পারে না।$Q1131$,
  $Q1132$সিলিং ও টেবিল ফ্যান, রেফ্রিজারেটর ও এসি কম্প্রেসর, ওয়াশিং মেশিন, এবং ছোট ওয়ার্কশপ যন্ত্রপাতিতে ব্যবহৃত হয়।$Q1132$,
  ARRAY[$Q1133$Single-Phase AC$Q1133$,$Q1134$Auxiliary Winding$Q1134$,$Q1135$Household Motor$Q1135$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1136$Stepper Motor$Q1136$,
  $Q1137$S$Q1137$,
  $Q1138$machines$Q1138$,
  $Q1139$Chapman, Ch.9$Q1139$,
  $Q1140$medium$Q1140$,
  $Q1141$motor$Q1141$,
  $Q1142$নির্দিষ্ট ধাপে ধাপে নিয়ন্ত্রিত ঘূর্ণনকারী মোটর$Q1142$,
  $Q1143$Stepper Motor একটি ব্রাশলেস DC মোটর যা পূর্ণ ঘূর্ণনকে অনেকগুলো সমান, বিচ্ছিন্ন ধাপে (step) বিভক্ত করে, এবং প্রতিটি ইলেকট্রিক্যাল পালসে ঠিক একটি নির্দিষ্ট কোণ ঘোরে — এটি ওপেন-লুপে সুনির্দিষ্ট পজিশন কন্ট্রোল দেয়, ফিডব্যাক সেন্সর ছাড়াই।$Q1143$,
  $Q1144$🕰️ ঘড়ির সেকেন্ড কাঁটার মতো — মসৃণভাবে না ঘুরে, প্রতি সেকেন্ডে ঠিক একটি নির্দিষ্ট, গণনাযোগ্য ধাপ (tick) নেয় — কতগুলো ধাপ নিয়েছে তা গুনে আপনি সঠিক অবস্থান জানতে পারেন।$Q1144$,
  $Q1145$3D প্রিন্টার, CNC মেশিন, রোবোটিক্স, এবং ক্যামেরা লেন্স ফোকাসিং-এর মতো সুনির্দিষ্ট পজিশনিং প্রয়োজন এমন অ্যাপ্লিকেশনে ব্যবহৃত হয়।$Q1145$,
  $Q1146$একটি সাধারণ 3D প্রিন্টারে 1.8° প্রতি-স্টেপ স্টেপার মোটর ব্যবহার করা হয়, অর্থাৎ একটি পূর্ণ ঘূর্ণনে (360°) মোট 200টি ধাপ লাগে, যা প্রিন্ট হেডের অবস্থান নিখুঁতভাবে নিয়ন্ত্রণ করে।$Q1146$,
  $Q1147$Step Angle = 360°/(ধাপের সংখ্যা)। মাইক্রোস্টেপিং কৌশল ব্যবহার করে প্রতিটি পূর্ণ ধাপকে আরও ছোট ভাগে ভাগ করে মসৃণতর ও নিখুঁততর গতি নিয়ন্ত্রণ সম্ভব।$Q1147$,
  $Q1148$3D প্রিন্টার ও CNC রাউটার, রোবোটিক আর্ম জয়েন্ট কন্ট্রোল, ক্যামেরা অটো-ফোকাস মেকানিজম, এবং টেক্সটাইল মেশিনে ব্যবহৃত হয়।$Q1148$,
  ARRAY[$Q1149$Position Control$Q1149$,$Q1150$Open-Loop$Q1150$,$Q1151$Digital Motor$Q1151$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1152$Servo Motor$Q1152$,
  $Q1153$S$Q1153$,
  $Q1154$machines$Q1154$,
  $Q1155$Chapman, Ch.9$Q1155$,
  $Q1156$medium$Q1156$,
  $Q1157$sensor$Q1157$,
  $Q1158$ফিডব্যাকসহ নিখুঁত অবস্থান/গতি নিয়ন্ত্রিত মোটর$Q1158$,
  $Q1159$Servo Motor একটি ক্লোজড-লুপ মোটর সিস্টেম, যেখানে একটি পজিশন বা স্পিড সেন্সর (এনকোডার) মোটরের প্রকৃত অবস্থান ক্রমাগত পরিমাপ করে একটি কন্ট্রোলারে ফিডব্যাক পাঠায়, যা কাঙ্ক্ষিত অবস্থানের সাথে তুলনা করে সংশোধনী সিগন্যাল পাঠিয়ে অতি নিখুঁত নিয়ন্ত্রণ নিশ্চিত করে।$Q1159$,
  $Q1160$🚗 GPS নেভিগেশন সিস্টেমের মতো — শুধু গন্তব্য বলে দিলেই হয় না, সিস্টেম ক্রমাগত বর্তমান অবস্থান চেক করে (ফিডব্যাক) প্রয়োজনমতো দিক সংশোধন করতে থাকে, যতক্ষণ না ঠিক গন্তব্যে পৌঁছায়।$Q1160$,
  $Q1161$রোবোটিক্সের জয়েন্ট কন্ট্রোল, RC (রিমোট কন্ট্রোল) খেলনা ও ড্রোন, এবং শিল্প অটোমেশনে নিখুঁত পজিশনিং-এ ব্যবহৃত হয়।$Q1161$,
  $Q1162$একটি রোবোটিক আর্মের প্রতিটি জয়েন্টে সার্ভো মোটর ব্যবহার করা হয়, যা কন্ট্রোলার থেকে নির্দেশিত সঠিক কোণে (যেমন 45.5°) নিখুঁতভাবে পৌঁছায় ও ধরে রাখে, বাহ্যিক ধাক্কা লাগলেও।$Q1162$,
  $Q1163$Error signal e(t) = θ_desired − θ_actual, যা PID কন্ট্রোলারে ব্যবহৃত হয়ে মোটরের ড্রাইভ সিগন্যাল নির্ধারণ করে — Feedback Loop ক্রমাগত এই ত্রুটি শূন্যের কাছাকাছি রাখার চেষ্টা করে।$Q1163$,
  $Q1164$শিল্প রোবোটিক্স ও CNC মেশিনিং, RC কার/প্লেন/ড্রোন কন্ট্রোল সারফেস, এবং প্যাকেজিং মেশিন অটোমেশনে ব্যবহৃত হয়।$Q1164$,
  ARRAY[$Q1165$Closed-Loop Control$Q1165$,$Q1166$Feedback$Q1166$,$Q1167$Precision Motion$Q1167$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1168$Efficiency of Machine$Q1168$,
  $Q1169$E$Q1169$,
  $Q1170$machines$Q1170$,
  $Q1171$Chapman, Ch.4$Q1171$,
  $Q1172$medium$Q1172$,
  $Q1173$gauge$Q1173$,
  $Q1174$ইনপুট শক্তির কতটুকু কার্যকর আউটপুটে রূপান্তরিত হয়$Q1174$,
  $Q1175$Efficiency (η) হলো একটি ইলেকট্রিক্যাল মেশিনের আউটপুট পাওয়ার (কার্যকর) এবং ইনপুট পাওয়ারের অনুপাত, যা শতকরা হিসেবে প্রকাশ করা হয় — বাকি অংশ কপার লস, কোর লস ও ঘর্ষণজনিত লস হিসেবে তাপে অপচয় হয়।$Q1175$,
  $Q1176$🚗 গাড়ির মাইলেজের মতো — এক লিটার তেল (ইনপুট এনার্জি) দিয়ে কত কিলোমিটার যাওয়া যায় (কার্যকর আউটপুট), বাকিটা ইঞ্জিনের তাপ ও ঘর্ষণে অপচয় হয়ে যায়।$Q1176$,
  $Q1177$মোটর ও জেনারেটর নির্বাচনে শক্তি সাশ্রয়ী বিকল্প বেছে নিতে, এবং শিল্প কারখানার এনার্জি অডিটে ব্যবহৃত হয়।$Q1177$,
  $Q1178$একটি প্রিমিয়াম দক্ষতাসম্পন্ন (IE3) ইন্ডাকশন মোটরের দক্ষতা প্রায় 95%, যেখানে একটি পুরনো স্ট্যান্ডার্ড মোটরের দক্ষতা হয়তো মাত্র 85% — এই পার্থক্য দীর্ঘমেয়াদে উল্লেখযোগ্য বিদ্যুৎ সাশ্রয় করে।$Q1178$,
  $Q1179$η = (P_out/P_in) × 100% = P_out/(P_out + P_losses)। মোটরে মোট লস = কপার লস (I²R) + কোর লস (হিস্টেরেসিস ও এডি কারেন্ট) + মেকানিক্যাল লস (ফ্রিকশন ও উইন্ডেজ)।$Q1179$,
  $Q1180$শিল্প কারখানার এনার্জি অডিট, প্রিমিয়াম-এফিসিয়েন্সি মোটর নির্বাচন (IE3/IE4 রেটিং), এবং ইলেকট্রিক ভেহিকেল ড্রাইভট্রেন ডিজাইনে ব্যবহৃত হয়।$Q1180$,
  ARRAY[$Q1181$Energy Loss$Q1181$,$Q1182$Motor Rating$Q1182$,$Q1183$Energy Efficiency$Q1183$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1184$Excitation$Q1184$,
  $Q1185$E$Q1185$,
  $Q1186$machines$Q1186$,
  $Q1187$Chapman, Ch.4$Q1187$,
  $Q1188$low$Q1188$,
  $Q1189$magnet$Q1189$,
  $Q1190$মেশিনের চৌম্বক ফিল্ড তৈরির প্রক্রিয়া$Q1190$,
  $Q1191$Excitation হলো একটি সিঙ্ক্রোনাস মেশিনের রোটরে (ফিল্ড ওয়াইন্ডিং-এ) DC কারেন্ট সরবরাহ করার প্রক্রিয়া, যা প্রয়োজনীয় চৌম্বক ফিল্ড তৈরি করে — এই ফিল্ডের শক্তি নিয়ন্ত্রণ করে জেনারেটরের আউটপুট ভোল্টেজ ও পাওয়ার ফ্যাক্টর নিয়ন্ত্রণ করা যায়।$Q1191$,
  $Q1192$🔥 চুলার আঁচের নবের মতো — নব ঘুরিয়ে (এক্সাইটেশন কারেন্ট বাড়িয়ে-কমিয়ে) আঁচের তীব্রতা (চৌম্বক ফিল্ডের শক্তি) নিয়ন্ত্রণ করা যায়, যা রান্নার (আউটপুট ভোল্টেজের) ফলাফল প্রভাবিত করে।$Q1192$,
  $Q1193$পাওয়ার প্ল্যান্টের জেনারেটর আউটপুট ভোল্টেজ নিয়ন্ত্রণ (Automatic Voltage Regulator-এর মাধ্যমে), এবং সিঙ্ক্রোনাস মোটরের পাওয়ার ফ্যাক্টর নিয়ন্ত্রণে ব্যবহৃত হয়।$Q1193$,
  $Q1194$একটি পাওয়ার প্ল্যান্টের অল্টারনেটরে AVR (Automatic Voltage Regulator) এক্সাইটেশন কারেন্ট স্বয়ংক্রিয়ভাবে সমন্বয় করে, লোড পরিবর্তন হলেও আউটপুট ভোল্টেজ 220V/400V স্থির রাখে।$Q1194$,
  $Q1195$Generated EMF, E ∝ φ (ফ্লাক্স) ∝ I_field (এক্সাইটেশন কারেন্ট)। Over-excitation-এ মেশিন লিডিং পাওয়ার ফ্যাক্টরে কাজ করে (রিয়্যাক্টিভ পাওয়ার সরবরাহ করে), Under-excitation-এ ল্যাগিং।$Q1195$,
  $Q1196$পাওয়ার প্ল্যান্ট জেনারেটর ভোল্টেজ কন্ট্রোল সিস্টেম, সিঙ্ক্রোনাস কনডেনসার (গ্রিড রিয়্যাক্টিভ পাওয়ার সাপোর্ট), এবং জাহাজের বিদ্যুৎ ব্যবস্থায় ব্যবহৃত হয়।$Q1196$,
  ARRAY[$Q1197$Field Winding$Q1197$,$Q1198$Voltage Control$Q1198$,$Q1199$Synchronous Machine$Q1199$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1200$Commutator$Q1200$,
  $Q1201$C$Q1201$,
  $Q1202$machines$Q1202$,
  $Q1203$Chapman, Ch.8$Q1203$,
  $Q1204$medium$Q1204$,
  $Q1205$gauge$Q1205$,
  $Q1206$DC মেশিনে AC কে DC তে রূপান্তরকারী যান্ত্রিক সুইচ$Q1206$,
  $Q1207$Commutator হলো DC মেশিনে ব্যবহৃত তামার সেগমেন্ট দিয়ে তৈরি একটি ঘূর্ণায়মান যান্ত্রিক সুইচ, যা আর্মেচারে উৎপন্ন AC ভোল্টেজকে বাহ্যিক সার্কিটে DC-তে রূপান্তরিত করে (জেনারেটরে) অথবা DC সাপ্লাইকে আর্মেচারে AC-তে রূপান্তর করে (মোটরে), স্থির ব্রাশের সাথে যোগাযোগ রক্ষা করে।$Q1207$,
  $Q1208$🔄 একটি স্বয়ংক্রিয় দিক-পরিবর্তনকারী সংযোগের মতো — যখনই কারেন্টের দিক ভুল হওয়ার কথা, ঠিক তখনই এই যান্ত্রিক সুইচ সংযোগ পাল্টে দেয়, যাতে বাহ্যিক সার্কিটে সবসময় একই দিকে (DC) প্রবাহ বজায় থাকে।$Q1208$,
  $Q1209$পুরনো DC মোটর ও জেনারেটর ডিজাইনে, এবং ছোট ব্রাশড DC মোটরে (যেমন খেলনা, ছোট টুলস) ব্যবহৃত হয়।$Q1209$,
  $Q1210$একটি ব্যাটারি-চালিত খেলনা গাড়ির মোটরে কমিউটেটর ও কার্বন ব্রাশ থাকে, যা মোটর ঘোরার সময় ক্রমাগত সংযোগ পরিবর্তন করে ধারাবাহিক ঘূর্ণন বজায় রাখে।$Q1210$,
  $Q1211$কমিউটেটর সেগমেন্ট সংখ্যা কয়েল সংখ্যার সমানুপাতিক; সেগমেন্ট যত বেশি, আউটপুট DC তত বেশি স্মুথ (কম রিপল) হয়। ব্রাশ ও কমিউটেটরের মধ্যে ঘর্ষণ ও স্পার্কিং মেইনটেন্যান্সের প্রধান কারণ।$Q1211$,
  $Q1212$পুরনো DC মোটর ও জেনারেটর, গাড়ির স্টার্টার মোটর, ছোট পাওয়ার টুলস (ড্রিল মেশিন), এবং শিল্প কারখানার লিগেসি DC ড্রাইভে ব্যবহৃত হয়।$Q1212$,
  ARRAY[$Q1213$DC Machine$Q1213$,$Q1214$Mechanical Rectifier$Q1214$,$Q1215$Brush Contact$Q1215$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1216$Rotor & Stator$Q1216$,
  $Q1217$R$Q1217$,
  $Q1218$machines$Q1218$,
  $Q1219$Chapman, Ch.4$Q1219$,
  $Q1220$high$Q1220$,
  $Q1221$motor$Q1221$,
  $Q1222$মেশিনের ঘূর্ণায়মান ও স্থির প্রধান অংশ$Q1222$,
  $Q1223$প্রতিটি ঘূর্ণায়মান বৈদ্যুতিক মেশিনের দুটি প্রধান অংশ থাকে — Stator হলো মেশিনের স্থির বাহ্যিক অংশ (সাধারণত ওয়াইন্ডিং ধারণ করে), এবং Rotor হলো ভেতরের ঘূর্ণায়মান অংশ, যা শ্যাফটের সাথে যুক্ত থাকে ও যান্ত্রিক শক্তি প্রদান/গ্রহণ করে।$Q1223$,
  $Q1224$🎠 একটি ঘূর্ণায়মান নাগরদোলার মতো — মাটিতে গাঁথা স্থির কাঠামো (Stator) এবং তার ভেতরে ঘূর্ণায়মান আসনগুলো (Rotor) — দুটো মিলেই সম্পূর্ণ সিস্টেম কাজ করে।$Q1224$,
  $Q1225$সব ধরনের মোটর ও জেনারেটরের মৌলিক গঠন বোঝা এবং মেইনটেন্যান্স/ট্রাবলশুটিং-এ (কোন অংশে সমস্যা তা নির্ণয়ে) ব্যবহৃত হয়।$Q1225$,
  $Q1226$একটি ইন্ডাকশন মোটরে Stator-এ থ্রি-ফেজ ওয়াইন্ডিং থাকে যা ঘূর্ণায়মান চৌম্বক ফিল্ড তৈরি করে, আর Rotor (সাধারণত Squirrel Cage টাইপ) সেই ফিল্ডের প্রভাবে ঘোরে ও শ্যাফটের মাধ্যমে যান্ত্রিক শক্তি দেয়।$Q1226$,
  $Q1227$Air Gap (Stator ও Rotor-এর মধ্যকার সরু ফাঁক) যত কম, চৌম্বক কাপলিং তত ভালো ও দক্ষতা বেশি — কিন্তু যান্ত্রিক সহনশীলতার (tolerance) কারণে এটি একটি ন্যূনতম সীমার নিচে নামানো যায় না।$Q1227$,
  $Q1228$সব ধরনের ইলেকট্রিক মোটর ও জেনারেটর (DC, ইন্ডাকশন, সিঙ্ক্রোনাস), টারবাইন জেনারেটর, এবং ইলেকট্রিক ভেহিকেল মোটর ডিজাইনে মৌলিক কাঠামো হিসেবে ব্যবহৃত হয়।$Q1228$,
  ARRAY[$Q1229$Machine Structure$Q1229$,$Q1230$Mechanical Design$Q1230$,$Q1231$Basic Component$Q1231$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1232$Auto-transformer$Q1232$,
  $Q1233$A$Q1233$,
  $Q1234$machines$Q1234$,
  $Q1235$Chapman, Ch.2$Q1235$,
  $Q1236$low$Q1236$,
  $Q1237$transformer$Q1237$,
  $Q1238$একটি একক ওয়াইন্ডিং শেয়ারকারী সাশ্রয়ী ট্রান্সফরমার$Q1238$,
  $Q1239$Auto-transformer একটি বিশেষ ধরনের ট্রান্সফরমার, যেখানে প্রাইমারি ও সেকেন্ডারি একটি সাধারণ (common) ওয়াইন্ডিং শেয়ার করে (আলাদা আলাদা ওয়াইন্ডিং না থাকায়), ফলে এটি স্বাভাবিক দুই-ওয়াইন্ডিং ট্রান্সফরমারের চেয়ে ছোট, হালকা ও সস্তা হয়।$Q1239$,
  $Q1240$🪜 একটি অ্যাডজাস্টেবল মইয়ের মতো — একটি মাত্র মই (একটি ওয়াইন্ডিং) ব্যবহার করে বিভিন্ন উচ্চতায় (ভোল্টেজে) ট্যাপ পয়েন্ট থেকে পৌঁছানো যায়, আলাদা আলাদা দুটি মই বানানোর প্রয়োজন হয় না।$Q1240$,
  $Q1241$মোটর স্টার্টিং-এ (Auto-transformer Starter), ভোল্টেজ স্ট্যাবিলাইজারে, এবং যেখানে সামান্য ভোল্টেজ পরিবর্তন প্রয়োজন সেখানে খরচ কমাতে ব্যবহৃত হয়।$Q1241$,
  $Q1242$একটি ভেরিয়েক (Variac) হলো একটি অ্যাডজাস্টেবল Auto-transformer, যা ল্যাবরেটরিতে ইনপুট ভোল্টেজ ধীরে ধীরে পরিবর্তন করে বিভিন্ন যন্ত্র পরীক্ষা করতে ব্যবহৃত হয়।$Q1242$,
  $Q1243$Auto-transformer-এ ব্যবহৃত তামার পরিমাণ স্বাভাবিক ট্রান্সফরমারের তুলনায় কম, যা টার্নস রেশিওর ওপর নির্ভর করে সাশ্রয়ের পরিমাণ নির্ধারণ করে — কিন্তু প্রাইমারি ও সেকেন্ডারির মধ্যে সরাসরি বৈদ্যুতিক সংযোগ থাকায় ইলেকট্রিক্যাল আইসোলেশন থাকে না (নিরাপত্তা সীমাবদ্ধতা)।$Q1243$,
  $Q1244$মোটর স্টার্টিং সার্কিট, ল্যাবরেটরি ভেরিয়েবল ভোল্টেজ সাপ্লাই (Variac), এবং ভোল্টেজ স্ট্যাবিলাইজারে ব্যবহৃত হয়।$Q1244$,
  ARRAY[$Q1245$Transformer Type$Q1245$,$Q1246$Cost Saving$Q1246$,$Q1247$Single Winding$Q1247$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1248$Universal Motor$Q1248$,
  $Q1249$U$Q1249$,
  $Q1250$machines$Q1250$,
  $Q1251$Chapman, Ch.9$Q1251$,
  $Q1252$low$Q1252$,
  $Q1253$motor$Q1253$,
  $Q1254$AC ও DC উভয় সাপ্লাইয়ে চলতে সক্ষম মোটর$Q1254$,
  $Q1255$Universal Motor একটি বিশেষ ধরনের সিরিজ-উত্তেজিত মোটর, যা ফিল্ড ও আর্মেচার উভয় ওয়াইন্ডিং সিরিজে সংযুক্ত থাকার কারণে AC এবং DC উভয় সাপ্লাইতেই কাজ করতে পারে, এবং প্রতি ইউনিট ওজনে অত্যন্ত উচ্চ গতি ও টর্ক প্রদান করে।$Q1255$,
  $Q1256$🔌 একটি বিশ্বব্যাপী ভ্রমণ অ্যাডাপ্টারের মতো — যেকোনো দেশের (AC বা DC) সাপ্লাইয়ে সংযুক্ত করলেই কাজ করে, আলাদা আলাদা যন্ত্রের দরকার নেই।$Q1256$,
  $Q1257$ছোট, হালকা ও উচ্চ-গতির পোর্টেবল যন্ত্রপাতি যেখানে দ্রুত ঘূর্ণন প্রয়োজন, সেখানে ব্যাপকভাবে ব্যবহৃত হয়।$Q1257$,
  $Q1258$একটি হ্যান্ড ব্লেন্ডার বা ভ্যাকুয়াম ক্লিনারে ইউনিভার্সাল মোটর ব্যবহৃত হয়, যা AC মেইন সাপ্লাইতে সরাসরি প্রতি মিনিটে হাজার হাজার RPM গতিতে ঘোরে।$Q1258$,
  $Q1259$যেহেতু ফিল্ড ও আর্মেচার সিরিজে যুক্ত, তাই টর্ক T ∝ I² (কারেন্টের বর্গের সমানুপাতিক) — এই কারণে কম কারেন্টেও অত্যন্ত উচ্চ স্টার্টিং টর্ক পাওয়া যায়, তবে নো-লোডে গতি বিপজ্জনকভাবে বেড়ে যেতে পারে।$Q1259$,
  $Q1260$ভ্যাকুয়াম ক্লিনার, হ্যান্ড ড্রিল ও পাওয়ার টুলস, কিচেন ব্লেন্ডার ও মিক্সার, এবং সেলাই মেশিনে ব্যবহৃত হয়।$Q1260$,
  ARRAY[$Q1261$AC-DC Motor$Q1261$,$Q1262$Series Motor$Q1262$,$Q1263$High Speed$Q1263$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1264$Synchronous Speed$Q1264$,
  $Q1265$S$Q1265$,
  $Q1266$machines$Q1266$,
  $Q1267$Chapman, Ch.6$Q1267$,
  $Q1268$medium$Q1268$,
  $Q1269$gauge$Q1269$,
  $Q1270$স্টেটর চৌম্বক ফিল্ডের ঘূর্ণন গতি$Q1270$,
  $Q1271$Synchronous Speed (N_s) হলো AC মেশিনের স্টেটরে প্রবাহিত পলিফেজ কারেন্টের কারণে সৃষ্ট ঘূর্ণায়মান চৌম্বক ফিল্ডের গতি, যা সরাসরি সাপ্লাই ফ্রিকোয়েন্সি ও পোল সংখ্যার ওপর নির্ভর করে।$Q1271$,
  $Q1272$🎪 সার্কাস তাঁবুর ঘূর্ণায়মান স্পটলাইটের মতো — আলো একটি নির্দিষ্ট, অপরিবর্তনীয় গতিতে বৃত্তাকারে ঘোরে, যা শুধুমাত্র মোটরের নিয়ন্ত্রণ প্যানেলের সেটিং (ফ্রিকোয়েন্সি ও পোল সংখ্যা) দ্বারা নির্ধারিত, ভেতরের পারফরমারদের (রোটরের) ওপর নির্ভর করে না।$Q1272$,
  $Q1273$ইন্ডাকশন ও সিঙ্ক্রোনাস মোটরের রেফারেন্স গতি হিসেবে, এবং সঠিক পোল সংখ্যার মোটর নির্বাচনে (কাঙ্ক্ষিত গতি পেতে) ব্যবহৃত হয়।$Q1273$,
  $Q1274$50Hz সাপ্লাইতে একটি 4-পোল মোটরের সিঙ্ক্রোনাস স্পিড N_s = 120×50/4 = 1500 RPM, যা সেই মোটরের সর্বোচ্চ তাত্ত্বিক গতি নির্দেশ করে।$Q1274$,
  $Q1275$N_s = 120f/P (f = ফ্রিকোয়েন্সি Hz, P = পোল সংখ্যা)। বেশি পোল মানে কম গতি, কম পোল মানে বেশি গতি — নির্দিষ্ট অ্যাপ্লিকেশনের জন্য সঠিক পোল সংখ্যা বেছে নেওয়া হয়।$Q1275$,
  $Q1276$মোটর সিলেকশন ইঞ্জিনিয়ারিং, VFD ফ্রিকোয়েন্সি ক্যালকুলেশন (ভ্যারিয়েবল স্পিড ড্রাইভ), এবং জেনারেটর ফ্রিকোয়েন্সি ডিজাইনে (পাওয়ার প্ল্যান্টে 50/60Hz পেতে) ব্যবহৃত হয়।$Q1276$,
  ARRAY[$Q1277$Rotating Field$Q1277$,$Q1278$Pole Number$Q1278$,$Q1279$AC Frequency$Q1279$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1280$Modulation$Q1280$,
  $Q1281$M$Q1281$,
  $Q1282$communication$Q1282$,
  $Q1283$Lathi, Ch.4$Q1283$,
  $Q1284$critical$Q1284$,
  $Q1285$wavesine$Q1285$,
  $Q1286$তথ্য সিগন্যাল ক্যারিয়ার ওয়েভে আরোপণ প্রক্রিয়া$Q1286$,
  $Q1287$Modulation হলো একটি প্রক্রিয়া, যেখানে একটি নিম্ন-ফ্রিকোয়েন্সির তথ্য সিগন্যাল (বার্তা) কে একটি উচ্চ-ফ্রিকোয়েন্সির ক্যারিয়ার ওয়েভের অ্যামপ্লিটিউড, ফ্রিকোয়েন্সি বা ফেজ পরিবর্তন করে তার ওপর 'আরোপিত' করা হয়, যাতে সেটি দীর্ঘ দূরত্বে দক্ষতার সাথে প্রেরণ করা যায়।$Q1287$,
  $Q1288$🚌 একটি বাসে চড়ে ভ্রমণের মতো — তোমার বার্তা (তথ্য সিগন্যাল) নিজে থেকে দূরে যেতে পারে না, তাই তাকে একটি দ্রুতগামী বাসে (ক্যারিয়ার ওয়েভ) তুলে দিতে হয়, যা তাকে বহুদূর পর্যন্ত বহন করে নিয়ে যায়।$Q1288$,
  $Q1289$রেডিও ও টেলিভিশন ব্রডকাস্টিং, মোবাইল যোগাযোগ, এবং স্যাটেলাইট কমিউনিকেশনে দীর্ঘ দূরত্বে সিগন্যাল প্রেরণে ব্যবহৃত হয়।$Q1289$,
  $Q1290$একটি FM রেডিও স্টেশন 100 MHz ক্যারিয়ার ফ্রিকোয়েন্সিতে অডিও সিগন্যাল (20Hz-20kHz) মডুলেট করে সম্প্রচার করে, যা রিসিভার আবার ডিমডুলেট করে মূল শব্দে ফিরিয়ে আনে।$Q1290$,
  $Q1291$মডুলেটেড সিগন্যাল: s(t) = A(t)cos(2πf_c t + φ(t)), যেখানে A(t) (AM), f_c (FM), বা φ(t) (PM) কে বার্তা সিগন্যাল দিয়ে পরিবর্তন করা হয়। কম ফ্রিকোয়েন্সির বেসব্যান্ড সিগন্যালকে উচ্চ-ফ্রিকোয়েন্সিতে স্থানান্তর করাই মূল উদ্দেশ্য (Frequency Translation)।$Q1291$,
  $Q1292$রেডিও ও টিভি ব্রডকাস্টিং, মোবাইল ফোন নেটওয়ার্ক (4G/5G), Wi-Fi যোগাযোগ, এবং স্যাটেলাইট টিভি সম্প্রচারে ব্যবহৃত হয়।$Q1292$,
  ARRAY[$Q1293$Communication Basics$Q1293$,$Q1294$Carrier Wave$Q1294$,$Q1295$Signal Transmission$Q1295$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1296$Amplitude Modulation (AM)$Q1296$,
  $Q1297$A$Q1297$,
  $Q1298$communication$Q1298$,
  $Q1299$Lathi, Ch.4$Q1299$,
  $Q1300$critical$Q1300$,
  $Q1301$wavesine$Q1301$,
  $Q1302$বার্তার তীব্রতা অনুযায়ী ক্যারিয়ারের অ্যামপ্লিটিউড পরিবর্তন$Q1302$,
  $Q1303$Amplitude Modulation (AM) হলো একটি মডুলেশন কৌশল, যেখানে ক্যারিয়ার ওয়েভের অ্যামপ্লিটিউড (তীব্রতা) বার্তা সিগন্যালের তাৎক্ষণিক মানের সমানুপাতিক হারে পরিবর্তিত হয়, কিন্তু ক্যারিয়ারের ফ্রিকোয়েন্সি অপরিবর্তিত থাকে।$Q1303$,
  $Q1304$🔊 কথা বলার সময় ফিসফিস থেকে চিৎকার পর্যন্ত ভয়েসের ভলিউম পরিবর্তনের মতো — একই সুরে (ফ্রিকোয়েন্সি) কথা বলছ, শুধু জোরে-আস্তে (অ্যামপ্লিটিউড) করছ, যাতে শ্রোতা তোমার আবেগের তীব্রতা বুঝতে পারে।$Q1304$,
  $Q1305$AM রেডিও ব্রডকাস্টিং (দীর্ঘ পাল্লার যোগাযোগ), এভিয়েশন কমিউনিকেশন, এবং সাধারণ কম-খরচের রেডিও ট্রান্সমিশনে ব্যবহৃত হয়।$Q1305$,
  $Q1306$বাংলাদেশ বেতারের মিডিয়াম ওয়েভ (MW) ব্যান্ড AM মডুলেশন ব্যবহার করে, যা কয়েকশ কিলোমিটার দূর পর্যন্ত সিগন্যাল পৌঁছাতে পারে, যদিও শব্দের মান FM-এর তুলনায় কম।$Q1306$,
  $Q1307$s(t) = [A_c + A_m cos(2πf_m t)]cos(2πf_c t)। Modulation Index m = A_m/A_c (0 থেকে 1-এর মধ্যে হওয়া উচিত, নাহলে over-modulation ও বিকৃতি ঘটে)। Bandwidth = 2×f_m (বার্তা সিগন্যালের সর্বোচ্চ ফ্রিকোয়েন্সির দ্বিগুণ)।$Q1307$,
  $Q1308$AM রেডিও সম্প্রচার, এয়ারক্রাফট পাইলট-কন্ট্রোল টাওয়ার যোগাযোগ, এবং সিভিল ব্যান্ড (CB) রেডিওতে ব্যবহৃত হয়।$Q1308$,
  ARRAY[$Q1309$Analog Modulation$Q1309$,$Q1310$Radio Broadcasting$Q1310$,$Q1311$Amplitude$Q1311$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1312$Frequency Modulation (FM)$Q1312$,
  $Q1313$F$Q1313$,
  $Q1314$communication$Q1314$,
  $Q1315$Lathi, Ch.4$Q1315$,
  $Q1316$critical$Q1316$,
  $Q1317$wavesine$Q1317$,
  $Q1318$বার্তার মান অনুযায়ী ক্যারিয়ারের ফ্রিকোয়েন্সি পরিবর্তন$Q1318$,
  $Q1319$Frequency Modulation (FM) হলো একটি মডুলেশন কৌশল, যেখানে ক্যারিয়ার ওয়েভের ফ্রিকোয়েন্সি বার্তা সিগন্যালের তাৎক্ষণিক মানের সমানুপাতিক হারে পরিবর্তিত হয়, কিন্তু অ্যামপ্লিটিউড স্থির থাকে — এটি AM-এর তুলনায় নয়েজ-প্রতিরোধী।$Q1319$,
  $Q1320$🎤 গান গাওয়ার সময় সুরের ওঠানামার (পিচ) মতো — একই ভলিউমে (অ্যামপ্লিটিউড) গাইছ, কিন্তু সুর (ফ্রিকোয়েন্সি) কখনো উঁচুতে কখনো নিচুতে যাচ্ছে বার্তা প্রকাশ করতে।$Q1320$,
  $Q1321$FM রেডিও ব্রডকাস্টিং (উচ্চমানের সাউন্ড), ওয়াকি-টকি যোগাযোগ, এবং টিভি সাউন্ড ট্রান্সমিশনে ব্যবহৃত হয়।$Q1321$,
  $Q1322$বাংলাদেশের জনপ্রিয় FM রেডিও স্টেশনগুলো (যেমন 88.0-108.0 MHz ব্যান্ডে) FM মডুলেশন ব্যবহার করে, যা AM-এর তুলনায় অনেক পরিষ্কার ও নয়েজ-মুক্ত শব্দ দেয়।$Q1322$,
  $Q1323$Instantaneous Frequency: f(t) = f_c + k_f×m(t)। Frequency Deviation Δf ও Modulation Index β = Δf/f_m। Carson's Rule অনুযায়ী Bandwidth ≈ 2(Δf + f_m), যা AM-এর চেয়ে বেশি bandwidth লাগে কিন্তু নয়েজ ইমিউনিটি বেশি দেয়।$Q1323$,
  $Q1324$FM রেডিও সম্প্রচার, পুলিশ ও নিরাপত্তা বাহিনীর ওয়াকি-টকি, টেলিভিশন সাউন্ড চ্যানেল, এবং ওয়েদার স্যাটেলাইট সিগন্যালে ব্যবহৃত হয়।$Q1324$,
  ARRAY[$Q1325$Analog Modulation$Q1325$,$Q1326$Noise Immunity$Q1326$,$Q1327$Radio Broadcasting$Q1327$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1328$Sampling Theorem$Q1328$,
  $Q1329$S$Q1329$,
  $Q1330$communication$Q1330$,
  $Q1331$Lathi, Ch.6 / Nyquist$Q1331$,
  $Q1332$critical$Q1332$,
  $Q1333$waveform$Q1333$,
  $Q1334$অ্যানালগ সিগন্যাল ডিজিটালাইজেশনের ভিত্তি সূত্র$Q1334$,
  $Q1335$Sampling Theorem (Nyquist Theorem) বলে যে, একটি ব্যান্ড-লিমিটেড অ্যানালগ সিগন্যালকে বিকৃতি বা তথ্য হারানো ছাড়াই সম্পূর্ণরূপে পুনর্গঠন করা সম্ভব, যদি সেটিকে তার সর্বোচ্চ কম্পাঙ্কের কমপক্ষে দ্বিগুণ হারে (Nyquist Rate) স্যাম্পল করা হয়।$Q1335$,
  $Q1336$🎬 চলচ্চিত্রের ফ্রেম রেটের মতো — একটি চলন্ত গাড়ির ছবি যথেষ্ট দ্রুত (প্রতি সেকেন্ডে অনেকগুলো ফ্রেম) না তুললে, ভিডিওতে গাড়ি ঝাঁকুনি খেয়ে বা ভুলভাবে চলতে দেখাবে (Aliasing) — যথেষ্ট দ্রুত তুললে মসৃণ ও সঠিক গতি দেখা যায়।$Q1336$,
  $Q1337$ডিজিটাল অডিও রেকর্ডিং, স্পিচ প্রসেসিং, এবং যেকোনো Analog-to-Digital Conversion (ADC) সিস্টেম ডিজাইনে মৌলিক ভিত্তি হিসেবে ব্যবহৃত হয়।$Q1337$,
  $Q1338$মানুষের শ্রবণ সীমা 20kHz পর্যন্ত হওয়ায়, CD অডিওতে 44.1kHz স্যাম্পলিং রেট ব্যবহার করা হয় (Nyquist রেট 40kHz-এর চেয়ে সামান্য বেশি), যাতে পুরো শ্রবণযোগ্য পরিসীমা নিখুঁতভাবে ক্যাপচার হয়।$Q1338$,
  $Q1339$f_s ≥ 2f_max (f_s = স্যাম্পলিং ফ্রিকোয়েন্সি, f_max = সিগন্যালের সর্বোচ্চ ফ্রিকোয়েন্সি)। এই শর্ত না মানলে Aliasing ঘটে, যেখানে উচ্চ-ফ্রিকোয়েন্সি সিগন্যাল ভুলভাবে নিম্ন-ফ্রিকোয়েন্সি হিসেবে প্রতীয়মান হয়।$Q1339$,
  $Q1340$ডিজিটাল অডিও ও ভিডিও রেকর্ডিং, মেডিকেল ইমেজিং (MRI, আল্ট্রাসাউন্ড), এবং সব ধরনের ডিজিটাল সিগন্যাল প্রসেসিং সিস্টেমে ব্যবহৃত হয়।$Q1340$,
  ARRAY[$Q1341$Nyquist Rate$Q1341$,$Q1342$Analog-to-Digital$Q1342$,$Q1343$Aliasing$Q1343$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1344$Bandwidth$Q1344$,
  $Q1345$B$Q1345$,
  $Q1346$communication$Q1346$,
  $Q1347$Lathi, Ch.2$Q1347$,
  $Q1348$critical$Q1348$,
  $Q1349$filter$Q1349$,
  $Q1350$একটি সিগন্যাল বা চ্যানেলের ফ্রিকোয়েন্সি পরিসীমা$Q1350$,
  $Q1351$Bandwidth হলো একটি সিগন্যাল, চ্যানেল বা সিস্টেমের ব্যবহৃত সর্বোচ্চ ও সর্বনিম্ন ফ্রিকোয়েন্সির মধ্যকার পার্থক্য (Hz-এ পরিমাপ করা হয়) — এটি একটি যোগাযোগ চ্যানেল দিয়ে কত দ্রুত তথ্য পাঠানো যাবে তা নির্ধারণ করে।$Q1351$,
  $Q1352$🛣️ রাস্তার প্রশস্ততার মতো — যত চওড়া রাস্তা (বেশি ব্যান্ডউইথ), তত বেশি গাড়ি (তথ্য) একসাথে চলতে পারে, ফলে যানজট কম হয় ও দ্রুত পৌঁছানো যায়।$Q1352$,
  $Q1353$ইন্টারনেট স্পিড নির্ধারণ, ভিডিও কলিং কোয়ালিটি, এবং যেকোনো যোগাযোগ ব্যবস্থার ডেটা রেট ক্যাপাসিটি পরিকল্পনায় ব্যবহৃত হয়।$Q1353$,
  $Q1354$একটি স্ট্যান্ডার্ড ভয়েস কল চ্যানেলের ব্যান্ডউইথ প্রায় 4kHz (300Hz-3400Hz), যেখানে একটি HD ভিডিও স্ট্রিমিং-এর জন্য কয়েক MHz ব্যান্ডউইথ প্রয়োজন হয়।$Q1354$,
  $Q1355$Shannon-Hartley অনুযায়ী চ্যানেল ক্যাপাসিটি C = B×log₂(1+SNR) — ব্যান্ডউইথ (B) বাড়ালে তথ্য পাঠানোর সর্বোচ্চ হার (C) সরাসরি সমানুপাতিক হারে বাড়ে।$Q1355$,
  $Q1356$ব্রডব্যান্ড ইন্টারনেট প্যাকেজ ডিজাইন, মোবাইল নেটওয়ার্ক স্পেকট্রাম বরাদ্দ, এবং স্যাটেলাইট চ্যানেল প্ল্যানিং-এ ব্যবহৃত হয়।$Q1356$,
  ARRAY[$Q1357$Frequency Range$Q1357$,$Q1358$Channel Capacity$Q1358$,$Q1359$Data Rate$Q1359$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1360$Signal-to-Noise Ratio (SNR)$Q1360$,
  $Q1361$S$Q1361$,
  $Q1362$communication$Q1362$,
  $Q1363$Lathi, Ch.3$Q1363$,
  $Q1364$critical$Q1364$,
  $Q1365$gauge$Q1365$,
  $Q1366$প্রকৃত সিগন্যাল ও অবাঞ্ছিত নয়েজের শক্তি অনুপাত$Q1366$,
  $Q1367$Signal-to-Noise Ratio (SNR) হলো একটি প্রাপ্ত সিগন্যালের পাওয়ার এবং তার সাথে মিশ্রিত নয়েজের পাওয়ারের অনুপাত, সাধারণত ডেসিবেলে (dB) প্রকাশ করা হয় — এটি যোগাযোগ ব্যবস্থার গুণগত মান নির্দেশ করে।$Q1367$,
  $Q1368$🗣️ ভিড়ের মধ্যে কথা বলার মতো — একজনের গলার আওয়াজ (সিগন্যাল) এবং চারপাশের হইচই (নয়েজ)-এর অনুপাত যত বেশি, তত সহজে তার কথা বোঝা যায়; শোরগোল বেশি হলে (কম SNR) কথা বোঝা কঠিন হয়ে পড়ে।$Q1368$,
  $Q1369$মোবাইল নেটওয়ার্ক কভারেজ মান যাচাই, অডিও ইকুইপমেন্ট কোয়ালিটি রেটিং, এবং ওয়্যারলেস কমিউনিকেশন সিস্টেম ডিজাইনে ব্যবহৃত হয়।$Q1369$,
  $Q1370$একটি মোবাইল ফোনের সিগন্যাল বার যদি খুব দুর্বল হয় (কম SNR), তাহলে কল কোয়ালিটি খারাপ হয় বা কল কেটে যায়, কারণ প্রকৃত ভয়েস সিগন্যাল নয়েজের নিচে চাপা পড়ে যায়।$Q1370$,
  $Q1371$SNR(dB) = 10log₁₀(P_signal/P_noise)। উচ্চ SNR (যেমন 30dB+) মানে পরিষ্কার সিগন্যাল; নিম্ন SNR (0dB-এর কাছাকাছি) মানে সিগন্যাল নয়েজের সমান শক্তিশালী, বোঝা কঠিন।$Q1371$,
  $Q1372$মোবাইল নেটওয়ার্ক প্ল্যানিং, অডিও/ভিডিও ইকুইপমেন্ট রেটিং, মেডিকেল সিগন্যাল প্রসেসিং যন্ত্র, এবং স্যাটেলাইট লিংক বাজেট ক্যালকুলেশনে ব্যবহৃত হয়।$Q1372$,
  ARRAY[$Q1373$Signal Quality$Q1373$,$Q1374$Noise$Q1374$,$Q1375$Decibel$Q1375$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1376$Multiplexing (TDM/FDM)$Q1376$,
  $Q1377$M$Q1377$,
  $Q1378$communication$Q1378$,
  $Q1379$Lathi, Ch.7$Q1379$,
  $Q1380$high$Q1380$,
  $Q1381$network$Q1381$,
  $Q1382$একই চ্যানেলে একাধিক সিগন্যাল একসাথে পাঠানোর কৌশল$Q1382$,
  $Q1383$Multiplexing হলো একটি কৌশল, যা একাধিক সিগন্যালকে একই ভৌত মাধ্যমের (কেবল, রেডিও চ্যানেল) মধ্য দিয়ে একসাথে পাঠাতে দেয় — Time Division Multiplexing (TDM) সময়ে ভাগ করে, আর Frequency Division Multiplexing (FDM) ফ্রিকোয়েন্সিতে ভাগ করে সিগন্যালগুলো আলাদা রাখে।$Q1383$,
  $Q1384$🍽️ একটি রেস্তোরাঁর টেবিলের মতো — TDM হলো একই টেবিলে বিভিন্ন সময়ে (টাইম স্লট) বিভিন্ন খদ্দের বসানো, আর FDM হলো একই সময়ে একটি বড় হলঘরে (ফ্রিকোয়েন্সি স্পেস) বিভিন্ন টেবিলে (চ্যানেলে) বিভিন্ন খদ্দের বসানো।$Q1384$,
  $Q1385$টেলিফোন এক্সচেঞ্জে একই তারে অনেক কল একসাথে পাঠানো, কেবল টিভিতে একাধিক চ্যানেল সম্প্রচার, এবং ফাইবার অপটিক কমিউনিকেশনে ব্যবহৃত হয়।$Q1385$,
  $Q1386$একটি ডিজিটাল টেলিফোন এক্সচেঞ্জে TDM ব্যবহার করে একটি একক ফাইবার লাইনে ৩০টি ভয়েস কল একসাথে পাঠানো হয়, প্রতিটি কলকে অতি দ্রুত টাইম স্লট বরাদ্দ করে।$Q1386$,
  $Q1387$FDM-এ মোট ব্যান্ডউইথ = N × (একটি চ্যানেলের ব্যান্ডউইথ) + গার্ড ব্যান্ড। TDM-এ প্রতিটি ইউজার একটি নির্দিষ্ট Time Slot পায়, ফ্রেম রেট = 1/(N × স্লট সময়)।$Q1387$,
  $Q1388$টেলিফোন এক্সচেঞ্জ নেটওয়ার্ক, কেবল টিভি ডিস্ট্রিবিউশন, 4G/5G মোবাইল নেটওয়ার্ক (OFDM একটি উন্নত সংস্করণ), এবং ফাইবার অপটিক কমিউনিকেশনে ব্যবহৃত হয়।$Q1388$,
  ARRAY[$Q1389$Channel Sharing$Q1389$,$Q1390$TDM$Q1390$,$Q1391$FDM$Q1391$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1392$Pulse Code Modulation (PCM)$Q1392$,
  $Q1393$P$Q1393$,
  $Q1394$communication$Q1394$,
  $Q1395$Lathi, Ch.6$Q1395$,
  $Q1396$high$Q1396$,
  $Q1397$binary$Q1397$,
  $Q1398$অ্যানালগ সিগন্যালকে ডিজিটাল বাইনারি কোডে রূপান্তর$Q1398$,
  $Q1399$Pulse Code Modulation (PCM) হলো একটি ডিজিটাল মডুলেশন কৌশল, যেখানে একটি অ্যানালগ সিগন্যালকে তিনটি ধাপে রূপান্তর করা হয় — Sampling (নমুনা নেওয়া), Quantization (নির্দিষ্ট লেভেলে গোলাকার করা), এবং Encoding (বাইনারি সংখ্যায় রূপান্তর)।$Q1399$,
  $Q1400$📐 একটি ছবিকে গ্রিড পেপারে আঁকার মতো — মসৃণ রেখার (অ্যানালগ সিগন্যাল) বদলে গ্রিডের প্রতিটি বক্সের (স্যাম্পল) নিকটতম নির্দিষ্ট লেভেলে (কোয়ান্টাইজড মান) রেখা টানা হয়, তারপর সেটি সংখ্যায় (বাইনারি কোড) লেখা হয়।$Q1400$,
  $Q1401$ডিজিটাল টেলিফোন নেটওয়ার্ক, CD অডিও রেকর্ডিং, এবং ডিজিটাল ভয়েস কমিউনিকেশন সিস্টেমে অ্যানালগ ভয়েসকে ডিজিটাল করতে ব্যবহৃত হয়।$Q1401$,
  $Q1402$টেলিফোন নেটওয়ার্কে ভয়েস সিগন্যাল 8kHz-এ স্যাম্পল করে 8-বিট কোডে এনকোড করা হয়, যার ফলে প্রতিটি ভয়েস চ্যানেলের ডেটা রেট হয় 8000×8 = 64 kbps।$Q1402$,
  $Q1403$Bit Rate = f_s × n (f_s = স্যাম্পলিং ফ্রিকোয়েন্সি, n = প্রতি স্যাম্পলে বিট সংখ্যা)। Quantization Levels = 2ⁿ। বেশি বিট মানে বেশি নির্ভুলতা কিন্তু বেশি ডেটা রেট প্রয়োজন।$Q1403$,
  $Q1404$ডিজিটাল টেলিফোন এক্সচেঞ্জ (৬৪kbps স্ট্যান্ডার্ড), CD ও DVD অডিও, এবং ডিজিটাল ভয়েস রেকর্ডার/VoIP সিস্টেমে ব্যবহৃত হয়।$Q1404$,
  ARRAY[$Q1405$Digital Modulation$Q1405$,$Q1406$Quantization$Q1406$,$Q1407$Encoding$Q1407$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1408$Digital Modulation (ASK/FSK/PSK)$Q1408$,
  $Q1409$D$Q1409$,
  $Q1410$communication$Q1410$,
  $Q1411$Sanjay Sharma, Ch.5$Q1411$,
  $Q1412$high$Q1412$,
  $Q1413$wavesquare$Q1413$,
  $Q1414$বাইনারি তথ্য ক্যারিয়ার ওয়েভে বহনকারী কৌশল$Q1414$,
  $Q1415$Digital Modulation হলো ডিজিটাল (0/1) তথ্যকে একটি অ্যানালগ ক্যারিয়ার ওয়েভের ওপর আরোপ করার কৌশল — ASK (Amplitude Shift Keying) অ্যামপ্লিটিউড পরিবর্তন করে, FSK (Frequency Shift Keying) ফ্রিকোয়েন্সি পরিবর্তন করে, এবং PSK (Phase Shift Keying) ফেজ পরিবর্তন করে বিট প্রতিনিধিত্ব করে।$Q1415$,
  $Q1416$🚩 পতাকা সংকেতের মতো — একটি পতাকা উঁচু (বিট ১) বা নিচু (বিট ০) করে (ASK), অথবা দ্রুত বা ধীরে নাড়িয়ে (FSK), অথবা ভিন্ন কোণে ধরে (PSK) সংকেত পাঠানো যায় — সবগুলোই বাইনারি তথ্য পাঠানোর ভিন্ন ভিন্ন উপায়।$Q1416$,
  $Q1417$Wi-Fi, ব্লুটুথ, মোবাইল ডেটা নেটওয়ার্ক, এবং ডায়াল-আপ মডেমে ডিজিটাল ডেটা রেডিও ওয়েভের মাধ্যমে পাঠাতে ব্যবহৃত হয়।$Q1417$,
  $Q1418$Wi-Fi রাউটার উচ্চ-গতির ডেটা পাঠাতে QPSK বা QAM (PSK ও ASK-এর সমন্বয়) ব্যবহার করে, যা প্রতি সিম্বলে একাধিক বিট এনকোড করতে পারে।$Q1418$,
  $Q1419$PSK সাধারণত সবচেয়ে নয়েজ-প্রতিরোধী (noise-resistant), কারণ ফেজ ডিটেকশন অ্যামপ্লিটিউড পরিবর্তনের প্রতি কম সংবেদনশীল। M-ary মডুলেশনে (যেমন 16-QAM) প্রতি সিম্বলে log₂(M) বিট পাঠানো যায়, যা ডেটা রেট বাড়ায়।$Q1419$,
  $Q1420$Wi-Fi ও মোবাইল ডেটা নেটওয়ার্ক (4G/5G), স্যাটেলাইট ডিজিটাল টিভি, RFID ও IoT ডিভাইস কমিউনিকেশনে ব্যবহৃত হয়।$Q1420$,
  ARRAY[$Q1421$Digital Communication$Q1421$,$Q1422$Keying$Q1422$,$Q1423$Wireless Data$Q1423$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1424$Antenna$Q1424$,
  $Q1425$A$Q1425$,
  $Q1426$communication$Q1426$,
  $Q1427$Haykin, Ch.1$Q1427$,
  $Q1428$high$Q1428$,
  $Q1429$antenna$Q1429$,
  $Q1430$বৈদ্যুতিক সিগন্যালকে রেডিও তরঙ্গে রূপান্তরকারী যন্ত্র$Q1430$,
  $Q1431$Antenna একটি পরিবাহী যন্ত্র, যা ট্রান্সমিটারে বৈদ্যুতিক সিগন্যালকে ইলেকট্রোম্যাগনেটিক (রেডিও) তরঙ্গে রূপান্তরিত করে মহাশূন্যে বিকিরণ করে, অথবা রিসিভারে বিপরীতমুখী কাজ করে — আগত রেডিও তরঙ্গকে বৈদ্যুতিক সিগন্যালে রূপান্তরিত করে।$Q1431$,
  $Q1432$📢 একটি মেগাফোনের মতো — ভেতরের যন্ত্রের (ট্রান্সমিটারের) সিগন্যালকে বাতাসে (স্থানে) ছড়িয়ে দেয়, এবং একই যন্ত্র বিপরীতভাবে দূরের শব্দ (তরঙ্গ) সংগ্রহ করে ভেতরে (রিসিভারে) পাঠাতেও পারে।$Q1432$,
  $Q1433$মোবাইল টাওয়ার, WiFi রাউটার, রেডিও/টিভি সম্প্রচার কেন্দ্র, এবং স্যাটেলাইট ডিশে সিগন্যাল পাঠাতে/গ্রহণ করতে ব্যবহৃত হয়।$Q1433$,
  $Q1434$একটি মোবাইল ফোন টাওয়ারে একাধিক প্যানেল অ্যান্টেনা ব্যবহার করা হয়, প্রতিটি একটি নির্দিষ্ট দিকে (sector) সিগন্যাল পাঠিয়ে আশেপাশের এলাকায় নেটওয়ার্ক কভারেজ দেয়।$Q1434$,
  $Q1435$অ্যান্টেনার দৈর্ঘ্য সাধারণত সিগন্যালের তরঙ্গদৈর্ঘ্যের সাথে সম্পর্কিত (যেমন Quarter-wave: L = λ/4 = c/(4f)) — সঠিক সাইজ না হলে সিগন্যাল কার্যকরভাবে বিকিরণ/গ্রহণ হয় না (Impedance Mismatch)।$Q1435$,
  $Q1436$মোবাইল সেল টাওয়ার, WiFi ও ব্লুটুথ ডিভাইস, স্যাটেলাইট ডিশ (পারাবোলিক অ্যান্টেনা), এবং GPS নেভিগেশন সিস্টেমে ব্যবহৃত হয়।$Q1436$,
  ARRAY[$Q1437$Radio Wave$Q1437$,$Q1438$Transmitter-Receiver$Q1438$,$Q1439$Wireless Hardware$Q1439$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1440$Channel Capacity (Shannon Theorem)$Q1440$,
  $Q1441$C$Q1441$,
  $Q1442$communication$Q1442$,
  $Q1443$Haykin, Ch.9$Q1443$,
  $Q1444$critical$Q1444$,
  $Q1445$formula$Q1445$,
  $Q1446$নয়েজযুক্ত চ্যানেলের সর্বোচ্চ তথ্য প্রেরণ হার$Q1446$,
  $Q1447$Shannon's Channel Capacity Theorem একটি মৌলিক তথ্য তত্ত্ব সূত্র, যা একটি নয়েজযুক্ত যোগাযোগ চ্যানেলের মাধ্যমে ত্রুটি-মুক্তভাবে তথ্য পাঠানোর তাত্ত্বিক সর্বোচ্চ হার (ক্যাপাসিটি) নির্ধারণ করে, ব্যান্ডউইথ ও Signal-to-Noise Ratio-এর উপর ভিত্তি করে।$Q1447$,
  $Q1448$🚰 একটি পাইপের সর্বোচ্চ পানি প্রবাহের সীমার মতো — পাইপ যত চওড়া (ব্যান্ডউইথ) এবং পানি যত পরিষ্কার (উচ্চ SNR), তত বেশি পানি (তথ্য) নিরাপদে (ত্রুটি-মুক্তভাবে) প্রবাহিত করা যায় — এই সর্বোচ্চ সীমাই ক্যাপাসিটি।$Q1448$,
  $Q1449$যেকোনো যোগাযোগ ব্যবস্থার তাত্ত্বিক সর্বোচ্চ ডেটা রেট নির্ধারণে, এবং মডেম বা ওয়্যারলেস নেটওয়ার্ক ডিজাইনের কর্মক্ষমতা মূল্যায়নে ব্যবহৃত হয়।$Q1449$,
  $Q1450$একটি টেলিফোন লাইনের ব্যান্ডউইথ 3kHz এবং SNR 1000 (30dB) হলে, C = 3000×log₂(1001) ≈ 30 kbps — যা ব্যাখ্যা করে কেন পুরনো ডায়াল-আপ মডেম 56kbps-এর বেশি গতি পেত না।$Q1450$,
  $Q1451$C = B×log₂(1 + SNR), যেখানে C = bits/second-এ চ্যানেল ক্যাপাসিটি, B = ব্যান্ডউইথ (Hz), SNR = রৈখিক অনুপাত (dB নয়)। এই সীমা অতিক্রম করে ত্রুটি-মুক্ত যোগাযোগ সম্ভব নয়, যতই এনকোডিং কৌশল উন্নত করা হোক না কেন।$Q1451$,
  $Q1452$4G/5G নেটওয়ার্ক ডিজাইন ও স্পেকট্রাম প্ল্যানিং, স্যাটেলাইট লিংক বাজেট ক্যালকুলেশন, এবং ডেটা কমপ্রেশন/এনকোডিং প্রযুক্তির তাত্ত্বিক সীমা নির্ধারণে ব্যবহৃত হয়।$Q1452$,
  ARRAY[$Q1453$Information Theory$Q1453$,$Q1454$Shannon-Hartley$Q1454$,$Q1455$Data Rate Limit$Q1455$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1456$Superheterodyne Receiver$Q1456$,
  $Q1457$S$Q1457$,
  $Q1458$communication$Q1458$,
  $Q1459$Haykin, Ch.3$Q1459$,
  $Q1460$medium$Q1460$,
  $Q1461$chip$Q1461$,
  $Q1462$সাধারণ IF ফ্রিকোয়েন্সিতে রূপান্তর করে সিগন্যাল গ্রহণকারী রিসিভার$Q1462$,
  $Q1463$Superheterodyne Receiver একটি রেডিও রিসিভার ডিজাইন, যা আগত উচ্চ-ফ্রিকোয়েন্সি সিগন্যালকে একটি লোকাল অসিলেটরের সাথে মিশিয়ে (mixing) একটি স্থির, নিম্নতর Intermediate Frequency (IF)-এ রূপান্তরিত করে, যা সহজে ফিল্টার ও অ্যামপ্লিফাই করা যায় — এটি বেশিরভাগ আধুনিক রেডিও রিসিভারের ভিত্তি।$Q1463$,
  $Q1464$🌐 ভাষা অনুবাদকের মতো — বিভিন্ন ভাষার (বিভিন্ন ফ্রিকোয়েন্সির) বার্তা প্রথমে একটি সাধারণ, পরিচিত ভাষায় (IF ফ্রিকোয়েন্সি) অনুবাদ করা হয়, তারপর সহজেই প্রসেস করা যায়, চ্যানেল যাই হোক না কেন।$Q1464$,
  $Q1465$AM/FM রেডিও, টেলিভিশন রিসিভার, এবং মোবাইল ফোনের RF ফ্রন্ট-এন্ডে ব্যাপকভাবে ব্যবহৃত হয়।$Q1465$,
  $Q1466$একটি FM রেডিও রিসিভার যেকোনো স্টেশনের ফ্রিকোয়েন্সিকে (88-108 MHz) লোকাল অসিলেটর দিয়ে মিশিয়ে সবসময় একই 10.7 MHz IF-এ রূপান্তর করে, যাতে একই ফিল্টার ও অ্যামপ্লিফায়ার সার্কিট সব স্টেশনের জন্য ব্যবহার করা যায়।$Q1466$,
  $Q1467$f_IF = |f_LO − f_RF| (LO = Local Oscillator, RF = আগত সিগন্যাল ফ্রিকোয়েন্সি)। এই ডিজাইনে Image Frequency (f_LO + f_IF) সমস্যা এড়াতে সঠিক ফিল্টারিং প্রয়োজন হয়।$Q1467$,
  $Q1468$সব ধরনের AM/FM রেডিও রিসিভার, টিভি টিউনার, মোবাইল ফোন RF রিসিভার সেকশন, এবং RADAR সিস্টেমে ব্যবহৃত হয়।$Q1468$,
  ARRAY[$Q1469$Receiver Design$Q1469$,$Q1470$IF Conversion$Q1470$,$Q1471$Radio Architecture$Q1471$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1472$Carrier Wave$Q1472$,
  $Q1473$C$Q1473$,
  $Q1474$communication$Q1474$,
  $Q1475$Lathi, Ch.4$Q1475$,
  $Q1476$medium$Q1476$,
  $Q1477$wavesine$Q1477$,
  $Q1478$তথ্য বহনকারী উচ্চ-কম্পাঙ্কের মূল তরঙ্গ$Q1478$,
  $Q1479$Carrier Wave হলো একটি উচ্চ-ফ্রিকোয়েন্সির সাইনুসয়েডাল তরঙ্গ, যা নিজে কোনো তথ্য বহন করে না, কিন্তু মডুলেশন প্রক্রিয়ায় বার্তা সিগন্যাল এর ওপর 'আরোপিত' হয়ে দীর্ঘ দূরত্বে সিগন্যাল পরিবহনে সহায়তা করে।$Q1479$,
  $Q1480$🚂 একটি পণ্যবাহী ট্রেনের মতো — ট্রেন নিজে (ক্যারিয়ার ওয়েভ) কোনো নির্দিষ্ট পণ্য নয়, কিন্তু এটি বিভিন্ন পণ্য (তথ্য সিগন্যাল) বহন করে গন্তব্যে পৌঁছে দেয়।$Q1480$,
  $Q1481$সব ধরনের রেডিও যোগাযোগ ব্যবস্থার মৌলিক উপাদান হিসেবে, তথ্যকে দূরত্বে পাঠাতে ব্যবহৃত হয়।$Q1481$,
  $Q1482$একটি Wi-Fi রাউটার 2.4 GHz বা 5 GHz ক্যারিয়ার ফ্রিকোয়েন্সি ব্যবহার করে, যার ওপর ইন্টারনেট ডেটা (তথ্য সিগন্যাল) মডুলেট করে পাঠানো হয়।$Q1482$,
  $Q1483$s_carrier(t) = A_c cos(2πf_c t + φ_c)। ক্যারিয়ার ফ্রিকোয়েন্সি (f_c) সবসময় বার্তা সিগন্যালের সর্বোচ্চ ফ্রিকোয়েন্সির চেয়ে অনেক বেশি হতে হয়, যাতে কার্যকর অ্যান্টেনা ডিজাইন ও চ্যানেল বিভাজন সম্ভব হয়।$Q1483$,
  $Q1484$রেডিও ও টিভি সম্প্রচার, মোবাইল নেটওয়ার্ক, Wi-Fi ও ব্লুটুথ, এবং স্যাটেলাইট কমিউনিকেশনে মৌলিক উপাদান হিসেবে ব্যবহৃত হয়।$Q1484$,
  ARRAY[$Q1485$Modulation Basics$Q1485$,$Q1486$High-Frequency Wave$Q1486$,$Q1487$Signal Transport$Q1487$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1488$Bit Error Rate (BER)$Q1488$,
  $Q1489$B$Q1489$,
  $Q1490$communication$Q1490$,
  $Q1491$Sanjay Sharma, Ch.6$Q1491$,
  $Q1492$medium$Q1492$,
  $Q1493$gauge$Q1493$,
  $Q1494$ভুল প্রাপ্ত বিটের অনুপাত$Q1494$,
  $Q1495$Bit Error Rate (BER) হলো একটি ডিজিটাল যোগাযোগ ব্যবস্থায় মোট প্রেরিত বিটের মধ্যে কতগুলো বিট ভুলভাবে গ্রহণ করা হয়েছে তার অনুপাত — এটি একটি যোগাযোগ ব্যবস্থার নির্ভরযোগ্যতা ও গুণমান পরিমাপের প্রধান মানদণ্ড।$Q1495$,
  $Q1496$📝 ডিকটেশন লেখার মতো — একজন যত বেশি শব্দ ভুল লেখে (ভুল বিট) মোট বলা শব্দের (মোট বিট) তুলনায়, তার শোনা ও লেখার দক্ষতা (যোগাযোগ ব্যবস্থার মান) তত খারাপ বলে বিবেচিত হয়।$Q1496$,
  $Q1497$মোবাইল নেটওয়ার্ক কোয়ালিটি টেস্টিং, ফাইবার অপটিক লিংক পারফরমেন্স যাচাই, এবং যেকোনো ডিজিটাল যোগাযোগ সিস্টেমের নির্ভরযোগ্যতা মূল্যায়নে ব্যবহৃত হয়।$Q1497$,
  $Q1498$একটি ফাইবার অপটিক লিংকে BER = 10⁻⁹ মানে প্রতি এক বিলিয়ন বিটের মধ্যে গড়ে মাত্র একটি বিট ভুল হয় — যা অত্যন্ত উচ্চমানের নির্ভরযোগ্য যোগাযোগ নির্দেশ করে।$Q1498$,
  $Q1499$BER = (ভুল বিট সংখ্যা)/(মোট প্রেরিত বিট সংখ্যা)। BER সাধারণত SNR-এর সাথে বিপরীতভাবে সম্পর্কিত — SNR বাড়লে BER কমে, এবং প্রতিটি মডুলেশন স্কিমের (BPSK, QPSK) নিজস্ব BER-vs-SNR কার্ভ থাকে।$Q1499$,
  $Q1500$মোবাইল ও ফাইবার নেটওয়ার্ক কোয়ালিটি অ্যাসুরেন্স, স্যাটেলাইট লিংক টেস্টিং, এবং ডেটা স্টোরেজ সিস্টেম (হার্ড ড্রাইভ) নির্ভরযোগ্যতা যাচাইয়ে ব্যবহৃত হয়।$Q1500$,
  ARRAY[$Q1501$Digital Communication Quality$Q1501$,$Q1502$Error Rate$Q1502$,$Q1503$Reliability Metric$Q1503$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1504$Spread Spectrum$Q1504$,
  $Q1505$S$Q1505$,
  $Q1506$communication$Q1506$,
  $Q1507$Haykin, Ch.10$Q1507$,
  $Q1508$low$Q1508$,
  $Q1509$wavesine$Q1509$,
  $Q1510$সিগন্যালকে বিস্তৃত ব্যান্ডউইথে ছড়িয়ে দেওয়ার কৌশল$Q1510$,
  $Q1511$Spread Spectrum একটি টেকনিক, যেখানে একটি সংকীর্ণ-ব্যান্ড সিগন্যালকে ইচ্ছাকৃতভাবে একটি অনেক প্রশস্ত ফ্রিকোয়েন্সি পরিসরে ছড়িয়ে দেওয়া হয়, যা সিগন্যালকে জ্যামিং, নয়েজ ও আড়িপাতা (interception) থেকে অধিক প্রতিরোধী করে এবং একই ব্যান্ডউইথে একাধিক ব্যবহারকারী ভাগাভাগি করতে দেয়।$Q1511$,
  $Q1512$🗣️ একটি জনাকীর্ণ পার্টিতে অনেকগুলো ছোট ছোট কথোপকথনে একই কথা টুকরো টুকরো করে ছড়িয়ে বলার মতো — বাইরের কেউ পুরো কথোপকথন সহজে বুঝতে বা ব্যাহত করতে পারে না, কিন্তু ইচ্ছুক শ্রোতা (সঠিক কোড জানা রিসিভার) টুকরোগুলো একত্র করে পুরো বার্তা বুঝতে পারে।$Q1512$,
  $Q1513$সামরিক নিরাপদ যোগাযোগ, GPS নেভিগেশন সিস্টেম, এবং CDMA-ভিত্তিক মোবাইল নেটওয়ার্কে ব্যবহৃত হয়।$Q1513$,
  $Q1514$GPS স্যাটেলাইট সিগন্যাল Spread Spectrum ব্যবহার করে পাঠানো হয়, যা মাটির খুব দুর্বল সিগন্যাল লেভেলেও (নয়েজের নিচে) নির্ভুলভাবে ডিটেক্ট ও ডিকোড করা সম্ভব করে।$Q1514$,
  $Q1515$Processing Gain = Spread Bandwidth/Original Bandwidth। Direct Sequence Spread Spectrum (DSSS)-এ একটি উচ্চ-হারের PN (Pseudo-random Noise) কোড দিয়ে মূল সিগন্যাল গুণ করে ছড়িয়ে দেওয়া হয়।$Q1515$,
  $Q1516$সামরিক ও নিরাপত্তা যোগাযোগ, GPS ও GNSS নেভিগেশন, পুরনো CDMA মোবাইল নেটওয়ার্ক, এবং Wi-Fi-এর কিছু লিগেসি মোডে ব্যবহৃত হয়।$Q1516$,
  ARRAY[$Q1517$Secure Communication$Q1517$,$Q1518$CDMA$Q1518$,$Q1519$Anti-Jamming$Q1519$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1520$Satellite Communication$Q1520$,
  $Q1521$S$Q1521$,
  $Q1522$communication$Q1522$,
  $Q1523$Sanjay Sharma, Ch.9$Q1523$,
  $Q1524$medium$Q1524$,
  $Q1525$satellite$Q1525$,
  $Q1526$মহাকাশে অবস্থিত স্যাটেলাইটের মাধ্যমে যোগাযোগ$Q1526$,
  $Q1527$Satellite Communication হলো একটি যোগাযোগ ব্যবস্থা, যেখানে পৃথিবীর কক্ষপথে স্থাপিত একটি স্যাটেলাইট মাটির একটি স্টেশন (uplink) থেকে সিগন্যাল গ্রহণ করে, তা অ্যামপ্লিফাই ও ফ্রিকোয়েন্সি রূপান্তর করে, তারপর অন্য একটি বা একাধিক স্টেশনে (downlink) পুনরায় প্রেরণ করে — যা ভূপৃষ্ঠের বাধা (পাহাড়, দূরত্ব) অতিক্রম করে বিশাল এলাকা কভার করতে সাহায্য করে।$Q1527$,
  $Q1528$🪞 আকাশে একটি বিশাল আয়নার মতো — একটি জায়গা থেকে আলো (সিগন্যাল) ছুড়ে দিলে, আয়না (স্যাটেলাইট) সেটি প্রতিফলিত করে অনেক দূরের আরেকটি জায়গায় পৌঁছে দেয়, যেখানে সরাসরি সরল রেখায় দেখা সম্ভব নয়।$Q1528$,
  $Q1529$স্যাটেলাইট টিভি সম্প্রচার, দূরবর্তী ও প্রত্যন্ত এলাকায় ইন্টারনেট সংযোগ, এবং আন্তর্জাতিক ফোন কল রাউটিং-এ ব্যবহৃত হয়।$Q1529$,
  $Q1530$বাংলাদেশের প্রথম স্যাটেলাইট 'বঙ্গবন্ধু-১' একটি Geostationary Orbit (৩৬,০০০ কিমি উচ্চতায়) স্যাটেলাইট, যা টিভি সম্প্রচার ও ব্যাকআপ যোগাযোগ সেবা দেয়।$Q1530$,
  $Q1531$Geostationary Orbit-এ স্যাটেলাইট পৃথিবীর ঘূর্ণনের সাথে সিঙ্ক্রোনাইজড থাকে (24 ঘণ্টায় একবার প্রদক্ষিণ), ফলে মাটি থেকে দেখতে সবসময় একই স্থানে স্থির মনে হয় — যা ট্র্যাকিং অ্যান্টেনার প্রয়োজনীয়তা দূর করে।$Q1531$,
  $Q1532$DTH (Direct-to-Home) স্যাটেলাইট টিভি, প্রত্যন্ত অঞ্চলে VSAT ইন্টারনেট, আবহাওয়া পূর্বাভাস স্যাটেলাইট, এবং আন্তর্জাতিক ব্রডকাস্ট রিলেতে ব্যবহৃত হয়।$Q1532$,
  ARRAY[$Q1533$Geostationary Orbit$Q1533$,$Q1534$Uplink-Downlink$Q1534$,$Q1535$Wide Area Coverage$Q1535$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1536$Fiber Optic Communication$Q1536$,
  $Q1537$F$Q1537$,
  $Q1538$communication$Q1538$,
  $Q1539$Sanjay Sharma, Ch.11$Q1539$,
  $Q1540$high$Q1540$,
  $Q1541$cloud$Q1541$,
  $Q1542$আলোর সংকেত দিয়ে অতি উচ্চ-গতির তথ্য প্রেরণ$Q1542$,
  $Q1543$Fiber Optic Communication হলো একটি যোগাযোগ প্রযুক্তি, যেখানে তথ্যকে আলোর পালস (LED বা লেজার থেকে) হিসেবে এনকোড করে একটি অতি সরু কাচ বা প্লাস্টিকের তন্তুর (fiber) মধ্য দিয়ে টোটাল ইন্টারনাল রিফ্লেকশনের মাধ্যমে পাঠানো হয় — এটি ব্যাপক ব্যান্ডউইথ ও অতি নিম্ন সিগন্যাল লসের সুবিধা দেয়।$Q1543$,
  $Q1544$🪞 একটি বাঁকা আয়নার সুড়ঙ্গের মতো — আলো (সিগন্যাল) দেয়ালে (fiber-এর কোরের সীমানায়) বারবার প্রতিফলিত হতে হতে বহুদূর পর্যন্ত এগিয়ে যায়, বাইরে না বেরিয়ে, প্রায় কোনো শক্তি না হারিয়ে।$Q1544$,
  $Q1545$ইন্টারনেট ব্যাকবোন নেটওয়ার্ক, আন্তর্মহাদেশীয় সাবমেরিন কেবল, এবং ব্রডব্যান্ড ফাইবার-টু-দ্য-হোম (FTTH) সংযোগে ব্যবহৃত হয়।$Q1545$,
  $Q1546$বাংলাদেশ SEA-ME-WE সাবমেরিন কেবল সিস্টেমের মাধ্যমে ফাইবার অপটিক প্রযুক্তি দিয়ে আন্তর্জাতিক ইন্টারনেট ব্যান্ডউইথ পায়, যা তামার ক্যাবলের তুলনায় বহুগুণ দ্রুত ও নির্ভরযোগ্য।$Q1546$,
  $Q1547$সিগন্যাল Fiber-এর মূল অংশে (Core, উচ্চ রিফ্র্যাকটিভ ইনডেক্স) আটকে থাকে Total Internal Reflection-এর মাধ্যমে, কারণ চারপাশের Cladding-এর রিফ্র্যাকটিভ ইনডেক্স তুলনামূলক কম রাখা হয়। Attenuation সাধারণত তামার তারের চেয়ে বহুগুণ কম (dB/km-এ)।$Q1547$,
  $Q1548$আন্তর্জাতিক ইন্টারনেট ব্যাকবোন, সাবমেরিন কমিউনিকেশন কেবল, ডেটা সেন্টার ইন্টারকানেক্ট, এবং হাসপাতালের মেডিকেল ইমেজিং ডেটা ট্রান্সফারে ব্যবহৃত হয়।$Q1548$,
  ARRAY[$Q1549$Optical Communication$Q1549$,$Q1550$Total Internal Reflection$Q1550$,$Q1551$High Bandwidth$Q1551$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1552$Multipath Fading$Q1552$,
  $Q1553$M$Q1553$,
  $Q1554$communication$Q1554$,
  $Q1555$Haykin, Ch.13$Q1555$,
  $Q1556$low$Q1556$,
  $Q1557$wavesine$Q1557$,
  $Q1558$একাধিক প্রতিফলিত পথে সিগন্যাল দুর্বল হওয়া$Q1558$,
  $Q1559$Multipath Fading হলো একটি ঘটনা, যেখানে একটি বেতার সিগন্যাল বিভিন্ন বস্তু (দালান, পাহাড়) থেকে প্রতিফলিত হয়ে একাধিক ভিন্ন পথে রিসিভারে পৌঁছায়, এবং এই বিভিন্ন পথের সময়ের পার্থক্যের কারণে সিগন্যালগুলো একে অপরের সাথে গঠনমূলক (শক্তিশালী) বা ধ্বংসাত্মক (দুর্বল) হস্তক্ষেপ করে।$Q1559$,
  $Q1560$🎤 একটি বড় হলঘরে ইকো (প্রতিধ্বনি)-এর মতো — সরাসরি কথা (direct path) ও দেয়ালে প্রতিফলিত কথা (reflected path) কানে একটু ভিন্ন সময়ে পৌঁছে একসাথে মিশে যায়, ফলে কখনো শব্দ পরিষ্কার শোনা যায়, কখনো বিকৃত বা মিইয়ে যাওয়া মনে হয়।$Q1560$,
  $Q1561$শহরে মোবাইল নেটওয়ার্ক ডিজাইন, ইনডোর WiFi কভারেজ প্ল্যানিং, এবং ডিজিটাল টিভি রিসেপশন সমস্যা বিশ্লেষণে বিবেচনা করা হয়।$Q1561$,
  $Q1562$একটি উঁচু দালানের মধ্যে মোবাইল সিগন্যাল বিভিন্ন দেয়াল থেকে প্রতিফলিত হয়ে আসার কারণে, একই ঘরের মধ্যে কয়েক ফুট দূরত্বে সরে গেলেও সিগন্যাল স্ট্রেংথ হঠাৎ কমে-বাড়ে (fading) — এটাই মাল্টিপাথ ফেডিং-এর প্রভাব।$Q1562$,
  $Q1563$রিসিভড সিগন্যাল = Σ (বিভিন্ন পথের সিগন্যাল, প্রতিটির ভিন্ন amplitude ও delay)। Rayleigh Fading Model প্রায়ই শহুরে এলাকায় সরাসরি দৃষ্টিরেখা (Line-of-Sight) না থাকা পরিস্থিতিতে ব্যবহৃত হয়।$Q1563$,
  $Q1564$মোবাইল নেটওয়ার্ক টাওয়ার প্লেসমেন্ট প্ল্যানিং, MIMO অ্যান্টেনা সিস্টেম ডিজাইন (মাল্টিপাথ থেকে সুবিধা নেওয়া), এবং ইনডোর ওয়্যারলেস কভারেজ অপটিমাইজেশনে ব্যবহৃত হয়।$Q1564$,
  ARRAY[$Q1565$Wireless Propagation$Q1565$,$Q1566$Signal Interference$Q1566$,$Q1567$Rayleigh Fading$Q1567$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1568$Quantization$Q1568$,
  $Q1569$Q$Q1569$,
  $Q1570$communication$Q1570$,
  $Q1571$Lathi, Ch.6$Q1571$,
  $Q1572$medium$Q1572$,
  $Q1573$binary$Q1573$,
  $Q1574$ধারাবাহিক মানকে সীমিত বিচ্ছিন্ন লেভেলে রূপান্তর$Q1574$,
  $Q1575$Quantization হলো একটি প্রক্রিয়া, যেখানে একটি ধারাবাহিক (continuous) অ্যামপ্লিটিউড মানকে সসীম সংখ্যক পূর্বনির্ধারিত বিচ্ছিন্ন (discrete) লেভেলের মধ্যে নিকটতমটিতে গোলাকার করা হয় — এটি PCM-এর দ্বিতীয় ধাপ এবং Analog-to-Digital Conversion-এর একটি অপরিহার্য অংশ।$Q1575$,
  $Q1576$🪜 একটি সিঁড়ির ধাপের মতো — একটি ঢালু র‍্যাম্পে (ধারাবাহিক মান) যেকোনো উচ্চতায় দাঁড়ানো যায়, কিন্তু সিঁড়িতে (কোয়ান্টাইজড লেভেল) শুধুমাত্র নির্দিষ্ট ধাপের উচ্চতায় দাঁড়াতে হয় — যেটির সবচেয়ে কাছে, সেই ধাপেই উঠতে হয়।$Q1576$,
  $Q1577$ডিজিটাল অডিও/ভিডিও এনকোডিং, ডিজিটাল ক্যামেরা ইমেজ প্রসেসিং, এবং যেকোনো ADC (Analog-to-Digital Converter) ডিজাইনে ব্যবহৃত হয়।$Q1577$,
  $Q1578$একটি 8-বিট অডিও সিস্টেমে 256টি সম্ভাব্য কোয়ান্টাইজেশন লেভেল থাকে, যেখানে 16-বিট সিস্টেমে (CD কোয়ালিটি) 65,536টি লেভেল থাকে, যা অনেক বেশি সূক্ষ্ম ও নির্ভুল প্রতিনিধিত্ব দেয়।$Q1578$,
  $Q1579$Quantization Error e = x(actual) − x(quantized), যা সর্বোচ্চ ±(Δ/2) হতে পারে (Δ = step size)। Quantization Noise Power ≈ Δ²/12। বেশি বিট (n) মানে বেশি লেভেল (2ⁿ) ও কম কোয়ান্টাইজেশন এরর।$Q1579$,
  $Q1580$ডিজিটাল অডিও রেকর্ডিং (CD, MP3), ডিজিটাল ইমেজ ও ভিডিও কমপ্রেশন (JPEG, MPEG), এবং সেন্সর ডেটা ডিজিটাইজেশনে ব্যবহৃত হয়।$Q1580$,
  ARRAY[$Q1581$ADC$Q1581$,$Q1582$Discrete Levels$Q1582$,$Q1583$PCM Component$Q1583$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1584$Phase Modulation (PM)$Q1584$,
  $Q1585$P$Q1585$,
  $Q1586$communication$Q1586$,
  $Q1587$Lathi, Ch.4$Q1587$,
  $Q1588$medium$Q1588$,
  $Q1589$wavesine$Q1589$,
  $Q1590$বার্তার মান অনুযায়ী ক্যারিয়ারের ফেজ পরিবর্তন$Q1590$,
  $Q1591$Phase Modulation (PM) হলো একটি মডুলেশন কৌশল, যেখানে ক্যারিয়ার ওয়েভের ফেজ (দশা) বার্তা সিগন্যালের তাৎক্ষণিক মানের সমানুপাতিক হারে পরিবর্তিত হয়, অ্যামপ্লিটিউড স্থির থাকে — এটি FM-এর ঘনিষ্ঠভাবে সম্পর্কিত এবং একই পরিবার Angle Modulation-এর অন্তর্ভুক্ত।$Q1591$,
  $Q1592$🚶 হাঁটার তালের মতো — একই গতিতে (ফ্রিকোয়েন্সি) হাঁটছ, কিন্তু কোন পায়ে (বাম না ডান, অর্থাৎ ফেজে) কখন পা ফেলছ তা বার্তা অনুযায়ী সামান্য এগিয়ে বা পিছিয়ে দিচ্ছ।$Q1592$,
  $Q1593$ডিজিটাল মডুলেশনের ভিত্তি (PSK), স্যাটেলাইট কমিউনিকেশন, এবং কিছু বিশেষায়িত রেডিও সিস্টেমে ব্যবহৃত হয়।$Q1593$,
  $Q1594$আধুনিক ডিজিটাল মডুলেশন স্কিম যেমন QPSK মূলত Phase Modulation-এর একটি ডিজিটাল রূপ, যেখানে চারটি ভিন্ন ফেজ চারটি ভিন্ন বিট-জোড়া প্রতিনিধিত্ব করে।$Q1594$,
  $Q1595$s(t) = A_c cos(2πf_c t + k_p×m(t))। PM ও FM গাণিতিকভাবে সম্পর্কিত — একটি সিগন্যালের PM আসলে তার ইন্টিগ্রেলের FM-এর সমতুল্য (এবং বিপরীতভাবে)।$Q1595$,
  $Q1596$ডিজিটাল স্যাটেলাইট যোগাযোগ, PSK-ভিত্তিক ডেটা মডেম, এবং কিছু মিলিটারি রেডিও সিস্টেমে ব্যবহৃত হয়।$Q1596$,
  ARRAY[$Q1597$Analog Modulation$Q1597$,$Q1598$Angle Modulation$Q1598$,$Q1599$Phase Shift$Q1599$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1600$Transfer Function$Q1600$,
  $Q1601$T$Q1601$,
  $Q1602$control$Q1602$,
  $Q1603$Nise, Ch.2$Q1603$,
  $Q1604$critical$Q1604$,
  $Q1605$formula$Q1605$,
  $Q1606$আউটপুট ও ইনপুটের Laplace ডোমেইন অনুপাত$Q1606$,
  $Q1607$Transfer Function G(s) হলো একটি লিনিয়ার টাইম-ইনভ্যারিয়ান্ট (LTI) সিস্টেমের আউটপুট ও ইনপুটের Laplace রূপান্তরের অনুপাত, যেখানে সব প্রাথমিক শর্ত শূন্য ধরা হয় — এটি সিস্টেমের সম্পূর্ণ গাণিতিক আচরণ একটি একক সমীকরণে প্রকাশ করে।$Q1607$,
  $Q1608$🍳 একটি রান্নার রেসিপির মতো — কাঁচামাল (ইনপুট) দিলে রেসিপি (ট্রান্সফার ফাংশন) অনুযায়ী নির্দিষ্ট একটি খাবার (আউটপুট) তৈরি হবে, রেসিপি জানলে যেকোনো কাঁচামালের জন্য ফলাফল আগেই অনুমান করা যায়।$Q1608$,
  $Q1609$কন্ট্রোল সিস্টেম ডিজাইন, স্টেবিলিটি অ্যানালাইসিস, এবং সিস্টেমের ফ্রিকোয়েন্সি রেসপন্স পূর্বাভাসে ব্যবহৃত হয়।$Q1609$,
  $Q1610$একটি DC মোটরের স্পিড কন্ট্রোল সিস্টেমের ট্রান্সফার ফাংশন G(s) = K/(Ts+1) আকারে লেখা যায়, যা ইনপুট ভোল্টেজ থেকে আউটপুট স্পিডের সম্পর্ক বর্ণনা করে।$Q1610$,
  $Q1611$G(s) = Y(s)/X(s), যেখানে Y(s) = আউটপুটের Laplace Transform, X(s) = ইনপুটের Laplace Transform। ডিনোমিনেটরের মূল (roots) সিস্টেমের Pole, নিউমারেটরের মূল Zero নির্দেশ করে, যা সিস্টেমের স্থিতিশীলতা ও আচরণ নির্ধারণ করে।$Q1611$,
  $Q1612$রোবোটিক্স মোশন কন্ট্রোল, বিমানের অটোপাইলট সিস্টেম, এবং শিল্প প্রসেস কন্ট্রোল (তাপমাত্রা, চাপ) ডিজাইনে ব্যবহৃত হয়।$Q1612$,
  ARRAY[$Q1613$Laplace Transform$Q1613$,$Q1614$LTI System$Q1614$,$Q1615$System Model$Q1615$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1616$Block Diagram$Q1616$,
  $Q1617$B$Q1617$,
  $Q1618$control$Q1618$,
  $Q1619$Nise, Ch.5$Q1619$,
  $Q1620$high$Q1620$,
  $Q1621$blockdiagram$Q1621$,
  $Q1622$সিস্টেমের উপাদান ও সিগন্যাল প্রবাহের গ্রাফিক্যাল উপস্থাপনা$Q1622$,
  $Q1623$Block Diagram হলো একটি কন্ট্রোল সিস্টেমের গ্রাফিক্যাল প্রতিনিধিত্ব, যেখানে প্রতিটি উপাদানকে একটি ব্লক (তার ট্রান্সফার ফাংশনসহ) দিয়ে দেখানো হয় এবং তীরচিহ্ন দিয়ে সিগন্যালের প্রবাহের দিক নির্দেশ করা হয় — এটি জটিল সিস্টেম বোঝা ও বিশ্লেষণ সহজ করে।$Q1623$,
  $Q1624$🗺️ একটি ফ্লো চার্টের মতো — জটিল প্রক্রিয়াকে (কন্ট্রোল সিস্টেম) ছোট ছোট বোঝার-যোগ্য ধাপে (ব্লকে) ভেঙে, তীর দিয়ে তথ্যের গতিপথ দেখিয়ে পুরো সিস্টেম এক নজরে বোঝা সহজ করে দেয়।$Q1624$,
  $Q1625$কন্ট্রোল সিস্টেম ডকুমেন্টেশন, জটিল মাল্টি-লুপ সিস্টেম সরলীকরণ (Block Diagram Reduction), এবং টিমের মধ্যে ডিজাইন কমিউনিকেশনে ব্যবহৃত হয়।$Q1625$,
  $Q1626$একটি এয়ার কন্ডিশনার থার্মোস্ট্যাট সিস্টেমের ব্লক ডায়াগ্রামে থাকে: Reference (কাঙ্ক্ষিত তাপমাত্রা) → Comparator → Controller → Compressor → Room → Sensor (ফিডব্যাক লুপ)।$Q1626$,
  $Q1627$Series (ক্যাসকেড) ব্লকের মোট ট্রান্সফার ফাংশন = গুণফল (G₁×G₂); Parallel ব্লকের যোগফল (G₁+G₂); Feedback loop-এর জন্য: G_total = G/(1±GH), যেখানে H = ফিডব্যাক পাথ।$Q1627$,
  $Q1628$শিল্প অটোমেশন সিস্টেম ডকুমেন্টেশন, একাডেমিক কন্ট্রোল সিস্টেম ডিজাইন, এবং MATLAB/Simulink-এ সিস্টেম মডেলিং-এ ব্যবহৃত হয়।$Q1628$,
  ARRAY[$Q1629$System Representation$Q1629$,$Q1630$Signal Flow$Q1630$,$Q1631$Diagram Reduction$Q1631$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1632$Feedback Control System$Q1632$,
  $Q1633$F$Q1633$,
  $Q1634$control$Q1634$,
  $Q1635$Nise, Ch.1$Q1635$,
  $Q1636$critical$Q1636$,
  $Q1637$feedbackloop$Q1637$,
  $Q1638$আউটপুট পর্যবেক্ষণ করে নিজেকে সংশোধনকারী সিস্টেম$Q1638$,
  $Q1639$Feedback Control System একটি সিস্টেম, যা তার আউটপুট ক্রমাগত পরিমাপ করে, কাঙ্ক্ষিত মানের (Reference/Setpoint) সাথে তুলনা করে, এবং ত্রুটি (Error) কমাতে ইনপুটকে স্বয়ংক্রিয়ভাবে সমন্বয় করে — এটি Open-Loop সিস্টেমের বিপরীত, যেখানে কোনো আউটপুট পর্যবেক্ষণ থাকে না।$Q1639$,
  $Q1640$🚗 ক্রুজ কন্ট্রোলের মতো — গাড়ির গতি (আউটপুট) ক্রমাগত পরিমাপ করে, কাঙ্ক্ষিত গতির (সেটপয়েন্ট) সাথে তুলনা করে, পাহাড় উঠলে বা নামলেও ইঞ্জিন নিজে থেকে স্বয়ংক্রিয়ভাবে থ্রটল সমন্বয় করে গতি স্থির রাখে।$Q1640$,
  $Q1641$শিল্প প্রসেস কন্ট্রোল (তাপমাত্রা, চাপ, লেভেল), রোবোটিক্স, এবং যেকোনো স্বয়ংক্রিয় নিয়ন্ত্রণ ব্যবস্থায় ব্যাপকভাবে ব্যবহৃত হয়।$Q1641$,
  $Q1642$একটি এয়ার কন্ডিশনার ঘরের তাপমাত্রা ক্রমাগত সেন্সর দিয়ে মাপে এবং সেট তাপমাত্রার সাথে তুলনা করে কম্প্রেসর অন/অফ করে — এটি একটি ক্লাসিক ফিডব্যাক কন্ট্রোল সিস্টেম।$Q1642$,
  $Q1643$Error e(t) = r(t) − y(t) (r = রেফারেন্স, y = আউটপুট)। কন্ট্রোলার এই এরর সিগন্যাল ব্যবহার করে প্ল্যান্টের ইনপুট নির্ধারণ করে, লক্ষ্য থাকে e(t)→0 করা।$Q1643$,
  $Q1644$এয়ার কন্ডিশনার ও রেফ্রিজারেটর থার্মোস্ট্যাট, ক্রুজ কন্ট্রোল, শিল্প কারখানার প্রসেস কন্ট্রোল লুপ, এবং রোবোটিক্সে ব্যবহৃত হয়।$Q1644$,
  ARRAY[$Q1645$Closed-Loop$Q1645$,$Q1646$Error Correction$Q1646$,$Q1647$Automatic Control$Q1647$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1648$Open-Loop vs Closed-Loop System$Q1648$,
  $Q1649$O$Q1649$,
  $Q1650$control$Q1650$,
  $Q1651$Nise, Ch.1$Q1651$,
  $Q1652$high$Q1652$,
  $Q1653$loop$Q1653$,
  $Q1654$ফিডব্যাক ছাড়া বনাম ফিডব্যাকসহ কন্ট্রোল সিস্টেম$Q1654$,
  $Q1655$Open-Loop System-এ আউটপুট ইনপুটকে প্রভাবিত করে না (কোনো ফিডব্যাক নেই), তাই সিস্টেম বাহ্যিক ব্যাঘাত (disturbance) সংশোধন করতে পারে না। Closed-Loop System-এ আউটপুট পরিমাপ করে ইনপুটে ফিরিয়ে দেওয়া হয়, যা স্বয়ংক্রিয় সংশোধন সম্ভব করে।$Q1655$,
  $Q1656$🍞 টোস্টারের মতো — একটি সাধারণ টোস্টার (Open-Loop) শুধু একটি নির্দিষ্ট সময় ধরে গরম করে, রুটি পোড়া বা কাঁচা যাই হোক না কেন যাচাই করে না; কিন্তু একটি স্মার্ট টোস্টার যদি রঙ সেন্সর দিয়ে রুটির রং দেখে বন্ধ করে (Closed-Loop), তাহলে প্রতিবার নিখুঁত টোস্ট হবে।$Q1656$,
  $Q1657$সাধারণ, সস্তা ও পূর্বাভাসযোগ্য অ্যাপ্লিকেশনে Open-Loop (যেমন ওয়াশিং মেশিন টাইমার) এবং নির্ভুলতা প্রয়োজন এমন অ্যাপ্লিকেশনে Closed-Loop (যেমন রোবোটিক্স) ব্যবহৃত হয়।$Q1657$,
  $Q1658$একটি সাধারণ মাইক্রোওয়েভ ওভেন টাইমার Open-Loop (নির্দিষ্ট সময় পর বন্ধ হয়, খাবার গরম হলো কিনা যাচাই করে না), কিন্তু একটি ইলেকট্রিক ওভেনের থার্মোস্ট্যাট Closed-Loop (তাপমাত্রা সেন্সর দিয়ে ক্রমাগত পরীক্ষা করে)।$Q1658$,
  $Q1659$Open-Loop: Output = G(s)×Input (কোনো ফিডব্যাক নেই, ব্যাঘাত সরাসরি আউটপুটে প্রভাব ফেলে)। Closed-Loop: Output = [G(s)/(1+G(s)H(s))]×Input, যেখানে H(s) ফিডব্যাক পাথ, যা ব্যাঘাত ও প্যারামিটার পরিবর্তনের প্রভাব উল্লেখযোগ্যভাবে কমায়।$Q1659$,
  $Q1660$ওয়াশিং মেশিন ও ডিশওয়াশার টাইমার (Open-Loop), রোবোটিক্স, ড্রোন স্ট্যাবিলাইজেশন, এবং শিল্প প্রসেস কন্ট্রোল (Closed-Loop) ব্যবহৃত হয়।$Q1660$,
  ARRAY[$Q1661$System Classification$Q1661$,$Q1662$Feedback$Q1662$,$Q1663$Control Design$Q1663$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1664$Stability$Q1664$,
  $Q1665$S$Q1665$,
  $Q1666$control$Q1666$,
  $Q1667$Nise, Ch.6$Q1667$,
  $Q1668$critical$Q1668$,
  $Q1669$gauge$Q1669$,
  $Q1670$সসীম ইনপুটে সসীম আউটপুট প্রদানের সিস্টেম বৈশিষ্ট্য$Q1670$,
  $Q1671$Stability হলো একটি কন্ট্রোল সিস্টেমের সেই বৈশিষ্ট্য, যেখানে একটি সসীম (bounded) ইনপুটে সিস্টেমের আউটপুট সময়ের সাথে সসীম থাকে (BIBO Stability) — একটি স্থিতিশীল সিস্টেম বিরক্তির (disturbance) পর একটি স্টেডি-স্টেট অবস্থায় ফিরে আসে, অস্থির সিস্টেমের আউটপুট অসীমভাবে বেড়ে যায়।$Q1671$,
  $Q1672$🎳 একটি বলকে বাটির মধ্যে বনাম উল্টানো বাটির ওপর রাখার মতো — বাটির ভেতরে বল (স্থিতিশীল সিস্টেম) সামান্য নাড়া খেলেও ফিরে এসে মাঝখানে থামে, কিন্তু উল্টানো বাটির চূড়ায় বল (অস্থির সিস্টেম) সামান্য নাড়া খেলেই গড়িয়ে অনেক দূরে চলে যায়।$Q1672$,
  $Q1673$যেকোনো কন্ট্রোল সিস্টেম ডিজাইনের প্রথম ও অত্যাবশ্যক শর্ত যাচাই — অস্থির সিস্টেম বাস্তবে বিপজ্জনক বা অকার্যকর হতে পারে।$Q1673$,
  $Q1674$একটি বিমানের অটোপাইলট সিস্টেম যদি অস্থির হয়, তাহলে সামান্য বাতাসের ঝাপটায় (disturbance) বিমান ক্রমশ বেশি করে দুলতে থাকবে এবং নিয়ন্ত্রণ হারাবে — তাই স্থিতিশীলতা নিশ্চিত করা জীবন-মৃত্যুর বিষয়।$Q1674$,
  $Q1675$একটি সিস্টেম স্থিতিশীল হয় যদি এর ট্রান্সফার ফাংশনের সব Pole s-প্লেনের বামপাশে (Left Half Plane, ঋণাত্মক real part) অবস্থিত হয়। ডানপাশে (Right Half Plane) কোনো Pole থাকলে সিস্টেম অস্থির।$Q1675$,
  $Q1676$বিমান ও ড্রোন অটোপাইলট ডিজাইন, নিউক্লিয়ার পাওয়ার প্ল্যান্ট কন্ট্রোল, এবং শিল্প প্রসেস কন্ট্রোল সিস্টেম যাচাইয়ে ব্যবহৃত হয়।$Q1676$,
  ARRAY[$Q1677$BIBO Stability$Q1677$,$Q1678$Pole Location$Q1678$,$Q1679$System Analysis$Q1679$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1680$Routh-Hurwitz Criterion$Q1680$,
  $Q1681$R$Q1681$,
  $Q1682$control$Q1682$,
  $Q1683$Nise, Ch.6$Q1683$,
  $Q1684$high$Q1684$,
  $Q1685$formula$Q1685$,
  $Q1686$মূল না বের করে স্থিতিশীলতা যাচাইয়ের বীজগাণিতিক পদ্ধতি$Q1686$,
  $Q1687$Routh-Hurwitz Criterion একটি বীজগাণিতিক পদ্ধতি, যা একটি সিস্টেমের ক্যারেক্টারিস্টিক সমীকরণের মূল (roots) সরাসরি না বের করেই, একটি টেবিল (Routh Array) তৈরি করে সিস্টেমের ডানপাশের-হাফ-প্লেনে (Right Half Plane) কতগুলো Pole আছে তা নির্ণয় করে স্থিতিশীলতা যাচাই করে।$Q1687$,
  $Q1688$🩻 এক্স-রে দিয়ে হাড় না ভেঙেই ভাঙা আছে কিনা জানার মতো — জটিল উচ্চ-ক্রম সমীকরণের প্রতিটি মূল আসলে বের না করেই, একটি সরল টেবিল বিশ্লেষণ করে বলে দেওয়া যায় সিস্টেম স্থিতিশীল কিনা।$Q1688$,
  $Q1689$উচ্চ-ক্রম (৩য়, ৪র্থ বা তার বেশি) কন্ট্রোল সিস্টেমের দ্রুত স্থিতিশীলতা যাচাই এবং একটি প্যারামিটারের (যেমন গেইন K) নিরাপদ পরিসীমা নির্ধারণে ব্যবহৃত হয়।$Q1689$,
  $Q1690$একটি কন্ট্রোলারের গেইন K কোন পরিসরে সিস্টেম স্থিতিশীল থাকবে তা নির্ধারণ করতে Routh Array-তে K-কে একটি ভেরিয়েবল হিসেবে রেখে প্রথম কলামের সাইন পরিবর্তন পরীক্ষা করা হয়।$Q1690$,
  $Q1691$Characteristic equation-এর সহগ দিয়ে Routh Array তৈরি করা হয়। প্রথম কলামে কোনো সাইন পরিবর্তন না থাকলে সিস্টেম স্থিতিশীল; প্রতিটি সাইন পরিবর্তন একটি Right-Half-Plane Pole নির্দেশ করে (অস্থিরতা)।$Q1691$,
  $Q1692$নিয়ন্ত্রক (controller) গেইন টিউনিং, শিল্প প্রসেস কন্ট্রোলার ডিজাইন যাচাই, এবং একাডেমিক কন্ট্রোল সিস্টেম কোর্সওয়ার্কে ব্যাপকভাবে ব্যবহৃত হয়।$Q1692$,
  ARRAY[$Q1693$Stability Analysis$Q1693$,$Q1694$Routh Array$Q1694$,$Q1695$Characteristic Equation$Q1695$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1696$Root Locus$Q1696$,
  $Q1697$R$Q1697$,
  $Q1698$control$Q1698$,
  $Q1699$Nise, Ch.8$Q1699$,
  $Q1700$high$Q1700$,
  $Q1701$gauge$Q1701$,
  $Q1702$গেইন পরিবর্তনে Pole-এর গতিপথের লেখচিত্র$Q1702$,
  $Q1703$Root Locus হলো একটি গ্রাফিক্যাল পদ্ধতি, যা একটি কন্ট্রোল সিস্টেমের লুপ গেইন (K) শূন্য থেকে অসীম পর্যন্ত পরিবর্তিত হলে ক্লোজড-লুপ ট্রান্সফার ফাংশনের Pole-গুলো s-প্লেনে কীভাবে সরে যায় (locus/পথ) তা দেখায়, যা স্থিতিশীলতা ও ট্রানজিয়েন্ট রেসপন্স ডিজাইনে সহায়ক।$Q1703$,
  $Q1704$🎢 একটি রোলার কোস্টারের ট্র্যাকের মতো — গেইন (K) বাড়ালে সিস্টেমের 'গাড়ি' (Pole) একটি পূর্বনির্ধারিত ট্র্যাক (locus) ধরে সরে যায় — ডিজাইনার আগে থেকেই জানতে পারেন কোন গেইনে গাড়ি কোথায় থাকবে।$Q1704$,
  $Q1705$কাঙ্ক্ষিত ট্রানজিয়েন্ট রেসপন্স (damping ratio, settling time) পেতে সঠিক কন্ট্রোলার গেইন নির্বাচনে গ্রাফিক্যালি ব্যবহৃত হয়।$Q1705$,
  $Q1706$একটি Root Locus প্লট দেখে ডিজাইনার নির্ধারণ করতে পারেন যে গেইন K=5-এর বেশি হলে সিস্টেমের কিছু Pole s-প্লেনের ডানপাশে চলে যাবে, অর্থাৎ সিস্টেম অস্থির হয়ে যাবে।$Q1706$,
  $Q1707$Root Locus সমীকরণ: 1 + K×G(s)H(s) = 0। Locus সবসময় Open-Loop Pole থেকে শুরু হয়ে Open-Loop Zero-তে (বা অসীমে) শেষ হয়, এবং বাস্তব অক্ষের প্রতিসম হয়।$Q1707$,
  $Q1708$PID কন্ট্রোলার গেইন টিউনিং, রোবোটিক আর্ম কন্ট্রোলার ডিজাইন, এবং এরোস্পেস কন্ট্রোল সিস্টেম ডিজাইনে ব্যবহৃত হয়।$Q1708$,
  ARRAY[$Q1709$Gain Analysis$Q1709$,$Q1710$Pole Migration$Q1710$,$Q1711$Graphical Design$Q1711$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1712$Bode Plot$Q1712$,
  $Q1713$B$Q1713$,
  $Q1714$control$Q1714$,
  $Q1715$Nise, Ch.10$Q1715$,
  $Q1716$high$Q1716$,
  $Q1717$bode$Q1717$,
  $Q1718$ফ্রিকোয়েন্সির সাথে গেইন ও ফেজের লগারিদমিক লেখচিত্র$Q1718$,
  $Q1719$Bode Plot একটি সিস্টেমের ফ্রিকোয়েন্সি রেসপন্স দেখানোর গ্রাফিক্যাল পদ্ধতি, যা দুটি পৃথক গ্রাফ দিয়ে গঠিত — একটি Magnitude Plot (dB vs log frequency) এবং একটি Phase Plot (degrees vs log frequency) — যা সিস্টেমের স্থিতিশীলতা ও কর্মক্ষমতা বিশ্লেষণে ব্যবহৃত হয়।$Q1719$,
  $Q1720$🎧 একটি অডিও ইকুয়ালাইজার ডিসপ্লের মতো — বিভিন্ন ফ্রিকোয়েন্সিতে (বেস, মিড, ট্রেবল) সিস্টেম কতটা 'জোরে' (গেইন) ও কতটা 'দেরিতে' (ফেজ) সাড়া দিচ্ছে তা এক নজরে দেখায়।$Q1720$,
  $Q1721$কন্ট্রোল সিস্টেমের Gain Margin ও Phase Margin নির্ধারণ, এবং ফিল্টার ও অ্যামপ্লিফায়ারের ফ্রিকোয়েন্সি রেসপন্স ডিজাইনে ব্যবহৃত হয়।$Q1721$,
  $Q1722$একটি অ্যামপ্লিফায়ারের Bode Plot দেখে ইঞ্জিনিয়ার নির্ধারণ করতে পারেন যে −3dB cutoff frequency কোথায়, অর্থাৎ কোন ফ্রিকোয়েন্সির পর সিস্টেমের গেইন কার্যকরভাবে কমতে শুরু করে।$Q1722$,
  $Q1723$Gain(dB) = 20log₁₀|G(jω)|, Phase = ∠G(jω)। এই লগারিদমিক স্কেল ব্যবহার করার সুবিধা হলো, একাধিক ব্লক ক্যাসকেড করলে তাদের Bode Plot শুধু যোগ করলেই মোট রেসপন্স পাওয়া যায় (গুণনের বদলে যোগ)।$Q1723$,
  $Q1724$অডিও ইকুয়ালাইজার ও ফিল্টার ডিজাইন, ফিডব্যাক কন্ট্রোলার স্থিতিশীলতা মার্জিন যাচাই, এবং RF অ্যামপ্লিফায়ার ডিজাইনে ব্যবহৃত হয়।$Q1724$,
  ARRAY[$Q1725$Frequency Response$Q1725$,$Q1726$Gain-Phase Plot$Q1726$,$Q1727$Stability Margin$Q1727$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1728$PID Controller$Q1728$,
  $Q1729$P$Q1729$,
  $Q1730$control$Q1730$,
  $Q1731$Nise, Ch.9$Q1731$,
  $Q1732$critical$Q1732$,
  $Q1733$controller$Q1733$,
  $Q1734$শিল্পে সবচেয়ে ব্যবহৃত ত্রি-মুখী কন্ট্রোলার$Q1734$,
  $Q1735$PID Controller একটি ফিডব্যাক কন্ট্রোলার যা তিনটি উপাদানের সমন্বয়ে এরর সিগন্যাল প্রক্রিয়া করে — Proportional (বর্তমান এররের সমানুপাতিক), Integral (অতীত এররের সমষ্টি, স্টেডি-স্টেট এরর দূর করে), এবং Derivative (এররের পরিবর্তনের হার, ভবিষ্যৎ প্রবণতা অনুমান করে) — শিল্প নিয়ন্ত্রণে সবচেয়ে বেশি ব্যবহৃত কন্ট্রোলার।$Q1735$,
  $Q1736$🚗 একজন অভিজ্ঞ ড্রাইভারের মতো — P হলো বর্তমান লেন থেকে বিচ্যুতি দেখে স্টিয়ারিং ঘোরানো, I হলো দীর্ঘদিন ধরে একটু বাঁকা চলার প্রবণতা সংশোধন করা, আর D হলো সামনে বাঁক আসছে বুঝে আগে থেকেই স্টিয়ারিং প্রস্তুত করা।$Q1736$,
  $Q1737$তাপমাত্রা কন্ট্রোল (ওভেন, এসি), মোটর স্পিড কন্ট্রোল, ড্রোন স্ট্যাবিলাইজেশন, এবং প্রায় সব শিল্প প্রসেস কন্ট্রোল সিস্টেমে ব্যবহৃত হয়।$Q1737$,
  $Q1738$একটি 3D প্রিন্টারের হটএন্ড তাপমাত্রা নিয়ন্ত্রণে PID কন্ট্রোলার ব্যবহার করা হয়, যা দ্রুত কাঙ্ক্ষিত তাপমাত্রায় পৌঁছায় এবং ওভারশুট বা দোলন (oscillation) ছাড়াই স্থির রাখে।$Q1738$,
  $Q1739$u(t) = K_p×e(t) + K_i∫e(t)dt + K_d×(de(t)/dt)। K_p বাড়ালে রেসপন্স দ্রুত হয় কিন্তু ওভারশুট বাড়তে পারে; K_i স্টেডি-স্টেট এরর দূর করে কিন্তু বেশি হলে দোলন বাড়ায়; K_d দোলন কমিয়ে স্থিতিশীলতা বাড়ায়।$Q1739$,
  $Q1740$ইন্ডাস্ট্রিয়াল অটোমেশন (তাপমাত্রা, চাপ, ফ্লো কন্ট্রোল), ড্রোন ও রোবোটিক্স স্ট্যাবিলাইজেশন, 3D প্রিন্টার ও CNC মেশিন, এবং গাড়ির ক্রুজ কন্ট্রোলে ব্যবহৃত হয়।$Q1740$,
  ARRAY[$Q1741$Proportional-Integral-Derivative$Q1741$,$Q1742$Feedback Controller$Q1742$,$Q1743$Industrial Control$Q1743$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1744$Steady-State Error$Q1744$,
  $Q1745$S$Q1745$,
  $Q1746$control$Q1746$,
  $Q1747$Nise, Ch.7$Q1747$,
  $Q1748$high$Q1748$,
  $Q1749$gauge$Q1749$,
  $Q1750$সিস্টেম স্থির হওয়ার পরও থেকে যাওয়া চিরস্থায়ী ত্রুটি$Q1750$,
  $Q1751$Steady-State Error (e_ss) হলো একটি কন্ট্রোল সিস্টেমের আউটপুট, দীর্ঘ সময় পরে (t→∞) কাঙ্ক্ষিত রেফারেন্স মান থেকে যে স্থায়ী পার্থক্য রেখে যায়, তা — এটি সিস্টেমের নির্ভুলতার একটি গুরুত্বপূর্ণ মানদণ্ড।$Q1751$,
  $Q1752$🎯 তীর ছোড়ার মতো — বহুবার অনুশীলনের (সিস্টেম স্থির হওয়ার) পরও যদি তীর সবসময় লক্ষ্যের একটু ডানে গিয়ে পড়ে (স্থায়ী পার্থক্য), সেই ধারাবাহিক বিচ্যুতিই Steady-State Error।$Q1752$,
  $Q1753$কন্ট্রোল সিস্টেম ডিজাইনে নির্ভুলতা যাচাই, এবং সিস্টেম টাইপ (Type 0/1/2) অনুযায়ী কোন ইনপুটে (স্টেপ, র‍্যাম্প) কতটা এরর থাকবে তা পূর্বাভাসে ব্যবহৃত হয়।$Q1753$,
  $Q1754$একটি সাধারণ প্রপোরশনাল-অনলি কন্ট্রোলার দিয়ে চালিত থার্মোস্ট্যাট সিস্টেমে সবসময় কাঙ্ক্ষিত তাপমাত্রা থেকে সামান্য কম (যেমন 0.5°C) স্টেডি-স্টেট এরর থেকে যেতে পারে, যা শুধুমাত্র Integral কন্ট্রোল যোগ করলে দূর হয়।$Q1754$,
  $Q1755$e_ss = lim(s→0) sE(s) = lim(s→0) s×R(s)/(1+G(s)H(s)) (Final Value Theorem ব্যবহার করে)। System Type (Open-Loop Transfer Function-এ s=0-এ Pole সংখ্যা) নির্ধারণ করে স্টেপ, র‍্যাম্প বা প্যারাবোলিক ইনপুটে e_ss শূন্য হবে নাকি সসীম থাকবে।$Q1755$,
  $Q1756$থার্মোস্ট্যাট ও তাপমাত্রা কন্ট্রোল সিস্টেম নির্ভুলতা যাচাই, পজিশন কন্ট্রোল সিস্টেম (CNC, রোবোটিক্স) ডিজাইন, এবং শিল্প প্রসেস কন্ট্রোলার টিউনিং-এ ব্যবহৃত হয়।$Q1756$,
  ARRAY[$Q1757$Accuracy$Q1757$,$Q1758$System Type$Q1758$,$Q1759$Final Value Theorem$Q1759$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1760$Pole & Zero$Q1760$,
  $Q1761$P$Q1761$,
  $Q1762$control$Q1762$,
  $Q1763$Nise, Ch.4$Q1763$,
  $Q1764$high$Q1764$,
  $Q1765$gauge$Q1765$,
  $Q1766$ট্রান্সফার ফাংশনের বৈশিষ্ট্য নির্ধারণকারী বিশেষ বিন্দু$Q1766$,
  $Q1767$Pole হলো ট্রান্সফার ফাংশনের সেই মান যেখানে ডিনোমিনেটর শূন্য হয় (ফাংশন অসীম হয়ে যায়), আর Zero হলো যেখানে নিউমারেটর শূন্য হয় (ফাংশন শূন্য হয়ে যায়) — এই s-প্লেনের বিন্দুগুলো সিস্টেমের স্থিতিশীলতা, ট্রানজিয়েন্ট রেসপন্স ও সামগ্রিক আচরণ সম্পূর্ণভাবে নির্ধারণ করে।$Q1767$,
  $Q1768$🏔️ একটি ভূখণ্ডের পাহাড় ও গহ্বরের মতো — Pole হলো অসীম উচ্চতার পাহাড় (যেখানে ফাংশন বিস্ফোরিত হয়), Zero হলো গভীর গহ্বর (যেখানে ফাংশন শূন্যে নেমে যায়) — এই ভূখণ্ডের আকৃতিই বলে দেয় সিস্টেম কেমন আচরণ করবে।$Q1768$,
  $Q1769$সিস্টেম স্থিতিশীলতা যাচাই (Pole-এর অবস্থান দেখে), এবং ট্রানজিয়েন্ট রেসপন্সের বৈশিষ্ট্য (rise time, overshoot) পূর্বাভাসে ব্যবহৃত হয়।$Q1769$,
  $Q1770$G(s) = (s+2)/[(s+1)(s+3)] সিস্টেমে Zero আছে s=−2 তে, এবং Pole আছে s=−1 ও s=−3 তে — উভয় Pole বামপাশে (negative) থাকায় সিস্টেম স্থিতিশীল।$Q1770$,
  $Q1771$Pole-এর অবস্থান (s-প্লেনে) সিস্টেমের প্রাকৃতিক রেসপন্স নির্ধারণ করে — বাম-পাশের Pole ক্ষয়িষ্ণু (decaying) রেসপন্স দেয়, ডান-পাশের Pole বর্ধমান (growing/unstable) রেসপন্স দেয়। জটিল-সংযুক্ত (complex conjugate) Pole দোলনশীল (oscillatory) রেসপন্স তৈরি করে।$Q1771$,
  $Q1772$কন্ট্রোল সিস্টেম ডিজাইন ও স্থিতিশীলতা যাচাই, ফিল্টার ডিজাইন, এবং MATLAB-এর মতো সফটওয়্যারে সিস্টেম বিশ্লেষণে মৌলিক হাতিয়ার হিসেবে ব্যবহৃত হয়।$Q1772$,
  ARRAY[$Q1773$s-Plane$Q1773$,$Q1774$Transfer Function$Q1774$,$Q1775$System Behavior$Q1775$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1776$State-Space Representation$Q1776$,
  $Q1777$S$Q1777$,
  $Q1778$control$Q1778$,
  $Q1779$Nise, Ch.3$Q1779$,
  $Q1780$medium$Q1780$,
  $Q1781$blockdiagram$Q1781$,
  $Q1782$প্রথম-ক্রম ম্যাট্রিক্স সমীকরণে সিস্টেম মডেলিং$Q1782$,
  $Q1783$State-Space Representation হলো একটি সিস্টেম মডেলিং পদ্ধতি, যেখানে একটি n-ক্রম ডিফারেনশিয়াল সমীকরণকে n-সংখ্যক প্রথম-ক্রম ডিফারেনশিয়াল সমীকরণে (ম্যাট্রিক্স আকারে) রূপান্তর করা হয় — এটি মাল্টি-ইনপুট মাল্টি-আউটপুট (MIMO) সিস্টেম এবং আধুনিক কন্ট্রোল ডিজাইনে (যেমন Optimal Control) ব্যাপকভাবে ব্যবহৃত হয়।$Q1783$,
  $Q1784$📊 একটি বিমানের ককপিট ড্যাশবোর্ডের মতো — একটি একক জটিল বর্ণনার বদলে (ট্রান্সফার ফাংশন), সিস্টেমের প্রতিটি অভ্যন্তরীণ 'অবস্থা' (state, যেমন গতি, উচ্চতা, দিক) আলাদা আলাদা গেজে দেখানো হয়, যা সিস্টেমের সম্পূর্ণ অভ্যন্তরীণ চিত্র দেয়।$Q1784$,
  $Q1785$MIMO (Multiple-Input Multiple-Output) সিস্টেম ডিজাইন, রোবোটিক্স ও এরোস্পেস কন্ট্রোল, এবং Optimal ও Adaptive Control অ্যালগরিদমে ব্যবহৃত হয়।$Q1785$,
  $Q1786$একটি ড্রোনের স্ট্যাবিলাইজেশন সিস্টেম State-Space মডেল ব্যবহার করে, যেখানে state ভেক্টরে অবস্থান, গতিবেগ, ও কৌণিক গতি (angular velocity)-এর মতো একাধিক ভেরিয়েবল একসাথে থাকে।$Q1786$,
  $Q1787$ẋ = Ax + Bu (State Equation), y = Cx + Du (Output Equation) — যেখানে x = state vector, u = input, y = output, এবং A, B, C, D ম্যাট্রিক্স সিস্টেমের গতিবিদ্যা সম্পূর্ণভাবে বর্ণনা করে।$Q1787$,
  $Q1788$স্যাটেলাইট ও ড্রোন Attitude Control, স্বয়ংক্রিয় গাড়ি (Autonomous Vehicle) কন্ট্রোল, এবং আধুনিক রোবোটিক্স Optimal Controller (LQR) ডিজাইনে ব্যবহৃত হয়।$Q1788$,
  ARRAY[$Q1789$MIMO System$Q1789$,$Q1790$Matrix Model$Q1790$,$Q1791$Modern Control$Q1791$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1792$Gain Margin & Phase Margin$Q1792$,
  $Q1793$G$Q1793$,
  $Q1794$control$Q1794$,
  $Q1795$Nise, Ch.10$Q1795$,
  $Q1796$medium$Q1796$,
  $Q1797$gauge$Q1797$,
  $Q1798$স্থিতিশীলতার নিরাপত্তা মার্জিন পরিমাপ$Q1798$,
  $Q1799$Gain Margin হলো সিস্টেম অস্থির হওয়ার আগে গেইন কতটা বাড়ানো যায় তার পরিমাপ (dB-তে), আর Phase Margin হলো সিস্টেম অস্থির হওয়ার আগে ফেজ ল্যাগ কতটা বাড়ানো যায় তার পরিমাপ (ডিগ্রিতে) — উভয়ই Bode Plot বা Nyquist Plot থেকে নির্ণয় করা হয় এবং সিস্টেমের 'নিরাপত্তা বাফার' নির্দেশ করে।$Q1799$,
  $Q1800$🚗 গাড়ির ব্রেকিং দূরত্বের মার্জিনের মতো — সামনের গাড়ি থেকে যত বেশি নিরাপদ দূরত্ব রাখবে (বড় মার্জিন), হঠাৎ ব্রেক করলেও দুর্ঘটনার (অস্থিরতার) ঝুঁকি তত কম থাকবে।$Q1800$,
  $Q1801$কন্ট্রোলার ডিজাইনে পর্যাপ্ত রোবাস্টনেস (মজবুততা) নিশ্চিত করা, যাতে সিস্টেম প্যারামিটার পরিবর্তন বা মডেলিং ত্রুটি সত্ত্বেও স্থিতিশীল থাকে।$Q1801$,
  $Q1802$একটি ভালো ডিজাইন করা কন্ট্রোল সিস্টেমে সাধারণত Gain Margin কমপক্ষে 6dB এবং Phase Margin কমপক্ষে 30-60° রাখার লক্ষ্য রাখা হয়, যাতে বাস্তব-জগতের অনিশ্চয়তা সহ্য করতে পারে।$Q1802$,
  $Q1803$Gain Margin পরিমাপ করা হয় সেই ফ্রিকোয়েন্সিতে (Phase Crossover Frequency) যেখানে ফেজ = −180°। Phase Margin পরিমাপ করা হয় সেই ফ্রিকোয়েন্সিতে (Gain Crossover Frequency) যেখানে Magnitude = 0dB। উভয়ই ধনাত্মক হলে সিস্টেম স্থিতিশীল।$Q1803$,
  $Q1804$শিল্প কন্ট্রোলার রোবাস্টনেস যাচাই, ফ্লাইট কন্ট্রোল সিস্টেম সার্টিফিকেশন, এবং পাওয়ার ইলেকট্রনিক্স কনভার্টার কন্ট্রোলার ডিজাইনে ব্যবহৃত হয়।$Q1804$,
  ARRAY[$Q1805$Robustness$Q1805$,$Q1806$Frequency Domain$Q1806$,$Q1807$Stability Margin$Q1807$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1808$Nyquist Stability Criterion$Q1808$,
  $Q1809$N$Q1809$,
  $Q1810$control$Q1810$,
  $Q1811$Nise, Ch.10$Q1811$,
  $Q1812$medium$Q1812$,
  $Q1813$orbit$Q1813$,
  $Q1814$ওপেন-লুপ প্লট থেকে ক্লোজড-লুপ স্থিতিশীলতা যাচাই$Q1814$,
  $Q1815$Nyquist Stability Criterion একটি গ্রাফিক্যাল পদ্ধতি, যা Open-Loop ফ্রিকোয়েন্সি রেসপন্সের একটি পোলার প্লট (Nyquist Plot) পরীক্ষা করে ক্লোজড-লুপ সিস্টেমের স্থিতিশীলতা নির্ধারণ করে — এটি বিশেষভাবে কার্যকর যখন সিস্টেমে Time Delay থাকে, যেখানে Routh-Hurwitz সরাসরি প্রয়োগযোগ্য নয়।$Q1815$,
  $Q1816$🧭 একটি বিন্দুর চারপাশে পথ কতবার প্রদক্ষিণ করে তা গোনার মতো — যদি প্লট করা পথ একটি বিশেষ বিপজ্জনক বিন্দুকে (−1, 0) সঠিক সংখ্যকবার প্রদক্ষিণ না করে, তাহলে বোঝা যায় সিস্টেম অস্থির হয়ে যাবে।$Q1816$,
  $Q1817$টাইম-ডিলে সম্বলিত সিস্টেম (যেমন নেটওয়ার্ক কন্ট্রোল সিস্টেম) এবং জটিল ট্রান্সফার ফাংশনের স্থিতিশীলতা যাচাইয়ে ব্যবহৃত হয়।$Q1817$,
  $Q1818$একটি রিমোট-কন্ট্রোলড রোবট, যেখানে নেটওয়ার্ক ল্যাটেন্সির কারণে সিগন্যাল দেরিতে পৌঁছায় (Time Delay), সেই সিস্টেমের স্থিতিশীলতা Nyquist Criterion দিয়ে সবচেয়ে নির্ভরযোগ্যভাবে যাচাই করা যায়।$Q1818$,
  $Q1819$Nyquist Criterion: Z = N + P, যেখানে Z = ক্লোজড-লুপ সিস্টেমের ডানপাশের Pole সংখ্যা, N = (−1,0) বিন্দুর চারপাশে ঘড়ির কাঁটার দিকে প্রদক্ষিণ সংখ্যা, P = Open-Loop সিস্টেমের ডানপাশের Pole সংখ্যা। স্থিতিশীলতার জন্য Z=0 প্রয়োজন।$Q1819$,
  $Q1820$নেটওয়ার্কড কন্ট্রোল সিস্টেম ডিজাইন (টাইম-ডিলেসহ), রাসায়নিক প্রসেস কন্ট্রোল, এবং একাডেমিক কন্ট্রোল সিস্টেম কোর্সে ব্যবহৃত হয়।$Q1820$,
  ARRAY[$Q1821$Polar Plot$Q1821$,$Q1822$Time Delay System$Q1822$,$Q1823$Stability Analysis$Q1823$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1824$Time Response (Transient Response)$Q1824$,
  $Q1825$T$Q1825$,
  $Q1826$control$Q1826$,
  $Q1827$Nise, Ch.4$Q1827$,
  $Q1828$high$Q1828$,
  $Q1829$waveform$Q1829$,
  $Q1830$স্টেপ ইনপুটে সিস্টেমের সময়ের সাথে আচরণ$Q1830$,
  $Q1831$Time Response হলো একটি সিস্টেমের আউটপুট সময়ের সাথে কীভাবে পরিবর্তিত হয় তার বর্ণনা, যা দুটি অংশে বিভক্ত — Transient Response (প্রাথমিক অস্থায়ী আচরণ, যেমন ওঠানামা) এবং Steady-State Response (দীর্ঘমেয়াদী চূড়ান্ত আচরণ) — এটি সিস্টেমের কর্মক্ষমতার মূল সূচক।$Q1831$,
  $Q1832$🚗 একটি গাড়ি ব্রেক করার প্রক্রিয়ার মতো — ব্রেক চাপার সাথে সাথে গাড়ি হঠাৎ ঝাঁকুনি খেতে খেতে (Transient) থামে, তারপর সম্পূর্ণ স্থির হয়ে থাকে (Steady-State) — পুরো প্রক্রিয়াটাই টাইম রেসপন্স।$Q1832$,
  $Q1833$কন্ট্রোল সিস্টেমের গতি (rise time), স্থিতিশীলতা (settling time), এবং নির্ভুলতা (overshoot) একসাথে মূল্যায়নে ব্যবহৃত হয়, যা ডিজাইনারদের কর্মক্ষমতার সম্পূর্ণ চিত্র দেয়।$Q1833$,
  $Q1834$একটি এলিভেটরের টাইম রেসপন্স পরীক্ষা করে দেখা হয় যে এটি কাঙ্ক্ষিত ফ্লোরে কত দ্রুত পৌঁছায় (rise time), কতটা 'বাউন্স' করে (overshoot), এবং কতক্ষণে সম্পূর্ণ স্থির হয় (settling time)।$Q1834$,
  $Q1835$মূল পারফরমেন্স প্যারামিটার: Rise Time (10% থেকে 90% পৌঁছাতে সময়), Peak Time, %Overshoot, Settling Time (সাধারণত ±2% ব্যান্ডে স্থির হতে সময়), এবং Steady-State Error — সবগুলোই damping ratio (ζ) ও natural frequency (ω_n) দ্বারা নির্ধারিত।$Q1835$,
  $Q1836$এলিভেটর ও রোবোটিক আর্ম রেসপন্স টিউনিং, গাড়ির সাসপেনশন সিস্টেম ডিজাইন, এবং শিল্প প্রসেস কন্ট্রোলার পারফরমেন্স যাচাইয়ে ব্যবহৃত হয়।$Q1836$,
  ARRAY[$Q1837$Performance Metrics$Q1837$,$Q1838$Transient$Q1838$,$Q1839$Rise Time$Q1839$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1840$Damping Ratio$Q1840$,
  $Q1841$D$Q1841$,
  $Q1842$control$Q1842$,
  $Q1843$Nise, Ch.4$Q1843$,
  $Q1844$high$Q1844$,
  $Q1845$waveform$Q1845$,
  $Q1846$দোলন কতটা দ্রুত ক্ষয় হবে তার পরিমাপ$Q1846$,
  $Q1847$Damping Ratio (ζ) হলো একটি দ্বিতীয়-ক্রম সিস্টেমের একটি অমাত্রিক (dimensionless) প্যারামিটার, যা নির্ধারণ করে সিস্টেমের রেসপন্স কতটা দোলনশীল (oscillatory) হবে — ζ<1 হলে Underdamped (দোলনশীল), ζ=1 হলে Critically Damped, ζ>1 হলে Overdamped (কোনো দোলন নেই)।$Q1847$,
  $Q1848$🚗 গাড়ির শক-অ্যাবজর্বারের (shock absorber) মতো — নতুন ভালো শক-অ্যাবজর্বার (উচ্চ damping) গর্তে পড়লে গাড়িকে একবারই ঝাঁকুনি দিয়ে দ্রুত স্থির করে, কিন্তু পুরনো নষ্ট শক-অ্যাবজর্বার (কম damping) গাড়িকে বহুক্ষণ ধরে ওঠানামা (দোলন) করাতে থাকে।$Q1848$,
  $Q1849$সাসপেনশন সিস্টেম ডিজাইন, মোটর কন্ট্রোলার টিউনিং, এবং যেকোনো দ্বিতীয়-ক্রম সিস্টেমের কাঙ্ক্ষিত রেসপন্স আচরণ নির্ধারণে ব্যবহৃত হয়।$Q1849$,
  $Q1850$একটি গাড়ির সাসপেনশন সাধারণত ζ ≈ 0.6-0.8 (Underdamped কিন্তু নিয়ন্ত্রিত) রাখা হয়, যাতে আরাম (সামান্য নমনীয়তা) ও স্থিতিশীলতা (দ্রুত স্থির হওয়া) উভয়ের মধ্যে ভারসাম্য থাকে।$Q1850$,
  $Q1851$Characteristic equation: s² + 2ζω_n s + ω_n² = 0। ζ<1 হলে জটিল-সংযুক্ত (complex conjugate) Pole থাকে, যা দোলনশীল রেসপন্স তৈরি করে; %Overshoot = e^(−ζπ/√(1−ζ²)) × 100%।$Q1851$,
  $Q1852$গাড়ি সাসপেনশন ও শক-অ্যাবজর্বার ডিজাইন, রোবোটিক আর্ম মোশন কন্ট্রোলার, এবং ভবন নির্মাণে ভূমিকম্প-প্রতিরোধী ড্যাম্পিং সিস্টেমে ব্যবহৃত হয়।$Q1852$,
  ARRAY[$Q1853$Second-Order System$Q1853$,$Q1854$Oscillation$Q1854$,$Q1855$Overshoot$Q1855$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1856$Natural Frequency$Q1856$,
  $Q1857$N$Q1857$,
  $Q1858$control$Q1858$,
  $Q1859$Nise, Ch.4$Q1859$,
  $Q1860$medium$Q1860$,
  $Q1861$wavesine$Q1861$,
  $Q1862$কোনো ড্যাম্পিং না থাকলে দোলনের অন্তর্নিহিত কম্পাঙ্ক$Q1862$,
  $Q1863$Natural Frequency (ω_n) হলো একটি সিস্টেমের সেই কম্পাঙ্ক, যে কম্পাঙ্কে এটি দোলিত হতো যদি কোনো ড্যাম্পিং (ঘর্ষণ/শক্তি অপচয়) না থাকতো — এটি সিস্টেমের ভৌত বৈশিষ্ট্য (ভর, স্প্রিং কনস্ট্যান্ট ইত্যাদি) দ্বারা নির্ধারিত হয়।$Q1863$,
  $Q1864$🎵 একটি টিউনিং ফর্কের মতো — প্রতিটি টিউনিং ফর্কের নিজস্ব একটি স্বাভাবিক কম্পাঙ্ক থাকে, যাতে এটি বাতাসের ঘর্ষণ (ড্যাম্পিং) না থাকলে অনন্তকাল ধরে সেই একই সুরে বাজতে থাকতো।$Q1864$,
  $Q1865$মেকানিক্যাল ও ইলেকট্রিক্যাল সিস্টেমের রেজোন্যান্স ফ্রিকোয়েন্সি পূর্বাভাস, এবং কন্ট্রোল সিস্টেম রেসপন্স স্পিড ডিজাইনে ব্যবহৃত হয়।$Q1865$,
  $Q1866$একটি ব্রিজের নিজস্ব Natural Frequency যদি বাতাসের ঝাপটার ফ্রিকোয়েন্সির কাছাকাছি হয়ে যায়, তাহলে রেজোন্যান্স ঘটে বিপজ্জনক দোলন তৈরি হতে পারে (যেমন Tacoma Narrows Bridge বিপর্যয়)।$Q1866$,
  $Q1867$ω_n = √(k/m) (মেকানিক্যাল স্প্রিং-মাস সিস্টেমে, k=স্প্রিং কনস্ট্যান্ট, m=ভর)। Damped Natural Frequency ω_d = ω_n√(1−ζ²), যা প্রকৃত দোলনের কম্পাঙ্ক (ড্যাম্পিং বিবেচনা করে)।$Q1867$,
  $Q1868$ব্রিজ ও ভবনের কম্পন বিশ্লেষণ, গাড়ির সাসপেনশন ডিজাইন, এবং কন্ট্রোল সিস্টেম রেসপন্স স্পিড ক্যালকুলেশনে ব্যবহৃত হয়।$Q1868$,
  ARRAY[$Q1869$Resonance$Q1869$,$Q1870$Undamped Frequency$Q1870$,$Q1871$Mechanical System$Q1871$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1872$Sensor/Transducer (feedback element)$Q1872$,
  $Q1873$S$Q1873$,
  $Q1874$control$Q1874$,
  $Q1875$Nise, Ch.1$Q1875$,
  $Q1876$medium$Q1876$,
  $Q1877$sensor$Q1877$,
  $Q1878$ভৌত রাশিকে বৈদ্যুতিক সিগন্যালে রূপান্তরকারী যন্ত্র$Q1878$,
  $Q1879$Sensor/Transducer হলো একটি যন্ত্র, যা একটি ভৌত রাশি (তাপমাত্রা, চাপ, অবস্থান, গতি ইত্যাদি) পরিমাপ করে তাকে একটি সমানুপাতিক বৈদ্যুতিক সিগন্যালে রূপান্তরিত করে — এটি একটি ফিডব্যাক কন্ট্রোল সিস্টেমের 'চোখ ও কান' হিসেবে কাজ করে, যা প্রকৃত আউটপুট পরিমাপ করে কন্ট্রোলারকে জানায়।$Q1879$,
  $Q1880$👁️ মানুষের ইন্দ্রিয়ের মতো — চোখ (ভিজ্যুয়াল সেন্সর) বাইরের জগতের অবস্থা মস্তিষ্কে (কন্ট্রোলারে) পাঠায়, যা ছাড়া মস্তিষ্ক জানতেই পারবে না শরীর কী অবস্থায় আছে এবং কী সংশোধন প্রয়োজন।$Q1880$,
  $Q1881$প্রতিটি ফিডব্যাক কন্ট্রোল সিস্টেমে ফিডব্যাক পাথে ব্যবহৃত হয়, যেমন থার্মোস্ট্যাটে তাপমাত্রা সেন্সর, বা রোবটে পজিশন এনকোডার।$Q1881$,
  $Q1882$একটি স্মার্ট এসি সিস্টেমে থার্মিস্টর (তাপমাত্রা সেন্সর) ঘরের তাপমাত্রা পরিমাপ করে একটি ভোল্টেজ সিগন্যালে রূপান্তরিত করে, যা কন্ট্রোলার পড়ে কম্প্রেসর অন/অফ সিদ্ধান্ত নেয়।$Q1882$,
  $Q1883$Sensor Gain H(s) ফিডব্যাক পাথে ব্যবহৃত হয়: Feedback Signal = H(s)×Output। সেন্সরের নির্ভুলতা (accuracy), রেজোলিউশন ও প্রতিক্রিয়া সময় (response time) সামগ্রিক কন্ট্রোল সিস্টেমের কর্মক্ষমতা সরাসরি প্রভাবিত করে।$Q1883$,
  $Q1884$থার্মোস্ট্যাট তাপমাত্রা সেন্সর, রোবোটিক্স পজিশন এনকোডার, গাড়ির স্পিড ও প্রেসার সেন্সর, এবং শিল্প প্রসেস কন্ট্রোল ইনস্ট্রুমেন্টেশনে ব্যবহৃত হয়।$Q1884$,
  ARRAY[$Q1885$Feedback Element$Q1885$,$Q1886$Physical Measurement$Q1886$,$Q1887$Instrumentation$Q1887$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1888$Servo Mechanism$Q1888$,
  $Q1889$S$Q1889$,
  $Q1890$control$Q1890$,
  $Q1891$Nise, Ch.1$Q1891$,
  $Q1892$low$Q1892$,
  $Q1893$controller$Q1893$,
  $Q1894$অবস্থান বা গতি নিয়ন্ত্রণের জন্য ফিডব্যাক ব্যবস্থা$Q1894$,
  $Q1895$Servo Mechanism (Servomechanism) হলো একটি স্বয়ংক্রিয় ফিডব্যাক কন্ট্রোল সিস্টেম, যা একটি যান্ত্রিক অবস্থান, গতিবেগ বা ত্বরণ নির্ভুলভাবে নিয়ন্ত্রণ করে — এটি Feedback Control System-এরই একটি বিশেষায়িত রূপ, বিশেষভাবে যান্ত্রিক গতি নিয়ন্ত্রণের জন্য প্রয়োগ করা হয়।$Q1895$,
  $Q1896$🎯 একটি স্বয়ংক্রিয় টার্গেট-ট্র্যাকিং ক্যামেরার মতো — লক্ষ্যবস্তু (কাঙ্ক্ষিত অবস্থান) যেদিকেই সরুক না কেন, ক্যামেরা (সার্ভো সিস্টেম) ক্রমাগত নিজেকে সমন্বয় করে সবসময় লক্ষ্যের দিকে মুখ করে রাখে।$Q1896$,
  $Q1897$রোবোটিক্স জয়েন্ট কন্ট্রোল, RC (রিমোট কন্ট্রোল) যানবাহনের স্টিয়ারিং, এবং CNC মেশিনের নির্ভুল পজিশনিং-এ ব্যবহৃত হয়।$Q1897$,
  $Q1898$একটি স্যাটেলাইট ডিশ Antenna Positioning Servo Mechanism ব্যবহার করে সবসময় নির্দিষ্ট স্যাটেলাইটের দিকে সঠিকভাবে মুখ করে থাকে, যদিও ডিশ মাউন্টিং সামান্য নড়ে যায়।$Q1898$,
  $Q1899$সার্ভো মেকানিজম সাধারণত Position Feedback (এনকোডার/পটেনশিওমিটার) ব্যবহার করে Error = Desired Position − Actual Position গণনা করে, তারপর PID বা অনুরূপ কন্ট্রোলার দিয়ে মোটরকে সংশোধনী কমান্ড পাঠায়।$Q1899$,
  $Q1900$RC গাড়ি/প্লেন/ড্রোন কন্ট্রোল সারফেস, রোবোটিক আর্ম জয়েন্ট, স্যাটেলাইট ডিশ অ্যান্টেনা ট্র্যাকিং, এবং CNC মেশিন টুল পজিশনিং-এ ব্যবহৃত হয়।$Q1900$,
  ARRAY[$Q1901$Position Control$Q1901$,$Q1902$Feedback System$Q1902$,$Q1903$Precision Mechanism$Q1903$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1904$Compensator (Lead-Lag)$Q1904$,
  $Q1905$C$Q1905$,
  $Q1906$control$Q1906$,
  $Q1907$Nise, Ch.9$Q1907$,
  $Q1908$low$Q1908$,
  $Q1909$controller$Q1909$,
  $Q1910$সিস্টেমের রেসপন্স উন্নত করার অতিরিক্ত নেটওয়ার্ক$Q1910$,
  $Q1911$Compensator হলো একটি অতিরিক্ত সার্কিট বা অ্যালগরিদম, যা মূল কন্ট্রোল সিস্টেমে যুক্ত করা হয় এর কর্মক্ষমতা (স্থিতিশীলতা, গতি, নির্ভুলতা) উন্নত করার জন্য — Lead Compensator ফেজ যোগ করে দ্রুততর রেসপন্স ও স্থিতিশীলতা দেয়, আর Lag Compensator স্টেডি-স্টেট নির্ভুলতা উন্নত করে (কিছুটা গতি ত্যাগ করে)।$Q1911$,
  $Q1912$🚲 সাইকেলের গিয়ার পরিবর্তনের মতো — Lead Compensator হলো নিচু গিয়ারে নামানোর মতো (দ্রুত ত্বরণ পাওয়া কিন্তু টপ স্পিড কম), আর Lag Compensator হলো উঁচু গিয়ারে থাকার মতো (ধীর ত্বরণ কিন্তু দীর্ঘমেয়াদে বেশি দক্ষ ও নির্ভুল)।$Q1912$,
  $Q1913$যখন শুধু গেইন সমন্বয় করে (Proportional Control) কাঙ্ক্ষিত পারফরমেন্স পাওয়া যায় না, তখন Root Locus বা Bode Plot-ভিত্তিক ডিজাইনে অতিরিক্ত Compensator যোগ করা হয়।$Q1913$,
  $Q1914$একটি এরোস্পেস কন্ট্রোল সিস্টেমে Lead Compensator যোগ করে সিস্টেমের Phase Margin বাড়ানো হয়, যা দ্রুততর ও বেশি স্থিতিশীল রেসপন্স দেয়, যা শুধু PID দিয়ে পাওয়া কঠিন হতো।$Q1914$,
  $Q1915$Lead Compensator: G_c(s) = K(s+z)/(s+p), যেখানে |z|<|p| (Zero, Pole-এর চেয়ে origin-এর কাছে) — এটি ফেজ যোগ করে। Lag Compensator-এ বিপরীত (|z|>|p|), যা লো-ফ্রিকোয়েন্সি গেইন বাড়িয়ে স্টেডি-স্টেট এরর কমায়।$Q1915$,
  $Q1916$এরোস্পেস ও স্যাটেলাইট কন্ট্রোল সিস্টেম ডিজাইন, শিল্প সার্ভো সিস্টেম ফাইন-টিউনিং, এবং অ্যাডভান্সড রোবোটিক্স কন্ট্রোলার ডিজাইনে ব্যবহৃত হয়।$Q1916$,
  ARRAY[$Q1917$System Enhancement$Q1917$,$Q1918$Lead-Lag Network$Q1918$,$Q1919$Advanced Control$Q1919$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1920$Logic Gates (AND/OR/NOT)$Q1920$,
  $Q1921$L$Q1921$,
  $Q1922$digital$Q1922$,
  $Q1923$Mano, Ch.2$Q1923$,
  $Q1924$critical$Q1924$,
  $Q1925$gate$Q1925$,
  $Q1926$বুলিয়ান লজিক প্রয়োগকারী মৌলিক ডিজিটাল উপাদান$Q1926$,
  $Q1927$Logic Gates হলো ডিজিটাল ইলেকট্রনিক্সের মৌলিক বিল্ডিং ব্লক, যা এক বা একাধিক বাইনারি ইনপুট (0/1) নিয়ে বুলিয়ান লজিক অনুযায়ী একটি নির্দিষ্ট আউটপুট প্রদান করে — AND (সব ইনপুট 1 হলে আউটপুট 1), OR (যেকোনো একটি ইনপুট 1 হলে আউটপুট 1), এবং NOT (ইনপুট উল্টে দেয়) হলো তিনটি মৌলিক গেট।$Q1927$,
  $Q1928$🚪 একাধিক তালাযুক্ত দরজার মতো — AND গেট হলো এমন দরজা যা খুলতে সব চাবি (সব ইনপুট) একসাথে লাগবে; OR গেট হলো এমন দরজা যা যেকোনো একটি চাবি (যেকোনো ইনপুট) দিয়েই খুলে যায়; NOT গেট হলো একটি উল্টানো সুইচ, যা চালু থাকলে বন্ধ দেখায় আর বন্ধ থাকলে চালু দেখায়।$Q1928$,
  $Q1929$সব ডিজিটাল সার্কিট, প্রসেসর ও মাইক্রোকন্ট্রোলার ডিজাইনের ভিত্তি — জটিল লজিক (যেমন CPU) এই মৌলিক গেটগুলো দিয়েই তৈরি হয়।$Q1929$,
  $Q1930$একটি লিফটের দরজা খোলার লজিক AND গেট ব্যবহার করে ডিজাইন করা যায়: 'দরজা খুলবে' শুধু যদি 'লিফট থেমেছে' AND 'বাটন চাপা হয়েছে' — উভয় শর্ত সত্য হয়।$Q1930$,
  $Q1931$AND: Y = A·B (Y=1 শুধু A=1 ও B=1 হলে)। OR: Y = A+B (Y=1 যদি A বা B যেকোনো একটি 1 হয়)। NOT: Y = A' (ইনপুট উল্টে দেয়)। এই তিনটি গেট দিয়ে যেকোনো বুলিয়ান ফাংশন তৈরি করা সম্ভব (Functionally Complete)।$Q1931$,
  $Q1932$মাইক্রোপ্রসেসর ও মাইক্রোকন্ট্রোলার ডিজাইন, ডিজিটাল ক্যালকুলেটর, ট্রাফিক লাইট কন্ট্রোল সিস্টেম, এবং যেকোনো ডিজিটাল লজিক সার্কিটে মৌলিক উপাদান হিসেবে ব্যবহৃত হয়।$Q1932$,
  ARRAY[$Q1933$Boolean Logic$Q1933$,$Q1934$Basic Gate$Q1934$,$Q1935$Digital Building Block$Q1935$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1936$Boolean Algebra$Q1936$,
  $Q1937$B$Q1937$,
  $Q1938$digital$Q1938$,
  $Q1939$Mano, Ch.2$Q1939$,
  $Q1940$critical$Q1940$,
  $Q1941$formula$Q1941$,
  $Q1942$সত্য/মিথ্যা মানের ওপর গাণিতিক লজিক সিস্টেম$Q1942$,
  $Q1943$Boolean Algebra হলো একটি গাণিতিক পদ্ধতি, যা শুধুমাত্র দুটি মান (0/False ও 1/True) নিয়ে কাজ করে, এবং AND, OR, NOT-এর মতো লজিক্যাল অপারেশন ব্যবহার করে জটিল লজিক এক্সপ্রেশন সরলীকরণ ও বিশ্লেষণ করে — এটি ডিজিটাল সার্কিট ডিজাইনের গাণিতিক ভিত্তি।$Q1943$,
  $Q1944$🧮 সাধারণ বীজগণিতের একটি সরল সংস্করণের মতো — যেখানে সাধারণ বীজগণিতে সংখ্যা যেকোনো কিছু হতে পারে, বুলিয়ান অ্যালজেব্রায় শুধু দুটি মান (সত্য বা মিথ্যা) নিয়ে কাজ করা হয়, কিন্তু নিয়মগুলো (যোগ, গুণ) একইরকম যুক্তিসঙ্গত।$Q1944$,
  $Q1945$জটিল ডিজিটাল সার্কিট সরলীকরণ (কম গেট ব্যবহার করে খরচ কমানো), এবং প্রোগ্রামিং-এ কন্ডিশনাল লজিক ডিজাইনে ব্যবহৃত হয়।$Q1945$,
  $Q1946$একটি জটিল এক্সপ্রেশন Y = A·B + A·B' কে বুলিয়ান অ্যালজেব্রা ব্যবহার করে সরলীকরণ করলে Y = A হয়ে যায় (Distributive ও Complement Law প্রয়োগ করে), যা একটি গেটের বদলে কোনো গেটই লাগবে না।$Q1946$,
  $Q1947$মৌলিক নিয়ম: Commutative (A+B=B+A), Associative, Distributive (A(B+C)=AB+AC), De Morgan's Theorem [(A+B)' = A'·B', (A·B)' = A'+B']। De Morgan's Theorem সার্কিট সরলীকরণে সবচেয়ে বেশি ব্যবহৃত হয়।$Q1947$,
  $Q1948$ডিজিটাল সার্কিট মিনিমাইজেশন (কম ট্রানজিস্টর, কম খরচ), কম্পাইলার ডিজাইনে লজিক অপ্টিমাইজেশন, এবং ডেটাবেস কোয়েরি লজিকে (SQL WHERE ক্লজ) ব্যবহৃত হয়।$Q1948$,
  ARRAY[$Q1949$Digital Logic$Q1949$,$Q1950$De Morgan's Theorem$Q1950$,$Q1951$Circuit Minimization$Q1951$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1952$Flip-Flop$Q1952$,
  $Q1953$F$Q1953$,
  $Q1954$digital$Q1954$,
  $Q1955$Mano, Ch.5$Q1955$,
  $Q1956$critical$Q1956$,
  $Q1957$flipflop$Q1957$,
  $Q1958$এক বিট তথ্য সংরক্ষণকারী মৌলিক মেমরি উপাদান$Q1958$,
  $Q1959$Flip-Flop একটি বাইস্টেবল (দুটি স্থিতিশীল অবস্থাযুক্ত) সিকোয়েনশিয়াল লজিক সার্কিট, যা একটি ক্লক পালসের সাথে সিঙ্ক্রোনাইজড হয়ে এক বিট বাইনারি তথ্য (0 বা 1) সংরক্ষণ করে রাখতে পারে — এটি সব ডিজিটাল মেমরি ও রেজিস্টারের মৌলিক একক।$Q1959$,
  $Q1960$🔦 একটি টগল সুইচের মতো — একবার চাপ দিলে চালু (1) হয়ে থাকে, আবার চাপ না দেওয়া পর্যন্ত সেই অবস্থাতেই থাকে (তথ্য ধরে রাখে), শুধু বাটন চাপলেই (ক্লক পালস) অবস্থা পরিবর্তন হয়।$Q1960$,
  $Q1961$রেজিস্টার, কাউন্টার, RAM মেমরি সেল, এবং যেকোনো সিকোয়েনশিয়াল ডিজিটাল সার্কিট তৈরির মৌলিক উপাদান হিসেবে ব্যবহৃত হয়।$Q1961$,
  $Q1962$একটি D Flip-Flop ব্যবহার করে একটি সাধারণ ১-বিট মেমরি সেল তৈরি করা যায়, যেখানে ক্লক পালসের নির্দিষ্ট মুহূর্তে (rising edge) ইনপুট D-এর মান আউটপুট Q-তে 'লক' হয়ে যায় এবং পরবর্তী পালস পর্যন্ত সেখানেই থাকে।$Q1962$,
  $Q1963$প্রধান প্রকার: SR (Set-Reset), D (Data/Delay), JK, এবং T (Toggle) Flip-Flop। D Flip-Flop-এ: Q(next) = D। JK Flip-Flop-এ J=K=1 হলে আউটপুট টগল করে (Q(next) = Q')।$Q1963$,
  $Q1964$কম্পিউটার প্রসেসরের রেজিস্টার (CPU cache), ডিজিটাল ঘড়ি ও কাউন্টার, RAM মেমরি সেল ডিজাইন, এবং FPGA/ASIC চিপ ডিজাইনে ব্যবহৃত হয়।$Q1964$,
  ARRAY[$Q1965$Sequential Circuit$Q1965$,$Q1966$Bistable$Q1966$,$Q1967$Memory Element$Q1967$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1968$Multiplexer$Q1968$,
  $Q1969$M$Q1969$,
  $Q1970$digital$Q1970$,
  $Q1971$Mano, Ch.4$Q1971$,
  $Q1972$high$Q1972$,
  $Q1973$mux$Q1973$,
  $Q1974$একাধিক ইনপুট থেকে একটি নির্বাচনকারী ডিজিটাল সুইচ$Q1974$,
  $Q1975$Multiplexer (MUX) একটি কম্বিনেশনাল সার্কিট, যা একাধিক ইনপুট লাইন থেকে একটি নির্দিষ্ট ইনপুট নির্বাচন করে সিলেক্ট লাইনের (control input) মান অনুযায়ী একক আউটপুটে পাঠায় — এটি একটি ডিজিটাল রোটারি সুইচের মতো কাজ করে।$Q1975$,
  $Q1976$📺 টিভি রিমোটের চ্যানেল সিলেক্টরের মতো — অনেকগুলো চ্যানেল (ইনপুট) উপলব্ধ থাকে, কিন্তু রিমোটে সংখ্যা চেপে (সিলেক্ট লাইন) শুধুমাত্র একটি চ্যানেলের ছবি টিভি স্ক্রিনে (আউটপুটে) দেখানো হয়।$Q1976$,
  $Q1977$ডেটা রাউটিং (একাধিক সোর্স থেকে একটি বাসে ডেটা পাঠানো), মেমরি অ্যাড্রেসিং, এবং কমিউনিকেশন সিস্টেমে চ্যানেল সিলেকশনে ব্যবহৃত হয়।$Q1977$,
  $Q1978$একটি 4-to-1 MUX-এ চারটি ইনপুট (I0-I3) ও দুটি সিলেক্ট লাইন (S1S0) থাকে; S1S0=10 হলে শুধু I2 আউটপুটে পাঠানো হয়, বাকি তিনটি ইনপুট উপেক্ষা করা হয়।$Q1978$,
  $Q1979$n সিলেক্ট লাইনের জন্য 2ⁿ ইনপুট নির্বাচন করা যায় (একটি 4-to-1 MUX-এ 2টি সিলেক্ট লাইন লাগে, log₂4=2)। Output Y = ΣIᵢ·mᵢ (mᵢ = i-তম মিনটার্ম যা সিলেক্ট লাইন দ্বারা নির্ধারিত)।$Q1979$,
  $Q1980$CPU-তে ALU ইনপুট সিলেকশন, ডিজিটাল কমিউনিকেশন চ্যানেল সুইচিং, LED ডিসপ্লে স্ক্যানিং, এবং মেমরি অ্যাড্রেস ডিকোডিং-এ ব্যবহৃত হয়।$Q1980$,
  ARRAY[$Q1981$Data Selector$Q1981$,$Q1982$Combinational Circuit$Q1982$,$Q1983$MUX$Q1983$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q1984$Demultiplexer$Q1984$,
  $Q1985$D$Q1985$,
  $Q1986$digital$Q1986$,
  $Q1987$Mano, Ch.4$Q1987$,
  $Q1988$medium$Q1988$,
  $Q1989$mux$Q1989$,
  $Q1990$একটি ইনপুট বিভিন্ন আউটপুটে বিতরণকারী সার্কিট$Q1990$,
  $Q1991$Demultiplexer (DEMUX) একটি কম্বিনেশনাল সার্কিট, যা Multiplexer-এর বিপরীত কাজ করে — এটি একটি একক ইনপুট সিগন্যাল নিয়ে সিলেক্ট লাইনের মান অনুযায়ী একাধিক আউটপুট লাইনের মধ্যে একটিতে সেই সিগন্যাল পাঠায়, বাকিগুলো নিষ্ক্রিয় থাকে।$Q1991$,
  $Q1992$🚚 একটি ডেলিভারি ট্রাকের মতো — একটি প্যাকেজ (একক ইনপুট) নিয়ে ঠিকানার (সিলেক্ট লাইন) ওপর ভিত্তি করে সঠিক বাড়িতে (নির্দিষ্ট আউটপুট লাইনে) পৌঁছে দেয়, বাকি বাড়িগুলোতে কিছু যায় না।$Q1992$,
  $Q1993$একটি কেন্দ্রীয় ডেটা সোর্স থেকে বিভিন্ন গন্তব্যে (যেমন বিভিন্ন মেমরি চিপ, বিভিন্ন ডিসপ্লে সেগমেন্ট) ডেটা রাউটিং-এ ব্যবহৃত হয়।$Q1993$,
  $Q1994$একটি 1-to-4 DEMUX ব্যবহার করে একটি মাইক্রোকন্ট্রোলারের একটি মাত্র আউটপুট পিন থেকে চারটি ভিন্ন LED-এর মধ্যে যেকোনো একটিকে (সিলেক্ট লাইন অনুযায়ী) নিয়ন্ত্রণ করা যায়।$Q1994$,
  $Q1995$n সিলেক্ট লাইনের জন্য 2ⁿ আউটপুট লাইন তৈরি করা যায়। Output Yᵢ = Input যখন সিলেক্ট লাইন i-তম আউটপুট নির্দেশ করে, বাকি সব আউটপুট 0 থাকে।$Q1995$,
  $Q1996$মেমরি চিপ সিলেকশন (Chip Select ডিকোডিং), সেভেন-সেগমেন্ট ডিসপ্লে মাল্টিপ্লেক্সিং, এবং টেলিকমিউনিকেশন সুইচিং সিস্টেমে ব্যবহৃত হয়।$Q1996$,
  ARRAY[$Q1997$Data Distributor$Q1997$,$Q1998$Combinational Circuit$Q1998$,$Q1999$DEMUX$Q1999$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2000$Encoder$Q2000$,
  $Q2001$E$Q2001$,
  $Q2002$digital$Q2002$,
  $Q2003$Mano, Ch.4$Q2003$,
  $Q2004$medium$Q2004$,
  $Q2005$encoder$Q2005$,
  $Q2006$একাধিক ইনপুটকে বাইনারি কোডে রূপান্তরকারী সার্কিট$Q2006$,
  $Q2007$Encoder একটি কম্বিনেশনাল সার্কিট, যা 2ⁿ সংখ্যক ইনপুট লাইনের মধ্যে সক্রিয় (active) ইনপুটকে একটি n-বিট বাইনারি কোডে রূপান্তরিত করে — এটি Decoder-এর বিপরীত কাজ করে।$Q2007$,
  $Q2008$🔢 একজন রিসেপশনিস্টের মতো — অনেকগুলো ডেস্কের (ইনপুট) মধ্যে কোন ডেস্কে গ্রাহক এসেছে দেখে, তার একটি নির্দিষ্ট টিকিট নম্বর (বাইনারি কোড) লিখে দেয়, যাতে পরে সহজে ট্র্যাক করা যায়।$Q2008$,
  $Q2009$কীবোর্ড এনকোডিং (কোন কী চাপা হয়েছে তা নির্ণয়), এবং একাধিক ইনপুট সোর্সকে কমপ্যাক্ট কোডে রূপান্তরে ব্যবহৃত হয়।$Q2009$,
  $Q2010$একটি ৮-থেকে-৩ Priority Encoder-এ ৮টি ইনপুট লাইনের মধ্যে যে সর্বোচ্চ অগ্রাধিকারযুক্ত ইনপুট সক্রিয় থাকে, তার সংখ্যাটিকে ৩-বিট বাইনারি কোডে রূপান্তর করে আউটপুট দেয় — যেমন কম্পিউটার কীবোর্ডে একসাথে একাধিক কী চাপলে।$Q2010$,
  $Q2011$n আউটপুট বিটের জন্য সর্বোচ্চ 2ⁿ ইনপুট লাইন এনকোড করা যায়। Priority Encoder-এ একাধিক ইনপুট একসাথে সক্রিয় হলে, সর্বোচ্চ অগ্রাধিকারযুক্ত ইনপুটকেই এনকোড করা হয়।$Q2011$,
  $Q2012$কম্পিউটার কীবোর্ড ইন্টারফেস, ইন্টারাপ্ট প্রায়োরিটি এনকোডিং (CPU-তে), এবং ডিজিটাল ক্যালকুলেটর কীপ্যাড ডিজাইনে ব্যবহৃত হয়।$Q2012$,
  ARRAY[$Q2013$Binary Encoding$Q2013$,$Q2014$Combinational Circuit$Q2014$,$Q2015$Priority Encoder$Q2015$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2016$Decoder$Q2016$,
  $Q2017$D$Q2017$,
  $Q2018$digital$Q2018$,
  $Q2019$Mano, Ch.4$Q2019$,
  $Q2020$high$Q2020$,
  $Q2021$decoder$Q2021$,
  $Q2022$বাইনারি কোডকে নির্দিষ্ট আউটপুট লাইনে রূপান্তরকারী সার্কিট$Q2022$,
  $Q2023$Decoder একটি কম্বিনেশনাল সার্কিট, যা একটি n-বিট বাইনারি ইনপুট কোড নিয়ে সেই কোডের সাথে সংশ্লিষ্ট একটি মাত্র আউটপুট লাইনকে (2ⁿ সম্ভাব্য আউটপুটের মধ্যে) সক্রিয় করে — এটি Encoder-এর বিপরীত কাজ করে।$Q2023$,
  $Q2024$🏨 একটি হোটেলের রুম নম্বরের মতো — একটি নির্দিষ্ট নম্বর (বাইনারি কোড) দিলে, শুধুমাত্র সেই নির্দিষ্ট রুমের (আউটপুট লাইনের) দরজা খুলে যায়, অন্য কোনো রুমের দরজা নয়।$Q2024$,
  $Q2025$কম্পিউটার মেমরিতে অ্যাড্রেস ডিকোডিং (কোন মেমরি লোকেশন অ্যাক্সেস করতে হবে), এবং সেভেন-সেগমেন্ট ডিসপ্লে ড্রাইভিং-এ ব্যবহৃত হয়।$Q2025$,
  $Q2026$একটি 3-to-8 Decoder কম্পিউটারের মেমরি সিস্টেমে ব্যবহৃত হয়, যেখানে 3-বিট অ্যাড্রেস ইনপুট দিয়ে ৮টি মেমরি চিপের মধ্যে ঠিক একটি চিপ সিলেক্ট (সক্রিয়) করা হয়।$Q2026$,
  $Q2027$n ইনপুট বিটের জন্য সর্বোচ্চ 2ⁿ আউটপুট লাইন তৈরি হয়। প্রতিটি আউটপুট Yᵢ = একটি নির্দিষ্ট মিনটার্ম, যা শুধু নির্দিষ্ট ইনপুট কম্বিনেশনে সক্রিয় হয় (বাকি সব 0 থাকে)।$Q2027$,
  $Q2028$কম্পিউটার মেমরি অ্যাড্রেস ডিকোডিং, সেভেন-সেগমেন্ট ডিসপ্লে ড্রাইভার (BCD-to-7-segment Decoder), এবং মাইক্রোপ্রসেসরের ইনস্ট্রাকশন ডিকোডিং ইউনিটে ব্যবহৃত হয়।$Q2028$,
  ARRAY[$Q2029$Address Decoding$Q2029$,$Q2030$Combinational Circuit$Q2030$,$Q2031$Binary Decoding$Q2031$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2032$Counter$Q2032$,
  $Q2033$C$Q2033$,
  $Q2034$digital$Q2034$,
  $Q2035$Mano, Ch.6$Q2035$,
  $Q2036$high$Q2036$,
  $Q2037$counter$Q2037$,
  $Q2038$ক্লক পালস গণনাকারী সিকোয়েনশিয়াল সার্কিট$Q2038$,
  $Q2039$Counter একটি সিকোয়েনশিয়াল ডিজিটাল সার্কিট, যা Flip-Flop-এর একটি চেইন ব্যবহার করে প্রতিটি ইনপুট ক্লক পালসে একটি পূর্বনির্ধারিত ক্রমে (সাধারণত বাইনারি) অগ্রসর হয় — এটি Synchronous (সব Flip-Flop একই ক্লকে) বা Asynchronous (প্রতিটি Flip-Flop পরেরটির ক্লক) হতে পারে।$Q2039$,
  $Q2040$🔢 একটি গাড়ির ওডোমিটারের মতো — প্রতিবার এক কিলোমিটার (এক ক্লক পালস) চলার সাথে সাথে সংখ্যাটি স্বয়ংক্রিয়ভাবে এক বেড়ে যায়, এবং সর্বোচ্চ সংখ্যায় পৌঁছালে আবার শূন্য থেকে শুরু হয়ে যায় (rollover)।$Q2040$,
  $Q2041$ডিজিটাল ঘড়ি ও টাইমার, ফ্রিকোয়েন্সি ডিভিশন (ক্লক স্পিড কমানো), এবং ইভেন্ট গণনায় (যেমন প্রোডাকশন লাইনে আইটেম কাউন্ট) ব্যবহৃত হয়।$Q2041$,
  $Q2042$একটি ডিজিটাল ঘড়িতে একাধিক কাউন্টার ব্যবহার করা হয় — একটি সেকেন্ড গোনে (0-59), আরেকটি মিনিট গোনে (0-59), যখন সেকেন্ড কাউন্টার 59 থেকে 0-তে রিসেট হয়, তখন মিনিট কাউন্টার এক বাড়ে।$Q2042$,
  $Q2043$একটি n-বিট বাইনারি কাউন্টার 0 থেকে (2ⁿ−1) পর্যন্ত গুনতে পারে, তারপর আবার শূন্যে ফিরে যায় (Modulo-2ⁿ কাউন্টার)। Mod-N কাউন্টার (যেমন Mod-10 দশমিক গণনার জন্য) বিশেষভাবে ডিজাইন করা যায় নির্দিষ্ট সংখ্যায় রিসেট করার জন্য।$Q2043$,
  $Q2044$ডিজিটাল ঘড়ি ও স্টপওয়াচ, ফ্রিকোয়েন্সি ডিভাইডার সার্কিট, শিল্প কারখানার প্রোডাকশন কাউন্টার, এবং মাইক্রোপ্রসেসরের প্রোগ্রাম কাউন্টারে ব্যবহৃত হয়।$Q2044$,
  ARRAY[$Q2045$Sequential Circuit$Q2045$,$Q2046$Flip-Flop Chain$Q2046$,$Q2047$Frequency Division$Q2047$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2048$Register (Shift Register)$Q2048$,
  $Q2049$R$Q2049$,
  $Q2050$digital$Q2050$,
  $Q2051$Mano, Ch.6$Q2051$,
  $Q2052$medium$Q2052$,
  $Q2053$register$Q2053$,
  $Q2054$একাধিক বিট সংরক্ষণ ও স্থানান্তরকারী সার্কিট$Q2054$,
  $Q2055$Register হলো একাধিক Flip-Flop-এর সমন্বয়ে গঠিত একটি সার্কিট, যা একাধিক বিট (যেমন 8-বিট, 32-বিট) একসাথে সংরক্ষণ করে — Shift Register বিশেষভাবে প্রতিটি ক্লক পালসে সংরক্ষিত বিটগুলোকে একটি নির্দিষ্ট দিকে (বামে বা ডানে) সরাতে সক্ষম।$Q2055$,
  $Q2056$🚂 একটি ট্রেনের বগির লাইনের মতো — প্রতিটি বগি (Flip-Flop) একজন যাত্রী (বিট) ধরে রাখে, আর প্রতিবার ট্রেন এগোলে (ক্লক পালস) প্রতিটি যাত্রী পরের বগিতে সরে যায় — এটাই শিফট রেজিস্টারের কাজ।$Q2056$,
  $Q2057$প্যারালাল-টু-সিরিয়াল বা সিরিয়াল-টু-প্যারালাল ডেটা রূপান্তর (যেমন UART কমিউনিকেশন), এবং প্রসেসরে অস্থায়ী ডেটা সংরক্ষণে ব্যবহৃত হয়।$Q2057$,
  $Q2058$একটি মাইক্রোকন্ট্রোলারে সিরিয়াল কমিউনিকেশন (UART) করার সময় একটি Shift Register 8-বিট ডেটাকে একটি করে বিট বের করে সিরিয়ালি পাঠায়, রিসিভিং প্রান্তে আরেকটি Shift Register সেগুলো আবার প্যারালাল বাইটে একত্র করে।$Q2058$,
  $Q2059$Register-এর ধরন: SISO (Serial-In Serial-Out), SIPO, PISO, PIPO — নাম অনুযায়ী ইনপুট/আউটপুট সিরিয়াল বা প্যারালাল কিনা তা নির্দেশ করে। n-বিট রেজিস্টারে n সংখ্যক Flip-Flop প্রয়োজন হয়।$Q2059$,
  $Q2060$CPU-এর অভ্যন্তরীণ রেজিস্টার (Accumulator, Program Counter), UART সিরিয়াল কমিউনিকেশন, এবং LED ম্যাট্রিক্স ডিসপ্লে কন্ট্রোলে ব্যবহৃত হয়।$Q2060$,
  ARRAY[$Q2061$Data Storage$Q2061$,$Q2062$Serial-Parallel Conversion$Q2062$,$Q2063$Flip-Flop Array$Q2063$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2064$Adder (Half/Full Adder)$Q2064$,
  $Q2065$A$Q2065$,
  $Q2066$digital$Q2066$,
  $Q2067$Mano, Ch.4$Q2067$,
  $Q2068$high$Q2068$,
  $Q2069$adder$Q2069$,
  $Q2070$বাইনারি সংখ্যা যোগকারী মৌলিক ডিজিটাল সার্কিট$Q2070$,
  $Q2071$Adder একটি কম্বিনেশনাল সার্কিট যা বাইনারি সংখ্যা যোগ করে — Half Adder দুটি একক-বিট সংখ্যা যোগ করে Sum ও Carry আউটপুট দেয় (আগের Carry বিবেচনা করে না), আর Full Adder দুটি বিট ও একটি Carry-in যোগ করে সম্পূর্ণ বহু-বিট যোগ সম্ভব করে।$Q2071$,
  $Q2072$🧮 হাতে হিসাব করার সময় 'হাতে রাখা' (carry) সংখ্যার মতো — Half Adder হলো প্রথম কলামের যোগ (কোনো আগের হাতে-রাখা সংখ্যা নেই), আর Full Adder হলো পরের কলামের যোগ, যেখানে আগের কলাম থেকে হাতে-রাখা সংখ্যাও যোগ করতে হয়।$Q2072$,
  $Q2073$CPU-এর ALU (Arithmetic Logic Unit)-এ সব ধরনের গাণিতিক অপারেশনের মৌলিক ভিত্তি হিসেবে, এবং ডিজিটাল ক্যালকুলেটরে ব্যবহৃত হয়।$Q2073$,
  $Q2074$একটি 4-বিট Full Adder চেইন (Ripple Carry Adder) ব্যবহার করে দুটি 4-বিট বাইনারি সংখ্যা (যেমন 0101 এবং 0011) যোগ করে 5-বিট ফলাফল (01000, দশমিকে 8) পাওয়া যায়।$Q2074$,
  $Q2075$Half Adder: Sum = A⊕B (XOR), Carry = A·B (AND)। Full Adder: Sum = A⊕B⊕Cin, Carry_out = AB + Cin(A⊕B)। একাধিক Full Adder চেইন করে (Ripple Carry) যেকোনো বিট-প্রস্থের সংখ্যা যোগ করা যায়।$Q2075$,
  $Q2076$কম্পিউটার প্রসেসরের ALU, ডিজিটাল সিগন্যাল প্রসেসিং (DSP) চিপ, এবং ক্যালকুলেটর ও এমবেডেড সিস্টেমে গাণিতিক প্রক্রিয়াকরণে ব্যবহৃত হয়।$Q2076$,
  ARRAY[$Q2077$Binary Arithmetic$Q2077$,$Q2078$Combinational Circuit$Q2078$,$Q2079$ALU Building Block$Q2079$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2080$K-Map (Karnaugh Map)$Q2080$,
  $Q2081$K$Q2081$,
  $Q2082$digital$Q2082$,
  $Q2083$Mano, Ch.3$Q2083$,
  $Q2084$high$Q2084$,
  $Q2085$gate$Q2085$,
  $Q2086$বুলিয়ান এক্সপ্রেশন সরলীকরণের গ্রাফিক্যাল পদ্ধতি$Q2086$,
  $Q2087$K-Map (Karnaugh Map) একটি গ্রাফিক্যাল পদ্ধতি, যা একটি ট্রুথ টেবিলের মানগুলোকে একটি বিশেষ গ্রিডে (যেখানে পাশাপাশি সেল মাত্র একটি ভেরিয়েবলে ভিন্ন হয়, Gray Code অর্ডারে) সাজিয়ে, চোখে দেখে সংলগ্ন সেলগুলো গ্রুপ করে বুলিয়ান এক্সপ্রেশন দ্রুত ও সহজে সরলীকরণ করতে সাহায্য করে।$Q2087$,
  $Q2088$🧩 একটি জিগস পাজলের মতো — বিক্ষিপ্ত টুকরাগুলোকে (ট্রুথ টেবিলের সারি) একটি নির্দিষ্ট প্যাটার্নে (গ্রিডে) সাজালে, চোখে সহজেই মিল খুঁজে (গ্রুপ করে) পুরো ছবির (সরলীকৃত এক্সপ্রেশন) সহজ প্যাটার্ন বের করা যায়।$Q2088$,
  $Q2089$৪-৫ ভেরিয়েবল পর্যন্ত ডিজিটাল সার্কিট হাতে-কলমে সরলীকরণে, এবং কম গেট ব্যবহার করে সার্কিট খরচ কমাতে ব্যবহৃত হয়।$Q2089$,
  $Q2090$একটি ৪-ভেরিয়েবল ফাংশনের ট্রুথ টেবিল থেকে K-Map বানিয়ে, ৮টি আলাদা মিনটার্মের বদলে মাত্র ২টি সরলীকৃত টার্মে এক্সপ্রেশন লেখা সম্ভব হয়, যা সার্কিটে ব্যবহৃত গেট সংখ্যা উল্লেখযোগ্যভাবে কমায়।$Q2090$,
  $Q2091$K-Map-এ 2ⁿ বা 2^(n-1)-সংখ্যক আসন্ন (adjacent) ১-সমূহকে (Power of 2 আকারে: 1,2,4,8...) গ্রুপ করে প্রতিটি গ্রুপ একটি সরলীকৃত টার্মে পরিণত হয় — যত বড় গ্রুপ, তত সরল টার্ম।$Q2091$,
  $Q2092$ডিজিটাল সার্কিট ডিজাইন অপ্টিমাইজেশন, FPGA/PLD প্রোগ্রামিং-এ লজিক মিনিমাইজেশন, এবং একাডেমিক ডিজিটাল লজিক ডিজাইন শিক্ষায় ব্যাপকভাবে ব্যবহৃত হয়।$Q2092$,
  ARRAY[$Q2093$Boolean Simplification$Q2093$,$Q2094$Graphical Method$Q2094$,$Q2095$Circuit Minimization$Q2095$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2096$Combinational vs Sequential Circuit$Q2096$,
  $Q2097$C$Q2097$,
  $Q2098$digital$Q2098$,
  $Q2099$Mano, Ch.4-5$Q2099$,
  $Q2100$critical$Q2100$,
  $Q2101$gate$Q2101$,
  $Q2102$মেমরিবিহীন বনাম মেমরিসহ ডিজিটাল সার্কিট$Q2102$,
  $Q2103$Combinational Circuit-এর আউটপুট শুধুমাত্র বর্তমান ইনপুটের ওপর নির্ভর করে (কোনো মেমরি নেই), যেমন Logic Gate, Adder, MUX। Sequential Circuit-এর আউটপুট বর্তমান ইনপুট ও সিস্টেমের পূর্ববর্তী অবস্থা (state, Flip-Flop-এ সংরক্ষিত) উভয়ের ওপর নির্ভর করে, যেমন Counter, Register।$Q2103$,
  $Q2104$🧮📖 ক্যালকুলেটর বনাম ডায়েরির মতো — ক্যালকুলেটর (Combinational) শুধু বর্তমান ইনপুট দেখে হিসাব দেয়, অতীত মনে রাখে না; ডায়েরি (Sequential) প্রতিদিনের এন্ট্রি আগের পাতার ওপর ভিত্তি করে লেখা হয়, অতীতের ওপর নির্ভর করে।$Q2104$,
  $Q2105$ডিজিটাল সিস্টেম ডিজাইনে সঠিক সার্কিট টাইপ নির্বাচন করতে — যদি 'মেমরি' বা 'অবস্থা' প্রয়োজন হয় (যেমন কাউন্টার), তাহলে Sequential; শুধু তাৎক্ষণিক গণনা হলে Combinational ব্যবহৃত হয়।$Q2105$,
  $Q2106$একটি সাধারণ ক্যালকুলেটরের যোগ ফাংশন Combinational (একই ইনপুটে সবসময় একই ফলাফল), কিন্তু একটি ট্রাফিক লাইট কন্ট্রোলার Sequential (বর্তমান রং পূর্ববর্তী রঙের ওপর নির্ভর করে পরিবর্তিত হয়)।$Q2106$,
  $Q2107$Combinational: Output = f(Present Inputs)। Sequential: Output = f(Present Inputs, Present State), এবং Next State = g(Present Inputs, Present State) — Sequential সার্কিটে সবসময় একটি ক্লক সিগন্যাল ও ফিডব্যাক পাথ থাকে।$Q2107$,
  $Q2108$Combinational: ক্যালকুলেটর, ALU। Sequential: ডিজিটাল ঘড়ি, কাউন্টার, CPU-এর কন্ট্রোল ইউনিট (Finite State Machine ভিত্তিক), এবং ট্রাফিক লাইট কন্ট্রোলারে ব্যবহৃত হয়।$Q2108$,
  ARRAY[$Q2109$Circuit Classification$Q2109$,$Q2110$State Memory$Q2110$,$Q2111$Digital Design Basics$Q2111$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2112$Binary Number System$Q2112$,
  $Q2113$B$Q2113$,
  $Q2114$digital$Q2114$,
  $Q2115$Mano, Ch.1$Q2115$,
  $Q2116$critical$Q2116$,
  $Q2117$binary$Q2117$,
  $Q2118$শুধুমাত্র ০ ও ১ ব্যবহারকারী ভিত্তি-২ সংখ্যা পদ্ধতি$Q2118$,
  $Q2119$Binary Number System হলো একটি ভিত্তি-২ (base-2) সংখ্যা পদ্ধতি, যেখানে শুধুমাত্র দুটি অঙ্ক (0 ও 1) ব্যবহার করে যেকোনো সংখ্যা প্রকাশ করা হয় — এটি ডিজিটাল ইলেকট্রনিক্সের ভিত্তি, কারণ ট্রানজিস্টর সহজেই দুটি অবস্থা (অন/অফ) ধরে রাখতে পারে।$Q2119$,
  $Q2120$💡 একটি লাইট সুইচের মতো — শুধু দুটি অবস্থা আছে, জ্বলা (1) বা নেভা (0), মাঝামাঝি কিছু নেই — এই সরল দ্বৈততা দিয়েই কম্পিউটার সব ধরনের জটিল তথ্য (সংখ্যা, লেখা, ছবি) প্রকাশ করে।$Q2120$,
  $Q2121$সব ডিজিটাল কম্পিউটার সিস্টেমের অভ্যন্তরীণ তথ্য উপস্থাপনার মৌলিক ভিত্তি এবং ডিজিটাল সার্কিট ডিজাইনের প্রাথমিক ধাপ হিসেবে ব্যবহৃত হয়।$Q2121$,
  $Q2122$দশমিক সংখ্যা 13 কে বাইনারিতে লিখলে হয় 1101, কারণ 13 = 1×8 + 1×4 + 0×2 + 1×1 = (1×2³)+(1×2²)+(0×2¹)+(1×2⁰)।$Q2122$,
  $Q2123$যেকোনো বাইনারি সংখ্যার দশমিক মান = Σ(bit × 2^position), position ডানদিক থেকে 0 শুরু হয়। n-বিট দিয়ে 0 থেকে (2ⁿ−1) পর্যন্ত মোট 2ⁿ সংখ্যক ভিন্ন মান প্রকাশ করা যায়।$Q2123$,
  $Q2124$কম্পিউটার মেমরি ও প্রসেসর ডিজাইন, ডিজিটাল ডেটা স্টোরেজ (হার্ড ড্রাইভ, SSD), এবং নেটওয়ার্ক প্রোটোকল (IP অ্যাড্রেসিং) ডিজাইনে ব্যবহৃত হয়।$Q2124$,
  ARRAY[$Q2125$Base-2$Q2125$,$Q2126$Digital Foundation$Q2126$,$Q2127$Number Representation$Q2127$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2128$Number System Conversion$Q2128$,
  $Q2129$N$Q2129$,
  $Q2130$digital$Q2130$,
  $Q2131$Mano, Ch.1$Q2131$,
  $Q2132$medium$Q2132$,
  $Q2133$binary$Q2133$,
  $Q2134$বিভিন্ন ভিত্তির সংখ্যা পদ্ধতির মধ্যে রূপান্তর$Q2134$,
  $Q2135$Number System Conversion হলো একটি সংখ্যাকে এক ভিত্তি (base) থেকে অন্য ভিত্তিতে (যেমন Decimal থেকে Binary, Binary থেকে Hexadecimal, Octal ইত্যাদি) রূপান্তরের প্রক্রিয়া, যা ডিজিটাল সিস্টেম ডিজাইন ও প্রোগ্রামিং-এ ব্যাপকভাবে প্রয়োজন হয়।$Q2135$,
  $Q2136$💱 বিভিন্ন ভাষায় একই সংখ্যা লেখার মতো — 'পাঁচ' বাংলায়, 'Five' ইংরেজিতে, '५' হিন্দিতে — একই পরিমাণ (মান), কিন্তু ভিন্ন প্রতীক পদ্ধতিতে (base) প্রকাশ করা হয়েছে।$Q2136$,
  $Q2137$প্রোগ্রামিং-এ মেমরি অ্যাড্রেস (Hex) পড়া, ডিজিটাল সার্কিট ডিজাইনে বাইনারি-থেকে-দশমিক যাচাই, এবং কম্পিউটার নেটওয়ার্কিং-এ IP অ্যাড্রেস (Binary/Decimal) বোঝায় ব্যবহৃত হয়।$Q2137$,
  $Q2138$প্রোগ্রামাররা প্রায়ই মেমরি অ্যাড্রেস হেক্সাডেসিমেলে দেখেন কারণ এটি সংক্ষিপ্ত — যেমন বাইনারি 11111111 (৮ বিট) কে হেক্সাডেসিমেলে মাত্র 'FF' লেখা যায়, যা পড়তে ও মনে রাখতে অনেক সহজ।$Q2138$,
  $Q2139$Decimal→Binary: বারবার 2 দিয়ে ভাগ করে ভাগশেষ (remainder) নিচ থেকে ওপরে সাজানো। Binary→Hex: প্রতি ৪-বিট গ্রুপকে একটি হেক্স অঙ্কে রূপান্তর (0000=0, 1111=F)। Binary→Octal: প্রতি ৩-বিট গ্রুপ একটি অক্টাল অঙ্কে রূপান্তর।$Q2139$,
  $Q2140$প্রোগ্রামিং ও ডিবাগিং (মেমরি অ্যাড্রেস, কালার কোড #FF5733), নেটওয়ার্ক IP অ্যাড্রেসিং, এবং ডিজিটাল সার্কিট ডিজাইন যাচাইয়ে ব্যবহৃত হয়।$Q2140$,
  ARRAY[$Q2141$Base Conversion$Q2141$,$Q2142$Hexadecimal$Q2142$,$Q2143$Programming Basics$Q2143$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2144$ALU (Arithmetic Logic Unit)$Q2144$,
  $Q2145$A$Q2145$,
  $Q2146$digital$Q2146$,
  $Q2147$Mano, Ch.10$Q2147$,
  $Q2148$high$Q2148$,
  $Q2149$chip$Q2149$,
  $Q2150$প্রসেসরের গাণিতিক ও লজিক্যাল হিসাব সম্পাদনকারী অংশ$Q2150$,
  $Q2151$ALU (Arithmetic Logic Unit) হলো একটি মাইক্রোপ্রসেসরের কেন্দ্রীয় অংশ, যা সব গাণিতিক (যোগ, বিয়োগ, গুণ) এবং লজিক্যাল (AND, OR, তুলনা) অপারেশন সম্পাদন করে — এটি কম্পিউটার CPU-এর 'গণনার মস্তিষ্ক' হিসেবে বিবেচিত হয়।$Q2151$,
  $Q2152$🧮 একজন হিসাবরক্ষকের ক্যালকুলেটরের মতো — অফিসের সব সিদ্ধান্ত (কন্ট্রোল ইউনিট) নিলেও, প্রকৃত সংখ্যা যোগ-বিয়োগ ও তুলনা করার আসল কাজটি (গণনা) একটিমাত্র বিশেষায়িত যন্ত্র (ALU) করে।$Q2152$,
  $Q2153$প্রতিটি কম্পিউটার প্রোগ্রামের প্রতিটি গাণিতিক ও লজিক্যাল অপারেশন (যেমন x+y, a>b) ALU-তে সম্পাদিত হয়।$Q2153$,
  $Q2154$যখন একটি স্প্রেডশিটে =A1+B1 ফর্মুলা ব্যবহার করা হয়, CPU-এর ALU-তে প্রকৃতপক্ষে সেই যোগ অপারেশনটি সম্পাদিত হয়, তারপর ফলাফল মেমরিতে সংরক্ষিত হয়।$Q2154$,
  $Q2155$ALU একটি n-বিট প্রশস্ত ডেটা নিয়ে কাজ করে (যেমন 32-বিট বা 64-বিট প্রসেসর) এবং একটি নিয়ন্ত্রণ সিগন্যাল (Opcode) অনুযায়ী নির্দিষ্ট অপারেশন (ADD, SUB, AND, OR, ইত্যাদি) নির্বাচন করে সম্পাদন করে, ফলাফলের সাথে Flag (Zero, Carry, Overflow) সেট করে।$Q2155$,
  $Q2156$প্রতিটি কম্পিউটার প্রসেসর (CPU) ও মাইক্রোকন্ট্রোলার, গ্রাফিক্স প্রসেসিং ইউনিট (GPU), এবং ডিজিটাল সিগন্যাল প্রসেসর (DSP)-এর মূল অংশ হিসেবে ব্যবহৃত হয়।$Q2156$,
  ARRAY[$Q2157$CPU Core$Q2157$,$Q2158$Arithmetic Operation$Q2158$,$Q2159$Processor Component$Q2159$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2160$Clock Signal$Q2160$,
  $Q2161$C$Q2161$,
  $Q2162$digital$Q2162$,
  $Q2163$Mano, Ch.5$Q2163$,
  $Q2164$high$Q2164$,
  $Q2165$clock$Q2165$,
  $Q2166$সিকোয়েনশিয়াল সার্কিটের সিঙ্ক্রোনাইজেশন পালস$Q2166$,
  $Q2167$Clock Signal হলো একটি নিয়মিত, পর্যায়ক্রমিক (periodic) স্কয়ার ওয়েভ সিগন্যাল, যা একটি ডিজিটাল সিস্টেমের সব Sequential উপাদানের (Flip-Flop, Register) কার্যক্রম সিঙ্ক্রোনাইজ (একই তালে) করে, নিশ্চিত করে যে সব অপারেশন সঠিক ও পূর্বাভাসযোগ্য ক্রমে ঘটে।$Q2167$,
  $Q2168$🥁 একটি ব্যান্ডের ড্রামারের বিটের মতো — সব বাদক (ডিজিটাল উপাদান) ড্রামারের নিয়মিত তালে (ক্লক সিগন্যাল) বাজায়, যাতে সবাই একসাথে সমন্বিতভাবে সুর তৈরি করে, কেউ এলোমেলোভাবে বাজায় না।$Q2168$,
  $Q2169$প্রতিটি মাইক্রোপ্রসেসর, মাইক্রোকন্ট্রোলার ও ডিজিটাল সিস্টেমে সব অপারেশনের টাইমিং নিয়ন্ত্রণে অপরিহার্য।$Q2169$,
  $Q2170$একটি 3 GHz প্রসেসর মানে এর ক্লক প্রতি সেকেন্ডে ৩ বিলিয়ন বার দোলন করে (পালস দেয়), এবং প্রতিটি পালসে প্রসেসর একটি বা একাধিক মৌলিক অপারেশন সম্পাদন করতে পারে।$Q2170$,
  $Q2171$Clock Frequency f = 1/T (T = ক্লক পিরিয়ড)। Rising Edge (0→1 পরিবর্তন) বা Falling Edge (1→0)-এ Flip-Flop তথ্য গ্রহণ করে — Setup Time ও Hold Time মেনে চলতে হয়, নাহলে Metastability সমস্যা হতে পারে।$Q2171$,
  $Q2172$কম্পিউটার প্রসেসর ক্লক জেনারেটর (ক্রিস্টাল অসিলেটর), ডিজিটাল যোগাযোগ প্রোটোকল সিঙ্ক্রোনাইজেশন, এবং সব সিঙ্ক্রোনাস ডিজিটাল সার্কিটে ব্যবহৃত হয়।$Q2172$,
  ARRAY[$Q2173$Synchronization$Q2173$,$Q2174$Timing Signal$Q2174$,$Q2175$Sequential Logic$Q2175$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2176$Memory (RAM/ROM)$Q2176$,
  $Q2177$M$Q2177$,
  $Q2178$digital$Q2178$,
  $Q2179$Mano, Ch.9$Q2179$,
  $Q2180$high$Q2180$,
  $Q2181$memory$Q2181$,
  $Q2182$ডিজিটাল তথ্য সংরক্ষণকারী ইলেকট্রনিক ডিভাইস$Q2182$,
  $Q2183$Memory হলো একটি ডিভাইস যা ডিজিটাল তথ্য সংরক্ষণ করে — RAM (Random Access Memory) হলো ভোলাটাইল (পাওয়ার বন্ধ হলে তথ্য মুছে যায়) মেমরি যা দ্রুত পড়া-লেখা করা যায়, আর ROM (Read-Only Memory) হলো নন-ভোলাটাইল (পাওয়ার ছাড়াও তথ্য থাকে) মেমরি যা মূলত শুধু পড়া যায়।$Q2183$,
  $Q2184$📝🗂️ কাজের নোটবুক বনাম প্রকাশিত বইয়ের মতো — RAM হলো তোমার কাজের নোটবুক, যেখানে দ্রুত লিখতে-মুছতে পারো কিন্তু বন্ধ করলে (পাওয়ার অফ) সব হারিয়ে যায়; ROM হলো একটি ছাপা বই, যা স্থায়ী কিন্তু সহজে পরিবর্তন করা যায় না।$Q2184$,
  $Q2185$কম্পিউটার সিস্টেম অপারেশনের সময় প্রোগ্রাম ও ডেটা অস্থায়ীভাবে সংরক্ষণে (RAM), এবং বুট-আপ ফার্মওয়্যার/BIOS স্থায়ীভাবে সংরক্ষণে (ROM) ব্যবহৃত হয়।$Q2185$,
  $Q2186$একটি স্মার্টফোন চালু হওয়ার সময় ROM-এ সংরক্ষিত বুটলোডার ফার্মওয়্যার প্রথমে চালু হয়, তারপর অপারেটিং সিস্টেম RAM-এ লোড হয়ে চলতে শুরু করে — ফোন বন্ধ করলে RAM-এর তথ্য মুছে যায়, কিন্তু ROM অক্ষুণ্ণ থাকে।$Q2186$,
  $Q2187$মেমরি ক্যাপাসিটি = 2^(অ্যাড্রেস বিট সংখ্যা) × (প্রতি লোকেশনে বিট সংখ্যা)। RAM-এর দুই প্রকার: SRAM (দ্রুত, Flip-Flop ভিত্তিক, ক্যাশে ব্যবহৃত) ও DRAM (সস্তা, ক্যাপাসিটর ভিত্তিক, মেইন মেমরিতে ব্যবহৃত)।$Q2187$,
  $Q2188$কম্পিউটার মেইন মেমরি (RAM), মোবাইল ফোন ফার্মওয়্যার (ROM/Flash), গেমিং কনসোল, এবং এমবেডেড সিস্টেম মাইক্রোকন্ট্রোলারে ব্যবহৃত হয়।$Q2188$,
  ARRAY[$Q2189$Data Storage$Q2189$,$Q2190$Volatile/Non-Volatile$Q2190$,$Q2191$Computer Architecture$Q2191$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2192$Multiplexed Display / 7-segment$Q2192$,
  $Q2193$M$Q2193$,
  $Q2194$digital$Q2194$,
  $Q2195$Mano, Ch.4$Q2195$,
  $Q2196$low$Q2196$,
  $Q2197$chip$Q2197$,
  $Q2198$সাতটি LED সেগমেন্ট দিয়ে সংখ্যা প্রদর্শনকারী ডিসপ্লে$Q2198$,
  $Q2199$7-Segment Display হলো সাতটি পৃথক LED সেগমেন্ট (a থেকে g চিহ্নিত) দিয়ে তৈরি একটি ডিসপ্লে ইউনিট, যেখানে নির্দিষ্ট সেগমেন্ট সমন্বয়ে জ্বালিয়ে 0-9 সংখ্যা (এবং কিছু অক্ষর) দেখানো যায়; Multiplexing কৌশল ব্যবহার করে একাধিক ডিজিট একই সময়ে (আসলে দ্রুত পালাক্রমে) দেখানো হয়, যা মানুষের চোখে একসাথে দেখাচ্ছে বলে মনে হয়।$Q2199$,
  $Q2200$🕯️ পুরনো ডিজিটাল ঘড়ির ফ্লিপ-বোর্ডের মতো — নির্দিষ্ট প্যানেল (সেগমেন্ট) উঁচু-নিচু করে আলাদা আলাদা সংখ্যা তৈরি করা যায়, আর দ্রুত একের পর এক ডিজিট আলো জ্বালিয়ে-নিভিয়ে (মাল্টিপ্লেক্সিং) একসাথে দেখানোর ভ্রম তৈরি করা হয়।$Q2200$,
  $Q2201$ডিজিটাল ঘড়ি, ক্যালকুলেটর, মাইক্রোওয়েভ ওভেন ডিসপ্লে, এবং সাধারণ সংখ্যাসূচক ইন্ডিকেটরে ব্যবহৃত হয়।$Q2201$,
  $Q2202$একটি ৪-ডিজিট ডিজিটাল ক্লকে চারটি 7-segment ডিসপ্লে মাল্টিপ্লেক্স করা হয় — প্রতিটি ডিজিট মাত্র কয়েক মিলিসেকেন্ডের জন্য জ্বলে, কিন্তু এত দ্রুত পালাক্রমে ঘটে যে চোখে সবগুলো একসাথে স্থিরভাবে জ্বলছে মনে হয় (Persistence of Vision)।$Q2202$,
  $Q2203$একটি সংখ্যা দেখাতে একটি BCD-to-7-Segment Decoder ব্যবহৃত হয়, যা 4-বিট BCD ইনপুট থেকে সাতটি আউটপুট (প্রতিটি সেগমেন্টের জন্য) তৈরি করে। মাল্টিপ্লেক্সিং রিফ্রেশ রেট সাধারণত ৬০Hz-এর বেশি রাখা হয় flicker এড়াতে।$Q2203$,
  $Q2204$ডিজিটাল ঘড়ি ও ক্যালকুলেটর, মাইক্রোওয়েভ ও ওয়াশিং মেশিন ডিসপ্লে, লিফট ফ্লোর ইন্ডিকেটর, এবং গ্যাস পাম্প প্রাইস ডিসপ্লেতে ব্যবহৃত হয়।$Q2204$,
  ARRAY[$Q2205$Display Device$Q2205$,$Q2206$BCD Decoder$Q2206$,$Q2207$Persistence of Vision$Q2207$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2208$Finite State Machine$Q2208$,
  $Q2209$F$Q2209$,
  $Q2210$digital$Q2210$,
  $Q2211$Mano, Ch.5$Q2211$,
  $Q2212$medium$Q2212$,
  $Q2213$statemachine$Q2213$,
  $Q2214$সসীম সংখ্যক অবস্থাসম্পন্ন সিকোয়েনশিয়াল মডেল$Q2214$,
  $Q2215$Finite State Machine (FSM) হলো একটি গাণিতিক মডেল, যা একটি সিস্টেমের আচরণকে সসীম সংখ্যক অবস্থার (states) মধ্যে বর্ণনা করে, যেখানে ইনপুট অনুযায়ী সিস্টেম এক অবস্থা থেকে অন্য অবস্থায় (Transition) সরে যায় — Sequential Circuit ডিজাইনের মৌলিক তাত্ত্বিক কাঠামো।$Q2215$,
  $Q2216$🚦 একটি ট্রাফিক সিগন্যালের মতো — সিস্টেমটি সবসময় একটি সুনির্দিষ্ট অবস্থায় থাকে (লাল, হলুদ বা সবুজ), এবং একটি নির্দিষ্ট শর্তে (টাইমার শেষ) পরবর্তী নির্ধারিত অবস্থায় পরিবর্তিত হয় — কখনো এলোমেলোভাবে নয়, সবসময় একটি পূর্বনির্ধারিত নিয়ম মেনে।$Q2216$,
  $Q2217$ডিজিটাল সিস্টেম কন্ট্রোল ইউনিট ডিজাইন (যেমন CPU-এর ইনস্ট্রাকশন প্রসেসিং), প্রোটোকল ডিজাইন, এবং গেম লজিক তৈরিতে ব্যবহৃত হয়।$Q2217$,
  $Q2218$একটি ভেন্ডিং মেশিনের FSM-এ বিভিন্ন অবস্থা থাকে — 'অপেক্ষমান', 'মুদ্রা গৃহীত', 'পণ্য নির্বাচিত', 'পণ্য বিতরণ' — প্রতিটি ইনপুটে (মুদ্রা দেওয়া, বাটন চাপা) নির্দিষ্ট নিয়মে পরবর্তী অবস্থায় যায়।$Q2218$,
  $Q2219$Mealy Machine-এ আউটপুট বর্তমান অবস্থা ও ইনপুট উভয়ের ফাংশন (Output = f(State, Input)); Moore Machine-এ আউটপুট শুধু বর্তমান অবস্থার ফাংশন (Output = f(State))। State Transition Table বা Diagram দিয়ে FSM ডকুমেন্ট করা হয়।$Q2219$,
  $Q2220$CPU কন্ট্রোল ইউনিট ডিজাইন, যোগাযোগ প্রোটোকল স্টেট মেশিন (TCP), ট্রাফিক লাইট কন্ট্রোলার, এবং ভিডিও গেম ক্যারেক্টার AI লজিকে ব্যবহৃত হয়।$Q2220$,
  ARRAY[$Q2221$State Diagram$Q2221$,$Q2222$Mealy-Moore$Q2222$,$Q2223$Sequential Design$Q2223$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2224$Tri-state Buffer$Q2224$,
  $Q2225$T$Q2225$,
  $Q2226$digital$Q2226$,
  $Q2227$Mano, Ch.9$Q2227$,
  $Q2228$low$Q2228$,
  $Q2229$gate$Q2229$,
  $Q2230$তৃতীয় হাই-ইমপিডেন্স অবস্থাযুক্ত বিশেষ বাফার$Q2230$,
  $Q2231$Tri-state Buffer একটি ডিজিটাল সার্কিট, যার তিনটি সম্ভাব্য আউটপুট অবস্থা থাকে — Logic 0, Logic 1, এবং High-Impedance (Z, যেখানে আউটপুট কার্যত সংযোগ-বিচ্ছিন্নের মতো আচরণ করে) — এটি একাধিক ডিভাইসকে একই কমন বাসলাইনে সংঘর্ষ ছাড়াই সংযুক্ত থাকতে দেয়।$Q2231$,
  $Q2232$🎙️ একটি সম্মেলন কক্ষের মাইক্রোফোনের মতো — যখন কারো মাইক বন্ধ থাকে (High-Z অবস্থা), সে কথা বললেও শোনা যায় না ও লাইনে হস্তক্ষেপ করে না; শুধু যার মাইক চালু (Logic 0/1 সক্রিয়) সেই একজনের কথাই স্পষ্টভাবে শোনা যায়, একসাথে সবাই বললে গোলমাল (bus conflict) হতো।$Q2232$,
  $Q2233$কম্পিউটার সিস্টেম বাসে (data bus) একাধিক ডিভাইসকে (RAM, ROM, I/O) শেয়ার্ড লাইনে সংযুক্ত রাখতে, যাতে একসাথে একাধিক ডিভাইস ড্রাইভ করে সিগন্যাল সংঘর্ষ না ঘটায়।$Q2233$,
  $Q2234$একটি কম্পিউটার মাদারবোর্ডের ডেটা বাসে RAM, ROM ও I/O কন্ট্রোলার একই তারে সংযুক্ত থাকে; Tri-state Buffer নিশ্চিত করে যে যেকোনো মুহূর্তে শুধুমাত্র একটি ডিভাইস সক্রিয়ভাবে বাস ড্রাইভ করছে, বাকিরা High-Z অবস্থায় আছে।$Q2234$,
  $Q2235$একটি Enable ইনপুট (EN) নিয়ন্ত্রণ করে আউটপুট অবস্থা: EN=1 হলে আউটপুট = ইনপুট অনুসরণ করে (0 বা 1); EN=0 হলে আউটপুট High-Impedance (Z) অবস্থায় চলে যায়, বাসের সাথে কার্যত সংযোগ-বিচ্ছিন্ন থাকে।$Q2235$,
  $Q2236$কম্পিউটার সিস্টেম বাস আর্কিটেকচার (মেমরি ও I/O শেয়ারিং), মাইক্রোপ্রসেসর ডেটা বাস ইন্টারফেস, এবং FPGA-তে multiplexed বাস ডিজাইনে ব্যবহৃত হয়।$Q2236$,
  ARRAY[$Q2237$Bus Interface$Q2237$,$Q2238$High-Impedance$Q2238$,$Q2239$Digital System Design$Q2239$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2240$Thyristor (SCR)$Q2240$,
  $Q2241$T$Q2241$,
  $Q2242$powerElectronics$Q2242$,
  $Q2243$Rashid, Ch.3$Q2243$,
  $Q2244$critical$Q2244$,
  $Q2245$thyristor$Q2245$,
  $Q2246$গেট সিগন্যাল দিয়ে চালু করা যায় এমন হাই-পাওয়ার সুইচ$Q2246$,
  $Q2247$Thyristor (Silicon Controlled Rectifier/SCR) একটি চার-স্তরের (PNPN) সেমিকন্ডাক্টর ডিভাইস, যা একটি ছোট Gate পালস দিয়ে 'অন' (ট্রিগার) করা যায়, কিন্তু বন্ধ করতে হলে মূল কারেন্টকে শূন্যে নামাতে হয় (Gate দিয়ে বন্ধ করা যায় না) — এটি উচ্চ-পাওয়ার কন্ট্রোল অ্যাপ্লিকেশনে ব্যাপকভাবে ব্যবহৃত হয়।$Q2247$,
  $Q2248$🎇 একটি পটকা বা আতশবাজির মতো — একবার সলতেতে (Gate) আগুন ধরালে (ট্রিগার), পুরো পটকা জ্বলতে থাকে (কারেন্ট প্রবাহ), শুধু সলতেয় ফুঁ দিয়ে (Gate সিগন্যাল বন্ধ করে) তা থামানো যায় না — জ্বলন শেষ হলেই (কারেন্ট শূন্যে নামলে) থামে।$Q2248$,
  $Q2249$AC-DC রেকটিফায়ার নিয়ন্ত্রণ, মোটর স্পিড কন্ট্রোল, এবং লাইট ডিমার সার্কিটে ব্যাপকভাবে ব্যবহৃত হয়।$Q2249$,
  $Q2250$একটি ফ্যান স্পিড কন্ট্রোলার (রেগুলেটর) SCR ব্যবহার করে AC পাওয়ারের একটি অংশ কেটে নিয়ন্ত্রণ করে ফ্যানের গতি সামঞ্জস্য করে।$Q2250$,
  $Q2251$V-I ক্যারেক্টারিস্টিকে SCR-এর একটি Forward Breakover Voltage আছে, কিন্তু Gate কারেন্ট প্রয়োগ করলে অনেক কম ভোল্টেজেই এটি চালু হয়ে যায়। একবার চালু হলে, বন্ধ করতে Anode কারেন্ট Holding Current-এর নিচে নামাতে হয় (Natural বা Forced Commutation)।$Q2251$,
  $Q2252$শিল্প কারখানার AC মোটর স্পিড কন্ট্রোলার, HVDC পাওয়ার ট্রান্সমিশন, লাইট ডিমার সুইচ, এবং সোলার চার্জ কন্ট্রোলারে ব্যবহৃত হয়।$Q2252$,
  ARRAY[$Q2253$Power Semiconductor$Q2253$,$Q2254$PNPN Device$Q2254$,$Q2255$Gate-Triggered$Q2255$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2256$Diode Rectifier (Power)$Q2256$,
  $Q2257$D$Q2257$,
  $Q2258$powerElectronics$Q2258$,
  $Q2259$Rashid, Ch.2$Q2259$,
  $Q2260$high$Q2260$,
  $Q2261$bridge$Q2261$,
  $Q2262$উচ্চ-পাওয়ার AC থেকে DC রূপান্তরকারী সার্কিট$Q2262$,
  $Q2263$Power Diode Rectifier একটি উচ্চ-কারেন্ট/ভোল্টেজ ক্ষমতাসম্পন্ন ডায়োড সার্কিট, যা শিল্প-স্তরে AC পাওয়ারকে DC-তে রূপান্তরিত করে — এটি ইলেকট্রনিক্সের ছোট রেকটিফায়ারের তুলনায় অনেক বেশি পাওয়ার (কিলোওয়াট থেকে মেগাওয়াট) হ্যান্ডেল করতে পারে।$Q2263$,
  $Q2264$🚰 একটি বড় শিল্প-কারখানার পানি পাম্পের ভালভের মতো — বাসাবাড়ির ছোট কলের ভালভের (ইলেকট্রনিক ডায়োড) মতোই কাজ করে, কিন্তু এটি বিশাল পরিমাণ পানি (পাওয়ার) সামলাতে ডিজাইন করা।$Q2264$,
  $Q2265$শিল্প কারখানার DC মোটর ড্রাইভ, ইলেকট্রোপ্লেটিং প্ল্যান্ট, এবং HVDC ট্রান্সমিশন সিস্টেমের কনভার্টার স্টেশনে ব্যবহৃত হয়।$Q2265$,
  $Q2266$একটি HVDC ট্রান্সমিশন স্টেশনে বিশাল থ্রি-ফেজ Diode/Thyristor Rectifier ব্যাংক ব্যবহার করে AC পাওয়ারকে DC-তে রূপান্তরিত করে শত শত কিলোমিটার দূরে পাঠানো হয়।$Q2266$,
  $Q2267$থ্রি-ফেজ ফুল-ব্রিজ রেকটিফায়ারে: V_dc = (3√3/π)×V_m ≈ 1.654×V_m (V_m = লাইন ভোল্টেজের পিক মান) — যা সিঙ্গেল-ফেজের চেয়ে অনেক কম রিপল ও বেশি দক্ষ DC আউটপুট দেয়।$Q2267$,
  $Q2268$HVDC পাওয়ার ট্রান্সমিশন, শিল্প ইলেকট্রোপ্লেটিং ও ইলেকট্রোলাইসিস প্ল্যান্ট, এবং বড় DC মোটর ড্রাইভ সিস্টেমে ব্যবহৃত হয়।$Q2268$,
  ARRAY[$Q2269$High Power Rectifier$Q2269$,$Q2270$Three-Phase$Q2270$,$Q2271$HVDC$Q2271$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2272$Inverter$Q2272$,
  $Q2273$I$Q2273$,
  $Q2274$powerElectronics$Q2274$,
  $Q2275$Rashid, Ch.6$Q2275$,
  $Q2276$critical$Q2276$,
  $Q2277$converter$Q2277$,
  $Q2278$DC কে AC তে রূপান্তরকারী পাওয়ার ইলেকট্রনিক সার্কিট$Q2278$,
  $Q2279$Inverter একটি পাওয়ার ইলেকট্রনিক সার্কিট, যা DC পাওয়ারকে (ব্যাটারি বা সোলার প্যানেল থেকে) AC পাওয়ারে রূপান্তরিত করে, দ্রুত সুইচিং (MOSFET/IGBT দিয়ে) ব্যবহার করে ভোল্টেজের দিক পর্যায়ক্রমে পাল্টে একটি সাইনুসয়েডাল-সদৃশ ওয়েভফর্ম তৈরি করে।$Q2279$,
  $Q2280$🔄 Rectifier-এর উল্টো কাজের মতো — Rectifier যেমন AC কে DC বানায়, Inverter ঠিক তার বিপরীত কাজ করে, DC-কে AC বানায় — একটি রাস্তায় দুই দিকেই ট্রাফিক চালানোর সুবিধার মতো।$Q2280$,
  $Q2281$সোলার প্যানেল সিস্টেমে DC থেকে গৃহস্থালী AC পাওয়ার তৈরি, UPS ব্যাকআপ পাওয়ার সাপ্লাই, এবং ইলেকট্রিক গাড়ির মোটর ড্রাইভে ব্যবহৃত হয়।$Q2281$,
  $Q2282$একটি সোলার হোম সিস্টেমে ব্যাটারিতে জমা DC বিদ্যুৎকে ইনভার্টার 220V, 50Hz AC-তে রূপান্তর করে, যা সরাসরি বাসার সাধারণ বৈদ্যুতিক যন্ত্রপাতিতে ব্যবহার করা যায়।$Q2282$,
  $Q2283$Square Wave Inverter সহজ কিন্তু বেশি হারমনিক্স তৈরি করে; Modified Sine Wave ও Pure Sine Wave Inverter PWM কৌশল ব্যবহার করে আরও মসৃণ, কম-বিকৃতি সিগন্যাল তৈরি করে যা সংবেদনশীল ইলেকট্রনিক যন্ত্রের জন্য নিরাপদ।$Q2283$,
  $Q2284$সোলার ইনভার্টার (গ্রিড-টাই ও অফ-গ্রিড), UPS ও ইনভার্টার ব্যাটারি ব্যাকআপ সিস্টেম, ইলেকট্রিক ভেহিকেল মোটর ড্রাইভ, এবং ইন্ডাস্ট্রিয়াল VFD-তে ব্যবহৃত হয়।$Q2284$,
  ARRAY[$Q2285$DC-AC Conversion$Q2285$,$Q2286$PWM$Q2286$,$Q2287$Solar Power$Q2287$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2288$Chopper (DC-DC Converter)$Q2288$,
  $Q2289$C$Q2289$,
  $Q2290$powerElectronics$Q2290$,
  $Q2291$Rashid, Ch.5$Q2291$,
  $Q2292$high$Q2292$,
  $Q2293$converter$Q2293$,
  $Q2294$DC ভোল্টেজের মাত্রা পরিবর্তনকারী সার্কিট$Q2294$,
  $Q2295$Chopper (DC-DC Converter) একটি পাওয়ার ইলেকট্রনিক সার্কিট, যা একটি স্থির DC ইনপুট ভোল্টেজকে দ্রুত সুইচিং (ON/OFF) করে গড়ে একটি ভিন্ন (বেশি বা কম) DC আউটপুট ভোল্টেজে রূপান্তরিত করে — এটি Linear Regulator-এর চেয়ে অনেক বেশি দক্ষ।$Q2295$,
  $Q2296$🚰 একটি দ্রুত খোলা-বন্ধ হওয়া কলের মতো — কল সম্পূর্ণ খোলা না রেখে অতি দ্রুত খুলছে-বন্ধ করছে (সুইচিং), গড়ে যে পরিমাণ পানি (ভোল্টেজ) বের হচ্ছে তা কলের 'খোলা থাকার সময়ের অনুপাত' (Duty Cycle) দিয়ে নিয়ন্ত্রণ করা যাচ্ছে।$Q2296$,
  $Q2297$ব্যাটারি-চালিত ডিভাইসে দক্ষ ভোল্টেজ নিয়ন্ত্রণ, DC মোটর স্পিড কন্ট্রোল, এবং সোলার MPPT চার্জ কন্ট্রোলারে ব্যবহৃত হয়।$Q2297$,
  $Q2298$একটি ইলেকট্রিক গাড়িতে ব্যাটারি থেকে মোটরে পাঠানো ভোল্টেজ Chopper সার্কিট দিয়ে নিয়ন্ত্রণ করা হয়, যা এক্সিলারেটর প্যাডেল চাপার পরিমাণ অনুযায়ী মোটরের গতি নিয়ন্ত্রণ করে।$Q2298$,
  $Q2299$Average Output Voltage V_o = D×V_in (D = Duty Cycle, 0 থেকে 1)। D নিয়ন্ত্রণ করেই আউটপুট ভোল্টেজ সমন্বয় করা যায়, এবং সুইচিং লস কম হওয়ায় দক্ষতা প্রায়ই ৯০%+ পাওয়া যায়।$Q2299$,
  $Q2300$ইলেকট্রিক ট্রেন ও ভেহিকেল মোটর কন্ট্রোল, ব্যাটারি চার্জ কন্ট্রোলার (সোলার MPPT), এবং ল্যাপটপ/মোবাইল পাওয়ার সাপ্লাইতে ব্যবহৃত হয়।$Q2300$,
  ARRAY[$Q2301$DC-DC Conversion$Q2301$,$Q2302$Duty Cycle$Q2302$,$Q2303$Switching Regulator$Q2303$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2304$PWM (Pulse Width Modulation)$Q2304$,
  $Q2305$P$Q2305$,
  $Q2306$powerElectronics$Q2306$,
  $Q2307$Rashid, Ch.6$Q2307$,
  $Q2308$critical$Q2308$,
  $Q2309$pwm$Q2309$,
  $Q2310$পালসের প্রস্থ পরিবর্তন করে গড় পাওয়ার নিয়ন্ত্রণ$Q2310$,
  $Q2311$PWM (Pulse Width Modulation) হলো একটি কৌশল, যেখানে একটি স্থির ফ্রিকোয়েন্সির স্কয়ার ওয়েভের 'অন' সময়ের প্রস্থ (Pulse Width বা Duty Cycle) পরিবর্তন করে গড় ভোল্টেজ বা পাওয়ার নিয়ন্ত্রণ করা হয় — এটি Inverter, Motor Drive ও LED ডিমিং-এর প্রধান নিয়ন্ত্রণ পদ্ধতি।$Q2311$,
  $Q2312$💡 একটি লাইট দ্রুত জ্বালানো-নেভানোর মতো — লাইট এত দ্রুত অন-অফ হয় যে চোখে বোঝা যায় না, কিন্তু 'অন' থাকার সময়ের অনুপাত (Duty Cycle) বেশি হলে লাইট বেশি উজ্জ্বল, কম হলে কম উজ্জ্বল মনে হয়।$Q2312$,
  $Q2313$মোটর স্পিড কন্ট্রোল, LED ডিমিং, ইনভার্টারে সাইনুসয়েডাল আউটপুট তৈরি, এবং সুইচিং পাওয়ার সাপ্লাই ডিজাইনে ব্যাপকভাবে ব্যবহৃত হয়।$Q2313$,
  $Q2314$একটি সোলার MPPT চার্জ কন্ট্রোলারে PWM ব্যবহার করে সোলার প্যানেলের ভোল্টেজকে ব্যাটারি চার্জিং-এর জন্য উপযুক্ত মাত্রায় দক্ষতার সাথে রূপান্তরিত করা হয়, লিনিয়ার রেগুলেটরের তুলনায় অনেক কম তাপ অপচয় করে।$Q2314$,
  $Q2315$Duty Cycle D = t_on/T (T = মোট পিরিয়ড)। Average Voltage V_avg = D×V_supply। PWM ফ্রিকোয়েন্সি যত বেশি (সাধারণত কয়েক kHz থেকে MHz), আউটপুট তত মসৃণ (কম রিপল), কিন্তু সুইচিং লসও বাড়ে।$Q2315$,
  $Q2316$ইলেকট্রিক গাড়ির মোটর কন্ট্রোলার, সোলার ইনভার্টার ও চার্জ কন্ট্রোলার, LED লাইট ডিমার, এবং কম্পিউটার পাওয়ার সাপ্লাই (SMPS)-এ ব্যবহৃত হয়।$Q2316$,
  ARRAY[$Q2317$Duty Cycle$Q2317$,$Q2318$Motor Control$Q2318$,$Q2319$Switching Technique$Q2319$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2320$Power MOSFET$Q2320$,
  $Q2321$P$Q2321$,
  $Q2322$powerElectronics$Q2322$,
  $Q2323$Rashid, Ch.3$Q2323$,
  $Q2324$high$Q2324$,
  $Q2325$mosfet$Q2325$,
  $Q2326$উচ্চ-গতির পাওয়ার সুইচিং ট্রানজিস্টর$Q2326$,
  $Q2327$Power MOSFET একটি ভোল্টেজ-নিয়ন্ত্রিত সেমিকন্ডাক্টর সুইচ, যা কম ভোল্টেজ (সাধারণত <1000V) অ্যাপ্লিকেশনে অত্যন্ত উচ্চ সুইচিং গতিতে (কয়েক kHz থেকে MHz) কাজ করতে সক্ষম, এবং কম গেট ড্রাইভ কারেন্ট প্রয়োজন হয় — এটি আধুনিক সুইচিং পাওয়ার সাপ্লাই ও কনভার্টারের মূল উপাদান।$Q2327$,
  $Q2328$⚡ একটি অতি দ্রুত ইলেকট্রিক সুইচের মতো — সাধারণ ট্রানজিস্টরের চেয়ে অনেক দ্রুত অন-অফ (সুইচ) করতে পারে, প্রায় সেকেন্ডে লাখো বার, যা পাওয়ার কনভার্টারে অত্যন্ত সূক্ষ্ম নিয়ন্ত্রণ সম্ভব করে।$Q2328$,
  $Q2329$কম-ভোল্টেজ, উচ্চ-ফ্রিকোয়েন্সি DC-DC কনভার্টার, কম্পিউটার পাওয়ার সাপ্লাই (SMPS), এবং ছোট মোটর ড্রাইভে ব্যবহৃত হয়।$Q2329$,
  $Q2330$মোবাইল ফোন চার্জারের ভেতরে ছোট Power MOSFET উচ্চ ফ্রিকোয়েন্সিতে (কয়েক শত kHz) সুইচ করে, যা ছোট ও হালকা ট্রান্সফরমার ব্যবহার সম্ভব করে (কম-ফ্রিকোয়েন্সি ডিজাইনের তুলনায় অনেক ছোট)।$Q2330$,
  $Q2331$উচ্চ-ভোল্টেজে (>1000V) Power MOSFET-এর On-Resistance (R_DS(on)) দ্রুত বাড়ে, তাই উচ্চ-ভোল্টেজ অ্যাপ্লিকেশনে IGBT বেশি উপযুক্ত। কম-ভোল্টেজ, উচ্চ-ফ্রিকোয়েন্সিতে MOSFET-এর সুইচিং লস IGBT-এর চেয়ে কম।$Q2331$,
  $Q2332$মোবাইল ও ল্যাপটপ চার্জার, কম্পিউটার পাওয়ার সাপ্লাই, সোলার MPPT কন্ট্রোলার, এবং ছোট ইলেকট্রিক ভেহিকেল কন্ট্রোলারে ব্যবহৃত হয়।$Q2332$,
  ARRAY[$Q2333$Power Switch$Q2333$,$Q2334$High-Frequency Switching$Q2334$,$Q2335$Low Voltage$Q2335$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2336$IGBT$Q2336$,
  $Q2337$I$Q2337$,
  $Q2338$powerElectronics$Q2338$,
  $Q2339$Rashid, Ch.3$Q2339$,
  $Q2340$critical$Q2340$,
  $Q2341$mosfet$Q2341$,
  $Q2342$উচ্চ-ভোল্টেজ ও উচ্চ-কারেন্টের হাইব্রিড পাওয়ার সুইচ$Q2342$,
  $Q2343$IGBT (Insulated Gate Bipolar Transistor) একটি হাইব্রিড ডিভাইস, যা MOSFET-এর ভোল্টেজ-নিয়ন্ত্রিত সহজ গেট ড্রাইভ এবং BJT-এর উচ্চ-ভোল্টেজ, উচ্চ-কারেন্ট হ্যান্ডলিং ক্ষমতা একত্রিত করে — এটি মাঝারি-উচ্চ পাওয়ার (কয়েক kW থেকে MW) অ্যাপ্লিকেশনে সবচেয়ে জনপ্রিয় সুইচ।$Q2343$,
  $Q2344$🚛 একটি হাইব্রিড ট্রাকের মতো — MOSFET-এর 'সহজ স্টিয়ারিং' (সহজ গেট কন্ট্রোল) আর BJT-এর 'ভারী মাল বহনের ক্ষমতা' (উচ্চ পাওয়ার হ্যান্ডলিং) — দুটো সেরা বৈশিষ্ট্য মিলিয়ে একটি শক্তিশালী যান তৈরি হয়েছে।$Q2344$,
  $Q2345$ইলেকট্রিক ভেহিকেল মোটর ড্রাইভ, শিল্প কারখানার ইনভার্টার ও VFD, এবং রেনিউয়েবল এনার্জি (সোলার/উইন্ড) কনভার্টারে ব্যাপকভাবে ব্যবহৃত হয়।$Q2345$,
  $Q2346$একটি ইলেকট্রিক গাড়ির মোটর কন্ট্রোলারে IGBT ব্যবহার করা হয়, যা ব্যাটারির উচ্চ-ভোল্টেজ DC পাওয়ারকে দ্রুত সুইচ করে মোটরের জন্য প্রয়োজনীয় থ্রি-ফেজ AC তৈরি করে।$Q2346$,
  $Q2347$IGBT MOSFET-এর মতো Gate ভোল্টেজ দিয়ে নিয়ন্ত্রিত হয় (কম গেট ড্রাইভ পাওয়ার প্রয়োজন), কিন্তু কন্ডাকশনের সময় BJT-এর মতো আচরণ করে (কম Forward Voltage Drop, উচ্চ কারেন্ট ক্যাপাসিটি)। সুইচিং স্পিড MOSFET-এর চেয়ে সামান্য কম।$Q2347$,
  $Q2348$ইলেকট্রিক ও হাইব্রিড ভেহিকেল ড্রাইভট্রেন, শিল্প কারখানার VFD (Variable Frequency Drive), সোলার ও উইন্ড ইনভার্টার, এবং ট্রেন ট্র্যাকশন কন্ট্রোলে ব্যবহৃত হয়।$Q2348$,
  ARRAY[$Q2349$Hybrid Power Device$Q2349$,$Q2350$High Power Switch$Q2350$,$Q2351$Motor Drive$Q2351$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2352$TRIAC$Q2352$,
  $Q2353$T$Q2353$,
  $Q2354$powerElectronics$Q2354$,
  $Q2355$Rashid, Ch.3$Q2355$,
  $Q2356$medium$Q2356$,
  $Q2357$triac$Q2357$,
  $Q2358$উভয় দিকে কারেন্ট প্রবাহ নিয়ন্ত্রণকারী AC সুইচ$Q2358$,
  $Q2359$TRIAC (Triode for Alternating Current) একটি বাইডাইরেকশনাল থাইরিস্টর-জাতীয় ডিভাইস, যা AC সিগন্যালের উভয় অর্ধ-চক্রে (positive ও negative) কারেন্ট প্রবাহ নিয়ন্ত্রণ করতে সক্ষম — এটি মূলত দুটি SCR পরস্পর বিপরীতমুখী সংযুক্ত করে তৈরি একটি সমতুল্য কাঠামো।$Q2359$,
  $Q2360$🚪🚪 দুই দিকেই খোলা যায় এমন একটি দরজার মতো — সাধারণ SCR (একমুখী দরজা) শুধু একদিক থেকেই ঢুকতে দেয়, কিন্তু TRIAC উভয় দিক থেকেই (AC-এর উভয় অর্ধ-চক্রে) কারেন্ট প্রবাহ নিয়ন্ত্রণ করতে পারে।$Q2360$,
  $Q2361$গৃহস্থালী AC লোড নিয়ন্ত্রণে (লাইট ডিমার, ফ্যান স্পিড কন্ট্রোলার), কারণ এটি একটি মাত্র ডিভাইস দিয়ে সম্পূর্ণ AC সাইকেল নিয়ন্ত্রণ করতে পারে।$Q2361$,
  $Q2362$একটি সাধারণ বাসাবাড়ির লাইট ডিমার সুইচে TRIAC ব্যবহার করা হয়, যা প্রতিটি AC সাইকেলের একটি নির্দিষ্ট অংশ (Firing Angle অনুযায়ী) কেটে বাল্বের উজ্জ্বলতা নিয়ন্ত্রণ করে।$Q2362$,
  $Q2363$TRIAC-কে দুই দিকেই (Quadrant I ও III প্রধানত) Gate পালস দিয়ে ট্রিগার করা যায়। দুটি পৃথক SCR ব্যবহারের তুলনায় TRIAC কম জায়গা নেয় এবং সহজ, তবে উচ্চ-পাওয়ার শিল্প অ্যাপ্লিকেশনে দুটি পৃথক SCR (Anti-parallel) বেশি নির্ভরযোগ্য।$Q2363$,
  $Q2364$গৃহস্থালী লাইট ডিমার, ফ্যান স্পিড কন্ট্রোলার, ছোট হিটার তাপমাত্রা নিয়ন্ত্রণ, এবং সাধারণ AC মোটর স্পিড কন্ট্রোলে ব্যবহৃত হয়।$Q2364$,
  ARRAY[$Q2365$Bidirectional Switch$Q2365$,$Q2366$AC Control$Q2366$,$Q2367$Dimmer Circuit$Q2367$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2368$Buck Converter$Q2368$,
  $Q2369$B$Q2369$,
  $Q2370$powerElectronics$Q2370$,
  $Q2371$Rashid, Ch.5$Q2371$,
  $Q2372$high$Q2372$,
  $Q2373$converter$Q2373$,
  $Q2374$DC ভোল্টেজ কমানোর কনভার্টার$Q2374$,
  $Q2375$Buck Converter একটি ধরনের DC-DC কনভার্টার (Step-Down), যা ইনপুট DC ভোল্টেজের চেয়ে কম আউটপুট ভোল্টেজ তৈরি করে, উচ্চ দক্ষতায় (সাধারণত ৯০%+) — এটি একটি সুইচ, ডায়োড, ইন্ডাক্টর ও ক্যাপাসিটর দিয়ে গঠিত।$Q2375$,
  $Q2376$🎢 একটি নিয়ন্ত্রিত পাহাড় থেকে নামার পথের মতো — বিশাল উচ্চতা (ইনপুট ভোল্টেজ) থেকে দ্রুত নিয়ন্ত্রিতভাবে নামিয়ে (সুইচিং) কম উচ্চতায় (আউটপুট ভোল্টেজ) নিয়ে আসা হয়, শক্তির বেশিরভাগ অংশ ব্যবহারযোগ্য থাকে (উচ্চ দক্ষতা)।$Q2376$,
  $Q2377$ল্যাপটপ ও মোবাইল ফোন চার্জার, USB পাওয়ার ব্যাংক, এবং যেকোনো ডিভাইসে উচ্চ ব্যাটারি ভোল্টেজ থেকে নিম্ন লজিক ভোল্টেজ (যেমন 5V, 3.3V) তৈরিতে ব্যবহৃত হয়।$Q2377$,
  $Q2378$একটি ল্যাপটপ চার্জারের 19V DC আউটপুটকে ল্যাপটপের অভ্যন্তরীণ Buck Converter আরও কমিয়ে CPU-এর জন্য 1.2V-এর মতো নিম্ন ভোল্টেজে রূপান্তরিত করে।$Q2378$,
  $Q2379$V_out = D×V_in (D = Duty Cycle, 0<D<1)। যেহেতু D সবসময় 1-এর কম, আউটপুট সবসময় ইনপুটের চেয়ে কম হয়। ইন্ডাক্টর কারেন্ট রিপল ও ক্যাপাসিটর আউটপুট রিপল কমাতে সাহায্য করে।$Q2379$,
  $Q2380$মোবাইল ও ল্যাপটপ চার্জার, USB পাওয়ার ডেলিভারি, প্রসেসর পাওয়ার সাপ্লাই (VRM), এবং ব্যাটারি-চালিত সব ইলেকট্রনিক ডিভাইসে ব্যবহৃত হয়।$Q2380$,
  ARRAY[$Q2381$Step-Down Converter$Q2381$,$Q2382$DC-DC$Q2382$,$Q2383$High Efficiency$Q2383$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2384$Boost Converter$Q2384$,
  $Q2385$B$Q2385$,
  $Q2386$powerElectronics$Q2386$,
  $Q2387$Rashid, Ch.5$Q2387$,
  $Q2388$high$Q2388$,
  $Q2389$converter$Q2389$,
  $Q2390$DC ভোল্টেজ বাড়ানোর কনভার্টার$Q2390$,
  $Q2391$Boost Converter একটি ধরনের DC-DC কনভার্টার (Step-Up), যা ইনপুট DC ভোল্টেজের চেয়ে বেশি আউটপুট ভোল্টেজ তৈরি করে — এটি ইন্ডাক্টরে শক্তি সঞ্চয় করে (সুইচ 'অন' অবস্থায়) এবং পরে সেই শক্তি উচ্চ ভোল্টেজে আউটপুটে ছেড়ে দেয় (সুইচ 'অফ' অবস্থায়)।$Q2391$,
  $Q2392$🤸 একটি ট্রাম্পোলিনের মতো — একটু নিচে চেপে (ইন্ডাক্টরে শক্তি জমিয়ে) তারপর ছেড়ে দিলে (সুইচ অফ), তুমি প্রাথমিক অবস্থানের চেয়েও অনেক বেশি উঁচুতে (আউটপুট ভোল্টেজ) উঠে যাও।$Q2392$,
  $Q2393$একক ব্যাটারি সেল থেকে উচ্চ ভোল্টেজ তৈরি (যেমন LED ফ্ল্যাশলাইট ড্রাইভার), এবং সোলার প্যানেল থেকে ব্যাটারি চার্জিং ভোল্টেজ বাড়াতে ব্যবহৃত হয়।$Q2393$,
  $Q2394$একটি একক 1.5V AA ব্যাটারি দিয়ে চালিত LED ফ্ল্যাশলাইটে Boost Converter ব্যবহার করে সেই কম ভোল্টেজকে LED চালানোর জন্য প্রয়োজনীয় 3-3.5V-এ বাড়ানো হয়।$Q2394$,
  $Q2395$V_out = V_in/(1−D) (D = Duty Cycle)। D যত 1-এর কাছাকাছি যায়, আউটপুট ভোল্টেজ তত বেশি বাড়ে (তাত্ত্বিকভাবে D=1-এ অসীম, কিন্তু বাস্তবে সীমিত থাকে ক্ষতির কারণে)।$Q2395$,
  $Q2396$LED ড্রাইভার ও ফ্ল্যাশলাইট, সোলার প্যানেল MPPT সিস্টেম, ইলেকট্রিক ভেহিকেল ব্যাটারি ভোল্টেজ বুস্টিং, এবং পোর্টেবল ইলেকট্রনিক ডিভাইস পাওয়ার সাপ্লাইতে ব্যবহৃত হয়।$Q2396$,
  ARRAY[$Q2397$Step-Up Converter$Q2397$,$Q2398$DC-DC$Q2398$,$Q2399$Energy Storage$Q2399$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2400$Buck-Boost Converter$Q2400$,
  $Q2401$B$Q2401$,
  $Q2402$powerElectronics$Q2402$,
  $Q2403$Rashid, Ch.5$Q2403$,
  $Q2404$medium$Q2404$,
  $Q2405$converter$Q2405$,
  $Q2406$ভোল্টেজ কমানো ও বাড়ানো উভয়ই করতে সক্ষম কনভার্টার$Q2406$,
  $Q2407$Buck-Boost Converter একটি DC-DC কনভার্টার, যা Duty Cycle-এর মান অনুযায়ী আউটপুট ভোল্টেজকে ইনপুটের চেয়ে কম বা বেশি — উভয়ই করতে সক্ষম, এবং সাধারণ টপোলজিতে আউটপুট ভোল্টেজের পোলারিটি ইনপুটের বিপরীত হয়ে যায়।$Q2407$,
  $Q2408$🎚️ একটি সর্বজনীন ভলিউম নবের মতো — শুধু ভলিউম বাড়ানো বা শুধু কমানো নয়, একই নব দিয়ে উভয় দিকেই (কম-বেশি) সম্পূর্ণ নিয়ন্ত্রণ পাওয়া যায়।$Q2408$,
  $Q2409$সোলার প্যানেল সিস্টেমে যেখানে প্যানেলের ভোল্টেজ দিনের বিভিন্ন সময়ে ব্যাটারি ভোল্টেজের চেয়ে কম বা বেশি হতে পারে, সেখানে নমনীয় ভোল্টেজ কন্ট্রোলে ব্যবহৃত হয়।$Q2409$,
  $Q2410$একটি ব্যাটারি ম্যানেজমেন্ট সিস্টেমে যখন ব্যাটারি ভোল্টেজ কখনো সিস্টেম রিকোয়ারমেন্টের চেয়ে বেশি, কখনো কম থাকে (ডিসচার্জ হওয়ার সাথে সাথে), তখন Buck-Boost Converter উভয় পরিস্থিতিতে স্থির আউটপুট নিশ্চিত করে।$Q2410$,
  $Q2411$V_out = −D/(1−D) × V_in (Duty Cycle D-এর ওপর ভিত্তি করে আউটপুট কম বা বেশি হতে পারে; ঋণাত্মক চিহ্ন পোলারিটি বিপরীত হওয়া নির্দেশ করে সাধারণ টপোলজিতে)। D<0.5 হলে Buck মোড, D>0.5 হলে Boost মোড আচরণ করে।$Q2411$,
  $Q2412$সোলার MPPT চার্জ কন্ট্রোলার, ব্যাটারি ম্যানেজমেন্ট সিস্টেম, এবং বিস্তৃত ইনপুট ভোল্টেজ রেঞ্জসম্পন্ন পোর্টেবল ইলেকট্রনিক ডিভাইসে ব্যবহৃত হয়।$Q2412$,
  ARRAY[$Q2413$Step Up-Down Converter$Q2413$,$Q2414$Polarity Inversion$Q2414$,$Q2415$Flexible Voltage$Q2415$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2416$AC Voltage Controller$Q2416$,
  $Q2417$A$Q2417$,
  $Q2418$powerElectronics$Q2418$,
  $Q2419$Rashid, Ch.4$Q2419$,
  $Q2420$medium$Q2420$,
  $Q2421$triac$Q2421$,
  $Q2422$একই ফ্রিকোয়েন্সিতে AC ভোল্টেজের RMS মান নিয়ন্ত্রণকারী সার্কিট$Q2422$,
  $Q2423$AC Voltage Controller একটি পাওয়ার ইলেকট্রনিক সার্কিট, যা একই ইনপুট ফ্রিকোয়েন্সি বজায় রেখে AC আউটপুট ভোল্টেজের RMS মান নিয়ন্ত্রণ করে — এটি সাধারণত TRIAC বা Anti-parallel SCR ব্যবহার করে Phase Angle Control-এর মাধ্যমে কাজ করে।$Q2423$,
  $Q2424$🚿 শাওয়ারের পানির প্রবাহ কমানোর মতো — পানির উৎস (ফ্রিকোয়েন্সি) পরিবর্তন না করেই, ভালভ আংশিক বন্ধ রেখে (Firing Angle Control) প্রবাহের পরিমাণ (RMS ভোল্টেজ) নিয়ন্ত্রণ করা হয়।$Q2424$,
  $Q2425$গৃহস্থালী লাইট ডিমার, ফ্যান স্পিড কন্ট্রোলার, ইলেকট্রিক হিটার তাপমাত্রা নিয়ন্ত্রণ, এবং ছোট AC মোটর স্পিড কন্ট্রোলে ব্যবহৃত হয়।$Q2425$,
  $Q2426$একটি ইলেকট্রিক ওভেনের হিটিং এলিমেন্টের তাপমাত্রা নিয়ন্ত্রণে AC Voltage Controller ব্যবহার করা হয়, যা প্রতিটি AC সাইকেলের একটি নির্দিষ্ট অংশ কেটে হিটারে সরবরাহকৃত গড় পাওয়ার নিয়ন্ত্রণ করে।$Q2426$,
  $Q2427$Phase Angle Control-এ Firing Angle (α) নিয়ন্ত্রণ করে আউটপুট RMS ভোল্টেজ V_rms = V_m√[(1/π)(π−α+sin2α/2)] নির্ধারিত হয়, যেখানে α বাড়ালে আউটপুট RMS ভোল্টেজ কমে।$Q2427$,
  $Q2428$লাইট ডিমার সুইচ, ফ্যান রেগুলেটর, ইলেকট্রিক হিটার তাপমাত্রা কন্ট্রোলার, এবং ছোট শিল্প যন্ত্রপাতির AC মোটর স্পিড কন্ট্রোলে ব্যবহৃত হয়।$Q2428$,
  ARRAY[$Q2429$RMS Control$Q2429$,$Q2430$Phase Angle Control$Q2430$,$Q2431$AC Regulation$Q2431$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2432$Cycloconverter$Q2432$,
  $Q2433$C$Q2433$,
  $Q2434$powerElectronics$Q2434$,
  $Q2435$Rashid, Ch.4$Q2435$,
  $Q2436$low$Q2436$,
  $Q2437$converter$Q2437$,
  $Q2438$সরাসরি AC থেকে ভিন্ন-ফ্রিকোয়েন্সির AC তৈরিকারী কনভার্টার$Q2438$,
  $Q2439$Cycloconverter একটি পাওয়ার ইলেকট্রনিক সার্কিট, যা একটি AC সোর্সকে সরাসরি (মাঝখানে DC-তে রূপান্তর ছাড়াই) একটি ভিন্ন, সাধারণত নিম্নতর ফ্রিকোয়েন্সির AC আউটপুটে রূপান্তরিত করে — এটি থাইরিস্টর ব্যবহার করে ইনপুট সাইকেলের নির্বাচিত অংশ একত্র করে আউটপুট ওয়েভফর্ম তৈরি করে।$Q2439$,
  $Q2440$🎞️ একটি পুরনো চলচ্চিত্র রিলের ফ্রেম বাছাইয়ের মতো — একটি দ্রুত রেকর্ড করা ফুটেজ (উচ্চ-ফ্রিকোয়েন্সি AC ইনপুট) থেকে নির্দিষ্ট ফ্রেম বেছে বেছে জোড়া দিয়ে একটি ধীরগতির (নিম্ন-ফ্রিকোয়েন্সি) নতুন ভিডিও তৈরি করা।$Q2440$,
  $Q2441$খুব বড়, নিম্ন-গতির AC মোটর ড্রাইভে (যেমন সিমেন্ট মিল, রোলিং মিল), যেখানে সরাসরি ফ্রিকোয়েন্সি রূপান্তর প্রয়োজন হয়, ব্যবহৃত হয়।$Q2441$,
  $Q2442$একটি বড় সিমেন্ট মিল ড্রাইভে Cycloconverter ব্যবহার করে 50Hz গ্রিড সাপ্লাই থেকে সরাসরি অনেক কম ফ্রিকোয়েন্সি (যেমন 10Hz) তৈরি করে মিলের বিশাল মোটরকে অতি ধীরগতিতে ঘোরানো হয়।$Q2442$,
  $Q2443$আউটপুট ফ্রিকোয়েন্সি সাধারণত ইনপুট ফ্রিকোয়েন্সির এক-তৃতীয়াংশের কম রাখা হয় (স্বাভাবিক Cycloconverter-এ), যাতে গ্রহণযোগ্য মানের আউটপুট ওয়েভফর্ম পাওয়া যায় (কম হারমনিক ডিসটরশন)।$Q2443$,
  $Q2444$বড় নিম্ন-গতির শিল্প মিল ড্রাইভ (সিমেন্ট, রোলিং মিল), জাহাজের প্রপালশন মোটর ড্রাইভ, এবং কিছু পুরনো ট্রেন ট্র্যাকশন সিস্টেমে ব্যবহৃত হয়।$Q2444$,
  ARRAY[$Q2445$Direct AC-AC Conversion$Q2445$,$Q2446$Low-Speed Drive$Q2446$,$Q2447$Frequency Conversion$Q2447$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2448$Firing Angle$Q2448$,
  $Q2449$F$Q2449$,
  $Q2450$powerElectronics$Q2450$,
  $Q2451$Rashid, Ch.3$Q2451$,
  $Q2452$medium$Q2452$,
  $Q2453$gauge$Q2453$,
  $Q2454$SCR ট্রিগার করার বিলম্বকৃত কোণ$Q2454$,
  $Q2455$Firing Angle (α) হলো একটি Thyristor/SCR-ভিত্তিক সার্কিটে, AC ভোল্টেজ শূন্য অতিক্রম করার (Zero Crossing) মুহূর্ত থেকে Gate ট্রিগার পালস পাঠানো পর্যন্ত বিলম্বকৃত ফেজ কোণ, যা আউটপুট DC ভোল্টেজ বা কারেন্টের গড় মান নিয়ন্ত্রণ করে।$Q2455$,
  $Q2456$🏁 একটি রেসের শুরুর 'হুইসেল বাজানো'-এর টাইমিং-এর মতো — যদি হুইসেল (ট্রিগার) দেরিতে বাজানো হয়, দৌড়বিদ (কারেন্ট) কম সময় দৌড়াবে, ফলে মোট দৌড়ের দূরত্ব (গড় ভোল্টেজ) কম হবে।$Q2456$,
  $Q2457$SCR-ভিত্তিক রেকটিফায়ার ও AC Voltage Controller-এ আউটপুট ভোল্টেজ/পাওয়ার নিয়ন্ত্রণের মূল প্যারামিটার হিসেবে ব্যবহৃত হয়।$Q2457$,
  $Q2458$একটি Controlled Rectifier-এ Firing Angle α=0° হলে সর্বোচ্চ DC আউটপুট পাওয়া যায় (সম্পূর্ণ আনকন্ট্রোলড ডায়োড রেকটিফায়ারের মতো), কিন্তু α=90° হলে আউটপুট প্রায় অর্ধেকে নেমে আসে।$Q2458$,
  $Q2459$সিঙ্গেল-ফেজ হাফ-ওয়েভ কন্ট্রোলড রেকটিফায়ারে: V_dc = (V_m/2π)(1+cosα)। α বাড়ালে V_dc কমে, α=180°-এ V_dc প্রায় শূন্যে নেমে আসে।$Q2459$,
  $Q2460$শিল্প কারখানার DC মোটর স্পিড কন্ট্রোল, HVDC কনভার্টার স্টেশন, এবং সোলার/উইন্ড পাওয়ার কনভার্টার নিয়ন্ত্রণে ব্যবহৃত হয়।$Q2460$,
  ARRAY[$Q2461$SCR Control$Q2461$,$Q2462$Phase Delay$Q2462$,$Q2463$Voltage Regulation$Q2463$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2464$Commutation$Q2464$,
  $Q2465$C$Q2465$,
  $Q2466$powerElectronics$Q2466$,
  $Q2467$Rashid, Ch.3$Q2467$,
  $Q2468$low$Q2468$,
  $Q2469$switch$Q2469$,
  $Q2470$থাইরিস্টরকে বন্ধ করার প্রক্রিয়া$Q2470$,
  $Q2471$Commutation হলো একটি পরিবাহী (conducting) Thyristor-কে বন্ধ (turn-off) করার প্রক্রিয়া, যেখানে এর কারেন্টকে Holding Current-এর নিচে নামিয়ে আনা হয় — Natural Commutation AC সাপ্লাইয়ের প্রাকৃতিক Zero Crossing ব্যবহার করে ঘটে, আর Forced Commutation বাহ্যিক সার্কিট (ক্যাপাসিটর/ইন্ডাক্টর) ব্যবহার করে কৃত্রিমভাবে কারেন্ট শূন্যে নামায়।$Q2471$,
  $Q2472$🕯️ মোমবাতি নেভানোর মতো — Natural Commutation হলো মোমবাতি নিজে থেকে জ্বলে শেষ হয়ে যাওয়া (AC নিজে থেকে শূন্যে যায়), আর Forced Commutation হলো ফুঁ দিয়ে জোর করে নেভানো (বাহ্যিক সার্কিট দিয়ে কারেন্ট জোর করে বন্ধ করা)।$Q2472$,
  $Q2473$DC সার্কিটে ব্যবহৃত Thyristor-ভিত্তিক Chopper ও Inverter ডিজাইনে অপরিহার্য, কারণ DC-তে কোনো প্রাকৃতিক Zero Crossing নেই।$Q2473$,
  $Q2474$একটি পুরনো DC Thyristor Chopper সার্কিটে যেহেতু DC কারেন্ট কখনো নিজে থেকে শূন্যে যায় না, তাই SCR বন্ধ করতে একটি অতিরিক্ত ক্যাপাসিটর-ভিত্তিক Forced Commutation সার্কিট প্রয়োজন হয়।$Q2474$,
  $Q2475$Natural Commutation AC সিস্টেমে সহজ ও সস্তা (কোনো অতিরিক্ত সার্কিট লাগে না, প্রতি অর্ধ-চক্রে স্বয়ংক্রিয়ভাবে ঘটে); Forced Commutation-এ অতিরিক্ত কম্পোনেন্ট লাগে যা সার্কিটের জটিলতা ও খরচ বাড়ায় — এই কারণেই আধুনিক ডিজাইনে IGBT/MOSFET (যেগুলো Gate দিয়েই বন্ধ করা যায়) বেশি জনপ্রিয়।$Q2475$,
  $Q2476$পুরনো DC Thyristor Drive সিস্টেম, HVDC কনভার্টার (Natural Commutation ব্যবহার করে), এবং একাডেমিক পাওয়ার ইলেকট্রনিক্স ডিজাইন কোর্সে গুরুত্বপূর্ণ ধারণা হিসেবে ব্যবহৃত হয়।$Q2476$,
  ARRAY[$Q2477$SCR Turn-off$Q2477$,$Q2478$Natural vs Forced$Q2478$,$Q2479$Thyristor Circuit$Q2479$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2480$Snubber Circuit$Q2480$,
  $Q2481$S$Q2481$,
  $Q2482$powerElectronics$Q2482$,
  $Q2483$Rashid, Ch.3$Q2483$,
  $Q2484$low$Q2484$,
  $Q2485$capacitor$Q2485$,
  $Q2486$সুইচিং ডিভাইসকে ভোল্টেজ স্পাইক থেকে রক্ষাকারী সার্কিট$Q2486$,
  $Q2487$Snubber Circuit হলো একটি রেজিস্টর-ক্যাপাসিটর (RC) বা RCD সমন্বয়, যা পাওয়ার সুইচিং ডিভাইসের (SCR, MOSFET, IGBT) সমান্তরালে স্থাপন করা হয়, যা সুইচিং-এর সময় সৃষ্ট ক্ষতিকর ভোল্টেজ স্পাইক ও উচ্চ dv/dt শোষণ করে ডিভাইসকে রক্ষা করে।$Q2487$,
  $Q2488$🛡️ একটি শক-অ্যাবজর্বারের মতো — গাড়ি হঠাৎ গর্তে পড়লে (সুইচিং-এর আকস্মিক পরিবর্তন) সরাসরি বিশাল ধাক্কা (ভোল্টেজ স্পাইক) যাত্রীদের (সুইচিং ডিভাইসের) গায়ে না লেগে শক-অ্যাবজর্বার তা শোষণ করে নেয়।$Q2488$,
  $Q2489$উচ্চ-পাওয়ার সুইচিং সার্কিট (Inverter, Chopper) ডিজাইনে ডিভাইসের নিরাপদ অপারেটিং এরিয়া (SOA) বজায় রাখতে এবং আয়ু বাড়াতে ব্যবহৃত হয়।$Q2489$,
  $Q2490$একটি মোটর কন্ট্রোলার সার্কিটে, মোটরের ইন্ডাক্টিভ লোড হঠাৎ বন্ধ করার সময় সৃষ্ট বিশাল ভোল্টেজ স্পাইক থেকে IGBT রক্ষা করতে একটি RC Snubber ব্যবহার করা হয়।$Q2490$,
  $Q2491$Snubber সাধারণত dv/dt (ভোল্টেজ পরিবর্তনের হার) সীমিত রাখে সুইচিং লস ও ইলেকট্রোম্যাগনেটিক ইন্টারফেরেন্স (EMI) কমাতে, যদিও Snubber নিজেও কিছুটা পাওয়ার লস তৈরি করে (যা ডিজাইনে ট্রেড-অফ হিসেবে বিবেচনা করা হয়)।$Q2491$,
  $Q2492$মোটর ড্রাইভ ইনভার্টার, সুইচিং পাওয়ার সাপ্লাই, ওয়েল্ডিং মেশিন কন্ট্রোলার, এবং শিল্প থাইরিস্টর ড্রাইভ সার্কিটে ব্যবহৃত হয়।$Q2492$,
  ARRAY[$Q2493$Voltage Spike Protection$Q2493$,$Q2494$dv/dt Limiting$Q2494$,$Q2495$Device Protection$Q2495$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2496$Harmonics$Q2496$,
  $Q2497$H$Q2497$,
  $Q2498$powerElectronics$Q2498$,
  $Q2499$Rashid, Ch.5$Q2499$,
  $Q2500$medium$Q2500$,
  $Q2501$wavesquare$Q2501$,
  $Q2502$মৌলিক ফ্রিকোয়েন্সির পূর্ণসংখ্যা গুণিতকে অবাঞ্ছিত সিগন্যাল$Q2502$,
  $Q2503$Harmonics হলো একটি বিকৃত (non-sinusoidal) পিরিয়ডিক ওয়েভফর্মের সেই উপাদানগুলো, যাদের ফ্রিকোয়েন্সি মৌলিক ফ্রিকোয়েন্সির (fundamental, যেমন 50Hz) পূর্ণসংখ্যা গুণিতক (100Hz, 150Hz...) — পাওয়ার ইলেকট্রনিক্স সুইচিং সার্কিট এগুলো তৈরি করে, যা গ্রিড কোয়ালিটি ও যন্ত্রপাতির ক্ষতি করতে পারে।$Q2503$,
  $Q2504$🎵 একটি বেসুরো গানের মতো — মূল সুরের (fundamental) সাথে অবাঞ্ছিত উচ্চতর সুর (harmonics) মিশে গেলে গান বিকৃত ও কর্কশ শোনায়, ঠিক তেমনি বিদ্যুৎ সিস্টেমে হারমনিক্স ভোল্টেজ/কারেন্ট ওয়েভফর্ম বিকৃত করে।$Q2504$,
  $Q2505$পাওয়ার কোয়ালিটি বিশ্লেষণ, গ্রিড-কানেক্টেড ইনভার্টার ডিজাইনে ফিল্টার প্রয়োজনীয়তা নির্ধারণ, এবং শিল্প কারখানার ইলেকট্রনিক লোড ব্যবস্থাপনায় বিবেচনা করা হয়।$Q2505$,
  $Q2506$একটি কম্পিউটার বা LED লাইট (নন-লিনিয়ার লোড) গ্রিড থেকে বিকৃত (non-sinusoidal) কারেন্ট টানে, যা 3rd, 5th, 7th হারমনিক তৈরি করে এবং ট্রান্সফরমার ও ক্যাবলে অতিরিক্ত তাপ উৎপন্ন করতে পারে।$Q2506$,
  $Q2507$Total Harmonic Distortion (THD) = √(Σ V_n²)/V₁ × 100% (n≥2, V₁=মৌলিক উপাদান)। উচ্চ THD মানে বেশি বিকৃতি, যা পাওয়ার ফ্যাক্টর কমায় ও যন্ত্রপাতিতে অতিরিক্ত তাপ তৈরি করে।$Q2507$,
  $Q2508$পাওয়ার কোয়ালিটি অ্যানালাইজার, শিল্প কারখানার হারমনিক ফিল্টার ডিজাইন, এবং গ্রিড-টাই সোলার ইনভার্টার সার্টিফিকেশন স্ট্যান্ডার্ডে (IEEE 519) ব্যবহৃত হয়।$Q2508$,
  ARRAY[$Q2509$Power Quality$Q2509$,$Q2510$THD$Q2510$,$Q2511$Non-Linear Load$Q2511$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2512$Freewheeling Diode$Q2512$,
  $Q2513$F$Q2513$,
  $Q2514$powerElectronics$Q2514$,
  $Q2515$Rashid, Ch.5$Q2515$,
  $Q2516$medium$Q2516$,
  $Q2517$diode$Q2517$,
  $Q2518$ইন্ডাক্টিভ কারেন্টের জন্য বিকল্প পথ তৈরিকারী ডায়োড$Q2518$,
  $Q2519$Freewheeling Diode (Flyback Diode) একটি ডায়োড, যা একটি ইন্ডাক্টিভ লোডের (মোটর, রিলে কয়েল) সমান্তরালে বিপরীতমুখী সংযুক্ত করা হয়, যাতে সুইচ 'অফ' হওয়ার মুহূর্তে ইন্ডাক্টরে সঞ্চিত শক্তির কারেন্ট নিরাপদে প্রবাহিত হওয়ার একটি বিকল্প পথ পায়, ফলে ক্ষতিকর ভোল্টেজ স্পাইক তৈরি হয় না।$Q2519$,
  $Q2520$🚪 জরুরি নির্গমন পথের মতো — যখন প্রধান দরজা (সুইচ) হঠাৎ বন্ধ হয়ে যায়, ভেতরে থাকা মানুষদের (ইন্ডাক্টর কারেন্ট) বের হওয়ার জন্য একটি বিকল্প জরুরি পথ (Freewheeling Diode) থাকে, যাতে দরজায় ধাক্কাধাক্কি করে (ভোল্টেজ স্পাইক) ভাঙচুর না হয়।$Q2520$,
  $Q2521$রিলে ড্রাইভার সার্কিট, DC মোটর কন্ট্রোলার, এবং Chopper/Buck Converter-এ ইন্ডাক্টরের কারেন্ট কন্টিনিউটি বজায় রাখতে ব্যবহৃত হয়।$Q2521$,
  $Q2522$একটি মাইক্রোকন্ট্রোলার দিয়ে একটি রিলে চালানোর সময়, রিলে কয়েলের সমান্তরালে একটি Freewheeling Diode বসানো হয়, যাতে রিলে বন্ধ করার মুহূর্তে সৃষ্ট ভোল্টেজ স্পাইক মাইক্রোকন্ট্রোলারের ট্রানজিস্টর নষ্ট না করে।$Q2522$,
  $Q2523$সুইচ 'অন' অবস্থায় ডায়োড রিভার্স বায়াসে থাকে (কোনো প্রভাব নেই); সুইচ 'অফ' হওয়ার সাথে সাথে ইন্ডাক্টর কারেন্ট বজায় রাখার চেষ্টা করে (Lenz's Law), তখন ডায়োড ফরওয়ার্ড বায়াসড হয়ে সেই কারেন্টের জন্য একটি নিরাপদ লুপ তৈরি করে (i_L ধীরে ধীরে ক্ষয় হয়)।$Q2523$,
  $Q2524$রিলে ও সোলেনয়েড ড্রাইভার সার্কিট, DC মোটর H-Bridge কন্ট্রোলার, এবং Buck/Boost Converter-এর মৌলিক উপাদান হিসেবে ব্যবহৃত হয়।$Q2524$,
  ARRAY[$Q2525$Inductive Kickback Protection$Q2525$,$Q2526$Flyback Diode$Q2526$,$Q2527$Motor Drive$Q2527$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2528$Soft Starter$Q2528$,
  $Q2529$S$Q2529$,
  $Q2530$powerElectronics$Q2530$,
  $Q2531$Rashid, Ch.4$Q2531$,
  $Q2532$low$Q2532$,
  $Q2533$switch$Q2533$,
  $Q2534$ধীরে ভোল্টেজ বাড়িয়ে মোটর চালু করার যন্ত্র$Q2534$,
  $Q2535$Soft Starter একটি পাওয়ার ইলেকট্রনিক যন্ত্র (সাধারণত SCR/TRIAC-ভিত্তিক), যা AC মোটরে ধীরে ধীরে ভোল্টেজ বাড়িয়ে (Firing Angle নিয়ন্ত্রণ করে) সরবরাহ করে, ফলে মোটরের স্টার্টিং কারেন্ট ও যান্ত্রিক ঝাঁকুনি উল্লেখযোগ্যভাবে কমে যায় — এটি Star-Delta বা DOL Starter-এর একটি আধুনিক ইলেকট্রনিক বিকল্প।$Q2535$,
  $Q2536$🚗 গাড়ির ধীরে গ্যাস দেওয়ার মতো — হঠাৎ পুরো গ্যাস (পূর্ণ ভোল্টেজ) না দিয়ে ধীরে ধীরে গ্যাস বাড়ানো হয়, যাতে ইঞ্জিন (মোটর) ও ড্রাইভট্রেন (যান্ত্রিক লোড) ঝাঁকুনি ছাড়াই মসৃণভাবে গতি পায়।$Q2536$,
  $Q2537$বড় পাম্প, কনভেয়র বেল্ট, ও কম্প্রেসর মোটর চালু করতে, যেখানে যান্ত্রিক ঝাঁকুনি বা বিশাল স্টার্টিং কারেন্ট এড়ানো প্রয়োজন।$Q2537$,
  $Q2538$একটি পানি সরবরাহ পাম্পিং স্টেশনে Soft Starter ব্যবহার করে বড় মোটর চালু করা হয়, যা হঠাৎ পানির চাপ বেড়ে পাইপ ফেটে যাওয়ার (Water Hammer) ঝুঁকি কমায় এবং গ্রিডে ভোল্টেজ ডিপ প্রতিরোধ করে।$Q2538$,
  $Q2539$Soft Starter Firing Angle ধীরে ধীরে α=180° (প্রায় শূন্য ভোল্টেজ) থেকে α=0° (পূর্ণ ভোল্টেজ) পর্যন্ত কমিয়ে আনে একটি নির্ধারিত সময়ে (Ramp-up Time), যা স্টার্টিং কারেন্টকে DOL-এর 6-8× থেকে কমিয়ে মাত্র 2-4×-এ নামিয়ে আনে।$Q2539$,
  $Q2540$শিল্প কারখানার বড় পাম্প ও কম্প্রেসর, কনভেয়র বেল্ট সিস্টেম, এবং এসকেলেটর ও লিফট মোটর স্টার্টিং-এ ব্যবহৃত হয়।$Q2540$,
  ARRAY[$Q2541$Motor Starting$Q2541$,$Q2542$Inrush Current Reduction$Q2542$,$Q2543$SCR-based$Q2543$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2544$UPS (Uninterruptible Power Supply)$Q2544$,
  $Q2545$U$Q2545$,
  $Q2546$powerElectronics$Q2546$,
  $Q2547$Rashid, Ch.6$Q2547$,
  $Q2548$medium$Q2548$,
  $Q2549$battery$Q2549$,
  $Q2550$বিদ্যুৎ বিভ্রাটে তাৎক্ষণিক ব্যাকআপ পাওয়ার সরবরাহকারী যন্ত্র$Q2550$,
  $Q2551$UPS (Uninterruptible Power Supply) একটি যন্ত্র, যা মেইন বিদ্যুৎ সরবরাহ হঠাৎ বন্ধ হয়ে গেলে অভ্যন্তরীণ ব্যাটারি ও ইনভার্টার ব্যবহার করে তাৎক্ষণিকভাবে (মিলিসেকেন্ডের মধ্যে) সংযুক্ত ডিভাইসে বিদ্যুতের সরবরাহ অব্যাহত রাখে, যাতে কম্পিউটার বা সংবেদনশীল যন্ত্রপাতি হঠাৎ বন্ধ হয়ে ডেটা হারানো বা ক্ষতিগ্রস্ত না হয়।$Q2551$,
  $Q2552$🪂 একটি জরুরি প্যারাসুটের মতো — প্রধান ইঞ্জিন (মেইন বিদ্যুৎ) হঠাৎ বিকল হয়ে গেলেও, প্যারাসুট (ব্যাটারি ব্যাকআপ) সাথে সাথে খুলে গিয়ে নিরাপদে অবতরণ (মসৃণ পাওয়ার সরবরাহ) নিশ্চিত করে, বিমান হঠাৎ পড়ে যায় না (সিস্টেম ক্র্যাশ করে না)।$Q2552$,
  $Q2553$কম্পিউটার ও সার্ভার রুম, হাসপাতালের গুরুত্বপূর্ণ মেডিকেল যন্ত্রপাতি, এবং ডেটা সেন্টারে বিদ্যুৎ বিভ্রাটের সময় ডেটা লস ও যন্ত্রপাতি ক্ষতি প্রতিরোধে ব্যবহৃত হয়।$Q2553$,
  $Q2554$বাংলাদেশে ঘন ঘন লোডশেডিং বা ভোল্টেজ ফ্লাকচুয়েশনের কারণে বাসাবাড়ি ও অফিসে কম্পিউটারের সাথে UPS ব্যবহার করা হয়, যা বিদ্যুৎ চলে গেলে কয়েক মিনিট পর্যন্ত ব্যাকআপ পাওয়ার দিয়ে কাজ সংরক্ষণের সময় দেয়।$Q2554$,
  $Q2555$Online UPS-এ সবসময় ইনভার্টার সক্রিয় থাকে (কোনো সুইচিং সময় লাগে না, বিশুদ্ধ সাইন ওয়েভ), Offline/Standby UPS-এ মেইন বিদ্যুৎ বন্ধ হলে সুইচিং টাইম (কয়েক মিলিসেকেন্ড) লাগে ব্যাটারি মোডে যেতে — Online UPS বেশি নির্ভরযোগ্য কিন্তু বেশি ব্যয়বহুল।$Q2555$,
  $Q2556$ডেটা সেন্টার ও সার্ভার রুম, হাসপাতালের ICU ও অপারেশন থিয়েটার, ব্যাংকিং ও টেলিকম ইনফ্রাস্ট্রাকচার, এবং বাসাবাড়ির কম্পিউটার ব্যাকআপে ব্যবহৃত হয়।$Q2556$,
  ARRAY[$Q2557$Backup Power$Q2557$,$Q2558$Battery Inverter$Q2558$,$Q2559$Power Continuity$Q2559$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2560$Signal (Continuous vs Discrete)$Q2560$,
  $Q2561$S$Q2561$,
  $Q2562$signals$Q2562$,
  $Q2563$Oppenheim, Ch.1$Q2563$,
  $Q2564$critical$Q2564$,
  $Q2565$waveform$Q2565$,
  $Q2566$সময়ের সাথে তথ্য বহনকারী রাশি$Q2566$,
  $Q2567$Signal হলো একটি রাশি (যেমন ভোল্টেজ, তাপমাত্রা) যা সময়ের (বা অন্য কোনো স্বাধীন ভেরিয়েবলের) সাথে পরিবর্তিত হয়ে তথ্য বহন করে — Continuous-Time Signal প্রতিটি মুহূর্তে সংজ্ঞায়িত (যেমন অ্যানালগ ভয়েস), আর Discrete-Time Signal শুধুমাত্র নির্দিষ্ট সময়ে (স্যাম্পলে) সংজ্ঞায়িত (যেমন ডিজিটাল অডিও)।$Q2567$,
  $Q2568$🎬 চলচ্চিত্র বনাম ফ্লিপবুকের মতো — Continuous Signal হলো বাস্তব জীবনের নিরবচ্ছিন্ন গতি (প্রতিটি মুহূর্তে চলমান), আর Discrete Signal হলো ফ্লিপবুকের আলাদা আলাদা পৃষ্ঠা (নির্দিষ্ট মুহূর্তের স্ন্যাপশট), যা দ্রুত উল্টালে ধারাবাহিক মনে হয়।$Q2568$,
  $Q2569$যেকোনো ইলেকট্রনিক যোগাযোগ ও প্রসেসিং সিস্টেমের ভিত্তি — অডিও, ভিডিও, সেন্সর ডেটা সবই সিগন্যাল হিসেবে বিশ্লেষণ করা হয়।$Q2569$,
  $Q2570$একটি মাইক্রোফোনের আউটপুট একটি Continuous-Time Signal (অ্যানালগ ভোল্টেজ), যা ADC দিয়ে স্যাম্পল করলে একটি Discrete-Time Signal-এ (সংখ্যার সিরিজ) পরিণত হয়, যা কম্পিউটার প্রসেস করতে পারে।$Q2570$,
  $Q2571$Continuous Signal x(t) সময়ের একটি ফাংশন (t যেকোনো real number)। Discrete Signal x[n] শুধু ইন্টিজার n-এ সংজ্ঞায়িত, যা Sampling-এর মাধ্যমে x(nT) থেকে পাওয়া যায় (T = স্যাম্পলিং পিরিয়ড)।$Q2571$,
  $Q2572$অডিও ও ভিডিও প্রসেসিং, বায়োমেডিকেল সিগন্যাল (ECG, EEG) বিশ্লেষণ, এবং সব ধরনের ডিজিটাল সিগন্যাল প্রসেসিং (DSP) সিস্টেমে মৌলিক ভিত্তি হিসেবে ব্যবহৃত হয়।$Q2572$,
  ARRAY[$Q2573$Signal Classification$Q2573$,$Q2574$Analog-Digital$Q2574$,$Q2575$DSP Basics$Q2575$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2576$System (LTI System)$Q2576$,
  $Q2577$S$Q2577$,
  $Q2578$signals$Q2578$,
  $Q2579$Oppenheim, Ch.1$Q2579$,
  $Q2580$critical$Q2580$,
  $Q2581$blockdiagram$Q2581$,
  $Q2582$সিগন্যালকে অন্য সিগন্যালে রূপান্তরকারী প্রক্রিয়া$Q2582$,
  $Q2583$System হলো একটি প্রক্রিয়া বা যন্ত্র যা একটি ইনপুট সিগন্যালকে একটি আউটপুট সিগন্যালে রূপান্তরিত করে। LTI (Linear Time-Invariant) System দুটি গুরুত্বপূর্ণ বৈশিষ্ট্য পূরণ করে — Linearity (সুপারপজিশন নীতি মেনে চলে) এবং Time-Invariance (সিস্টেমের আচরণ সময়ের সাথে পরিবর্তিত হয় না)।$Q2583$,
  $Q2584$🏭 একটি ধারাবাহিক কারখানার মতো — একই কাঁচামাল (ইনপুট) দিয়ে সবসময় একই প্রক্রিয়ায় (LTI) একই পণ্য (আউটপুট) তৈরি হয়, আজ বানালেও একই ফল, কাল বানালেও একই ফল (Time-Invariant), এবং দুইগুণ কাঁচামাল দিলে দ্বিগুণ পণ্য পাওয়া যায় (Linear)।$Q2584$,
  $Q2585$সিগন্যাল প্রসেসিং সিস্টেম (ফিল্টার, অ্যামপ্লিফায়ার) বিশ্লেষণ ও ডিজাইনের সরলীকরণে ব্যবহৃত হয়, কারণ LTI সিস্টেম শুধু একটি Impulse Response দিয়ে সম্পূর্ণভাবে বর্ণনা করা যায়।$Q2585$,
  $Q2586$একটি অডিও অ্যামপ্লিফায়ার একটি LTI সিস্টেম, কারণ এটি ইনপুট সিগন্যালকে সমানুপাতিক হারে বড় করে (Linear) এবং সকাল-বিকাল একইভাবে কাজ করে (Time-Invariant)।$Q2586$,
  $Q2587$Linearity: T[a·x₁(t)+b·x₂(t)] = a·T[x₁(t)]+b·T[x₂(t)]। Time-Invariance: যদি x(t)→y(t) হয়, তাহলে x(t−t₀)→y(t−t₀) হবে। LTI সিস্টেমের আউটপুট = ইনপুট ও Impulse Response-এর Convolution।$Q2587$,
  $Q2588$অডিও ও ভিডিও প্রসেসিং ফিল্টার, কমিউনিকেশন চ্যানেল মডেলিং, এবং কন্ট্রোল সিস্টেম ও সার্কিট বিশ্লেষণের তাত্ত্বিক ভিত্তি হিসেবে ব্যবহৃত হয়।$Q2588$,
  ARRAY[$Q2589$Linear Time-Invariant$Q2589$,$Q2590$System Theory$Q2590$,$Q2591$Signal Processing$Q2591$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2592$Convolution$Q2592$,
  $Q2593$C$Q2593$,
  $Q2594$signals$Q2594$,
  $Q2595$Oppenheim, Ch.2$Q2595$,
  $Q2596$critical$Q2596$,
  $Q2597$formula$Q2597$,
  $Q2598$সিস্টেমের ইনপুট ও ইমপালস রেসপন্স একত্রকারী গাণিতিক প্রক্রিয়া$Q2598$,
  $Q2599$Convolution একটি গাণিতিক অপারেশন, যা একটি LTI সিস্টেমের ইনপুট সিগন্যাল এবং সিস্টেমের Impulse Response একত্রিত করে আউটপুট সিগন্যাল বের করে — এটি সিগন্যাল প্রসেসিং-এর সবচেয়ে গুরুত্বপূর্ণ গাণিতিক অপারেশনগুলোর একটি।$Q2599$,
  $Q2600$🔊 একটি হলঘরের ইকো-র মতো — মূল শব্দ (ইনপুট) হলঘরের বিভিন্ন দেয়ালে প্রতিফলিত হয়ে (Impulse Response) বিভিন্ন বিলম্ব ও তীব্রতায় ফিরে আসে, সব প্রতিফলনের যোগফলই প্রকৃত শোনা শব্দ (আউটপুট) — এটাই Convolution-এর ভৌত অর্থ।$Q2600$,
  $Q2601$অডিও ইফেক্ট প্রসেসিং (রিভার্ব সিমুলেশন), ইমেজ প্রসেসিং (ব্লার/শার্পেন ফিল্টার), এবং যেকোনো LTI সিস্টেমের আউটপুট গণনায় ব্যবহৃত হয়।$Q2601$,
  $Q2602$স্টুডিও রেকর্ডিং সফটওয়্যারে একটি ভয়েস ট্র্যাককে একটি ক্যাথিড্রালের Impulse Response দিয়ে Convolve করলে, ভয়েসটি যেন ক্যাথিড্রালের ভেতরে রেকর্ড করা হয়েছে এমন প্রাকৃতিক প্রতিধ্বনি যুক্ত হয়।$Q2602$,
  $Q2603$Continuous: y(t) = x(t)*h(t) = ∫x(τ)h(t−τ)dτ। Discrete: y[n] = x[n]*h[n] = Σx[k]h[n−k]। Convolution-এর ক্রম পরিবর্তনযোগ্য (Commutative): x*h = h*x।$Q2603$,
  $Q2604$অডিও রিভার্ব ও ইকো ইফেক্ট, ইমেজ প্রসেসিং ফিল্টার (Photoshop-এর Blur/Sharpen), এবং ডিপ লার্নিং-এ Convolutional Neural Network (CNN)-এর মূল অপারেশন হিসেবে ব্যবহৃত হয়।$Q2604$,
  ARRAY[$Q2605$Mathematical Operation$Q2605$,$Q2606$Impulse Response$Q2606$,$Q2607$System Output$Q2607$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2608$Fourier Series$Q2608$,
  $Q2609$F$Q2609$,
  $Q2610$signals$Q2610$,
  $Q2611$Oppenheim, Ch.3$Q2611$,
  $Q2612$critical$Q2612$,
  $Q2613$wavesine$Q2613$,
  $Q2614$পিরিয়ডিক সিগন্যালকে সাইন-কোসাইনের যোগফলে প্রকাশ$Q2614$,
  $Q2615$Fourier Series একটি গাণিতিক পদ্ধতি, যা যেকোনো পিরিয়ডিক (periodic) সিগন্যালকে বিভিন্ন ফ্রিকোয়েন্সির (মৌলিক ফ্রিকোয়েন্সি ও তার হারমনিক্স) সাইন ও কোসাইন তরঙ্গের যোগফল হিসেবে প্রকাশ করে — এটি Time Domain থেকে Frequency Domain-এ যাওয়ার প্রথম গুরুত্বপূর্ণ সেতু।$Q2615$,
  $Q2616$🎨 রঙের প্রিজমের মতো — একটি সাদা আলো (জটিল পিরিয়ডিক সিগন্যাল) প্রিজম দিয়ে গেলে তার মৌলিক রঙের উপাদানে (বিভিন্ন ফ্রিকোয়েন্সির সাইন ওয়েভে) ভেঙে যায় — Fourier Series ঠিক এই কাজটাই সিগন্যালের জন্য করে।$Q2616$,
  $Q2617$যেকোনো পিরিয়ডিক সিগন্যালের (যেমন স্কয়ার ওয়েভ, স্যতুথ ওয়েভ) ফ্রিকোয়েন্সি কম্পোজিশন বিশ্লেষণ, এবং অডিও সিন্থেসাইজার ডিজাইনে ব্যবহৃত হয়।$Q2617$,
  $Q2618$একটি স্কয়ার ওয়েভকে Fourier Series দিয়ে বিশ্লেষণ করলে দেখা যায় এটি মৌলিক ফ্রিকোয়েন্সি ও তার বিজোড় হারমনিক্স (3rd, 5th, 7th...) সমন্বয়ে গঠিত, যা সঙ্গীত সিন্থেসাইজারে বিভিন্ন যন্ত্রের শব্দ অনুকরণে ব্যবহৃত হয়।$Q2618$,
  $Q2619$x(t) = a₀ + Σ[aₙcos(nω₀t) + bₙsin(nω₀t)], যেখানে ω₀ = মৌলিক ফ্রিকোয়েন্সি (2π/T)। শুধুমাত্র পিরিয়ডিক সিগন্যালের জন্য প্রযোজ্য; নন-পিরিয়ডিক সিগন্যালের জন্য Fourier Transform ব্যবহার করা হয়।$Q2619$,
  $Q2620$অডিও সিন্থেসাইজার ও ইকুয়ালাইজার ডিজাইন, ইলেকট্রিক পাওয়ার সিস্টেমে হারমনিক বিশ্লেষণ, এবং ইমেজ কমপ্রেশন (JPEG-এ ব্যবহৃত DCT-এর সম্পর্কিত ধারণা) এ ব্যবহৃত হয়।$Q2620$,
  ARRAY[$Q2621$Periodic Signal Analysis$Q2621$,$Q2622$Harmonics$Q2622$,$Q2623$Frequency Domain$Q2623$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2624$Fourier Transform$Q2624$,
  $Q2625$F$Q2625$,
  $Q2626$signals$Q2626$,
  $Q2627$Oppenheim, Ch.4$Q2627$,
  $Q2628$critical$Q2628$,
  $Q2629$wavesine$Q2629$,
  $Q2630$যেকোনো সিগন্যালকে ফ্রিকোয়েন্সি ডোমেইনে রূপান্তর$Q2630$,
  $Q2631$Fourier Transform একটি গাণিতিক টুল, যা যেকোনো (পিরিয়ডিক বা নন-পিরিয়ডিক) সিগন্যালকে Time Domain থেকে Frequency Domain-এ রূপান্তরিত করে, দেখায় সিগন্যালে কোন কোন ফ্রিকোয়েন্সি কতটা শক্তিশালীভাবে উপস্থিত — এটি Fourier Series-এর সাধারণীকৃত (generalized) রূপ।$Q2631$,
  $Q2632$🍹 একটি ফলের জুসের স্বাদ বিশ্লেষণের মতো — একটি মিশ্র জুস (সিগন্যাল) খেয়ে বলা যায় এতে আম কতটুকু, কমলা কতটুকু, আনারস কতটুকু (কোন ফ্রিকোয়েন্সি কতটা শক্তিশালী) — Fourier Transform সিগন্যালের 'উপাদান' গুলো আলাদা করে দেখায়।$Q2632$,
  $Q2633$সিগন্যাল প্রসেসিং, ইমেজ প্রসেসিং, এবং যোগাযোগ ব্যবস্থায় সিগন্যালের ব্যান্ডউইথ ও ফ্রিকোয়েন্সি বিশ্লেষণে ব্যাপকভাবে ব্যবহৃত হয়।$Q2633$,
  $Q2634$একটি গানের অডিও ফাইলে Fourier Transform প্রয়োগ করলে দেখা যায় বেস (কম ফ্রিকোয়েন্সি) ও ট্রেবল (উচ্চ ফ্রিকোয়েন্সি) কতটা শক্তিশালী, যা ইকুয়ালাইজার সফটওয়্যারে ভিজ্যুয়ালাইজেশন হিসেবে দেখানো হয়।$Q2634$,
  $Q2635$X(f) = ∫x(t)e^(−j2πft)dt (Time Domain থেকে Frequency Domain)। FFT (Fast Fourier Transform) হলো এর একটি অতি দ্রুত কম্পিউটেশনাল অ্যালগরিদম, যা O(N log N) সময়ে গণনা করে (সরাসরি গণনার O(N²)-এর তুলনায় অনেক দ্রুত)।$Q2635$,
  $Q2636$অডিও ইকুয়ালাইজার ও স্পেকট্রাম অ্যানালাইজার, JPEG/MP3 কমপ্রেশন, মেডিকেল ইমেজিং (MRI স্পেকট্রাল বিশ্লেষণ), এবং WiFi/মোবাইল যোগাযোগে OFDM মডুলেশনে ব্যবহৃত হয়।$Q2636$,
  ARRAY[$Q2637$Frequency Analysis$Q2637$,$Q2638$FFT$Q2638$,$Q2639$Spectral Analysis$Q2639$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2640$Laplace Transform$Q2640$,
  $Q2641$L$Q2641$,
  $Q2642$signals$Q2642$,
  $Q2643$Oppenheim, Ch.9$Q2643$,
  $Q2644$critical$Q2644$,
  $Q2645$formula$Q2645$,
  $Q2646$ডিফারেনশিয়াল সমীকরণকে বীজগণিতে রূপান্তরকারী টুল$Q2646$,
  $Q2647$Laplace Transform একটি গাণিতিক টুল, যা একটি সময়-ডোমেইন ফাংশনকে একটি জটিল-ফ্রিকোয়েন্সি ডোমেইন (s-ডোমেইন) ফাংশনে রূপান্তরিত করে, যার ফলে জটিল ডিফারেনশিয়াল সমীকরণ সহজ বীজগাণিতিক সমীকরণে পরিণত হয়ে যায় — এটি সার্কিট ও কন্ট্রোল সিস্টেম বিশ্লেষণে ব্যাপকভাবে ব্যবহৃত হয়।$Q2647$,
  $Q2648$🌐 একটি সহজ ভাষায় অনুবাদের মতো — জটিল ডিফারেনশিয়াল ক্যালকুলাসের 'ভাষায়' (Time Domain) সমস্যা সমাধান করা কঠিন, তাই তাকে সহজ বীজগণিতের 'ভাষায়' (s-Domain) অনুবাদ করে সমাধান করা হয়, তারপর আবার মূল ভাষায় ফিরিয়ে আনা হয়।$Q2648$,
  $Q2649$সার্কিট ট্রানজিয়েন্ট বিশ্লেষণ (RLC সার্কিট), কন্ট্রোল সিস্টেম ডিজাইন, এবং জটিল ডিফারেনশিয়াল সমীকরণ সমাধানে ব্যাপকভাবে ব্যবহৃত হয়।$Q2649$,
  $Q2650$একটি RLC সার্কিটের ডিফারেনশিয়াল সমীকরণকে Laplace Transform দিয়ে s-ডোমেইনে রূপান্তর করলে সহজ বীজগাণিতিক সমীকরণ পাওয়া যায়, যা সমাধান করে Inverse Laplace Transform দিয়ে আবার সময়-ডোমেইনে ফিরিয়ে আনা হয়।$Q2650$,
  $Q2651$X(s) = ∫x(t)e^(−st)dt (t=0 থেকে ∞)। Differentiation Property: L{dx/dt} = sX(s)−x(0), যা ডিফারেনশিয়াল সমীকরণকে বীজগণিতে রূপান্তরের মূল কারণ। Laplace Transform Fourier Transform-এর একটি সাধারণীকৃত রূপ (s=jω হলে সমতুল্য)।$Q2651$,
  $Q2652$কন্ট্রোল সিস্টেম ট্রান্সফার ফাংশন বিশ্লেষণ, ইলেকট্রিক্যাল সার্কিট ট্রানজিয়েন্ট রেসপন্স গণনা, এবং মেকানিক্যাল সিস্টেম (স্প্রিং-ড্যাম্পার) মডেলিং-এ ব্যবহৃত হয়।$Q2652$,
  ARRAY[$Q2653$s-Domain$Q2653$,$Q2654$Differential Equation$Q2654$,$Q2655$Circuit Analysis$Q2655$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2656$Z-Transform$Q2656$,
  $Q2657$Z$Q2657$,
  $Q2658$signals$Q2658$,
  $Q2659$Oppenheim, Ch.10$Q2659$,
  $Q2660$high$Q2660$,
  $Q2661$formula$Q2661$,
  $Q2662$ডিসক্রিট সিগন্যালের জন্য Laplace Transform-এর সমতুল্য$Q2662$,
  $Q2663$Z-Transform একটি গাণিতিক টুল, যা একটি ডিসক্রিট-টাইম সিগন্যালকে জটিল ফ্রিকোয়েন্সি ডোমেইনে (z-ডোমেইন) রূপান্তরিত করে — এটি ডিসক্রিট সিস্টেমের জন্য Laplace Transform-এর সমতুল্য, এবং ডিজিটাল ফিল্টার ডিজাইন ও বিশ্লেষণে মৌলিক টুল।$Q2663$,
  $Q2664$🎞️ Laplace Transform-এর ডিজিটাল সংস্করণের মতো — Laplace Transform যেমন Continuous সিগন্যালের জন্য কাজ করে, Z-Transform ঠিক সেই একই ধারণা, কিন্তু ডিসক্রিট (স্যাম্পল করা) সিগন্যালের জন্য প্রযোজ্য।$Q2664$,
  $Q2665$ডিজিটাল ফিল্টার (FIR/IIR) ডিজাইন, ডিসক্রিট সিস্টেমের স্থিতিশীলতা বিশ্লেষণ, এবং ডিজিটাল কন্ট্রোল সিস্টেম ডিজাইনে ব্যবহৃত হয়।$Q2665$,
  $Q2666$একটি ডিজিটাল অডিও ইকুয়ালাইজার সফটওয়্যারে ফিল্টার ডিজাইন করার সময় Z-Transform ব্যবহার করে ফিল্টারের ট্রান্সফার ফাংশন H(z) নির্ধারণ করা হয়, যা তারপর কোডে বাস্তবায়ন করা যায়।$Q2666$,
  $Q2667$X(z) = Σx[n]z^(−n) (n = −∞ থেকে ∞)। ডিসক্রিট সিস্টেমের স্থিতিশীলতার শর্ত: সব Pole unit circle-এর ভেতরে (|z|<1) থাকতে হবে — এটি Laplace-এর Left Half Plane-এর সমতুল্য।$Q2667$,
  $Q2668$ডিজিটাল অডিও ও ইমেজ ফিল্টার ডিজাইন, ডিজিটাল কন্ট্রোল সিস্টেম (মাইক্রোকন্ট্রোলার-ভিত্তিক), এবং স্পিচ প্রসেসিং সফটওয়্যারে ব্যবহৃত হয়।$Q2668$,
  ARRAY[$Q2669$Discrete System$Q2669$,$Q2670$Digital Filter$Q2670$,$Q2671$z-Domain$Q2671$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2672$Impulse Response$Q2672$,
  $Q2673$I$Q2673$,
  $Q2674$signals$Q2674$,
  $Q2675$Oppenheim, Ch.2$Q2675$,
  $Q2676$high$Q2676$,
  $Q2677$waveform$Q2677$,
  $Q2678$ইউনিট ইমপালস ইনপুটে সিস্টেমের আউটপুট$Q2678$,
  $Q2679$Impulse Response h(t) হলো একটি LTI সিস্টেমের আউটপুট, যখন ইনপুট হিসেবে একটি আদর্শ ইউনিট ইমপালস ফাংশন δ(t) প্রয়োগ করা হয় — এটি একটি LTI সিস্টেমের সম্পূর্ণ আচরণকে একটি একক ফাংশনে সংক্ষিপ্ত করে, যা দিয়ে যেকোনো ইনপুটের জন্য আউটপুট (Convolution-এর মাধ্যমে) গণনা করা যায়।$Q2679$,
  $Q2680$🔔 একটি ঘণ্টায় একবার হাতুড়ি মারার মতো — এই একক আঘাতে (ইমপালস) ঘণ্টা যেভাবে বাজে ও ধীরে ধীরে থেমে যায় (Impulse Response), তা থেকেই ঘণ্টাটির সব ধ্বনিতাত্ত্বিক বৈশিষ্ট্য (সিস্টেমের সম্পূর্ণ আচরণ) বোঝা যায়।$Q2680$,
  $Q2681$অডিও রুম অ্যাকুস্টিক পরিমাপ, স্পিকার/মাইক্রোফোন ক্যারেক্টারাইজেশন, এবং যেকোনো LTI সিস্টেমের সম্পূর্ণ বৈশিষ্ট্য একক পরীক্ষায় নির্ণয়ে ব্যবহৃত হয়।$Q2681$,
  $Q2682$একটি কনসার্ট হলের Impulse Response রেকর্ড করতে একটি বেলুন ফাটানো (কাছাকাছি একটি ইমপালস) হয়, রেকর্ড করা প্রতিধ্বনি থেকে হলের acoustic বৈশিষ্ট্য সম্পূর্ণরূপে ক্যাপচার করা যায়, যা পরে যেকোনো অডিওতে virtually প্রয়োগ করা যায়।$Q2682$,
  $Q2683$যেকোনো ইনপুট x(t)-এর জন্য আউটপুট y(t) = x(t)*h(t) (Convolution)। Frequency Domain-এ Impulse Response-এর Fourier Transform H(f) সিস্টেমের Frequency Response দেয়, যা ফিল্টার ডিজাইনে সরাসরি ব্যবহৃত হয়।$Q2683$,
  $Q2684$অডিও রিভার্ব ইফেক্ট প্লাগইন, স্পিকার ও রুম acoustic ক্যালিব্রেশন, এবং ফিল্টার ডিজাইন বৈশিষ্ট্য যাচাইয়ে ব্যবহৃত হয়।$Q2684$,
  ARRAY[$Q2685$LTI Characterization$Q2685$,$Q2686$Unit Impulse$Q2686$,$Q2687$System Identification$Q2687$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2688$Aliasing$Q2688$,
  $Q2689$A$Q2689$,
  $Q2690$signals$Q2690$,
  $Q2691$Oppenheim, Ch.7$Q2691$,
  $Q2692$high$Q2692$,
  $Q2693$waveform$Q2693$,
  $Q2694$অপর্যাপ্ত স্যাম্পলিং-এর ফলে সিগন্যালের ভুল প্রতিনিধিত্ব$Q2694$,
  $Q2695$Aliasing হলো একটি ত্রুটি, যা ঘটে যখন একটি সিগন্যালকে Nyquist Rate-এর চেয়ে কম হারে স্যাম্পল করা হয় — এর ফলে উচ্চ-ফ্রিকোয়েন্সি উপাদান একটি ভিন্ন, নিম্ন (ভুয়া) ফ্রিকোয়েন্সি হিসেবে প্রতীয়মান হয়, যা মূল সিগন্যাল থেকে অপরিবর্তনীয়ভাবে বিকৃত হয়ে যায়।$Q2695$,
  $Q2696$🎡 চলন্ত গাড়ির চাকার ভিডিওতে উল্টো ঘোরার ভ্রমের মতো — যখন ক্যামেরার ফ্রেম রেট (স্যাম্পলিং রেট) চাকার ঘূর্ণন গতির (সিগন্যাল ফ্রিকোয়েন্সি) তুলনায় যথেষ্ট দ্রুত না হয়, তখন চাকা ভিডিওতে ভুল দিকে বা ভুল গতিতে ঘুরছে বলে মনে হয়।$Q2696$,
  $Q2697$ADC ডিজাইনে অ্যান্টি-অ্যালায়াসিং ফিল্টারের প্রয়োজনীয়তা নির্ধারণ, এবং ডিজিটাল অডিও/ভিডিও সিস্টেম ডিজাইনে বিবেচনা করা হয়।$Q2697$,
  $Q2698$যদি একটি অডিও রেকর্ডার 8kHz স্যাম্পলিং রেট ব্যবহার করে কিন্তু ইনপুটে 6kHz-এর একটি টোন থাকে (Nyquist Rate 4kHz-এর বেশি), তাহলে রেকর্ডিং-এ সেই টোন ভুলভাবে একটি ভিন্ন, নিম্নতর ফ্রিকোয়েন্সি হিসেবে শোনা যাবে।$Q2698$,
  $Q2699$Aliasing ঘটে যখন f_signal > f_s/2 (f_s = স্যাম্পলিং ফ্রিকোয়েন্সি)। প্রতিরোধের জন্য স্যাম্পলিং-এর আগে একটি Anti-Aliasing Low-Pass Filter ব্যবহার করে f_s/2-এর ওপরের সব ফ্রিকোয়েন্সি বাদ দেওয়া হয়।$Q2699$,
  $Q2700$ADC সার্কিট ডিজাইনে অ্যান্টি-অ্যালায়াসিং ফিল্টার, ডিজিটাল ক্যামেরা সেন্সর ডিজাইন (মোয়ার প্যাটার্ন এড়াতে), এবং অডিও রেকর্ডিং ইকুইপমেন্ট ডিজাইনে বিবেচনা করা হয়।$Q2700$,
  ARRAY[$Q2701$Sampling Error$Q2701$,$Q2702$Nyquist Violation$Q2702$,$Q2703$Anti-Aliasing Filter$Q2703$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2704$Frequency Domain vs Time Domain$Q2704$,
  $Q2705$F$Q2705$,
  $Q2706$signals$Q2706$,
  $Q2707$Oppenheim, Ch.4$Q2707$,
  $Q2708$high$Q2708$,
  $Q2709$wavesine$Q2709$,
  $Q2710$সিগন্যাল দেখার দুটি ভিন্ন দৃষ্টিভঙ্গি$Q2710$,
  $Q2711$Time Domain-এ একটি সিগন্যালকে সময়ের সাপেক্ষে তার তাৎক্ষণিক মান (amplitude vs time) দিয়ে বর্ণনা করা হয়, আর Frequency Domain-এ সেই একই সিগন্যালকে তার মধ্যে থাকা বিভিন্ন ফ্রিকোয়েন্সি উপাদানের শক্তি/তীব্রতা (amplitude vs frequency) দিয়ে বর্ণনা করা হয় — Fourier Transform এই দুই দৃষ্টিভঙ্গির মধ্যে সেতুবন্ধন তৈরি করে।$Q2711$,
  $Q2712$🎼 একটি গানের রেকর্ডিং বনাম শীট মিউজিকের মতো — Time Domain হলো রেকর্ডিং (কখন কী শব্দ হচ্ছে), Frequency Domain হলো শীট মিউজিক (কোন সুর/নোট ব্যবহৃত হচ্ছে) — দুটোই একই গানের ভিন্ন উপস্থাপনা, একটি থেকে অন্যটি বের করা যায়।$Q2712$,
  $Q2713$সিগন্যাল বিশ্লেষণে সঠিক দৃষ্টিভঙ্গি বেছে নিতে — টাইমিং সমস্যা (কখন কী ঘটছে) দেখতে Time Domain, ফ্রিকোয়েন্সি কম্পোজিশন (কোন সুর/নয়েজ আছে) দেখতে Frequency Domain ব্যবহৃত হয়।$Q2713$,
  $Q2714$একটি গিটারের নোটের Time Domain প্লট দেখায় শব্দ কীভাবে সময়ের সাথে ক্ষয় হচ্ছে (decay), কিন্তু Frequency Domain প্লট (স্পেকট্রাম) দেখায় কোন কোন হারমনিক ফ্রিকোয়েন্সি সেই নোটের সমৃদ্ধ টিম্বার তৈরি করছে।$Q2714$,
  $Q2715$Fourier Transform দিয়ে Time Domain থেকে Frequency Domain-এ যাওয়া যায় (x(t)→X(f)), Inverse Fourier Transform দিয়ে বিপরীত। একটি সংকীর্ণ Time Domain পালস প্রশস্ত Frequency Domain স্পেকট্রাম তৈরি করে (এবং বিপরীতভাবে) — এটি Uncertainty Principle-এর একটি রূপ।$Q2715$,
  $Q2716$অডিও ইঞ্জিনিয়ারিং (ইকুয়ালাইজার Frequency Domain, ওয়েভফর্ম এডিটিং Time Domain), ভাইব্রেশন অ্যানালাইসিস, এবং রেডিও/কমিউনিকেশন সিস্টেম ডিজাইনে ব্যবহৃত হয়।$Q2716$,
  ARRAY[$Q2717$Signal Representation$Q2717$,$Q2718$Fourier Analysis$Q2718$,$Q2719$Spectrum$Q2719$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2720$Even & Odd Signal$Q2720$,
  $Q2721$E$Q2721$,
  $Q2722$signals$Q2722$,
  $Q2723$Oppenheim, Ch.1$Q2723$,
  $Q2724$low$Q2724$,
  $Q2725$waveform$Q2725$,
  $Q2726$প্রতিসাম্য বৈশিষ্ট্য অনুযায়ী সিগন্যালের শ্রেণিবিভাগ$Q2726$,
  $Q2727$একটি সিগন্যাল Even (যুগ্ম) হয় যদি x(−t) = x(t) হয় (y-অক্ষের সাপেক্ষে প্রতিসম), আর Odd (অযুগ্ম) হয় যদি x(−t) = −x(t) হয় (মূলবিন্দুর সাপেক্ষে প্রতিসম) — যেকোনো সিগন্যালকে একটি Even ও একটি Odd অংশের যোগফল হিসেবে ভাঙা যায়।$Q2727$,
  $Q2728$🪞 আয়নার প্রতিফলনের মতো — Even সিগন্যাল হলো একটি প্রজাপতির ডানার মতো (আয়নায় দেখলে হুবহু একই দেখায়), আর Odd সিগন্যাল হলো একটি ঘূর্ণায়মান পাখার মতো (আয়নায় দেখলে উল্টো/বিপরীত দেখায়)।$Q2728$,
  $Q2729$Fourier Series-এ শুধু cosine (Even) বা শুধু sine (Odd) টার্ম ব্যবহার করে বিশ্লেষণ সরল করতে, এবং সিগন্যাল প্রতিসাম্য বৈশিষ্ট্য দ্রুত সনাক্ত করতে ব্যবহৃত হয়।$Q2729$,
  $Q2730$cos(t) একটি Even সিগন্যাল (কারণ cos(−t)=cos(t)), আর sin(t) একটি Odd সিগন্যাল (কারণ sin(−t)=−sin(t)) — এই প্রতিসাম্য অনেক গাণিতিক হিসাব সরল করে দেয়।$Q2730$,
  $Q2731$যেকোনো সিগন্যাল x(t) = x_even(t) + x_odd(t), যেখানে x_even(t) = [x(t)+x(−t)]/2 এবং x_odd(t) = [x(t)−x(−t)]/2। Even সিগন্যালের Fourier Series-এ শুধু cosine টার্ম থাকে, Odd সিগন্যালে শুধু sine টার্ম থাকে।$Q2731$,
  $Q2732$Fourier Series গণনা সরলীকরণ, অডিও সিগন্যাল সিমেট্রি বিশ্লেষণ, এবং ডিজিটাল ফিল্টার ডিজাইনে (Linear Phase FIR ফিল্টার Even/Odd Symmetry ব্যবহার করে) ব্যবহৃত হয়।$Q2732$,
  ARRAY[$Q2733$Signal Symmetry$Q2733$,$Q2734$Fourier Simplification$Q2734$,$Q2735$Signal Decomposition$Q2735$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2736$Periodic Signal$Q2736$,
  $Q2737$P$Q2737$,
  $Q2738$signals$Q2738$,
  $Q2739$Oppenheim, Ch.1$Q2739$,
  $Q2740$medium$Q2740$,
  $Q2741$wavesine$Q2741$,
  $Q2742$নির্দিষ্ট বিরতিতে নিজেকে পুনরাবৃত্তকারী সিগন্যাল$Q2742$,
  $Q2743$Periodic Signal হলো একটি সিগন্যাল, যা একটি নির্দিষ্ট সময় পর পর (পিরিয়ড T) হুবহু নিজেকে পুনরাবৃত্তি করে, অর্থাৎ x(t) = x(t+T) সব t-এর জন্য সত্য — যে সিগন্যাল এই শর্ত পূরণ করে না, তাকে Non-Periodic বা Aperiodic বলা হয়।$Q2743$,
  $Q2744$🌊 জোয়ার-ভাটার মতো — প্রতিদিন নির্দিষ্ট সময় পর পর একই প্যাটার্নে পানি উঠা-নামা করে, একই ধরনের চক্র বারবার হুবহু পুনরাবৃত্তি হতে থাকে, কখনো থামে না।$Q2744$,
  $Q2745$AC পাওয়ার সিস্টেম, ঘড়ির ক্লক সিগন্যাল, এবং Fourier Series বিশ্লেষণের প্রয়োজনীয় পূর্বশর্ত হিসেবে ব্যবহৃত হয়।$Q2745$,
  $Q2746$বাংলাদেশের গৃহস্থালী AC বিদ্যুৎ সাপ্লাই (50Hz) একটি ক্লাসিক Periodic Signal, যার পিরিয়ড T = 1/50 = 0.02 সেকেন্ড, যা প্রতি সেকেন্ডে ৫০ বার হুবহু পুনরাবৃত্তি হয়।$Q2746$,
  $Q2747$মৌলিক পিরিয়ড T₀ হলো ক্ষুদ্রতম ধনাত্মক মান যেখানে x(t)=x(t+T₀) সত্য। মৌলিক ফ্রিকোয়েন্সি f₀=1/T₀। দুটি পিরিয়ডিক সিগন্যালের যোগফল পিরিয়ডিক হয় শুধু যদি তাদের পিরিয়ডের অনুপাত একটি মূলদ সংখ্যা (rational number) হয়।$Q2747$,
  $Q2748$AC পাওয়ার সিস্টেম বিশ্লেষণ, ডিজিটাল ঘড়ি ক্লক সিগন্যাল ডিজাইন, এবং রেডিও ক্যারিয়ার ওয়েভ জেনারেশনে ব্যবহৃত হয়।$Q2748$,
  ARRAY[$Q2749$Repetitive Signal$Q2749$,$Q2750$Fundamental Period$Q2750$,$Q2751$AC Waveform$Q2751$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2752$Unit Step & Impulse Function$Q2752$,
  $Q2753$U$Q2753$,
  $Q2754$signals$Q2754$,
  $Q2755$Oppenheim, Ch.1$Q2755$,
  $Q2756$high$Q2756$,
  $Q2757$waveform$Q2757$,
  $Q2758$সিগন্যাল বিশ্লেষণের মৌলিক আদর্শ ফাংশন$Q2758$,
  $Q2759$Unit Step Function u(t) একটি সিগন্যাল যা t<0-এ 0 এবং t≥0-এ 1 মান নেয় (হঠাৎ 'অন' হওয়া সিগন্যাল প্রতিনিধিত্ব করে)। Unit Impulse Function δ(t) একটি আদর্শায়িত (idealized) সিগন্যাল, যার অসীম উচ্চতা, শূন্য প্রস্থ, কিন্তু একক (unity) ক্ষেত্রফল আছে — উভয়ই সিস্টেম বিশ্লেষণের মৌলিক টেস্ট সিগন্যাল।$Q2759$,
  $Q2760$🔦💥 লাইট সুইচ ও ক্যামেরা ফ্ল্যাশের মতো — Unit Step হলো লাইট সুইচ চাপা (হঠাৎ চিরস্থায়ীভাবে 'অন' হয়ে থাকা), আর Unit Impulse হলো ক্যামেরার ফ্ল্যাশ (মুহূর্তের জন্য অত্যন্ত তীব্র, তারপর সাথে সাথে বন্ধ)।$Q2760$,
  $Q2761$সিস্টেমের Step Response (স্টেপ ইনপুটে সাড়া) ও Impulse Response (ইমপালস ইনপুটে সাড়া) পরীক্ষা করে সিস্টেমের সম্পূর্ণ বৈশিষ্ট্য বুঝতে ব্যবহৃত হয়।$Q2761$,
  $Q2762$যখন একটি সুইচ চেপে লাইট জ্বালানো হয়, তখন সেই ইনপুটকে গাণিতিকভাবে একটি Unit Step Function দিয়ে মডেল করা হয়, এবং লাইট কতক্ষণে পূর্ণ উজ্জ্বলতায় পৌঁছায় তা Step Response দিয়ে বিশ্লেষণ করা হয়।$Q2762$,
  $Q2763$δ(t) = du(t)/dt (Impulse হলো Step-এর ডেরিভেটিভ), এবং u(t) = ∫δ(τ)dτ (t থেকে -∞ পর্যন্ত ইন্টিগ্রেল)। Sampling Property: ∫x(t)δ(t−t₀)dt = x(t₀), যা সিগন্যাল প্রসেসিং-এ ব্যাপকভাবে ব্যবহৃত হয়।$Q2763$,
  $Q2764$কন্ট্রোল সিস্টেম Step Response টেস্টিং, সিস্টেম আইডেন্টিফিকেশন (Impulse Response দিয়ে), এবং সার্কিট ট্রানজিয়েন্ট অ্যানালাইসিসে ব্যবহৃত হয়।$Q2764$,
  ARRAY[$Q2765$Test Signal$Q2765$,$Q2766$Idealized Function$Q2766$,$Q2767$System Response$Q2767$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2768$Linearity & Time-Invariance$Q2768$,
  $Q2769$L$Q2769$,
  $Q2770$signals$Q2770$,
  $Q2771$Oppenheim, Ch.1$Q2771$,
  $Q2772$high$Q2772$,
  $Q2773$blockdiagram$Q2773$,
  $Q2774$LTI সিস্টেমের দুটি সংজ্ঞায়িত মৌলিক বৈশিষ্ট্য$Q2774$,
  $Q2775$Linearity হলো একটি সিস্টেমের সেই বৈশিষ্ট্য যেখানে সুপারপজিশন নীতি প্রযোজ্য (ইনপুটের যোগফলের আউটপুট = আউটপুটের যোগফল, এবং স্কেলিং সংরক্ষিত থাকে)। Time-Invariance হলো সেই বৈশিষ্ট্য যেখানে সিস্টেমের প্যারামিটার সময়ের সাথে পরিবর্তিত হয় না — ইনপুট বিলম্বিত হলে আউটপুটও শুধু একই পরিমাণ বিলম্বিত হয়।$Q2775$,
  $Q2776$⚖️🕰️ একটি ন্যায্য ও নিয়মিত বিচারকের মতো — Linearity হলো সব মামলা একই ন্যায্য নিয়মে বিচার করা (দ্বিগুণ প্রমাণে দ্বিগুণ শাস্তি নয়, বরং একই যুক্তিসঙ্গত নিয়ম), Time-Invariance হলো আজ ও দশ বছর পরে একই মামলার একই রায় দেওয়া (নিয়ম বদলায় না)।$Q2776$,
  $Q2777$একটি সিস্টেমকে LTI হিসেবে গণ্য করার আগে এই দুটি শর্ত যাচাই করা হয়, কারণ শুধুমাত্র LTI সিস্টেমের জন্যই Convolution, Fourier ও Laplace Transform-এর শক্তিশালী টুলগুলো সরাসরি প্রয়োগযোগ্য।$Q2777$,
  $Q2778$একটি সাধারণ রেজিস্টর (Ohm's Law মেনে চলে) একটি লিনিয়ার ও টাইম-ইনভ্যারিয়ান্ট উপাদান, কিন্তু একটি ডায়োড (V-I সম্পর্ক অ-রৈখিক) লিনিয়ার নয় — তাই ডায়োডসহ সার্কিটে সরাসরি LTI বিশ্লেষণ পদ্ধতি প্রয়োগ করা যায় না।$Q2778$,
  $Q2779$Linearity: y(t) = T[ax₁(t)+bx₂(t)] = aT[x₁(t)]+bT[x₂(t)]। Time-Invariance: যদি x(t)→y(t) হয়, তাহলে x(t−t₀)→y(t−t₀)। উভয় শর্ত একসাথে পূরণ হলেই সিস্টেম LTI, এবং তখনই Impulse Response দিয়ে সম্পূর্ণ সিস্টেম বর্ণনা করা সম্ভব।$Q2779$,
  $Q2780$সার্কিট বিশ্লেষণে লিনিয়ার উপাদান (R, L, C) বনাম নন-লিনিয়ার উপাদান (ডায়োড, ট্রানজিস্টর) শনাক্তকরণ, এবং কন্ট্রোল সিস্টেম মডেলিং-এ গুরুত্বপূর্ণ প্রাথমিক শর্ত হিসেবে ব্যবহৃত হয়।$Q2780$,
  ARRAY[$Q2781$LTI Properties$Q2781$,$Q2782$Superposition$Q2782$,$Q2783$System Classification$Q2783$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2784$Causality$Q2784$,
  $Q2785$C$Q2785$,
  $Q2786$signals$Q2786$,
  $Q2787$Oppenheim, Ch.1$Q2787$,
  $Q2788$medium$Q2788$,
  $Q2789$blockdiagram$Q2789$,
  $Q2790$আউটপুট শুধু বর্তমান ও অতীত ইনপুটের ওপর নির্ভরশীলতা$Q2790$,
  $Q2791$Causality হলো একটি সিস্টেমের সেই বৈশিষ্ট্য, যেখানে আউটপুট কোনো নির্দিষ্ট মুহূর্তে শুধুমাত্র বর্তমান ও অতীতের ইনপুটের ওপর নির্ভর করে, ভবিষ্যতের ইনপুটের ওপর নয় — সব বাস্তব-সময় (real-time) ভৌত সিস্টেম অবশ্যই Causal হতে হয়, কারণ ভবিষ্যৎ জানা সম্ভব নয়।$Q2791$,
  $Q2792$🔮 ভবিষ্যৎ দেখতে না পারা একজন মানুষের মতো — একজন সাধারণ মানুষ শুধু অতীত ও বর্তমান অভিজ্ঞতার ওপর ভিত্তি করে সিদ্ধান্ত নিতে পারে, ভবিষ্যতে কী ঘটবে তা আগে থেকে জেনে সিদ্ধান্ত নিতে পারে না।$Q2792$,
  $Q2793$বাস্তব-সময় সিগন্যাল প্রসেসিং সিস্টেম ডিজাইনে অবশ্যপালনীয় শর্ত হিসেবে যাচাই করা হয় (যদিও অফলাইন প্রসেসিং-এ Non-Causal সিস্টেমও ব্যবহার করা যায়, যেমন রেকর্ড করা অডিও এডিটিং)।$Q2793$,
  $Q2794$একটি লাইভ অডিও ইফেক্ট প্রসেসর (যেমন মাইক্রোফোনের সাথে সরাসরি ব্যবহৃত ইকো ইফেক্ট) অবশ্যই Causal হতে হবে, কারণ এটি ভবিষ্যতের শব্দ শুনে আগেই প্রতিক্রিয়া দেখাতে পারবে না — কিন্তু একটি রেকর্ড করা গানের এডিটিং সফটওয়্যার Non-Causal প্রসেসিং ব্যবহার করতে পারে, কারণ পুরো ফাইল আগে থেকেই উপলব্ধ।$Q2794$,
  $Q2795$একটি LTI সিস্টেম Causal হয় যদি এবং শুধুমাত্র যদি h(t)=0 for t<0 (t=0-এর আগে Impulse Response শূন্য থাকতে হবে, নাহলে সিস্টেম ইমপালস প্রয়োগের আগেই সাড়া দিচ্ছে — যা ভৌতভাবে অসম্ভব)।$Q2795$,
  $Q2796$রিয়েল-টাইম অডিও/ভিডিও প্রসেসিং সিস্টেম ডিজাইন, কন্ট্রোল সিস্টেম বাস্তবায়নযোগ্যতা (implementability) যাচাই, এবং ডিজিটাল ফিল্টার ডিজাইনে (FIR/IIR ফিল্টার Causal কিনা) ব্যবহৃত হয়।$Q2796$,
  ARRAY[$Q2797$Real-Time System$Q2797$,$Q2798$Physical Realizability$Q2798$,$Q2799$System Property$Q2799$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2800$BIBO Stability$Q2800$,
  $Q2801$B$Q2801$,
  $Q2802$signals$Q2802$,
  $Q2803$Oppenheim, Ch.2$Q2803$,
  $Q2804$medium$Q2804$,
  $Q2805$gauge$Q2805$,
  $Q2806$সসীম ইনপুটে সসীম আউটপুট নিশ্চিতকারী স্থিতিশীলতা$Q2806$,
  $Q2807$BIBO (Bounded-Input Bounded-Output) Stability হলো একটি সিস্টেমের সেই বৈশিষ্ট্য, যেখানে প্রতিটি সসীম (bounded, একটি নির্দিষ্ট সীমার মধ্যে থাকা) ইনপুটের জন্য আউটপুটও সসীম থাকে — এটি সিগন্যাল ও সিস্টেম তত্ত্বে স্থিতিশীলতার একটি মৌলিক ও সবচেয়ে ব্যাপকভাবে ব্যবহৃত সংজ্ঞা।$Q2807$,
  $Q2808$🏗️ একটি ভালো নির্মিত ব্রিজের মতো — যুক্তিসঙ্গত পরিমাণ গাড়ি ও বাতাসের চাপ (সসীম ইনপুট) সহ্য করে ব্রিজ সবসময় নিরাপদ (সসীম আউটপুট, যেমন সামান্য কম্পন) থাকে, কখনো অসীম দুলুনি বা ভেঙে পড়ে না।$Q2808$,
  $Q2809$যেকোনো নতুন ডিজাইন করা সিস্টেম বাস্তবে নিরাপদে ব্যবহারযোগ্য কিনা তা যাচাইয়ের প্রথম ধাপ হিসেবে ব্যবহৃত হয় — অস্থির সিস্টেম বাস্তব প্রয়োগে বিপজ্জনক।$Q2809$,
  $Q2810$একটি অস্থির অডিও ফিডব্যাক সিস্টেম (মাইক্রোফোন স্পিকারের খুব কাছে) সামান্য শব্দ (সসীম ইনপুট) থেকে ক্রমাগত বেড়ে যাওয়া তীক্ষ্ণ চিৎকারে (অসীমের কাছাকাছি আউটপুট) পরিণত হতে পারে — এটি BIBO অস্থিতিশীলতার একটি বাস্তব উদাহরণ।$Q2810$,
  $Q2811$একটি LTI সিস্টেম BIBO স্থিতিশীল হয় যদি এবং শুধুমাত্র যদি Impulse Response সম্পূর্ণরূপে সমাকলনযোগ্য হয় (Absolutely Integrable): ∫|h(t)|dt < ∞। এটি ট্রান্সফার ফাংশনের সব Pole s-প্লেনের বামপাশে থাকার শর্তের সমতুল্য।$Q2811$,
  $Q2812$অডিও সিস্টেম ফিডব্যাক প্রতিরোধ, কন্ট্রোল সিস্টেম নিরাপত্তা যাচাই, এবং ডিজিটাল ফিল্টার ডিজাইনে (IIR ফিল্টার Pole স্থিতিশীলতা) ব্যবহৃত হয়।$Q2812$,
  ARRAY[$Q2813$System Stability$Q2813$,$Q2814$Bounded Signal$Q2814$,$Q2815$Absolute Integrability$Q2815$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2816$Convolution Theorem$Q2816$,
  $Q2817$C$Q2817$,
  $Q2818$signals$Q2818$,
  $Q2819$Oppenheim, Ch.4$Q2819$,
  $Q2820$high$Q2820$,
  $Q2821$formula$Q2821$,
  $Q2822$টাইম ডোমেইনে Convolution = ফ্রিকোয়েন্সি ডোমেইনে গুণ$Q2822$,
  $Q2823$Convolution Theorem বলে যে, Time Domain-এ দুটি সিগন্যালের Convolution, Frequency Domain-এ তাদের যথাক্রমে Fourier Transform-এর সরল গুণফলের সমতুল্য — এই তত্ত্ব সিগন্যাল প্রসেসিং-এর গণনা উল্লেখযোগ্যভাবে সহজ করে দেয়।$Q2823$,
  $Q2824$🔢 জটিল গুণ বনাম সহজ যোগের মতো — বড় সংখ্যা সরাসরি গুণ করা কঠিন, কিন্তু লগারিদম নিলে গুণ যোগে পরিণত হয় (সহজ); একইভাবে, Time Domain-এ জটিল Convolution, Frequency Domain-এ গেলে সহজ গুণে পরিণত হয়ে যায়।$Q2824$,
  $Q2825$কম্পিউটার সফটওয়্যারে দ্রুত ফিল্টারিং বাস্তবায়ন — Time Domain-এ Convolution গণনা ধীর (O(N²)), তাই FFT ব্যবহার করে Frequency Domain-এ গুণ করে দ্রুত (O(N log N)) ফলাফল পাওয়া হয়।$Q2825$,
  $Q2826$একটি ইমেজ প্রসেসিং সফটওয়্যার বড় ছবিতে ব্লার ফিল্টার প্রয়োগ করার সময়, সরাসরি Convolution না করে FFT ব্যবহার করে Frequency Domain-এ গুণ করে, তারপর Inverse FFT করে ফলাফল পায় — যা অনেক দ্রুত।$Q2826$,
  $Q2827$y(t) = x(t)*h(t) ⟺ Y(f) = X(f)×H(f) (Time Domain Convolution = Frequency Domain Multiplication)। বিপরীতভাবে, Time Domain-এ গুণ = Frequency Domain-এ Convolution (Duality Property)।$Q2827$,
  $Q2828$দ্রুত ডিজিটাল ফিল্টারিং (অডিও/ইমেজ প্রসেসিং সফটওয়্যার), OFDM যোগাযোগ সিস্টেম, এবং বড় ডেটাসেট সিগন্যাল প্রসেসিং-এ কম্পিউটেশনাল দক্ষতা বাড়াতে ব্যবহৃত হয়।$Q2828$,
  ARRAY[$Q2829$Fourier Property$Q2829$,$Q2830$Fast Filtering$Q2830$,$Q2831$FFT Application$Q2831$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2832$Energy & Power Signal$Q2832$,
  $Q2833$E$Q2833$,
  $Q2834$signals$Q2834$,
  $Q2835$Oppenheim, Ch.1$Q2835$,
  $Q2836$low$Q2836$,
  $Q2837$gauge$Q2837$,
  $Q2838$মোট শক্তি ও গড় ক্ষমতা অনুযায়ী সিগন্যালের শ্রেণিবিভাগ$Q2838$,
  $Q2839$Energy Signal হলো সেই সিগন্যাল যার মোট শক্তি সসীম কিন্তু গড় ক্ষমতা শূন্য (সাধারণত সসীম সময়ের বা ক্ষয়িষ্ণু সিগন্যাল), আর Power Signal হলো সেই সিগন্যাল যার গড় ক্ষমতা সসীম কিন্তু মোট শক্তি অসীম (সাধারণত পিরিয়ডিক বা চিরস্থায়ী সিগন্যাল) — কোনো সিগন্যাল একই সাথে উভয়ই হতে পারে না।$Q2839$,
  $Q2840$💥🔋 একটি বিস্ফোরণ বনাম একটি চলমান ইঞ্জিনের মতো — বিস্ফোরণ (Energy Signal) সংক্ষিপ্ত সময়ে বিশাল মোট শক্তি ছাড়ে তারপর থেমে যায় (গড় ক্ষমতা শূন্যের কাছে), কিন্তু একটি সবসময় চলমান ইঞ্জিন (Power Signal) অনন্তকাল ধরে একটি স্থির হারে ক্ষমতা ব্যবহার করতে থাকে (মোট শক্তি অসীম)।$Q2840$,
  $Q2841$সিগন্যালের গাণিতিক বিশ্লেষণে সঠিক টুল (Fourier Transform বনাম Fourier Series) নির্বাচনে সাহায্য করে, কারণ Power Signal-এর Fourier Transform সরাসরি সংজ্ঞায়িত নয়।$Q2841$,
  $Q2842$একটি একক রেডার পালস (কয়েক মাইক্রোসেকেন্ড স্থায়ী, তারপর শূন্য) একটি Energy Signal, কিন্তু একটি স্থির AC পাওয়ার সাপ্লাই সিগন্যাল (অনন্তকাল চলমান sin ওয়েভ) একটি Power Signal।$Q2842$,
  $Q2843$Energy: E = ∫|x(t)|²dt (t = −∞ থেকে ∞), যদি E সসীম হয় তাহলে Energy Signal। Power: P = lim(T→∞) (1/T)∫|x(t)|²dt, যদি P সসীম ও ধনাত্মক হয় তাহলে Power Signal।$Q2843$,
  $Q2844$রেডার ও কমিউনিকেশন পালস ডিজাইন বিশ্লেষণ (Energy Signal), এবং AC পাওয়ার সিস্টেম ও পিরিয়ডিক ক্যারিয়ার ওয়েভ বিশ্লেষণে (Power Signal) ব্যবহৃত হয়।$Q2844$,
  ARRAY[$Q2845$Signal Classification$Q2845$,$Q2846$Total Energy$Q2846$,$Q2847$Average Power$Q2847$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2848$Filter (LPF/HPF/BPF)$Q2848$,
  $Q2849$F$Q2849$,
  $Q2850$signals$Q2850$,
  $Q2851$Oppenheim, Ch.6$Q2851$,
  $Q2852$high$Q2852$,
  $Q2853$filter$Q2853$,
  $Q2854$নির্দিষ্ট ফ্রিকোয়েন্সি পাস বা ব্লক করার সার্কিট$Q2854$,
  $Q2855$Filter হলো একটি সিস্টেম, যা একটি সিগন্যালের নির্দিষ্ট ফ্রিকোয়েন্সি রেঞ্জ পাস (প্রবেশ) করতে দেয় এবং অন্যগুলো বাধা (attenuate) দেয় — Low-Pass Filter (LPF) নিম্ন ফ্রিকোয়েন্সি পাস করে, High-Pass Filter (HPF) উচ্চ ফ্রিকোয়েন্সি পাস করে, আর Band-Pass Filter (BPF) শুধু একটি নির্দিষ্ট মধ্যবর্তী রেঞ্জ পাস করে।$Q2855$,
  $Q2856$🧺 একটি চালনি (sieve)-র মতো — বিভিন্ন সাইজের ছিদ্রযুক্ত চালনি দিয়ে শুধু নির্দিষ্ট আকারের কণা (নির্দিষ্ট ফ্রিকোয়েন্সি) পার হতে দেয়, বাকিগুলো আটকে যায় — LPF হলো বড় ছিদ্রের চালনি (শুধু বড়/ধীর জিনিস পার হয়), HPF হলো উল্টো।$Q2856$,
  $Q2857$অডিও ইকুয়ালাইজার (বেস/ট্রেবল নিয়ন্ত্রণ), রেডিও চ্যানেল সিলেকশন, এবং নয়েজ রিমুভালে ব্যাপকভাবে ব্যবহৃত হয়।$Q2857$,
  $Q2858$একটি সাবউফার স্পিকারে একটি Low-Pass Filter ব্যবহার করা হয় যাতে শুধু নিম্ন-ফ্রিকোয়েন্সি বেস সাউন্ড (সাধারণত <200Hz) সেই স্পিকারে যায়, উচ্চ-ফ্রিকোয়েন্সি সাউন্ড টুইটার স্পিকারে পাঠানো হয়।$Q2858$,
  $Q2859$প্রতিটি ফিল্টারের একটি Cutoff Frequency (−3dB পয়েন্ট) থাকে। Order যত বেশি (2nd, 4th, 8th order), Roll-off (কতটা দ্রুতভাবে গেইন কমে) তত তীক্ষ্ণ হয় — কিন্তু ডিজাইন জটিলতা ও ফেজ বিকৃতিও বাড়ে।$Q2859$,
  $Q2860$অডিও ক্রসওভার নেটওয়ার্ক (স্পিকার), রেডিও রিসিভার চ্যানেল সিলেকশন, ADC-র আগে অ্যান্টি-অ্যালায়াসিং ফিল্টার, এবং বায়োমেডিকেল সিগন্যাল (ECG) নয়েজ রিমুভালে ব্যবহৃত হয়।$Q2860$,
  ARRAY[$Q2861$Frequency Selectivity$Q2861$,$Q2862$Cutoff Frequency$Q2862$,$Q2863$Signal Conditioning$Q2863$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2864$Region of Convergence (ROC)$Q2864$,
  $Q2865$R$Q2865$,
  $Q2866$signals$Q2866$,
  $Q2867$Oppenheim, Ch.9-10$Q2867$,
  $Q2868$low$Q2868$,
  $Q2869$formula$Q2869$,
  $Q2870$যে অঞ্চলে Laplace/Z-Transform সীমিত থাকে$Q2870$,
  $Q2871$Region of Convergence (ROC) হলো s-প্লেন (Laplace Transform-এর জন্য) বা z-প্লেন (Z-Transform-এর জন্য) সেই অংশ, যেখানে ট্রান্সফর্মের ইন্টিগ্রেল/সামেশন সীমিত (converge) থাকে — একই ট্রান্সফার ফাংশনের বিভিন্ন ROC থাকলে ভিন্ন ভিন্ন টাইম-ডোমেইন সিগন্যাল বোঝাতে পারে, তাই ROC উল্লেখ করা অপরিহার্য।$Q2871$,
  $Q2872$🗺️ একটি মানচিত্রের বৈধ এলাকার মতো — একটি ম্যাপ (ট্রান্সফার ফাংশন) হয়তো একটি নির্দিষ্ট অঞ্চলের জন্যই সঠিক তথ্য দেয় (ROC), সেই অঞ্চলের বাইরে ব্যবহার করলে ভুল দিকনির্দেশনা (ভুল ফলাফল) পাওয়া যাবে।$Q2872$,
  $Q2873$একটি সিস্টেম Causal নাকি Anti-Causal, এবং Stable নাকি Unstable তা নির্ধারণে ROC পরীক্ষা করা হয়, কারণ শুধু Transfer Function যথেষ্ট নয়।$Q2873$,
  $Q2874$একই ট্রান্সফার ফাংশন X(z) = 1/(1−0.5z⁻¹)-এর দুটি ভিন্ন ROC (|z|>0.5 বা |z|<0.5) থাকতে পারে, যা দুটি সম্পূর্ণ ভিন্ন (একটি Causal, একটি Anti-Causal) সময়-ডোমেইন সিগন্যাল প্রতিনিধিত্ব করে।$Q2874$,
  $Q2875$একটি সিস্টেম Stable হয় যদি ROC unit circle (|z|=1) বা jω-অক্ষ (s-প্লেনে) অন্তর্ভুক্ত করে। Causal সিস্টেমের ROC সবচেয়ে বাইরের Pole-এর ডানপাশে (s-প্লেনে) বা বাইরে (z-প্লেনে) থাকে।$Q2875$,
  $Q2876$ডিজিটাল ফিল্টার ডিজাইনে স্থিতিশীলতা ও Causality একসাথে নিশ্চিতকরণ, এবং একাডেমিক সিগন্যাল প্রসেসিং কোর্সে Z-Transform/Laplace Transform সমস্যা সমাধানে অপরিহার্য ধাপ হিসেবে ব্যবহৃত হয়।$Q2876$,
  ARRAY[$Q2877$Z-Transform$Q2877$,$Q2878$Laplace Transform$Q2878$,$Q2879$Convergence Analysis$Q2879$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2880$Electric Field$Q2880$,
  $Q2881$E$Q2881$,
  $Q2882$electromagnetic$Q2882$,
  $Q2883$Hayt, Ch.2$Q2883$,
  $Q2884$critical$Q2884$,
  $Q2885$fieldlines$Q2885$,
  $Q2886$চার্জের চারপাশে বল অনুভবের ক্ষেত্র$Q2886$,
  $Q2887$Electric Field (E) হলো একটি চার্জিত কণার চারপাশের সেই স্থান, যেখানে অন্য কোনো চার্জ রাখলে সে একটি বৈদ্যুতিক বল অনুভব করবে — এটি একটি ভেক্টর রাশি, যার দিক ধনাত্মক টেস্ট চার্জের ওপর বলের দিক নির্দেশ করে।$Q2887$,
  $Q2888$🌡️ একটি চুলার তাপের প্রভাবের মতো — চুলার (চার্জের) কাছে গেলে তাপ (বল) অনুভব করবে, দূরে গেলে কম অনুভব করবে — এই 'তাপ অনুভবের সম্ভাবনার ক্ষেত্র' প্রতিটি বিন্দুতে বিদ্যমান, কেউ সেখানে থাকুক বা না থাকুক।$Q2888$,
  $Q2889$ক্যাপাসিটর ডিজাইন, ইলেকট্রোস্ট্যাটিক প্রিন্টার ও পেইন্ট স্প্রেয়ার, এবং হাই-ভোল্টেজ ইনসুলেশন ডিজাইনে ফিল্ড স্ট্রেংথ বিশ্লেষণে ব্যবহৃত হয়।$Q2889$,
  $Q2890$একটি চার্জিত বেলুন চুল আকর্ষণ করে কারণ বেলুনের চারপাশে সৃষ্ট Electric Field চুলের অণুতে পোলারাইজেশন ঘটিয়ে আকর্ষণী বল তৈরি করে।$Q2890$,
  $Q2891$E = F/q (একক টেস্ট চার্জের ওপর বল)। একটি বিন্দু চার্জ থেকে: E = kQ/r² (Coulomb's Law থেকে প্রাপ্ত), যেখানে দূরত্ব বাড়ার সাথে ফিল্ড দ্রুত (r²-এর ব্যস্তানুপাতিক) কমে যায়।$Q2891$,
  $Q2892$ক্যাপাসিটর ও হাই-ভোল্টেজ ইনসুলেটর ডিজাইন, ইলেকট্রোস্ট্যাটিক এয়ার ফিল্টার ও পেইন্ট স্প্রেয়ার, এবং জেরক্স/লেজার প্রিন্টার প্রযুক্তিতে ব্যবহৃত হয়।$Q2892$,
  ARRAY[$Q2893$Vector Field$Q2893$,$Q2894$Coulomb's Law$Q2894$,$Q2895$Electrostatics$Q2895$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2896$Magnetic Field$Q2896$,
  $Q2897$M$Q2897$,
  $Q2898$electromagnetic$Q2898$,
  $Q2899$Hayt, Ch.7$Q2899$,
  $Q2900$critical$Q2900$,
  $Q2901$fieldlines$Q2901$,
  $Q2902$চলমান চার্জ বা চুম্বকের চারপাশের বল ক্ষেত্র$Q2902$,
  $Q2903$Magnetic Field (B) হলো চলমান বৈদ্যুতিক চার্জ (কারেন্ট) বা স্থায়ী চুম্বকের চারপাশে সৃষ্ট একটি ভেক্টর ক্ষেত্র, যা অন্য চলমান চার্জ বা চুম্বকীয় উপাদানের ওপর বল প্রয়োগ করে — এটি ইলেকট্রিক্যাল মেশিন ও ইলেকট্রনিক্সের অন্যতম মৌলিক ভৌত ধারণা।$Q2903$,
  $Q2904$🧲 একটি চুম্বকের চারপাশে লোহার গুঁড়া ছড়ালে যে প্যাটার্ন দেখা যায় তার মতো — যদিও চোখে দেখা যায় না, চুম্বকের চারপাশের প্রতিটি বিন্দুতে একটি নির্দিষ্ট দিক ও তীব্রতার 'প্রভাব' (ফিল্ড) বিদ্যমান, যা লোহার গুঁড়া তার আকৃতি দেখিয়ে দেয়।$Q2904$,
  $Q2905$মোটর ও জেনারেটর ডিজাইন, MRI মেশিন, এবং কম্পাস ও চৌম্বক সেন্সর প্রযুক্তিতে মৌলিক ভিত্তি হিসেবে ব্যবহৃত হয়।$Q2905$,
  $Q2906$একটি তার দিয়ে কারেন্ট প্রবাহিত করলে তার চারপাশে একটি বৃত্তাকার Magnetic Field তৈরি হয় (Right-Hand Rule দিয়ে দিক নির্ণয় করা যায়), যা একটি কাছাকাছি কম্পাস সুচকে বিচ্যুত করতে পারে।$Q2906$,
  $Q2907$একটি লম্বা সোজা তারের জন্য (Ampere's Law থেকে): B = μ₀I/(2πr) (I = কারেন্ট, r = তার থেকে দূরত্ব)। চলমান চার্জের ওপর বল (Lorentz Force): F = qv×B, যা মোটরে টর্ক উৎপাদনের মূল কারণ।$Q2907$,
  $Q2908$DC ও AC মোটর/জেনারেটর, MRI মেডিকেল ইমেজিং, হার্ড ড্রাইভ ডেটা স্টোরেজ, এবং ম্যাগলেভ ট্রেন প্রযুক্তিতে ব্যবহৃত হয়।$Q2908$,
  ARRAY[$Q2909$Vector Field$Q2909$,$Q2910$Lorentz Force$Q2910$,$Q2911$Magnetism$Q2911$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2912$Coulomb's Law$Q2912$,
  $Q2913$C$Q2913$,
  $Q2914$electromagnetic$Q2914$,
  $Q2915$Hayt, Ch.2$Q2915$,
  $Q2916$critical$Q2916$,
  $Q2917$formula$Q2917$,
  $Q2918$দুই চার্জের মধ্যকার বলের মৌলিক সূত্র$Q2918$,
  $Q2919$Coulomb's Law বলে যে, দুটি স্থির বিন্দু চার্জের মধ্যকার বৈদ্যুতিক বল তাদের চার্জের গুণফলের সমানুপাতিক এবং তাদের মধ্যকার দূরত্বের বর্গের ব্যস্তানুপাতিক — এটি ইলেকট্রোস্ট্যাটিক্সের ভিত্তিমূল সূত্র, যা মহাকর্ষের Newton's Law-এর সাথে গাণিতিকভাবে সাদৃশ্যপূর্ণ।$Q2919$,
  $Q2920$🧲 দুই চুম্বকের আকর্ষণ-বিকর্ষণের মতো — চার্জ যত বেশি (শক্তিশালী চুম্বক), বল তত বেশি; দূরত্ব যত বেশি, বল তত দ্রুত কমে যায় — কাছাকাছি গেলে টান/ধাক্কা প্রবল অনুভব হয়, দূরে গেলে প্রায় অনুভবই হয় না।$Q2920$,
  $Q2921$ইলেকট্রোস্ট্যাটিক ফোর্স ক্যালকুলেশন, ক্যাপাসিটর ডিজাইন, এবং পারমাণবিক ও আণবিক গঠন বিশ্লেষণের ভিত্তি হিসেবে ব্যবহৃত হয়।$Q2921$,
  $Q2922$দুটি সমান ধনাত্মক চার্জকে কাছাকাছি আনলে তারা পরস্পরকে বিকর্ষণ করে দূরে সরে যেতে চায় (যেমন দুটি ফুলিয়ে ঘষা বেলুন কাছাকাছি আনলে একে অপরকে ঠেলে দেয়), যার তীব্রতা Coulomb's Law দিয়ে হিসাব করা যায়।$Q2922$,
  $Q2923$F = kQ₁Q₂/r² = Q₁Q₂/(4πε₀r²), যেখানে k ≈ 9×10⁹ N·m²/C² (Coulomb's constant), ε₀ = free space-এর পারমিটিভিটি। সমচিহ্নের চার্জে বিকর্ষণ, বিপরীত চিহ্নে আকর্ষণ ঘটে।$Q2923$,
  $Q2924$ইলেকট্রোস্ট্যাটিক প্রিন্টার ও পেইন্ট স্প্রেয়ার, পারমাণবিক গঠন মডেলিং, ভ্যান ডার গ্রাফ জেনারেটর, এবং ক্যাপাসিটর ফিল্ড গণনায় ব্যবহৃত হয়।$Q2924$,
  ARRAY[$Q2925$Electrostatics$Q2925$,$Q2926$Point Charge$Q2926$,$Q2927$Inverse Square Law$Q2927$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2928$Gauss's Law$Q2928$,
  $Q2929$G$Q2929$,
  $Q2930$electromagnetic$Q2930$,
  $Q2931$Hayt, Ch.3$Q2931$,
  $Q2932$high$Q2932$,
  $Q2933$fieldlines$Q2933$,
  $Q2934$বদ্ধ পৃষ্ঠের মধ্য দিয়ে ইলেকট্রিক ফ্লাক্স ও আবদ্ধ চার্জের সম্পর্ক$Q2934$,
  $Q2935$Gauss's Law বলে যে, একটি বদ্ধ পৃষ্ঠের (closed surface) মধ্য দিয়ে মোট ইলেকট্রিক ফ্লাক্স সেই পৃষ্ঠের ভেতরে আবদ্ধ মোট চার্জের সমানুপাতিক — এটি Coulomb's Law-এরই একটি সমতুল্য কিন্তু বেশি শক্তিশালী গাণিতিক রূপ, যা প্রতিসাম্যপূর্ণ চার্জ বিতরণে ফিল্ড দ্রুত গণনায় সাহায্য করে।$Q2935$,
  $Q2936$🎣 একটি মাছ ধরার জালের মধ্য দিয়ে পানি প্রবাহের মতো — জালের ভেতরে যত বেশি মাছ (চার্জ) থাকবে, জাল দিয়ে তত বেশি পানির ঢেউ (ফ্লাক্স) বেরিয়ে যাবে, জালের আকৃতি যাই হোক না কেন — শুধু ভেতরের মোট মাছের সংখ্যাই গুরুত্বপূর্ণ।$Q2936$,
  $Q2937$প্রতিসাম্যপূর্ণ চার্জ বিতরণে (গোলক, তার, প্লেন) দ্রুত Electric Field গণনায়, এবং ক্যাপাসিটর ডিজাইনে ব্যবহৃত হয়।$Q2937$,
  $Q2938$একটি সুষমভাবে চার্জিত গোলকের বাইরের ফিল্ড হিসাব করতে Gauss's Law ব্যবহার করলে দেখা যায় ফলাফল ঠিক এমন হয় যেন সব চার্জ গোলকের কেন্দ্রে একটি বিন্দু চার্জ হিসেবে ঘনীভূত আছে।$Q2938$,
  $Q2939$∮E·dA = Q_enclosed/ε₀ (Integral Form), অথবা ∇·E = ρ/ε₀ (Differential Form, ρ = চার্জ ঘনত্ব) — এটি Maxwell's Equations-এর প্রথম সমীকরণ।$Q2939$,
  $Q2940$ক্যাপাসিটর ফিল্ড ডিজাইন, উচ্চ-ভোল্টেজ ইকুইপমেন্টের ইলেকট্রিক ফিল্ড বিশ্লেষণ, এবং কোঅ্যাক্সিয়াল ক্যাবল ডিজাইনে ব্যবহৃত হয়।$Q2940$,
  ARRAY[$Q2941$Maxwell's Equations$Q2941$,$Q2942$Electric Flux$Q2942$,$Q2943$Symmetry$Q2943$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2944$Faraday's Law of Induction$Q2944$,
  $Q2945$F$Q2945$,
  $Q2946$electromagnetic$Q2946$,
  $Q2947$Hayt, Ch.9$Q2947$,
  $Q2948$critical$Q2948$,
  $Q2949$generator$Q2949$,
  $Q2950$পরিবর্তনশীল চৌম্বক ফ্লাক্স দ্বারা EMF সৃষ্টি$Q2950$,
  $Q2951$Faraday's Law of Induction বলে যে, একটি বদ্ধ লুপের মধ্য দিয়ে চৌম্বক ফ্লাক্স পরিবর্তিত হলে সেই লুপে একটি Electromotive Force (EMF) প্ররোচিত হয় — এই EMF-এর মাত্রা ফ্লাক্স পরিবর্তনের হারের সমানুপাতিক, এবং এটি সব ইলেকট্রিক্যাল জেনারেটর ও ট্রান্সফরমারের মৌলিক নীতি।$Q2951$,
  $Q2952$🌊 একটি নৌকার ওপর ঢেউয়ের প্রভাবের মতো — শান্ত পানিতে (স্থির চৌম্বক ফিল্ড) নৌকা স্থির থাকে, কিন্তু ঢেউ যত দ্রুত পরিবর্তিত হয় (ফ্লাক্স পরিবর্তনের হার), নৌকা তত জোরে দোলে (তত বেশি EMF তৈরি হয়)।$Q2952$,
  $Q2953$সব ধরনের ইলেকট্রিক জেনারেটর, ট্রান্সফরমার, এবং ইনডাকশন কুকটপ ডিজাইনের মূল বৈজ্ঞানিক ভিত্তি হিসেবে ব্যবহৃত হয়।$Q2953$,
  $Q2954$একটি সাইকেলের ডায়নামোতে চাকা ঘোরার সাথে সাথে একটি চুম্বক কয়েলের কাছে ঘোরে, যার ফলে কয়েলের মধ্য দিয়ে চৌম্বক ফ্লাক্স ক্রমাগত পরিবর্তিত হয়ে EMF তৈরি করে, যা বাতি জ্বালায়।$Q2954$,
  $Q2955$EMF = −N(dΦ/dt) (N = কয়েলের প্যাঁচ সংখ্যা, Φ = চৌম্বক ফ্লাক্স, ঋণাত্মক চিহ্ন Lenz's Law নির্দেশ করে — প্ররোচিত কারেন্ট সবসময় তার সৃষ্টিকারী পরিবর্তনকে বিরোধিতা করে)। দ্রুত ফ্লাক্স পরিবর্তন (দ্রুত ঘূর্ণন বা দ্রুত সুইচিং) বেশি EMF তৈরি করে।$Q2955$,
  $Q2956$সব ধরনের AC/DC জেনারেটর ও অল্টারনেটর, পাওয়ার ট্রান্সফরমার, ইনডাকশন কুকটপ, এবং ওয়্যারলেস ফোন চার্জিং প্রযুক্তিতে ব্যবহৃত হয়।$Q2956$,
  ARRAY[$Q2957$EMF$Q2957$,$Q2958$Electromagnetic Induction$Q2958$,$Q2959$Lenz's Law$Q2959$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2960$Ampere's Circuital Law$Q2960$,
  $Q2961$A$Q2961$,
  $Q2962$electromagnetic$Q2962$,
  $Q2963$Hayt, Ch.7$Q2963$,
  $Q2964$high$Q2964$,
  $Q2965$fieldlines$Q2965$,
  $Q2966$বদ্ধ পথে চৌম্বক ফিল্ড ও আবদ্ধ কারেন্টের সম্পর্ক$Q2966$,
  $Q2967$Ampere's Circuital Law বলে যে, একটি বদ্ধ পথ (closed loop) বরাবর চৌম্বক ফিল্ডের লাইন ইন্টিগ্রাল, সেই পথের মধ্য দিয়ে আবদ্ধ মোট কারেন্টের সমানুপাতিক — এটি Gauss's Law-এর চৌম্বকীয় সংস্করণের মতো, যা প্রতিসাম্যপূর্ণ কারেন্ট বিতরণে ফিল্ড দ্রুত গণনায় সাহায্য করে।$Q2967$,
  $Q2968$🌀 একটি ঘূর্ণিঝড়ের কেন্দ্রের চারপাশে বাতাসের গতির মতো — ঝড়ের কেন্দ্রে (কারেন্ট) যত বেশি শক্তি, তার চারপাশের বৃত্তাকার পথে (লুপে) বাতাসের গতি (চৌম্বক ফিল্ড) তত তীব্র হবে।$Q2968$,
  $Q2969$সোলেনয়েড, টরয়েড ও লম্বা তারের চৌম্বক ফিল্ড দ্রুত গণনায়, এবং ইলেকট্রোম্যাগনেট ডিজাইনে ব্যবহৃত হয়।$Q2969$,
  $Q2970$একটি লম্বা সোজা তারের চারপাশে চৌম্বক ফিল্ড হিসাব করতে Ampere's Law ব্যবহার করলে সহজেই B = μ₀I/(2πr) সূত্র পাওয়া যায়, যা Biot-Savart Law দিয়ে করলে আরও জটিল ইন্টিগ্রেশন লাগত।$Q2970$,
  $Q2971$∮B·dl = μ₀I_enclosed (Integral Form), অথবা ∇×B = μ₀J (Differential Form, J = কারেন্ট ঘনত্ব) — Maxwell পরে এতে Displacement Current যোগ করে সম্পূর্ণ করেন (Ampere-Maxwell Law)।$Q2971$,
  $Q2972$সোলেনয়েড ও টরয়েড ইনডাক্টর ডিজাইন, ইলেকট্রোম্যাগনেট, এবং MRI মেশিনের চৌম্বক কয়েল ডিজাইনে ব্যবহৃত হয়।$Q2972$,
  ARRAY[$Q2973$Maxwell's Equations$Q2973$,$Q2974$Magnetic Field Calculation$Q2974$,$Q2975$Symmetry$Q2975$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2976$Maxwell's Equations$Q2976$,
  $Q2977$M$Q2977$,
  $Q2978$electromagnetic$Q2978$,
  $Q2979$Hayt, Ch.10$Q2979$,
  $Q2980$critical$Q2980$,
  $Q2981$formula$Q2981$,
  $Q2982$ইলেকট্রোম্যাগনেটিজমের চারটি মৌলিক সমীকরণ$Q2982$,
  $Q2983$Maxwell's Equations হলো চারটি সমীকরণের একটি সেট, যা ইলেকট্রিক ও ম্যাগনেটিক ফিল্ড কীভাবে চার্জ, কারেন্ট এবং একে অপরের সাথে সম্পর্কিত ও সৃষ্টি হয় তা সম্পূর্ণরূপে বর্ণনা করে — এই সমীকরণগুলো আধুনিক ইলেকট্রোম্যাগনেটিজম, অপটিক্স ও রেডিও প্রযুক্তির ভিত্তি।$Q2983$,
  $Q2984$📜 পদার্থবিজ্ঞানের 'সংবিধান'-এর মতো — যেমন একটি দেশের সংবিধানের কয়েকটি মৌলিক ধারা সব আইনের ভিত্তি তৈরি করে, ঠিক তেমনি এই চারটি সমীকরণ পুরো ইলেকট্রোম্যাগনেটিজমের সব ঘটনা (আলো, রেডিও তরঙ্গ, চুম্বকত্ব) ব্যাখ্যা করে।$Q2984$,
  $Q2985$রেডিও ও ওয়্যারলেস কমিউনিকেশন সিস্টেম ডিজাইন, অ্যান্টেনা তত্ত্ব, এবং আলোর প্রকৃতি (ইলেকট্রোম্যাগনেটিক তরঙ্গ হিসেবে) ব্যাখ্যায় ব্যবহৃত হয়।$Q2985$,
  $Q2986$Maxwell তার সমীকরণ থেকে গাণিতিকভাবে প্রমাণ করেন যে পরিবর্তনশীল ইলেকট্রিক ও ম্যাগনেটিক ফিল্ড একে অপরকে তৈরি করে স্বয়ং-প্রসারণশীল তরঙ্গ (Electromagnetic Wave) তৈরি করতে পারে, যার গতি আলোর গতির সমান — এভাবেই আলো ইলেকট্রোম্যাগনেটিক তরঙ্গ প্রমাণিত হয়।$Q2986$,
  $Q2987$চারটি সমীকরণ: (১) Gauss's Law: ∇·E=ρ/ε₀, (২) Gauss's Law for Magnetism: ∇·B=0 (চৌম্বক মনোপোল নেই), (৩) Faraday's Law: ∇×E=−∂B/∂t, (৪) Ampere-Maxwell Law: ∇×B=μ₀J+μ₀ε₀(∂E/∂t)।$Q2987$,
  $Q2988$রেডিও, WiFi ও মোবাইল অ্যান্টেনা ডিজাইন, ফাইবার অপটিক ও লেজার প্রযুক্তি, এবং RADAR সিস্টেম ডিজাইনের তাত্ত্বিক ভিত্তি হিসেবে ব্যবহৃত হয়।$Q2988$,
  ARRAY[$Q2989$Unified Theory$Q2989$,$Q2990$EM Wave$Q2990$,$Q2991$Foundation of Electromagnetism$Q2991$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q2992$Electric Flux Density$Q2992$,
  $Q2993$E$Q2993$,
  $Q2994$electromagnetic$Q2994$,
  $Q2995$Hayt, Ch.3$Q2995$,
  $Q2996$medium$Q2996$,
  $Q2997$fieldlines$Q2997$,
  $Q2998$মাধ্যম-স্বাধীন ইলেকট্রিক ফিল্ড রাশি$Q2998$,
  $Q2999$Electric Flux Density (D), যাকে Electric Displacement Field-ও বলা হয়, হলো একটি ভেক্টর রাশি যা ইলেকট্রিক ফিল্ডের সাথে সম্পর্কিত কিন্তু মাধ্যমের ডাইইলেকট্রিক বৈশিষ্ট্যের ওপর সরাসরি নির্ভর করে না — এটি বিভিন্ন মাধ্যম (ডাইইলেকট্রিক) সম্বলিত সমস্যায় Gauss's Law প্রয়োগ সহজ করে।$Q2999$,
  $Q3000$🌊 নদীর পানির প্রবাহের হারের মতো — পানির স্রোতের গতি (E) নদীর তলদেশের বাধা (মাধ্যমের বৈশিষ্ট্য) অনুযায়ী ভিন্ন হতে পারে, কিন্তু মোট পানির প্রবাহের হার (D) উৎসের ওপর নির্ভরশীল, তলদেশের বাধার ওপর নয়।$Q3000$,
  $Q3001$মাল্টি-লেয়ার ডাইইলেকট্রিক ক্যাপাসিটর ডিজাইন, এবং বিভিন্ন মাধ্যমের সীমানায় ইলেকট্রিক ফিল্ড বিশ্লেষণে ব্যবহৃত হয়।$Q3001$,
  $Q3002$একটি মাল্টি-লেয়ার ক্যাপাসিটরে (বিভিন্ন ডাইইলেকট্রিক উপাদানের স্তর) D সবসময় ধারাবাহিক (continuous) থাকে সীমানা জুড়ে, যদিও প্রতিটি স্তরে E-এর মান আলাদা আলাদা হতে পারে।$Q3002$,
  $Q3003$D = ε₀E + P = εE (P = পোলারাইজেশন, ε = মাধ্যমের পারমিটিভিটি)। ভ্যাকুয়ামে D = ε₀E। Gauss's Law-এর সাধারণীকৃত রূপ: ∮D·dA = Q_free (শুধু মুক্ত চার্জ বিবেচনা করে, বাউন্ড চার্জ নয়)।$Q3003$,
  $Q3004$ডাইইলেকট্রিক ক্যাপাসিটর ডিজাইন, উচ্চ-ভোল্টেজ ইনসুলেশন বিশ্লেষণ, এবং মাল্টি-লেয়ার PCB ডিজাইনে ব্যবহৃত হয়।$Q3004$,
  ARRAY[$Q3005$Electric Displacement$Q3005$,$Q3006$Dielectric Material$Q3006$,$Q3007$Boundary Analysis$Q3007$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3008$Poynting Vector$Q3008$,
  $Q3009$P$Q3009$,
  $Q3010$electromagnetic$Q3010$,
  $Q3011$Hayt, Ch.11$Q3011$,
  $Q3012$medium$Q3012$,
  $Q3013$wavesine$Q3013$,
  $Q3014$ইলেকট্রোম্যাগনেটিক শক্তি প্রবাহের দিক ও তীব্রতা$Q3014$,
  $Q3015$Poynting Vector (S) হলো একটি ভেক্টর রাশি, যা একটি ইলেকট্রোম্যাগনেটিক তরঙ্গের শক্তি প্রবাহের হার ও দিক (একক ক্ষেত্রফলে) নির্দেশ করে — এটি Electric Field (E) ও Magnetic Field (H)-এর ক্রস প্রোডাক্ট থেকে পাওয়া যায়।$Q3015$,
  $Q3016$🌞 সূর্যরশ্মির শক্তি প্রবাহের মতো — সূর্য থেকে পৃথিবীতে আলো (ইলেকট্রোম্যাগনেটিক তরঙ্গ) আসার সময় প্রতি বর্গমিটারে কতটা শক্তি (ওয়াট) পৌঁছাচ্ছে এবং কোন দিকে যাচ্ছে, তা Poynting Vector বলে দেয়।$Q3016$,
  $Q3017$অ্যান্টেনা রেডিয়েশন প্যাটার্ন বিশ্লেষণ, মাইক্রোওয়েভ পাওয়ার ট্রান্সমিশন, এবং সোলার প্যানেলে সৌরশক্তি প্রবাহ গণনায় ব্যবহৃত হয়।$Q3017$,
  $Q3018$একটি রেডিও ট্রান্সমিটার অ্যান্টেনার চারপাশে Poynting Vector গণনা করে ইঞ্জিনিয়াররা নির্ধারণ করেন কোন দিকে এবং কতটা শক্তি বিকিরিত হচ্ছে (Radiation Pattern), যা অ্যান্টেনা ডিজাইন অপ্টিমাইজ করতে সাহায্য করে।$Q3018$,
  $Q3019$S = E×H (ভেক্টর ক্রস প্রোডাক্ট, একক: W/m²)। S-এর দিক শক্তি প্রবাহের দিক নির্দেশ করে, এবং এর মাত্রা একক ক্ষেত্রফলে শক্তি প্রবাহের হার (তীব্রতা) নির্দেশ করে।$Q3019$,
  $Q3020$অ্যান্টেনা রেডিয়েশন প্যাটার্ন ডিজাইন, মাইক্রোওয়েভ ওভেন পাওয়ার বিতরণ বিশ্লেষণ, এবং সোলার প্যানেল ও লেজার শক্তি পরিমাপে ব্যবহৃত হয়।$Q3020$,
  ARRAY[$Q3021$Energy Flow$Q3021$,$Q3022$EM Wave Power$Q3022$,$Q3023$Antenna Analysis$Q3023$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3024$Electromagnetic Wave Propagation$Q3024$,
  $Q3025$E$Q3025$,
  $Q3026$electromagnetic$Q3026$,
  $Q3027$Hayt, Ch.11$Q3027$,
  $Q3028$high$Q3028$,
  $Q3029$wavesine$Q3029$,
  $Q3030$মহাশূন্যে বা মাধ্যমে EM তরঙ্গের ভ্রমণ$Q3030$,
  $Q3031$Electromagnetic Wave Propagation বর্ণনা করে কীভাবে পরস্পর লম্ব ইলেকট্রিক ও ম্যাগনেটিক ফিল্ড একে অপরকে সৃষ্টি করতে করতে মহাশূন্যে বা কোনো মাধ্যমে ভ্রমণ করে, কোনো পরিবাহী মাধ্যমের প্রয়োজন ছাড়াই — এই তরঙ্গ শূন্যস্থানে আলোর গতিতে ভ্রমণ করে।$Q3031$,
  $Q3032$🌊 একটি পুকুরে ঢিল ফেলে সৃষ্ট ঢেউয়ের মতো — কিন্তু বিশেষত্ব হলো, পানির ঢেউ ভ্রমণে পানি (মাধ্যম) প্রয়োজন, অথচ EM তরঙ্গ কোনো মাধ্যম ছাড়াই (যেমন মহাশূন্যের শূন্যতায়) ভ্রমণ করতে পারে — যেন ঢেউ নিজেই নিজের 'পুকুর' তৈরি করে নিচ্ছে।$Q3032$,
  $Q3033$রেডিও ও মোবাইল সিগন্যাল ট্রান্সমিশন, স্যাটেলাইট কমিউনিকেশন, এবং WiFi/ব্লুটুথ ডিভাইস ডিজাইনের ভিত্তি হিসেবে ব্যবহৃত হয়।$Q3033$,
  $Q3034$সূর্য থেকে সূর্যালোক প্রায় ৮ মিনিটে পৃথিবীতে পৌঁছায়, কারণ আলো (একটি EM তরঙ্গ) শূন্যস্থান দিয়ে প্রায় ৩×১০⁸ মিটার/সেকেন্ড গতিতে ভ্রমণ করে, কোনো মাধ্যমের প্রয়োজন ছাড়াই।$Q3034$,
  $Q3035$মহাশূন্যে তরঙ্গের গতি: c = 1/√(μ₀ε₀) ≈ 3×10⁸ m/s। মাধ্যমে গতি কমে যায়: v = c/√(εᵣμᵣ) (εᵣ, μᵣ = আপেক্ষিক পারমিটিভিটি ও পারমিয়াবিলিটি)। E ও H ফিল্ড এবং প্রোপাগেশন দিক পরস্পর লম্ব (Transverse Wave)।$Q3035$,
  $Q3036$রেডিও, টিভি ও মোবাইল সিগন্যাল ট্রান্সমিশন, স্যাটেলাইট ও GPS কমিউনিকেশন, এবং WiFi/ব্লুটুথ ওয়্যারলেস ডিভাইসে ব্যবহৃত হয়।$Q3036$,
  ARRAY[$Q3037$Wave Physics$Q3037$,$Q3038$Transverse Wave$Q3038$,$Q3039$Wireless Communication$Q3039$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3040$Skin Effect$Q3040$,
  $Q3041$S$Q3041$,
  $Q3042$electromagnetic$Q3042$,
  $Q3043$Hayt, Ch.11$Q3043$,
  $Q3044$medium$Q3044$,
  $Q3045$wire$Q3045$,
  $Q3046$উচ্চ-ফ্রিকোয়েন্সিতে কারেন্ট পরিবাহীর পৃষ্ঠে কেন্দ্রীভূত হওয়া$Q3046$,
  $Q3047$Skin Effect হলো একটি ঘটনা, যেখানে উচ্চ-ফ্রিকোয়েন্সি AC কারেন্ট একটি পরিবাহীর কেন্দ্রের বদলে তার বাইরের পৃষ্ঠের (skin) কাছাকাছি কেন্দ্রীভূত হয়ে প্রবাহিত হতে থাকে — ফ্রিকোয়েন্সি যত বেশি, এই কেন্দ্রীভবন তত তীব্র হয়, যা কার্যকর রেজিস্ট্যান্স বাড়িয়ে দেয়।$Q3047$,
  $Q3048$🏊 জনাকীর্ণ সুইমিং পুলের পাড়ের কাছে সাঁতার কাটার মতো — যখন পুল খুব ভিড় থাকে (উচ্চ ফ্রিকোয়েন্সি), মানুষ (কারেন্ট) কেন্দ্রের বদলে পাড়ের কাছাকাছি (পরিবাহীর পৃষ্ঠে) সাঁতার কাটতে বাধ্য হয়, কেন্দ্রের জায়গা কার্যত অব্যবহৃত থেকে যায়।$Q3048$,
  $Q3049$উচ্চ-ফ্রিকোয়েন্সি ট্রান্সমিশন লাইন ও RF সার্কিট ডিজাইনে কন্ডাক্টর নির্বাচনে (যেমন লিটজ ওয়্যার ব্যবহার) বিবেচনা করা হয়।$Q3049$,
  $Q3050$উচ্চ-ফ্রিকোয়েন্সি ট্রান্সফরমার ও ইনডাক্টর ডিজাইনে সলিড তারের বদলে 'Litz Wire' (অনেকগুলো পাতলা, পৃথকভাবে ইনসুলেটেড তারের সমন্বয়) ব্যবহার করা হয়, যা Skin Effect-এর কারণে সৃষ্ট অতিরিক্ত রেজিস্ট্যান্স কমায়।$Q3050$,
  $Q3051$Skin Depth δ = √(2/(ωμσ)) (ω = কৌণিক ফ্রিকোয়েন্সি, μ = পারমিয়াবিলিটি, σ = কন্ডাক্টিভিটি) — যত বেশি ফ্রিকোয়েন্সি, δ তত কম (কারেন্ট আরও পাতলা পৃষ্ঠস্তরে সীমাবদ্ধ), ফলে কার্যকর রেজিস্ট্যান্স R বেড়ে যায়।$Q3051$,
  $Q3052$উচ্চ-ভোল্টেজ ট্রান্সমিশন লাইনে হলো (hollow) কন্ডাক্টর ব্যবহার, RF ও মাইক্রোওয়েভ সার্কিট ডিজাইন, এবং উচ্চ-ফ্রিকোয়েন্সি ট্রান্সফরমার ওয়াইন্ডিং ডিজাইনে বিবেচনা করা হয়।$Q3052$,
  ARRAY[$Q3053$High-Frequency Effect$Q3053$,$Q3054$AC Resistance$Q3054$,$Q3055$Conductor Design$Q3055$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3056$Biot-Savart Law$Q3056$,
  $Q3057$B$Q3057$,
  $Q3058$electromagnetic$Q3058$,
  $Q3059$Hayt, Ch.7$Q3059$,
  $Q3060$medium$Q3060$,
  $Q3061$formula$Q3061$,
  $Q3062$কারেন্ট উপাদান থেকে চৌম্বক ফিল্ড গণনার সূত্র$Q3062$,
  $Q3063$Biot-Savart Law একটি মৌলিক সূত্র, যা একটি অতি ক্ষুদ্র কারেন্ট-বহনকারী তারের অংশ (differential current element) থেকে যেকোনো বিন্দুতে সৃষ্ট চৌম্বক ফিল্ডের অবদান গণনা করে — যেকোনো আকৃতির (অসম্প্রতিসম) তারের সম্পূর্ণ চৌম্বক ফিল্ড বের করতে এই সূত্রকে পুরো তার বরাবর ইন্টিগ্রেট করতে হয়।$Q3063$,
  $Q3064$🧩 একটি বড় ছবি তৈরিতে ছোট ছোট পিক্সেল যোগ করার মতো — সরাসরি একটি জটিল আকৃতির তারের মোট ফিল্ড বের করা কঠিন, তাই তারকে অসংখ্য ছোট ছোট টুকরায় (differential element) ভেঙে প্রতিটির অবদান আলাদাভাবে হিসাব করে সব যোগ (ইন্টিগ্রেট) করা হয়।$Q3064$,
  $Q3065$অসম্প্রতিসম আকৃতির কয়েল ও তারের চৌম্বক ফিল্ড গণনায় (যেখানে Ampere's Law সরাসরি প্রযোজ্য নয়) ব্যবহৃত হয়।$Q3065$,
  $Q3066$একটি বৃত্তাকার কয়েলের কেন্দ্রে চৌম্বক ফিল্ড গণনা করতে Biot-Savart Law প্রয়োগ করে দেখানো হয় যে B = μ₀I/(2R) (R = কয়েলের ব্যাসার্ধ), যা কয়েলের প্রতিটি ক্ষুদ্র অংশের অবদান যোগ করে পাওয়া যায়।$Q3066$,
  $Q3067$dB = (μ₀/4π) × (I dl×r̂)/r² (I dl = differential current element, r = পর্যবেক্ষণ বিন্দুর দূরত্ব)। সম্পূর্ণ তারের ফিল্ড পেতে এই সমীকরণকে পুরো তার বরাবর ইন্টিগ্রেট করতে হয়।$Q3067$,
  $Q3068$কয়েল ও ইনডাক্টর ডিজাইন, ইলেকট্রোম্যাগনেট গণনা, এবং জটিল আকৃতির কারেন্ট-বহনকারী কন্ডাক্টরের চৌম্বক ফিল্ড বিশ্লেষণে ব্যবহৃত হয়।$Q3068$,
  ARRAY[$Q3069$Magnetic Field Calculation$Q3069$,$Q3070$Current Element$Q3070$,$Q3071$Differential Field$Q3071$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3072$Electrostatic Potential$Q3072$,
  $Q3073$E$Q3073$,
  $Q3074$electromagnetic$Q3074$,
  $Q3075$Hayt, Ch.4$Q3075$,
  $Q3076$high$Q3076$,
  $Q3077$gauge$Q3077$,
  $Q3078$একক চার্জকে সরাতে প্রয়োজনীয় কাজ$Q3078$,
  $Q3079$Electrostatic Potential (V) হলো একটি বিন্দুতে একক ধনাত্মক চার্জকে অসীম দূরত্ব (রেফারেন্স পয়েন্ট) থেকে সেই বিন্দুতে আনতে যে পরিমাণ কাজ (energy per unit charge) করতে হয় তার পরিমাপ — এটি একটি স্কেলার রাশি, যা Electric Field-এর তুলনায় গাণিতিকভাবে সহজে ব্যবহারযোগ্য।$Q3079$,
  $Q3080$⛰️ একটি পাহাড়ের উচ্চতার মতো — Electric Field হলো ঢালের খাড়াই (steepness, ভেক্টর, দিকসহ), আর Electrostatic Potential হলো সেই বিন্দুর উচ্চতা (স্কেলার, শুধু একটি সংখ্যা) — উচ্চতার পার্থক্য (ভোল্টেজ) জানলেই বল ছাড়াই কাজ হিসাব করা যায়।$Q3080$,
  $Q3081$সার্কিট বিশ্লেষণে ভোল্টেজ ধারণার তাত্ত্বিক ভিত্তি, এবং ক্যাপাসিটর ও ইলেকট্রনিক ডিভাইস ডিজাইনে ব্যবহৃত হয়।$Q3081$,
  $Q3082$একটি ব্যাটারির দুই টার্মিনালের মধ্যে Electrostatic Potential পার্থক্য (যেমন 1.5V) নির্ধারণ করে একক চার্জ সেই ব্যাটারি দিয়ে সার্কিটে প্রবাহিত হলে কতটা শক্তি (কাজ) স্থানান্তরিত হবে।$Q3082$,
  $Q3083$V = W/q (একক চার্জে কাজ)। E = −∇V (Electric Field হলো Potential-এর ঋণাত্মক গ্রেডিয়েন্ট) — অর্থাৎ ফিল্ড সবসময় Potential হ্রাসের দিকে নির্দেশ করে, ঠিক যেমন পানি উঁচু থেকে নিচু দিকে গড়িয়ে পড়ে।$Q3083$,
  $Q3084$সার্কিট ভোল্টেজ ধারণার ভিত্তি, ক্যাপাসিটর ডিজাইন, ইলেকট্রন মাইক্রোস্কোপে ত্বরণকারী ভোল্টেজ ডিজাইন, এবং হাই-ভোল্টেজ ইকুইপমেন্ট নিরাপত্তা বিশ্লেষণে ব্যবহৃত হয়।$Q3084$,
  ARRAY[$Q3085$Voltage$Q3085$,$Q3086$Scalar Field$Q3086$,$Q3087$Potential Energy$Q3087$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3088$Polarization (of EM Wave)$Q3088$,
  $Q3089$P$Q3089$,
  $Q3090$electromagnetic$Q3090$,
  $Q3091$Hayt, Ch.11$Q3091$,
  $Q3092$low$Q3092$,
  $Q3093$wavesine$Q3093$,
  $Q3094$ইলেকট্রিক ফিল্ড ভেক্টরের দোলনের দিক বিন্যাস$Q3094$,
  $Q3095$Polarization (of EM Wave) বর্ণনা করে একটি ইলেকট্রোম্যাগনেটিক তরঙ্গের ইলেকট্রিক ফিল্ড ভেক্টর কীভাবে ভ্রমণের সময় দোলিত হয় — Linear Polarization-এ ফিল্ড একটি নির্দিষ্ট সমতলে দোলে, Circular Polarization-এ ফিল্ড ভেক্টর প্রোপাগেশনের দিক বরাবর ঘুরতে থাকে।$Q3095$,
  $Q3096$🎾 একটি দড়িতে টেনিস বল বেঁধে দোলানোর মতো — যদি বলটি শুধু ওপর-নিচে দোলে (Linear), তাহলে দড়ির কম্পন একটি সমতলে সীমাবদ্ধ; কিন্তু যদি বলটি একটি বৃত্তাকার পথে ঘোরে (Circular), তাহলে কম্পন একটি সর্পিল আকৃতি তৈরি করে।$Q3096$,
  $Q3097$স্যাটেলাইট যোগাযোগে সিগন্যাল হস্তক্ষেপ কমাতে, পোলারাইজড সানগ্লাসে প্রতিফলিত আলোর ঝলক কমাতে, এবং WiFi/মোবাইল অ্যান্টেনা ডিজাইনে ব্যবহৃত হয়।$Q3097$,
  $Q3098$পোলারাইজড সানগ্লাস রাস্তা বা পানির পৃষ্ঠ থেকে প্রতিফলিত আলোর (যা একটি নির্দিষ্ট দিকে বেশি পোলারাইজড থাকে) তীব্রতা কমিয়ে দেয়, যা চোখের ঝলকানি কমায় এবং দৃষ্টি স্বচ্ছ করে।$Q3098$,
  $Q3099$একটি তরঙ্গের Polarization নির্ধারিত হয় দুটি পরস্পর লম্ব উপাদানের (E_x, E_y) ফেজ সম্পর্ক দ্বারা — সমান ফেজে Linear Polarization, 90° ফেজ পার্থক্যে ও সমান তীব্রতায় Circular Polarization তৈরি হয়।$Q3099$,
  $Q3100$স্যাটেলাইট ও রাডার কমিউনিকেশন (সিগন্যাল হস্তক্ষেপ প্রতিরোধ), পোলারাইজড ফটোগ্রাফি ফিল্টার ও সানগ্লাস, এবং LCD স্ক্রিন প্রযুক্তিতে ব্যবহৃত হয়।$Q3100$,
  ARRAY[$Q3101$Wave Property$Q3101$,$Q3102$Linear-Circular$Q3102$,$Q3103$Antenna Design$Q3103$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3104$Waveguide$Q3104$,
  $Q3105$W$Q3105$,
  $Q3106$electromagnetic$Q3106$,
  $Q3107$Hayt, Ch.13$Q3107$,
  $Q3108$low$Q3108$,
  $Q3109$tower$Q3109$,
  $Q3110$মাইক্রোওয়েভ পরিচালনার জন্য বিশেষ ধাতব নালী$Q3110$,
  $Q3111$Waveguide একটি ফাঁপা ধাতব নালী (সাধারণত আয়তাকার বা বৃত্তাকার), যা মাইক্রোওয়েভ ফ্রিকোয়েন্সির ইলেকট্রোম্যাগনেটিক তরঙ্গকে অভ্যন্তরীণ প্রতিফলনের মাধ্যমে নির্দেশিতভাবে পরিবহন করে — সাধারণ তারের চেয়ে উচ্চ-ফ্রিকোয়েন্সিতে অনেক কম ক্ষতি (loss) সহ শক্তি পরিবহন করতে সক্ষম।$Q3111$,
  $Q3112$🚇 একটি পানির পাইপ বা টানেলের মতো — সাধারণ তারে (খোলা রাস্তায়) উচ্চ-ফ্রিকোয়েন্সি শক্তি সহজেই 'পালিয়ে যায়' (বিকিরিত হয়ে নষ্ট হয়), কিন্তু একটি বদ্ধ ধাতব নালী (টানেল) সেই শক্তিকে ভেতরে আটকে রেখে নির্দিষ্ট গন্তব্যে দক্ষতার সাথে পৌঁছে দেয়।$Q3112$,
  $Q3113$রাডার সিস্টেম, স্যাটেলাইট গ্রাউন্ড স্টেশন, এবং মাইক্রোওয়েভ ওভেনে উচ্চ-ফ্রিকোয়েন্সি শক্তি পরিবহনে ব্যবহৃত হয়।$Q3113$,
  $Q3114$একটি মাইক্রোওয়েভ ওভেনে ম্যাগনেট্রন (মাইক্রোওয়েভ উৎস) থেকে তৈরি শক্তি একটি ছোট Waveguide দিয়ে সরাসরি খাবার রাখার চেম্বারে পরিবাহিত হয়, যেখানে এটি খাবার গরম করে।$Q3114$,
  $Q3115$একটি Waveguide-এর একটি Cutoff Frequency আছে, যার নিচে কোনো তরঙ্গ প্রোপাগেট করতে পারে না — এই ফ্রিকোয়েন্সি Waveguide-এর মাত্রা (dimension) দ্বারা নির্ধারিত হয়, যা সাধারণ তারের ক্যাবলে থাকে না।$Q3115$,
  $Q3116$রাডার ও স্যাটেলাইট আর্থ স্টেশন সিস্টেম, মাইক্রোওয়েভ ওভেন, এবং উচ্চ-ফ্রিকোয়েন্সি টেলিকমিউনিকেশন ইকুইপমেন্টে ব্যবহৃত হয়।$Q3116$,
  ARRAY[$Q3117$Microwave Transmission$Q3117$,$Q3118$Hollow Conductor$Q3118$,$Q3119$RF Engineering$Q3119$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3120$Boundary Conditions (EM)$Q3120$,
  $Q3121$B$Q3121$,
  $Q3122$electromagnetic$Q3122$,
  $Q3123$Hayt, Ch.5$Q3123$,
  $Q3124$low$Q3124$,
  $Q3125$fieldlines$Q3125$,
  $Q3126$দুই মাধ্যমের সীমানায় ফিল্ডের আচরণের নিয়ম$Q3126$,
  $Q3127$Boundary Conditions বর্ণনা করে দুটি ভিন্ন মাধ্যমের (যেমন বাতাস ও ডাইইলেকট্রিক, অথবা বাতাস ও পরিবাহী) সীমানায় ইলেকট্রিক ও ম্যাগনেটিক ফিল্ডের স্বাভাবিক (normal) ও স্পর্শক (tangential) উপাদান কীভাবে পরিবর্তিত বা সংরক্ষিত থাকে তার নিয়মাবলী — এটি Maxwell's Equations থেকে উদ্ভূত।$Q3127$,
  $Q3128$🚧 দুই দেশের সীমান্তের নিয়মের মতো — সীমান্ত পার হওয়ার সময় কিছু জিনিস (যেমন ভাষা, মুদ্রা) হঠাৎ পরিবর্তিত হয়, আবার কিছু জিনিস (যেমন ব্যক্তির পরিচয়) অপরিবর্তিত থাকে — একটি নির্দিষ্ট নিয়ম মেনে কী পরিবর্তিত হবে আর কী থাকবে তা নির্ধারিত হয়।$Q3128$,
  $Q3129$মাইক্রোস্ট্রিপ PCB ট্রান্সমিশন লাইন ডিজাইন, অপটিক্যাল ফাইবার ডিজাইন (আলোর প্রতিফলন-প্রতিসরণ), এবং অ্যান্টেনা ডিজাইনে ব্যবহৃত হয়।$Q3129$,
  $Q3130$যখন আলো (EM তরঙ্গ) বাতাস থেকে কাচে প্রবেশ করে, Boundary Conditions ব্যবহার করে ইঞ্জিনিয়াররা নির্ধারণ করেন কতটা আলো প্রতিফলিত হবে এবং কতটা প্রতিসরিত (refract) হয়ে ভেতরে যাবে।$Q3130$,
  $Q3131$একটি আদর্শ পরিবাহীর পৃষ্ঠে: স্পর্শক E-ফিল্ড শূন্য (E_tan=0), স্বাভাবিক B-ফিল্ড শূন্য (B_normal=0)। দুই ডাইইলেকট্রিকের সীমানায়: স্পর্শক E ও স্বাভাবিক D ধারাবাহিক থাকে (কোনো মুক্ত চার্জ না থাকলে)।$Q3131$,
  $Q3132$মাইক্রোস্ট্রিপ ও PCB ট্রান্সমিশন লাইন ডিজাইন, ফাইবার অপটিক তারের প্রতিফলন বিশ্লেষণ, এবং অ্যান্টেনা রেডিয়েশন ডিজাইনে ব্যবহৃত হয়।$Q3132$,
  ARRAY[$Q3133$Interface Condition$Q3133$,$Q3134$Field Continuity$Q3134$,$Q3135$Dielectric Boundary$Q3135$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3136$Divergence Theorem$Q3136$,
  $Q3137$D$Q3137$,
  $Q3138$electromagnetic$Q3138$,
  $Q3139$Hayt, Ch.3$Q3139$,
  $Q3140$low$Q3140$,
  $Q3141$formula$Q3141$,
  $Q3142$আয়তন ও পৃষ্ঠ ইন্টিগ্রেলের মধ্যে গাণিতিক সেতু$Q3142$,
  $Q3143$Divergence Theorem (Gauss's Divergence Theorem) একটি গাণিতিক উপপাদ্য, যা একটি ভেক্টর ফিল্ডের একটি বদ্ধ পৃষ্ঠের মধ্য দিয়ে মোট ফ্লাক্সকে (surface integral) সেই পৃষ্ঠের ভেতরে আবদ্ধ আয়তনে ফিল্ডের ডাইভারজেন্সের ইন্টিগ্রেলের (volume integral) সাথে সমতুল্য করে — এটি Gauss's Law-এর Integral ও Differential রূপের মধ্যে সেতুবন্ধন তৈরি করে।$Q3143$,
  $Q3144$🏭 একটি কারখানার মোট উৎপাদনের হিসাবের মতো — কারখানার বাইরের গেট দিয়ে মোট কতটা পণ্য বের হচ্ছে (পৃষ্ঠ ইন্টিগ্রেল) তা হিসাব করার বদলে, ভেতরের প্রতিটি মেশিন কতটা পণ্য তৈরি করছে (আয়তন ইন্টিগ্রেল) তা যোগ করেও একই মোট উৎপাদন পাওয়া যায়।$Q3144$,
  $Q3145$Maxwell's Equations-এর Integral রূপ থেকে Differential রূপে রূপান্তরে, এবং জটিল ফ্লাক্স সমস্যা সরলীকরণে ব্যবহৃত হয়।$Q3145$,
  $Q3146$Gauss's Law-এর Integral রূপ (∮E·dA = Q/ε₀) থেকে Differential রূপ (∇·E = ρ/ε₀) বের করতে Divergence Theorem ব্যবহার করা হয়, যা ইলেকট্রোম্যাগনেটিক তত্ত্বের অনেক গাণিতিক প্রমাণে ব্যবহৃত একটি মূল হাতিয়ার।$Q3146$,
  $Q3147$∮∮F·dA = ∭(∇·F)dV (একটি ভেক্টর ফিল্ড F-এর জন্য, বদ্ধ পৃষ্ঠ S ও আবদ্ধ আয়তন V-এর মধ্যে)। এই উপপাদ্য ফ্লুইড ডাইনামিক্স, তাপ পরিবহন এবং ইলেকট্রোম্যাগনেটিজম — সব ক্ষেত্রেই ব্যবহৃত হয়।$Q3147$,
  $Q3148$Maxwell's Equations-এর গাণিতিক ডেরিভেশন, ইলেকট্রোম্যাগনেটিক সিমুলেশন সফটওয়্যারের অভ্যন্তরীণ গণনা, এবং তাত্ত্বিক পদার্থবিজ্ঞান শিক্ষায় ব্যবহৃত হয়।$Q3148$,
  ARRAY[$Q3149$Vector Calculus$Q3149$,$Q3150$Mathematical Tool$Q3150$,$Q3151$Gauss's Law Derivation$Q3151$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3152$Curl$Q3152$,
  $Q3153$C$Q3153$,
  $Q3154$electromagnetic$Q3154$,
  $Q3155$Hayt, Ch.8$Q3155$,
  $Q3156$low$Q3156$,
  $Q3157$loop$Q3157$,
  $Q3158$একটি ভেক্টর ফিল্ডের ঘূর্ণন প্রবণতার পরিমাপ$Q3158$,
  $Q3159$Curl (∇×F) হলো একটি ভেক্টর অপারেটর, যা একটি ভেক্টর ফিল্ডের প্রতিটি বিন্দুতে 'ঘূর্ণন' বা 'দোলন' প্রবণতার পরিমাণ ও দিক পরিমাপ করে — Faraday's Law ও Ampere's Law-এর Differential রূপে এটি একটি কেন্দ্রীয় গাণিতিক অপারেটর হিসেবে ব্যবহৃত হয়।$Q3159$,
  $Q3160$🌀 পানিতে একটি ছোট প্যাডেল হুইল রাখার মতো — যদি পানির প্রবাহে কোনো ঘূর্ণন প্রবণতা থাকে (যেমন একটি ঘূর্ণিতে), প্যাডেল হুইল নিজে থেকে ঘুরতে শুরু করবে — Curl সেই 'ঘোরার প্রবণতা' কতটা তীব্র তা পরিমাপ করে।$Q3160$,
  $Q3161$Maxwell's Equations-এর Differential রূপ প্রকাশে, এবং ইলেকট্রিক ও ম্যাগনেটিক ফিল্ডের স্থানীয় (local) আচরণ বিশ্লেষণে ব্যবহৃত হয়।$Q3161$,
  $Q3162$Faraday's Law-এর Differential রূপ (∇×E = −∂B/∂t) ব্যবহার করে বোঝা যায় যে একটি স্থানে পরিবর্তনশীল চৌম্বক ফিল্ড থাকলে সেখানে ইলেকট্রিক ফিল্ডের একটি 'ঘূর্ণনশীল' (curl-যুক্ত) উপাদান তৈরি হবে, যা একটি বদ্ধ লুপে EMF তৈরি করে।$Q3162$,
  $Q3163$একটি Conservative Field-এর (যেমন স্থির চার্জের ইলেকট্রিক ফিল্ড) Curl সবসময় শূন্য (∇×E=0, স্ট্যাটিক ক্ষেত্রে)। কিন্তু পরিবর্তনশীল চৌম্বক ফিল্ড থাকলে (∇×E=−∂B/∂t), ফিল্ড আর Conservative থাকে না।$Q3163$,
  $Q3164$ইলেকট্রোম্যাগনেটিক ফিল্ড সিমুলেশন সফটওয়্যার, তাত্ত্বিক পদার্থবিজ্ঞান গবেষণা, এবং ফ্লুইড ডাইনামিক্সে ঘূর্ণি (vortex) বিশ্লেষণে ব্যবহৃত হয়।$Q3164$,
  ARRAY[$Q3165$Vector Calculus$Q3165$,$Q3166$Rotational Field$Q3166$,$Q3167$Maxwell's Equations$Q3167$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3168$Inductance (self & mutual)$Q3168$,
  $Q3169$I$Q3169$,
  $Q3170$electromagnetic$Q3170$,
  $Q3171$Hayt, Ch.9$Q3171$,
  $Q3172$medium$Q3172$,
  $Q3173$inductor$Q3173$,
  $Q3174$কারেন্টের পরিবর্তনে EMF সৃষ্টির ক্ষমতা$Q3174$,
  $Q3175$Self-Inductance (L) হলো একটি কয়েলের নিজের মধ্য দিয়ে প্রবাহিত কারেন্ট পরিবর্তনের ফলে নিজের মধ্যেই EMF সৃষ্টি করার ক্ষমতা। Mutual Inductance (M) হলো একটি কয়েলের কারেন্ট পরিবর্তনের ফলে কাছাকাছি অবস্থিত দ্বিতীয় একটি কয়েলে EMF সৃষ্টির ক্ষমতা — ট্রান্সফরমারের কার্যনীতি এই দ্বিতীয় ধারণার ওপর ভিত্তি করে গঠিত।$Q3175$,
  $Q3176$🔔🔔 দুটি সংযুক্ত ঘণ্টার মতো — একটি ঘণ্টা (কয়েল) নিজে বাজলে নিজের মধ্যেই একটি প্রতিক্রিয়া তৈরি হয় (Self-Inductance), কিন্তু যদি এর কম্পন কাছের আরেকটি ঘণ্টাকেও (দ্বিতীয় কয়েল) কাঁপিয়ে দেয়, সেটাই Mutual Inductance।$Q3176$,
  $Q3177$ইনডাক্টর ও ট্রান্সফরমার ডিজাইন, ওয়্যারলেস চার্জিং প্রযুক্তি, এবং RFID/NFC কার্ড রিডার ডিজাইনে ব্যবহৃত হয়।$Q3177$,
  $Q3178$একটি ওয়্যারলেস ফোন চার্জারে চার্জিং প্যাডের কয়েল (প্রাইমারি) এবং ফোনের ভেতরের কয়েল (সেকেন্ডারি)-এর মধ্যে Mutual Inductance-এর কারণে তারবিহীনভাবে বিদ্যুৎ শক্তি স্থানান্তরিত হয়।$Q3178$,
  $Q3179$Self-Inductance: EMF = −L(dI/dt)। Mutual Inductance: EMF₂ = −M(dI₁/dt)। Coupling Coefficient k = M/√(L₁L₂) (0≤k≤1) — k=1 হলে নিখুঁত কাপলিং (আদর্শ ট্রান্সফরমার), k যত কম, শক্তি স্থানান্তর তত কম দক্ষ।$Q3179$,
  $Q3180$পাওয়ার ট্রান্সফরমার, ওয়্যারলেস চার্জিং প্যাড, RFID ও NFC প্রযুক্তি, এবং ইনডাকশন কুকটপে ব্যবহৃত হয়।$Q3180$,
  ARRAY[$Q3181$Coil Property$Q3181$,$Q3182$Transformer Basis$Q3182$,$Q3183$Wireless Power$Q3183$]
)
ON CONFLICT (term) DO NOTHING;

INSERT INTO public.eee_terms (term, letter, subject, book, importance, icon, short, definition, analogy, use_case, example, relation, application, tags) VALUES (
  $Q3184$Capacitance (parallel plate)$Q3184$,
  $Q3185$C$Q3185$,
  $Q3186$electromagnetic$Q3186$,
  $Q3187$Hayt, Ch.6$Q3187$,
  $Q3188$medium$Q3188$,
  $Q3189$capacitor$Q3189$,
  $Q3190$দুই সমান্তরাল প্লেটের চার্জ ধারণ ক্ষমতা$Q3190$,
  $Q3191$Parallel Plate Capacitance হলো দুটি সমান্তরাল পরিবাহী প্লেটের মধ্যে একটি ডাইইলেকট্রিক দিয়ে গঠিত সবচেয়ে সরল ক্যাপাসিটর গঠনের চার্জ ধারণ ক্ষমতা, যা প্লেটের ক্ষেত্রফল, তাদের মধ্যকার দূরত্ব এবং ডাইইলেকট্রিক উপাদানের বৈশিষ্ট্যের ওপর নির্ভর করে।$Q3191$,
  $Q3192$🥞 দুটি সমান্তরাল প্যানকেকের মধ্যে সিরাপ রাখার মতো — প্যানকেক (প্লেট) যত বড়, তত বেশি সিরাপ (চার্জ) ধরে রাখা যায়; প্যানকেক দুটো যত কাছাকাছি, তত বেশি সিরাপ ধরে রাখার ক্ষমতা বাড়ে — এবং মাঝের উপাদান (ডাইইলেকট্রিক) কেমন তার ওপরও নির্ভর করে।$Q3192$,
  $Q3193$ক্যাপাসিটর ডিজাইনে মৌলিক গণনা, এবং টাচস্ক্রিন প্রযুক্তি (আঙুল কাছে এলে ক্যাপাসিট্যান্স পরিবর্তন সনাক্তকরণ) ডিজাইনে ব্যবহৃত হয়।$Q3193$,
  $Q3194$একটি ক্যাপাসিটিভ টাচস্ক্রিনে আঙুল স্ক্রিনের কাছে এলে, আঙুল ও স্ক্রিনের সেন্সর মিলে একটি ছোট 'ক্যাপাসিটর' তৈরি হয়, যার ক্যাপাসিট্যান্স পরিবর্তন সনাক্ত করে ফোন বুঝতে পারে ঠিক কোথায় স্পর্শ করা হয়েছে।$Q3194$,
  $Q3195$C = εA/d (ε = ডাইইলেকট্রিক পারমিটিভিটি, A = প্লেটের ক্ষেত্রফল, d = প্লেটের মধ্যকার দূরত্ব)। বড় ক্ষেত্রফল বা কম দূরত্ব বেশি ক্যাপাসিট্যান্স দেয়; উচ্চ-পারমিটিভিটি ডাইইলেকট্রিক ব্যবহার করেও ক্যাপাসিট্যান্স বাড়ানো যায়।$Q3195$,
  $Q3196$স্মার্টফোন ক্যাপাসিটিভ টাচস্ক্রিন, ইলেকট্রনিক ক্যাপাসিটর ডিজাইন, মাইক্রোফোন (কনডেনসার মাইক্রোফোন ক্যাপাসিট্যান্স পরিবর্তন ব্যবহার করে), এবং প্রেসার সেন্সরে ব্যবহৃত হয়।$Q3196$,
  ARRAY[$Q3197$Parallel Plate Formula$Q3197$,$Q3198$Dielectric$Q3198$,$Q3199$Touchscreen Technology$Q3199$]
)
ON CONFLICT (term) DO NOTHING;


-- Done. Verify with: SELECT COUNT(*) FROM public.eee_terms;
