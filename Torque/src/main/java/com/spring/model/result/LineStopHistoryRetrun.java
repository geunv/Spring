package com.spring.model.result;

import java.util.List;

import com.spring.model.BaseResponse;

public class LineStopHistoryRetrun extends BaseResponse {

	List<LineStopHistoryModel> list;
	
	int total_count;

	public List<LineStopHistoryModel> getList() {
		return list;
	}

	public void setList(List<LineStopHistoryModel> list) {
		this.list = list;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	
	
}
