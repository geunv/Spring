package com.spring.model.menu;

import java.util.List;

import com.spring.model.BaseResponse;

public class ResponseMenu extends BaseResponse {

	public List<MainMenu> list;

	public List<MainMenu> getList() {
		return list;
	}

	public void setList(List<MainMenu> list) {
		this.list = list;
	}
	
	
}
