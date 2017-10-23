package com.spring.dao;

import com.spring.model.sample.ParamSample;
import com.spring.model.sample.ResultSample;

public interface ISampleMapper {
	
	public ResultSample getSample(int num);
	
	public void insertSample(ParamSample paramSample);

	public void updateSample(ParamSample paramSample);
	
	public void deleteSample(int num);
	
}
