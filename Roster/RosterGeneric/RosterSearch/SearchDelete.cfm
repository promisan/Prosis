 <cfquery name="Delete" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     DELETE FROM RosterSearch
	 WHERE SearchId = '#URL.ID#'	  
 </cfquery>
 
<HTML><HEAD>
    <TITLE>Result listing</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>
 
<table width="100%">
<tr>
	<td align="center" style="padding-top:80px" class="labellarge">Archived Search has been removed from the system</td>
</tr>
<tr><td align="center" class="labelmedium">
	<font color="6688aa">Please start  a new search</font></a>
</td></tr>
</table>

