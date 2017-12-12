package com.spring.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.spring.model.BaseResponse;
import com.spring.model.main.ResponseMainChart;
import com.spring.service.main.IMainService;

@RestController
public class MainController {
	
	@Autowired
	IMainService mainService;
	
	@RequestMapping(value="/api/getdisconnectedtoollist",method=GET)
	public BaseResponse getDisconnectedToolList(){
		return mainService.getDisconnectedToolList();
	}
		
	@RequestMapping(value="/api/getrepairtoolconnstatus",method=GET)
	public BaseResponse getRepairToolConnStatus(){
		return mainService.getRepairToolConnStatus();
	}
	
	@RequestMapping(value="/api/getThighteningResult",method=GET)
	public BaseResponse getThighteningResult(){
		
		ResponseMainChart res = new ResponseMainChart();
		res.setList(mainService.getThighteningResult());
		return res;
	}
}
