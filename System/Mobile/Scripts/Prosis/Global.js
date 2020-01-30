//Global data variables
var globalDataList 			= '';
var globalCustomerList		= '';
var globalPicturesList		= '';
var globalPersonsList		= '';

var globalParentCustomerObj = {};
var globalCustomerObj 		= {};
var globalClassObj			= {};
var globalAreaObj			= {};
var globalHourObj			= {};
var globalPersonObj			= {};

var globalISOSelectedDate	= "";
var globalSTRSelectedDate	= "";

var globalScrollTimer		= null;
var globalScrollDelay		= 500;

var $globalVisible;

var globalClickEvent		= 'mousedown';
var globalClickOutEvent		= 'mouseup';

//Detect a touch device
if (!!('ontouchstart' in window)) { //just for ie10 || !!('onmsgesturechange' in window)
	globalClickEvent		= 'touchstart';
	globalClickOutEvent		= 'touchend';
}
