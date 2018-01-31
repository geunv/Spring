package com.spring.model.system;

import java.util.List;

import com.spring.model.BaseResponse;

public class ProgramProcessListReturn extends BaseResponse {
	int total_count;
	
	List<ProgramProcessListModel> list;

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public List<ProgramProcessListModel> getList() {
		return list;
	}

	public void setList(List<ProgramProcessListModel> list) {
		this.list = list;
	}
	
	
}
