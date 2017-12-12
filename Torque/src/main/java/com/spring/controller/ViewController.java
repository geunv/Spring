package com.spring.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class ViewController {
	
	@RequestMapping("index")
	public ModelAndView index_view(){
		return new ModelAndView("index");
	}
}
