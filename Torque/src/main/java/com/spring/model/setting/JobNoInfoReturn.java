package com.spring.model.setting;

import java.util.List;

import com.spring.model.BaseResponse;

public class JobNoInfoReturn extends BaseResponse{

	List<JobNoInfo> infolist;
	
	List<JobNoConditionTempModel> condlist;

	String cond_expr;
	
	public List<JobNoInfo> getInfolist() {
		return infolist;
	}

	public void setInfolist(List<JobNoInfo> infolist) {
		this.infolist = infolist;
	}

	public List<JobNoConditionTempModel> getCondlist() {
		return condlist;
	}

	public void setCondlist(List<JobNoConditionTempModel> condlist) {
		this.condlist = condlist;
	}

	public String getCond_expr() {
		return cond_expr;
	}

	public void setCond_expr(String cond_expr) {
		this.cond_expr = cond_expr;
	}
	
	
}
