
<cfparam name="url.filterwarehouse"   default="1">	
<cfparam name="url.location"          default="">	
<cfparam name="url.mode"              default="stock">	

<table width="100%" style="height:100%;" align="center"> 

	<tr>
		<td id="mainlisting" valign="top" style="height:99%;padding-top:4px">				
			<cf_securediv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Diversity/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#&mode=#url.mode#">        	
		</td>
	</tr>
	
</table>				     
	