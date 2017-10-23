package com.spring.service;

import com.spring.model.sample.ParamSample;
import com.spring.model.sample.ResultSample;

public interface ISampleService {
	
	public ResultSample getSample(int num);
	
	public ParamSample insertSample(ParamSample paramSample);
	
	public void updateSample(ParamSample paramSample);
	
	public void deleteSample(int num);
}
