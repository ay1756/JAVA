package com.fenglin.springboottest.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.fenglin.springboottest.dto.LoginDTO;
import com.fenglin.springboottest.dto.RegisterDTO;
import com.fenglin.springboottest.entity.User;

/**
 * 用户业务接口：继承 IService 后自动获得 save / getById / list / remove 等方法
 */
public interface UserService extends IService<User> {

    /** 登录：校验用户名密码，返回用户信息 */
    User login(LoginDTO dto);

    /** 注册：校验用户名/邮箱是否已存在，写入数据库 */
    void register(RegisterDTO dto);
}
