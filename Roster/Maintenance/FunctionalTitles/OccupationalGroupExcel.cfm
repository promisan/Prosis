<HTML><HEAD>
    <TITLE>Occupational Groups</TITLE>		
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=occgroup.xls">
</HEAD>
<body>
<cfquery name="OccGroup"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT OccupationalGroup, Description
	FROM OccGroup
	WHERE Status = '1' 
	ORDER BY Description
</cfquery>
<cfoutput>
<table width="100%">
<tr><TD><font size="4"><b><cf_tl id="Occupational Groups"></b></font>
</td></tr>
</table>
<table>
</cfoutput>
<cfloop query="OccGroup">
 <cfoutput> <tr><td>#OccGroup.OccupationalGroup#</td><td> #OccGroup.Description#</cfoutput></tr></td>
</cfloop>
</table>
</BODY></HTML>