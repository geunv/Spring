package com.spring.model.system;

public class ProgramProcessParamModel {
	String plant_cd; 				
	String pgm_id;					
	String proc_id;					
	String pgm_nm;					
	String proc_nm;					
	String stn_gub;					
	String tool;
	String device_id;
	String device_serial;
	int reconnect_waiting_sec;	
	
	String interlock_use_flg;		
	int interlock_ng_point;		
	int interlock_ng_cnt;		
	int interlock_noscan_point;	
	int interlock_noscan_cnt;	
	
	String interlock_plc_type;		
	String interlock_plc_ip;		
	int interlock_plc_port;		
	String interlock_plc_start_add; 

	String trk_plc_type; 			
	int trk_plc_ip;				
	int trk_plc_port;			
	int trk_plc_start_add;		

	String logical_trk_flg;			
	String mes_stn_cd;				
	int trk_point;			

	int ng_trk_alarm_point;
	int trk_stn_cnt; 			
	String trk_stn_nm;
	
	String ng_mes_stn_cd;			
	int ng_trk_point;			
	int ng_trk_view_cnt;			
	String scanning_use_flg;
	String cycle_test_time;
	
	String reg_user_id;

	public String getPlant_cd() {
		return plant_cd;
	}

	public void setPlant_cd(String plant_cd) {
		this.plant_cd = plant_cd;
	}

	public String getPgm_id() {
		return pgm_id;
	}

	public void setPgm_id(String pgm_id) {
		this.pgm_id = pgm_id;
	}

	public String getProc_id() {
		return proc_id;
	}

	public void setProc_id(String proc_id) {
		this.proc_id = proc_id;
	}

	public String getPgm_nm() {
		return pgm_nm;
	}

	public void setPgm_nm(String pgm_nm) {
		this.pgm_nm = pgm_nm;
	}

	public String getProc_nm() {
		return proc_nm;
	}

	public void setProc_nm(String proc_nm) {
		this.proc_nm = proc_nm;
	}

	public String getStn_gub() {
		return stn_gub;
	}

	public void setStn_gub(String stn_gub) {
		this.stn_gub = stn_gub;
	}

	public String getTool() {
		return tool;
	}

