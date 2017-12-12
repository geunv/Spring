package com.spring.service.result;

import com.spring.model.BaseResponse;

public interface IResultService {
	
	public BaseResponse getResultSummary(int page,int show_count,String plant_cd,String work_dt,String line_cd,String shift,String tool,String excel_down);
}
