<!--- Create Criteria string for query from data entered thru search form --->

<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<HTML>

<HEAD>

<TITLE>Claimant</TITLE>
	
</HEAD>

<body>

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Claimant
	ORDER BY ListingOrder
</cfquery>

<cf_divscroll>

<cfset Header = "Claimant">
<cfset page="0">
<cfset add="1">
<cfinclude template="../HeaderTravelClaim.cfm"> 	

<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp)
	{
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=500, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1)
	{
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=500, height=300, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>


<tr><td colspan="2">

	<table width="97%" cellspacing="0" cellpadding="2" align="center">
	 
		<tr style="height:20px;">
		    <td width="4%" align="center" ></td>
		    <td align="center">Code</td>
			<td align="left" >Description</td>
			<td align="center">DSA perc</td>
			<td align="left" >Officer</td>
		</tr>
	
	<tr><td colspan="5" class="linedotted"></td></tr>
		
	<cfoutput query="SearchResult"> 
	     
	    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f4f4f4'))#">
		<td width="4%" align="center" style="padding-top:3px;">
		     <cf_img icon="open" onclick="recordedit('#Code#')">
		</td>
		<td width="7%" align="center"><a href="javascript:recordedit('#Code#')">#Code#</a></td>
		<td width="55%"><a href="javascript:recordedit('#Code#')">#Description#</a></td>
		<td width="15%" align="center"><cfif #LinePercentage# neq "100">#LinePercentage# %</cfif></td>
		<td width="20%">#OfficerFirstName# #OfficerLastName#</td>
		</tr>
		<cfif #currentRow# neq "#SearchResult.recordcount#">
		<tr><td colspan="5" class="linedotted"></td></tr>
		</cfif>
			
	</cfoutput>
	
	</table>

</td>
</tr>

</table>

</cf_divscroll>

</BODY></HTML>