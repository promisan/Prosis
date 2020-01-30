<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML>

<HEAD>

<TITLE>Claimant</TITLE>
	
</HEAD>

<body leftmargin="2" topmargin="2" rightmargin="3">

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT P.*, R.Description as Indicator
	FROM Ref_ClaimPurpose P, Ref_Indicator R
	WHERE P.DefaultIndicator *= R.Code
	ORDER BY P.ListingOrder
</cfquery>

<cfset Header = "">
<cfset add="1">
<cfinclude template="../HeaderTravelClaim.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0" >

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=500, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id1) {
	          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=500, height=250, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>

<tr><td colspan="2">

	<table width="97%" cellspacing="0" cellpadding="1" align="center">
	 
		<tr style="height:20px;">
		    <td  width="2%" align="center"></td>
		    <td  align="center">Code</td>
			<td  align="left">Description</td>
			<td  align="left">Default Indicator DSA</td>
		</tr>
	
		<tr><td colspan="4" class="linedotted"></td></tr>
	
		<cfoutput query="SearchResult"> 
	     
		    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#">
				<td width="2%" height="20" align="center">
				 	<cf_img icon="open" onclick="recordedit('#Code#')">
				</td>
				<td width="7%" align="center"><a href="javascript:recordedit('#Code#')">#Code#</a></td>
				<td width="55%"><a href="javascript:recordedit('#Code#')">#Description#</a></td>
			
				<td width="20%">#Indicator#</td>
			</tr>
			<cfif #currentRow# neq "#SearchResult.recordcount#">
			<tr><td colspan="4" class="linedotted"></td></tr>
			</cfif>
			
		</cfoutput>
	
	</table>

</td>
</tr>

</table>

</BODY></HTML>