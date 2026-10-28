package com.fenglin.springboottest.controller;

import com.fenglin.springboottest.common.Result;
import com.fenglin.springboottest.dto.LoginDTO;
import com.fenglin.springboottest.dto.RegisterDTO;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.service.UserService;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 用户接口（RESTful）
 *  - POST /api/user/login    登录
 *  - POST /api/user/register 注册
 *  - GET  /api/user/hello    联调自检
 */
@Slf4j
@RestController
@RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Result<User> login(@Valid @RequestBody LoginDTO dto) {
        log.info("登录请求：username={}", dto.getUsername());
        User user = userService.login(dto);
        // 返回前清空敏感字段
        user.setPassword(null);
        user.setDeleted(null);
        return Result.success("登录成功", user);
    }

    @PostMapping("/register")
    public Result<Void> register(@Valid @RequestBody RegisterDTO dto) {
        log.info("注册请求：username={}, faction={}", dto.getUsername(), dto.getFaction());
        userService.register(dto);
        return Result.success("注册成功", null);
    }

    @GetMapping("/hello")
    public Result<String> hello() {
        return Result.success("OK", "后端 sky-login 已就绪");
    }
}
