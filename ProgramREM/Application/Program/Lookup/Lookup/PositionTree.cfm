<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
	