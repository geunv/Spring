package com.spring.service.result;

import com.spring.model.BaseResponse;

public interface IResultService {
	
	public BaseResponse getResultSummary(int page,int show_count,String plant_cd,String work_dt,String line_cd,String shift,String tool,String excel_down);
	
	public BaseResponse getResultDetail(int page,int show_count,String plant_cd,String from_dt,String to_dt,String shift,String tool,String tightening_result,String seq,String car_type,String body_no,String old_data,String all_batch,String excel_down);
}
