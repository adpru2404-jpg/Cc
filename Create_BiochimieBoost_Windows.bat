@echo off
setlocal enabledelayedexpansion

REM Dossier de sortie (dans le même répertoire que ce .bat)
set ROOT=%~dp0BiochimieBoost

echo.
echo === Creation du projet BiochimieBoost ===
if exist "%ROOT%" (
  echo Le dossier existe deja, il sera ecrase/actualise.
) else (
  echo Creation du dossier...
)

REM Arborescence
mkdir "%ROOT%\src\components" 2>nul
mkdir "%ROOT%\src\pages" 2>nul
mkdir "%ROOT%\public" 2>nul

REM Ecriture des fichiers via PowerShell here-strings
powershell -NoProfile -Command ^
  "$p='%ROOT%\package.json'; ^
   @' {
  "name": "biochimieboost",
  "version": "1.0.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "framer-motion": "^11.2.6",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.1"
  },
  "devDependencies": {
    "autoprefixer": "^10.4.18",
    "postcss": "^8.4.35",
    "tailwindcss": "^3.4.3",
    "vite": "^5.2.0",
    "@vitejs/plugin-react": "^4.3.1"
  }
} '@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\index.html'; ^
   @'<!doctype html>
<html lang="fr">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" href="data:," />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>BiochimieBoost</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\postcss.config.js'; ^
   @'export default {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\tailwind.config.js'; ^
   @'export default {
  content: ["./index.html", "./src/**/*.{js,jsx}"],
  theme: {
    extend: {
      colors: {
        bleuNuit: "#0f172a",
        vertMenthe: "#3ef4a0",
        blancCasse: "#f5f5f4"
      },
    },
  },
  plugins: [],
};
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\vite.config.js'; ^
   @'import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()],
});
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\README.md'; ^
   @'# BiochimieBoost

Application React multipage (Vite + Tailwind) pour réviser la biochimie/chimie en français.

## Lancer en local
```bash
npm install
npm run dev
```

## Déploiement gratuit
- Vercel (recommandé) : https://vercel.com → Importer votre repo GitHub, ou utiliser l'app Vercel pour déployer le dossier.

## Sons
Placez des fichiers audio libres de droits dans `public/` en les nommant :
- `lofi.mp3` (musique de fond)
- `success.mp3` (bonne réponse)
- `click.mp3` (clic/erreur)

L’appli fonctionne même sans ces fichiers (pas d’audio).
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\index.css'; ^
   @'@tailwind base;
@tailwind components;
@tailwind utilities;

body {
  background-color: #0f172a;
  color: #f5f5f4;
  font-family: -apple-system, BlinkMacSystemFont, "Inter", Segoe UI, Roboto, Arial, sans-serif;
}

button {
  @apply px-4 py-2 rounded-lg transition-all duration-200;
}

