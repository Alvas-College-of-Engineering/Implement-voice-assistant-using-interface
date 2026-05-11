<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>ARIA Voice Assistant</title>
  <link href="https://fonts.googleapis.com/css2?family=Syne:wght@800&family=DM+Mono:wght@400;500&display=swap" rel="stylesheet"/>
  <style>
    :root {
      --bg:#0b0c0f; --surface:#13141a; --border:#1f2130;
      --accent:#7c6cfc; --coral:#fc6c8f;
      --text:#e8e9f0; --muted:#6b6e85; --r:14px;
    }
    *,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
    body{background:var(--bg);color:var(--text);font-family:'DM Mono',monospace;font-size:14px;height:100dvh;display:flex;flex-direction:column;overflow:hidden}
    header{display:flex;align-items:center;gap:12px;padding:16px 24px;border-bottom:1px solid var(--border);background:var(--surface);flex-shrink:0}
    .dot{width:9px;height:9px;border-radius:50%;background:var(--accent);box-shadow:0 0 8px var(--accent);animation:breathe 2.5s ease-in-out infinite}
    @keyframes breathe{0%,100%{opacity:1;transform:scale(1)}50%{opacity:.4;transform:scale(.7)}}
    .brand{font-family:'Syne',sans-serif;font-weight:800;font-size:17px;letter-spacing:.1em}
    .brand span{color:var(--accent)}
    .badge{margin-left:auto;font-size:10px;color:var(--muted);letter-spacing:.12em;text-transform:uppercase}

    #chat{flex:1;overflow-y:auto;padding:24px 20px;display:flex;flex-direction:column;gap:14px;scroll-behavior:smooth}
    #chat::-webkit-scrollbar{width:3px}
    #chat::-webkit-scrollbar-thumb{background:var(--border);border-radius:4px}

    .msg{display:flex;gap:10px;max-width:680px;animation:rise .2s ease both}
    @keyframes rise{from{opacity:0;transform:translateY(8px)}to{opacity:1;transform:translateY(0)}}
    .msg.user{align-self:flex-end;flex-direction:row-reverse}
    .av{width:30px;height:30px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:13px;flex-shrink:0;margin-top:3px}
    .msg.user .av{background:var(--accent);color:#fff;font-family:'Syne',sans-serif;font-weight:700}
    .msg.bot  .av{background:var(--border);color:var(--accent)}
    .meta{font-size:10px;color:var(--muted);letter-spacing:.08em;text-transform:uppercase;margin-bottom:4px}
    .bubble{padding:10px 14px;border-radius:var(--r);line-height:1.65;max-width:calc(100% - 42px);word-break:break-word}
    .msg.user .bubble{background:#1c1e2e;border:1px solid var(--accent);border-top-right-radius:4px}
    .msg.bot  .bubble{background:#161820;border:1px solid var(--border);border-top-left-radius:4px}

    .dots{display:flex;gap:5px;align-items:center;padding:2px 0}
    .dots span{width:6px;height:6px;background:var(--accent);border-radius:50%;animation:blink 1.2s ease-in-out infinite}
    .dots span:nth-child(2){animation-delay:.2s}
    .dots span:nth-child(3){animation-delay:.4s}
    @keyframes blink{0%,80%,100%{opacity:.2;transform:scale(.8)}40%{opacity:1;transform:scale(1)}}

    #welcome{text-align:center;padding:50px 20px 10px;color:var(--muted)}
    #welcome h2{font-family:'Syne',sans-serif;font-size:26px;font-weight:800;color:var(--text);margin-bottom:6px}
    #welcome h2 span{color:var(--accent)}
    #welcome p{font-size:12px;line-height:1.7;max-width:380px;margin:0 auto 20px}
    .chips{display:flex;flex-wrap:wrap;gap:8px;justify-content:center}
    .chip{padding:7px 13px;border-radius:999px;border:1px solid var(--border);background:var(--surface);color:var(--muted);font-size:12px;cursor:pointer;transition:all .15s;font-family:'DM Mono',monospace}
    .chip:hover{border-color:var(--accent);color:var(--accent)}

    .bar{padding:14px 20px;border-top:1px solid var(--border);background:var(--surface);display:flex;gap:8px;align-items:flex-end;flex-shrink:0}
    #inp{flex:1;background:var(--bg);border:1px solid var(--border);border-radius:var(--r);color:var(--text);font-family:'DM Mono',monospace;font-size:14px;padding:11px 14px;resize:none;min-height:44px;max-height:130px;line-height:1.5;outline:none;transition:border-color .2s}
    #inp::placeholder{color:var(--muted)}
    #inp:focus{border-color:var(--accent)}
    .btn{width:44px;height:44px;border-radius:12px;border:1px solid var(--border);background:var(--bg);color:var(--muted);cursor:pointer;display:flex;align-items:center;justify-content:center;flex-shrink:0;transition:all .2s;font-size:17px}
    .btn:hover{border-color:var(--accent);color:var(--accent)}
    #sendBtn{background:var(--accent);border-color:var(--accent);color:#fff}
    #sendBtn:hover{opacity:.85}
    #micBtn.on{background:var(--coral);border-color:var(--coral);color:#fff;animation:mp 1s ease-in-out infinite}
    @keyframes mp{0%,100%{box-shadow:0 0 0 0 rgba(252,108,143,.4)}50%{box-shadow:0 0 0 7px rgba(252,108,143,0)}}
    #status{font-size:11px;color:var(--muted);padding:0 20px 8px;background:var(--surface);letter-spacing:.08em;min-height:20px}
  </style>
</head>
<body>

<header>
  <div class="dot"></div>
  <div class="brand">AR<span>IA</span></div>
  <div class="badge">Voice Assistant &middot; Java Servlet</div>
</header>

<div id="chat">
  <div id="welcome">
    <h2>Hello, I'm <span>ARIA</span></h2>
    <p>Click the mic to speak or type below. Your command goes to the Java backend and Claude replies.</p>
    <div class="chips">
      <div class="chip" onclick="chip(this)">Hello</div>
      <div class="chip" onclick="chip(this)">Tell me a joke</div>
      <div class="chip" onclick="chip(this)">What is Java?</div>
      <div class="chip" onclick="chip(this)">What is your name?</div>
      <div class="chip" onclick="chip(this)">What time is it?</div>
    </div>
  </div>
</div>

<div class="bar">
  <button class="btn" id="micBtn" onclick="toggleMic()" title="Voice input">&#127908;</button>
  <textarea id="inp" placeholder="Type or speak a command…" rows="1"
            onkeydown="onKey(event)" oninput="resize(this)"></textarea>
  <button class="btn" id="sendBtn" onclick="send()">&#10148;</button>
</div>
<div id="status"></div>

<script>
  /*
   * FULL SPEECH PIPELINE:
   *
   *  Browser mic  →  SpeechRecognition (built-in, no API key)
   *                    ↓ transcript text
   *  fetch() POST /assistant   (form-encoded: command=hello)
   *                    ↓
   *  AssistantServlet.doPost()
   *    → assistant.listenCommand(command)   // store text
   *    → assistant.executeTask()            // call Claude API, store reply
   *    → assistant.provideResponse()        // return reply
   *                    ↓ plain text response
   *  Chat bubble + SpeechSynthesis reads reply aloud
   *
   * API KEY: lives in WEB-INF/config.properties — Tomcat never serves WEB-INF to browser.
   */

  var recording = false, recog = null;

  function resize(el) {
    el.style.height = 'auto';
    el.style.height = Math.min(el.scrollHeight, 130) + 'px';
  }

  function onKey(e) {
    if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); send(); }
  }

  function chip(el) {
    document.getElementById('inp').value = el.textContent.trim();
    send();
  }

  function addBubble(role, text) {
    var w = document.getElementById('welcome');
    if (w) w.remove();
    var chat = document.getElementById('chat');
    var d = document.createElement('div');
    d.className = 'msg ' + role;
    d.innerHTML = '<div class="av">' + (role==='user'?'U':'&#129302;') + '</div>' +
      '<div><div class="meta">' + (role==='user'?'You':'ARIA') + '</div>' +
      '<div class="bubble">' + esc(text) + '</div></div>';
    chat.appendChild(d);
    chat.scrollTop = chat.scrollHeight;
  }

  function showTyping() {
    var chat = document.getElementById('chat');
    var d = document.createElement('div');
    d.className='msg bot'; d.id='typing';
    d.innerHTML='<div class="av">&#129302;</div><div><div class="meta">ARIA</div>' +
      '<div class="bubble"><div class="dots"><span></span><span></span><span></span></div></div></div>';
    chat.appendChild(d);
    chat.scrollTop = chat.scrollHeight;
  }

  function removeTyping() {
    var t = document.getElementById('typing');
    if (t) t.remove();
  }

  function esc(t) {
    return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
  }

  function setStatus(m) { document.getElementById('status').textContent = m; }

  /*
   * send() — POSTs the command to AssistantServlet
   *
   * JSP MAGIC: <%= request.getContextPath() %>
   * Tomcat fills this in at runtime with the correct app root.
   * e.g.  ROOT deploy → ""     → URL becomes "/assistant"
   *       VoiceApp    → "/VoiceApp" → "/VoiceApp/assistant"
   * Plain HTML cannot do this — it's why we use JSP.
   */
  async function send() {
    var inp = document.getElementById('inp');
    var cmd = inp.value.trim();
    if (!cmd) return;
    addBubble('user', cmd);
    inp.value = ''; inp.style.height = 'auto';
    showTyping();
    setStatus('Processing…');
    try {
      var res = await fetch('<%= request.getContextPath() %>/assistant', {
        method: 'POST',
        headers: {'Content-Type':'application/x-www-form-urlencoded'},
        body: 'command=' + encodeURIComponent(cmd)
      });
      if (!res.ok) throw new Error('HTTP ' + res.status);
      var text = await res.text();
      removeTyping();
      addBubble('bot', text);
      setStatus('');
      // Speak the reply (SpeechSynthesis — also built-in, no key needed)
      if (window.speechSynthesis) {
        var u = new SpeechSynthesisUtterance(text);
        u.rate = 1.05;
        speechSynthesis.speak(u);
      }
    } catch(err) {
      removeTyping();
      addBubble('bot', 'Server unreachable. Is Tomcat running?');
      setStatus('Error: ' + err.message);
    }
  }

  /*
   * VOICE INPUT — Web Speech API
   *
   * Built into Chrome and Edge. Zero cost. Zero config.
   * interimResults=true → words appear in textarea as you speak (real-time)
   * onend → fires when silence detected → auto-sends whatever was captured
   */
  function toggleMic() { recording ? stopMic() : startMic(); }

  function startMic() {
    var SR = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SR) { setStatus('Speech not supported. Use Chrome or Edge.'); return; }
    recog = new SR();
    recog.lang = 'en-US';
    recog.interimResults = true;
    recog.maxAlternatives = 1;
    recog.onresult = function(e) {
      var t = Array.from(e.results).map(function(r){return r[0].transcript}).join('');
      var inp = document.getElementById('inp');
      inp.value = t; resize(inp);
    };
    recog.onend = function() {
      stopMic();
      if (document.getElementById('inp').value.trim()) send();
    };
    recog.onerror = function(e) { setStatus('Mic error: ' + e.error); stopMic(); };
    recog.start();
    recording = true;
    var btn = document.getElementById('micBtn');
    btn.classList.add('on'); btn.innerHTML = '&#9646;';
    setStatus('Listening… speak now');
  }

  function stopMic() {
    if (recog) { recog.stop(); recog = null; }
    recording = false;
    var btn = document.getElementById('micBtn');
    btn.classList.remove('on'); btn.innerHTML = '&#127908;';
    setStatus('');
  }
</script>
</body>
</html>