<!--- Create Criteria string for query from data entered thru search form --->
<cfset add          = "1">
<cfset save         = "0"> 

<cf_screentop html="No" jquery="Yes">

<cfquery name="SearchResult"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT G.*, P.Description, P.Category, P.PostType
	FROM Ref_PostGrade G, Ref_PostGradeParent P
	WHERE G.PostGradeParent = P.Code
	ORDER BY PostOrder
</cfquery>

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=590,height=630, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function recordeditpg(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80,top=80, width=590, height=650, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

</script>	

</cfoutput>

<table height="100%" width="100%">
<tr><td style="height:30px"><cfinclude template = "../HeaderMaintain.cfm"></td></tr>

<tr><td style="height:100%">

	<cf_divscroll style="height:100%">
	
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr class="labelheader line"> 
	    <td align="left"></td> 
	    <td>Code</td>
		<td>Display</td>
		<td>Sort</td>
		<td>Budget</td>
		<td>P</td>
		<td>R</td>
		<td>C</td>
		<td>Class</td>
		<td>Post type</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
	
	<cfoutput query="SearchResult" group="Description">
	    
		<tr><td colspan="12" class="labellarge" style="height:40px">#Description#</b></td></tr>	
		
		<cfoutput>
	    <tr class="cellcontent line navigation_row"> 
		    <td width="5%" align="center" style="padding-top:0px;">
			 <cf_img icon="edit" navigation="Yes" onclick="recordeditpg('#PostGrade#')">
			</td>			
			<td>#PostGrade#</td>
			<td>#PostgradeDisplay#</td>
			<td>&nbsp;#PostOrder#</td>
			<td>#PostgradeBudget#</td>
			<td><cfif PostgradePosition eq "1">Y</cfif></td>
			<td><cfif PostgradeVactrack eq "1">Y</cfif></td>
			<td><cfif PostgradeContract eq "1">Y</cfif></td>
			<td>#Category#</td>
			<td>#Posttype#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>
		
		</cfoutput>
		
	</cfoutput>
	
	</table>
	
	</cf_divscroll>

</td></tr>
</table>

