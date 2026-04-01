<!doctype html>
<html lang="en" class="h-full">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Engagement Sent in 15 Min</title>
  <script src="https://cdn.tailwindcss.com/3.4.17"></script>
  <script src="https://cdn.jsdelivr.net/npm/lucide@0.263.0/dist/umd/lucide.min.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Lora:wght@400;500;600;700&family=Questrial&display=swap" rel="stylesheet">
  <style>
    html, body { height: 100%; margin: 0; }
    * { font-family: 'Questrial', sans-serif; }
    .font-display { font-family: 'Lora', serif; }

    @keyframes fadeUp {
      from { opacity: 0; transform: translateY(24px); }
      to { opacity: 1; transform: translateY(0); }
    }
    @keyframes shimmer {
      0% { background-position: -200% 0; }
      100% { background-position: 200% 0; }
    }
    @keyframes pulse-ring {
      0% { transform: scale(0.8); opacity: 0.6; }
      100% { transform: scale(1.6); opacity: 0; }
    }

    .anim-fade-up { animation: fadeUp 0.6s ease-out both; }
    .anim-delay-1 { animation-delay: 0.1s; }
    .anim-delay-2 { animation-delay: 0.2s; }
    .anim-delay-3 { animation-delay: 0.3s; }
    .anim-delay-4 { animation-delay: 0.4s; }
    .anim-delay-5 { animation-delay: 0.5s; }

    .pulse-dot::before {
      content: '';
      position: absolute;
      inset: -8px;
      border-radius: 50%;
      border: 2px solid currentColor;
      animation: pulse-ring 2s ease-out infinite;
    }

    .screen-transition { transition: opacity 0.4s ease, transform 0.4s ease; }
    .screen-hidden {
      opacity: 0; transform: translateY(16px);
      pointer-events: none; position: absolute; width: 100%;
    }
    .screen-visible { opacity: 1; transform: translateY(0); pointer-events: auto; }

    .option-btn {
      transition: all 0.25s ease;
      border: 2px solid transparent;
      cursor: pointer;
    }
    .option-btn:hover:not(.disabled) {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0,0,0,0.15);
    }
    .option-btn.disabled { pointer-events: none; }

    .progress-fill {
      transition: width 0.5s ease;
      background: linear-gradient(90deg, #6378FD, #7c8bfe);
      background-size: 200% 100%;
      animation: shimmer 2s infinite;
    }

    .drag-item {
      cursor: grab;
      user-select: none;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .drag-item:active { cursor: grabbing; }
    .drag-item.dragging { opacity: 0.5; transform: scale(0.97); }
    .drag-item.drag-over { border-top: 3px solid #22c55e; }

    .toast-msg { animation: fadeUp 0.4s ease-out both; }

    .confetti-container {
      position: absolute; inset: 0;
      pointer-events: none; overflow: hidden;
    }
    .confetti-piece {
      position: absolute; width: 8px; height: 8px; border-radius: 2px;
    }
  </style>
</head>
<body class="h-full">
<div id="app" class="h-full w-full overflow-auto" style="background: #151821;">

  <!-- Progress Bar -->
  <div class="fixed top-0 left-0 w-full z-50" style="height: 4px; background: rgba(255,255,255,0.08);">
    <div id="progress-bar" class="h-full progress-fill" style="width: 0%;"></div>
  </div>

  <div id="screens" class="relative w-full min-h-full flex items-center justify-center p-4 sm:p-8">

    <!-- SCREEN 1: INTRO -->
    <div id="screen-1" class="screen-transition screen-visible w-full max-w-2xl mx-auto text-center">
      <div class="anim-fade-up">
        <div class="relative inline-flex items-center justify-center w-20 h-20 rounded-full mb-8" style="background: rgba(34,197,94,0.15);">
          <div class="pulse-dot relative" style="color: #22c55e;">
            <i data-lucide="message-circle" style="width:36px;height:36px;color:#22c55e;"></i>
          </div>
        </div>
      </div>
      <h1 class="font-display text-4xl sm:text-5xl font-bold mb-4 anim-fade-up anim-delay-1" style="color: #f1f5f9;">Engagement sent in 15 min</h1>
      <p class="text-lg sm:text-xl mb-4 anim-fade-up anim-delay-2" style="color: #22c55e;">The chat just ended. The client is still thinking about you.</p>
      <p class="text-base mb-10 anim-fade-up anim-delay-3" style="color: #94a3b8; max-width: 480px; margin-left: auto; margin-right: auto;">You have 15 minutes. One short message. A push notification that reminds them you exist. Let's train exactly how to use that window — before it closes.</p>
      <button onclick="goToScreen(2)" class="anim-fade-up anim-delay-4 inline-flex items-center gap-2 px-8 py-4 rounded-xl text-white font-semibold text-lg transition-all hover:scale-105" style="background: linear-gradient(135deg, #f97316, #ea580c);">
        Let's start <i data-lucide="arrow-right" style="width:20px;height:20px;"></i>
      </button>
    </div>

    <!-- SCREEN 2: QUIZ -->
    <div id="screen-2" class="screen-transition screen-hidden w-full max-w-2xl mx-auto">
      <div class="text-center mb-8">
        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold mb-4" style="background: rgba(99,120,253,0.15); color: #6378FD;">QUIZ · SCREEN 2 OF 8</span>
        <h2 class="font-display text-3xl font-bold mb-2" style="color: #f1f5f9;">Let's check the basics first</h2>
      </div>
      <div id="quiz-container"></div>
    </div>

    <!-- SCREEN 3: SCENARIO — Chat just ended -->
    <div id="screen-3" class="screen-transition screen-hidden w-full max-w-2xl mx-auto">
      <div class="text-center mb-6">
        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold mb-4" style="background: rgba(99,120,253,0.15); color: #6378FD;">SCENARIO · SCREEN 3 OF 8</span>
        <h2 class="font-display text-3xl font-bold mb-2" style="color: #f1f5f9;">The chat just ended. Now what?</h2>
      </div>
      <div class="rounded-2xl p-5 mb-6" style="background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08);">
        <p class="text-xs font-semibold mb-2" style="color: #94a3b8;">SITUATION</p>
        <p class="text-sm leading-relaxed" style="color: #e2e8f0;">You just finished a chat with a client. She was emotional, talking about her relationship. The chat ended 2 minutes ago. You immediately opened a new chat with a different client and you're in the middle of reading their message. You have 13 minutes left in your engagement window.</p>
      </div>
      <p class="text-sm font-semibold mb-4" style="color: #f1f5f9;">What do you do?</p>
      <div class="space-y-3" id="s3-options">
        <button onclick="answerS3(0)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-xs font-semibold block mb-1" style="color:#94a3b8;">OPTION A</span>
          <span class="text-sm">Focus on the new client — engagement messages can wait until there's a natural pause in the session.</span>
        </button>
        <button onclick="answerS3(1)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-xs font-semibold block mb-1" style="color:#94a3b8;">OPTION B</span>
          <span class="text-sm">Quickly switch to the Chats tab, send a short personal engagement message to the previous client, then return to the new chat. The whole thing takes under a minute.</span>
        </button>
        <button onclick="answerS3(2)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-xs font-semibold block mb-1" style="color:#94a3b8;">OPTION C</span>
          <span class="text-sm">Send a quick "Thank you for the session!" through the Pings tab right now so it's done.</span>
        </button>
      </div>
      <div id="s3-feedback" class="hidden mt-4"></div>
      <div id="s3-next" class="hidden text-center mt-6">
        <button onclick="goToScreen(4)" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background: linear-gradient(135deg, #6378FD, #5169e8);">
          Continue <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
        </button>
      </div>
    </div>

    <!-- SCREEN 4: SPOT THE MISTAKE -->
    <div id="screen-4" class="screen-transition screen-hidden w-full max-w-2xl mx-auto">
      <div class="text-center mb-6">
        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold mb-4" style="background: rgba(239,68,68,0.15); color: #f87171;">SPOT THE MISTAKE · SCREEN 4 OF 8</span>
        <h2 class="font-display text-3xl font-bold mb-2" style="color: #f1f5f9;">What went wrong here?</h2>
        <p class="text-sm" style="color: #94a3b8;">An expert sent an engagement message but it didn't work. Find the mistake.</p>
      </div>
      <div class="rounded-2xl p-5 mb-6" style="background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08);">
        <p class="text-xs font-semibold mb-3" style="color: #94a3b8;">WHAT HAPPENED</p>
        <div class="space-y-3">
          <div class="flex items-start gap-3 p-3 rounded-xl" style="background: rgba(99,120,253,0.08);">
            <i data-lucide="check-circle" style="width:16px;height:16px;color:#6378FD;flex-shrink:0;margin-top:2px;"></i>
            <p class="text-sm" style="color:#e2e8f0;">The chat ended and the expert immediately sent a message within 30 seconds</p>
          </div>
          <div class="flex items-start gap-3 p-3 rounded-xl" style="background: rgba(99,120,253,0.08);">
            <i data-lucide="check-circle" style="width:16px;height:16px;color:#6378FD;flex-shrink:0;margin-top:2px;"></i>
            <p class="text-sm" style="color:#e2e8f0;">The message was sent through the Chats tab — correct channel</p>
          </div>
          <div class="flex items-start gap-3 p-3 rounded-xl" style="background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.2);">
            <i data-lucide="x-circle" style="width:16px;height:16px;color:#f87171;flex-shrink:0;margin-top:2px;"></i>
            <p class="text-sm" style="color:#e2e8f0;">The client saw the message as <strong style="color:#f87171;">blurred</strong> and couldn't read it</p>
          </div>
          <div class="flex items-start gap-3 p-3 rounded-xl" style="background: rgba(239,68,68,0.08);">
            <i data-lucide="alert-circle" style="width:16px;height:16px;color:#f87171;flex-shrink:0;margin-top:2px;"></i>
            <p class="text-sm" style="color:#f87171;">Result: the client didn't read the message and didn't come back</p>
          </div>
        </div>
      </div>
      <p class="text-sm font-semibold mb-4" style="color: #f1f5f9;">Why did the client see a blurred message?</p>
      <div class="space-y-3" id="s4-options">
        <button onclick="answerS4(0)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-sm">A) The message was too short — the system blurs messages under a certain length</span>
        </button>
        <button onclick="answerS4(1)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-sm">B) The message was sent within the first minute after the chat ended — messages sent that early appear blurred to the client</span>
        </button>
        <button onclick="answerS4(2)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-sm">C) The client's notifications were turned off — nothing the expert could have done</span>
        </button>
      </div>
      <div id="s4-feedback" class="hidden mt-4"></div>
      <div id="s4-next" class="hidden text-center mt-6">
        <button onclick="goToScreen(5)" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background: linear-gradient(135deg, #6378FD, #5169e8);">
          Continue <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
        </button>
      </div>
    </div>

    <!-- SCREEN 5: SCENARIO — Choose the better message -->
    <div id="screen-5" class="screen-transition screen-hidden w-full max-w-2xl mx-auto">
      <div class="text-center mb-6">
        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold mb-4" style="background: rgba(99,120,253,0.15); color: #6378FD;">SCENARIO · SCREEN 5 OF 8</span>
        <h2 class="font-display text-3xl font-bold mb-2" style="color: #f1f5f9;">Which message brings the client back?</h2>
      </div>
      <div class="rounded-2xl p-5 mb-6" style="background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08);">
        <p class="text-xs font-semibold mb-2" style="color: #94a3b8;">CLIENT CONTEXT</p>
        <p class="text-sm leading-relaxed" style="color: #e2e8f0;">A client just finished a chat with you. They were anxious about their partner — they mentioned he seemed distant lately and they don't know why. The chat ended 3 minutes ago. You're about to send your engagement message.</p>
      </div>
      <p class="text-sm font-semibold mb-4" style="color: #f1f5f9;">Which message do you send?</p>
      <div class="space-y-3" id="s5-options">
        <button onclick="answerS5(0)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-xs font-semibold block mb-1" style="color:#94a3b8;">OPTION A</span>
          <span class="text-sm italic">"Thank you for the session today! It was lovely talking with you. Feel free to come back anytime you need guidance. Take care!"</span>
        </button>
        <button onclick="answerS5(1)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-xs font-semibold block mb-1" style="color:#94a3b8;">OPTION B</span>
          <span class="text-sm italic">"I can see he's nervous today, and I feel he thinks about you a lot. Let's see what it will bring you?"</span>
        </button>
        <button onclick="answerS5(2)" class="option-btn w-full text-left px-5 py-4 rounded-xl" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
          <span class="text-xs font-semibold block mb-1" style="color:#94a3b8;">OPTION C</span>
          <span class="text-sm italic">"Would you like to know more about your situation? I have more insights I'd love to share with you!"</span>
        </button>
      </div>
      <div id="s5-feedback" class="hidden mt-4"></div>
      <div id="s5-next" class="hidden text-center mt-6">
        <button onclick="goToScreen(6)" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background: linear-gradient(135deg, #6378FD, #5169e8);">
          Continue <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
        </button>
      </div>
    </div>

    <!-- SCREEN 6: DRAG & DROP -->
    <div id="screen-6" class="screen-transition screen-hidden w-full max-w-2xl mx-auto">
      <div class="text-center mb-6">
        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold mb-4" style="background: rgba(99,120,253,0.15); color: #6378FD;">BUILD IT · SCREEN 6 OF 8</span>
        <h2 class="font-display text-3xl font-bold mb-2" style="color: #f1f5f9;">Build the engagement message</h2>
        <p class="text-sm" style="color: #94a3b8;">Drag these 4 elements into the correct order for an engagement message that actually brings clients back.</p>
      </div>
      <div id="sort-container" class="space-y-2 mb-6"></div>
      <div id="sort-feedback" class="hidden mb-4"></div>
      <div class="text-center">
        <button id="check-sort-btn" onclick="checkSort()" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background: linear-gradient(135deg, #6378FD, #5169e8);">
          Check order <i data-lucide="check" style="width:18px;height:18px;"></i>
        </button>
        <button id="sort-next-btn" onclick="goToScreen(7)" class="hidden inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background: linear-gradient(135deg, #6378FD, #5169e8);">
          Continue <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
        </button>
      </div>
    </div>

    <!-- SCREEN 7: REVIEW -->
    <div id="screen-7" class="screen-transition screen-hidden w-full max-w-2xl mx-auto">
      <div class="text-center mb-6">
        <span class="inline-block px-3 py-1 rounded-full text-xs font-semibold mb-4" style="background: rgba(34,197,94,0.15); color: #22c55e;">REVIEW · SCREEN 7 OF 8</span>
        <h2 class="font-display text-3xl font-bold mb-3" style="color: #f1f5f9;">The rules of Engagement Messages</h2>
        <p class="text-sm mb-6" style="color: #94a3b8;">Keep these close. Every session, every time.</p>
      </div>
      <div class="rounded-2xl overflow-hidden mb-6" style="background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08);">
        <div class="p-6 space-y-5">
          <div class="flex items-start gap-4">
            <div class="flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm" style="background: rgba(34,197,94,0.2); color: #22c55e;">1</div>
            <div>
              <p class="font-semibold text-sm mb-1" style="color: #22c55e;">15-minute window — not a moment longer</p>
              <p class="text-sm" style="color: #cbd5e1;">After 15 minutes, the Chats tab no longer allows engagement messages. You'd have to use Pings — which is a different tool entirely.</p>
            </div>
          </div>
          <div class="flex items-start gap-4">
            <div class="flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm" style="background: rgba(34,197,94,0.2); color: #22c55e;">2</div>
            <div>
              <p class="font-semibold text-sm mb-1" style="color: #22c55e;">Wait at least 1 minute before sending</p>
              <p class="text-sm" style="color: #cbd5e1;">Messages sent within the first minute after the chat ends appear blurred to the client. They won't be able to read it. Wait — then write.</p>
            </div>
          </div>
          <div class="flex items-start gap-4">
            <div class="flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm" style="background: rgba(34,197,94,0.2); color: #22c55e;">3</div>
            <div>
              <p class="font-semibold text-sm mb-1" style="color: #22c55e;">Send through the Chats tab — not Pings</p>
              <p class="text-sm" style="color: #cbd5e1;">Engagement Messages go through Chats. They trigger a push notification that reminds the client about you. That's the whole point.</p>
            </div>
          </div>
          <div class="flex items-start gap-4">
            <div class="flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm" style="background: rgba(34,197,94,0.2); color: #22c55e;">4</div>
            <div>
              <p class="font-semibold text-sm mb-1" style="color: #22c55e;">Keep it short and personal</p>
              <p class="text-sm" style="color: #cbd5e1;">This isn't the place for a long message. One or two sentences. Something specific to their situation. Greeting → detail from the session → intrigue → invitation to return.</p>
            </div>
          </div>
          <div class="flex items-start gap-4">
            <div class="flex-shrink-0 w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm" style="background: rgba(34,197,94,0.2); color: #22c55e;">5</div>
            <div>
              <p class="font-semibold text-sm mb-1" style="color: #22c55e;">Your goal: ≥ 85% of chats</p>
              <p class="text-sm" style="color: #cbd5e1;">At least 85% of your chats should have an Engagement Message sent on time. Track it in your dashboard.</p>
            </div>
          </div>
        </div>
        <div class="p-5" style="background: rgba(34,197,94,0.06); border-top: 1px solid rgba(255,255,255,0.06);">
          <p class="text-xs font-semibold mb-2" style="color: #94a3b8;">EXAMPLE ENGAGEMENT MESSAGE</p>
          <p class="text-sm italic leading-relaxed" style="color: #e2e8f0;">"I can see he's nervous today, and I feel he thinks about you a lot. Let's see what it will bring you?"</p>
          <div class="flex gap-2 mt-3 flex-wrap">
            <span class="text-xs px-2 py-1 rounded-full" style="background:rgba(99,120,253,0.15);color:#6378FD;">Detail from session</span>
            <span class="text-xs px-2 py-1 rounded-full" style="background:rgba(99,120,253,0.15);color:#6378FD;">Intrigue</span>
            <span class="text-xs px-2 py-1 rounded-full" style="background:rgba(99,120,253,0.15);color:#6378FD;">Invitation to return</span>
          </div>
        </div>
      </div>
      <div class="text-center">
        <button onclick="goToScreen(8)" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background: linear-gradient(135deg, #f97316, #ea580c);">
          See my results <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
        </button>
      </div>
    </div>

    <!-- SCREEN 8: END -->
    <div id="screen-8" class="screen-transition screen-hidden w-full max-w-2xl mx-auto text-center">
      <div class="confetti-container" id="confetti"></div>
      <div class="anim-fade-up">
        <div class="relative inline-flex items-center justify-center w-24 h-24 rounded-full mb-6" style="background: rgba(34,197,94,0.15);">
          <i data-lucide="trophy" style="width:44px;height:44px;color:#22c55e;"></i>
        </div>
      </div>
      <h2 class="font-display text-4xl font-bold mb-3 anim-fade-up anim-delay-1" style="color: #f1f5f9;">Training Complete!</h2>
      <p class="text-lg mb-6 anim-fade-up anim-delay-2" style="color: #94a3b8;">Here's how you did</p>
      <div id="score-display" class="anim-fade-up anim-delay-3 rounded-2xl p-6 mb-8 mx-auto" style="max-width: 360px; background: rgba(255,255,255,0.04); border: 1px solid rgba(255,255,255,0.08);"></div>
      <p class="text-sm mb-8 anim-fade-up anim-delay-4" style="color: #94a3b8; max-width: 400px; margin: 0 auto;">15 minutes. One message. A client who remembers you. That's the habit that builds lasting relationships.</p>
      <button onclick="restartTraining()" class="anim-fade-up anim-delay-5 inline-flex items-center gap-2 px-6 py-3 rounded-xl font-semibold transition-all hover:scale-105" style="background: rgba(255,255,255,0.08); color: #f1f5f9; border: 1px solid rgba(255,255,255,0.12);">
        <i data-lucide="rotate-ccw" style="width:18px;height:18px;"></i> Try again
      </button>
    </div>

  </div>
</div>

<script>
  let currentScreen = 1;
  let score = 0;
  let totalPossible = 7;
  let quizIndex = 0;
  let s3Done = false, s4Done = false, s5Done = false;

  const quizData = [
    {
      q: "How long do you have to send an Engagement Message after a chat ends?",
      options: ["30 minutes", "15 minutes", "24 hours"],
      correct: 1,
      feedbackCorrect: "Correct. 15 minutes is your window. After that, the Chats tab no longer allows engagement messages — you'd have to use Pings instead.",
      feedbackWrong: "The window is 15 minutes. After that, you can no longer send an Engagement Message through the Chats tab. You'd have to use Pings — which is a different tool."
    },
    {
      q: "Where do you send an Engagement Message?",
      options: ["Pings tab in NebulaX", "Chats tab", "Messenger tab"],
      correct: 1,
      feedbackCorrect: "Exactly. Engagement Messages go through the Chats tab. They trigger a push notification that reminds the client about you.",
      feedbackWrong: "Engagement Messages are sent through the Chats tab — not Pings. They trigger a push notification. That's the whole mechanic that brings clients back."
    },
    {
      q: "You sent an engagement message 40 seconds after the chat ended. The client sees it blurred. Why?",
      options: [
        "The message was too long",
        "Messages sent within the first minute after a chat ends appear blurred to the client",
        "The client has notifications turned off"
      ],
      correct: 1,
      feedbackCorrect: "Right. If you send within the first minute, the message appears blurred. Wait at least 1 minute — then send. The window closes at 15 minutes.",
      feedbackWrong: "Messages sent within the first minute after the chat ends appear blurred to the client. Always wait at least 1 minute before sending — then you have until the 15-minute mark."
    }
  ];

  const sortFragments = [
    { id: 1, text: "Greeting — a warm, personal opening" },
    { id: 2, text: "Detail from the session — something specific they shared" },
    { id: 3, text: "Intrigue — a hint at something valuable they haven't heard yet" },
    { id: 4, text: "Invitation to return — a gentle, clear CTA" }
  ];

  let sortOrder = [];

  function goToScreen(num) {
    const prev = document.getElementById('screen-' + currentScreen);
    prev.classList.remove('screen-visible');
    prev.classList.add('screen-hidden');
    currentScreen = num;
    const next = document.getElementById('screen-' + num);
    setTimeout(() => {
      next.classList.remove('screen-hidden');
      next.classList.add('screen-visible');
      updateProgress();
      if (num === 2) renderQuiz();
      if (num === 6) renderSort();
      if (num === 8) renderEndScreen();
      lucide.createIcons();
    }, 300);
  }

  function updateProgress() {
    const pct = ((currentScreen - 1) / 7) * 100;
    document.getElementById('progress-bar').style.width = pct + '%';
  }

  function renderQuiz() {
    const container = document.getElementById('quiz-container');
    if (quizIndex >= quizData.length) {
      container.innerHTML = `
        <div class="text-center py-8">
          <div class="inline-flex items-center justify-center w-16 h-16 rounded-full mb-4" style="background:rgba(34,197,94,0.15);">
            <i data-lucide="check-circle" style="width:32px;height:32px;color:#22c55e;"></i>
          </div>
          <p class="text-lg font-semibold mb-2" style="color:#f1f5f9;">Quiz complete!</p>
          <p class="text-sm mb-6" style="color:#94a3b8;">Now let's practice with real situations.</p>
          <button onclick="goToScreen(3)" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background:linear-gradient(135deg,#f97316,#ea580c);">
            Continue <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
          </button>
        </div>`;
      lucide.createIcons();
      return;
    }
    const q = quizData[quizIndex];
    container.innerHTML = `
      <div class="mb-4">
        <span class="text-xs font-semibold px-2 py-1 rounded" style="background:rgba(255,255,255,0.06);color:#94a3b8;">Question ${quizIndex+1} of ${quizData.length}</span>
      </div>
      <p class="text-lg font-semibold mb-5" style="color:#f1f5f9;">${q.q}</p>
      <div class="space-y-3" id="quiz-options">
        ${q.options.map((o, i) => `
          <button onclick="answerQuiz(${i})" class="option-btn w-full text-left px-5 py-4 rounded-xl flex items-center gap-3" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);color:#e2e8f0;">
            <span class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold" style="background:rgba(255,255,255,0.06);color:#94a3b8;">${String.fromCharCode(65+i)}</span>
            <span class="text-sm">${o}</span>
          </button>
        `).join('')}
      </div>
      <div id="quiz-feedback" class="hidden mt-4"></div>`;
  }

  function answerQuiz(idx) {
    const q = quizData[quizIndex];
    const correct = idx === q.correct;
    if (correct) score++;

    document.querySelectorAll('#quiz-options .option-btn').forEach((b, i) => {
      b.classList.add('disabled');
      if (i === q.correct) { b.style.borderColor='#22c55e'; b.style.background='rgba(34,197,94,0.1)'; }
      else if (i === idx && !correct) { b.style.borderColor='#ef4444'; b.style.background='rgba(239,68,68,0.1)'; }
    });

    const fb = document.getElementById('quiz-feedback');
    fb.classList.remove('hidden');
    fb.innerHTML = `
      <div class="toast-msg rounded-xl p-4 flex items-start gap-3 mb-4" style="background:${correct?'rgba(34,197,94,0.1)':'rgba(239,68,68,0.1)'};border:1px solid ${correct?'rgba(34,197,94,0.3)':'rgba(239,68,68,0.3)'};">
        <span class="text-lg">${correct?'✅':'❌'}</span>
        <p class="text-sm" style="color:#e2e8f0;">${correct?q.feedbackCorrect:q.feedbackWrong}</p>
      </div>
      <div class="text-center">
        <button onclick="nextQuiz()" class="inline-flex items-center gap-2 px-6 py-3 rounded-xl text-white font-semibold transition-all hover:scale-105" style="background:linear-gradient(135deg,#6378FD,#5169e8);">
          Continue <i data-lucide="arrow-right" style="width:18px;height:18px;"></i>
        </button>
      </div>`;
    lucide.createIcons();
  }

  function nextQuiz() {
    quizIndex++;
    renderQuiz();
    lucide.createIcons();
  }

  function answerS3(idx) {
    if (s3Done) return;
    s3Done = true;
    const correct = idx === 1;
    if (correct) score++;

    document.querySelectorAll('#s3-options .option-btn').forEach((b, i) => {
      b.classList.add('disabled');
      if (i === 1) { b.style.borderColor='#22c55e'; b.style.background='rgba(34,197,94,0.1)'; }
      else if (i === idx && !correct) { b.style.borderColor='#ef4444'; b.style.background='rgba(239,68,68,0.1)'; }
    });

    const feedbacks = [
      "The new client is important — but so is the 15-minute window. By the time there's a 'natural pause', it might already be too late. Sending an engagement message takes under a minute. That's a small interruption that can bring a client back.",
      "Yes! This is exactly right. Switch, send one short personal message, return. The whole thing takes under a minute. You're not abandoning the new client — you're protecting a relationship that already exists.",
      "Two problems here. First — 'Thank you for the session!' is a generic closing, not an engagement message with intrigue. Second — Engagement Messages should go through the Chats tab, not Pings."
    ];

    const fb = document.getElementById('s3-feedback');
    fb.classList.remove('hidden');
    fb.innerHTML = `
      <div class="toast-msg rounded-xl p-4 flex items-start gap-3" style="background:${correct?'rgba(34,197,94,0.1)':'rgba(239,68,68,0.1)'};border:1px solid ${correct?'rgba(34,197,94,0.3)':'rgba(239,68,68,0.3)'};">
        <span class="text-lg">${correct?'✅':'❌'}</span>
        <p class="text-sm" style="color:#e2e8f0;">${feedbacks[idx]}</p>
      </div>`;
    document.getElementById('s3-next').classList.remove('hidden');
    lucide.createIcons();
  }

  function answerS4(idx) {
    if (s4Done) return;
    s4Done = true;
    const correct = idx === 1;
    if (correct) score++;

    document.querySelectorAll('#s4-options .option-btn').forEach((b, i) => {
      b.classList.add('disabled');
      if (i === 1) { b.style.borderColor='#22c55e'; b.style.background='rgba(34,197,94,0.1)'; }
      else if (i === idx && !correct) { b.style.borderColor='#ef4444'; b.style.background='rgba(239,68,68,0.1)'; }
    });

    const feedbacks = [
      "Message length has nothing to do with blurring. The timing is the issue — sending within the first minute causes the message to appear blurred, regardless of how long it is.",
      "Exactly. If you send the engagement message within the first minute after the chat ends, it appears blurred to the client. They see something is there but can't read it. Always wait at least 1 minute — then send before the 15-minute window closes.",
      "Notifications have nothing to do with blurring. The blurred effect is caused by sending too early — within the first minute after the chat ends. It's a system behavior, not a client setting."
    ];

    const fb = document.getElementById('s4-feedback');
    fb.classList.remove('hidden');
    fb.innerHTML = `
      <div class="toast-msg rounded-xl p-4 flex items-start gap-3" style="background:${correct?'rgba(34,197,94,0.1)':'rgba(239,68,68,0.1)'};border:1px solid ${correct?'rgba(34,197,94,0.3)':'rgba(239,68,68,0.3)'};">
        <span class="text-lg">${correct?'✅':'❌'}</span>
        <p class="text-sm" style="color:#e2e8f0;">${feedbacks[idx]}</p>
      </div>`;
    document.getElementById('s4-next').classList.remove('hidden');
    lucide.createIcons();
  }

  function answerS5(idx) {
    if (s5Done) return;
    s5Done = true;
    const correct = idx === 1;
    if (correct) score++;

    document.querySelectorAll('#s5-options .option-btn').forEach((b, i) => {
      b.classList.add('disabled');
      if (i === 1) { b.style.borderColor='#22c55e'; b.style.background='rgba(34,197,94,0.1)'; }
      else if (i === idx && !correct) { b.style.borderColor='#ef4444'; b.style.background='rgba(239,68,68,0.1)'; }
    });

    const feedbacks = [
      "Option A closes the door. It's polite, but it doesn't give the client any reason to come back. 'Feel free to come back anytime' is passive — there's no intrigue, no hook, nothing that makes them curious.",
      "Yes! Option B is short, personal, and creates real intrigue. It references his behavior without spelling everything out, and ends with an open question that makes the client want to know more. That's exactly what an engagement message should do.",
      "Option C has no personal detail — it could have been sent to anyone. 'More insights' without any specifics doesn't feel personal. The client doesn't know what they're missing, so they have no real reason to return."
    ];

    const fb = document.getElementById('s5-feedback');
    fb.classList.remove('hidden');
    fb.innerHTML = `
      <div class="toast-msg rounded-xl p-4 flex items-start gap-3" style="background:${correct?'rgba(34,197,94,0.1)':'rgba(239,68,68,0.1)'};border:1px solid ${correct?'rgba(34,197,94,0.3)':'rgba(239,68,68,0.3)'};">
        <span class="text-lg">${correct?'✅':'❌'}</span>
        <p class="text-sm" style="color:#e2e8f0;">${feedbacks[idx]}</p>
      </div>`;
    document.getElementById('s5-next').classList.remove('hidden');
    lucide.createIcons();
  }

  function renderSort() {
    sortOrder = [...sortFragments].sort(() => Math.random() - 0.5);
    renderSortItems();
  }

  function renderSortItems() {
    const container = document.getElementById('sort-container');
    container.innerHTML = sortOrder.map((f, i) => `
      <div class="drag-item rounded-xl px-5 py-4 flex items-center gap-3" draggable="true"
           data-idx="${i}" style="background:rgba(255,255,255,0.04);border:2px solid rgba(255,255,255,0.08);">
        <span class="flex-shrink-0 w-8 h-8 rounded-full flex items-center justify-center text-sm font-bold" style="background:rgba(34,197,94,0.15);color:#22c55e;">${i+1}</span>
        <span class="text-sm" style="color:#e2e8f0;">${f.text}</span>
      </div>
    `).join('');

    const items = container.querySelectorAll('.drag-item');
    let dragIdx = null;

    items.forEach(item => {
      item.addEventListener('dragstart', e => {
        dragIdx = +item.dataset.idx;
        item.classList.add('dragging');
        e.dataTransfer.effectAllowed = 'move';
      });
      item.addEventListener('dragend', () => {
        item.classList.remove('dragging');
        container.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
      });
      item.addEventListener('dragover', e => { e.preventDefault(); item.classList.add('drag-over'); });
      item.addEventListener('dragleave', () => item.classList.remove('drag-over'));
      item.addEventListener('drop', e => {
        e.preventDefault();
        item.classList.remove('drag-over');
        const dropIdx = +item.dataset.idx;
        if (dragIdx !== null && dragIdx !== dropIdx) {
          const temp = sortOrder[dragIdx];
          sortOrder.splice(dragIdx, 1);
          sortOrder.splice(dropIdx, 0, temp);
          renderSortItems();
        }
      });

      let touchIdx = null;
      item.addEventListener('touchstart', e => { touchIdx = +item.dataset.idx; item.classList.add('dragging'); }, { passive: true });
      item.addEventListener('touchmove', e => {
        e.preventDefault();
        const touch = e.touches[0];
        const el = document.elementFromPoint(touch.clientX, touch.clientY);
        container.querySelectorAll('.drag-over').forEach(x => x.classList.remove('drag-over'));
        if (el && el.closest('.drag-item')) el.closest('.drag-item').classList.add('drag-over');
      }, { passive: false });
      item.addEventListener('touchend', e => {
        item.classList.remove('dragging');
        const touch = e.changedTouches[0];
        const el = document.elementFromPoint(touch.clientX, touch.clientY);
        container.querySelectorAll('.drag-over').forEach(x => x.classList.remove('drag-over'));
        if (el && el.closest('.drag-item')) {
          const dropIdx = +el.closest('.drag-item').dataset.idx;
          if (touchIdx !== null && touchIdx !== dropIdx) {
            const temp = sortOrder[touchIdx];
            sortOrder.splice(touchIdx, 1);
            sortOrder.splice(dropIdx, 0, temp);
            renderSortItems();
          }
        }
      });
    });
  }

  function checkSort() {
    const correct = sortOrder.every((f, i) => f.id === i + 1);
    const fb = document.getElementById('sort-feedback');
    fb.classList.remove('hidden');
    if (correct) {
      score++;
      fb.innerHTML = `<div class="toast-msg rounded-xl p-4 flex items-start gap-3" style="background:rgba(34,197,94,0.1);border:1px solid rgba(34,197,94,0.3);">
        <span class="text-lg">✅</span><p class="text-sm" style="color:#e2e8f0;">Perfect! Greeting → detail → intrigue → invitation. Short, personal, with a reason to come back. That's an engagement message that works.</p></div>`;
      document.getElementById('check-sort-btn').classList.add('hidden');
      document.getElementById('sort-next-btn').classList.remove('hidden');
    } else {
      fb.innerHTML = `<div class="toast-msg rounded-xl p-4 flex items-start gap-3" style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);">
        <span class="text-lg">🔄</span><p class="text-sm" style="color:#e2e8f0;">Not quite — try again. Think about what the client needs to feel first, before you give them a reason to come back.</p></div>`;
    }
    lucide.createIcons();
  }

  function renderEndScreen() {
    const pct = Math.round((score / totalPossible) * 100);
    const display = document.getElementById('score-display');
    let emoji = pct >= 80 ? '🌟' : pct >= 60 ? '👍' : '💪';
    let msg = pct >= 80 ? "Outstanding! You know exactly how to use the 15-minute window." : pct >= 60 ? "Good work! A few moments to sharpen." : "Keep practicing — the habit will build.";

    display.innerHTML = `
      <div class="text-5xl mb-3">${emoji}</div>
      <p class="text-4xl font-bold font-display mb-1" style="color:#22c55e;">${score}/${totalPossible}</p>
      <p class="text-sm" style="color:#94a3b8;">${msg}</p>`;

    const confetti = document.getElementById('confetti');
    confetti.innerHTML = '';
    if (pct >= 60) {
      const colors = ['#22c55e','#6378FD','#f97316','#fbbf24','#ec4899'];
      for (let i = 0; i < 40; i++) {
        const piece = document.createElement('div');
        piece.className = 'confetti-piece';
        piece.style.cssText = `left:${Math.random()*100}%;top:-10px;background:${colors[i%colors.length]};animation:fadeUp ${1+Math.random()*2}s ease-out ${Math.random()*0.5}s both;transform:rotate(${Math.random()*360}deg);`;
        confetti.appendChild(piece);
      }
    }
    lucide.createIcons();
  }

  function restartTraining() {
    score = 0; quizIndex = 0; s3Done = false; s4Done = false; s5Done = false;
    ['s3-feedback','s4-feedback','s5-feedback','sort-feedback'].forEach(id => document.getElementById(id).classList.add('hidden'));
    ['s3-next','s4-next','s5-next'].forEach(id => document.getElementById(id).classList.add('hidden'));
    document.getElementById('check-sort-btn').classList.remove('hidden');
    document.getElementById('sort-next-btn').classList.add('hidden');
    goToScreen(1);
  }

  lucide.createIcons();
  updateProgress();
</script>
</body>
</html>
