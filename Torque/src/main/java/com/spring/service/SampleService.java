package com.spring.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.ISampleMapper;
import com.spring.model.sample.ParamSample;
import com.spring.model.sample.ResultSample;

@Service
public class SampleService implements ISampleService{

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public ResultSample getSample(int num) {
		ISampleMapper mapper  = sqlSession.getMapper(ISampleMapper.class);
		return mapper.getSample(num);
	}
	
	public ParamSample insertSample(ParamSample paramSample){
		ISampleMapper mapper  = sqlSession.getMapper(ISampleMapper.class);
		mapper.insertSample(paramSample);
		return paramSample;
	}
	
	public void updateSample(ParamSample paramSample){
		ISampleMapper mapper  = sqlSession.getMapper(ISampleMapper.class);
		mapper.updateSample(paramSample);
	}

	public void deleteSample(int num) {
		ISampleMapper mapper  = sqlSession.getMapper(ISampleMapper.class);
		mapper.deleteSample(num);
	}

}
