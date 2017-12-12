package com.spring.dao.main;

import java.util.List;

import com.spring.model.main.MainDisconnectedTool;
import com.spring.model.main.MainRepairConn;
import com.spring.model.main.MainThighteningResult;
import com.spring.model.main.MainToolStatus;

public interface IMainMapper {
	
	public List<MainDisconnectedTool> selectDisconnectedToolList();
	
	public MainToolStatus selectToolConnectionStatus();
	
	public List<MainRepairConn> selectRepairToolConnStatus();
	
	public List<MainThighteningResult> selectThighteningResult();
}
