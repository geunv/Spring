package com.spring.model.setting;

import java.util.List;

import com.spring.model.BaseResponse;

public class UserListReturn extends BaseResponse {
	List<UserListModel> list;
	
	int total_count;

	public List<UserListModel> getList() {
		return list;
	}

	public void setList(List<UserListModel> list) {
		this.list = list;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	
	
}
