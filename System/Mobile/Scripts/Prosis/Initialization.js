//Init params
window['parameterAppId'] 				= '1F0D7D17-CD3B-442F-8120-FA7F6B15377D';
window['parameterGetConfigRoot'] 		= 'http://www.mantinsa.com/apps/Component/Process/System/Mobile.cfc'
window['parameterIsCordovaEnabled'] 	= 0;

if (window['parameterIsCordovaEnabled'] == 1) {
	$(document).on("deviceready", function(e) {
		getSystemParameters();
		cordova.exec(null, null, "SplashScreen", "hide", []);
	});
}else{
	$(document).ready(function(e) {
		getSystemParameters();
	});
}