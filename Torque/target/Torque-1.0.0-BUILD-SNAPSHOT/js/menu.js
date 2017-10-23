$(document).ready(function(){
	$.get('/api/main-menu', function(data){
		console.log(data.list);
		var $menu;
		
		data.list.forEach(function(data, index){
			
			if(data.second_order == 0){
				$menu = $('<li class="dropdown"> ' +
				          '<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-expanded="false">'
				          	 + data.name_en +
				          '<span class="caret"></span></a>' +
				          // '<ul class="dropdown-menu" role="menu">' +
				          // '</ul>' +
				        '</li>');
				
				$('#myMenu').append($menu);
				
			}else{
				
				if(data.second_order == 1){
					$menu.append('<ul class="dropdown-menu" role="menu"></ul>');
				}
				
				$menu.find('ul').append('<li><a href="#">' + data.name_en + '</a></li>')
	
			}
			
			
			
		});
		
		
	});
});