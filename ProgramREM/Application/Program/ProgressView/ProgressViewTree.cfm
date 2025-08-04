<!--
    Copyright © 2025 Promisan

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

<link rel="stylesheet" type="text/css" href="../../../../tree.css">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

</head>

<body bgcolor="#FFFFFF" topmargin="16" onLoad="window.focus()">

<cfoutput>

<cf_ObjectControls>

<script language="JavaScript1.2">

function refreshTree() {
   location.reload();
}

function updatePeriod(per,mandate,mis) {

window.PeriodSelect.value = per

if (mandate != window.MandateNo.value) {
   window.MandateNo.value = mandate
   window.location = "ProgressViewTree.cfm?period="+per+"&Mission="+mis
} else {   
	<cfoutput>
	parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
	</cfoutput>
}

}

function updateSub(per) {

window.SubSelect.value = per
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

<cfparam name="URL.Sub" default="#Parameter.DefaultPeriodSub#">
<cfparam name="URL.Period" default="#Parameter.DefaultProgressPeriod#">

<!--- query --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset Criteria = ''>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" rules="cols" style="border-collapse: collapse">
  
  <tr><td height="5"</td></tr>
  <tr><td>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left">

<cfif Parameter.stPeriodUpdated+1 lt #now()#>

	<cfinclude template="ObservationPeriod.cfm">
   
	<cfquery name="UPDATE" 
		datasource="AppsProgram">
   		UPDATE Ref_ParameterMission
		SET stPeriodUpdated = '#DateFormat(now(), CLIENT.DateSQL)#'  
	</cfquery>

</cfif>

 <cfquery name="Period" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT R.Period, R.Description, M.Mission, M.MandateNo 
	  FROM Ref_Period R, stPeriod S, Organization.dbo.Ref_MissionPeriod M
	  WHERE IncludeListing = 1
	  <!--- added 20/8/2010 --->
	  AND      (R.isPlanningPeriod = 1 OR M.isPlanPeriod = 1)
	  AND M.Mission = '#URL.Mission#'
	  AND R.Period = M.Period
	  AND R.Period = S.Period
  </cfquery>
  
    <cfset per = Period.Period>  
    <cfset PNo = 0>
    <cfset Man = ''>
	  
        <cfoutput query = "Period"> 
		<cfset PNo = PNo+1>
        <tr>
          <td class="Regular" id="Period#PNo#"> 
			<input type="radio" name="Period" value="#Period#" 
				onClick="ClearRow('Period',#Period.RecordCount#);Period#PNo#.style.fontWeight='bold';updatePeriod(this.value,'#MandateNo#','#URL.Mission#)"
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
		  
	  <cfquery name="SubPeriod" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM Ref_SubPeriod
	  </cfquery>	  
  
      <tr>
        <td><hr></td>
      </tr>
 
	  <cfset SPNo = 0>
	  
      <cfoutput query = "SubPeriod"> 
		  <cfset SPNo = #SPNo#+1>

  		<cfif SPNo eq 1>
			<input type="hidden" name="SubSelect" value="#Parameter.DefaultPeriodSub#">
		</cfif>
		  
        <tr>
          <td class="Regular" id="SubPeriod#SPNo#"> 
			<input type="radio" name="SubPeriod" value="#SubPeriod#" 
				onClick="ClearRow('SubPeriod',#SubPeriod.RecordCount#);SubPeriod#SPNo#.style.fontWeight='bold';updateSub(this.value)"
				<cfif Parameter.DefaultPeriodSub eq SubPeriod>Checked</cfif>>
			&nbsp;#Description#&nbsp;

  		<cfif #Parameter.DefaultPeriodSub# eq #SubPeriod#>
			<script language="JavaScript">
				javascript:SubPeriod#SPNo#.style.fontWeight='bold';
			</script>
		</cfif>

		  </td>
        </tr>
      </cfoutput> 

<tr><td><hr></td></tr>





<tr><td class="Show">
<a href="javascript:refreshTree()" target="left"> 
      <font color="002350">Refresh</font></a></td></tr>

<tr><td>

<cfif Man neq "">

	<cfinvoke component="Service.AccessGlobal"
	    Method="global"
	  	Role="AdminProgram"
		ReturnVariable="ManagerAccess">	
	
	  <cfif #ManagerAccess# is "EDIT" OR #ManagerAccess# is "ALL">
	
	<cf_eztree
		template  = "TreeTemplate\ProgressTreeDataFull.cfm"
		iconpath  = "#SESSION.root#/Tools/Treeview/images" 
		target    ="right"
		mission   = "#URL.Mission#"
		mandate   = "#Man#"
		period    = "#Per#"
		scriptpath=".">
		
	<cfelse>
	
	<cf_eztree
		template  = "TreeTemplate\ProgressTreeData.cfm"
		iconpath  = "#SESSION.root#/Tools/Treeview/images" 
		target    = "right"
		mission   = "#URL.Mission#"
		mandate   = "#Man#"
		period    = "#Per#"
		scriptpath= ".">
	
	</cfif>	
	
<cfelse>

<b>Attention:</b>&nbsp; Default period [Parameters] must be defined</b>

</cfif>
	
</td></tr>

<cfoutput>

<tr><td><hr></td></tr>
 
</cfoutput>

</table>

</td></tr>

</table>
		
<cfoutput>	
<script language="JavaScript1.2">

{

parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"

}

</script>
</cfoutput>	

</body>	