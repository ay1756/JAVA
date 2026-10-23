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

    <!-- 登录卡片 -->
    <main class="card">
      <svg class="candle" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
        <ellipse cx="32" cy="56" rx="14" ry="4" fill="rgba(255,255,255,0.25)" />
        <rect x="24" y="30" width="16" height="24" rx="4" fill="#fff3df" />
        <path d="M32 6c4 6 6 10 0 16-6-6-4-10 0-16z" fill="#ffd27a" />
        <path d="M32 12c2 4 3 6 0 10-3-4-2-6 0-10z" fill="#fff3b0" />
        <path d="M30 30h4v24h-4z" fill="#e9c79a" />
      </svg>

      <h1 class="title">光·遇</h1>
      <p class="subtitle">愿你所遇，皆成微光</p>

      <form class="login-form" @submit.prevent="onSubmit">
        <div class="field">
          <span class="ic">✦</span>
          <input v-model="username" type="text" name="username" placeholder="旅人之名" required />
        </div>
        <div class="field">
          <span class="ic">❂</span>
          <input v-model="password" type="password" name="password" placeholder="记忆之语" required />
        </div>
        <div class="field">
          <FactionSelect v-model="faction" placeholder="归属之境（可选）" />
        </div>

        <div class="row">
          <label><input v-model="remember" type="checkbox" name="remember" /> 铭记此身</label>
          <a href="#" @click.prevent>遗落了？找回</a>
        </div>

        <button class="btn" type="submit">{{ submitting ? '✦ 微光已亮 ✦' : '点 亮 前 行' }}</button>
      </form>

      <p class="alt">尚无旅伴？ <router-link to="/register">携手同游</router-link></p>
    </main>

    <p class="hint">— 在云端，与光相遇 —</p>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { login } from '../api/user'
import FactionSelect from './FactionSelect.vue'

// 背景图：默认放在 public/ 下，可传 props 覆盖
const props = defineProps({
  bgImage: { type: String, default: import.meta.env.BASE_URL + 'sky-bg-liuguang.png' }
})

const router = useRouter()

const username = ref('')
const password = ref('')
const faction = ref('')
const remember = ref(false)
const submitting = ref(false)

const meteors = [
  { top: '6%', left: '78%', dur: 9, delay: 0 },
  { top: '2%', left: '55%', dur: 12, delay: 4 },
  { top: '16%', left: '88%', dur: 11, delay: 7 },
  { top: '8%', left: '35%', dur: 14, delay: 10 }
]

async function onSubmit() {
  if (submitting.value) return
  submitting.value = true
  try {
    // 真实调用后端 /api/user/login
    const res = await login({
      username: username.value.trim(),
      password: password.value,
      faction: faction.value
    })
    // res 即后端 Result { code, msg, data }
    const user = res.data
    // 登录成功 → 跳转光遇风格欢迎页，携带用户名
    router.push({ path: '/welcome', query: { name: user.username, id: user.id } })
  } catch (e) {
    alert(e.message || '登录失败，请稍后再试')
  } finally {
    submitting.value = false
  }
}

// 轻微视差
let onMove = null
onMounted(() => {
  const card = document.querySelector('.card')
  onMove = (e) => {
    if (!card) return
    const x = (e.clientX / window.innerWidth - 0.5) * 10
    const y = (e.clientY / window.innerHeight - 0.5) * 8
    card.style.transform = `translate(${x}px, ${y}px)`
  }
  window.addEventListener('mousemove', onMove)
})
onUnmounted(() => {
  if (onMove) window.removeEventListener('mousemove', onMove)
})
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

/* 背景图 */
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

/* 极光飘带 */
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

/* 流星 */
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

/* 卡片 */
.card {
  position: relative;
  width: 380px;
  max-width: 90vw;
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
@keyframes rise {
  from { opacity: 0; transform: translateY(28px) scale(0.97); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
.card::before {
  content: "";
  position: absolute;
  inset: 0;
  border-radius: 28px;
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
  width: 56px; height: 56px;
  margin: 0 auto 14px;
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
  font-size: 30px;
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

.field { margin-top: 18px; position: relative; }
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

/* 阵营下拉：由 FactionSelect 组件渲染（可爱版），样式内置 */

.row {
  margin-top: 14px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 13px;
  color: rgba(226, 236, 255, 0.72);
}
.row label { display: flex; align-items: center; gap: 6px; cursor: pointer; }
.row a { color: #f2f6ff; text-decoration: none; opacity: 0.85; }
.row a:hover { opacity: 1; text-decoration: underline; }

.btn {
  margin-top: 22px;
  width: 100%;
  padding: 15px;
  border: none;
  border-radius: 16px;
  font-size: 16px;
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
