package com.spring.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.model.BaseResponse;
import com.spring.model.common.ProcessDDLReturn;
import com.spring.model.common.ProgramDDLReturn;
import com.spring.service.common.ICommonService;

@RestController
public class CommonController {

	@Autowired
	ICommonService commonService;
	
	@RequestMapping(value="/api/common/getplant", method=GET)
	public BaseResponse getPlant(){
		
		return  commonService.getPlant();
	}
	
	@RequestMapping(value="/api/common/getcartype", method=GET)
	public BaseResponse getCarType(){
		
		return  commonService.getCarType();
	}
		
	@RequestMapping(value="/api/common/getline", method=GET)
	public BaseResponse getLine(){
		
		return  commonService.getLine();
	}
	
	@RequestMapping(value="/api/common/getstntype", method=GET)
	public BaseResponse getStnType(){
		
		return  commonService.getStnType();
	}
	
	@RequestMapping(value="/api/common/getshift", method=GET)
	public BaseResponse getShift(){
		
		return  commonService.getShift();
	}
	
	@RequestMapping(value="/api/common/gettoolgroup", method=GET)
	public BaseResponse getToolGroup(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd
			){
		
		return  commonService.getToolGroup(plant_cd);
	}
	
	
	//&device_grp_cd=" + vdevice_grp_cd + "&stn_gub=" + vstn_gub + "&line_cd=" + vline_cd + "&web_display_flg=" + vweb_display_flg
	@RequestMapping(value="/api/common/gettoolid", method=GET)
	public BaseResponse getToolList(
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="device_grp_cd", required=true, defaultValue="1") String device_grp_cd,
			@RequestParam(value="stn_gub", required=true, defaultValue="1") String stn_gub,
			@RequestParam(value="line_cd", required=true, defaultValue="-1") String line_cd,
			@RequestParam(value="web_display_flg", required=true, defaultValue="-1") String web_display_flg
			){
		
		return  commonService.getToolID(plant_cd,device_grp_cd,stn_gub,line_cd,web_display_flg);
	}
	
	
	
	@RequestMapping(value="/api/common/getjobnotool", method=GET)
	public BaseResponse getJobNoTool(
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="car_type", required=true, defaultValue="") String car_type
			){
		
		return  commonService.getJobNoTool(plant_cd,car_type);
	}
	
	@RequestMapping(value="/api/common/gettooltype", method=GET)
	public BaseResponse getToolType(){
		
		return  commonService.getToolType();
	}
	
	@RequestMapping(value="/api/common/gettoolstate", method=GET)
	public BaseResponse getToolState(){
		
		return  commonService.getToolState();
	}
	
	@RequestMapping(value="/api/common/getprocstate", method=GET)
	public BaseResponse getProcState(){
		
		return  commonService.getProcState();
	}
	
	@RequestMapping(value="/api/common/getpgmlist", method=GET)
	public List<ProgramDDLReturn> getPgmList(
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="stn_gub", required=false, defaultValue="-1") String stn_gub
			){

		return  commonService.getPgmList(plant_cd,stn_gub);
	}

	@RequestMapping(value="/api/common/getproclist", method=GET)
	public List<ProcessDDLReturn> getProcList(
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="stn_gub", required=false, defaultValue="-1") String stn_gub,
			@RequestParam(value="pgm_id", required=false, defaultValue="-1") String pgm_id
			){

		return  commonService.getProcList(plant_cd,stn_gub,pgm_id);
	}
	
	
	
	@RequestMapping(value="/api/common/getuseflag", method=GET)
	public BaseResponse getUseFlag(){
		return  commonService.getUseFlage();
	}
	
	@RequestMapping(value="/api/common/getshifttime", method=GET)
	public String getShiftTime(
			@RequestParam(value="code", required=false, defaultValue="1") String code
			){
		return  commonService.getShiftTime(code);
	}
	

}
