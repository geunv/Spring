package com.spring.service.menu;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.spring.model.menu.MainMenu;

public interface IMenuService {

	public List<MainMenu> getMainMenu(HttpSession session);
}
