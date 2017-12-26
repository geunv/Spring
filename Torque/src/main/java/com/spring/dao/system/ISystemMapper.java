package com.spring.dao.system;

import java.util.HashMap;
import java.util.List;

import com.spring.model.system.ProgramProcessParamModel;
import com.spring.model.system.DictionaryModel;
import com.spring.model.system.LanguageInfo;
import com.spring.model.system.LanguageListModel;
import com.spring.model.system.LanguageParamModel;
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
	
	public List<LanguageListModel> selectLanguageList(HashMap<String, Object> map);
	
	public int selectLanguageListCount(HashMap<String, Object> map);
	
	public List<LanguageInfo> selectLanguageInfo(HashMap<String, Object> map);
	
	public void InsertLanguage(LanguageParamModel param);
	
	public List<LanguageInfo> getLanguageInfo(String plant_cd,String lang_id,String lang_type);
	
	public void updateLanguage(LanguageParamModel param);
	
	public void deleteLanguage(HashMap<String, Object> map);
	
	public List<DictionaryModel> selectDic();
}