button:hover {
  @apply scale-105;
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\main.jsx'; ^
   @'import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.jsx";
import "./index.css";

ReactDOM.createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\App.jsx'; ^
   @'import { BrowserRouter as Router, Routes, Route, Link } from "react-router-dom";
import { motion } from "framer-motion";
import Accueil from "./pages/Accueil.jsx";
import Module1 from "./pages/Module1.jsx";
import Module2 from "./pages/Module2.jsx";
import Module3 from "./pages/Module3.jsx";
import Module4 from "./pages/Module4.jsx";

export default function App() {
  return (
    <Router>
      <nav className="bg-bleuNuit text-vertMenthe p-4 flex flex-wrap gap-4 justify-center text-lg font-semibold shadow-md">
        <Link to="/">🏠 Accueil</Link>
        <Link to="/module1">🧬 Acides aminés</Link>
        <Link to="/module2">⚗️ Stéréochimie</Link>
        <Link to="/module3">🔬 Réactions</Link>
        <Link to="/module4">🧠 Synthèse</Link>
      </nav>

      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ duration: 0.5 }}
        className="p-6 max-w-4xl mx-auto"
      >
        <Routes>
          <Route path="/" element={<Accueil />} />
          <Route path="/module1" element={<Module1 />} />
          <Route path="/module2" element={<Module2 />} />
          <Route path="/module3" element={<Module3 />} />
          <Route path="/module4" element={<Module4 />} />
        </Routes>
      </motion.div>
    </Router>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\components\AudioPlayer.jsx'; ^
   @'import React, { useEffect } from "react";

export default function AudioPlayer({ src }) {
  useEffect(() => {
    const audio = new Audio(src);
    audio.loop = true;
    audio.volume = 0.25;
    audio.play().catch(() => {});
    return () => audio.pause();
  }, [src]);
  return null;
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\components\Quiz.jsx'; ^
   @'import React, { useState, useEffect } from "react";

export default function Quiz({ questions, storeKey }) {
  const [index, setIndex] = useState(0);
  const [score, setScore] = useState(0);
  const [finished, setFinished] = useState(false);
  const current = questions[index];

  useEffect(() => {
    const saved = localStorage.getItem(storeKey);
    if (saved) {
      try {
        const data = JSON.parse(saved);
        setIndex(data.index ?? 0);
        setScore(data.score ?? 0);
        setFinished(data.finished ?? false);
      } catch {}
    }
  }, [storeKey]);

  useEffect(() => {
    localStorage.setItem(storeKey, JSON.stringify({ index, score, finished }));
  }, [index, score, finished, storeKey]);

  const play = (file) => {
    const s = new Audio(file);
    s.volume = 0.6;
    s.play().catch(() => {});
  };

  const handleAnswer = (isCorrect) => {
    play(isCorrect ? "/success.mp3" : "/click.mp3");
    if (isCorrect) setScore((s) => s + 1);
    if (index + 1 < questions.length) setIndex((i) => i + 1);
    else setFinished(true);
  };

  if (finished) {
    return (
      <div className="text-center space-y-2">
        <h2 className="text-2xl mb-2">🎉 Quiz terminé !</h2>
        <p>Score : <span className="text-vertMenthe font-bold">{score}</span> / {questions.length}</p>
        <button
          className="mt-3 bg-vertMenthe text-bleuNuit font-bold"
          onClick={() => {
            setIndex(0);
            setScore(0);
            setFinished(false);
          }}
        >
          Rejouer
        </button>
      </div>
    );
  }

  return (
    <div className="text-center space-y-4">
      <div className="text-sm text-gray-300">Question {index + 1} / {questions.length}</div>
      <h3 className="text-xl">{current.question}</h3>
      <div className="flex flex-col items-center gap-2">
        {current.answers.map((a, i) => (
          <button
            key={i}
            className="bg-vertMenthe text-bleuNuit font-bold w-72"
            onClick={() => handleAnswer(a.correct)}
          >
            {a.text}
          </button>
        ))}
      </div>
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\pages\Accueil.jsx'; ^
   @'import React from "react";
import AudioPlayer from "../components/AudioPlayer.jsx";
import { Link } from "react-router-dom";

export default function Accueil() {
  return (
    <div className="text-center space-y-6">
      <AudioPlayer src="/lofi.mp3" />
      <h1 className="text-4xl font-bold text-vertMenthe">BiochimieBoost ⚗️</h1>
      <p className="text-lg text-blancCasse">
        Bienvenue dans ton laboratoire virtuel d’apprentissage interactif !
      </p>
      <p className="italic text-gray-300">
        “Les enzymes aussi ont commencé par apprendre à réagir.” 💡
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-4 max-w-2xl mx-auto">
        <Link to="/module1" className="p-4 rounded-xl bg-white/5 hover:bg-white/10">
          <div className="text-2xl">🧬</div>
          <div className="font-semibold">Module 1 — Acides aminés & protéines</div>
        </Link>
        <Link to="/module2" className="p-4 rounded-xl bg-white/5 hover:bg-white/10">
          <div className="text-2xl">⚗️</div>
          <div className="font-semibold">Module 2 — Stéréochimie</div>
        </Link>
        <Link to="/module3" className="p-4 rounded-xl bg-white/5 hover:bg-white/10">
          <div className="text-2xl">🔬</div>
          <div className="font-semibold">Module 3 — Réactions biochimiques</div>
        </Link>
        <Link to="/module4" className="p-4 rounded-xl bg-white/5 hover:bg-white/10">
          <div className="text-2xl">🧠</div>
          <div className="font-semibold">Module 4 — Synthèse & Quiz final</div>
        </Link>
      </div>
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\pages\Module1.jsx'; ^
   @'import React from "react";
import Quiz from "../components/Quiz.jsx";

const questions = [
  { question: "Combien d’acides aminés standards existent ?", answers: [
    { text: "10", correct: false },
    { text: "20", correct: true },
    { text: "22", correct: false }
  ]},
  { question: "La méthionine contient quel atome particulier ?", answers: [
    { text: "Soufre", correct: true },
    { text: "Phosphore", correct: false },
    { text: "Magnésium", correct: false }
  ]},
  { question: "La proline est :", answers: [
    { text: "Aromatique", correct: false },
    { text: "Amine secondaire cyclique", correct: true },
    { text: "Acide", correct: false }
  ]},
  { question: "Quel acide aminé est basique ?", answers: [
    { text: "Lysine", correct: true },
    { text: "Sérine", correct: false },
    { text: "Aspartate", correct: false }
  ]},
  { question: "Les protéines sont des polymères :", answers: [
    { text: "Ramifiés", correct: false },
    { text: "Non ramifiés", correct: true },
    { text: "Aromatiques", correct: false }
  ]},
];

export default function Module1() {
  return (
    <div className="space-y-6 text-center">
      <h2 className="text-3xl text-vertMenthe font-bold">Module 1 — Acides aminés & protéines</h2>
      <Quiz questions={questions} storeKey="quiz-module1" />
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\pages\Module2.jsx'; ^
   @'import React from "react";
import Quiz from "../components/Quiz.jsx";

const questions = [
  { question: "Que signifie R/S en stéréochimie ?", answers: [
    { text: "Réduction / Substitution", correct: false },
    { text: "Rectus / Sinister (configuration absolue)", correct: true },
    { text: "Résonance / Stabilisation", correct: false }
  ]},
  { question: "D/L en projection de Fischer indique :", answers: [
    { text: "Le signe du pouvoir rotatoire", correct: false },
    { text: "La famille relative (position de l’OH/NH2)", correct: true },
    { text: "La présence d’un cycle", correct: false }
  ]},
  { question: "Z/E s’applique à :", answers: [
    { text: "Liaisons simples C–C", correct: false },
    { text: "Doubles liaisons (C=C, C=N…)", correct: true },
    { text: "Groupements carbonyles", correct: false }
  ]},
  { question: "Un énantiomère diffère de son image miroir par :", answers: [
    { text: "Le pouvoir rotatoire uniquement", correct: true },
    { text: "Sa masse molaire", correct: false },
    { text: "Sa formule brute", correct: false }
  ]},
  { question: "Pour assigner R/S, on classe d’abord :", answers: [
    { text: "Par masse molaire", correct: false },
    { text: "Par numéro atomique (règles CIP)", correct: true },
    { text: "Par longueur de chaîne", correct: false }
  ]},
];

export default function Module2() {
  return (
    <div className="space-y-6 text-center">
      <h2 className="text-3xl text-vertMenthe font-bold">Module 2 — Stéréochimie</h2>
      <Quiz questions={questions} storeKey="quiz-module2" />
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\pages\Module3.jsx'; ^
   @'import React from "react";
import Quiz from "../components/Quiz.jsx";

const questions = [
  { question: "La forme zwitterionique d’un acide aminé apparaît typiquement à :", answers: [
    { text: "pH très acide (pH 1)", correct: false },
    { text: "pH physiologique (~7)", correct: true },
    { text: "pH très basique (pH 13)", correct: false }
  ]},
  { question: "Oxydation en organique signifie :", answers: [
    { text: "Gain d’oxygène et/ou perte d’hydrogène", correct: true },
    { text: "Gain d’hydrogène seulement", correct: false },
    { text: "Perte d’oxygène seulement", correct: false }
  ]},
  { question: "La liaison peptidique est une :", answers: [
    { text: "Liaison ester", correct: false },
    { text: "Liaison amide entre deux AA", correct: true },
    { text: "Liaison éther", correct: false }
  ]},
  { question: "NaBH4 est principalement :", answers: [
    { text: "Un oxydant fort", correct: false },
    { text: "Un donneur d’hydrure H− (réducteur)", correct: true },
    { text: "Un acide fort", correct: false }
  ]},
  { question: "Le point isoélectrique (pI) est :", answers: [
    { text: "Le pH où la charge nette est nulle", correct: true },
    { text: "Le pH de solubilité maximale", correct: false },
    { text: "Le pH de dénaturation protéique", correct: false }
  ]},
];

export default function Module3() {
  return (
    <div className="space-y-6 text-center">
      <h2 className="text-3xl text-vertMenthe font-bold">Module 3 — Réactions biochimiques</h2>
      <Quiz questions={questions} storeKey="quiz-module3" />
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

powershell -NoProfile -Command ^
  "$p='%ROOT%\src\pages\Module4.jsx'; ^
   @'import React from "react";
import Quiz from "../components/Quiz.jsx";

const questions = [
  { question: "Essentiels chez l’adulte :", answers: [
    { text: "Leu, Ile, Val, Lys, Thr, Met, Phe, Trp", correct: true },
    { text: "Gly, Ala, Ser, Pro, Tyr, Cys, Asn, Gln", correct: false },
    { text: "His, Arg uniquement", correct: false }
  ]},
  { question: "Les aromatiques qui absorbent aux UV :", answers: [
    { text: "Phe, Tyr, Trp", correct: true },
    { text: "Gly, Ala, Val", correct: false },
    { text: "Lys, Arg, His", correct: false }
  ]},
  { question: "Pour un AA simple, pI ≈ moyenne de :", answers: [
    { text: "Deux pKa pertinents (COOH & NH3+)", correct: true },
    { text: "Tous les pKa possibles", correct: false },
    { text: "Aucun pKa", correct: false }
  ]},
  { question: "Le glutathion est :", answers: [
    { text: "Un tripeptide fournissant un pouvoir réducteur", correct: true },
    { text: "Un disaccharide", correct: false },
    { text: "Un acide gras essentiel", correct: false }
  ]},
  { question: "La β-alanine provient de :", answers: [
    { text: "La décarboxylation de l’aspartate", correct: true },
    { text: "La réduction de la lysine", correct: false },
    { text: "L’oxydation du tryptophane", correct: false }
  ]},
];

export default function Module4() {
  return (
    <div className="space-y-6 text-center">
      <h2 className="text-3xl text-vertMenthe font-bold">Module 4 — Synthèse & Quiz final</h2>
      <Quiz questions={questions} storeKey="quiz-module4" />
      <p className="text-gray-300 mt-4">🎓 Quand tu fais 4/5 à chaque module, tu es prêt·e pour le final !</p>
    </div>
  );
}
'@ | Set-Content -Encoding UTF8 $p"

REM Placeholder audios (fichiers vides, tu pourras les remplacer)
type nul > "%ROOT%\public\lofi.mp3"
type nul > "%ROOT%\public\success.mp3"
type nul > "%ROOT%\public\click.mp3"

echo.
echo === Creation du ZIP ===
powershell -NoProfile -Command "if (Test-Path '%~dp0BiochimieBoost.zip') { Remove-Item '%~dp0BiochimieBoost.zip' -Force }; Compress-Archive -Path '%ROOT%' -DestinationPath '%~dp0BiochimieBoost.zip' -Force"

echo.
echo Terminé !
echo - Le dossier a été créé : %ROOT%
echo - Le ZIP a été créé : %~dp0BiochimieBoost.zip
echo.
echo Pour l'utiliser :
echo 1) Double-cliquez ce ZIP pour l'ouvrir, ou uploadez-le sur vercel.com
echo 2) Ou bien installez Node.js, ouvrez un terminal dans BiochimieBoost et lancez: npm install && npm run dev
echo.
pause
