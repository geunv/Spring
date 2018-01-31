package com.spring.model.chart;

import java.util.List;

import com.spring.model.BaseResponse;

public class XbarRChartReturn extends BaseResponse {

	List<String> xchart;
	
	List<String> rchart;
	
	LineChartStandardValueModel standardvalue;

	public List<String> getXchart() {
		return xchart;
	}

	public void setXchart(List<String> xchart) {
		this.xchart = xchart;
	}

	public List<String> getRchart() {
		return rchart;
	}

	public void setRchart(List<String> rchart) {
		this.rchart = rchart;
	}

	public LineChartStandardValueModel getStandardvalue() {
		return standardvalue;
	}

	public void setStandardvalue(LineChartStandardValueModel standardvalue) {
		this.standardvalue = standardvalue;
	}
	
	
}
