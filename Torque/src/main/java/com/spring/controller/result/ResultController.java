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
	
	@RequestMapping(value="/view/result/summary")
	public ModelAndView resultSummaryView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/summary");
		return mv;
	}
	
//	"plant_cd="+vplant_cd.trim()+
//	"&work_dt="+vwork_dt.trim()+
//	"&line="+vline.trim() +
//	"&shift="+vshift.trim() +
//	"&tool="+vtool.trim() +
//	"&page="+now_page+
//	"&show_count="+show_count;
	
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
	
	
	@RequestMapping(value="/view/result/detail")
	public ModelAndView resultDetailView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/result/detail");
		return mv;
	}
}
