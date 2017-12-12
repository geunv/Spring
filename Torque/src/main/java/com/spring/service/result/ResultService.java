package com.spring.service.result;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.result.IResultMapper;
import com.spring.dao.setting.ISettingMapper;
import com.spring.model.BaseResponse;
import com.spring.model.result.SummaryListModel;
import com.spring.model.setting.JobNoListModel;

@Service
public class ResultService implements IResultService {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public BaseResponse getResultSummary(int page,int show_count,String plant_cd,String work_dt,String line_cd,String shift,String tool,String excel_down){
		
		IResultMapper mapper = sqlSession.getMapper(IResultMapper.class);
		
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !tool.equals("-1")){
			array = tool.split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		HashMap<String, Object> map = new HashMap<String,Object>();
		map.put("plant_cd", plant_cd);
		map.put("work_dt", work_dt);
		map.put("line_cd", line_cd);
		map.put("shift", shift);
		map.put("device_id",device_id);
		map.put("device_serial", device_serial);
		
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
		
		List<SummaryListModel> list = mapper.selectSummaryList(map);
		int total = mapper.selectSummaryListCount(map);
		
		BaseResponse res = new BaseResponse();
		
		return res;
		
	}
	
}
