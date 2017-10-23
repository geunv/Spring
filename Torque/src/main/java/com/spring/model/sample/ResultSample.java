package com.spring.model.sample;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(description="샘플 결과 모델")
public class ResultSample {

	@ApiModelProperty(value="순번", required = true, position=1)
	int num;
	
	@ApiModelProperty(value="제목", required = true, position=2)
	String title;
	
	@ApiModelProperty(value="내용", required = true, position=3)
	String content;
	
	@ApiModelProperty(value="날짜", required = true, position=4)
	String insert_dt;

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

	public String getInsert_dt() {
		return insert_dt;
	}

	public void setInsert_dt(String insert_dt) {
		this.insert_dt = insert_dt;
	}

	
}
