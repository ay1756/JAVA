package com.fenglin.springboottest.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.fenglin.springboottest.dto.LoginDTO;
import com.fenglin.springboottest.dto.RegisterDTO;
import com.fenglin.springboottest.entity.User;
import com.fenglin.springboottest.mapper.UserMapper;
import com.fenglin.springboottest.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;

/**
 * 用户业务实现：继承 ServiceImpl<UserMapper, User> 后自动拥有 Mapper 与通用 CRUD
 */
@Slf4j
@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {

    /** MD5 加盐字符串（学习示例用，生产环境建议改用 BCryptPasswordEncoder） */
    private static final String SALT = "sky_login_2025";

    @Override
    public User login(LoginDTO dto) {
        // 1. 按用户名查询
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(User::getUsername, dto.getUsername());
        User user = getOne(wrapper);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        // 2. 校验密码（前端传明文 -> MD5 加盐 -> 与数据库比对）
        String md5Password = md5(dto.getPassword());
        if (!user.getPassword().equals(md5Password)) {
            throw new RuntimeException("密码错误");
        }
        // 3. 若登录时也选择了阵营，则回写（可选，不传则保持原值）
        if (dto.getFaction() != null && !dto.getFaction().isBlank()) {
            user.setFaction(dto.getFaction());
            updateById(user);
        }
        log.info("用户登录成功：{}", dto.getUsername());
        return user;
    }

    @Override
    public void register(RegisterDTO dto) {
        // 1. 用户名是否已存在
        LambdaQueryWrapper<User> usernameWrapper = new LambdaQueryWrapper<>();
        usernameWrapper.eq(User::getUsername, dto.getUsername());
        if (count(usernameWrapper) > 0) {
            throw new RuntimeException("用户名已被注册");
        }
        // 2. 构造实体并保存（密码加密入库）
        User user = new User();
        user.setUsername(dto.getUsername());
        user.setPassword(md5(dto.getPassword()));
        user.setFaction(dto.getFaction());
        save(user);
        log.info("用户注册成功：{}，阵营：{}", dto.getUsername(), dto.getFaction());
    }

    /** MD5 加盐 */
    private String md5(String text) {
        return DigestUtils.md5DigestAsHex((text + SALT).getBytes(StandardCharsets.UTF_8));
    }
}
