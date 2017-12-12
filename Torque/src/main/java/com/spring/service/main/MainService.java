package com.spring.service.main;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.main.IMainMapper;
import com.spring.model.BaseResponse;
import com.spring.model.main.MainDisconnectedTool;
import com.spring.model.main.MainRepairConn;
import com.spring.model.main.MainThighteningResult;
import com.spring.model.main.MainToolStatus;
import com.spring.model.main.ResponseDisToolList;
import com.spring.model.main.ResponseRepairStatus;

@Service
public class MainService implements IMainService {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public BaseResponse getDisconnectedToolList(){
		IMainMapper mapper = sqlSession.getMapper(IMainMapper.class);
		
		List<MainDisconnectedTool> list = mapper.selectDisconnectedToolList();
		
		MainToolStatus tool_status = mapper.selectToolConnectionStatus();
		
		ResponseDisToolList response = new ResponseDisToolList();
		response.setList(list);
		
		response.setStatuslist(tool_status);
		
		return response;
	}
	
	public BaseResponse getRepairToolConnStatus(){
		IMainMapper mapper = sqlSession.getMapper(IMainMapper.class);
		
		List<MainRepairConn> list = mapper.selectRepairToolConnStatus();
		
		ResponseRepairStatus response = new ResponseRepairStatus();
		response.setList(list);
		
		return response;
	}
	
	public List<MainThighteningResult> getThighteningResult(){
		
		IMainMapper mapper = sqlSession.getMapper(IMainMapper.class);
		
		return  mapper.selectThighteningResult();
	}
}
