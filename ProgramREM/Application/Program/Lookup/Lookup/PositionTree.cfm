
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

<title>Treeview</title>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

</head>

<body bgcolor="#FFFFFF" leftmargin="3" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">

<script language="JavaScript1.2">

function refreshTree()

{
location.reload();
}

</script>

<!--- query --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols" style="border-collapse: collapse">
  
<tr><td><hr></td></tr>   
<tr><td>

<table width="99%" border="0" cellspacing="0" cellpadding="0" align="right">

<tr><td>

<cf_eztree
	template="TreeTemplate\PositionLookupTreeData.cfm"
	iconpath="#SESSION.root#/Tools/Treeview/Images" 
	target="right"
	scriptpath=".">
	
</td></tr>
<tr><td><hr></td></tr>

<tr><td height="5"</td></tr>

</table>

</td></tr>

</table>
	

</body>
	