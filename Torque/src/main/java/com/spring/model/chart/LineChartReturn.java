package com.spring.model.chart;

import java.util.List;

import com.spring.model.BaseResponse;

public class LineChartReturn extends BaseResponse{
	List<LineChartModel> valuelist;
	
	LineChartStandardValueModel standardlist;

	public List<LineChartModel> getValuelist() {
		return valuelist;
	}
	
	public void setValuelist(List<LineChartModel> valuelist) {
		this.valuelist = valuelist;
	}

	public LineChartStandardValueModel getStandardlist() {
		return standardlist;
	}

	public void setStandardlist(LineChartStandardValueModel standardlist) {
		this.standardlist = standardlist;
	}
	
}
