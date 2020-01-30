<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML>

<HEAD>

<TITLE>Claim category</TITLE>
	
</HEAD>

<body>

<cfquery name="SearchResult"
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_ClaimEvent
	
</cfquery>

<cf_divscroll>

<cfset Header = "">
<cfset page="0">
<cfset add="1">
<cfinclude template="../HeaderTravelClaim.cfm"> 

<table width="100%" align="center" cellspacing="0" cellpadding="0">

<cfoutput>

	<script language = "JavaScript">
	
		function recordadd(grp) {
		          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=0", "Add", "left=80, top=80, width=500, height=415, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
		function recordedit(id1) {
		          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=500, height=415, toolbar=no, status=yes, scrollbars=no, resizable=no");
		}
		
	</script>	

</cfoutput>

	<tr><td colspan="2">

	<table width="97%" cellspacing="0" cellpadding="2" align="center" >
	 
		<tr class="height:20px;">
		    <td width="4%" align="center" ></td>
		    <td >Code</td>
			<td width="50%" align="left" >Description</td>
			<td >Image</td>
			<td >Class</td>
			<td align="center" >Default</td>
			<td align="center" >TRM</td>
			<td align="center" >Doc</td>
			<td align="center" >Express</td>	
			<td align="center" >Precheck</td>	
		</tr>
	
		<tr><td colspan="10" class="linedotted"></td></tr>
		
		<cfoutput query="SearchResult"> 
		     
		    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('f8f8f8'))#">
			<td width="4%" align="center" style="padding-top:3px;">
			 	<cf_img icon="open" onclick="recordedit('#Code#')">
			</td>
			<td width="7%"><a href="javascript:recordedit('#Code#')">#Code#</a></td>
			<td width="20%">#Description#</td>
			<td>#Image#</td>
			<td>#Reference#</td>
			<td width="40" align="center"><cfif PointerDefault eq "1">Yes</cfif></td>
			<td width="40" align="center"><cfif PointerTerminal eq "1">Yes</cfif></td>
			<td width="40" align="center"><cfif PointerReference eq "1">Yes</cfif></td>
			<td width="40" align="center"><cfif PointerExpress eq "1">Yes</cfif></td>
			<td width="40" align="center"><cfif PointerTransport eq "1">Yes</cfif></td>
			</tr>
			<cfif currentRow neq "#SearchResult.recordcount#">
			<tr><td colspan="10" class="linedotted"></td></tr>
			</cfif>
				
		</cfoutput>
	
	</table>

</td>
</tr>
</table>

</cf_divscroll>

</BODY></HTML>