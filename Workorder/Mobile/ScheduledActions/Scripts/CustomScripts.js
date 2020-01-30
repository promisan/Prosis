//All methods should have a "custom" prefix

//This method is mandatory in order to add the custom behavior
function customAddServerBehavior() {
	customTest();
}

function customMyclick() {
	alert('toggling menu from server armin');
	$('#menuContainer').toggle();
}

function customTest() {
	var vAdd = '<img src="Images/Default/add.png" style="height:75px;" onmousedown="customMyclick()">';
	//$('.clsTxtPlaceDisplay').html($('.clsTxtPlaceDisplay').html() + vAdd);
}

