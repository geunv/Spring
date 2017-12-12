package com.spring.model.main;

import java.util.List;

import com.spring.model.BaseResponse;

public class ResponseDisToolList extends BaseResponse {

	List<MainDisconnectedTool> list;

	MainToolStatus statuslist;
	
	public List<MainDisconnectedTool> getList() {
		return list;
	}

	public void setList(List<MainDisconnectedTool> list) {
		this.list = list;
	}

	public MainToolStatus getStatuslist() {
		return statuslist;
	}

	public void setStatuslist(MainToolStatus statuslist) {
		this.statuslist = statuslist;
	}

	
	
}
