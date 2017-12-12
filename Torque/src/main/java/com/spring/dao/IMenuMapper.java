package com.spring.dao;

import java.util.List;

import com.spring.model.menu.MainMenu;
import com.spring.model.menu.ParamMenu;

public interface IMenuMapper {
	
	public List<MainMenu> getMainMenu(ParamMenu param);
}
