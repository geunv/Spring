package com.spring.dao.system;

import java.util.HashMap;
import java.util.List;

import com.spring.model.system.ProgramProcessParamModel;
import com.spring.model.system.ProgramProcessInfoModel;
import com.spring.model.system.ProgramProcessListModel;

public interface ISystemMapper {

	public List<ProgramProcessListModel> selectProgramProcessList(HashMap<String, Object> map);
	
	public int selectProgramProcessListCount(HashMap<String, Object> map);
	
	public int CheckDuplicateProgram(HashMap<String, Object> map);
	
	public void InsertProgram(ProgramProcessParamModel param);
	
	public List<ProgramProcessInfoModel> selectProgramInfo(HashMap<String, Object> map);
	
	public void updateProgram(ProgramProcessParamModel param);
	
	public void deleteProgram(HashMap<String, Object> map);
}
