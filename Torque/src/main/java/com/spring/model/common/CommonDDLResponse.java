package com.spring.model.common;

import java.util.List;

import com.spring.model.BaseResponse;

public class CommonDDLResponse extends BaseResponse {

	List<CommonDDLReturn> list ;

	public List<CommonDDLReturn> getList() {
		return list;
	}

	public void setList(List<CommonDDLReturn> list) {
		this.list = list;
	}
	
}
