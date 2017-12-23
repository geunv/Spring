package com.spring.dao.setting;

import java.util.HashMap;
import java.util.List;

import com.spring.model.setting.JobNoListModel;
import com.spring.model.setting.ToolInfoModel;
import com.spring.model.setting.ToolListModel;
import com.spring.model.setting.ToolListParam;
import com.spring.model.setting.UserInfoModel;
import com.spring.model.setting.UserInsertParam;
import com.spring.model.setting.UserListModel;

public interface ISettingMapper {
	public List<ToolListModel> selectToolList(ToolListParam param);
	
	public int selectToolListCount(ToolListParam param);
	
	public List<ToolInfoModel> selectToolInfo(HashMap<String,Object> map);
	
	public void insertToolId(ToolInfoModel param);
	
	public void updateToolId(ToolInfoModel param);
	
	public void deleteToolId(HashMap<String, Object> map);
	
	public List<JobNoListModel> selectJobNoList(HashMap<String, Object> map);
	
	public int selectJobNoListCount(HashMap<String, Object> map);
	
	public List<UserListModel> selectUserList(HashMap<String, Object> map);
	
	public int selectUserListCount(HashMap<String, Object> map);
	
	public List<UserInfoModel> selectUserInfo(HashMap<String, Object> map);
	
	public void insertUserInfo(UserInsertParam param);
	
	public void updateUserInfo(UserInsertParam param);
	
	public void deleteUserInfo(HashMap<String , Object>map);
	
}
