package com.spring.model.setting;

public class ToolInfoModel {
	
	String plant_cd; 			
	String device_id;			
	String device_serial;
	String stn_gub;				
	String device_grp_cd;		
	String line_cd;				
	String device_nm;			
	String device_alias;		
	String device_type;			
	String serial_parallel_flg;	
	String device_ip;			
	String device_port;			
	String completed_device_flg;
	String jobno_send_flg;		
	String torque_low;			
	String angle_low;			
	String torque_ok;			
	String angle_ok;			
	String torque_high;			
	String angle_high;			
	String web_display_flg;		
	String scan_jobreset_flg;	
	String show_value_type;
	String reg_user_id;
	
	
	public String getReg_user_id() {
		return reg_user_id;
	}
	public void setReg_user_id(String reg_user_id) {
		this.reg_user_id = reg_user_id;
	}
	public String getPlant_cd() {
		return plant_cd;
	}
	public void setPlant_cd(String plant_cd) {
		this.plant_cd = plant_cd;
	}
	public String getDevice_id() {
		return device_id;
	}
	public void setDevice_id(String device_id) {
		this.device_id = device_id;
	}
	public String getDevice_serial() {
		return device_serial;
	}
	public void setDevice_serial(String device_serial) {
		this.device_serial = device_serial;
	}
	public String getStn_gub() {
		return stn_gub;
	}
	public void setStn_gub(String stn_gub) {
		this.stn_gub = stn_gub;
	}
	public String getDevice_grp_cd() {
		return device_grp_cd;
	}
	
	public void setDevice_grp_cd(String device_grp_cd) {
		if ( device_grp_cd.length() == 0 )
			this.device_grp_cd = " ";
		else
			this.device_grp_cd = device_grp_cd.trim();
	}
	public String getLine_cd() {
		return line_cd;
	}
	
	public void setLine_cd(String line_cd) {
		if (line_cd.trim().length() == 0)
			this.line_cd = " ";
		else
			this.line_cd = line_cd.trim();
	}
	
	public String getDevice_nm() {
		return device_nm;
	}
	public void setDevice_nm(String device_nm) {
		if ( device_nm.trim().length() == 0 )
			this.device_nm = " ";
		else
			this.device_nm = device_nm.trim();
	}
	public String getDevice_alias() {
		return device_alias;
	}
	public void setDevice_alias(String device_alias) {
		if ( device_alias.trim().length() == 0)
			this.device_alias = " ";
		else
			this.device_alias = device_alias.trim();
	}
	public String getDevice_type() {
		return device_type;
	}
	public void setDevice_type(String device_type) {
		if ( device_type.trim().length() == 0 )
			this.device_type = " ";
		else
			this.device_type = device_type.trim();
	}
	
	public String getSerial_parallel_flg() {
		return serial_parallel_flg;
	}
	public void setSerial_parallel_flg(String serial_parallel_flg) {
		if ( serial_parallel_flg.trim().length() == 0)
			this.serial_parallel_flg = " ";
		else
			this.serial_parallel_flg = serial_parallel_flg.trim();
	}
	
	public String getDevice_ip() {
		return device_ip;
	}
	public void setDevice_ip(String device_ip) {
		if ( device_ip.trim().length() == 0 )
			this.device_ip = " ";
		else
			this.device_ip = device_ip.trim();
	}
	
	public String getDevice_port() {
		return device_port;
	}
	public void setDevice_port(String device_port) {
		if ( device_port.trim().length() == 0 )
			this.device_port ="0";
		else
			this.device_port = device_port.trim();
	}
	public String getCompleted_device_flg() {
		return completed_device_flg;
	}
	public void setCompleted_device_flg(String completed_device_flg) {
		if ( completed_device_flg.trim().length() == 0 )
			this.completed_device_flg = " ";
		else
			this.completed_device_flg = completed_device_flg.trim();
	}
	public String getJobno_send_flg() {
		return jobno_send_flg;
	}
	public void setJobno_send_flg(String jobno_send_flg) {
		if ( jobno_send_flg.trim().length() == 0)
			this.jobno_send_flg = " ";
		else
			this.jobno_send_flg = jobno_send_flg.trim();
	}
	
	public String getTorque_low() {
		return torque_low;
	}
	public void setTorque_low(String torque_low) {
		if ( torque_low.trim().length() == 0 )
			this.torque_low = "0";
		else
			this.torque_low = torque_low.trim();
	}
	
	public String getAngle_low() {
		return angle_low;
	}
	public void setAngle_low(String angle_low) {
		if ( angle_low.trim().length() == 0 )
			this.angle_low  = "0";
		else
			this.angle_low = angle_low.trim();
	}
	
	public String getTorque_ok() {
		return torque_ok;
	}
	public void setTorque_ok(String torque_ok) {
		if ( torque_ok.trim().length() == 0 )
			this.torque_ok = "0";
		else
			this.torque_ok = torque_ok.trim();
	}
	
	public String getAngle_ok() {
		return angle_ok;
	}
	public void setAngle_ok(String angle_ok) {
		if ( angle_ok.trim().length() == 0 )
			this.angle_ok = "0";
		else
			this.angle_ok = angle_ok.trim();
	}
	
	public String getTorque_high() {
		return torque_high;
	}
	public void setTorque_high(String torque_high) {
		if ( torque_high.trim().length() == 0 )
			this.torque_high = "0";
		else
			this.torque_high = torque_high.trim();
	}
	
	public String getAngle_high() {
		return angle_high;
	}
	public void setAngle_high(String angle_high) {
		if ( angle_high.trim().length() == 0 )
			this.angle_high = "0";
		else
			this.angle_high = angle_high.trim();
	}
	
	public String getWeb_display_flg() {
		return web_display_flg;
	}
	public void setWeb_display_flg(String web_display_flg) {
		if ( web_display_flg.trim().length() == 0)
			this.web_display_flg = " ";
		else 
			this.web_display_flg = web_display_flg.trim();
	}
	
	public String getScan_jobreset_flg() {
		return scan_jobreset_flg;
	}
	public void setScan_jobreset_flg(String scan_jobreset_flg) {
		if ( scan_jobreset_flg.trim().length() == 0)
			this.scan_jobreset_flg = " ";
		else
			this.scan_jobreset_flg = scan_jobreset_flg.trim();
	}
	
	public String getShow_value_type() {
		return show_value_type;
	}
	public void setShow_value_type(String show_value_type) {
		if ( show_value_type.trim().length() == 0 )
			this.show_value_type = " ";
		else
			this.show_value_type = show_value_type.trim();
	}		

	
}