	public void setTool(String tool) {
		this.tool = tool;
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

	public int getReconnect_waiting_sec() {
		return reconnect_waiting_sec;
	}

	public void setReconnect_waiting_sec(int reconnect_waiting_sec) {
		this.reconnect_waiting_sec = reconnect_waiting_sec;
	}

	public String getInterlock_use_flg() {
		return interlock_use_flg;
	}

	public void setInterlock_use_flg(String interlock_use_flg) {
		if ( interlock_use_flg.length() == 0 || interlock_use_flg.equals("-1") )
			this.interlock_use_flg = " ";
		else
			this.interlock_use_flg = interlock_use_flg.trim();
	}

	public int getInterlock_ng_point() {
		return interlock_ng_point;
	}

	public void setInterlock_ng_point(int interlock_ng_point) {
		if ( interlock_ng_point == -1 )
			this.interlock_ng_point = 0;
		else
			this.interlock_ng_point = interlock_ng_point;
	}

	public int getInterlock_ng_cnt() {
		return interlock_ng_cnt;
	}

	public void setInterlock_ng_cnt(int interlock_ng_cnt) {
		this.interlock_ng_cnt = interlock_ng_cnt;
	}

	public int getInterlock_noscan_point() {
		return interlock_noscan_point;
	}

	public void setInterlock_noscan_point(int interlock_noscan_point) {
		this.interlock_noscan_point = interlock_noscan_point;
	}

	public int getInterlock_noscan_cnt() {
		return interlock_noscan_cnt;
	}

	public void setInterlock_noscan_cnt(int interlock_noscan_cnt) {
		this.interlock_noscan_cnt = interlock_noscan_cnt;
	}

	public String getInterlock_plc_type() {
		return interlock_plc_type;
	}

	public void setInterlock_plc_type(String interlock_plc_type) {
		this.interlock_plc_type = interlock_plc_type;
	}

	public String getInterlock_plc_ip() {
		return interlock_plc_ip;
	}

	public void setInterlock_plc_ip(String interlock_plc_ip) {
		if( interlock_plc_ip.length() == 0 || interlock_plc_ip.equals("-1"))
			this.interlock_plc_ip = "0";
		else
			this.interlock_plc_ip = interlock_plc_ip;
	}

	public int getInterlock_plc_port() {
		return interlock_plc_port;
	}

	public void setInterlock_plc_port(int interlock_plc_port) {
		this.interlock_plc_port = interlock_plc_port;
	}

	public String getInterlock_plc_start_add() {
		return interlock_plc_start_add;
	}

	public void setInterlock_plc_start_add(String interlock_plc_start_add) {
		if ( interlock_plc_start_add.trim().length() == 0 || interlock_plc_start_add.trim().equals("-1"))
			this.interlock_plc_start_add = "0";
		else
			this.interlock_plc_start_add = interlock_plc_start_add;
	}

	public String getTrk_plc_type() {
		return trk_plc_type;
	}

	public void setTrk_plc_type(String trk_plc_type) {
		this.trk_plc_type = trk_plc_type;
	}

	public int getTrk_plc_ip() {
		return trk_plc_ip;
	}

	public void setTrk_plc_ip(int trk_plc_ip) {
		this.trk_plc_ip = trk_plc_ip;
	}

	public int getTrk_plc_port() {
		return trk_plc_port;
	}

	public void setTrk_plc_port(int trk_plc_port) {
		this.trk_plc_port = trk_plc_port;
	}

	public int getTrk_plc_start_add() {
		return trk_plc_start_add;
	}

	public void setTrk_plc_start_add(int trk_plc_start_add) {
		this.trk_plc_start_add = trk_plc_start_add;
	}

	public String getLogical_trk_flg() {
		return logical_trk_flg;
	}

	public void setLogical_trk_flg(String logical_trk_flg) {
		if( logical_trk_flg.trim().length() == 0 || logical_trk_flg.trim().equals("-1"))
			this.logical_trk_flg = "0";
		else
			this.logical_trk_flg = logical_trk_flg;
	}

	public String getMes_stn_cd() {
		return mes_stn_cd;
	}

	public void setMes_stn_cd(String mes_stn_cd) {
		this.mes_stn_cd = mes_stn_cd;
	}

	public int getTrk_point() {
		return trk_point;
	}

	public void setTrk_point(int trk_point) {
		this.trk_point = trk_point;
	}

	public int getNg_trk_alarm_point() {
		return ng_trk_alarm_point;
	}

	public void setNg_trk_alarm_point(int ng_trk_alarm_point) {
		this.ng_trk_alarm_point = ng_trk_alarm_point;
	}

	public int getTrk_stn_cnt() {
		return trk_stn_cnt;
	}

	public void setTrk_stn_cnt(int trk_stn_cnt) {
		this.trk_stn_cnt = trk_stn_cnt;
	}

	public String getTrk_stn_nm() {
		return trk_stn_nm;
	}

	public void setTrk_stn_nm(String trk_stn_nm) {
		this.trk_stn_nm = trk_stn_nm;
	}

	public String getNg_mes_stn_cd() {
		return ng_mes_stn_cd;
	}

	public void setNg_mes_stn_cd(String ng_mes_stn_cd) {
		this.ng_mes_stn_cd = ng_mes_stn_cd;
	}

	public int getNg_trk_point() {
		return ng_trk_point;
	}

	public void setNg_trk_point(int ng_trk_point) {
		this.ng_trk_point = ng_trk_point;
	}

	public int getNg_trk_view_cnt() {
		return ng_trk_view_cnt;
	}

	public void setNg_trk_view_cnt(int ng_trk_view_cnt) {
		this.ng_trk_view_cnt = ng_trk_view_cnt;
	}

	public String getScanning_use_flg() {
		return scanning_use_flg;
	}

	public void setScanning_use_flg(String scanning_use_flg) {
		if (scanning_use_flg.trim() == "" || scanning_use_flg.equals("-1"))
			this.scanning_use_flg = " ";
		else
			this.scanning_use_flg = scanning_use_flg;
	}

	public String getCycle_test_time() {
		return cycle_test_time;
	}

	public void setCycle_test_time(String cycle_test_time) {
		this.cycle_test_time = cycle_test_time;
	}

	public String getReg_user_id() {
		return reg_user_id;
	}

	public void setReg_user_id(String reg_user_id) {
		this.reg_user_id = reg_user_id;
	}
	
	
}
