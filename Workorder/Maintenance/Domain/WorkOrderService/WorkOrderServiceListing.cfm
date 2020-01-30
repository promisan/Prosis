<cfdiv id="workOrderServiceListing">

<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	 *
	FROM 	 WorkOrderService
	WHERE	 ServiceDomain = '#URL.ID1#'
	ORDER BY ListingOrder
</cfquery>

<cfoutput>

<table width="99%" align="center" cellspacing="0" cellpadding="0">  

<tr><td colspan="2">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium">
    <TD align="center"><a href="javascript:showWorkorderService('#URL.ID1#', '')"><font color="0080C0"><b>[ <cf_tl id="Add"> ]</font></a></TD> 
	<td align="center"><cf_tl id="Sort"></td>
    <TD><cf_tl id="Reference"></TD>
	<td><cf_tl id="Description"></td>
	<td align="center"><cf_tl id="Entities"></td>
	<td align="center"><cf_tl id="Items"></td>
</TR>

</cfoutput>

<cfoutput query="SearchResult">   

	<cfquery name="count"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	 (
					 	SELECT 	COUNT(*)
						FROM	WorkOrderServiceMission
						WHERE	ServiceDomain = WOS.ServiceDomain
						AND		Reference = WOS.Reference
					 ) as Missions,
					 (
					 	SELECT 	COUNT(*)
						FROM	WorkOrderServiceItem
						WHERE	ServiceDomain = WOS.ServiceDomain
						AND		Reference = WOS.Reference
					 ) as Items
			FROM 	 WorkOrderService WOS
			WHERE	 WOS.ServiceDomain = '#URL.ID1#'
			AND		 WOS.Reference = '#Reference#'
	</cfquery>
	
    <TR class="labelmedium line navigation_row"> 
	<td width="5%" align="center">
		<table>
			<tr>
				<td></td>
				<td>
					<cfquery name="CountRec" 
					      datasource="AppsWorkOrder" 
					      username="#SESSION.login#" 
					      password="#SESSION.dbpw#">
					      	SELECT	WorkorderId as id
							FROM	Workorderline
							WHERE	ServiceDomain = '#url.id1#'
							AND 	Reference = '#reference#'
					</cfquery>
					<cfif countRec.recordcount eq 0>
						<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) { ptoken.navigate('WorkOrderService/WorkOrderServicePurge.cfm?id1=#url.id1#&id2=#reference#','processWOS'); }">
					</cfif>
				</td>
				<td style="padding-left:3px;padding-top:3px">
					<cf_img icon="select" navigation="Yes" onclick="showWorkorderService('#URL.ID1#', '#Reference#')">
				</td>
			</tr>
		</table>
		  
	</td>		
	<TD align="center">#listingOrder#</TD>
	<TD>#Reference#</TD>
	<TD>#Description#</TD>	
	<td align="center">#Count.Missions#</td>
	<td align="center">#Count.Items#</td>
    </TR>
    	

</CFOUTPUT>

<tr><td class="line" colspan="8" id="processWOS"></td></tr>

</TABLE>

</td>

</TABLE>

</cfdiv>
