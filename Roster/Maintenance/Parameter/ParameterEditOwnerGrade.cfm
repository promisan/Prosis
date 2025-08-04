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

<cf_screentop height="100%" label="Candidate roster bucket exclusion" jquery="Yes" layout="webapp" banner="gray" scroll="yes">

<cfparam name="URL.Owner" default="SysAdmin">

<cfquery name="Contract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT DISTINCT PostGradeBudget as Level, PostOrderBudget
	FROM Ref_PostGrade
	ORDER BY PostOrderBudget
</cfquery>

<cfquery name="Deployment" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_GradeDeployment 
	ORDER BY PostGradeParent, ListingOrder
</cfquery>

<script language="JavaScript">

function hl(id,val) {

	se1 = document.getElementById("a"+id)
	se2 = document.getElementById("b"+id) 

	if (val == true) {
		se1.className = "highlight"
		se2.className = "highlight"
	} else {
		se1.className = "regular"
		se2.className = "regular"
	}
}
</script>

<cfform style="height:100%" action="ParameterEditOwnerGradeSubmit.cfm?Owner=#URL.Owner#" method="post">

	<table width="98%" style="height:100%"  align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<!---
	<tr>
	<td align="center" colspan="2" style="height:20">
	   <button name="Submit" type="submit" onclick="Prosis.busy('no')" class="button10g">Save</button>
	</td>
	</tr>
	--->
	
	<tr><td colspan="2" class="labelit">Select the bucket levels for which a candidate with a specific grade/level may not apply and will be denied by batch.</td></tr>
	
	<tr><td colspan="2" height="100%">	
	
	<cf_divscroll style="height:100%">
	
	<table width="100%" height="100%">
	
	<cfloop query="Contract">
	
	<tr>
		<td style="height:20" width="100%" class="labellarge" colspan="2"><font size="2">Roster bucket level:</font>&nbsp;<cfoutput><b>#Level#</cfoutput></td>
	</tr>
	
	<tr><td colspan="2" style="height:100%;padding:10px">	
	
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	
	<cfset row = "#CurrentRow#">
	<cfset lvl = "#Contract.Level#">
	
	<cfoutput query="Deployment" group="PostGradeParent">
	
	<tr><td colspan="24" class="labelit"><b>#PostGradeParent#</td></tr>
	<tr><td colspan="24" class="line"></td></tr>
	<cfset ln  = 0>
	<cfoutput>
	
	<cfquery name="Check" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_RosterLevelCondition
		WHERE Owner = '#URL.Owner#'
		AND   ContractLevel = '#lvl#'
		AND   GradeDeployment = '#GradeDeployment#' 
	</cfquery>
	
	
	<cfset ln = ln + 1>
	
	<cfif ln gt "6">
	<tr>
		<cfset ln = 0>
	</cfif>	
	<cfif Check.Recordcount eq "1">
		<td width="50" id="a#Row#_#CurrentRow#" bgcolor="6FD854" style="padding-left:3px;height:13px" align="right" class="labelit">#GradeDeployment#:</td>
		<td width="50" id="b#Row#_#CurrentRow#" bgcolor="6FD854" align="center"><input type="checkbox" value="1" name="#Row#_#CurrentRow#" onclick="hl('#Row#_#CurrentRow#',this.checked)" checked>
		<input type="hidden" name="#Row#_#CurrentRow#_old" value="1">
		</td>
	<cfelse>
		<td width="50" id="a#Row#_#CurrentRow#" style="padding-left:3px;height:13px" align="right" class="labelit">#GradeDeployment#:</td>
		<td width="50" id="b#Row#_#CurrentRow#" align="center">
		<input type="checkbox" name="#Row#_#CurrentRow#" value="1" onclick="hl('#Row#_#CurrentRow#',this.checked)">
		<input type="hidden" name="#Row#_#CurrentRow#_old" value="0">
		</td>
	</cfif>
	
	</cfoutput>
	
	<td></td>
	
	</cfoutput>
	
	</table>
	
	
	
	</td></tr>
	
	</cfloop>
	
	</table>
	</td></tr>
	
	</cf_divscroll>
	
	<tr><td height="28" colspan="1"></td>
	<td colspan="1" align="center" style="padding-bottom:10px">
	    <button name="Submit" type="submit" onclick="Prosis.busy('no')" class="button10g">Save</button>
	</td>
	</tr>
	
	</table>

</cfform>

<cf_screenbottom layout="webdialog">
