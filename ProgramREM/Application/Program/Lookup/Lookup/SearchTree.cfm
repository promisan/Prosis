
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

<title>Treeview</title>

<link rel="stylesheet" type="text/css" href="../../../tree.css">

</head>

<body bgcolor="#FFFFFF" topmargin="16" onLoad="window.focus()">

<script language="JavaScript1.2">

function refreshTree()

{
location.reload();
}

</script>

<!--- query --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

   <tr><td><hr></td></tr>
   <tr><td>

   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

   <tr><td>

	<cf_eztree
		template="TreeTemplate\PositionSearchTreeData.cfm"
		iconpath="#SESSION.root#/Tools/Treeview/Images" 
		target="right"
		scriptpath=".">
	
	</td></tr>

	<tr><td><hr></td></tr>

</table>

</td></tr>

</table>
	

</body>
	