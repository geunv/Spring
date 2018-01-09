package com.spring.service.setting;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.dao.setting.ISettingMapper;
import com.spring.model.BaseResponse;
import com.spring.model.setting.JobNoConditionModel;
import com.spring.model.setting.JobNoConditionTempModel;
import com.spring.model.setting.JobNoInfo;
import com.spring.model.setting.JobNoInfoReturn;
import com.spring.model.setting.JobNoInsertParam;
import com.spring.model.setting.JobNoListModel;
import com.spring.model.setting.JobNoListReturn;
import com.spring.model.setting.ToolInfoModel;
import com.spring.model.setting.ToolListModel;
import com.spring.model.setting.ToolListParam;
import com.spring.model.setting.ToolListReturn;
import com.spring.model.setting.UserInfoModel;
import com.spring.model.setting.UserInsertParam;
import com.spring.model.setting.UserListModel;
import com.spring.model.setting.UserListReturn;

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
	
	public BaseResponse insertJobNo(JobNoInsertParam insertParam){
		
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		
		
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !insertParam.getTool().equals("-1")){
			array = insertParam.getTool().split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", insertParam.getPlant_cd());
		map.put("device_id", device_id);
		map.put("device_serial",device_serial);
		map.put("car_type", insertParam.getCar_type());
		map.put("job_num", insertParam.getJob_num());
		
		insertParam.setDevice_id(device_id);
		insertParam.setDevice_serial(device_serial);
		
		List<JobNoInfo> info = mapper.selectJobNoInfo(map);
				
		if ( info.size() > 0)
			res.setResult(300);
		else
		{
			
			
			
			List<JobNoConditionModel> sublist = subprocess(insertParam);
			
			int cond_grp_num = 1;
			if ( sublist.size() > 1)
				cond_grp_num = maxNum(sublist);
			
			for ( int i= 0; i < cond_grp_num;i++){
				insertParam.setCond_grp_num(Integer.toString(i+1));
				//map.replace("cond_grp_num",Integer.toString(i+1) );
				mapper.insertJobNo(insertParam);
			}
			
			if ( insertParam.getCond_use_flg().equals("Y"))
			{
								
				for(JobNoConditionModel ins : sublist){
					HashMap<String, Object> submap = new HashMap<String,Object>();
					
					submap.put("plant_cd", insertParam.getPlant_cd());
					submap.put("device_id", device_id);
					submap.put("device_serial",device_serial);
					submap.put("car_type", insertParam.getCar_type());
					submap.put("job_num", insertParam.getJob_num());
					
					
					submap.put("cond_grp_num", ins.getCond_grp_num());
					submap.put("cond_seq", ins.getCond_seq());
					submap.put("cond_gub", ins.getCond_gub());
					submap.put("spec219_num", ins.getSpec219_num());
					
					submap.put("equal_operator_flg", ins.getEqual_operator_flg());
					submap.put("spec219_value", ins.getSpec219_value());
					submap.put("reg_user_id", insertParam.getReg_user_id());
					
					mapper.insertJobNoCondition(submap);
					
				}
				
			}
		}
		
		return res;
	}
	
	public BaseResponse getJobNoInfo(String plant_cd,String car_type,String device_id,String device_serial,String job_num){
	
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("device_id", device_id);
		map.put("device_serial",device_serial);
		map.put("car_type", car_type);
		map.put("job_num", job_num);
		
		List<JobNoInfo> info = mapper.selectJobNoInfo(map);
		
		List<JobNoConditionModel> condInfo = mapper.selectJobNoConditionInfo(map);
		String cond_expr = CompressedCondition(condInfo);
		
		List<JobNoConditionTempModel> templist = bindCondition(condInfo);
		
		JobNoInfoReturn res = new JobNoInfoReturn();
		
		res.setCond_expr(cond_expr);
		res.setInfolist(info);
		res.setCondlist(templist);
		
		return res;
	}
	
	public String CompressedCondition(List<JobNoConditionModel> condInfo){
		String str = "";
		int utf32 = 65;
		
		if( condInfo != null && condInfo.size() > 0){
			for(int index = 0 ; index < condInfo.size(); ++index){
				str += Character.toString ((char) utf32);
				if ( index + 1 < condInfo.size() && condInfo.get(index).getCond_grp_num().equals(condInfo.get(index+1).getCond_grp_num()))
					str += "&";
				else if ( index + 1 < condInfo.size() &&  Integer.parseInt(condInfo.get(index).getCond_grp_num().trim()) < Integer.parseInt(condInfo.get(index+1).getCond_grp_num().trim()))
					str += "|";
				++utf32;
			}
		}
		
		return str;
	}
	
	public List<JobNoConditionTempModel> bindCondition(List<JobNoConditionModel> list){
		
		List<JobNoConditionTempModel> tempList = new ArrayList<JobNoConditionTempModel>();
		
		
		int utf32 = 65;
		for(JobNoConditionModel li : list){
			JobNoConditionTempModel mo = new JobNoConditionTempModel();
			mo.setCond_seq(Character.toString ((char) utf32));
			mo.setCond_type(li.getCond_gub());
			mo.setCond_no(li.getSpec219_num());
			mo.setCond_operator(li.getEqual_operator_flg());
			mo.setCond_optval(li.getSpec219_value());
			utf32++;
			tempList.add(mo);
		}
		
		return tempList;
	}
	
	public int maxNum(List<JobNoConditionModel> list){
		
		ArrayList<Integer> arrayList = new ArrayList<Integer>();
		for ( JobNoConditionModel num: list){
			arrayList.add(new Integer(num.getCond_grp_num()));
		}
		
		return Collections.max(arrayList);
	}
	
	public List<JobNoConditionModel> subprocess(JobNoInsertParam insertParam){
		
		List<JobNoConditionModel> sublist = new ArrayList<JobNoConditionModel>();
		
		String[] strArray1 = insertParam.getCondition_exp().split("\\|");
		
		int length1 = strArray1.length;
		ArrayList arrayList = new ArrayList();
		
		for (int index =0; index < length1; ++index){
			
			//String[] strArray2 =  strArray1.toString().split("&");
			int num1 = 1;
			char[] chars = strArray1[index].toCharArray();
			for(int i= 0 ; i < chars.length ; i++ ){
				String obj = Character.toString(chars[i]);
				if(!obj.toString().equals("&"))
					arrayList.add(obj);
				
				JobNoConditionTempModel insText = takeOut(insertParam,obj);
				
				if (insText.getCond_seq() != null)
		          {
					JobNoConditionModel row = new JobNoConditionModel();
					row.setCond_grp_num(Integer.toString(index+1));
					row.setCond_seq(Integer.toString(num1));
					row.setCond_gub(insText.getCond_type());
					row.setSpec219_num(insText.getCond_no());
					row.setEqual_operator_flg(insText.getCond_operator());
					row.setSpec219_value(insText.getCond_optval());
					sublist.add(row);
		            ++num1;
		          }
				
			
			}
		 
		}
		
		return sublist;
	}
	
	public JobNoConditionTempModel takeOut(JobNoInsertParam ins,String obj){
		
		List<JobNoConditionTempModel> tempList = new ArrayList<JobNoConditionTempModel>();
		
		if ( ins.getCond_no1().trim().length() > 0){
			JobNoConditionTempModel model = new JobNoConditionTempModel();
			model.setCond_seq(ins.getCond_seq1());
			model.setCond_type(ins.getCond_type1());
			model.setCond_no(ins.getCond_no1());
			model.setCond_operator(ins.getCond_operator1());
			model.setCond_optval(ins.getCond_optval1());
			tempList.add(model);
		}
		
		if ( ins.getCond_no2().trim().length() > 0){
			JobNoConditionTempModel model = new JobNoConditionTempModel();
			model.setCond_seq(ins.getCond_seq2());
			model.setCond_type(ins.getCond_type2());
			model.setCond_no(ins.getCond_no2());
			model.setCond_operator(ins.getCond_operator2());
			model.setCond_optval(ins.getCond_optval2());
			tempList.add(model);
		}
		
		if ( ins.getCond_no3().trim().length() > 0){
			JobNoConditionTempModel model = new JobNoConditionTempModel();
			model.setCond_seq(ins.getCond_seq3());
			model.setCond_type(ins.getCond_type3());
			model.setCond_no(ins.getCond_no3());
			model.setCond_operator(ins.getCond_operator3());
			model.setCond_optval(ins.getCond_optval3());
			tempList.add(model);
		}
		
		if ( ins.getCond_no4().trim().length() > 0){
			JobNoConditionTempModel model = new JobNoConditionTempModel();
			model.setCond_seq(ins.getCond_seq4());
			model.setCond_type(ins.getCond_type4());
			model.setCond_no(ins.getCond_no4());
			model.setCond_operator(ins.getCond_operator4());
			model.setCond_optval(ins.getCond_optval4());
			tempList.add(model);
		}
		
		JobNoConditionTempModel mo =new JobNoConditionTempModel();
		
		for(JobNoConditionTempModel aa : tempList){
			if ( aa.getCond_seq().equals(obj))
			{
				mo = aa;
				break;
			}
		}
		
		
		return mo;
	
	}
	
	@Transactional(rollbackFor=Exception.class)
	public BaseResponse updateJobNo(JobNoInsertParam updateParam) {
		
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !updateParam.getTool().equals("-1")){
			array = updateParam.getTool().split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", updateParam.getPlant_cd());
		map.put("device_id", device_id);
		map.put("device_serial",device_serial);
		map.put("car_type", updateParam.getCar_type());
		map.put("job_num", updateParam.getJob_num());
		
		updateParam.setDevice_id(device_id);
		updateParam.setDevice_serial(device_serial);

			
			mapper.deleteJobNo(map);
			mapper.deleteJobNoCond(map);
			
			List<JobNoConditionModel> sublist = subprocess(updateParam);
			
			int cond_grp_num = 1;
			if ( sublist.size() > 1)
				cond_grp_num = maxNum(sublist);
			
			for ( int i= 0; i < cond_grp_num;i++){
				updateParam.setCond_grp_num(Integer.toString(i+1));
				//map.replace("cond_grp_num",Integer.toString(i+1) );
				mapper.insertJobNo(updateParam);
			}
			
			if ( updateParam.getCond_use_flg().equals("Y"))
			{
								
				for(JobNoConditionModel ins : sublist){
					HashMap<String, Object> submap = new HashMap<String,Object>();
					
					submap.put("plant_cd", updateParam.getPlant_cd());
					submap.put("device_id", device_id);
					submap.put("device_serial",device_serial);
					submap.put("car_type", updateParam.getCar_type());
					submap.put("job_num", updateParam.getJob_num());
					
					
					submap.put("cond_grp_num", ins.getCond_grp_num());
					submap.put("cond_seq", ins.getCond_seq());
					submap.put("cond_gub", ins.getCond_gub());
					submap.put("spec219_num", ins.getSpec219_num());
					
					submap.put("equal_operator_flg", ins.getEqual_operator_flg());
					submap.put("spec219_value", ins.getSpec219_value());
					submap.put("reg_user_id", updateParam.getReg_user_id());
					
					mapper.insertJobNoCondition(submap);
					
				}
				
			}
		
		
		
		
		return res;
	}

	public BaseResponse deleteJobNo(String plant_cd,String car_type,String tool,String job_num){
		
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !tool.equals("-1")){
			array = tool.split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("car_type", car_type);
		map.put("device_id",device_id);
		map.put("device_serial", device_serial);
		map.put("job_num", job_num);
		
		
		try{
			mapper.deleteJobNo(map);
			mapper.deleteJobNoCond(map);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
	
	public BaseResponse getUserList(String plant_cd,String user_authority,String user_grp,String user_id,String user_nm,String user_grade,int page,int show_count,String excel_down ){
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("user_authority", user_authority);
		map.put("user_grp", user_grp);
		map.put("user_id", user_id);
		map.put("user_nm", user_nm);
		map.put("user_grade", user_grade);
		
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

		List<UserListModel> list = mapper.selectUserList(map);
		int total_count = mapper.selectUserListCount(map);
		
		UserListReturn response = new UserListReturn();
		
		response.setList(list);
		response.setTotal_count(total_count);
		
		return response;
		
	}
	
	public BaseResponse insertUser(UserInsertParam insertParam){
		
		BaseResponse res = new BaseResponse();
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", insertParam.getUser_id());
		
		List<UserInfoModel> info = mapper.selectUserInfo(map);
		
		if (info.size() > 0)
			res.setResult(300);
		else
			mapper.insertUserInfo(insertParam);
			
		return res;
	}
	
	public List<UserInfoModel> SelectUserInfo(String user_id){
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", user_id);
		
		List<UserInfoModel> info = mapper.selectUserInfo(map);
		
		return info;
	}
	
	public BaseResponse updateUser(UserInsertParam updateParam){
		BaseResponse res = new BaseResponse();
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("user_id", updateParam.getUser_id());

		if ( updateParam.getUser_authority() == "-1")
			updateParam.setUser_authority(" ");
		
		if(updateParam.getUser_grp() == "-1")
			updateParam.setUser_grp(" ");
		
		if(updateParam.getUser_pw().trim().length() == 0 )
			updateParam.setUser_pw(" ");
		
		if(updateParam.getUser_nm().trim().length() == 0 )
			updateParam.setUser_nm(" ");
		
	    
		try{
			mapper.updateUserInfo(updateParam);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
	
	public BaseResponse deleteUser(String plant_cd, String user_id){
		
		ISettingMapper mapper = sqlSession.getMapper(ISettingMapper.class);
		BaseResponse res = new BaseResponse();
		
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("plant_cd", plant_cd);
		map.put("user_id", user_id);
		
		
		try{
			mapper.deleteUserInfo(map);
		}catch(Exception e){
			res.setResult(300);
		}
		
		return res;
	}
}
