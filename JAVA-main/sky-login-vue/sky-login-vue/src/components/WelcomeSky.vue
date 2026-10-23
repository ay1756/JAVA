<template>
  <div class="sky-welcome">
    <!-- 晨曦天幕 -->
    <div class="dawn"></div>

    <!-- 暖阳柔光 -->
    <div class="sun"></div>

    <!-- 漂浮云团 -->
    <div class="clouds">
      <span v-for="(c, i) in clouds" :key="'c' + i" class="cloud"
        :style="{ top: c.top, left: c.left, width: c.w, height: c.h, animationDuration: c.dur + 's', animationDelay: c.delay + 's', opacity: c.op }"></span>
    </div>

    <!-- 上升的星之光（光遇收集之光） -->
    <div class="motes">
      <span v-for="(p, i) in motes" :key="'m' + i" class="mote"
        :style="{ left: p.left, width: p.s, height: p.s, animationDuration: p.dur + 's', animationDelay: p.delay + 's' }"></span>
    </div>

    <!-- 中央光之灵（带翼的光团） -->
    <div class="spirit">
      <svg viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <radialGradient id="bodyGlow" cx="50%" cy="45%" r="55%">
            <stop offset="0%" stop-color="#fff7e6" />
            <stop offset="45%" stop-color="#ffe6a8" />
            <stop offset="100%" stop-color="#ffc36b" />
          </radialGradient>
          <linearGradient id="wing" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stop-color="rgba(255,255,255,0.85)" />
            <stop offset="100%" stop-color="rgba(255,214,170,0.15)" />
          </linearGradient>
        </defs>
        <!-- 双翼 -->
        <path class="wing-l" d="M100 96 C58 70 36 92 30 132 C66 120 84 116 100 120 Z" fill="url(#wing)" />
        <path class="wing-r" d="M100 96 C142 70 164 92 170 132 C134 120 116 116 100 120 Z" fill="url(#wing)" />
        <!-- 光环 -->
        <circle cx="100" cy="96" r="46" fill="none" stroke="rgba(255,236,190,0.5)" stroke-width="2" />
        <!-- 身体光团 -->
        <circle cx="100" cy="96" r="34" fill="url(#bodyGlow)" />
        <circle cx="90" cy="86" r="10" fill="rgba(255,255,255,0.7)" opacity="0.8" />
        <!-- 飘带尾光 -->
        <path class="trail" d="M100 130 C100 160 96 184 100 200" stroke="rgba(255,214,170,0.5)" stroke-width="3" stroke-linecap="round" fill="none" />
      </svg>
    </div>

    <!-- 欢迎卡片 -->
    <main class="card">
      <div class="candle">
        <svg viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
          <ellipse cx="32" cy="56" rx="14" ry="4" fill="rgba(255,255,255,0.25)" />
          <rect x="24" y="30" width="16" height="24" rx="4" fill="#fff3df" />
          <path d="M32 6c4 6 6 10 0 16-6-6-4-10 0-16z" fill="#ffd27a" />
          <path d="M32 12c2 4 3 6 0 10-3-4-2-6 0-10z" fill="#fff3b0" />
          <path d="M30 30h4v24h-4z" fill="#e9c79a" />
        </svg>
      </div>

      <h1 class="welcome-title">欢迎登录</h1>
      <p class="welcome-name">愿光与你同在，{{ name || '旅人' }}</p>
      <p class="welcome-sub">你已点亮前行的烛火，云海之上，等你同游。</p>

      <div class="actions">
        <button class="go-btn" @click="goOn">继续前行 →</button>
        <router-link class="back" to="/login">← 返回云端</router-link>
      </div>
    </main>

    <p class="hint">— 在光遇，与你相遇 —</p>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const router = useRouter()
const route = useRoute()

// 用户名来自登录页跳转时携带的 query
const name = ref(route.query.name || '')
const id = ref(route.query.id || '')

const clouds = [
  { top: '18%', left: '8%', w: '220px', h: '70px', dur: 26, delay: 0, op: 0.5 },
  { top: '30%', left: '62%', w: '300px', h: '90px', dur: 34, delay: -6, op: 0.4 },
  { top: '12%', left: '44%', w: '180px', h: '60px', dur: 30, delay: -12, op: 0.35 },
  { top: '70%', left: '20%', w: '260px', h: '80px', dur: 38, delay: -3, op: 0.32 },
  { top: '76%', left: '66%', w: '200px', h: '64px', dur: 32, delay: -18, op: 0.3 }
]

