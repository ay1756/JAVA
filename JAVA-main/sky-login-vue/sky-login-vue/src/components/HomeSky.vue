<template>
  <div class="sky-home">
    <!-- 流光星空背景（与登录页同源） -->
    <div class="sky" :style="{ backgroundImage: `url('${bgImage}')` }"></div>

    <!-- 极光飘带 -->
    <div class="aurora">
      <div class="ribbon r1"></div>
      <div class="ribbon r2"></div>
      <div class="ribbon r3"></div>
    </div>

    <!-- 流星 -->
    <div class="meteors">
      <div
        v-for="(m, i) in meteors"
        :key="i"
        class="meteor"
        :style="{ top: m.top, left: m.left, animationDuration: m.dur + 's', animationDelay: m.delay + 's' }"
      ></div>
    </div>

    <!-- 顶部导航栏 -->
    <header class="nav">
      <div class="nav-inner">
        <router-link class="logo" to="/home">
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
            @click="onNavClick(item)"
          >{{ item.label }}</router-link>
        </nav>

        <div class="nav-icons">
          <span v-for="ic in navIcons" :key="ic" class="n-ic" :title="ic">{{ ic }}</span>
        </div>
      </div>
    </header>

    <!-- 主体 -->
    <main class="main">
      <!-- 标题 + 搜索栏 -->
      <section class="hero">
        <h1 class="hero-title">
          云国资讯
          <svg class="spark" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M20 2c2 9 6 13 15 15-9 2-13 6-15 15-2-9-6-13-15-15 9-2 13-6 15-15z" fill="#bfe0ff" opacity="0.9"/>
            <path d="M31 26c1 4 2.5 5.5 6.5 6.5-4 1-5.5 2.5-6.5 6.5-1-4-2.5-5.5-6.5-6.5 4-1 5.5-2.5 6.5-6.5z" fill="#e6f1ff" opacity="0.8"/>
          </svg>
        </h1>

        <div class="search">
          <span class="s-ic">✦</span>
          <input
            v-model.trim="keyword"
            type="text"
            placeholder="搜寻云国的记忆…"
            name="search"
          />
          <button class="s-btn" type="button" @click="onSearch">🔍</button>
        </div>
      </section>

      <!-- 分类标签 -->
      <section class="tabs">
        <button
          v-for="t in tabs"
          :key="t"
          class="tab"
          :class="{ on: currentTab === t }"
          type="button"
          @click="currentTab = t"
        >{{ t }}</button>
      </section>

      <!-- 资讯列表 -->
      <section class="list">
        <article v-for="(n, i) in filtered" :key="n.id" class="news-card" :style="{ animationDelay: (i * 0.08) + 's' }">
          <div class="thumb">
            <img class="thumb-img" :src="n.img" :alt="n.title" loading="lazy" />
            <span class="thumb-tag">{{ n.tag }}</span>
          </div>
          <div class="body">
            <p class="date">{{ n.date }}</p>
            <h2 class="news-title">{{ n.title }}</h2>
            <p class="excerpt">{{ n.excerpt }}</p>
          </div>
        </article>

        <div v-if="filtered.length === 0" class="empty">
          <span class="empty-ic">🕯️</span>
          <p>云端暂无相关记忆，换个关键词试试吧</p>
        </div>
      </section>

      <p class="foot-hint">— 前端演示页 · 数据为本地静态 · 后端接口预留 —</p>
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

function isActive(item) {
  return (route.path === '/home' && item.label === '云国资讯') ||
         (route.path === '/main' && item.label === '首页')
}

const props = defineProps({
  bgImage: { type: String, default: import.meta.env.BASE_URL + 'sky-bg-liuguang.png' }
})

const meteors = [
  { top: '10%', left: '78%', dur: 9, delay: 0 },
  { top: '6%', left: '55%', dur: 12, delay: 4 },
  { top: '20%', left: '88%', dur: 11, delay: 7 },
  { top: '12%', left: '35%', dur: 14, delay: 10 }
]

