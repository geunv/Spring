package com.spring.dao;

import java.util.HashMap;
import java.util.List;

import com.spring.model.common.CommonDDLReturn;
import com.spring.model.common.ToolGroupModel;
import com.spring.model.common.ToolIDModel;
import com.spring.model.common.ToolIDParam;

public interface ICommonMapper {

	public List<CommonDDLReturn> selectPlant();
	
	public List<CommonDDLReturn> selectCarType();
	
	public List<CommonDDLReturn> selectLine();
	
	public List<CommonDDLReturn> selectStn();
	
	public List<CommonDDLReturn> selectShift();
	
	public List<ToolGroupModel> selectToolGroup(String plant_cd);
	
	public List<ToolIDModel> selectToolID(ToolIDParam param);
	
	public List<ToolIDModel> selectJobNoTool(HashMap<String, Object> map);
	
	public List<CommonDDLReturn> selectToolType();
	
	public List<CommonDDLReturn> selectToolState();
	
	public List<CommonDDLReturn> selectUseFlage();
	
	public String selectShiftTime(String code);
}
