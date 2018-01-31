package com.spring.model.result;

import java.util.List;

import com.spring.model.BaseResponse;

public class ResultByDateListReturn extends BaseResponse {
	int total_count;
	
	List<ResultByDateListModel> list;

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public List<ResultByDateListModel> getList() {
		return list;
	}

	public void setList(List<ResultByDateListModel> list) {
		this.list = list;
	}
	
	
}
