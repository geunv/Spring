package com.spring.service.chart;

import com.spring.model.BaseResponse;

public interface IChartService {

	public BaseResponse getChartLine(String plant_cd,String from_dt,String to_dt,String display_type,String tool,String old_data);
	
	public BaseResponse getChartFaulty(String plant_cd,String from_dt,String to_dt,String display_type,String tool,String old_data);
	
	public BaseResponse getChartXbarR(String plant_cd,String from_dt,String to_dt,String tool,String grp_size,String data_gbn,String old_data);
}
