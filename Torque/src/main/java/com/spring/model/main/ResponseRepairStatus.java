package com.spring.model.main;

import java.util.List;

import com.spring.model.BaseResponse;

public class ResponseRepairStatus extends BaseResponse {

	List<MainRepairConn> list ;

	public List<MainRepairConn> getList() {
		return list;
	}

	public void setList(List<MainRepairConn> list) {
		this.list = list;
	}
	
}
