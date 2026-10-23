<template>
  <div class="sky-login-page">
    <!-- 流光星空背景图 -->
    <div class="sky" :style="{ backgroundImage: `url('${bgImage}')` }"></div>

    <!-- 动态流光层：极光飘带 -->
    <div class="aurora">
      <div class="ribbon r1"></div>
      <div class="ribbon r2"></div>
      <div class="ribbon r3"></div>
    </div>

    <!-- 划过的流星 -->
    <div class="meteors">
      <div
        v-for="(m, i) in meteors"
        :key="i"
        class="meteor"
        :style="{
          top: m.top,
          left: m.left,
          animationDuration: m.dur + 's',
          animationDelay: m.delay + 's'
        }"
      ></div>
    </div>

    <!-- 注册卡片 -->
    <main class="card">
      <svg class="candle" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
        <ellipse cx="32" cy="56" rx="14" ry="4" fill="rgba(255,255,255,0.25)" />
        <rect x="24" y="30" width="16" height="24" rx="4" fill="#fff3df" />
        <path d="M32 6c4 6 6 10 0 16-6-6-4-10 0-16z" fill="#ffd27a" />
        <path d="M32 12c2 4 3 6 0 10-3-4-2-6 0-10z" fill="#fff3b0" />
        <path d="M30 30h4v24h-4z" fill="#e9c79a" />
      </svg>

      <h1 class="title">光·遇</h1>
      <p class="subtitle">携手同游，点亮新程</p>

      <form class="login-form" @submit.prevent="onSubmit">
        <div class="field">
          <span class="ic">✦</span>
          <input v-model="username" type="text" name="username" placeholder="旅人之名" required />
        </div>
        <div class="field">
          <FactionSelect v-model="faction" placeholder="归属之境" />
        </div>
        <div class="field">
          <span class="ic">❂</span>
          <input v-model="password" type="password" name="password" placeholder="记忆之语" required />
        </div>
        <div class="field">
          <span class="ic">❉</span>
          <input v-model="confirm" type="password" name="confirm" placeholder="再忆一遍" required />
        </div>

        <!-- 图形验证码 -->
        <div class="field captcha-field">
          <span class="ic">⛨</span>
          <input v-model="captchaInput" type="text" maxlength="4" placeholder="图形之证" required />
          <canvas
            ref="captchaCanvas"
            class="captcha-canvas"
            width="80"
            height="38"
            title="点击刷新"
            @click="refreshCaptcha"
          ></canvas>
        </div>

        <div class="row">
          <label><input v-model="agree" type="checkbox" name="agree" required /> 我已阅知旅者契约</label>
        </div>

        <button class="btn" type="submit">{{ submitting ? '✦ 微光已起 ✦' : '携 手 同 行' }}</button>
      </form>

      <p class="alt">已有旅伴？ <router-link to="/login">直接同行</router-link></p>
    </main>

    <p class="hint">— 在云端，与光相遇 —</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { register } from '../api/user'
import FactionSelect from './FactionSelect.vue'

const props = defineProps({
  bgImage: { type: String, default: import.meta.env.BASE_URL + 'sky-bg-liuguang.png' }
})

const router = useRouter()

const username = ref('')
const faction = ref('')
const password = ref('')
const confirm = ref('')
const agree = ref(false)
const submitting = ref(false)

// 图形验证码
const captchaCanvas = ref(null)
const captchaText = ref('')
const captchaInput = ref('')

const rnd = (a, b) => Math.floor(Math.random() * (b - a + 1)) + a

function genCaptcha() {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'
  let s = ''
  for (let i = 0; i < 4; i++) s += chars[Math.floor(Math.random() * chars.length)]
  captchaText.value = s
}

function drawCaptcha() {
  genCaptcha()
  const c = captchaCanvas.value
  if (!c) return
  const ctx = c.getContext('2d')
  const w = c.width
  const h = c.height
  ctx.clearRect(0, 0, w, h)
  ctx.fillStyle = 'rgba(255,255,255,0.10)'
  ctx.fillRect(0, 0, w, h)
  // 干扰线
  for (let i = 0; i < 4; i++) {
    ctx.strokeStyle = `rgba(${rnd(120, 220)},${rnd(120, 220)},${rnd(120, 220)},0.5)`
    ctx.beginPath()
    ctx.moveTo(rnd(0, w), rnd(0, h))
    ctx.lineTo(rnd(0, w), rnd(0, h))
    ctx.stroke()
  }
  // 字符
  for (let i = 0; i < captchaText.value.length; i++) {
    ctx.save()
    ctx.translate(14 + i * 16, h / 2)
    ctx.rotate((Math.random() - 0.5) * 0.5)
    ctx.font = 'bold 18px Georgia, serif'
    ctx.fillStyle = `rgb(${rnd(120, 235)},${rnd(140, 235)},${rnd(180, 255)})`
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    ctx.fillText(captchaText.value[i], 0, 0)
    ctx.restore()
  }
  // 噪点
  for (let i = 0; i < 22; i++) {
    ctx.fillStyle = `rgba(255,255,255,${Math.random() * 0.4})`
    ctx.beginPath()
    ctx.arc(rnd(0, w), rnd(0, h), 1, 0, Math.PI * 2)
    ctx.fill()
  }
}

