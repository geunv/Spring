package com.spring.model.login;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description="로그인 모델")
public class LoginRequest {
	
	@ApiModelProperty(value="아이디", required = true, position=1)
	String userId;
	
	@ApiModelProperty(value="비밀번호", required = true, position=2)
	String passWd;
	
	@ApiModelProperty(value="언어", required = true, position=3, example="en")
	String lang;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPassWd() {
		return passWd;
	}

	public void setPassWd(String passWd) {
		this.passWd = passWd;
	}

	public String getLang() {
		return lang;
	}

	public void setLang(String lang) {
		this.lang = lang;
	}
	
	
}
