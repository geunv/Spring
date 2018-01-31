package com.spring.model.result;

import java.util.List;

import com.spring.model.BaseResponse;

public class CycleTestResultListReturn extends BaseResponse {

	int total_count;
	
	List<CycleTestResultListModel> list;

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public List<CycleTestResultListModel> getList() {
		return list;
	}

	public void setList(List<CycleTestResultListModel> list) {
		this.list = list;
	}
	
	
}
