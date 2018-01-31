package com.spring.service.chart;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.config.Utils;
import com.spring.dao.chart.IChartMapper;
import com.spring.model.BaseResponse;
import com.spring.model.chart.FaultyChartModel;
import com.spring.model.chart.FaultyChartReturn;
import com.spring.model.chart.LineChartModel;
import com.spring.model.chart.LineChartReturn;
import com.spring.model.chart.LineChartStandardValueModel;
import com.spring.model.chart.XbarRChartReturn;

@Service
public class ChartService implements IChartService{

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public Utils utils = new Utils();
	
	public BaseResponse getChartLine(String plant_cd,String from_dt,String to_dt,String display_type,String tool,String old_data){
		
		
		
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !tool.equals("-1")){
			array = tool.split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		String table_nm = "";
		if ( old_data.equals("N"))
			table_nm = "TIGHTENING_BATCH_INFO";
		else
			table_nm = "TIGHTENING_BATCH_INFO_BK";
		
		
		IChartMapper mapper = sqlSession.getMapper(IChartMapper.class);
		long time1 = System.currentTimeMillis ();
		
		HashMap<String , Object> map = new HashMap<String,Object>();
		map.put("plant_cd", utils.rpad(plant_cd,4,' '));
		map.put("display_type", display_type);
		map.put("from_dt", from_dt);
		map.put("to_dt", to_dt);
		map.put("device_id", utils.rpad(device_id,10,' '));
		map.put("device_serial", device_serial);
		map.put("table_nm", table_nm);
		
		long time2 = System.currentTimeMillis ();
		List<LineChartModel> valuelist = mapper.selectLineChart(map);
		long time3 = System.currentTimeMillis ();
		LineChartStandardValueModel standardvalue = mapper.selectStandardValue(map);
		long time4 = System.currentTimeMillis ();
		
		
		LineChartReturn response = new LineChartReturn();
		
		
		response.setValuelist(valuelist);
		response.setStandardlist(standardvalue);
		
		System.out.println ( "4-3=====>" + ( time4 - time3 ) / 1000.0  + "<=====");
		System.out.println ( "3-2=====>" + ( time3 - time2 ) / 1000.0  + "<=====");
		System.out.println ( "2-1=====>" + ( time2 - time1 ) / 1000.0  + "<=====");
		
		return response; 
	}
	
	public BaseResponse getChartFaulty(String plant_cd,String from_dt,String to_dt,String display_type,String tool,String old_data){

		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !tool.equals("-1")){
			array = tool.split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		String table_nm = "";
		if ( old_data.equals("N"))
			table_nm = "TIGHTENING_BATCH_INFO";
		else
			table_nm = "TIGHTENING_BATCH_INFO_BK";
		
		
		IChartMapper mapper = sqlSession.getMapper(IChartMapper.class);
		//long time1 = System.currentTimeMillis ();
		
		HashMap<String , Object> map = new HashMap<String,Object>();
		map.put("plant_cd", Utils.rpad(plant_cd, 4, ' '));
		
		map.put("display_type", "");
		if (display_type.trim().equals("M"))
			map.replace("display_type", "SUBSTR(TIGHTENING_DT, 1, 7)");
		else if (display_type.trim().equals("D"))
			map.replace("display_type", "SUBSTR(TIGHTENING_DT, 1, 10)");
		else if (display_type.trim().equals("H"))
			map.replace("display_type", "SUBSTR(TIGHTENING_DT, 1, 13)");
		else if (display_type.trim().equals("C"))
			map.replace("display_type", "SUBSTR(BODY_NO, 1, 4)");
		
		map.put("from_dt", from_dt);
		map.put("to_dt", to_dt);
		map.put("device_id", utils.rpad(device_id,10,' '));
		map.put("device_serial", device_serial);
		map.put("table_nm", table_nm);
		
		//long time2 = System.currentTimeMillis ();
		List<FaultyChartModel> list = mapper.selectFaultyChart(map);
		//long time3 = System.currentTimeMillis ();
		//LineChartStandardValueModel standardvalue = mapper.selectStandardValue(map);
		//long time4 = System.currentTimeMillis ();
		
		
		FaultyChartReturn res = new FaultyChartReturn();
		
		res.setList(list);
		
		
		//response.setValuelist(valuelist);
		//response.setStandardlist(standardvalue);
		
		//System.out.println ( "4-3=====>" + ( time4 - time3 ) / 1000.0  + "<=====");
		//System.out.println ( "3-2=====>" + ( time3 - time2 ) / 1000.0  + "<=====");
		//System.out.println ( "2-1=====>" + ( time2 - time1 ) / 1000.0  + "<=====");
		
		return res; 
	}
	
	public BaseResponse getChartXbarR(String plant_cd,String from_dt,String to_dt,String tool,String grp_size,String data_gbn,String old_data){
		String[] array;
		String device_id = "-1";
		String device_serial = "-1";
		 
		if( !tool.equals("-1")){
			array = tool.split("-");
			device_id = array[0].trim().toString();
			device_serial = array[1].trim().toString();
		}
		
		String table_nm = "";
		if ( old_data.equals("Y"))
			table_nm = "TIGHTENING_BATCH_INFO_BK";
		else
			table_nm = "TIGHTENING_BATCH_INFO";
		
		
		IChartMapper mapper = sqlSession.getMapper(IChartMapper.class);
		//long time1 = System.currentTimeMillis ();
		
		HashMap<String , Object> map = new HashMap<String,Object>();
		map.put("plant_cd", utils.rpad(plant_cd, 4, ' '));
		map.put("from_dt", from_dt);
		map.put("to_dt", to_dt);
		map.put("device_id", utils.rpad(device_id,10,' '));
		map.put("device_serial", device_serial);
		map.put("table_nm", table_nm);
		map.put("group_size",grp_size);
		
		map.put("x_sub", "");
		map.put("r_sub", "");
		if ( data_gbn.trim().equals("T")){
			map.replace("x_sub", " SELECT ROUND(AVG(VAL), 2)  XVAL FROM ( SELECT TOR_VALUE VAL");
			map.replace("r_sub", " SELECT MAX(VAL) - MIN(VAL) RVAL FROM ( SELECT TOR_VALUE VAL");
		}else if (data_gbn.trim().equals("A")) {
			map.replace("x_sub", " SELECT ROUND(AVG(VAL), 2)  XVAL FROM ( SELECT ANG_VALUE VAL");
			map.replace("r_sub", " SELECT MAX(VAL) - MIN(VAL) RVAL FROM ( SELECT ANG_VALUE VAL");
		}
		
		long time1 = System.currentTimeMillis ();
		List<String> xchart = mapper.selectXbarChart(map);
		long time2 = System.currentTimeMillis ();
		List<String> rchart = mapper.selectRchart(map);
		long time3 = System.currentTimeMillis ();
		LineChartStandardValueModel standardvalue = mapper.selectStandardValue(map);
		long time4 = System.currentTimeMillis ();
		
		System.out.println ( "4-3=====>" + ( time4 - time3 ) / 1000.0  + "<=====");
		System.out.println ( "3-2=====>" + ( time3 - time2 ) / 1000.0  + "<=====");
		System.out.println ( "2-1=====>" + ( time2 - time1 ) / 1000.0  + "<=====");
		System.out.println ( "Total===>" + ( time4 - time1 ) / 1000.0  + "<=====");
		
		XbarRChartReturn res = new XbarRChartReturn();
		
		res.setXchart(xchart);
		res.setRchart(rchart);
		res.setStandardvalue(standardvalue);
		
		return res;
	}
}
