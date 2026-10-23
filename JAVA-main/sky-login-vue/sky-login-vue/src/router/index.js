import { createRouter, createWebHistory } from 'vue-router'
import LoginSky from '../components/LoginSky.vue'
import RegisterSky from '../components/RegisterSky.vue'
import WelcomeSky from '../components/WelcomeSky.vue'
import HomeSky from '../components/HomeSky.vue'
import HomeMain from '../components/HomeMain.vue'

const routes = [
  { path: '/', redirect: '/login' },
  { path: '/login', name: 'login', component: LoginSky },
  { path: '/register', name: 'register', component: RegisterSky },
  { path: '/welcome', name: 'welcome', component: WelcomeSky },
  { path: '/home', name: 'home', component: HomeSky },
  { path: '/main', name: 'main', component: HomeMain }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
