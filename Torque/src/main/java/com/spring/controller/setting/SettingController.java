package com.spring.controller.setting;

import static org.springframework.web.bind.annotation.RequestMethod.DELETE;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;
import static org.springframework.web.bind.annotation.RequestMethod.PUT;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.spring.model.BaseResponse;
import com.spring.model.setting.JobNoInsertParam;
import com.spring.model.setting.ToolInfoModel;
import com.spring.model.setting.UserInfoModel;
import com.spring.model.setting.UserInsertParam;
import com.spring.model.system.CommonCodeInfo;
import com.spring.model.system.CommonCodeParamModel;
import com.spring.service.common.ICommonService;
//import com.spring.service.common.ICommonService;
import com.spring.service.setting.ISettingService;
import com.spring.service.system.ISystemService;

@RestController
public class SettingController {

	@Autowired
	ISettingService settingService;
	//ICommonService commonService;
	
	@Autowired
	ISystemService systemService;
	
	
	@RequestMapping(value="/view/setting/tool")
	public ModelAndView toolList(HttpServletRequest request){
		
		//HttpSession session = request.getSession();
		//List<DDLReturn> list = commonService.getPlantddl();
		
		ModelAndView mv = new ModelAndView("/setting/tool");
		//mv.addObject("ddlPlant",list);
		
		return mv;
	}
	
	
	@RequestMapping(value="/api/setting/gettoollist", method=GET)
	public BaseResponse getToolList(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=false) String plant_cd,
			@RequestParam(value="stn_type", required=false) String stn_type,
			@RequestParam(value="device_grp_cd", required=false) String device_grp_cd,
			@RequestParam(value="device", required=false) String device,
			@RequestParam(value="device_type", required=false) String device_type,
			@RequestParam(value="device_status", required=false) String device_status,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		
		return settingService.getToolList(page,show_count, plant_cd, stn_type, device_grp_cd,device,device_type,device_status,excel_down);
		//return listService.getList(page, show_count, search);
	}
	
	@RequestMapping(value="/view/setting/toolP01")
	public ModelAndView toolP01(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/toolP01");
		return mv;
	}
	
						
	@RequestMapping(value="/api/setting/inserttoolid", method=POST)
	public BaseResponse insertToolId(@RequestBody ToolInfoModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setReg_user_id(user_id);
		return settingService.insertToolId(insertParam);
		//
	}
	
	@RequestMapping(value="/api/setting/gettoolinfo", method=GET)
	public List<ToolInfoModel> getToolInfo(
			@RequestParam(value="tool_id", required=true) String tool_id,
			@RequestParam(value="tool_serial", required=true) String tool_serial
			){
	
		return settingService.getToolInfo(tool_id,tool_serial);
	}
	
	
	@RequestMapping(value="/api/setting/updatetoolid", method=PUT)
	public BaseResponse updateToolId(@RequestBody ToolInfoModel updateParam,
									HttpServletRequest request,
									@RequestParam(value="plant_cd", required=true) String plant_cd,
									@RequestParam(value="tool_id", required=true) String tool_id,
									@RequestParam(value="tool_serial", required=true) String tool_serial
									){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		updateParam.setPlant_cd(plant_cd);
		updateParam.setDevice_id(tool_id);
		updateParam.setDevice_serial(tool_serial);
		updateParam.setReg_user_id(user_id);
		return settingService.updateToolId(updateParam);
		//
	}
	
	
	@RequestMapping(value="/api/setting/deletetoolid", method=DELETE)
	public BaseResponse deleteToolId(@RequestParam(value="plant_cd", required=true) String plant_cd,
									 @RequestParam(value="tool_id", required=true) String tool_id,
									 @RequestParam(value="tool_serial", required=true) String tool_serial
									){
		
		return settingService.deleteToolId(plant_cd,tool_id, tool_serial);
		//
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/jobno")
	public ModelAndView jobnoList(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/jobno");
		return mv;
	}
		
	
	@RequestMapping(value="/api/setting/getjobnolist", method=GET)
	public BaseResponse getJobNolList(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=false) String plant_cd,
			@RequestParam(value="car_type", required=false) String car_type,
			@RequestParam(value="tool_id", required=false) String tool_id,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		
		return settingService.getJobNolList(page,show_count, plant_cd, car_type, tool_id,excel_down );
	}
	
	@RequestMapping(value="/view/setting/jobnoP01")
	public ModelAndView jobnoP01(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/jobnoP01");
		return mv;
	}
	
	
	@RequestMapping(value="/api/setting/insertjobno", method=POST)
	public BaseResponse insertJobNo(@RequestBody JobNoInsertParam insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setReg_user_id(user_id);
		return settingService.insertJobNo(insertParam);
		//
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/cartype")
	public ModelAndView cartypeView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/cartype");
		return mv;
	}
	
	@RequestMapping(value="/view/setting/cartypeP01")
	public ModelAndView cartypeP01View(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/cartypeP01");
		return mv;
	}
	
	
	@RequestMapping(value="/api/setting/getcartypelist", method=GET)
	public BaseResponse getCarTypeList(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code,
			@RequestParam(value="code_nm", required=false) String code_nm,
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		//return settingService.getCarTypeList(plant_cd,code_grp,code,page,show_count,excel_down );
		
		return systemService.getCommonCodeList(page, show_count, plant_cd, code_grp, code, code_nm, excel_down);
	}
	
	@RequestMapping(value="/api/setting/cartype_info", method=GET)
	public List<CommonCodeInfo> infoCommonCode(
									@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
									@RequestParam(value="code_grp", required=false) String code_grp,
									@RequestParam(value="code", required=false) String code
									){
		
		return systemService.infoCommonCode(plant_cd,code_grp,code);
	}
	
	@RequestMapping(value="/api/setting/cartype_insert", method=POST)
	public BaseResponse insertCommonCode(@RequestBody CommonCodeParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.insertCommonCode(insertParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/cartype_update", method=PUT)
	public BaseResponse updateCommonCode(@RequestBody CommonCodeParamModel updateParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		updateParam.setLogin_user_id(user_id);
		BaseResponse res =  systemService.updateCommonCode(updateParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/cartype_delete", method=DELETE)
	public BaseResponse deleteCommonCode(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code
			) throws Exception {
		
		BaseResponse res = systemService.deleteCommonCode(plant_cd,code_grp,code);
		
		return res;
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/line")
	public ModelAndView lineView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/line");
		return mv;
	}
	
	@RequestMapping(value="/view/setting/lineP01")
	public ModelAndView lineP01View(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/lineP01");
		return mv;
	}
	
	
	@RequestMapping(value="/api/setting/getlinelist", method=GET)
	public BaseResponse getLineList(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code,
			@RequestParam(value="code_nm", required=false) String code_nm,
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		return systemService.getCommonCodeList(page, show_count, plant_cd, code_grp, code, code_nm, excel_down);
	}
	
	@RequestMapping(value="/api/setting/line_info", method=GET)
	public List<CommonCodeInfo> infoLine(
									@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
									@RequestParam(value="code_grp", required=false) String code_grp,
									@RequestParam(value="code", required=false) String code
									){
		
		return systemService.infoCommonCode(plant_cd,code_grp,code);
	}
	
	@RequestMapping(value="/api/setting/line_insert", method=POST)
	public BaseResponse insertLine(@RequestBody CommonCodeParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.insertCommonCode(insertParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/line_update", method=PUT)
	public BaseResponse updateLine(@RequestBody CommonCodeParamModel updateParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		updateParam.setLogin_user_id(user_id);
		BaseResponse res =  systemService.updateCommonCode(updateParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/line_delete", method=DELETE)
	public BaseResponse deleteLine(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code
			) throws Exception {
		
		BaseResponse res = systemService.deleteCommonCode(plant_cd,code_grp,code);
		
		return res;
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/shift")
	public ModelAndView shiftView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/shift");
		return mv;
	}
	
	@RequestMapping(value="/view/setting/shiftP01")
	public ModelAndView shiftP01View(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/shiftP01");
		return mv;
	}
	
	@RequestMapping(value="/api/setting/shift_list", method=GET)
	public BaseResponse ShiftList(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code,
			@RequestParam(value="code_nm", required=false) String code_nm,
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		return systemService.getCommonCodeList(page, show_count, plant_cd, code_grp, code, code_nm, excel_down);
	}
	
	@RequestMapping(value="/api/setting/shift_info", method=GET)
	public List<CommonCodeInfo> infoshift(
									@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
									@RequestParam(value="code_grp", required=false) String code_grp,
									@RequestParam(value="code", required=false) String code
									){
		
		return systemService.infoCommonCode(plant_cd,code_grp,code);
	}
	
	@RequestMapping(value="/api/setting/shift_insert", method=POST)
	public BaseResponse insertshift(@RequestBody CommonCodeParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.insertCommonCode(insertParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/shift_update", method=PUT)
	public BaseResponse updateshift(@RequestBody CommonCodeParamModel updateParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		updateParam.setLogin_user_id(user_id);
		BaseResponse res =  systemService.updateCommonCode(updateParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/shift_delete", method=DELETE)
	public BaseResponse deleteshift(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code
			) throws Exception {
		
		BaseResponse res = systemService.deleteCommonCode(plant_cd,code_grp,code);
		
		return res;
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/cycletestitem")
	public ModelAndView cycletestitemView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/cycletestitem");
		return mv;
	}
	
	@RequestMapping(value="/view/setting/cycletestitemP01")
	public ModelAndView cycletestitemP01View(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/cycletestitemP01");
		return mv;
	}
	
	@RequestMapping(value="/api/setting/getcyclelist", method=GET)
	public BaseResponse getcycleList(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code,
			@RequestParam(value="code_nm", required=false) String code_nm,
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		return systemService.getCommonCodeList(page, show_count, plant_cd, code_grp, code, code_nm, excel_down);
	}
	
	@RequestMapping(value="/api/setting/cycle_info", method=GET)
	public List<CommonCodeInfo> infoCycle(
									@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
									@RequestParam(value="code_grp", required=false) String code_grp,
									@RequestParam(value="code", required=false) String code
									){
		
		return systemService.infoCommonCode(plant_cd,code_grp,code);
	}
	
	@RequestMapping(value="/api/setting/cycle_insert", method=POST)
	public BaseResponse insertCycle(@RequestBody CommonCodeParamModel insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		insertParam.setLogin_user_id(user_id);
		
		BaseResponse res =  systemService.insertCommonCode(insertParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/cycle_update", method=PUT)
	public BaseResponse updateCycle(@RequestBody CommonCodeParamModel updateParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		updateParam.setLogin_user_id(user_id);
		BaseResponse res =  systemService.updateCommonCode(updateParam);
		return res;
	}
	
	@RequestMapping(value="/api/setting/cycle_delete", method=DELETE)
	public BaseResponse deleteCycle(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="code_grp", required=false) String code_grp,
			@RequestParam(value="code", required=false) String code
			) throws Exception {
		
		BaseResponse res = systemService.deleteCommonCode(plant_cd,code_grp,code);
		
		return res;
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/category")
	public ModelAndView categoryView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/category");
		return mv;
	}
	
	/*******************************/
	@RequestMapping(value="/view/setting/user")
	public ModelAndView userList(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/user");
		return mv;
	}
	
	@RequestMapping(value="/api/setting/getuserlist", method=GET)
	public BaseResponse getUserList(
			@RequestParam(value="plant_cd", required=false) String plant_cd,
			@RequestParam(value="user_authority", required=false) String user_authority,
			@RequestParam(value="user_grp", required=false) String user_grp,
			@RequestParam(value="user_id", required=false) String user_id,
			@RequestParam(value="user_nm", required=false) String user_nm,
			@RequestParam(value="user_grade", required=false) String user_grade,
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		
		return settingService.getUserList(plant_cd,user_authority,user_grp,user_id,user_nm,user_grade,page,show_count,excel_down );
	}
	
	@RequestMapping(value="/view/setting/userP01")
	public ModelAndView userP01(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/userP01");
		return mv;
	}
	
	@RequestMapping(value="/api/setting/insertuser", method=POST)
	public BaseResponse insertUser(@RequestBody UserInsertParam insertParam){
		return settingService.insertUser(insertParam);
	}
	
	
	@RequestMapping(value="/api/setting/getuserinfo", method=GET)
	public List<UserInfoModel> insertUser(
			@RequestParam(value="user_id", required=false) String user_id
			){
		
		return settingService.SelectUserInfo(user_id);
	}
	
	
	@RequestMapping(value="/api/setting/updatetuser", method=PUT)
	public BaseResponse updateUser(@RequestBody UserInsertParam updateParam){
		return settingService.updateUser(updateParam);
	}
	
	
	@RequestMapping(value="/api/setting/deleteuser", method=DELETE)
	public BaseResponse deleteUser(
								@RequestParam(value="plant_cd", required=false) String plant_cd,
								@RequestParam(value="user_id", required=false) String user_id
								){
		return settingService.deleteUser(plant_cd,user_id);
	}
	
}
