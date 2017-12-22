package com.spring.dao.result;

import java.util.HashMap;
import java.util.List;

import com.spring.model.result.DetailListModel;
import com.spring.model.result.DetailListSubModel;
import com.spring.model.result.SummaryListModel;

public interface IResultMapper {
	
	public List<SummaryListModel> selectResultSummaryList(HashMap<String,Object> map);
	
	public int selectResultSummaryCount(HashMap<String,Object> map);
	
	public List<DetailListModel> selectResultDetailList(HashMap<String, Object> map);
	
	public int selectResultDetailListCount(HashMap<String,Object> map);
	
	public int selectResultDetailListBatchCount(HashMap<String,Object> map);
	
	public DetailListSubModel selectResultDetailSubList(HashMap<String,Object> map2);
}
