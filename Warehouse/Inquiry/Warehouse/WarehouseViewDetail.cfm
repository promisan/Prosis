
<cfif url.mode eq "MAP">

	<cfinclude template="WarehouseViewDetailMAP.cfm">
	
<cfelseif url.mode eq "ROLAP">	

	<table width="100%" height="100%"><tr><td style="padding:1px">
	
	<iframe name="invokedetail"
	        id="invokedetail"
	        width="100%"
	        height="100%"
	        scrolling="no"
	        frameborder="0"></iframe>
			
<cfdiv bind="url:WarehouseViewDetailDataset.cfm?mission=#url.mission#&itemno=#url.itemno#&uom=#url.uom#">		
	
	</td></tr></table>
	
<cfelse>

	<table width="100%" height="100%"><tr><td style="padding:8px">

	<cfinclude template="WarehouseViewDetailListing.cfm">
	
	</td></tr></table>

</cfif>