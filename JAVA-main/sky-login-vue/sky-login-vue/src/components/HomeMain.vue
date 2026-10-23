<template>
  <div class="sky-main">
    <!-- 蓝天背景（参照官网：浅蓝渐变天空） -->
    <div class="skyday" aria-hidden="true"></div>

    <!-- 漂浮白云层 -->
    <div class="cloudlayer" aria-hidden="true">
      <span v-for="(c, i) in floatClouds" :key="i" class="float-cloud"
        :style="{ top: c.top, width: c.w, height: c.h, animationDuration: c.dur + 's', animationDelay: c.delay + 's', opacity: c.op }"></span>
    </div>

    <!-- 阳光光晕 -->
    <div class="sunglow" aria-hidden="true"></div>

    <!-- 顶部导航栏（浅色玻璃，适配蓝天） -->
    <header class="nav">
      <div class="nav-inner">
        <router-link class="logo" to="/main">
          <svg class="logo-candle" viewBox="0 0 64 64" fill="none" xmlns="http://www.w3.org/2000/svg">
            <rect x="24" y="30" width="16" height="24" rx="4" fill="#fff3df" />
            <path d="M32 6c4 6 6 10 0 16-6-6-4-10 0-16z" fill="#ffd27a" />
            <path d="M32 12c2 4 3 6 0 10-3-4-2-6 0-10z" fill="#fff3b0" />
          </svg>
          <span>光·遇</span>
        </router-link>

        <nav class="links">
          <router-link
            v-for="item in navs"
            :key="item.label"
            :to="item.to"
            class="link"
            :class="{ active: isActive(item) }"
          >{{ item.label }}</router-link>
        </nav>

        <div class="nav-icons">
          <span v-for="ic in navIcons" :key="ic" class="n-ic" :title="ic">{{ ic }}</span>
        </div>
      </div>
    </header>

    <!-- 主体：三张高清场景图竖排，云朵渐变衔接（参照官网首页版式，文字暂不写） -->
    <main class="main">
      <!-- 顶部开场云海 -->
      <div class="cloud-band opening" aria-hidden="true">
        <span class="puff p1"></span>
        <span class="puff p2"></span>
        <span class="puff p3"></span>
        <span class="puff p4"></span>
      </div>

      <section
        v-for="(s, i) in scenes"
        :key="s.img"
        class="scene"
        :style="{ animationDelay: (i * 0.15) + 's' }"
      >
        <div class="scene-card">
          <img :src="s.img" alt="" loading="lazy" />
          <!-- 图片底部融进云朵的渐变 -->
          <div class="scene-fade" aria-hidden="true"></div>
          <span class="fade-puff fp1" aria-hidden="true"></span>
          <span class="fade-puff fp2" aria-hidden="true"></span>
          <!-- 右下角云朵贴角（遮住生成水印） -->
          <span class="corner-mask" aria-hidden="true"></span>
        </div>

        <!-- 图与图之间的云朵渐变带 -->
        <div class="cloud-band" aria-hidden="true">
          <span class="puff p1"></span>
          <span class="puff p2"></span>
          <span class="puff p3"></span>
          <span class="puff p4"></span>
          <span class="puff p5"></span>
        </div>
      </section>

      <p class="foot-hint">— 更多内容筹备中 · 敬请期待 —</p>
    </main>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'

const route = useRoute()

const navs = [
  { label: '首页', to: '/main' },
  { label: '云国资讯', to: '/home' },
  { label: '魔物志', to: '/home' },
  { label: '创作轮盘', to: '/home' },
  { label: '与光同行', to: '/home' }
]
const navIcons = ['🎶', '🕊️', '💬', '✨']

function isActive(item) {
  return (route.path === '/main' && item.label === '首页') ||
         (route.path === '/home' && item.label === '云国资讯')
}

// 三张高清场景图（AI 高清化：scene1~3-hd.png）
const scenes = [
  { img: '/images/home/scene1-hd.png' },
  { img: '/images/home/scene2-hd.png' },
  { img: '/images/home/scene3-hd.png' }
]

// 天空中的漂浮云朵
const floatClouds = [
  { top: '6%',  w: '260px', h: '90px',  dur: 26, delay: 0,  op: 0.9 },
  { top: '14%', w: '180px', h: '64px',  dur: 34, delay: -8, op: 0.7 },
  { top: '26%', w: '320px', h: '110px', dur: 40, delay: -16, op: 0.8 },
  { top: '40%', w: '220px', h: '76px',  dur: 30, delay: -4, op: 0.65 },
  { top: '55%', w: '280px', h: '96px',  dur: 44, delay: -20, op: 0.6 },
  { top: '70%', w: '200px', h: '70px',  dur: 36, delay: -12, op: 0.55 }
]
</script>

