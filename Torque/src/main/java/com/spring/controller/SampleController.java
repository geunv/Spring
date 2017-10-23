package com.spring.controller;

import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;
import static org.springframework.web.bind.annotation.RequestMethod.PUT;
import static org.springframework.web.bind.annotation.RequestMethod.DELETE;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.model.sample.ParamSample;
import com.spring.model.sample.ResultSample;
import com.spring.service.ISampleService;

import io.swagger.annotations.ApiOperation;

@RequestMapping(value="/api")
@RestController
public class SampleController {
	
	@Autowired
	ISampleService sampleService;
	

	@ApiOperation(value = "샘플", notes = "샘플 테스트")
	@RequestMapping(value="/sample", method=GET)
	public String sample(
			@RequestParam(value="who", required=false, defaultValue = "everyone") String whois){		
		return "hello " + whois;
	}
	
	
	@ApiOperation(value="쓰기", notes = "crud 중 c에 해당")
	@RequestMapping(value="/sample_insert", method=POST)
	public ParamSample insert(
			@RequestBody ParamSample paramSample
			){
		
		ParamSample resultSample = sampleService.insertSample(paramSample);
		return resultSample;
	}
	
	
	@ApiOperation(value="읽기", notes = "crud 중 r에 해당")
	@RequestMapping(value="/sample_read", method=GET)
	public ResultSample read(
			@RequestParam(value="num", required=false, defaultValue = "1") int num
			){
		return sampleService.getSample(num);
	}
	
	
	@ApiOperation(value="수정", notes = "crud 중 u에 해당")
	@RequestMapping(value="/sample_update", method=PUT)
	public String update(
			@RequestParam(value="num", required=true, defaultValue = "1") int num,
			@RequestBody ParamSample paramSample
			){
		
		paramSample.setNum(num);
		sampleService.updateSample(paramSample);
		return "OK";
	}
	
	@ApiOperation(value="삭제", notes = "crud 중 d에 해당")
	@RequestMapping(value="/sample_delete", method=DELETE)
	public String delete(
			@RequestParam(value="num", required=true, defaultValue = "1") int num
			){
		sampleService.deleteSample(num);
		return "OK";
	}
	
}
