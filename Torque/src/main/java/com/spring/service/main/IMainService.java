package com.spring.service.main;

import java.util.List;

import com.spring.model.BaseResponse;
import com.spring.model.main.MainThighteningResult;

public interface IMainService {
	public BaseResponse getDisconnectedToolList();
	
	public BaseResponse getRepairToolConnStatus();
	
	public List<MainThighteningResult> getThighteningResult();
}