<style scoped>
.sky-main {
  position: relative;
  min-height: 100vh;
  overflow-x: hidden;
  color: #1d4e79;
  font-family: "PingFang SC", "Microsoft YaHei", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  padding-bottom: 30px;
}

/* ===== 蓝天背景（浅蓝渐变，参照官网） ===== */
.skyday {
  position: fixed;
  inset: 0;
  z-index: -5;
  background: linear-gradient(180deg,
    #5db9ef 0%,
    #8fd2f7 26%,
    #bce6fb 52%,
    #e3f4fd 78%,
    #f6fcff 100%);
}
/* 阳光光晕（左上角暖光） */
.sunglow {
  position: fixed;
  z-index: -4;
  top: -12%;
  left: -8%;
  width: 55vw;
  height: 55vw;
  border-radius: 50%;
  pointer-events: none;
  background: radial-gradient(closest-side, rgba(255, 250, 224, 0.55), rgba(255, 250, 224, 0) 70%);
}

/* ===== 漂浮白云 ===== */
.cloudlayer {
  position: fixed;
  inset: 0;
  z-index: -3;
  overflow: hidden;
  pointer-events: none;
}
.float-cloud {
  position: absolute;
  left: -20vw;
  border-radius: 50%;
  background:
    radial-gradient(closest-side, rgba(255, 255, 255, 0.98) 55%, rgba(255, 255, 255, 0) 100%),
    radial-gradient(60% 90% at 30% 70%, rgba(255,255,255,0.9), transparent 75%);
  filter: blur(6px);
  animation: floatAcross linear infinite;
}
@keyframes floatAcross {
  from { transform: translateX(-10vw); }
  to   { transform: translateX(130vw); }
}

/* ===== 顶部导航栏（浅色玻璃） ===== */
.nav {
  position: sticky;
  top: 0;
  z-index: 10;
  background: rgba(255, 255, 255, 0.55);
  border-bottom: 1px solid rgba(120, 175, 225, 0.35);
  backdrop-filter: blur(18px) saturate(1.25);
  -webkit-backdrop-filter: blur(18px) saturate(1.25);
  box-shadow: 0 8px 30px rgba(60, 120, 180, 0.18);
}
.nav-inner {
  max-width: 1080px;
  margin: 0 auto;
  padding: 0 24px;
  height: 64px;
  display: flex;
  align-items: center;
  gap: 26px;
}
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 20px;
  font-weight: 700;
  letter-spacing: 4px;
  color: #1d4e79;
  text-decoration: none;
  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.8);
  flex-shrink: 0;
}
.logo-candle {
  width: 30px; height: 30px;
  filter: drop-shadow(0 0 8px rgba(255, 210, 120, 0.9));
  animation: sway 4s ease-in-out infinite;
}
@keyframes sway {
  0%, 100% { transform: rotate(-3deg); }
  50%      { transform: rotate(3deg); }
}
.links {
  display: flex;
  align-items: center;
  gap: 4px;
  flex: 1;
  min-width: 0;
  overflow-x: auto;
  scrollbar-width: none;
}
.links::-webkit-scrollbar { display: none; }
.link {
  padding: 7px 12px;
  border-radius: 12px;
  font-size: 14px;
  letter-spacing: 1px;
  color: rgba(29, 78, 121, 0.75);
  text-decoration: none;
  white-space: nowrap;
  transition: color 0.25s, background 0.25s, box-shadow 0.25s;
}
.link:hover {
  color: #123c60;
  background: rgba(120, 185, 235, 0.25);
}
.link.active {
  color: #0f3a5f;
  font-weight: 700;
  background: linear-gradient(135deg, rgba(255, 255, 255, 0.95), rgba(205, 235, 255, 0.85));
  box-shadow: inset 0 0 0 1px rgba(130, 190, 235, 0.55), 0 4px 12px rgba(90, 150, 210, 0.25);
}
.nav-icons { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
.n-ic {
  width: 32px; height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 15px;
  background: rgba(255, 255, 255, 0.55);
  border: 1px solid rgba(130, 185, 230, 0.45);
  cursor: pointer;
  transition: transform 0.2s, background 0.25s, box-shadow 0.25s;
}
.n-ic:hover {
  transform: translateY(-2px);
  background: rgba(255, 255, 255, 0.85);
  box-shadow: 0 6px 16px rgba(90, 150, 210, 0.35);
}

/* ===== 主体 ===== */
.main {
  max-width: 980px;
  margin: 0 auto;
  padding: 0 24px;
}

/* ===== 场景图卡片 ===== */
.scene {
  animation: rise 0.9s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes rise {
  from { opacity: 0; transform: translateY(30px); }
  to   { opacity: 1; transform: translateY(0); }
}
.scene-card {
  position: relative;
  border-radius: 26px;
  overflow: hidden;
  border: 1px solid rgba(255, 255, 255, 0.85);
  box-shadow:
    0 18px 50px rgba(70, 130, 190, 0.35),
    0 0 30px rgba(255, 255, 255, 0.35),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
  transition: transform 0.3s, box-shadow 0.35s;
}
.scene-card:hover {
  transform: translateY(-5px);
  box-shadow:
    0 26px 60px rgba(70, 130, 190, 0.45),
    0 0 40px rgba(255, 255, 255, 0.5),
    inset 0 1px 0 rgba(255, 255, 255, 0.9);
}
.scene-card img {
  display: block;
  width: 100%;
  height: auto;
  transform: scale(1.001);
  transition: transform 0.6s cubic-bezier(0.22, 1, 0.36, 1);
}
.scene-card:hover img { transform: scale(1.04); }

/* 图片底部融进云朵的渐变（云朵渐变效果之一） */
.scene-fade {
  position: absolute;
  left: 0; right: 0; bottom: 0;
  height: 30%;
  pointer-events: none;
  background: linear-gradient(180deg, transparent 0%, rgba(240, 249, 255, 0.25) 55%, rgba(240, 249, 255, 0.7) 88%, rgba(244, 251, 255, 0.92) 100%);
}
.fade-puff {
  position: absolute;
  bottom: -18px;
  height: 46px;
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0));
  filter: blur(10px);
  pointer-events: none;
}
.fade-puff.fp1 { left: 8%;  width: 42%; }
.fade-puff.fp2 { right: 6%; width: 52%; bottom: -24px; }

