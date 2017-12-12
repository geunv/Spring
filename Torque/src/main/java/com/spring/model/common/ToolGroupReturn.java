package com.spring.model.common;

import java.util.List;

import com.spring.model.BaseResponse;

public class ToolGroupReturn extends BaseResponse {

	List<ToolGroupModel> list ;

	public List<ToolGroupModel> getList() {
		return list;
	}

	public void setList(List<ToolGroupModel> list) {
		this.list = list;
	}
	
}
