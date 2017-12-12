package com.spring.service;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.ILoginMapper;
import com.spring.model.BaseResponse;
import com.spring.model.login.LoginRequest;
import com.spring.model.login.LoginResult;

@Service
public class LoginService implements ILoginService{
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public BaseResponse getLogin(HttpServletRequest request, LoginRequest loginRequest){
		ILoginMapper mapper = sqlSession.getMapper(ILoginMapper.class);
		LoginResult result = mapper.getLoginInfo(loginRequest.getUserId());
		
		BaseResponse res = new BaseResponse();
		
		if(result != null && result.getUser_pwd().trim().equals(loginRequest.getPassWd())){
			HttpSession session = request.getSession(true);
			session.setAttribute("PLANT_CD", result.getPlant_cd().trim());
        	session.setAttribute("USER_ID", loginRequest.getUserId().trim());
        	session.setAttribute("USER_GRP", result.getUser_grp().trim());
        	session.setAttribute("USER_NM", result.getUser_nm().trim());
        	session.setAttribute("APP_PERMIT", result.getApp_user_permit().trim());
        	session.setAttribute("WEB_PERMIT", result.getWeb_user_permit().trim());
        	session.setAttribute("LAST_LOGIN_DT", result.getLast_login_dt().trim());
        	//session.setAttribute("grade", result.getUser_grp());
        	session.setAttribute("LANG", loginRequest.getLang());
		}else {
        	res.setResult(300);        	
        }
        
        return res;
	}
}
