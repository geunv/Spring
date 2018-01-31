package com.spring.controller.chart;

import static org.springframework.web.bind.annotation.RequestMethod.GET;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.spring.model.BaseResponse;
import com.spring.service.chart.IChartService;

@RestController
public class ChartController {

	@Autowired
	IChartService charService;
	
	@RequestMapping(value="/view/chart/linechart")
	public ModelAndView resultSummaryView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/chart/linechart");
		return mv;
	}
	
	@RequestMapping(value="/api/chart/getchartline", method=GET)
	public BaseResponse getChartLine(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false) String from_dt,
			@RequestParam(value="to_dt", required=false) String to_dt,
			@RequestParam(value="display_type", required=false) String display_type,
			@RequestParam(value="tool", required=false) String tool,
			@RequestParam(value="old_data", required=false) String old_data
			){
		return charService.getChartLine(plant_cd,from_dt,to_dt,display_type,tool,old_data);
	}

	/******************************************/
	@RequestMapping(value="/view/chart/faultychart")
	public ModelAndView faultychartView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/chart/faultychart");
		return mv;
	}
	
	
	@RequestMapping(value="/api/chart/getchartfaulty", method=GET)
	public BaseResponse getChartFaulty(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false) String from_dt,
			@RequestParam(value="to_dt", required=false) String to_dt,
			@RequestParam(value="display_type", required=false) String display_type,
			@RequestParam(value="tool", required=false) String tool,
			@RequestParam(value="old_data", required=false) String old_data
			){
		return charService.getChartFaulty(plant_cd,from_dt,to_dt,display_type,tool,old_data);
	}
	
	
	/******************************************/
	@RequestMapping(value="/view/chart/xbarchart")
	public ModelAndView xbarchartView(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/chart/xbarchart");
		return mv;
	}
	
	@RequestMapping(value="/api/chart/getchartxbarr", method=GET)
	public BaseResponse getChartXbarR(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false) String from_dt,
			@RequestParam(value="to_dt", required=false) String to_dt,
			@RequestParam(value="tool", required=false) String tool,
			@RequestParam(value="grp_size", required=false,defaultValue="5") String grp_size,
			@RequestParam(value="data_gbn", required=false,defaultValue="T") String data_gbn,
			@RequestParam(value="old_data", required=false) String old_data
			){
		return charService.getChartXbarR(plant_cd,from_dt,to_dt,tool,grp_size,data_gbn,old_data);
	}
	
	/******************************************/
	@RequestMapping(value="/view/chart/linechart2")
	public ModelAndView linechart2View(HttpServletRequest request){
		ModelAndView mv = new ModelAndView("/chart/linechart2");
		return mv;
	}
	
	@RequestMapping(value="/api/chart/getchartline2", method=GET)
	public BaseResponse getChartLine2(
			@RequestParam(value="plant_cd", required=false, defaultValue="1") String plant_cd,
			@RequestParam(value="from_dt", required=false) String from_dt,
			@RequestParam(value="to_dt", required=false) String to_dt,
			@RequestParam(value="display_type", required=false) String display_type,
			@RequestParam(value="tool", required=false) String tool,
			@RequestParam(value="old_data", required=false) String old_data
			){
		
		System.out.println("plant_cd=>" + plant_cd);
		System.out.println("from_dt=>" + from_dt);
		System.out.println("to_dt=>" + to_dt);
		System.out.println("display_type=>" + display_type);
		System.out.println("tool=>" + tool);
		System.out.println("old_data=>" + old_data);
		
		return charService.getChartLine(plant_cd,from_dt,to_dt,display_type,tool,old_data);
		//return new BaseResponse();
	}
}
