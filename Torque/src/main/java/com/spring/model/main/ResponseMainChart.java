package com.spring.model.main;

import java.util.List;

import com.spring.model.BaseResponse;

public class ResponseMainChart extends BaseResponse {

	List<MainThighteningResult> list;

	public List<MainThighteningResult> getList() {
		return list;
	}

	public void setList(List<MainThighteningResult> list) {
		this.list = list;
	}
	
	
}