/* 右下角云朵贴角：自然遮住图片角落的生成水印 */
.corner-mask {
  position: absolute;
  right: -22px;
  bottom: -24px;
  width: 150px;
  height: 70px;
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(248, 253, 255, 0.98) 45%, rgba(248, 253, 255, 0) 100%);
  filter: blur(7px);
  pointer-events: none;
}

/* ===== 云朵渐变带（图与图之间的衔接） ===== */
.cloud-band {
  position: relative;
  height: 130px;
  pointer-events: none;
  background:
    radial-gradient(60% 90% at 20% 60%, rgba(255, 255, 255, 0.75), transparent 70%),
    radial-gradient(55% 80% at 75% 45%, rgba(255, 255, 255, 0.65), transparent 70%),
    linear-gradient(180deg, transparent 0%, rgba(255, 255, 255, 0.28) 60%, transparent 100%);
}
.puff {
  position: absolute;
  border-radius: 50%;
  background: radial-gradient(closest-side, rgba(255, 255, 255, 0.98), rgba(255, 255, 255, 0));
  filter: blur(14px);
  animation: drift 9s ease-in-out infinite alternate;
}
.puff.p1 { left: 4%;  top: 28%; width: 220px; height: 74px; }
.puff.p2 { left: 30%; top: 48%; width: 300px; height: 88px; animation-delay: -2s; }
.puff.p3 { right: 18%; top: 30%; width: 260px; height: 80px; animation-delay: -4s; }
.puff.p4 { right: 2%;  top: 55%; width: 200px; height: 66px; animation-delay: -6s; }
.puff.p5 { left: 48%; top: 14%; width: 180px; height: 60px; animation-delay: -3s; opacity: 0.7; }
/* 开场云海稍矮一些 */
.cloud-band.opening { height: 110px; margin-top: 8px; }
.cloud-band.opening .puff { opacity: 0.8; }
@keyframes drift {
  from { transform: translateX(-14px) scale(1); }
  to   { transform: translateX(18px) scale(1.06); }
}

.foot-hint {
  margin: 26px 0 10px;
  text-align: center;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(29, 78, 121, 0.5);
}

/* ===== 响应式 ===== */
@media (max-width: 720px) {
  .nav-inner { gap: 12px; padding: 0 14px; }
  .nav-icons { display: none; }
  .main { padding: 0 14px; }
  .cloud-band { height: 90px; }
  .puff.p1 { width: 150px; height: 54px; }
  .puff.p2 { width: 200px; height: 62px; }
  .puff.p3 { width: 170px; height: 56px; }
  .puff.p4 { width: 140px; height: 48px; }
  .puff.p5 { width: 120px; height: 44px; }
}
</style>
