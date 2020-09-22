<cf_screentop html="no" height="100%" jquery="Yes">

<cfparam name="URL.Mission" default="All">

<cfoutput>

<script language="JavaScript1.2">

function returnMain() {
   parent.window.close();
}

function refreshTree() {
	location.reload();
}

function filter() {
 	ptoken.open("../../Position/MandateView/InitView.cfm?Mission=#URL.Mission#",  "_top", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
}

function actions() {
 	ptoken.open("../../Authorization/Staffing/TransactionView.cfm?Mission=#URL.Mission#",  "accessscreen", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=no");
}

function employee() {
 	ptoken.open("../../Employee/EmployeeSearch/InitView.cfm?Mission=#URL.Mission#", "mandate", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=yes");
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
	
	<tr class="line"><td class="labelmedium" style="height:45px;font-size:18px">
	<table>
			<tr>
				<td><img src="#SESSION.root#/Images/bullet.png" alt="" border="0"></td>
				<td style="padding-left:8px;height:45px;font-size:20px">
					<a href="Search3.cfm?Mission=#URL.Mission#" target="right"><cf_tl id="New search"></a>
				</td>
			</tr>
	</table>
	</td>
	</tr>	
			
	<cfparam name="URL.ID" default="1">
	
	<cfif URL.ID eq "1"> 
		
		<tr>
		<td class="labelmedium" class="labelit">
			<table>
			<tr>
				<td><img src="#SESSION.root#/Images/bullet.png" alt="" border="0"></td>
				<td style="padding-left:6px"><a href="javascript:ptoken.location('SearchTree.cfm?ID=0&Mission=#URL.Mission#')"><cf_tl id="Go to archive"></a></td>
			</tr>
			</table>
		</td>
		</tr>
				
		<tr><td class="labelmedium">
		<table>
			<tr>
				<td><img src="#SESSION.root#/Images/bullet.png" alt="" border="0"></td>
				<td style="padding-left:6px"><a href="ResultCriteria.cfm?ID=#URL.ID1#" target="right"><cf_tl id="Review criteria"></a></td>
			</tr>
		  </table>
		</td>
		</tr>
		
	</cfif>
	
	<tr><td class="line"></td></tr>
	
	</cfoutput>	
	
	<tr><td style="padding-top:4px">
	
	<cfif URL.ID eq "1"> 
	
		<cf_PersonTreeData>
					
	<cfelse>
		
		<cf_PersonPriorTreeData>
	
		<!---
		<cf_eztree
		template="TreeTemplate\PersonPriorTreeData.cfm"
		iconpath="#SESSION.root#/Tools/Treeview/Images" 
		target="left"
		scriptpath=".">
		--->
	
	</cfif>	
		
	</td></tr>
	
	</table>

</td></tr>

</table>