package com.spring.controller.result;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.spring.model.BaseResponse;
import com.spring.service.result.IResultService;

@RestController
public class ResultController {

	@Autowired
	IResultService resultService;
	
	/***************************************************/
	@RequestMapping(value="/view/result/summary")
	public ModelAndView resultSummaryView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/summary");
		return mv;
	}
	
	@RequestMapping(value="/api/result/getresultsummary", method=GET)
	public BaseResponse getResultSummary(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="10") int show_count,
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="work_dt", required=false) String work_dt,
			@RequestParam(value="line", required=false) String line_cd,
			@RequestParam(value="shift", required=false) String shift,
			@RequestParam(value="tool", required=false) String tool,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			
			){
		return resultService.getResultSummary(page, show_count, plant_cd, work_dt, line_cd, shift, tool, excel_down);
	}
	
	/***************************************************/
	@RequestMapping(value="/view/result/detail")
	public ModelAndView resultDetailView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/detail");
		return mv;
	}
	
	@RequestMapping(value="/api/result/getresultdetail", method=GET)
	public BaseResponse getResultDetail(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false) String from_dt,
			@RequestParam(value="to_dt", required=false) String to_dt,
			@RequestParam(value="shift", required=false, defaultValue="-1") String shift,
			@RequestParam(value="tool", required=false, defaultValue="-1") String tool,
			@RequestParam(value="tightening_result", required=false, defaultValue="-1") String tightening_result,
			@RequestParam(value="seq", required=false, defaultValue=" ") String seq,
			@RequestParam(value="car_type", required=false, defaultValue=" ") String car_type,
			@RequestParam(value="body_no", required=false, defaultValue=" ") String body_no,
			@RequestParam(value="old_data", required=false, defaultValue="N") String old_data,
			@RequestParam(value="all_batch", required=false, defaultValue="Y") String all_batch,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			
			){
		return resultService.getResultDetail(page, show_count, plant_cd, from_dt,to_dt, shift, tool, tightening_result,seq,car_type,body_no,old_data,all_batch, excel_down);
	}
	
	/***************************************************/
	@RequestMapping(value="/view/result/resulthistory")
	public ModelAndView resultHistoryView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/resulthistory");
		return mv;
	}
	
	@RequestMapping(value="/api/result/getresulthistory", method=GET)
	public BaseResponse getResultHistory(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false, defaultValue="2017-12-01") String from_dt,
			@RequestParam(value="to_dt", required=false, defaultValue="2017-12-26") String to_dt,
			@RequestParam(value="tool", required=false, defaultValue="-1") String tool,
			@RequestParam(value="tightening_result", required=false, defaultValue="-1") String tightening_result,
			@RequestParam(value="seq", required=false, defaultValue=" " ) String seq,
			@RequestParam(value="car_type", required=false, defaultValue=" " ) String car_type,
			@RequestParam(value="body_no", required=false, defaultValue=" ") String body_no,
			@RequestParam(value="old_data", required=false, defaultValue="N") String old_data,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			
			){
		return resultService.getResultHistory(page, show_count, plant_cd, from_dt,to_dt,  tool, tightening_result,seq,car_type,body_no,old_data, excel_down);
	}
	
	
	/***************************************************/
	@RequestMapping(value="/view/result/resultbydate")
	public ModelAndView resultByDateView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/resultbydate");
		return mv;
	}
	
	
	@RequestMapping(value="/api/result/getresultbydate", method=GET)
	public BaseResponse getResultByDate(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false, defaultValue="2017-12-01") String from_dt,
			@RequestParam(value="to_dt", required=false, defaultValue="2017-12-26") String to_dt,
			@RequestParam(value="tool", required=false, defaultValue="-1") String tool,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			
			){
		return resultService.getResultByDate(page, show_count, plant_cd, from_dt,to_dt,  tool, excel_down);
	}
	
	/***************************************************/
	@RequestMapping(value="/view/result/cycletestresult")
	public ModelAndView CycleTestResultView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/cycletestresult");
		return mv;
	}
	
			 
	@RequestMapping(value="/api/result/getcycletestresult", method=GET)
	public BaseResponse getCycleTestResult(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="work_dt", required=false, defaultValue="2017-12-01") String work_dt,
			@RequestParam(value="hh", required=false, defaultValue="-1") String hh,
			@RequestParam(value="pgm_id", required=false, defaultValue="-1") String pgm_id,
			@RequestParam(value="proc_id", required=false, defaultValue="-1") String proc_id,
			@RequestParam(value="car_type", required=false, defaultValue="-1") String car_type,
			@RequestParam(value="tool", required=false, defaultValue="-1") String tool,
			@RequestParam(value="txt_car_type", required=false, defaultValue="") String txt_car_type,
			@RequestParam(value="txt_body_no", required=false, defaultValue="") String txt_body_no,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			
			){
		return resultService.getCycleTestResult(page, show_count, plant_cd, work_dt,hh,pgm_id,proc_id,car_type,  tool,txt_car_type,txt_body_no, excel_down);
	}
	
	/***************************************************/
	@RequestMapping(value="/view/result/linestophistory")
	public ModelAndView LineStopHistoryView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/linestophistory");
		return mv;
	}
	
	
	@RequestMapping(value="/api/result/getlinestophistory", method=GET)
	public BaseResponse getLineStopHistory(
			@RequestParam(value="page", required=false, defaultValue="1") int page,
			@RequestParam(value="show_count", required=false, defaultValue="20") int show_count,
			@RequestParam(value="plant_cd", required=true, defaultValue="1") String plant_cd,
			@RequestParam(value="work_dt", required=false, defaultValue="2017-12-01") String work_dt,
			@RequestParam(value="interlock_type", required=false, defaultValue="-1") String interlock_type,
			@RequestParam(value="tool", required=false, defaultValue="-1") String tool,
			@RequestParam(value="txt_car_type", required=false, defaultValue="") String txt_car_type,
			@RequestParam(value="txt_body_no", required=false, defaultValue="") String txt_body_no,
			@RequestParam(value="excel_down", required=false, defaultValue="N") String excel_down
			
			){
		return resultService.getLineStopHistory(page, show_count, plant_cd, work_dt,interlock_type, tool,txt_car_type,txt_body_no, excel_down);
	}
}
