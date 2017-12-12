package com.spring.model.setting;

import java.util.List;

import com.spring.model.BaseResponse;

public class JobNoListReturn  extends BaseResponse{
	
	int total_count;
	
	List<JobNoListModel> list ;

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}

	public List<JobNoListModel> getList() {
		return list;
	}

	public void setList(List<JobNoListModel> list) {
		this.list = list;
	}
}
