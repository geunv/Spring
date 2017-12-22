package com.spring.service.common;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.ICommonMapper;
import com.spring.model.BaseResponse;
import com.spring.model.common.CommonDDLResponse;
import com.spring.model.common.CommonDDLReturn;
import com.spring.model.common.ProcessDDLReturn;
import com.spring.model.common.ProgramDDLReturn;
import com.spring.model.common.TighteningResultModel;
import com.spring.model.common.ToolGroupModel;
import com.spring.model.common.ToolGroupReturn;
import com.spring.model.common.ToolIDModel;
import com.spring.model.common.ToolIDParam;
import com.spring.model.common.ToolIDReturn;

@Service
public class CommonService implements ICommonService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public BaseResponse getPlant(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectPlant();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse getCarType(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectCarType();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse getLine(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectLine();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse getStnType(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list =  mapper.selectStn();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse getShift(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list =  mapper.selectShift();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse getToolGroup(String plant_cd){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<ToolGroupModel> list = mapper.selectToolGroup(plant_cd);
		
		ToolGroupReturn response = new ToolGroupReturn();
		response.setList(list);
		
		return response;
	}
	
	
	public BaseResponse getToolID(String plant_cd, String device_grp_cd,String stn_gub,String line_cd,String web_display_flg){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		
		ToolIDParam param = new ToolIDParam();
		param.setPlant_cd(plant_cd);
		param.setDevice_grp_cd(device_grp_cd);
		param.setStn_gub(stn_gub);
		param.setLine_cd(line_cd);
		param.setWeb_display_flg(web_display_flg);
		
		List<ToolIDModel> list = mapper.selectToolID(param);
		
		ToolIDReturn response = new ToolIDReturn();
		response.setList(list);
		
		return response;
		
	}
	
	public BaseResponse getJobNoTool(String plant_cd, String car_type){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("car_type", car_type);
		
		List<ToolIDModel> list = mapper.selectJobNoTool(map);
		
		ToolIDReturn response = new ToolIDReturn();
		response.setList(list);
		
		return response;
	}
	
	public BaseResponse getToolType(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectToolType();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;		
	}
	
	public BaseResponse getToolState(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectToolState();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;		
	}
	
	
	public BaseResponse getProcState(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectProcState();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;		
	}
	
	
	public List<ProgramDDLReturn> getPgmList(String plant_cd, String stn_gub){
		
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("stn_gub", stn_gub);
		
		List<ProgramDDLReturn> list = mapper.selectPgmList(map);
		
		return list;
		
	}
	
	public List<ProcessDDLReturn> getProcList(String plant_cd,String stn_gub,String pgm_id){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("stn_gub", stn_gub);
		map.put("pgm_id", pgm_id);
		
		List<ProcessDDLReturn> list = mapper.selectProcList(map);
		
		return list;
	}
	
	public BaseResponse getUseFlage(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<CommonDDLReturn> list = mapper.selectUseFlage();
		
		CommonDDLResponse response = new CommonDDLResponse();
		
		response.setList(list);
		
		return response;
	}
	
	public String getShiftTime(String code){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		String startTime = mapper.selectShiftTime(code);
		
		return startTime ;
	}
	
	public List<TighteningResultModel> getTighteningResult(){
		ICommonMapper mapper = sqlSession.getMapper(ICommonMapper.class);
		List<TighteningResultModel> list= mapper.selectTighteningResult();
		
		return list;
	}
}
