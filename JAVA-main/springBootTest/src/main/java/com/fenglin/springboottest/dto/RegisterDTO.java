package com.fenglin.springboottest.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 注册请求参数
 */
@Data
public class RegisterDTO {

    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "请选择你的阵营")
    private String faction;

    @NotBlank(message = "密码不能为空")
    private String password;
}
