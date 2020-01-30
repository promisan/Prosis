<cf_screentop html="no" height="100%">

<cfparam name="URL.Mission" default="All">

<body>

<cfoutput>

<!---<cf_submenuleftscript>--->

<script language="JavaScript1.2">

function returnMain() {
   parent.window.close();
}

function refreshTree() {
	location.reload();
}

function filter() {
 	window.open("../../Position/MandateView/InitView.cfm?Mission=#URL.Mission#",  "_top", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}

function actions() {
 	window.open("../../Authorization/Staffing/TransactionView.cfm?Mission=#URL.Mission#",  "accessscreen", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=no");
}

function employee() {
 	window.open("../../Employee/EmployeeSearch/InitView.cfm?Mission=#URL.Mission#", "mandate", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}


function refreshTree() {
	location.reload();
}

</script>

</cfoutput>

<table width="100%" height="100%" class="tree" style="padding:9px" border="0" cellspacing="0" cellpadding="0" align="center">

  <tr><td valign="top" style="padding-top:4px;padding-left:10px">
  
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="left">
	
	<cfoutput>
	
	<tr class="line"><td class="labelmedium" style="height:45px;font-size:20px">
	<img src="#SESSION.root#/Images/bullet.png" alt="" border="0">&nbsp;
	<a href="Search3.cfm?Mission=#URL.Mission#" target="right"><cf_tl id="New search"></a>
	</tr></td>
		
	<cfparam name="URL.ID" default="1">
	
	<cfif URL.ID eq "1"> 
		
		<tr>
		<td class="labelmedium" class="labelit">
		<img src="#SESSION.root#/Images/bullet.png" alt="" border="0">&nbsp;
		<a href="SearchTree.cfm?ID=0?Mission=#URL.Mission#" target="left"><cf_tl id="Go to archive"></a>
		</td>
		</tr>
				
		<tr><td class="labelmedium">
		<img src="#SESSION.root#/Images/bullet.png" alt="" border="0">&nbsp;
		<a href="ResultCriteria.cfm?ID=<cfoutput>#URL.ID1#</cfoutput>" target="right"><cf_tl id="Review criteria"></a></td></tr>
		  
	</cfif>
	
	<tr><td class="line"></td></tr>
	
	</cfoutput>	
	
	<tr><td style="padding-top:4px;padding-left:10px">
	
	<cfif URL.ID eq "1"> 
	
		<cf_eztree
		template="TreeTemplate\PersonTreeData.cfm"
		iconpath="#SESSION.root#/Tools/Treeview/Images" 
		target="right"
		scriptpath=".">
			
	<cfelse>
	
		<cf_eztree
		template="TreeTemplate\PersonPriorTreeData.cfm"
		iconpath="#SESSION.root#/Tools/Treeview/Images" 
		target="left"
		scriptpath=".">
	
	</cfif>	
		
	</td></tr>
	
	</table>

</td></tr>

</table>