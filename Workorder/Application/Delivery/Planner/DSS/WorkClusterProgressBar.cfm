<cfprogressbar 
	name="DSSProgressBar"
	autodisplay=false
	bind="cfc:service.process.workorder.routing.getProgressData()"
 	style="bgcolor:white;progresscolor:green;margin:auto;position:absolute;top:0;left:0;bottom:0;right:0;width: 10%;height: 2%;"
 	onComplete="hideProgressBar">		