package com.spring.dao;

import java.util.HashMap;

import com.spring.model.login.LoginResult;

public interface ILoginMapper {

	public LoginResult getLoginInfo(String user_id);
	
	public void updateUserPassword(HashMap<String, Object> map);
}
