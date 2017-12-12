package com.spring.dao;

import com.spring.model.login.LoginResult;

public interface ILoginMapper {

	public LoginResult getLoginInfo(String user_id);
}
