package com.spring.dao.chart;

import java.util.HashMap;
import java.util.List;

import com.spring.model.chart.LineChartModel;
import com.spring.model.chart.LineChartParam;
import com.spring.model.chart.LineChartStandardValueModel;

public interface IChartMapper {
	
	public List<LineChartModel> selectLineChart(HashMap<String,Object> map);
	
	public LineChartStandardValueModel selectStandardValue(HashMap<String,Object> map);
}
