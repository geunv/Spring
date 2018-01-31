package com.spring.model.result;

import java.util.List;

import com.spring.model.BaseResponse;

public class SummaryListReturn extends BaseResponse  {

	int total_count;
	
	List<SummaryListModel> list;

	public List<SummaryListModel> getList() {
		return list;
	}

	public void setList(List<SummaryListModel> list) {
		this.list = list;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

}