// 生成上升的光点
const motes = []
for (let i = 0; i < 30; i++) {
  motes.push({
    left: (Math.random() * 100).toFixed(2) + '%',
    s: (4 + Math.random() * 8).toFixed(1) + 'px',
    dur: (7 + Math.random() * 8).toFixed(1),
    delay: (-Math.random() * 12).toFixed(1)
  })
}

function goOn() {
  // 前往首页（云国资讯）
  router.push('/home')
}

// 轻微视差
let onMove = null
onMounted(() => {
  const card = document.querySelector('.card')
  onMove = (e) => {
    if (!card) return
    const x = (e.clientX / window.innerWidth - 0.5) * 12
    const y = (e.clientY / window.innerHeight - 0.5) * 10
    card.style.transform = `translate(${x}px, ${y}px)`
  }
  window.addEventListener('mousemove', onMove)
})
onUnmounted(() => {
  if (onMove) window.removeEventListener('mousemove', onMove)
})
</script>

<style scoped>
.sky-welcome {
  position: fixed;
  inset: 0;
  overflow: hidden;
  color: #fff;
  font-family: "PingFang SC", "Microsoft YaHei", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 晨曦天幕：暖橙粉 → 薰衣草蓝 */
.dawn {
  position: absolute;
  inset: 0;
  z-index: -5;
  background:
    linear-gradient(180deg,
      #2a2350 0%,
      #5b4a8c 22%,
      #b07bb0 42%,
      #f0a38a 62%,
      #ffd6a8 82%,
      #fff0d6 100%);
}
/* 柔和暗角，让中央更聚焦 */
.dawn::after {
  content: "";
  position: absolute;
  inset: 0;
  background: radial-gradient(120% 90% at 50% 38%, transparent 50%, rgba(40, 24, 60, 0.45) 100%);
}

/* 暖阳柔光 */
.sun {
  position: absolute;
  top: 24%; left: 50%;
  width: 520px; height: 520px;
  transform: translate(-50%, -50%);
  border-radius: 50%;
  background: radial-gradient(circle, rgba(255, 244, 214, 0.95) 0%, rgba(255, 218, 160, 0.5) 28%, rgba(255, 190, 140, 0.0) 62%);
  z-index: -4;
  filter: blur(4px);
  animation: sunBreath 8s ease-in-out infinite;
}
@keyframes sunBreath {
  0%, 100% { opacity: 0.85; transform: translate(-50%, -50%) scale(1); }
  50%      { opacity: 1; transform: translate(-50%, -50%) scale(1.06); }
}

/* 云团 */
.clouds { position: absolute; inset: 0; z-index: -3; pointer-events: none; }
.cloud {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(255, 246, 232, 0.9), rgba(255, 232, 210, 0.0));
  filter: blur(6px);
  animation: drift linear infinite;
}
@keyframes drift {
  from { transform: translateX(-12vw); }
  to   { transform: translateX(12vw); }
}

/* 上升的星之光 */
.motes { position: absolute; inset: 0; z-index: -3; pointer-events: none; }
.mote {
  position: absolute;
  bottom: -20px;
  border-radius: 50%;
  background: radial-gradient(circle, #fff7e0 0%, rgba(255, 224, 170, 0.6) 50%, transparent 70%);
  box-shadow: 0 0 8px 2px rgba(255, 228, 178, 0.7);
  animation: rise ease-in infinite;
}
@keyframes rise {
  0%   { transform: translateY(0) scale(0.6); opacity: 0; }
  12%  { opacity: 1; }
  88%  { opacity: 0.9; }
  100% { transform: translateY(-108vh) scale(1); opacity: 0; }
}

/* 光之灵 */
.spirit {
  position: absolute;
  top: 14%; left: 50%;
  width: 150px; height: 150px;
  transform: translateX(-50%);
  z-index: -2;
  filter: drop-shadow(0 0 26px rgba(255, 214, 150, 0.85));
  animation: float 6s ease-in-out infinite;
}
.spirit svg { width: 100%; height: 100%; }
@keyframes float {
  0%, 100% { transform: translateX(-50%) translateY(0); }
  50%      { transform: translateX(-50%) translateY(-16px); }
}
.wing-l { transform-origin: 100px 110px; animation: flapL 4s ease-in-out infinite; }
.wing-r { transform-origin: 100px 110px; animation: flapR 4s ease-in-out infinite; }
@keyframes flapL {
  0%, 100% { transform: rotate(-6deg); }
  50%      { transform: rotate(8deg); }
}
@keyframes flapR {
  0%, 100% { transform: rotate(6deg); }
  50%      { transform: rotate(-8deg); }
}
.trail { animation: trailGlow 3s ease-in-out infinite; }
@keyframes trailGlow {
  0%, 100% { opacity: 0.4; }
  50%      { opacity: 0.9; }
}

/* 卡片 */
.card {
  position: relative;
  width: 400px;
  max-width: 90vw;
  padding: 38px 40px 34px;
  border-radius: 28px;
  background: rgba(60, 40, 78, 0.34);
  border: 1px solid rgba(255, 224, 200, 0.4);
  box-shadow:
    0 22px 60px rgba(60, 30, 70, 0.5),
    inset 0 1px 0 rgba(255, 240, 220, 0.4);
  backdrop-filter: blur(18px) saturate(1.2);
  -webkit-backdrop-filter: blur(18px) saturate(1.2);
  text-align: center;
  animation: rise 1.1s cubic-bezier(0.22, 1, 0.36, 1) both;
  transition: transform 0.25s ease-out;
}
@keyframes rise {
  from { opacity: 0; transform: translateY(28px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
.card::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: 28px;
  background: linear-gradient(115deg, transparent 30%, rgba(255, 230, 200, 0.18) 46%, rgba(255, 255, 255, 0.28) 50%, rgba(255, 230, 200, 0.18) 54%, transparent 70%);
  background-size: 260% 260%;
  animation: sheen 6s ease-in-out infinite;
  pointer-events: none;
}
@keyframes sheen {
  0%, 100% { background-position: 120% 120%; }
  50%      { background-position: -20% -20%; }
}

.candle {
  width: 48px; height: 48px;
  margin: 0 auto 12px;
  display: block;
  filter: drop-shadow(0 0 14px rgba(255, 220, 150, 0.9));
  animation: sway 4s ease-in-out infinite;
}
@keyframes sway {
  0%, 100% { transform: rotate(-3deg); }
  50%      { transform: rotate(3deg); }
}

.welcome-title {
  font-size: 32px;
  font-weight: 600;
  letter-spacing: 8px;
  text-shadow: 0 2px 22px rgba(255, 200, 150, 0.7);
}
.welcome-name {
  margin-top: 12px;
  font-size: 17px;
  letter-spacing: 2px;
  color: #fff4e2;
}
.welcome-sub {
  margin-top: 10px;
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(255, 244, 230, 0.78);
  line-height: 1.7;
}

.actions {
  margin-top: 26px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 14px;
}
.go-btn {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 16px;
  font-size: 16px;
  letter-spacing: 3px;
  font-weight: 600;
  color: #5a2f3f;
  cursor: pointer;
  background: linear-gradient(135deg, #fff1da 0%, #ffd6a8 50%, #ffbfae 100%);
  box-shadow: 0 10px 28px rgba(255, 170, 130, 0.5);
  transition: transform 0.2s, box-shadow 0.3s, filter 0.3s;
}
.go-btn:hover { transform: translateY(-2px); filter: brightness(1.05); box-shadow: 0 14px 34px rgba(255, 170, 130, 0.65); }
.go-btn:active { transform: translateY(0); }
.back {
  font-size: 13px;
  color: #fff4e2;
  text-decoration: none;
  opacity: 0.85;
}
.back:hover { text-decoration: underline; opacity: 1; }

.hint {
  position: fixed;
  bottom: 18px; left: 0; right: 0;
  text-align: center;
  font-size: 12px;
  color: rgba(255, 244, 230, 0.6);
  letter-spacing: 1px;
  text-shadow: 0 1px 8px rgba(40, 20, 40, 0.5);
}
</style>
