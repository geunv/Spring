$(document).ready(function(){
	$.get('/api/main-menu', function(data){
		//console.log(data.list);
		var $menu;
		
		data.list.forEach(function(data, index){
			
			//console.log(data);
			
			if(data.second_order == 0){
				$menu = $('<li class="dropdown"> ' +
						  	'<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">'
								+ data.name +
							'<span class="caret"></span></a>' +
						'</li>');
				
				$('#myMenu').append($menu);
				
			}else{
				
				/*if(data.second_order == 1 ){
					$menu.append('<ul class="dropdown-menu" role="menu"></ul>');
				}
				
				var sub_menu = $('<li><a href="' + data.menu_link + '">' + data.name + '</a></li>');
				$menu.find('ul').append(sub_menu);*/
	
				if(data.second_order == 1 ){
					$menu.append('<ul class="dropdown-menu dropdown-submenu2" role="menu"></ul>');
				}
				
				var sub_menu = $('<li><a href="' + data.menu_link + '"><span class="font-red"><i class="fa fa-caret-right"></i>&nbsp;' + data.name + '</span></a></li><li class="divider"></li>');
				$menu.find('ul').append(sub_menu);
				
			}
			
			
		});
		
	});
});