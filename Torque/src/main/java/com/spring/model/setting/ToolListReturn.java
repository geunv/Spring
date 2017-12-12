package com.spring.model.setting;

import java.util.List;

import com.spring.model.BaseResponse;

public class ToolListReturn extends BaseResponse  {

	List<ToolListModel> list;
	
	int total_count;

	public List<ToolListModel> getList() {
		return list;
	}

	public void setList(List<ToolListModel> list) {
		this.list = list;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	
}
