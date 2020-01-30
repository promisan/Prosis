<!--- Create Criteria string for query from data entered thru search form --->

<cfquery name="SearchResult"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, (SELECT count(*) 
	             FROM   ProgramAllotmentdetail 
				 WHERE  Fund = R.Code) as Used	
	FROM Ref_Fund R
	ORDER BY FundingMode, ListingOrder
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
  window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 450, height= 390, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordedit(id1) {
  window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 450, height= 390, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<tr class="labelmedium line">
    <td width="20"></td>
    <td width="30"></td>
    <td>Code</td>
	<td>Type</td>
	<td>Description</td>
	<td>Status</td>
	<td>S</td>
	<td>Curr.</td>
	<td>Fd Avail.</td>
	<td>Display</td>	
    <td>Entered</td>  
</tr>

<cfoutput query="SearchResult" group="FundingMode">

<tr><td colspan="4" class="labellarge" style="font-size:26px;height:40px">#FundingMode#</b></td></tr>

<cfoutput>
    
	<tr style="height:22px" class="labelmedium linedotted navigation_row">
		<td class="labelsmall"><font size="1">#currentrow#.</td>
		<td align="center">
		   <cf_img icon="open" onclick="recordedit('#Code#');" navigation="yes">
		</td>
		<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
		<td>#FundType#</td>
		<td>#Description#</td>
		<td><cfif used gte "1"><font color="008040">In Use</cfif></td>
		<td>#ListingOrder#</td>
		<td><cfif Currency neq "">#Currency#</cfif></td>
		<td><cfif VerifyAvailability eq "1">Yes</cfif></td>
		<td><cfif ControlView eq "1">Yes</cfif></td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>

</cfoutput>	

</cfoutput>

</table>

</cf_divscroll>