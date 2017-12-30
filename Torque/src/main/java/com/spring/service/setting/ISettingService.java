package com.spring.service.setting;

import java.util.List;

import com.spring.model.BaseResponse;
import com.spring.model.setting.JobNoInfo;
import com.spring.model.setting.ToolInfoModel;
import com.spring.model.setting.UserInfoModel;
import com.spring.model.setting.UserInsertParam;

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

	/*					*/
	public BaseResponse getJobNolList(int page,
									  int show_count, 
									  String plant_cd, 
									  String car_type, 
									  String tool_id,
									  String excel_down );
	
	public BaseResponse insertJobNo(JobNoInfo inputparam);
	/*					*/
	
	
	/*					*/
	public BaseResponse getUserList(String plant_cd,String user_authority,String user_grp,String user_id,String user_nm,String user_grade,int page,int show_count,String excel_down );
	
	public BaseResponse insertUser(UserInsertParam insertParam);
	
	public List<UserInfoModel> SelectUserInfo(String user_id);
	
	public BaseResponse updateUser(UserInsertParam updateParam);
	
	public BaseResponse deleteUser(String plant_cd, String user_id);
}
