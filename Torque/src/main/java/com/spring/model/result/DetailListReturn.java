package com.spring.model.result;

import java.util.List;

import com.spring.model.BaseResponse;

public class DetailListReturn  extends BaseResponse {

	List<DetailListModel> list;
	
	int batch_count;
	
	int total_count;

	public List<DetailListModel> getList() {
		return list;
	}

	public void setList(List<DetailListModel> list) {
		this.list = list;
	}

	public int getBatch_count() {
		return batch_count;
	}

	public void setBatch_count(int batch_count) {
		this.batch_count = batch_count;
	}

	public int getTotal_count() {
		return total_count;
	}

	public void setTotal_count(int total_count) {
		this.total_count = total_count;
	}
	
	
}
