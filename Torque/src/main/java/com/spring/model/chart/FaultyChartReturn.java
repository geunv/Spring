package com.spring.model.chart;

import java.util.List;

import com.spring.model.BaseResponse;

public class FaultyChartReturn extends BaseResponse {
	List<FaultyChartModel> list;

	public List<FaultyChartModel> getList() {
		return list;
	}

	public void setList(List<FaultyChartModel> list) {
		this.list = list;
	}
	
}
