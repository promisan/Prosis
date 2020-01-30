
<cfparam name="url.filterwarehouse"   default="1">	
<cfparam name="url.location"          default="">	
<cfparam name="url.mode"              default="stock">	


<table width="100%" style="height:100%;" align="center"> 

    <!---
		
	<cfif param.LotManagement eq "1" and url.location eq "">    
		<tr>
			<td height="20">
				<cfdiv id="divListingFilter" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingFilter.cfm?filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
			</td>
		</tr>
	<cfelse>
		<tr>
			<td id="mainlisting" valign="top" style="height:95%;">
				<cfdiv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
			</td>
		</tr>
	</cfif>	
	
	<cfif param.LotManagement eq "1" and url.location eq "">
	<tr>
		<td id="mainlisting" valign="top" style="height:95%;">
			<cfdiv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#"> 
		</td>
	</tr>
	</cfif>
	
	--->
	
	<tr>
			<td id="mainlisting" valign="top" style="height:95%;">
				<cfdiv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#&mode=#url.mode#">        	
			</td>
		</tr>
	
</table>				     
	