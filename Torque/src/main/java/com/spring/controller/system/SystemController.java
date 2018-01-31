package com.spring.controller.system;

import static org.springframework.web.bind.annotation.RequestMethod.DELETE;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;
import static org.springframework.web.bind.annotation.RequestMethod.PUT;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.spring.model.BaseResponse;
import com.spring.model.system.CommonCodeInfo;
import com.spring.model.system.CommonCodeParamModel;
import com.spring.model.system.DictionaryModel;
import com.spring.model.system.LanguageInfo;
import com.spring.model.system.LanguageParamModel;
import com.spring.model.system.ProgramProcessInfoModel;
import com.spring.model.system.ProgramProcessParamModel;
import com.spring.service.system.ISystemService;

@RestController
public class SystemController {

	@Autowired
	ISystemService systemService;
	
	@RequestMapping(value="/view/system/programandprocess")
	public ModelAndView programprocess(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/system/programandprocess");
		return mv;
	}
	
	@RequestMapping(value="/view/system/programandprocessP01")
	public ModelAndView toolP01(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/system/programandprocessP01");
		return mv;
	}
		
	@RequestMapping(value="/api/system/getprogramprocess")
	public BaseResponse getProgramProcess(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="stn_gub", required=false, defaultValue="1") String stn_gub,
			@RequestParam(value="pgm_id", required=false, defaultValue="1") String pgm_id,
			@RequestParam(value="proc_id", required=false, defaultValue="1") String proc_id,
			@RequestParam(value="proc_state", required=false, defaultValue="1") String proc_state,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			){
		
		return systemService.getProgramProcess(page, show_count, plant_cd, stn_gub, pgm_id, proc_id, proc_state, excel_down);
	}
	
	
	@RequestMapping(value="/api/system/programprocess_insert", method=POST)
	public BaseResponse insertProgramProcess(@RequestBody ProgramProcessParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setReg_user_id(user_id);
		
		return systemService.insertProgramProcess(insertParam);
	}
	
	
	@RequestMapping(value="/api/system/programprocess_info", method=GET)
	public List<ProgramProcessInfoModel> getProgramProcessInfo(
			@RequestParam(value="pgm_id", required=false, defaultValue="1") String pgm_id,
			@RequestParam(value="proc_id", required=false, defaultValue="1") String proc_id
			){
		
		
		return systemService.getProgramProcessInfo(pgm_id,proc_id);
	}
	
	
	@RequestMapping(value="/api/system/programprocess_update", method=PUT)
	public BaseResponse updateProgramProcess(@RequestBody ProgramProcessParamModel updateParam
			,HttpServletRequest request,
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="pgm_id", required=true, defaultValue="1") String pgm_id,
			@RequestParam(value="proc_id", required=true, defaultValue="1") String proc_id
			){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		updateParam.setPlant_cd(plant_cd);
		updateParam.setPgm_id(pgm_id);
		updateParam.setProc_id(proc_id);
		updateParam.setReg_user_id(user_id);
		
		return systemService.updateProgramProcess(updateParam);
	}
	
	@RequestMapping(value="/api/system/programprocess_delete", method=DELETE)
	public BaseResponse deleteProgramProcess(
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="pgm_id", required=true, defaultValue="1") String pgm_id,
			@RequestParam(value="proc_id", required=true, defaultValue="1") String proc_id
			){
		
		return systemService.deleteProgramProcess(plant_cd,pgm_id,proc_id);
	}
	
	/*	*/
	@RequestMapping(value="/view/system/commoncode")
	public ModelAndView commoncodeView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/system/commoncode");
		return mv;
	}
	
	@RequestMapping(value="/view/system/commoncodeP01")
	public ModelAndView commoncodeViewP01(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/system/commoncodeP01");
		return mv;
	}
	
	
	@RequestMapping(value="/api/system/getcommoncodelist")
	public BaseResponse getCommonCodeList(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false, defaultValue="-1") String code_grp,
			@RequestParam(value="code", required=false, defaultValue="") String code,
			@RequestParam(value="code_nm", required=false, defaultValue="") String code_nm,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			){
		
		
		return systemService.getCommonCodeList(page, show_count, plant_cd, code_grp, code,code_nm, excel_down);
	}
		
	
	@RequestMapping(value="/api/system/commoncode_insert", method=POST)
	public BaseResponse insertCommonCode(@RequestBody CommonCodeParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.insertCommonCode(insertParam);
		
		return res;
	}
	
	
	@RequestMapping(value="/api/setting/getcommoncode_info", method=GET)
	public List<CommonCodeInfo> infoCommonCode(
									@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
									@RequestParam(value="code_grp", required=false) String code_grp,
									@RequestParam(value="code", required=false) String code
									){
		
		return systemService.infoCommonCode(plant_cd,code_grp,code);
	}
	
	
	@RequestMapping(value="/api/system/commoncode_update", method=PUT)
	public BaseResponse updateCommonCode(@RequestBody CommonCodeParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.updateCommonCode(insertParam);
		
		return res;
	}
	
	
	@RequestMapping(value="/api/system/commoncode_delete", method=DELETE)
	public BaseResponse deleteCommonCode(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code
			) throws Exception {
		
		BaseResponse res = systemService.deleteCommonCode(plant_cd,code_grp,code);
		
		return res;
	}
	
	/***********/
	
	@RequestMapping(value="/view/system/language")
	public ModelAndView languageView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/system/language");
		return mv;
	}
	
	@RequestMapping(value="/view/system/languageP01")
	public ModelAndView languageP01View(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/system/languageP01");
		return mv;
	}
	
	
	
	@RequestMapping(value="/api/system/getlanguagelist")
	public BaseResponse getLanguageList(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="sys_area", required=false, defaultValue="-1") String sys_area,
			@RequestParam(value="lang_type", required=false, defaultValue="-1") String lang_type,
			@RequestParam(value="lang_id", required=false, defaultValue="") String lang_id,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			){
		
		return systemService.getLanguageList(page, show_count, plant_cd, sys_area, lang_type, lang_id, excel_down);
	}	
	
	
		
		
	@RequestMapping(value="/api/system/language_insert", method=POST)
	public BaseResponse insertLanguage(@RequestBody LanguageParamModel insertParam,HttpServletRequest request) throws Exception{
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.insertLanguage(insertParam);
		
		MakeDictionary();
		
		return res;
	}
	
	
	@RequestMapping(value="/api/setting/getlanguage_info", method=GET)
	public List<LanguageInfo> getLanguageInfo(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="lang_id", required=false, defaultValue="1") String lang_id,
			@RequestParam(value="lang_type", required=false, defaultValue="1") String lang_type
			){
		
		return systemService.getLanguageInfo(plant_cd,lang_id,lang_type);
	}
	
	
	@RequestMapping(value="/api/system/language_update", method=PUT)
	public BaseResponse updateLanguage(@RequestBody LanguageParamModel updateParam,HttpServletRequest request) throws Exception{
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		updateParam.setLogin_user_id(user_id);
		
		BaseResponse res = systemService.updateLanguage(updateParam);
		
		MakeDictionary();
		
		return res;
	}
	
	
	@RequestMapping(value="/api/system/language_delete", method=DELETE)
	public BaseResponse delteLanguage(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="lang_id", required=false, defaultValue="1") String lang_id,
			@RequestParam(value="lang_type", required=false, defaultValue="1") String lang_type
			) throws Exception {
		
		BaseResponse res = systemService.deleteLanguage(plant_cd,lang_id,lang_type);
		
		MakeDictionary();
		
		return res;
	}
	
	@Value("#{ds['ds.filepath']}")
	String filePath;
	
	public void MakeDictionary() throws Exception {
		
		Properties props_lo = new Properties();
		Properties props_ko = new Properties();
		Properties props_en = new Properties();

		FileInputStream fi_lo = new FileInputStream(filePath+"message_lo.properties");
		FileInputStream fi_ko = new FileInputStream(filePath+"message_ko.properties");
		FileInputStream fi_en = new FileInputStream(filePath+"message_en.properties");
		//props_lo.load(fi_lo);
		//props_ko.load(fi_ko);
		//props_en.load(fi_en);
		
		List<DictionaryModel> dicList = systemService.getDictionary();
		
		for (DictionaryModel dictionaryModel : dicList) {
			props_lo.setProperty(dictionaryModel.getMsg_id().trim(), dictionaryModel.getText_lo().trim());
			props_ko.setProperty(dictionaryModel.getMsg_id().trim(), dictionaryModel.getText_ko().trim());
			props_en.setProperty(dictionaryModel.getMsg_id().trim(), dictionaryModel.getText_en().trim());
		}
		props_lo.store(new FileOutputStream(filePath+"message_lo.properties"), "");
		props_ko.store(new FileOutputStream(filePath+"message_ko.properties"), "");
		props_en.store(new FileOutputStream(filePath+"message_en.properties"), "");
		
		System.out.println(filePath +"<=FilePath");
		
		fi_lo.close();
		fi_ko.close();
		fi_en.close();
	}


/*	public static String encode(String unicode){
		StringBuffer str = new StringBuffer();
	      
	    for (int i = 0; i < unicode.length(); i++) {
	    	if(((int) unicode.charAt(i) == 32)) {
	    		str.append(" ");
	    		continue;
	    	}
	       str.append("\\u");
	       str.append(Integer.toHexString((int) unicode.charAt(i)));
	       
	    }
	    return str.toString();
	}*/
	

}
