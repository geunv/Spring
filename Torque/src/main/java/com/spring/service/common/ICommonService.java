package com.spring.service.common;

import java.util.HashMap;
import java.util.List;

import com.spring.model.BaseResponse;
import com.spring.model.common.ProcessDDLReturn;
import com.spring.model.common.ProgramDDLReturn;
import com.spring.model.common.TighteningResultModel;

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
	
	public BaseResponse getProcState();
	
	public List<ProgramDDLReturn> getPgmList(String plant_cd, String stn_gub);
	
	public List<ProcessDDLReturn> getProcList(String plant_cd, String stn_gub, String pgm_id);
	
	public BaseResponse getUseFlage();
	
	public String getShiftTime(String code);
	
	public List<TighteningResultModel> getTighteningResult();
	
	public List<TighteningResultModel> getTighteningResultSimple();
	
	public BaseResponse getUserAuthority(String user_grade);
		
	public BaseResponse getUserGroup(String user_grade);
	
	public BaseResponse getSystemArea();
	
	public BaseResponse getLangType();
	
	public BaseResponse getCommonCodeGroup();

	public BaseResponse getInterLockType();
}
