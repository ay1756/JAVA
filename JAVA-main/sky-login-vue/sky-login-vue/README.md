# 光·遇 登录 / 注册页（Vue 3 + Vite）

光遇风格的前端登录 / 注册演示项目，整体视觉保持一致：流光星空背景、玻璃拟态卡片、蜡烛微光、流光扫过动画。

## 技术栈
- Vue 3（`<script setup>` + SFC）
- Vite 6
- Vue Router 4（登录 / 注册路由互跳）
- Axios（已安装，演示态未接真实后端，可后续对接接口）

## 目录结构
```
sky-login-vue/
├─ index.html
├─ vite.config.js
├─ package.json
├─ public/
│  └─ sky-bg-liuguang.png      # 流光星空背景图
└─ src/
   ├─ main.js
   ├─ App.vue                  # <router-view/>
   ├─ router/index.js          # /login、/register
   └─ components/
      ├─ LoginSky.vue          # 登录页（无图形验证码，窄列居中、上下对称）
      └─ RegisterSky.vue       # 注册页（含 canvas 图形验证码）
```

## 启动方式
1. 进入项目根目录：在文件夹地址栏输入 `cmd` 回车（或 Shift+右键“在此处打开终端”）。
2. 安装依赖：
   ```
   npm install
   ```
3. 启动开发服务器：
   ```
   npm run dev
   ```
   终端会输出本地地址（默认 http://localhost:5173 ），浏览器打开即可。

- 登录页：`/login`
- 注册页：`/register`（`/` 会自动重定向到 `/login`）

## 说明
- 登录 / 注册目前为前端演示，提交后会提示成功但未连接真实后端。
- 背景图读取路径为 `import.meta.env.BASE_URL + 'sky-bg-liuguang.png'`，对应放在 `public/` 下即可。
- 接真实接口：把组件 `onSubmit` 里的演示逻辑替换为 Axios 请求（依赖已装好）。
