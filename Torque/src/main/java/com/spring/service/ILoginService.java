package com.spring.service;

import javax.servlet.http.HttpServletRequest;

import com.spring.model.BaseResponse;
import com.spring.model.login.ChangePassModel;
import com.spring.model.login.LoginRequest;

public interface ILoginService {
	public BaseResponse getLogin(HttpServletRequest request, LoginRequest loginRequest);
	
	public BaseResponse changePassword(ChangePassModel inputParam);
}
