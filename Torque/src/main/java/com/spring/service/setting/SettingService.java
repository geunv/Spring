package com.spring.service.setting;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.setting.ISettingMapper;
import com.spring.model.BaseResponse;
import com.spring.model.setting.JobNoInfo;
import com.spring.model.setting.JobNoListModel;
import com.spring.model.setting.JobNoListReturn;
import com.spring.model.setting.ToolInfoModel;
import com.spring.model.setting.ToolListModel;
import com.spring.model.setting.ToolListParam;
import com.spring.model.setting.ToolListReturn;

@Service
public class SettingService implements ISettingService {

	@Autowired
	private SqlSessionTemplate sqlSession;

	//boolean isexcel;
	//String plant_cd;
	//String stn_type;
	//String device_grp_cd;
	//String device_id;
	//String device_serial;
	//String device_type;
	//String device_status;
	//int startno;
	//int endno;
	public BaseResponse getToolList(int page, 
									int show_count,
									String plant_cd,
									String stn_type,
									String device_grp_cd,
									String device,
									String device_type,
									String device_status,
									String excel_down
									){
		//IListMapper mapper  = sqlSession.getMapper(IListMapper.class);
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		
		String[] array;
		String pdevice_id = "-1";
		String pdevice_serial = "-1";
		
		
		 
		if( !device.equals("-1")){
			array = device.split("-");
			pdevice_id = array[0].trim().toString();
			pdevice_serial = array[1].trim().toString();
		}
		
		ToolListParam param = new ToolListParam();
		param.setPlant_cd(plant_cd.trim());
		param.setStn_type(stn_type.trim());
		param.setDevice_grp_cd(device_grp_cd.trim());
		param.setDevice_id(pdevice_id);
		param.setDevice_serial(pdevice_serial);
		param.setDevice_type(device_type);
		param.setDevice_status(device_status);
		param.setStartno((page * show_count) - show_count);
		param.setEndno((page*show_count) +1);
		param.setIsexcel(false);
		
		if ( excel_down.equals("Y"))
			param.setIsexcel(true);
		
		
		
		List<ToolListModel> list = mapper.selectToolList(param);
		int total = mapper.selectToolListCount(param);
		
		ToolListReturn response = new ToolListReturn();
		response.setList(list);
		response.setTotal_count(total);
		
		/*
		if(total == 0) {
			response.setTotal_page(1);
		}else {
			response.setTotal_page(total/show_count + (total%show_count > 0 ? 1 : 0));
		}
		*/
		
		return response; 
		
	}
	
	public BaseResponse insertToolId(ToolInfoModel insertParam){
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("device_id", insertParam.getDevice_id());
		map.put("device_serial",insertParam.getDevice_serial());
		
		List<ToolInfoModel> info = mapper.selectToolInfo(map);
		
		if ( info.size() > 0)
			res.setResult(300);
		else
		{
			mapper.insertToolId(insertParam);

		}
		
		return res;
	}


	public List<ToolInfoModel> getToolInfo(String tool_id , String tool_serial){
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("device_id", tool_id);
		map.put("device_serial",tool_serial);
		
		List<ToolInfoModel> info = mapper.selectToolInfo(map);
		
		return info;
	}
	
	public BaseResponse updateToolId(ToolInfoModel updateParam){
		
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		try{
			mapper.updateToolId(updateParam);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
	
	public BaseResponse deleteToolId(String plant_cd, String tool_id, String tool_serial){
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("device_id",tool_id);
		map.put("device_serial", tool_serial);
		
		try{
			mapper.deleteToolId(map);
		}catch(Exception e){
			res.setResult(300);
		}
		return res;
	}

	public BaseResponse getJobNolList(int page,
									  int show_count, 
									  String plant_cd, 
									  String car_type, 
									  String tool_id,
									  String excel_down ){
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		
		String[] array;
		String pdevice_id = "-1";
		String pdevice_serial = "-1";
		 
		if( !tool_id.equals("-1")){
			array = tool_id.split("-");
			pdevice_id = array[0].trim().toString();
			pdevice_serial = array[1].trim().toString();
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("car_type", car_type);
		map.put("device_id",pdevice_id);
		map.put("device_serial", pdevice_serial);
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
		
		List<JobNoListModel> list = mapper.selectJobNoList(map);
		int total = mapper.selectJobNoListCount(map);
		
		JobNoListReturn response = new JobNoListReturn();
		
		response.setList(list);
		response.setTotal_count(total);
		
		return response;
	}
	
	public BaseResponse insertJobNo(JobNoInfo inputparam){
		
		BaseResponse res = new BaseResponse();
		
		return res;
	}
}