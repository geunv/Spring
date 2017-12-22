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
import com.spring.model.setting.JobNoInfo;
import com.spring.model.setting.ToolInfoModel;
//import com.spring.service.common.ICommonService;
import com.spring.service.setting.ISettingService;

@RestController
public class SettingController {

	@Autowired
	ISettingService toolService;
	//ICommonService commonService;
	
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
			@RequestParam(value="show_count", required=false, defaultValue="10") int show_count,
			@RequestParam(value="plant_cd", required=false) String plant_cd,
			@RequestParam(value="stn_type", required=false) String stn_type,
			@RequestParam(value="device_grp_cd", required=false) String device_grp_cd,
			@RequestParam(value="device", required=false) String device,
			@RequestParam(value="device_type", required=false) String device_type,
			@RequestParam(value="device_status", required=false) String device_status,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		
		return toolService.getToolList(page,show_count, plant_cd, stn_type, device_grp_cd,device,device_type,device_status,excel_down);
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
		return toolService.insertToolId(insertParam);
		//
	}
	
	@RequestMapping(value="/api/setting/gettoolinfo", method=GET)
	public List<ToolInfoModel> getToolInfo(
			@RequestParam(value="tool_id", required=true) String tool_id,
			@RequestParam(value="tool_serial", required=true) String tool_serial
			){
	
		return toolService.getToolInfo(tool_id,tool_serial);
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
		return toolService.updateToolId(updateParam);
		//
	}
	
	
	@RequestMapping(value="/api/setting/deletetoolid", method=DELETE)
	public BaseResponse deleteToolId(@RequestParam(value="plant_cd", required=true) String plant_cd,
									 @RequestParam(value="tool_id", required=true) String tool_id,
									 @RequestParam(value="tool_serial", required=true) String tool_serial
									){
		
		return toolService.deleteToolId(plant_cd,tool_id, tool_serial);
		//
	}
	
	
	@RequestMapping(value="/view/setting/jobno")
	public ModelAndView jobnoList(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/jobno");
		return mv;
	}
		
	
	@RequestMapping(value="/api/setting/getjobnolist", method=GET)
	public BaseResponse getJobNolList(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="10") int show_count,
			@RequestParam(value="plant_cd", required=false) String plant_cd,
			@RequestParam(value="car_type", required=false) String car_type,
			@RequestParam(value="tool_id", required=false) String tool_id,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
	){
		
		return toolService.getJobNolList(page,show_count, plant_cd, car_type, tool_id,excel_down );
	}
	
	@RequestMapping(value="/view/setting/jobnoP01")
	public ModelAndView jobnoP01(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/jobnoP01");
		return mv;
	}
	
	
	@RequestMapping(value="/api/setting/insertjobno", method=POST)
	public BaseResponse insertJobNo(@RequestBody JobNoInfo insertParam,HttpServletRequest request){
		
		HttpSession my_session = request.getSession();
		String user_id = (String)my_session.getAttribute("USER_ID");
		
		insertParam.setReg_user_id(user_id);
		return toolService.insertJobNo(insertParam);
		//
	}
	
	
	@RequestMapping(value="/view/setting/user")
	public ModelAndView userList(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/setting/user");
		return mv;
	}
	
}
