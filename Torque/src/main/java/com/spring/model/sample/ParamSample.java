package com.spring.model.sample;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description="샘플 파라미터 모델")
public class ParamSample {
	
	@ApiModelProperty(hidden=true, required = false, position=1)
	int num;
	
	@ApiModelProperty(value="제목", required = true, position=2)
	String title;
	
	@ApiModelProperty(value="내용", required = true, position=3)
	String content;


	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
	
	

}
