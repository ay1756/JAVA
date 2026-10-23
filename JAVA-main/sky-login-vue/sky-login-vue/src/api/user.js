import request from './request'

/**
 * 用户登录
 * @param {{ username: string, password: string }} data
 * @returns Promise<Result<User>>
 */
export function login(data) {
  return request.post('/user/login', data)
}

/**
 * 用户注册
 * @param {{ username: string, faction: string, password: string }} data
 * @returns Promise<Result<void>>
 */
export function register(data) {
  return request.post('/user/register', data)
}

/**
 * 联调自检接口
 */
export function hello() {
  return request.get('/user/hello')
}
