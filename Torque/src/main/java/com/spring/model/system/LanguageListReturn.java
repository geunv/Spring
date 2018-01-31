package com.spring.model.system;

import java.util.List;

import com.spring.model.BaseResponse;

public class LanguageListReturn extends BaseResponse {
	int total_count;
	
	List<LanguageListModel> list;

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public List<LanguageListModel> getList() {
		return list;
	}

	public void setList(List<LanguageListModel> list) {
		this.list = list;
	}
	
	
}
