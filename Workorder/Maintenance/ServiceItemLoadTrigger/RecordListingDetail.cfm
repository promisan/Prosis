
<cfquery name="SearchResult"
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	T.*,
				I.Description as ServiceItemDescription
		FROM  	ServiceItemLoadTrigger T
				INNER JOIN ServiceItem I
					ON I.Code = T.ServiceItem
				INNER JOIN ServiceItemMission SIM 
					ON SIM.ServiceItem = I.Code
		WHERE T.SelectionDateStart >= SIM.DatePostingCalculate 
		ORDER BY T.ServiceItem ASC, T.SelectionDateStart DESC, T.Created DESC
</cfquery>




<table width="100%" align="center" class="navigation_table">

<tr class="labelmedium line">
    <TD width="5%"></TD> 
    <TD></TD>
	<td>Start</td>
	<TD>End</TD>	
	<TD align="center">Load Mode</TD>
	<TD align="center">Scope</TD>
	<TD >Remarks</TD>
    <TD align="center">Status</TD>
</TR>

<cfif SearchResult.recordCount eq 0>
	<tr><td colspan="8" align="center"><font color="808080"><b>No load triggers recorded.</b></font></td></tr>
</cfif>

<cfoutput query="SearchResult" group="ServiceItem">
	
	<tr><td colspan="8" class="labelmedium">[#ServiceItem#] #ServiceItemDescription#</b></td></tr>
	
	<cfoutput>
	
	<cfset vStart = Dateformat(SelectionDateStart, "#CLIENT.DateFormatShow#")>
	<cfset vEnd   = Dateformat(SelectionDateEnd, "#CLIENT.DateFormatShow#")>
	    
    <TR class="navigation_row labelmedium line"> 
	<td height="23"></td>
	<td width="5%" align="center">
	
		<cfquery name="lookup"
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
			FROM  	ServiceItemLoad
			WHERE	ServiceItem = '#ServiceItem#'
			AND		SelectionDateStart = '#SelectionDateStart#'
			AND		SelectionDateEnd = '#SelectionDateEnd#'
		</cfquery>
		
		<cfif lookup.recordCount eq 0>
			<cf_img icon="delete" onclick="if (confirm('Do you want to remove this record ?')) { ColdFusion.navigate('RecordPurge.cfm?serviceitem=#serviceItem#&start=#vStart#&end=#vEnd#&loadscope=#LoadScope#','tdListing'); }">
		</cfif>
	 	
	</td>		
	<TD>#vStart#</TD>
	<TD>#vEnd#</TD>
	<TD align="center">#LoadMode#</TD>
	<td align="center">#ucase(mid(LoadScope,1,1))##mid(LoadScope,2,len(LoadScope))#</td>
	<TD >#Memo#</TD>
	<TD align="center">
		<cfset vId = "#ServiceItem##vStart##vEnd##LoadScope#">
		<cfset vId = replace(vId," ", "_", "ALL")>
		<cfset vId = replace(vId,"/", "_", "ALL")>
		<cfdiv id="divStatus_#vId#" bind="url:RecordListingActionStatus.cfm?serviceitem=#serviceItem#&start=#vStart#&end=#vEnd#&loadscope=#LoadScope#&status=#ActionStatus#">
	</TD>
    </TR>
    	
	</cfoutput>
	
	<tr><td height="5"></td></tr>

</CFOUTPUT>

<tr><td height="5"></td></tr>

</table>