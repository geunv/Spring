package com.spring.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.model.BaseResponse;
import com.spring.model.menu.ResponseMenu;
import com.spring.service.menu.IMenuService;

import io.swagger.annotations.ApiOperation;

@RequestMapping(value="/api")
@RestController
public class MenuController {
	
	@Autowired
	IMenuService menuService;

	@ApiOperation(value = "메뉴", notes = "메뉴를 가져온다")
	@RequestMapping(value="/main-menu", method=GET)
	public BaseResponse menuMain(HttpServletRequest request){
		
		HttpSession session = request.getSession();
		
		ResponseMenu response = new ResponseMenu();
		response.setList(menuService.getMainMenu(session));
		
		return response;
		
		
	}
}
