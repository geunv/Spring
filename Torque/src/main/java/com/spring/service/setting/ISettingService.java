package com.spring.service.setting;

import java.util.List;

import com.spring.model.BaseResponse;
import com.spring.model.setting.JobNoInfo;
import com.spring.model.setting.ToolInfoModel;

public interface ISettingService {

	public BaseResponse getToolList(int page, 
			int show_count,
			String plant_cd,
			String stn_type,
			String device_grp_cd,
			String device,
			String device_type,
			String device_status,
			String excel_down
			);
	
	public BaseResponse insertToolId(ToolInfoModel insertParam);
	
	public List<ToolInfoModel> getToolInfo(String tool_id , String tool_serial);
	
	public BaseResponse updateToolId(ToolInfoModel updateParam);
	
	public BaseResponse deleteToolId(String plant_cd, String tool_id, String tool_serial);

	public BaseResponse getJobNolList(int page,
									  int show_count, 
									  String plant_cd, 
									  String car_type, 
									  String tool_id,
									  String excel_down );
	
	public BaseResponse insertJobNo(JobNoInfo inputparam);
}
