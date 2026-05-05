<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Password Checker Pro</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root { --bg: #0b1120; --card: #1e293b; --text: #ffffff; --border: #334155; --input: #1e293b; --input-text: #ffffff; }
        body.light { --bg: #f8fafc; --card: #ffffff; --text: #0f172a; --border: #e2e8f0; --input: #f1f5f9; --input-text: #0f172a; }
        body { background-color: var(--bg); color: var(--text); transition: all 0.3s ease; }
        .card { background-color: var(--card); border-radius: 12px; padding: 24px; border: 1px solid var(--border); }
        .input-field { background-color: var(--input); color: var(--input-text); border: 1px solid var(--border); }
        .accent-blue { background-color: #3b82f6; color: white; }
    </style>
</head>
<body class="font-sans antialiased">

    <nav class="flex items-center justify-between px-8 py-4 border-b border-gray-800">
        <div class="flex items-center gap-2 font-bold text-xl">
            <i class="fas fa-shield-alt text-blue-500"></i> Password Checker
        </div>
        <div class="flex items-center gap-4">
            <button onclick="toggleTheme()" class="p-2 hover:bg-gray-700/20 rounded-full transition">
                <i id="themeIcon" class="fas fa-moon text-blue-400"></i>
            </button>
            <select id="langSelect" onchange="changeLang()" class="bg-transparent border border-gray-600 rounded px-2 py-1 text-sm outline-none">
                <option value="ru">Русский</option>
                <option value="kz">Қазақша</option>
                <option value="en">English</option>
            </select>
        </div>
    </nav>

    <main class="max-w-6xl mx-auto mt-12 px-4 mb-12">
        <div class="text-center mb-12">
            <h1 id="t-title" class="text-4xl font-bold mb-4">Проверьте надёжность вашего пароля</h1>
        </div>

        <div class="flex flex-col md:flex-row gap-4 mb-8 justify-center">
            <div class="relative w-full max-w-2xl">
                <input type="password" id="passInput" placeholder="••••••••" 
                    class="input-field w-full rounded-lg py-4 px-6 focus:outline-none focus:border-blue-500 transition">
                <button onclick="togglePass()" class="absolute right-4 top-5 text-gray-500">
                    <i id="eyeIcon" class="far fa-eye"></i>
                </button>
            </div>
            <button onclick="runCheck()" id="t-btnCheck" class="accent-blue hover:bg-blue-600 px-10 py-4 rounded-lg font-bold transition">Проверить</button>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="card">
                <h3 id="t-card1" class="text-gray-400 text-xs mb-4 uppercase font-bold">Надёжность</h3>
                <div class="flex items-center gap-4 mb-4">
                    <div id="shieldBox" class="w-12 h-12 bg-gray-500/10 rounded-full flex items-center justify-center text-gray-500 text-2xl transition-all">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div>
                        <div id="strengthText" class="text-2xl font-bold text-gray-500">—</div>
                        <div id="strengthSub" class="text-xs text-gray-400">0/100</div>
                    </div>
                </div>
                <div class="w-full bg-gray-700 rounded-full h-2 overflow-hidden">
                    <div id="strengthBar" class="bg-gray-500 h-2 transition-all duration-700" style="width: 0%"></div>
                </div>
            </div>

            <div class="card">
                <h3 id="t-card2" class="text-gray-400 text-xs mb-4 uppercase font-bold">Время взлома</h3>
                <div class="flex items-center gap-4">
                    <div class="w-12 h-12 bg-green-500/10 rounded-full flex items-center justify-center text-green-500 text-2xl"><i class="far fa-clock"></i></div>
                    <div id="crackTime" class="text-2xl font-bold">—</div>
                </div>
            </div>

            <div class="card">
                <h3 id="t-card6" class="text-sm mb-4 font-bold uppercase text-blue-500">Генератор</h3>
                <div class="input-field p-3 rounded mb-4 flex justify-between border border-gray-700">
                    <code class="text-blue-500 font-mono text-sm truncate" id="genResult">********</code>
                    <button onclick="copyToClipboard()"><i id="copyIcon" class="far fa-copy"></i></button>
                </div>
                <div class="flex flex-wrap gap-2 mb-4 text-[10px]">
                    <label class="flex items-center gap-1"><input type="checkbox" id="genUpper" checked> ABC</label>
                    <label class="flex items-center gap-1"><input type="checkbox" id="genNum" checked> 123</label>
                    <label class="flex items-center gap-1"><input type="checkbox" id="genSym" checked> !@#</label>
                </div>
                <button onclick="generate()" id="t-btnGen" class="w-full accent-blue py-2 rounded font-bold text-xs uppercase">Создать</button>
            </div>

            <div class="card">
                <h3 id="t-card4" class="text-sm mb-4 font-bold uppercase">Анализ состава</h3>
                <ul id="analysisList" class="space-y-2 text-sm"></ul>
            </div>

            <div class="card md:col-span-2">
                <h3 id="t-card5" class="text-sm mb-2 font-bold uppercase">Статус пароля</h3>
                <div id="finalStatus" class="text-3xl font-bold text-gray-500 mb-4">—</div>
                <hr class="border-gray-700 mb-4">
                <div id="recommendTitle" class="text-sm font-bold text-gray-400 mb-2">РЕКОМЕНДАЦИИ:</div>
                <ul id="recommendList" class="space-y-2 text-sm"></ul>
            </div>
        </div>
    </main>

    <script>
        const i18n = {
            ru: {
                title: "Проверка пароля", btnCheck: "Проверить", card1: "Надёжность", card2: "Время взлома",
                card4: "Анализ состава", card5: "Статус пароля", card6: "Генератор", btnGen: "СОЗДАТЬ",
                weak: "Слабый пароль", medium: "Средний пароль", strong: "Надёжный пароль", perfect: "Идеальный пароль!",
                timeSec: "Мгновенно", timeWeek: "2 недели", timeYear: "100+ лет",
                recLen: "Увеличьте длину (12+)", recUpper: "Добавьте заглавные буквы", recNum: "Добавьте цифры", recSym: "Добавьте спецсимволы",
                allOk: "Ваш пароль полностью защищен!"
            },
            kz: {
                title: "Құпия сөзді тексеру", btnCheck: "Тексеру", card1: "Сенімділік", card2: "Бұзу уақыты",
                card4: "Құрамын талдау", card5: "Құпия сөз статусы", card6: "Генератор", btnGen: "ЖАСАУ",
                weak: "Әлсіз пароль", medium: "Орташа пароль", strong: "Надёжный пароль", perfect: "Жақсы пароль!",
                timeSec: "Қазір-ақ", timeWeek: "2 апта", timeYear: "100+ жыл",
                recLen: "Ұзындығын арттырыңыз (12+)", recUpper: "Бас әріптер қосыңыз", recNum: "Сандар қосыңыз", recSym: "Таңбалар қосыңыз (!@#)",
                allOk: "Құпия сөзіңіз толық қорғалған!"
            },
            en: {
                title: "Password Check", btnCheck: "Check", card1: "Strength", card2: "Crack Time",
                card4: "Analysis", card5: "Password Status", card6: "Generator", btnGen: "GENERATE",
                weak: "Weak Password", medium: "Medium Password", strong: "Strong Password", perfect: "Perfect Password!",
                timeSec: "Instantly", timeWeek: "2 weeks", timeYear: "100+ years",
                recLen: "Increase length (12+)", recUpper: "Add uppercase letters", recNum: "Add numbers", recSym: "Add special symbols",
                allOk: "Your password is fully secured!"
            }
        };

        function toggleTheme() {
            document.body.classList.toggle('light');
            const isLight = document.body.classList.contains('light');
            document.getElementById('themeIcon').className = isLight ? 'fas fa-sun text-orange-500' : 'fas fa-moon text-blue-400';
        }

        function togglePass() {
            const input = document.getElementById('passInput');
            input.type = input.type === 'password' ? 'text' : 'password';
        }

        function runCheck() {
            const pass = document.getElementById('passInput').value;
            const lang = document.getElementById('langSelect').value;
            const t = i18n[lang];
            if(!pass) return;

            let score = 0;
            let recs = [];
            let analysis = "";

            if(pass.length >= 12) { score += 40; analysis += "<li>✓ Длина 12+</li>"; } else { recs.push(t.recLen); }
            if(/[A-Z]/.test(pass)) { score += 20; analysis += "<li>✓ Заглавные</li>"; } else { recs.push(t.recUpper); }
            if(/[0-9]/.test(pass)) { score += 20; analysis += "<li>✓ Цифры</li>"; } else { recs.push(t.recNum); }
            if(/[^A-Za-z0-9]/.test(pass)) { score += 20; analysis += "<li>✓ Символы</li>"; } else { recs.push(t.recSym); }

            // Обновление UI
            const bar = document.getElementById('strengthBar');
            const strText = document.getElementById('strengthText');
            const finalStatus = document.getElementById('finalStatus');
            const recList = document.getElementById('recommendList');

            bar.style.width = score + "%";
            document.getElementById('strengthSub').innerText = score + "/100";
            document.getElementById('analysisList').innerHTML = analysis || "—";

            let statusStr = "";
            let color = "";
            let crack = "";

            if(score <= 40) { statusStr = t.weak; color = "#ef4444"; crack = t.timeSec; }
            else if(score < 80) { statusStr = t.medium; color = "#f59e0b"; crack = t.timeWeek; }
            else if(score < 100) { statusStr = t.strong; color = "#3b82f6"; crack = t.timeYear; }
            else { statusStr = t.perfect; color = "#10b981"; crack = t.timeYear; }

            strText.innerText = statusStr;
            strText.style.color = color;
            bar.style.backgroundColor = color;
            finalStatus.innerText = statusStr;
            finalStatus.style.color = color;
            document.getElementById('crackTime').innerText = crack;

            recList.innerHTML = recs.length > 0 
                ? recs.map(r => `<li class="text-red-400">• ${r}</li>`).join('')
                : `<li class="text-green-500">✓ ${t.allOk}</li>`;
        }

        function generate() {
            let charset = "abcdefghijklmnopqrstuvwxyz";
            if(document.getElementById('genUpper').checked) charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if(document.getElementById('genNum').checked) charset += "0123456789";
            if(document.getElementById('genSym').checked) charset += "!@#$%^&*";
            let res = "";
            for(let i=0; i<16; i++) res += charset.charAt(Math.floor(Math.random()*charset.length));
            document.getElementById('genResult').innerText = res;
        }

        function copyToClipboard() {
            const val = document.getElementById('genResult').innerText;
            if(val.includes('*')) return;
            navigator.clipboard.writeText(val);
            const icon = document.getElementById('copyIcon');
            icon.className = "fas fa-check text-green-500";
            setTimeout(() => icon.className = "far fa-copy", 2000);
        }

        function changeLang() {
            const l = document.getElementById('langSelect').value;
            const t = i18n[l];
            document.getElementById('t-title').innerText = t.title;
            document.getElementById('t-btnCheck').innerText = t.btnCheck;
            document.getElementById('t-btnGen').innerText = t.btnGen;
        }
    </script>
</body>
</html>
