<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<HTML><HEAD><TITLE>Bank Account Maintenance</TITLE></HEAD>

<body leftmargin="3" topmargin="3" rightmargin="1">

<cf_divscroll>

<cfset add          = "1">
<cfset Header       = "Bank Institution">
<cfinclude template = "../HeaderPayroll.cfm"> 


<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Bank	
</cfquery>

<cfoutput>

<script language = "JavaScript">

	function recordadd(grp) {
	      ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=450, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function recordedit(id) {
	      ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id, "Edit", "left=80, top=80, width=450, height=340, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}

</script>	

</cfoutput>
	
<table width="97%" cellspacing="0" cellpadding="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr class="line">   
	    <td></td>
	    <td class="labelit"><cf_tl id="Code"></td>
		<td class="labelit"><cf_tl id="Description"></td>
		<td class="labelit">Op</td>		
	</tr>
</thead>

<tbody>
	<cfoutput query="SearchResult">
	    <tr class="navigation_row labelmedium line">
			<td align="center" height="20" style="padding-top:1px;">
			   <cf_img icon="open" navigation="Yes" onclick="recordedit('#Code#')">
			</td>
			<td>#Code#</td>
			<td>#Description#</td>
			<td><cfif Operational eq "0"><cf_tl id="No"></cfif></td>			
	    </tr>	
	</cfoutput>
</tbody>

</table>

</cf_divscroll>
