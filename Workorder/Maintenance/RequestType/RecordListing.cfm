
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Request
</cfquery>


<cf_screentop height="100%" scroll="yes" html="No" jquery="Yes">

<table width="94%" height="100%" align="center">

<tr style="height:10px"><td>
	<cfset add          = "1">
	<cfset Header       = "Request type">
	<cfinclude template = "../HeaderMaintain.cfm"> 
</td>
</tr>

<cfoutput>

<script>

function recordadd(grp) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 550, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 550, height= 290, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="2">

<cf_divscroll>

	<table width="94%" align="center" class="navigation_table">
	
	<tr class="labelmedium2 line fixrow">
	    <td></td> 
	    <td>Code</td>
		<td>Descriptive</td>
		<td>Action</td>
		<td>Operational</td>
		<td>Officer</td>
	    <td>Entered</td>  
	</tr>
	
	<cfoutput query="SearchResult">
	   
	    <tr height="20" class="navigation_row line labelmedium2"> 
		<td width="5%" align="center" style="padding-top:1px;">
		  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
		</td>		
		<td width="5%">#Code#</td>
		<td width="40%">#Description#</td>	
		<td><cfif templateApply eq "RequestApplyService.cfm">New Service
		     <cfelseif templateApply eq "RequestApplyAmendment.cfm">Service Amendment
			 <cfelseif templateApply eq "RequestApplyTerminate.cfm">Service Termination</cfif>
		</td>
		<td><cfif operational eq "0">No</cfif></td> 
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		   
	</CFOUTPUT>
	
	</table>

</cf_divscroll>

</td>
</tr>

</table>



<cfset AjaxOnLoad("doHighlight")>
