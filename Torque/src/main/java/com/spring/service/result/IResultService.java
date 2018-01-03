package com.spring.service.result;

import com.spring.model.BaseResponse;

public interface IResultService {
	
	
	public BaseResponse getResultSummary(int page,int show_count,String plant_cd,String work_dt,String line_cd,String shift,String tool,String excel_down);
	
	public BaseResponse getResultDetail(int page,int show_count,String plant_cd,String from_dt,String to_dt,String shift,String tool,String tightening_result,String seq,String car_type,String body_no,String old_data,String all_batch,String excel_down);
	
	public BaseResponse getResultHistory(int page,int show_count,String plant_cd,String from_dt,String to_dt,String tool,String tightening_result,String seq,String car_type,String body_no,String old_data,String excel_down);
	
	public BaseResponse getResultByDate(int page,int show_count,String plant_cd,String from_dt,String to_dt,String tool,String excel_down);
	
	public BaseResponse getCycleTestResult(int page,int show_count,String plant_cd,String work_dt,String hh,String pgm_id,String proc_id,String car_type,String tool,String txt_car_type,String txt_body_no,String  excel_down);
	
	public BaseResponse getLineStopHistory(int page,int show_count,String plant_cd,String work_dt,String interlock_type,String tool,String txt_car_type,String txt_body_no,String excel_down);
}
