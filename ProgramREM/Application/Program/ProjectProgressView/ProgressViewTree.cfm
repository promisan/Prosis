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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Progress View Tree</proDes>
	<proCom>This file generates the progress view tree for progress reporting</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cf_screentop height="100%" band="No" scroll="yes" html="No">

<cfoutput>

<cf_ObjectControls>

<script language="JavaScript1.2">

function refreshTree() {
   location.reload();
}

function updatePeriod(per,mandate) {

document.getElementById("PeriodSelect").value = per

if (mandate != document.getElementById("MandateNo").value) {
   document.getElementById("MandateNo").value = mandate
   window.location = "ProgressViewTree.cfm?mission=#url.mission#&period="+per
} else {   
	<cfoutput>
	parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	</cfoutput>
}

}

function updateSub(per) {
document.getElementById("SubSelect").value = per
<cfoutput>
	parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
</cfoutput>

}

</script>

</cfoutput>

<cfquery name="Parameter" 
 datasource="AppsProgram" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
	  WHERE Mission = '#URL.Mission#'
</cfquery>

<cfparam name="URL.Period" default="#Parameter.DefaultProgressPeriod#">


<cfset Criteria = ''>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="tree">

  <cfform>
  
  <tr><td height="5"</td></tr>
  <tr><td valign="top">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

 <cfquery name="Period" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT R.Period, R.Description, M.Mission, M.MandateNo 
	  FROM Ref_Period R, Organization.dbo.Ref_MissionPeriod M
	  WHERE IncludeListing = 1
	  <!--- added 20/8/2010 --->
	  AND    (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
	  AND    M.Mission = '#URL.Mission#'
	  AND    R.Period = '#Parameter.DefaultProgressPeriod#'
	  AND    R.Period = M.Period
  </cfquery>
  
      
    <cfset PNo = 0>
    <cfset Man = ''>
	  
        <cfoutput query = "Period"> 
		<cfset PNo = #PNo#+1>
        <tr>
          <td class="Regular" id="Period#PNo#"> 
			<input type="radio" name="Period" value="#Period#" 
				onClick="ClearRow('Period',#Period.RecordCount#);Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#')"
				<cfif Parameter.DefaultProgressPeriod eq Period>Checked</cfif>>&nbsp;#Description#&nbsp;
         		<cfif Parameter.DefaultProgressPeriod eq Period>
					<input type="hidden" name="PeriodSelect" value="#Period#">
					<cfset per  = "#Period#">
					<input type="hidden" name="MandateNo" value="#MandateNo#">
					<cfset man  = "#MandateNo#">
					<script language="JavaScript">
						javascript:Period#PNo#.style.fontWeight='bold';
					</script>
				</cfif>
		  </td>
	   </tr>
	  </cfoutput> 
	 	      
<tr><td height="4"></td></tr>
<tr><td class="line"></td></tr>
<tr><td height="2"></td></tr>

<tr><td>

<cfif Man neq "">

	<cfinvoke component="Service.Access"
    Method="Organization"
	Mission="#URL.Mission#"
  	Role="AdminProgram"
	ReturnVariable="MissionAccess">	
			
	<cfif MissionAccess is "Edit" or MissionAccess eq "ALL">
	
	 	<cftree name="idtree" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
				     <cftreeitem 
					  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#man#','ProgressViewOpen.cfm','PRG','Operational Structure','#url.mission#','#man#','','Full')">  		 
			    </cftree>		
				
    <cfelse>
	
		 	<cftree name="idtree" font="tahoma"  fontsize="11" bold="No" format="html" required="No">
				     <cftreeitem 
					  bind="cfc:service.Tree.OrganizationTree.getNodes({cftreeitempath},{cftreeitemvalue},'#url.mission#','#man#','ProgressViewOpen.cfm','PRG','Operational Structure','#url.mission#','#man#','','Role')">  		 
			    </cftree>		
				
      
	</cfif> </td></tr>
	
<cfelse>

<b>Attention:</b>&nbsp; Default period [Parameters] must be defined</b>

</cfif>
	
</td></tr>

<cfoutput>

<tr><td class="line"></td></tr>
 
</cfoutput>

</table>

</td></tr>

	</cfform>

</table>
		
<cfoutput>	

	<script language="JavaScript1.2">

	{
		parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	}

</script>
</cfoutput>	
