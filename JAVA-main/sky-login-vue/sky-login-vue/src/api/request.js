import axios from 'axios'

// 创建 axios 实例：baseURL 用 /api，开发期由 vite 代理转发到后端 8081
const request = axios.create({
  baseURL: '/api',
  timeout: 10000,
  headers: { 'Content-Type': 'application/json;charset=utf-8' }
})

// 请求拦截器：可在此携带 token、统一加日志等（本演示暂留空）
request.interceptors.request.use(
  (config) => config,
  (error) => Promise.reject(error)
)

// 响应拦截器：统一处理后端 Result { code, msg, data }
//  - code === 200：返回整个 res.data（Result 对象），调用方再取 .data 即业务数据
//  - code !== 200：抛出 Error(msg)，组件 try/catch 即可拿到错误提示
request.interceptors.response.use(
  (response) => {
    const res = response.data
    if (res.code === 200) {
      return res
    }
    // 业务失败：抛出错误，组件 catch 中拿到 e.message
    return Promise.reject(new Error(res.msg || '请求失败'))
  },
  (error) => {
    // HTTP 异常或网络异常
    let msg = '网络异常，请稍后再试'
    if (error.response) {
      const data = error.response.data
      msg = (data && data.msg) ? data.msg : `请求出错（${error.response.status}）`
    } else if (error.message) {
      msg = error.message
    }
    return Promise.reject(new Error(msg))
  }
)

export default request
