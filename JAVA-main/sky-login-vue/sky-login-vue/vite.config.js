import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: true,
    port: 5173,
    // 部署到反向代理域名时需要放行 host，否则 Vite 会拒绝请求
    allowedHosts: true,
    // 开发期把 /api 请求代理到后端 Spring Boot（端口 8081）
    // 这样前端用相对路径 /api/xxx 发请求，无需跨域配置即可联通
    proxy: {
      '/api': {
        target: 'http://localhost:8081',
        changeOrigin: true
      }
    }
  },
  preview: {
    host: true,
    port: 4173,
    allowedHosts: true
  }
})
