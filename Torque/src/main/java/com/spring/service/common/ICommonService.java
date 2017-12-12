package com.spring.service.common;

import java.util.HashMap;

import com.spring.model.BaseResponse;

public interface ICommonService {

	public BaseResponse getPlant();
	
	public BaseResponse getCarType();
	
	public BaseResponse getLine();
	
	public BaseResponse getStnType();
	
	public BaseResponse getShift();
	
	public BaseResponse getToolGroup(String plant_cd);
	
	public BaseResponse getToolID(String plant_cd, String device_grp_cd,String stn_gub,String line_cd,String web_display_flg);
	
	public BaseResponse getJobNoTool(String plant_cd, String car_type);
	
	public BaseResponse getToolType();
	
	public BaseResponse getToolState();
	
	public BaseResponse getUseFlage();
}
