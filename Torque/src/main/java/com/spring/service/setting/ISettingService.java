package com.spring.service.setting;

import java.sql.SQLException;
import java.util.List;

import com.spring.model.BaseResponse;
import com.spring.model.setting.JobNoInsertParam;
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
	
	public BaseResponse insertJobNo(JobNoInsertParam inputparam);
	
	public BaseResponse getJobNoInfo(String plant_cd,String car_type,String device_id,String device_serial,String job_num);
	
	public BaseResponse updateJobNo(JobNoInsertParam updateParam);
	
	public BaseResponse deleteJobNo(String plant_cd,String car_type,String tool,String job_num);
	/*					*/
	
	
	/*					*/
	public BaseResponse getUserList(String plant_cd,String user_authority,String user_grp,String user_id,String user_nm,String user_grade,int page,int show_count,String excel_down );
	
	public BaseResponse insertUser(UserInsertParam insertParam);
	
	public List<UserInfoModel> SelectUserInfo(String user_id);
	
	public BaseResponse updateUser(UserInsertParam updateParam);
	
	public BaseResponse deleteUser(String plant_cd, String user_id);
}
