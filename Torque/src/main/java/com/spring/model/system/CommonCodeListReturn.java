package com.spring.model.system;

import java.util.List;

import com.spring.model.BaseResponse;

public class CommonCodeListReturn extends BaseResponse {
	int total_count;
	
	List<CommonCodeListModel> list;

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public List<CommonCodeListModel> getList() {
		return list;
	}

	public void setList(List<CommonCodeListModel> list) {
		this.list = list;
	}
	
	
}
