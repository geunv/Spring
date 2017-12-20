package com.spring.controller;

import static org.springframework.web.bind.annotation.RequestMethod.POST;
import static org.springframework.web.bind.annotation.RequestMethod.GET;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.spring.model.BaseResponse;
import com.spring.model.login.LoginRequest;
import com.spring.service.ILoginService;

import io.swagger.annotations.ApiOperation;

//@RequestMapping(value="/api/login")
@RestController
public class LoginController {

	@Autowired
	ILoginService loginService;
	
	@ApiOperation(value="로그인",notes = "ID / PWD ")
	@RequestMapping(value="/api/login",method=POST)
	public BaseResponse login(
			HttpServletRequest request, HttpServletResponse response,
			@RequestBody LoginRequest loginRequest){
		
		LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);
        localeResolver.setLocale(request, response, StringUtils.parseLocaleString(loginRequest.getLang()));
		
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
	
	
	@RequestMapping(value="/view/logout")
	public ModelAndView logout(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/logout");
		return mv;
	}
}
