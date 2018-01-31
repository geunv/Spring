package com.spring.model.result;

public class LineStopHistoryModel {
	int rnum;
	String device;
	String interlock_dt;
	String interlock_seq;
	String interlock_flg;
	String body_no;
	String interlock_reason; 
	String regdt;
	String reg_user_id;
	
	public int getRnum() {
		return rnum;
	}
	public void setRnum(int rnum) {
		this.rnum = rnum;
	}
	public String getDevice() {
		return device;
	}
	public void setDevice(String device) {
		this.device = device;
	}
	public String getInterlock_dt() {
		return interlock_dt;
	}
	public void setInterlock_dt(String interlock_dt) {
		this.interlock_dt = interlock_dt;
	}
	public String getInterlock_seq() {
		return interlock_seq;
	}
	public void setInterlock_seq(String interlock_seq) {
		this.interlock_seq = interlock_seq;
	}
	public String getInterlock_flg() {
		return interlock_flg;
	}
	public void setInterlock_flg(String interlock_flg) {
		this.interlock_flg = interlock_flg;
	}
	public String getBody_no() {
		return body_no;
	}
	public void setBody_no(String body_no) {
		this.body_no = body_no;
	}
	public String getInterlock_reason() {
		return interlock_reason;
	}
	public void setInterlock_reason(String interlock_reason) {
		this.interlock_reason = interlock_reason;
	}
	public String getRegdt() {
		return regdt;
	}
	public void setRegdt(String regdt) {
		this.regdt = regdt;
	}
	public String getReg_user_id() {
		return reg_user_id;
	}
	public void setReg_user_id(String reg_user_id) {
		this.reg_user_id = reg_user_id;
	} 
	
	
}
