package com.spring.dao.result;

import java.util.HashMap;
import java.util.List;

import com.spring.model.result.SummaryListModel;

public interface IResultMapper {
	
	public List<SummaryListModel> selectResultSummaryList(HashMap<String,Object> map);
	
	public int selectResultSummaryCount(HashMap<String,Object> map);
}
