package com.spring.service.system;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.system.ISystemMapper;
import com.spring.model.BaseResponse;
import com.spring.model.system.CommonCodeInfo;
import com.spring.model.system.CommonCodeListModel;
import com.spring.model.system.CommonCodeListReturn;
import com.spring.model.system.CommonCodeParamModel;
import com.spring.model.system.DictionaryModel;
import com.spring.model.system.LanguageInfo;
import com.spring.model.system.LanguageListModel;
import com.spring.model.system.LanguageListReturn;
import com.spring.model.system.LanguageParamModel;
import com.spring.model.system.ProgramProcessInfoModel;
import com.spring.model.system.ProgramProcessListModel;
import com.spring.model.system.ProgramProcessListReturn;
import com.spring.model.system.ProgramProcessParamModel;

@Service
public class SystemService implements ISystemService{
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	//page, show_count, plant_cd, stn_gub, pgm_id, proc_id, proc_state, excel_down
	public BaseResponse getProgramProcess(int page, int show_count, String plant_cd, String stn_gub, String pgm_id, String proc_id, String proc_state,String excel_down ){
		
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("stn_gub",stn_gub);
		map.put("pgm_id", pgm_id);
		map.put("proc_id", proc_id);
		map.put("proc_state", proc_state);
		
		if ( excel_down.equals("Y"))
		{
			map.put("pageStartNo", -1);
			map.put("pageEndNo", -1);
		}
		else
		{
			map.put("pageStartNo", (page * show_count) - show_count);
			map.put("pageEndNo", (page*show_count) +1);
		}
		
		List<ProgramProcessListModel> list = mapper.selectProgramProcessList(map);
		
		int total_count = mapper.selectProgramProcessListCount(map);
		
		ProgramProcessListReturn response = new ProgramProcessListReturn();
		
		response.setTotal_count(total_count);
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse insertProgramProcess(ProgramProcessParamModel insertParam){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", insertParam.getPlant_cd());
		map.put("pgm_id", insertParam.getPgm_id());
		map.put("proc_id",insertParam.getProc_id());
		
		int cnt = mapper.CheckDuplicateProgram(map);
		
		if ( cnt > 0)
			res.setResult(300);
		else
		{
			String[] array;
			String device_id = "-1";
			String device_serial = "-1";
			 
			if( !insertParam.getTool().equals("-1")){
				array = insertParam.getTool().split("-");
				device_id = array[0].trim().toString();
				device_serial = array[1].trim().toString();
				
				insertParam.setDevice_id(device_id);
				insertParam.setDevice_serial(device_serial);
			}
			
			mapper.InsertProgram(insertParam);

		}
		
		return res;
		
	}
	
	public List<ProgramProcessInfoModel> getProgramProcessInfo(String pgm_id, String proc_id){
		
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("pgm_id", pgm_id);
		map.put("proc_id", proc_id);
		
		List<ProgramProcessInfoModel> info = mapper.selectProgramInfo(map);
		
		return info;
	}
	
	public BaseResponse updateProgramProcess(ProgramProcessParamModel updateParam){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !updateParam.getTool().equals("-1")){
			array = updateParam.getTool().split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
			
			updateParam.setDevice_id(device_id);
			updateParam.setDevice_serial(device_serial);
		}
				
		try{
			mapper.updateProgram(updateParam);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
		
	}
	
	public BaseResponse deleteProgramProcess(String plant_cd,String pgm_id,String proc_id){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("pgm_id", pgm_id);
		map.put("proc_id", proc_id);
		
		try{
			mapper.deleteProgram(map);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
	
	public BaseResponse getCommonCodeList(int page,int show_count,String plant_cd,String  code_grp,String  code,String code_nm,String  excel_down){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("code_grp",code_grp);
		map.put("code", code);
		map.put("code_nm", code_nm);
		
		if ( excel_down.equals("Y"))
		{
			map.put("pageStartNo", -1);
			map.put("pageEndNo", -1);
		}
		else
		{
			map.put("pageStartNo", (page * show_count) - show_count);
			map.put("pageEndNo", (page*show_count) +1);
		}
		
		List<CommonCodeListModel> list = mapper.selectCommonCodeList(map);
		
		int total_count = mapper.selectCommonCodeListCount(map);
		
		CommonCodeListReturn res = new CommonCodeListReturn();
		
		res.setList(list);
		res.setTotal_count(total_count);
		
		return res;
		
	}
	
	public BaseResponse insertCommonCode(CommonCodeParamModel insertParam){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", insertParam.getPlant_cd());
		map.put("code_grp", insertParam.getCode_grp());
		map.put("code",insertParam.getCode());
		
		List<CommonCodeInfo> info = mapper.selectCommonCodeInfo(map);
		
		if ( info.size() > 0)
			res.setResult(300);
		else
		{
			mapper.insertCommonCode(insertParam);
		}
		
		return res;
		
	}
	
	public List<CommonCodeInfo> infoCommonCode(String plant_cd, String code_grp,String code){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("code_grp", code_grp);
		map.put("code",code);
		
		List<CommonCodeInfo> info = mapper.selectCommonCodeInfo(map);
		
		return info;
	}
	
	public BaseResponse updateCommonCode(CommonCodeParamModel updateParam){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", updateParam.getPlant_cd());
		map.put("code_grp", updateParam.getCode_grp());
		map.put("code",updateParam.getCode());
		
		
		try{
			mapper.updateCommonCode(updateParam);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
		
	}
	
	public BaseResponse deleteCommonCode(String plant_cd, String code_grp , String code){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("code_grp", code_grp);
		map.put("code",code);
		
		
		try{
			mapper.deleteCommonCode(map);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;

	}
	
	/*******/
	
	public BaseResponse getLanguageList(int page,int show_count,String plant_cd,String sys_area,String lang_type,String lang_id,String excel_down){

		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("sys_area",sys_area);
		map.put("lang_type", lang_type);
		map.put("lang_id", lang_id);
		
		if ( excel_down.equals("Y"))
		{
			map.put("pageStartNo", -1);
			map.put("pageEndNo", -1);
		}
		else
		{
			map.put("pageStartNo", (page * show_count) - show_count);
			map.put("pageEndNo", (page*show_count) +1);
		}
		
		List<LanguageListModel> list = mapper.selectLanguageList(map);
		
		int total_count = mapper.selectLanguageListCount(map);
		
		LanguageListReturn response = new LanguageListReturn();
		
		response.setTotal_count(total_count);
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse insertLanguage(LanguageParamModel insertParam){
		
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", insertParam.getPlant_cd());
		map.put("lang_id", insertParam.getLang_id());
		map.put("lang_type",insertParam.getLang_type());
		
		List<LanguageInfo> info = mapper.selectLanguageInfo(map);
		
		if ( info.size() > 0)
			res.setResult(300);
		else
		{
			mapper.InsertLanguage(insertParam);
		}
		
		return res;
				
	}
	
	public List<LanguageInfo> getLanguageInfo(String plant_cd,String lang_id,String lang_type){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("lang_id", lang_id);
		map.put("lang_type",lang_type);
		
		List<LanguageInfo> info = mapper.selectLanguageInfo(map);
		
		return info;
	}
	
	public BaseResponse updateLanguage(LanguageParamModel updateParam){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
	    
	    updateParam.setLang_id(updateParam.getLang_id().trim());
	    if ( updateParam.getSys_area().equals("-1"))
	    	updateParam.setSys_area(" ");
	    
	    if (updateParam.getLang_type().equals("") || updateParam.getLang_type().equals("-1"))
	    	updateParam.setLang_type(" ");
	    
	    if(updateParam.getMsg_type().equals("") || updateParam.getMsg_type().equals("-1") )
	    	updateParam.setMsg_type(" ");
	    
	    if(updateParam.getLang_kor().trim().length() == 0 )
	    	updateParam.setLang_kor(" ");
	    else
	    	updateParam.setLang_kor(updateParam.getLang_kor().trim());
	    
	    if(updateParam.getLang_eng().trim().length() == 0 )
	    	updateParam.setLang_eng(" ");
	    else
	    	updateParam.setLang_eng(updateParam.getLang_eng().trim());
	    
	    if(updateParam.getLang_lon().trim().length() == 0 )
	    	updateParam.setLang_lon(" ");
	    else
	    	updateParam.setLang_lon(updateParam.getLang_lon().trim());
	    
		try{
			mapper.updateLanguage(updateParam);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
	
	public BaseResponse deleteLanguage(String plant_cd,String lang_id,String lang_type){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("lang_id", lang_id);
		map.put("lang_type",lang_type);
		
		try{
			mapper.deleteLanguage(map);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
	
	public List<DictionaryModel> getDictionary(){
		ISystemMapper mapper = sqlSession.getMapper(ISystemMapper.class);
		return  mapper.selectDic();
	}
	
	
}
