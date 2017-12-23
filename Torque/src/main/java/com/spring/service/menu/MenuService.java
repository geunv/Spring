package com.spring.service.menu;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.dao.IMenuMapper;
import com.spring.model.menu.MainMenu;
import com.spring.model.menu.ParamMenu;

@Service
public class MenuService implements IMenuService {

	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List<MainMenu> getMainMenu(HttpSession session){
		IMenuMapper mapper = sqlSession.getMapper(IMenuMapper.class);
		
		ParamMenu param = new ParamMenu();
		
		param.setGrade(session.getAttribute("USER_GRADE").toString());
		param.setLang(session.getAttribute("LANG").toString());
		
		return mapper.getMainMenu(param);
	}
}
