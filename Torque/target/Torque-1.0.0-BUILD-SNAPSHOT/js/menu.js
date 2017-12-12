$(document).ready(function(){
	$.get('/api/main-menu', function(data){
		//console.log(data.list);
		var $menu;
		
		data.list.forEach(function(data, index){
			
			//console.log(data.name);
			
			if(data.second_order == 0){
				$menu = $('<li class="dropdown"> ' +
				          '<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">'
				          	 + data.name +
				          '<span class="caret"></span></a>' +
				          // '<ul class="dropdown-menu" role="menu">' +
				          // '</ul>' +
				        '</li>');
				
				$('#myMenu').append($menu);
				
			}else{
				
				if(data.second_order == 1){
					$menu.append('<ul class="dropdown-menu" role="menu"></ul>');
				}
				
				var sub_menu = $('<li><a href="' + data.menu_link + '">' + data.name + '</a></li>');
				$menu.find('ul').append(sub_menu);
	
				
			}
			
			
		});
		
	});
});