package com.spring.model.common;

import java.util.List;

import com.spring.model.BaseResponse;

public class ToolIDReturn extends BaseResponse {
	List<ToolIDModel> list ;

	public List<ToolIDModel> getList() {
		return list;
	}

	public void setList(List<ToolIDModel> list) {
		this.list = list;
	}
}