const navs = [
  { label: '首页', to: '/main' },
  { label: '云国资讯', to: '/home' },
  { label: '魔物志', to: '/home' },
  { label: '创作轮盘', to: '/home' },
  { label: '与光同行', to: '/home' }
]
const navIcons = ['🎶', '🕊️', '💬', '✨']

const tabs = ['最新', '新闻', '公告', '活动', '采访']
const currentTab = ref('最新')
const keyword = ref('')
const searched = ref('')

// 本地静态资讯（纯前端演示；后端资讯接口预留，届时替换为 api 调用即可）
// img 指向 public/images/news/ 下的真实缩略图，方框内等比缩放铺满
const news = [
  {
    id: 1, tab: '公告', date: '2026-10-20', img: '/images/news/evil-play.jpg', tag: '恶作剧',
    title: '来场不一样的恶作剧！| 《光·遇》恶作剧之日更新内容公告',
    excerpt: '10月24日，《光·遇》恶作剧之日正式开启！巫师小学开学，快来天空王国魔法学院，开启一场魔法之旅，和小巫师们一起策划一场不一样的恶作剧吧。'
  },
  {
    id: 2, tab: '公告', date: '2026-10-19', img: '/images/news/vangogh.jpg', tag: '小梢筑愿',
    title: '小镇筑居 陈设系列 | 《光·遇》致梵高主题小屋更新公告',
    excerpt: '小镇筑居，与光为邻！10月22日起，完成《光·遇》奇妙之旅：筑巢季季节任务和《光·遇》致梵高季任务的旅人，即可体验致梵高主题小屋，在向日葵与星空间安个家。'
  },
  {
    id: 3, tab: '公告', date: '2026-10-13', img: '/images/news/pearl.jpg', tag: '探海寻珍',
    title: '探海寻珍 携光同游 | 《光·遇》奇妙之旅：珍珍珠季 更新内容公告',
    excerpt: '海域辽阔，共遵星光！10月22日，《光·遇》奇妙之旅：珍珍珠季正式开启，全新季节场景上线，光之子们可以在波光粼粼的星光海中航行，探访静谧的海底花园与隐匿的海岸村落。'
  },
  {
    id: 4, tab: '新闻', date: '2026-10-06', img: '/images/news/art.jpg', tag: '同人共赏',
    title: '灵感交接 共忆秋青 | 《光·遇》秋节同人作品共赏',
    excerpt: '灵感交接，共忆秋青！本次秋节同人作品共赏精选了社区画师们的佳作，从云野的落日到霞谷的雪原，每一笔都是旅人们写给天空王国的情书。'
  },
  {
    id: 5, tab: '活动', date: '2026-10-02', img: '/images/news/minecraft.jpg', tag: '方块联动',
    title: '方块筑梦 云端相逢 | 《光·遇》《我的世界》联动活动正式开启！',
    excerpt: '方块筑梦，云端相逢！《光·遇》×《我的世界》联动活动10月2日正式开启，两个世界的旅人在云野相遇，限时任务与联动礼包同步上线，遇见方块新朋友！'
  },
  {
    id: 6, tab: '采访', date: '2026-10-01', img: '/images/news/flowers.jpg', tag: '旅人手记',
    title: '万千星光 熠熠皆见 | 《光·遇》致梵高 同人创作分享',
    excerpt: '万千星光，熠熠皆见！本次致梵高同人创作分享收录了旅人们以花枝与白鸟为题的画作，向梵高笔下的杏花致敬，也把春天永远留在了云国。'
  },
  {
    id: 7, tab: '活动', date: '2026-09-27', img: '/images/news/kites.jpg', tag: '缤纷飞行日',
    title: '缤纷入画 心意乘风 | 《光·遇》缤纷飞行日同人作品分享',
    excerpt: '缤纷入画，心意乘风！缤纷飞行日同人作品分享来啦，漫天纸鸢与彩虹色的梦一起飞上云端，快来看看旅人们笔下乘风而起的祝福吧。'
  }
]

