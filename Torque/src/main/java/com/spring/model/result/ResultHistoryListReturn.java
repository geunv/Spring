package com.spring.model.result;

import java.util.List;

import com.spring.model.BaseResponse;

public class ResultHistoryListReturn extends BaseResponse {

	List<ResultHistoryListModel> list ;
	
	int total_count;

	public List<ResultHistoryListModel> getList() {
		return list;
	}

	public void setList(List<ResultHistoryListModel> list) {
		this.list = list;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	
	
}
