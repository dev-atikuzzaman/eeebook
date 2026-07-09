import React from "react";

// প্রতিটি টার্মের জন্য হাতে-আঁকা সরলীকৃত ইঞ্জিনিয়ারিং সিম্বল/আইকন —
// কোনো স্টক ফটো নয়, স্বচ্ছ ভেক্টর আর্ট, তাই অফলাইনেও নিখুঁতভাবে কাজ করে।
const ICONS = {
  resistor: (
    <path d="M2 12h3l1.5-4 3 8 3-8 3 8 3-8 1.5 4h3" />
  ),
  capacitor: (
    <>
      <path d="M2 12h8" />
      <path d="M10 5v14" />
      <path d="M14 5v14" />
      <path d="M14 12h8" />
    </>
  ),
  inductor: (
    <path d="M2 12h2c0-6 4-6 4 0s4 6 4 0 4-6 4 0 4 6 4 0h2" />
  ),
  diode: (
    <>
      <path d="M2 12h6" />
      <path d="M8 6l8 6-8 6z" fill="currentColor" stroke="none" />
      <path d="M16 6v12" />
      <path d="M16 12h6" />
    </>
  ),
  zener: (
    <>
      <path d="M2 12h6" />
      <path d="M8 6l8 6-8 6z" fill="currentColor" stroke="none" />
      <path d="M13.5 6h2.5v12h2.5" />
      <path d="M16 12h6" />
    </>
  ),
  bjt: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M8 7v10" />
      <path d="M2 12h6" />
      <path d="M8 10l7-5v5" />
      <path d="M8 14l7 5-2-5.5" />
    </>
  ),
  mosfet: (
    <>
      <path d="M9 5v14" />
      <path d="M12 8v3M12 13v3" />
      <path d="M2 6.5h7" />
      <path d="M2 17.5h7" />
      <path d="M12 9.5h4v-4h6" />
      <path d="M12 14.5h4v4h6" />
      <path d="M12 12h4" />
    </>
  ),
  opamp: (
    <>
      <path d="M6 5v14l13-7z" />
      <path d="M2 8h4" />
      <path d="M2 16h4" />
      <path d="M19 12h3" />
      <text x="7.5" y="10" fontSize="5" stroke="none" fill="currentColor">−</text>
      <text x="7.5" y="17" fontSize="5" stroke="none" fill="currentColor">+</text>
    </>
  ),
  transformer: (
    <>
      <path d="M2 6c0-1 2-1 2 0s-2 1-2 2 2 1 2 2-2 1-2 2 2 1 2 2-2 1-2 2" />
      <path d="M11 5v14M14 5v14" strokeDasharray="2 2" />
      <path d="M22 6c0-1-2-1-2 0s2 1 2 2-2 1-2 2 2 1 2 2-2 1-2 2 2 1 2 2" />
    </>
  ),
  battery: (
    <>
      <path d="M2 12h5" />
      <path d="M7 6v12" />
      <path d="M10 9v6" />
      <path d="M13 6v12" />
      <path d="M16 9v6" />
      <path d="M19 12h3" />
    </>
  ),
  ground: (
    <>
      <path d="M12 3v9" />
      <path d="M5 12h14" />
      <path d="M7.5 16h9" />
      <path d="M10 20h4" />
    </>
  ),
  switch: (
    <>
      <circle cx="5" cy="16" r="1.6" fill="currentColor" stroke="none" />
      <circle cx="19" cy="16" r="1.6" fill="currentColor" stroke="none" />
      <path d="M2 16h3" />
      <path d="M19 16h3" />
      <path d="M6.5 15.3l11-7" />
    </>
  ),
  motor: (
    <>
      <circle cx="12" cy="12" r="9" />
      <text x="8" y="16" fontSize="10" fontWeight="700" stroke="none" fill="currentColor">M</text>
    </>
  ),
  generator: (
    <>
      <circle cx="12" cy="12" r="9" />
      <text x="7.7" y="16" fontSize="10" fontWeight="700" stroke="none" fill="currentColor">G</text>
    </>
  ),
  antenna: (
    <>
      <path d="M12 22V10" />
      <path d="M12 3v3" />
      <path d="M7 9c1.5-3 3.3-4.5 5-4.5" />
      <path d="M17 9c-1.5-3-3.3-4.5-5-4.5" />
      <path d="M4 12c2-5 5-8 8-8" />
      <path d="M20 12c-2-5-5-8-8-8" />
    </>
  ),
  wavesine: (
    <path d="M2 12c2-7 4-7 5 0s3 7 5 0 3-7 5 0 3 7 5 0" />
  ),
  wavesquare: (
    <path d="M2 17h4V7h4v10h4V7h4v10h4" />
  ),
  gate: (
    <>
      <path d="M5 5v14h4a7 7 0 000-14z" />
      <path d="M2 8h3M2 16h3" />
      <path d="M19 12h3" />
    </>
  ),
  flipflop: (
    <>
      <rect x="5" y="4" width="14" height="16" rx="1" />
      <path d="M5 15l3-3-3-3" />
      <text x="8.4" y="10.5" fontSize="4.5" stroke="none" fill="currentColor">Q</text>
      <text x="14" y="10.5" fontSize="4.5" stroke="none" fill="currentColor">D</text>
    </>
  ),
  blockdiagram: (
    <>
      <rect x="2" y="8" width="7" height="8" rx="1" />
      <rect x="15" y="8" width="7" height="8" rx="1" />
      <path d="M9 12h6" />
      <path d="M13.5 9.5L15 12l-1.5 2.5" />
    </>
  ),
  waveform: (
    <path d="M2 12h4l2-8 3 16 2-11 2 6h3l2-5 2 2" />
  ),
  phasor: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 12l6-4.5" />
      <path d="M15.5 6.7l2.5.8.8-2.5" />
    </>
  ),
  fieldlines: (
    <>
      <circle cx="12" cy="12" r="1.8" fill="currentColor" stroke="none" />
      <circle cx="12" cy="12" r="5.5" strokeDasharray="3 3" />
      <circle cx="12" cy="12" r="9.5" strokeDasharray="3 3" />
    </>
  ),
  bridge: (
    <>
      <path d="M12 2v6M12 16v6M2 12h6M16 12h6" />
      <path d="M8 8l3 3-3 1z" fill="currentColor" stroke="none" />
      <path d="M16 8l-3 3 3 1z" fill="currentColor" stroke="none" />
      <path d="M8 16l3-3-3-1z" fill="currentColor" stroke="none" />
      <path d="M16 16l-3-3 3-1z" fill="currentColor" stroke="none" />
    </>
  ),
  thyristor: (
    <>
      <path d="M2 12h6" />
      <path d="M8 6l8 6-8 6z" fill="currentColor" stroke="none" />
      <path d="M16 6v12" />
      <path d="M16 12h6" />
      <path d="M12 12l4 5" />
    </>
  ),
  chip: (
    <>
      <rect x="6" y="5" width="12" height="14" rx="1.5" />
      <path d="M2 8h4M2 12h4M2 16h4" />
      <path d="M18 8h4M18 12h4M18 16h4" />
    </>
  ),
  scope: (
    <>
      <rect x="2" y="3" width="20" height="14" rx="1.5" />
      <path d="M4 12c2-5 3-5 5 0s3 5 5 0 3-5 5 0" />
      <path d="M6 20h2M11 20h2M16 20h2" />
    </>
  ),
  bulb: (
    <>
      <circle cx="12" cy="10" r="6.5" />
      <path d="M9 10a3 3 0 016 0" />
      <path d="M10 16.5h4" />
      <path d="M10.5 19.5h3" />
    </>
  ),
  tower: (
    <>
      <path d="M12 2l7 20M12 2L5 22" />
      <path d="M8.5 11h7M7 15.5h10M9.8 6.7h4.4" />
      <path d="M4 22h16" />
    </>
  ),
  satellite: (
    <>
      <rect x="9.5" y="9.5" width="5" height="5" rx="0.8" />
      <path d="M2 6l5 5M2 12l3-3" />
      <path d="M22 6l-5 5M22 12l-3-3" />
      <path d="M9.5 9.5L5 5M14.5 9.5L19 5" />
      <circle cx="12" cy="19" r="2" />
      <path d="M12 14.5V17" />
    </>
  ),
  binary: (
    <>
      <text x="2" y="10" fontSize="8" fontWeight="700" stroke="none" fill="currentColor">01</text>
      <text x="11" y="20" fontSize="8" fontWeight="700" stroke="none" fill="currentColor">10</text>
    </>
  ),
  formula: (
    <text x="4" y="19" fontSize="18" fontWeight="700" stroke="none" fill="currentColor">∑</text>
  ),
  feedbackloop: (
    <>
      <rect x="8" y="8" width="8" height="8" rx="1" />
      <path d="M16 10h3V4H8v4" />
      <path d="M9.5 2.5L8 4l1.5 1.5" />
      <path d="M8 14H5v6h11v-4" />
      <path d="M14.5 21.5L16 20l-1.5-1.5" />
    </>
  ),
  filter: (
    <path d="M3 4h18l-7 8v7l-4-2v-5z" />
  ),
  gauge: (
    <>
      <path d="M3 16a9 9 0 0118 0" />
      <path d="M12 16l5-6" />
      <circle cx="12" cy="16" r="1.3" fill="currentColor" stroke="none" />
      <path d="M3 16h1.5M19.5 16H21M6 9l1 1M18 9l-1 1" />
    </>
  ),
  magnet: (
    <>
      <path d="M6 4v9a6 6 0 0012 0V4" />
      <path d="M6 4h4v9a2 2 0 01-4 0z" fill="currentColor" stroke="none" />
      <path d="M18 4h-4v9a2 2 0 004 0z" />
    </>
  ),
  network: (
    <>
      <circle cx="5" cy="6" r="2.2" />
      <circle cx="19" cy="6" r="2.2" />
      <circle cx="12" cy="13" r="2.2" />
      <circle cx="5" cy="19" r="2.2" />
      <circle cx="19" cy="19" r="2.2" />
      <path d="M6.6 7.6L10.4 11.6M17.4 7.6L13.6 11.6M6.6 17.4L10.4 14.4M17.4 17.4L13.6 14.4" />
    </>
  ),
  orbit: (
    <>
      <circle cx="12" cy="12" r="2" fill="currentColor" stroke="none" />
      <ellipse cx="12" cy="12" rx="10" ry="4.2" transform="rotate(-20 12 12)" />
      <circle cx="20.3" cy="8.4" r="1.4" fill="currentColor" stroke="none" />
    </>
  ),
  pwm: (
    <path d="M2 17h2V7h3v10h1V9h3v8h1V6h3v11h1V8h3v9h2" />
  ),
  register: (
    <>
      <rect x="2" y="8" width="4.4" height="8" rx="0.6" />
      <rect x="7.4" y="8" width="4.4" height="8" rx="0.6" />
      <rect x="12.8" y="8" width="4.4" height="8" rx="0.6" />
      <rect x="18.2" y="8" width="3.6" height="8" rx="0.6" />
    </>
  ),
  junction: (
    <>
      <circle cx="12" cy="12" r="1.8" fill="currentColor" stroke="none" />
      <path d="M12 2v7M12 15v7M2 12h7M15 12h7" />
    </>
  ),
  loop: (
    <>
      <path d="M5 12a7 7 0 1114 0 7 7 0 01-11.5 5.3" />
      <path d="M4 14.5l3 3-3 1z" fill="currentColor" stroke="none" />
    </>
  ),
  wire: (
    <>
      <path d="M2 12h6" />
      <circle cx="12" cy="12" r="2" />
      <path d="M14 12h8" />
    </>
  ),
  triac: (
    <>
      <path d="M2 12h5" />
      <path d="M7 6l7 6-7 6z" />
      <path d="M22 12h-5" />
      <path d="M17 18l-7-6 7-6z" />
      <path d="M12 3v3M12 18v3" />
    </>
  ),
  clock: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="M12 7v5l3.5 2" />
    </>
  ),
  cloud: (
    <path d="M7 18a4.5 4.5 0 01-.5-9 5.5 5.5 0 0110.8-1.5A4 4 0 0119 18H7z" />
  ),
  controller: (
    <>
      <rect x="3" y="4" width="18" height="16" rx="2" />
      <circle cx="8.5" cy="10" r="1.7" />
      <path d="M8.5 4.5v3.8M8.5 11.7v7.8" />
      <circle cx="15.5" cy="15" r="1.7" />
      <path d="M15.5 4.5v8.8M15.5 16.7v2.8" />
    </>
  ),
  converter: (
    <>
      <path d="M4 8h13" />
      <path d="M14 4.5L17.5 8 14 11.5" />
      <path d="M20 16H7" />
      <path d="M10 12.5L6.5 16 10 19.5" />
    </>
  ),
  counter: (
    <>
      <rect x="3" y="6" width="18" height="12" rx="1.5" />
      <path d="M9 6v12M15 6v12" />
      <text x="4.3" y="16" fontSize="7" stroke="none" fill="currentColor">1</text>
      <text x="10.3" y="16" fontSize="7" stroke="none" fill="currentColor">2</text>
      <text x="16.1" y="16" fontSize="7" stroke="none" fill="currentColor">3</text>
    </>
  ),
  decoder: (
    <>
      <path d="M4 6h6l4 6-4 6H4z" />
      <path d="M2 9h2M2 12h2M2 15h2" />
      <path d="M14 7h3M14 12h3M14 17h3" />
    </>
  ),
  encoder: (
    <>
      <path d="M20 6h-6l-4 6 4 6h6z" />
      <path d="M22 9h-2M22 12h-2M22 15h-2" />
      <path d="M10 7H7M10 12H7M10 17H7" />
    </>
  ),
  mux: (
    <>
      <path d="M6 5l-2 14h8l4-14z" />
      <path d="M1 8h3M1 12h3M1 16h3" />
      <path d="M17 12h5" />
    </>
  ),
  sensor: (
    <>
      <circle cx="9" cy="15" r="2.4" fill="currentColor" stroke="none" />
      <path d="M13 11a5.7 5.7 0 010 8" />
      <path d="M16 8a10 10 0 010 14" />
    </>
  ),
  spark: (
    <path d="M13 2L5 14h5l-1 8 9-13h-6z" fill="currentColor" stroke="none" />
  ),
  statemachine: (
    <>
      <circle cx="6" cy="12" r="4" />
      <circle cx="18" cy="12" r="4" />
      <path d="M9.7 10.5L14.3 10.5" />
      <path d="M13 8.8L14.6 10.5L13 12.2" />
      <path d="M3.2 9.3a4 4 0 010-4.6" />
    </>
  ),
  bode: (
    <>
      <path d="M3 3v18h18" />
      <path d="M3 8c4 0 5 0 8 4s5 4 10 4" />
    </>
  ),
  memory: (
    <>
      <rect x="3" y="4" width="18" height="16" rx="1.5" />
      <path d="M3 9h18M3 14h18M9 4v16M15 4v16" />
    </>
  ),
  adder: (
    <>
      <path d="M4 6l6 6-6 6" />
      <path d="M11 6l6 6-6 6" />
      <path d="M17 8v8M13 12h8" strokeWidth="1.4" />
    </>
  ),
  circuit: (
    <>
      <circle cx="6" cy="6" r="2.2" />
      <circle cx="18" cy="18" r="2.2" />
      <circle cx="18" cy="6" r="2.2" />
      <circle cx="6" cy="18" r="2.2" />
      <path d="M8.2 6h7.6M6 8.2v7.6M18 8.2v7.6M8.2 18h7.6" />
    </>
  ),
};

export default function Icon({ name, className = "w-6 h-6" }) {
  const content = ICONS[name] || ICONS.circuit;
  return (
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.6"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      aria-hidden="true"
    >
      {content}
    </svg>
  );
}
