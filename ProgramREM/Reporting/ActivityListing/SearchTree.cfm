
<head>
<meta http-equiv="Content-Language" content="en-us">
<meta name="GENERATOR" content="Microsoft FrontPage 5.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

<title>Treeview</title>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

</head>

<cfparam name="URL.Mission" default="All">

<body bgcolor="#FFFFFF" leftmargin="10" topmargin="16" rightmargin="0" onLoad="window.focus()">

<cfoutput>

<cf_submenuleftscript>

<script language="JavaScript1.2">

ie = document.all?1:0
ns4 = document.layers?1:0

w = 0
h = 0
if (screen) 
{
w = #CLIENT.width# - 60
h = #CLIENT.height# - 140
}

function returnMain()

{
parent.window.close();
}

function refreshTree()

{
location.reload();
}

function filter()

{
 	window.open("../../Position/MandateView/InitView.cfm?Mission=#URL.Mission#",  "_top", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}

function actions()

{

 	window.open("../../Authorization/Staffing/TransactionView.cfm",  "accessscreen", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=no");
}

function employee()

{
 	window.open("../../Employee/EmployeeSearch/InitView.cfm?Mission=#URL.Mission#", "mandate", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}


function refreshTree()

{
location.reload();
}

</script>

</cfoutput>


<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">

  <tr bgcolor="002350"><td height="5"></td></tr>
  <tr bgcolor="6688aa"><td height="3" class="top"></td></tr>
  <tr><td height="5"</td></tr>
  <tr><td>
  
  <cfif #URL.Mission# neq "All">
  <tr><td>
  <cfset heading = "Menu">
  <cfset module = "'Program'">
  <cfset selection = "'Application'">
  <cfset menuclass = "'Period'">
  <cfset except = "''">
  <cfset color = "ffffcf">
  <cfinclude template="../../../Tools/SubmenuLeft.cfm">
  </td></tr> 
  <tr><td><hr></td></tr>
  </cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<cfoutput>

<tr><td class="Regular">
<img src="#SESSION.root#/Images/point.jpg" alt="" border="0">&nbsp;
<a href="Search.cfm?Mission=#URL.Mission#" target="right"> 
     New search</a>
</tr></td>
<tr><td height="3" class="Show"></td></tr>	

<cfparam name="URL.ID" default="1">

<cfif #URL.ID# eq "1"> 

<tr><td class="Regular">
<img src="#SESSION.root#/Images/point.jpg" alt="" width="10" height="8" border="0">&nbsp;
<a href="SearchTree.cfm?ID=0?Mission=#URL.Mission#" target="left"> 
     Go to archive</a>
</tr></td>
<tr><td height="3" class="Show"></td></tr>

<tr><td class="Regular">
<img src="#SESSION.root#/Images/point.jpg" alt="" width="10" height="8" border="0">&nbsp;
<a href="ResultCriteria.cfm?ID=<cfoutput>#URL.ID1#</cfoutput>" target="right"> 
      Review criteria</a></td></tr>
	  
</cfif>

<tr><td><hr></td></tr>

</cfoutput>	

<tr><td>

<cfset Request.ArchiveClass = "Activity">

<cfif #URL.ID# eq "1"> 

<cf_eztree
	template="TreeTemplate\ProgramMonitorTreeData.cfm"
	iconpath="#SESSION.root#/Tools/Treeview/images" 
	target="right"
	scriptpath=".">
		
<cfelse>

<cf_eztree
	template="TreeTemplate\ProgramMPriorTreeData.cfm"
	iconpath="#SESSION.root#/Tools/Treeview/images" 
	target="_top"
	scriptpath=".">
	

</cfif>	

	
</td></tr>

<cfoutput>

<tr><td><hr></td></tr>
<tr><td class="Show">
<font color="Gray">#First# #Last#</font>
</td></tr>
<tr><td class="Show">
<font color="Gray">#Section#</font>
</td></tr>
<tr><td height="5"</td></tr>
<tr bgcolor="6688aa"><td height="3" class="top"></td></tr>
<tr bgcolor="002350"><td height="5"></td></tr>
 
</cfoutput>

</table>

</td></tr>

</table>

</body>	