package com.spring.service.system;

import java.util.List;

import com.spring.model.BaseResponse;
import com.spring.model.system.CommonCodeInfo;
import com.spring.model.system.CommonCodeParamModel;
import com.spring.model.system.DictionaryModel;
import com.spring.model.system.LanguageInfo;
import com.spring.model.system.LanguageParamModel;
import com.spring.model.system.ProgramProcessInfoModel;
import com.spring.model.system.ProgramProcessParamModel;

public interface ISystemService {
	
	public BaseResponse getProgramProcess(int page, int show_count, String plant_cd, String stn_gub, String pgm_id, String proc_id, String proc_state,String excel_down );
	
	public BaseResponse insertProgramProcess(ProgramProcessParamModel insertParam);
	
	public List<ProgramProcessInfoModel> getProgramProcessInfo(String pgm_id, String proc_id);
	
	public BaseResponse updateProgramProcess(ProgramProcessParamModel updateParam);
	
	public BaseResponse deleteProgramProcess(String plant_cd,String pgm_id,String proc_id);

	
	public BaseResponse getCommonCodeList(int page,int show_count,String plant_cd,String  code_grp,String  code,String code_nm,String  excel_down);
	
	public BaseResponse insertCommonCode(CommonCodeParamModel insertParam);
	
	public List<CommonCodeInfo> infoCommonCode(String plant_cd, String code_grp,String code);
	
	public BaseResponse updateCommonCode(CommonCodeParamModel updateParam);
	
	public BaseResponse deleteCommonCode(String plant_cd, String code_grp , String code);
	
	
	public BaseResponse getLanguageList(int page,int show_count,String plant_cd,String sys_area,String lang_type,String lang_id,String excel_down);
	
	public BaseResponse insertLanguage(LanguageParamModel insertParma);

	public List<LanguageInfo> getLanguageInfo(String plant_cd, String lang_id, String lang_type);
	
	public BaseResponse updateLanguage(LanguageParamModel updateParam);
	
	public BaseResponse deleteLanguage(String plant_cd,String lang_id,String lang_type);
	
	public List<DictionaryModel> getDictionary();
	
	
}
