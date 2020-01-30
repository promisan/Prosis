<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<HTML><HEAD><TITLE>Activity Class</TITLE></HEAD>

<body leftmargin="1" topmargin="1" rightmargin="1" bottommargin="1">

<cfquery name="SearchResult"
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	C.*,
				ISNULL((SELECT ISNULL(COUNT(*),0) FROM Ref_ActivityClassMission WHERE Code = C.Code),0) as CountMissions
		FROM 	Ref_ActivityClass C
</cfquery>

<cf_divscroll>

<cfset add          = "1">
<cfset save         = "0"> 
<cfinclude template = "../HeaderMaintain.cfm"> 	

<cfoutput>

<script>

function recordadd(grp) {
          window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width= 460, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

function recordedit(id1) {
          window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width= 460, height= 500, toolbar=no, status=yes, scrollbars=no, resizable=yes");
}

</script>	

</cfoutput>

<table width="96%" cellpadding="0" cellspacing="0" align="center" class="maintenancetable navigation_table">

<thead>
	<tr>
	    <td></td>
	    <td>Code</td>
		<td>Description</td>
		<td align="center">Entities</td>
		<td>Officer</td>
	    <td>Entered</td>
	</tr>
</thead>

<tbody>
<cfoutput query="SearchResult">
     
	<tr height="20" class="navigation_row">
		<td align="center" style="padding-top:3px;">
		  <cf_img icon="open" onclick="recordedit('#Code#');" navigation="Yes">
		</td>
		<td><a href="javascript:recordedit('#Code#')">#Code#</a></td>
		<td>#Description#</td>
		<td align="center">#CountMissions#</td>
		<td>#OfficerFirstName# #OfficerLastName#</td>
		<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
    </tr>
	
</cfoutput>
</tbody>

</table>

</cf_divscroll>

</BODY></HTML>