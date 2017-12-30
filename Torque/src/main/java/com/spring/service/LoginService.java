package com.spring.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.ILoginMapper;
import com.spring.dao.setting.ISettingMapper;
import com.spring.model.BaseResponse;
import com.spring.model.login.ChangePassModel;
import com.spring.model.login.LoginRequest;
import com.spring.model.login.LoginResult;
import com.spring.model.setting.UserInfoModel;

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
        	session.setAttribute("USER_GRADE", result.getWeb_user_permit().trim());
        	session.setAttribute("LAST_LOGIN_DT", result.getLast_login_dt().trim());
        	//session.setAttribute("grade", result.getUser_grp());
        	session.setAttribute("LANG", loginRequest.getLang());
		}else {
        	res.setResult(300);        	
        }
        
        return res;
	}
	
	public BaseResponse changePassword(ChangePassModel inputParam){
		BaseResponse res = new BaseResponse();
		//ILoginMapper mapper = sqlSession.getMapper(ILoginMapper.class);
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		ILoginMapper loginmapper = sqlSession.getMapper(ILoginMapper.class);
		
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", inputParam.getUser_id());
		map.put("user_pass", inputParam.getCurrent_password());
		map.put("user_new_pass",inputParam.getPassword1());
		
		List<UserInfoModel> info = mapper.selectUserInfo(map);
		
		
		if ( info.size() > 0 )	//  있는 사람
		{
			if ( info.get(0).getUser_pwd().trim().equals(inputParam.getCurrent_password())){	// DB Password AND input pass word match
				
				try{
					loginmapper.updateUserPassword(map);
				}catch(Exception e){
					res.setResult(300);	//update Error
				}
				
			}else{
				res.setResult(400);		// password not match	
			}
					
		}else{							// not a person
			res.setResult(500);
		}
		
		return res;
		
	}
}

