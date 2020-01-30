<cfdiv 
	id="HeaderDashboard" 
	bind="url:#session.root#/portal/mobile/Dashboard/DashboardHeader.cfm?mission=#url.mission#&ts=#getTickCount()#&systemfunctionid=#url.systemfunctionid#&appid=#url.appid#">

<cfdiv 
	id="MainDashboard" 
	bind="url:#session.root#/portal/mobile/Dashboard/DashboardDetail.cfm?mission=#url.mission#&ts=#getTickCount()#&systemfunctionid=#url.systemfunctionid#&appid=#url.appid#">