function refreshCaptcha() {
  drawCaptcha()
}

onMounted(drawCaptcha)

async function onSubmit() {
  if (submitting.value) return
  // 校验阵营必选
  if (!faction.value) {
    alert('请先选择你的「归属之境」。')
    return
  }
  // 校验图形验证码
  if (captchaInput.value.trim().toUpperCase() !== captchaText.value) {
    alert('图形之证不符，请重试。')
    refreshCaptcha()
    captchaInput.value = ''
    return
  }
  if (password.value !== confirm.value) {
    alert('两次「记忆之语」不一致，请再忆一遍。')
    return
  }
  submitting.value = true
  try {
    // 真实调用后端 /api/user/register
    await register({
      username: username.value.trim(),
      faction: faction.value,
      password: password.value
    })
    alert('欢迎加入，' + (username.value.trim() || '旅人') + '！\n注册成功，将返回登录。')
    // 注册成功后跳转回登录页
    router.push('/login')
  } catch (e) {
    alert(e.message || '注册失败，请稍后再试')
    refreshCaptcha()
    captchaInput.value = ''
  } finally {
    submitting.value = false
  }
}

const meteors = [
  { top: '6%', left: '78%', dur: 9, delay: 0 },
  { top: '2%', left: '55%', dur: 12, delay: 4 },
  { top: '16%', left: '88%', dur: 11, delay: 7 },
  { top: '8%', left: '35%', dur: 14, delay: 10 }
]
</script>

<style scoped>
.sky-login-page {
  position: fixed;
  inset: 0;
  overflow: hidden;
  color: #f2f6ff;
  font-family: "PingFang SC", "Microsoft YaHei", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  display: flex;
  align-items: center;
  justify-content: center;
}

.sky {
  position: absolute;
  inset: 0;
  background-position: center;
  background-size: cover;
  background-repeat: no-repeat;
  z-index: -4;
}
.sky::after {
  content: "";
  position: absolute;
  inset: 0;
  background:
    radial-gradient(120% 90% at 50% 50%, transparent 55%, rgba(8, 14, 40, 0.55) 100%),
    linear-gradient(180deg, rgba(8, 14, 40, 0.25) 0%, transparent 30%);
}

