package com.fenglin.springboottest.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.fenglin.springboottest.entity.User;
import org.apache.ibatis.annotations.Mapper;

/**
 * User 表的 Mapper：继承 BaseMapper 后即自动获得 selectById / insert / update 等方法，
 * 单表 CRUD 不用写任何 SQL。
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
}
