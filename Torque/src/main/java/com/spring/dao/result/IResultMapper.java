package com.spring.dao.result;

import java.util.HashMap;
import java.util.List;

import com.spring.model.result.CycleTestResultListModel;
import com.spring.model.result.DetailListModel;
import com.spring.model.result.DetailListSubModel;
import com.spring.model.result.LineStopHistoryModel;
import com.spring.model.result.ResultByDateListModel;
import com.spring.model.result.ResultHistoryListModel;
import com.spring.model.result.SummaryListModel;

public interface IResultMapper {
	
	public List<SummaryListModel> selectResultSummaryList(HashMap<String,Object> map);
	public int selectResultSummaryCount(HashMap<String,Object> map);
	
	
	public List<DetailListModel> selectResultDetailList(HashMap<String, Object> map);
	public int selectResultDetailListCount(HashMap<String,Object> map);
	public int selectResultDetailListBatchCount(HashMap<String,Object> map);
	public DetailListSubModel selectResultDetailSubList(HashMap<String,Object> map2);
	
	public List<ResultHistoryListModel> selectResultHistoryList(HashMap<String,Object> map);
	
	public List<ResultByDateListModel> selectResultByDate(HashMap<String, Object> map);
	public int selectResultByDateCount(HashMap<String, Object> map);
	
	public List<CycleTestResultListModel> selectCycleTestResult(HashMap<String, Object> map);
	public int selectCycleTestResultCount(HashMap<String, Object> map);
	
	public List<LineStopHistoryModel> selectInterlockHistory(HashMap<String, Object> map);
	public int selectInterlockHistoryCount(HashMap<String, Object> map);
}
