
<cfquery name="SearchResult"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Request
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 

<table width="99%" align="center" cellspacing="0" cellpadding="0">  

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 270, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 270, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<tr><td colspan="7" class="line"></td></tr>	

<tr><td colspan="2">

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr style="height:20px;">
    <td></td> 
    <td class="labelit">Code</td>
	<td class="labelit">Descriptive</td>
	<td class="labelit">Action</td>
	<td class="labelit">Operational</td>
	<td class="labelit">Officer</td>
    <td class="labelit">Entered</td>
  
</tr>
 <tr><td colspan="7" class="line"></td></tr>	

<cfoutput query="SearchResult">
   
    <tr height="20" class="navigation_row"> 
	<td width="5%" align="center" style="padding-top:1px;">
	  <cf_img icon="open" onclick="recordedit('#Code#')" navigation="Yes">
	</td>		
	<td class="labelit" width="5%">#Code#</td>
	<td class="labelit" width="40%">#Description#</td>	
	<td class="labelit"><cfif templateApply eq "RequestApplyService.cfm">New Service
	     <cfelseif templateApply eq "RequestApplyAmendment.cfm">Service Amendment
		 <cfelseif templateApply eq "RequestApplyTerminate.cfm">Service Termination</cfif>
	</td>
	<td class="labelit"><cfif operational eq "0">No</cfif></td> 
	<td class="labelit">#OfficerFirstName# #OfficerLastName#</td>
	<td class="labelit">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
	<tr><td colspan="7" class="line"></td></tr>	
   
</CFOUTPUT>

</table>

</td>
</tr>

</table>

</cf_divscroll>

<cfset AjaxOnLoad("doHighlight")>
