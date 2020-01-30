
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

<title>Treeview</title>

<link rel="stylesheet" type="text/css" href="../../../tree.css">
<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">

</head>

<body bgcolor="#FFFFFF" topmargin="16" onLoad="window.focus()">

<script language="JavaScript1.2">

function refreshTree()

{
location.reload();
}

</script>


<!--- query --->

<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

  <tr bgcolor="002350"><td height="5"></td></tr>
  <tr bgcolor="6688aa"><td height="3" class="top"></td></tr>
  <tr><td height="5"</td></tr>
   <tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<tr><td>
<cfset heading = "Menu">
<cfset module = "'PM Travel'">
<cfset selection = "'Application'">
<cfset menuclass = "'Control'">
<cfset color = "ffffcf">
<cfinclude template="../../../Tools/submenuleft.cfm">
</td></tr> 

<tr><td><hr></td></tr>

<tr><td class="Regular">
<a href="javascript:refreshTree()" target="left"> 
      Refresh</a></td></tr>

<tr><td>

<!--- Check if current user has access to all field missions --->
<cfquery name="AuthorizedForAllMissions" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT A.Mission
	FROM ActionAuthorization A INNER JOIN FlowAction F ON A.ActionId = F.ActionId
	WHERE A.Mission LIKE 'All%' 
	AND A.AccessLevel<>'9' 
	AND A.UserAccount='#SESSION.acc#'
</cfquery>

<!-- Set name of Tree Control template as appropriate --->
<cfset controltemplate = "TravelControlTreeData.cfm">
<cfoutput query="AuthorizedForAllMissions">
	<cfif #AuthorizedForAllMissions.RecordCount# GT 0>
		<cfset controltemplate = "TravelControlTreeDataAllMiss.cfm">
	</cfif>
</cfoutput>	
	
<cf_eztree
	template="TreeTemplate\#controltemplate#"
	iconpath="#CLIENT.Root#/Tools/Treeview/images" 
	target="right"
	scriptpath=".">
	
</td></tr>

<cfoutput>
<tr><td><hr></td></tr>
<tr><td height="5"</td></tr>
<tr bgcolor="6688aa"><td height="3" class="top"></td></tr>
<tr bgcolor="002350"><td height="5"></td></tr>
</cfoutput>

</table>

</td></tr>

</table>

</body>