.aurora {
  position: absolute;
  inset: 0;
  z-index: -3;
  overflow: hidden;
  pointer-events: none;
  mix-blend-mode: screen;
}
.ribbon {
  position: absolute;
  width: 160vw;
  height: 140px;
  border-radius: 50%;
  filter: blur(38px);
  opacity: 0.35;
  background: linear-gradient(90deg, transparent, #7fd8ff 22%, #b28bff 48%, #66e0c8 72%, transparent);
  animation: flow ease-in-out infinite alternate;
}
.ribbon.r1 { top: 14%; transform: rotate(-9deg); animation-duration: 11s; }
.ribbon.r2 { top: 34%; transform: rotate(-7deg); opacity: 0.22; animation-duration: 15s; animation-delay: -4s; }
.ribbon.r3 { top: 52%; transform: rotate(-11deg); opacity: 0.16; animation-duration: 19s; animation-delay: -8s; }
@keyframes flow {
  from { transform: translateX(-14vw) rotate(-9deg) scaleY(0.9); opacity: 0.18; }
  to   { transform: translateX(10vw) rotate(-5deg) scaleY(1.15); opacity: 0.42; }
}

.meteors { position: absolute; inset: 0; z-index: -3; overflow: hidden; pointer-events: none; }
.meteor {
  position: absolute;
  width: 130px;
  height: 2px;
  border-radius: 2px;
  background: linear-gradient(90deg, transparent, rgba(210, 230, 255, 0.95));
  opacity: 0;
  transform: rotate(24deg);
  animation: shoot linear infinite;
}
.meteor::after {
  content: "";
  position: absolute;
  right: -3px; top: -2px;
  width: 6px; height: 6px;
  border-radius: 50%;
  background: #fff;
  box-shadow: 0 0 10px 3px rgba(190, 220, 255, 0.9);
}
@keyframes shoot {
  0%   { opacity: 0; transform: translate(0, 0) rotate(24deg); }
  4%   { opacity: 1; }
  14%  { opacity: 0; transform: translate(-52vw, 24vw) rotate(24deg); }
  100% { opacity: 0; transform: translate(-52vw, 24vw) rotate(24deg); }
}

/* 卡片：限高 + 内部滚动，确保不超出视口 */
.card {
  position: relative;
  width: 380px;
  max-width: 92vw;
  max-height: 92vh;
  overflow-y: auto;
  padding: 36px 38px 36px;
  border-radius: 28px;
  background: rgba(20, 32, 78, 0.38);
  border: 1px solid rgba(160, 190, 255, 0.35);
  box-shadow:
    0 20px 60px rgba(4, 10, 32, 0.55),
    inset 0 1px 0 rgba(210, 228, 255, 0.35);
  backdrop-filter: blur(18px) saturate(1.25);
  -webkit-backdrop-filter: blur(18px) saturate(1.25);
  animation: rise 1.1s cubic-bezier(0.22, 1, 0.36, 1) both;
  transition: transform 0.25s ease-out;
}
.card::-webkit-scrollbar { width: 6px; }
.card::-webkit-scrollbar-thumb { background: rgba(160, 190, 255, 0.4); border-radius: 3px; }
@keyframes rise {
  from { opacity: 0; transform: translateY(28px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
.card::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: 26px;
  background: linear-gradient(115deg, transparent 30%, rgba(180, 215, 255, 0.16) 46%, rgba(255, 255, 255, 0.22) 50%, rgba(180, 215, 255, 0.16) 54%, transparent 70%);
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
  filter: drop-shadow(0 0 14px rgba(255, 220, 150, 0.85));
  animation: sway 4s ease-in-out infinite;
}
@keyframes sway {
  0%, 100% { transform: rotate(-3deg); }
  50%      { transform: rotate(3deg); }
}

.title {
  text-align: center;
  font-size: 26px;
  font-weight: 600;
  letter-spacing: 6px;
  text-shadow: 0 2px 22px rgba(120, 170, 255, 0.6);
}
.subtitle {
  text-align: center;
  margin-top: 6px;
  font-size: 13px;
  letter-spacing: 2px;
  color: rgba(226, 236, 255, 0.72);
}

/* 表单收窄居中列，输入框左右对称 */
.login-form {
  width: 248px;
  margin: 0 auto;
}

.field { margin-top: 13px; position: relative; }
.field input {
  width: 100%;
  padding: 11px 16px 11px 44px;
  border-radius: 16px;
  border: 1px solid rgba(160, 190, 255, 0.3);
  background: rgba(16, 28, 66, 0.45);
  color: #f2f6ff;
  font-size: 15px;
  outline: none;
  transition: border-color 0.3s, background 0.3s, box-shadow 0.3s;
}
.field input::placeholder { color: rgba(210, 226, 255, 0.5); }
.field input:focus {
  border-color: rgba(150, 195, 255, 0.95);
  background: rgba(20, 34, 78, 0.55);
  box-shadow: 0 0 0 4px rgba(140, 180, 255, 0.55), 0 0 22px rgba(120, 170, 255, 0.35);
}
.field .ic {
  position: absolute;
  left: 15px; top: 50%;
  transform: translateY(-50%);
  font-size: 16px;
  opacity: 0.8;
}

/* 图形验证码行：flex 布局，输入框与验证码并排，输入框自适应缩短 */
.captcha-field {
  display: flex;
  align-items: center;
  gap: 8px;
}
.captcha-field input {
  flex: 1 1 auto;
  width: auto;
}
.captcha-canvas {
  flex: 0 0 80px;
  width: 80px;
  height: 38px;
  border-radius: 10px;
  border: 1px solid rgba(160, 190, 255, 0.3);
  cursor: pointer;
  background: rgba(255, 255, 255, 0.06);
}

.row {
  margin-top: 14px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 13px;
  color: rgba(226, 236, 255, 0.72);
}
.row label { display: flex; align-items: center; gap: 6px; cursor: pointer; }

.btn {
  margin-top: 22px;
  width: 100%;
  padding: 13px;
  border: none;
  border-radius: 15px;
  font-size: 15px;
  letter-spacing: 4px;
  font-weight: 600;
  color: #10203f;
  cursor: pointer;
  background: linear-gradient(135deg, #dceaff 0%, #a8c6ff 45%, #cdb4ff 100%);
  box-shadow: 0 10px 28px rgba(110, 150, 255, 0.45);
  transition: transform 0.2s, box-shadow 0.3s, filter 0.3s;
  position: relative;
  overflow: hidden;
}
.btn::after {
  content: "";
  position: absolute;
  top: 0; left: -80%;
  width: 60%; height: 100%;
  background: linear-gradient(115deg, transparent, rgba(255, 255, 255, 0.55), transparent);
  animation: btnSheen 3.2s ease-in-out infinite;
}
@keyframes btnSheen {
  0%   { left: -80%; }
  55%, 100% { left: 130%; }
}
.btn:hover { transform: translateY(-2px); filter: brightness(1.06); box-shadow: 0 14px 34px rgba(110, 150, 255, 0.6); }
.btn:active { transform: translateY(0); }

.alt {
  margin-top: 18px;
  text-align: center;
  font-size: 13px;
  color: rgba(226, 236, 255, 0.72);
}
.alt a { color: #f2f6ff; font-weight: 600; text-decoration: none; }
.alt a:hover { text-decoration: underline; }

.hint {
  position: fixed;
  bottom: 18px; left: 0; right: 0;
  text-align: center;
  font-size: 12px;
  color: rgba(220, 232, 255, 0.5);
  letter-spacing: 1px;
  text-shadow: 0 1px 8px rgba(0, 0, 0, 0.4);
}
</style>
