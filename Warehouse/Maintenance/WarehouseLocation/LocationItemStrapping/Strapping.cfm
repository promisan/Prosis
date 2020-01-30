
<cfparam name="url.showOpenST" default="0">

<table width="100%" height="100%" cellspacing="0" cellpadding="0" id="tableStrappingContainer" class="formpadding">

	<tr><td height="5"></td></tr>
	
	<tr>
		
		<td width="50%"
		    valign="top"
		    style="padding-right:10px;">			
			<cf_divscroll>
				<cfinclude template="StrappingList.cfm">			
			</cf_divscroll>	
		</td>
		
		<td width="50%">
			<cfset vLink = "#SESSION.root#/warehouse/maintenance/WarehouseLocation/LocationItemStrapping/StrappingGraph.cfm">				
			<cfset vParameters = "warehouse=#url.warehouse#&location=#url.location#&itemno=#url.itemno#&uom=#url.uom#&strappingLevel=0">
			<cfdiv id="divGraphTank" bind="url:#vLink#?#vParameters#">
		</td>
	</tr>

</table>	