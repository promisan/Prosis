
<!--- -------------------------------- --->
<!--- pass tru from portal perspective --->
<!--- -------------------------------- --->

<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr><td>

<cfoutput>

	<iframe src="#session.root#/Warehouse/Application/Stock/StockControl/StockView.cfm?mission=#url.mission#&scope=portal&rand=#now()#" 
	  width="100%" 
	  height="100%" 
	  frameborder="0"></iframe>
	  
</cfoutput>

</td></tr></table>