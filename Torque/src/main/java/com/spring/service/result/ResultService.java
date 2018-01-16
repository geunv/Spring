package com.spring.service.result;

import java.util.HashMap;
import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.result.IResultMapper;
import com.spring.model.BaseResponse;
import com.spring.model.result.CycleTestResultListModel;
import com.spring.model.result.CycleTestResultListReturn;
import com.spring.model.result.DetailListModel;
import com.spring.model.result.DetailListReturn;
import com.spring.model.result.DetailListSubModel;
import com.spring.model.result.LineStopHistoryModel;
import com.spring.model.result.LineStopHistoryRetrun;
import com.spring.model.result.ResultByDateListModel;
import com.spring.model.result.ResultByDateListReturn;
import com.spring.model.result.ResultHistoryListModel;
import com.spring.model.result.ResultHistoryListReturn;
import com.spring.model.result.SummaryListModel;
import com.spring.model.result.SummaryListReturn;

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
		map.put("work_dt", work_dt.replace("-", ""));
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
		
		List<SummaryListModel> list = mapper.selectResultSummaryList(map);
		
		int total = mapper.selectResultSummaryCount(map);
		
		SummaryListReturn response = new SummaryListReturn();
		response.setList(list);
		response.setTotal_count(total);
		
		return response;
		
	}
	
	
	public BaseResponse getResultDetail(int page,int show_count,String plant_cd,String from_dt,String to_dt,String shift,String tool,String tightening_result,String seq,String car_type,String body_no,String old_data,String all_batch,String excel_down){
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
		map.put("plant_cd", plant_cd+"   ");
		map.put("from_dt", from_dt.replace("-", "")+"000000");
		map.put("to_dt", to_dt.replace("-", "")+"000000");
		map.put("shift", shift);
		map.put("device_id",device_id);
		map.put("device_serial", device_serial);
		
		map.put("scan_flg", "-1");
		map.put("pass_flg", "-1");
		
		if(tightening_result.equals("-1") ){
			map.put("tightening_result", "-1");
		}else if ( tightening_result.equals("1") ){
			map.put("tightening_result", "1");
		}else if ( tightening_result.equals("0") ){
			map.put("tightening_result", "0");
		}else if ( tightening_result.equals("N") ){
			map.put("tightening_result", "-1");
			map.replace("scan_flg", "N");
		}else if ( tightening_result.equals("P") ){
			map.put("tightening_result", "-1");
			map.replace("pass_flg", "Y");
		}
		
		map.put("seq", "-1");
		if (!seq.trim().equals(""))
			map.replace("seq", seq);
		
		map.put("car_type", "-1");
		if (!car_type.trim().equals(""))
			map.put("car_type", car_type);
		
		map.put("body_no", "-1");
		if(!body_no.trim().equals(""))
			map.put("body_no", body_no);
		
		String table_nm = "";
		if ( old_data.equals("N"))
			table_nm = "TIGHTENING_STATUS_MA";
		else
			table_nm = "TIGHTENING_STATUS_BK";
		
		map.put("table_nm", table_nm);
		
		map.put("all_batch", all_batch);
		
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
		
		long time1 = System.currentTimeMillis ();
		List<DetailListModel> list = mapper.selectResultDetailList(map);
		long time2 = System.currentTimeMillis ();
		int total = mapper.selectResultDetailListCount(map);
		long time3 = System.currentTimeMillis ();
		//int batch_count = mapper.selectResultDetailListBatchCount(map);
		long time4 = System.currentTimeMillis ();

		if ( list.size() > 0 ){
			for (DetailListModel model : list) {
				/*
				HashMap<String, Object> map2 = new HashMap<String,Object>();
				map2.put("plant_cd", model.getPlant_cd());
				map2.put("device_id", model.getDevice_id());
				map2.put("device_serial", model.getDevice_serial());
				map2.put("body_no", model.getBody_no());
				
				DetailListSubModel sublist = mapper.selectResultDetailSubList(map2);
				*/
				
				model.setTen_value("");
				model.setTor_value_1("");
				model.setAng_value_1("");
				model.setTor_value_2("");
				model.setAng_value_2("");
				model.setTor_value_3("");
				model.setAng_value_3("");
				model.setTor_value_4("");
				model.setAng_value_4("");
				model.setTor_value_5("");
				model.setAng_value_5("");
				model.setTor_value_6("");
				model.setAng_value_6("");
				model.setTor_value_7("");
				model.setAng_value_7("");
				model.setTor_value_8("");
				model.setAng_value_8("");
				model.setTor_value_9("");
				model.setAng_value_9("");
				model.setTor_value_10("");
				model.setAng_value_10("");
				model.setTor_value_11("");
				model.setAng_value_11("");
				model.setTor_value_12("");
				model.setAng_value_12("");
				
				String[] array_num,array_tor,array_ang,array_ten;
				
				if ( model.getBatch_num() != null)
				{
					
					array_num = model.getBatch_num().split(",");
					array_tor = model.getTor_value().split(",");
					array_ang = model.getAng_value().split(",");
					array_ten = model.getTen_value().split(",");
					
					for(int i = 0 ; i < array_num.length ; i++){
						
						if ( i == 0 ){
							model.setTor_value_1(array_tor[i].trim());
							model.setAng_value_1(array_ang[i].trim());
							model.setTen_value(array_ten[i].trim());
						}
						else if ( i == 1 ){
							model.setTor_value_2(array_tor[i].trim());
							model.setAng_value_2(array_ang[i].trim());
						}
						else if ( i == 2 ){
							model.setTor_value_3(array_tor[i].trim());
							model.setAng_value_3(array_ang[i].trim());
						}
						else if ( i == 3 ){
							model.setTor_value_4(array_tor[i].trim());
							model.setAng_value_4(array_ang[i].trim());
						}
						else if ( i == 4 ){
							model.setTor_value_5(array_tor[i].trim());
							model.setAng_value_5(array_ang[i].trim());
						}
						else if ( i == 5 ){
							model.setTor_value_6(array_tor[i].trim());
							model.setAng_value_6(array_ang[i].trim());
						}
						else if ( i == 6 ){
							model.setTor_value_7(array_tor[i].trim());
							model.setAng_value_7(array_ang[i].trim());
						}
						else if ( i == 7 ){
							model.setTor_value_8(array_tor[i].trim());
							model.setAng_value_8(array_ang[i].trim());
						}
						else if ( i == 8 ){
							model.setTor_value_9(array_tor[i].trim());
							model.setAng_value_9(array_ang[i].trim());
						}
						else if ( i == 9 ){
							model.setTor_value_10(array_tor[i].trim());
							model.setAng_value_10(array_ang[i].trim());
						}
						else if ( i == 10 ){
							model.setTor_value_11(array_tor[i].trim());
							model.setAng_value_11(array_ang[i].trim());
						}
						else if ( i == 11 ){
							model.setTor_value_12(array_tor[i].trim());
							model.setAng_value_12(array_ang[i].trim());
						}
						
					}
				}
				/*if ( sublist.size() > 0 ){
					for(DetailListSubModel sub : sublist){
						model.setTor_value_1(sub.getTor_value());
						model.setAng_value_1(sub.getAng_value());
					}
				}*/
			}
		}
		long time5 = System.currentTimeMillis ();
		
		System.out.println ( "5-4=====>" + ( time5 - time4 ) / 1000.0  + "<=====");
		System.out.println ( "4-3=====>" + ( time4 - time3 ) / 1000.0  + "<=====");
		System.out.println ( "3-2=====>" + ( time3 - time2 ) / 1000.0  + "<=====");
		System.out.println ( "2-1=====>" + ( time2 - time1 ) / 1000.0  + "<=====");
		System.out.println ( "Total===>" + ( time5 - time1 ) / 1000.0  + "<=====");
		
		DetailListReturn res = new DetailListReturn();
		res.setList(list);
		//res.setBatch_count(batch_count);
		res.setTotal_count(total);
		
		return res;
	}
	
	public BaseResponse getResultHistory(int page,int show_count,String plant_cd,String from_dt,String to_dt,String tool,String tightening_result,String seq,String car_type,String body_no,String old_data,String excel_down){
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
		map.put("plant_cd", plant_cd+"   ");
		//map.put("from_dt", from_dt.replace("-", ""));
		//map.put("to_dt", to_dt.replace("-", ""));
		map.put("from_dt", from_dt+":00:00:00");
		map.put("to_dt", to_dt+":23:59:59");
		map.put("device_id",device_id);
		map.put("device_serial", device_serial);
		
		
		map.put("seq", "-1");
		if (!seq.trim().equals(""))
			map.replace("seq", seq);
		
		map.put("car_type", "-1");
		if (!car_type.trim().equals(""))
			map.put("car_type", car_type);
		
		map.put("body_no", "-1");
		if(!body_no.trim().equals(""))
			map.put("body_no", body_no);
		
		if(tightening_result.equals("-1") ){
			map.put("tightening_result", "-1");
		}else if ( tightening_result.equals("1") ){
			map.put("tightening_result", "1");
		}else if ( tightening_result.equals("0") ){
			map.put("tightening_result", "0");
		}
				
		String table_nm3 = "";
		String table_nm4 = "";
		
		if ( old_data.equals("Y")){
			table_nm3 = "TIGHTENING_BATCH_INFO_HI_BK";
			table_nm4= "TIGHTENING_STATUS_BK";
		}else{
			table_nm3 = "TIGHTENING_BATCH_INFO_HI";
			table_nm4 = "TIGHTENING_STATUS_MA";
		}
		
		map.put("table_nm3", table_nm3);
		map.put("table_nm4", table_nm4);
		
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
		long time1 = System.currentTimeMillis ();
		List<ResultHistoryListModel> list = mapper.selectResultHistoryList(map);
		long time2 = System.currentTimeMillis ();
		int total_count = mapper.selectResultHistoryListCount(map);
		long time3 = System.currentTimeMillis ();
		
		System.out.println ( "3-2=====>" + ( time3 - time2 ) / 1000.0  + "<=====");
		System.out.println ( "2-1=====>" + ( time2 - time1 ) / 1000.0  + "<=====");
		
		ResultHistoryListReturn res = new ResultHistoryListReturn();
		res.setList(list);
		res.setTotal_count(total_count);
		
		return res;
	}
	
	public BaseResponse getResultByDate(int page,int show_count,String plant_cd,String from_dt,String to_dt,String tool,String excel_down){
		
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
		map.put("from_dt", from_dt.replace("-", ""));
		map.put("to_dt", to_dt.replace("-", ""));
		//map.put("from_dt", from_dt);
		//map.put("to_dt", to_dt);
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
		
		List<ResultByDateListModel> list = mapper.selectResultByDate(map);
		int total_count = mapper.selectResultByDateCount(map);
		
		ResultByDateListReturn res = new ResultByDateListReturn();
		
		res.setList(list);
		res.setTotal_count(total_count);
		
		return res;
	}
	
	public BaseResponse getCycleTestResult(int page,int show_count,String plant_cd,String work_dt,String hh,String pgm_id,String proc_id,String car_type,String tool,String txt_car_type,String txt_body_no,String  excel_down){
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
		map.put("work_dt", work_dt.replace("-", ""));
		
		map.put("hh", hh);
		map.put("pgm_id", pgm_id);
		map.put("proc_id", proc_id);
		
		map.put("car_type", car_type);
		
		map.put("txt_car_type", "-1");
		if (!txt_car_type.trim().equals(""))
			map.replace("txt_car_type", txt_car_type);
		
		map.put("txt_body_no", "-1");
		if (!txt_body_no.trim().equals(""))
			map.replace("txt_body_no", txt_body_no);
		
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
		
		List<CycleTestResultListModel> list = mapper.selectCycleTestResult(map);
		int total_count = mapper.selectCycleTestResultCount(map);
		
		CycleTestResultListReturn res = new CycleTestResultListReturn();
		
		res.setList(list);
		res.setTotal_count(total_count);
		
		return res;
		
	}
	
	public BaseResponse getLineStopHistory(int page,int show_count,String plant_cd,String work_dt,String interlock_type,String tool,String txt_car_type,String txt_body_no,String excel_down){
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
		map.put("work_dt", work_dt.replace("-", ""));
		
		map.put("interlock_type", interlock_type);
		
		map.put("txt_car_type", "-1");
		if (!txt_car_type.trim().equals(""))
			map.replace("txt_car_type", txt_car_type);
		
		map.put("txt_body_no", "-1");
		if (!txt_body_no.trim().equals(""))
			map.replace("txt_body_no", txt_body_no);
		
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
		
		
		List<LineStopHistoryModel> list = mapper.selectInterlockHistory(map);
		int total_count = mapper.selectInterlockHistoryCount(map);
		
		LineStopHistoryRetrun res = new LineStopHistoryRetrun();
		
		res.setList(list);
		res.setTotal_count(total_count);
		
		return res;
	}
}

