package com.fenglin.springboottest.common;

import lombok.Data;

import java.io.Serializable;

/**
 * 统一响应结构
 * {
 *   "code": 200,
 *   "msg":  "登录成功",
 *   "data": { ... }
 * }
 */
@Data
public class Result<T> implements Serializable {

    private Integer code;
    private String msg;
    private T data;

    public static <T> Result<T> success(String msg, T data) {
        Result<T> r = new Result<>();
        r.setCode(200);
        r.setMsg(msg);
        r.setData(data);
        return r;
    }

    public static <T> Result<T> success(T data) {
        return success("操作成功", data);
    }

    public static <T> Result<T> success() {
        return success("操作成功", null);
    }

    public static <T> Result<T> error(Integer code, String msg) {
        Result<T> r = new Result<>();
        r.setCode(code);
        r.setMsg(msg);
        r.setData(null);
        return r;
    }

    public static <T> Result<T> error(String msg) {
        return error(500, msg);
    }
}
