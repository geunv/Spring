package com.spring.controller;

import static org.springframework.web.bind.annotation.RequestMethod.POST;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.config.AesUtil;
import com.spring.model.BaseResponse;
import com.spring.model.login.ChangePassModel;
import com.spring.model.login.LoginRequest;
import com.spring.service.ILoginService;

import io.swagger.annotations.ApiOperation;

//@RequestMapping(value="/api/login")
@RestController
public class LoginController {

	private static final int KEY_SIZE = 128;
	private static final int ITERATION_COUNT = 100;
	private static final String IV = "F27D5C9927726BCEFE7510B1BDD3D137";
	private static final String SALT = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";
	private static final String PASSPHRASE = "KMM987654321";
	//private static final String PLAIN_TEXT = "AES ENCODING ALGORITHM PLAIN TEXT";    


	   
	@Autowired
	ILoginService loginService;

    
	@ApiOperation(value="로그인",notes = "ID / PWD ")
	@RequestMapping(value="/api/login",method=POST)
	public BaseResponse login(
			HttpServletRequest request, HttpServletResponse response,
			@RequestBody LoginRequest loginRequest) throws Exception{
		
		LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
        localeResolver.setLocale(request, response, StringUtils.parseLocaleString(loginRequest.getLang()));
		
        
        AesUtil util = new AesUtil(KEY_SIZE, ITERATION_COUNT);
        //String encrypt = util.encrypt(SALT, IV, PASSPHRASE, loginRequest.getPassWd());
        String decrypt = util.decrypt(SALT, IV, PASSPHRASE, loginRequest.getPassWd());
        
        loginRequest.setPassWd(decrypt);
        
		return loginService.getLogin(request,loginRequest);
		
	}
	
	
	@RequestMapping(value="/api/changeLanguage",method=POST)
	public BaseResponse changeLanguage(
			HttpServletRequest request, HttpServletResponse response,
			@RequestBody LoginRequest loginRequest){
		
		LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
        localeResolver.setLocale(request, response, StringUtils.parseLocaleString(loginRequest.getLang()));
		
        HttpSession session = request.getSession(true);
		
    	session.setAttribute("LANG", loginRequest.getLang());
    	
    	BaseResponse res = new BaseResponse();
    	
    	return res;
	}
	

	   
	
	
	@RequestMapping(value="/view/changepassword")
	public ModelAndView changePassword(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/changepassword");
		return mv;
	}
	
	
	@RequestMapping(value="/api/changepassword",method=POST)
	public BaseResponse changePassword(
			@RequestBody ChangePassModel inputparam){
		
		AesUtil util = new AesUtil(KEY_SIZE, ITERATION_COUNT);
        //String encrypt = util.encrypt(SALT, IV, PASSPHRASE, loginRequest.getPassWd());
        String dec_pass = util.decrypt(SALT, IV, PASSPHRASE, inputparam.getCurrent_password());
        String dec_pass1 = util.decrypt(SALT, IV, PASSPHRASE, inputparam.getPassword1());
        
		inputparam.setCurrent_password(dec_pass);
		inputparam.setPassword1(dec_pass1);
		return loginService.changePassword(inputparam);
    	
	}
	
	@RequestMapping(value="/view/logout")
	public ModelAndView logout(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/logout");
		return mv;
	}
	
}