// 前端本地筛选：分类标签 + 搜索关键词（不调用后端）
const filtered = computed(() => {
  const kw = searched.value.toLowerCase()
  return news.filter(n => {
    const okTab = currentTab.value === '最新' || n.tab === currentTab.value
    const okKw = !kw || n.title.toLowerCase().includes(kw) || n.excerpt.toLowerCase().includes(kw) || n.tag.includes(kw)
    return okTab && okKw
  })
})

function onNavClick(item) {
  // 点击「云国资讯」直接整页刷新
  if (item.label === '云国资讯') {
    window.location.reload()
  }
}

function onSearch() {
  searched.value = keyword.value
}
</script>

<style scoped>
.sky-home {
  position: relative;
  min-height: 100vh;
  overflow-x: hidden;
  color: #f2f6ff;
  font-family: "PingFang SC", "Microsoft YaHei", -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
  padding-bottom: 40px;
}

/* ===== 背景（与登录页同源） ===== */
.sky {
  position: fixed;
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
  position: fixed;
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
  opacity: 0.3;
  background: linear-gradient(90deg, transparent, #7fd8ff 22%, #b28bff 48%, #66e0c8 72%, transparent);
  animation: flow ease-in-out infinite alternate;
}
.ribbon.r1 { top: 14%; transform: rotate(-9deg); animation-duration: 11s; }
.ribbon.r2 { top: 34%; transform: rotate(-7deg); opacity: 0.2; animation-duration: 15s; animation-delay: -4s; }
.ribbon.r3 { top: 52%; transform: rotate(-11deg); opacity: 0.14; animation-duration: 19s; animation-delay: -8s; }
@keyframes flow {
  from { transform: translateX(-14vw) rotate(-9deg) scaleY(0.9); opacity: 0.16; }
  to   { transform: translateX(10vw) rotate(-5deg) scaleY(1.15); opacity: 0.36; }
}
.meteors { position: fixed; inset: 0; z-index: -3; overflow: hidden; pointer-events: none; }
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

/* ===== 顶部导航栏 ===== */
.nav {
  position: sticky;
  top: 0;
  z-index: 10;
  background: rgba(14, 24, 58, 0.5);
  border-bottom: 1px solid rgba(160, 190, 255, 0.22);
  backdrop-filter: blur(18px) saturate(1.25);
  -webkit-backdrop-filter: blur(18px) saturate(1.25);
  box-shadow: 0 8px 30px rgba(4, 10, 32, 0.35);
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
  color: #f2f6ff;
  text-decoration: none;
  text-shadow: 0 2px 18px rgba(120, 170, 255, 0.65);
  flex-shrink: 0;
}
.logo-candle {
  width: 30px; height: 30px;
  filter: drop-shadow(0 0 10px rgba(255, 220, 150, 0.9));
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
  color: rgba(226, 236, 255, 0.78);
  text-decoration: none;
  white-space: nowrap;
  transition: color 0.25s, background 0.25s, text-shadow 0.25s;
}
.link:hover {
  color: #fff;
  background: rgba(120, 165, 255, 0.18);
  text-shadow: 0 0 14px rgba(150, 195, 255, 0.8);
}
.link.active {
  color: #fff;
  font-weight: 600;
  background: linear-gradient(135deg, rgba(168, 198, 255, 0.3), rgba(205, 180, 255, 0.26));
  box-shadow: inset 0 0 0 1px rgba(170, 200, 255, 0.4);
}
.nav-icons { display: flex; align-items: center; gap: 8px; flex-shrink: 0; }
.n-ic {
  width: 32px; height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
  font-size: 15px;
  background: rgba(120, 165, 255, 0.14);
  border: 1px solid rgba(160, 190, 255, 0.3);
  cursor: pointer;
  transition: transform 0.2s, background 0.25s, box-shadow 0.25s;
}
.n-ic:hover {
  transform: translateY(-2px);
  background: rgba(140, 180, 255, 0.28);
  box-shadow: 0 6px 16px rgba(110, 150, 255, 0.4);
}

/* ===== 主体 ===== */
.main {
  max-width: 900px;
  margin: 0 auto;
  padding: 34px 24px 0;
}

/* 标题 + 搜索栏（参照官网：标题居中偏左，搜索在右） */
.hero {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 34px;
  flex-wrap: wrap;
}
.hero-title {
  margin: 0;
  font-size: 34px;
  font-weight: 700;
  letter-spacing: 10px;
  text-shadow: 0 2px 24px rgba(120, 170, 255, 0.65);
  display: flex;
  align-items: center;
  gap: 8px;
}
.spark { width: 30px; height: 30px; animation: twinkle 3s ease-in-out infinite; }
@keyframes twinkle {
  0%, 100% { transform: scale(1) rotate(0deg); opacity: 0.85; }
  50%      { transform: scale(1.18) rotate(12deg); opacity: 1; }
}

.search {
  position: relative;
  width: 300px;
  max-width: 80vw;
  display: flex;
  align-items: center;
}
.search .s-ic {
  position: absolute;
  left: 14px;
  font-size: 14px;
  opacity: 0.75;
  pointer-events: none;
}
.search input {
  width: 100%;
  padding: 11px 52px 11px 38px;
  border-radius: 999px;
  border: 1px solid rgba(160, 190, 255, 0.3);
  background: rgba(16, 28, 66, 0.45);
  color: #f2f6ff;
  font-size: 14px;
  outline: none;
  transition: border-color 0.3s, background 0.3s, box-shadow 0.3s;
}
.search input::placeholder { color: rgba(210, 226, 255, 0.5); }
.search input:focus {
  border-color: rgba(150, 195, 255, 0.95);
  background: rgba(20, 34, 78, 0.55);
  box-shadow: 0 0 0 4px rgba(140, 180, 255, 0.45), 0 0 22px rgba(120, 170, 255, 0.3);
}
.s-btn {
  position: absolute;
  right: 5px;
  width: 34px; height: 34px;
  border: none;
  border-radius: 50%;
  font-size: 14px;
  cursor: pointer;
  color: #10203f;
  background: linear-gradient(135deg, #dceaff 0%, #a8c6ff 60%, #cdb4ff 100%);
  box-shadow: 0 4px 14px rgba(110, 150, 255, 0.5);
  transition: transform 0.2s, box-shadow 0.25s, filter 0.25s;
}
.s-btn:hover { transform: scale(1.08); filter: brightness(1.06); box-shadow: 0 6px 18px rgba(110, 150, 255, 0.65); }
.s-btn:active { transform: scale(0.98); }

/* ===== 分类标签 ===== */
.tabs {
  margin-top: 26px;
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 6px;
  padding: 6px;
  width: fit-content;
  margin-left: auto;
  margin-right: auto;
  border-radius: 999px;
  background: rgba(14, 24, 58, 0.42);
  border: 1px solid rgba(160, 190, 255, 0.28);
  backdrop-filter: blur(14px);
  -webkit-backdrop-filter: blur(14px);
}
.tab {
  padding: 8px 20px;
  border: none;
  border-radius: 999px;
  background: transparent;
  color: rgba(226, 236, 255, 0.78);
  font-size: 14px;
  letter-spacing: 2px;
  cursor: pointer;
  transition: color 0.25s, background 0.3s, box-shadow 0.3s, transform 0.2s;
}
.tab:hover { color: #fff; background: rgba(120, 165, 255, 0.16); }
.tab.on {
  color: #10203f;
  font-weight: 700;
  background: linear-gradient(135deg, #dceaff 0%, #a8c6ff 55%, #cdb4ff 100%);
  box-shadow: 0 6px 18px rgba(110, 150, 255, 0.5);
  transform: translateY(-1px);
}

/* ===== 资讯列表 ===== */
.list {
  margin-top: 30px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.news-card {
  display: flex;
  gap: 22px;
  padding: 20px;
  border-radius: 22px;
  background: rgba(20, 32, 78, 0.38);
  border: 1px solid rgba(160, 190, 255, 0.3);
  box-shadow:
    0 14px 40px rgba(4, 10, 32, 0.45),
    inset 0 1px 0 rgba(210, 228, 255, 0.3);
  backdrop-filter: blur(16px) saturate(1.2);
  -webkit-backdrop-filter: blur(16px) saturate(1.2);
  cursor: pointer;
  transition: transform 0.25s, box-shadow 0.3s, border-color 0.3s;
  animation: rise 0.8s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes rise {
  from { opacity: 0; transform: translateY(24px) scale(0.98); }
  to   { opacity: 1; transform: translateY(0) scale(1); }
}
.news-card:hover {
  transform: translateY(-4px);
  border-color: rgba(170, 205, 255, 0.6);
  box-shadow:
    0 20px 52px rgba(4, 10, 32, 0.55),
    0 0 26px rgba(120, 170, 255, 0.28),
    inset 0 1px 0 rgba(210, 228, 255, 0.35);
}

/* 缩略图：渐变占位（无真实图片时的可爱替代） */
.thumb {
  position: relative;
  flex: 0 0 210px;
  height: 132px;
  border-radius: 16px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: inset 0 0 0 1px rgba(255, 255, 255, 0.22), 0 6px 18px rgba(4, 10, 32, 0.4);
}
.thumb::after {
  content: "";
  position: absolute;
  inset: 0;
  background: linear-gradient(115deg, transparent 32%, rgba(255, 255, 255, 0.28) 48%, rgba(255, 255, 255, 0.34) 52%, rgba(255, 255, 255, 0.24) 60%, transparent 72%);
  background-size: 240% 240%;
  animation: sheen 5.5s ease-in-out infinite;
}
@keyframes sheen {
  0%, 100% { background-position: 120% 120%; }
  50%      { background-position: -20% -20%; }
}
/* 缩略图：真实图片等比缩放铺满方框（方框多大，图片就铺多大） */
.thumb-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transform: scale(1.001);
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}
.news-card:hover .thumb-img { transform: scale(1.07); }
.thumb-tag {
  position: absolute;
  left: 10px;
  bottom: 8px;
  padding: 3px 10px;
  border-radius: 999px;
  font-size: 11px;
  letter-spacing: 1px;
  color: #fff;
  background: rgba(10, 18, 42, 0.45);
  border: 1px solid rgba(255, 255, 255, 0.35);
  backdrop-filter: blur(6px);
}

.body { flex: 1; min-width: 0; display: flex; flex-direction: column; }
.date {
  margin: 0;
  font-size: 12px;
  letter-spacing: 2px;
  color: rgba(200, 218, 255, 0.62);
}
.news-title {
  margin: 8px 0 0;
  font-size: 18px;
  font-weight: 700;
  letter-spacing: 1px;
  color: #bfe0ff;
  text-shadow: 0 0 16px rgba(130, 180, 255, 0.45);
  transition: color 0.25s, text-shadow 0.25s;
}
.news-card:hover .news-title {
  color: #e6f2ff;
  text-shadow: 0 0 20px rgba(160, 200, 255, 0.75);
}
.excerpt {
  margin: 10px 0 0;
  font-size: 13.5px;
  line-height: 1.8;
  color: rgba(224, 234, 255, 0.72);
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* 空状态 */
.empty {
  padding: 56px 0;
  text-align: center;
  color: rgba(224, 234, 255, 0.65);
  font-size: 14px;
  letter-spacing: 2px;
}
.empty-ic { font-size: 44px; display: block; margin-bottom: 12px; filter: drop-shadow(0 0 16px rgba(255, 220, 150, 0.7)); }

.foot-hint {
  margin-top: 36px;
  text-align: center;
  font-size: 12px;
  letter-spacing: 1px;
  color: rgba(220, 232, 255, 0.45);
  text-shadow: 0 1px 8px rgba(0, 0, 0, 0.35);
}

/* ===== 响应式 ===== */
@media (max-width: 720px) {
  .nav-inner { gap: 12px; padding: 0 14px; }
  .nav-icons { display: none; }
  .hero { gap: 16px; }
  .hero-title { font-size: 26px; letter-spacing: 6px; }
  .news-card { flex-direction: column; gap: 14px; }
  .thumb { flex: none; width: 100%; }
}
</style>
