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

<cfparam name="Form.PositionNo_#url.row#"    default="">
<cfparam name="Form.Topic_f004_#url.row#"    default="">
<cfparam name="Form.PlanOrderCode_#url.row#" default="">

<!--- manual planner 

1. check if workplan record exists, create record if needed
2. add record, and check if branch exists, if not add branc
3. Refresh right (ability to relink)
--->

<cfset PositionNo    = evaluate("Form.PositionNo_#url.row#")>
<cfset PlanOrderCode = evaluate("Form.PlanOrderCode_#url.row#")>
<cfset Topic1Value   = evaluate("FORM.Topic_f004_#url.row#")>

<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
   method           = "applyWorkPlan" 
   Mission          = "#url.mission#" 
   WorkActionId     = "#url.workactionid#" 
   Date             = "#url.dts#"
   PositionNo       = "#PositionNo#"
   PlanOrderCode    = "#PlanOrderCode#"
   Topic1           = "f004"
   Topic1Value      = "#Topic1Value#">   

<cfoutput>

<script>
try {
	positionselect('#positionno#','#url.dts#','limited') } catch(e) {}   
</script>

<!--- show the result --->

<cfset dateValue = "">
<CF_DateConvert Value="#url.dts#">
<cfset DTS = dateValue>

<cfquery name="Actor"
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">						

	SELECT     PA.PositionNo, 
			   PA.OrgUnit,	
	           PA.FunctionNo, 
			   PA.FunctionDescription, 
			   P.PersonNo, 
			   P.LastName, 
			   P.FirstName, 
			   PA.DateEffective, 
			   PA.DateExpiration
			   
	FROM       Person AS P INNER JOIN
                     PersonAssignment AS PA ON P.PersonNo = PA.PersonNo INNER JOIN
                  Position AS Pos ON PA.PositionNo = Pos.PositionNo
	WHERE      PA.DateEffective  <= #dts#
	AND        PA.DateExpiration >= #dts#
	AND        PA.AssignmentStatus IN ('0', '1') 
	AND        Pos.Mission       = '#url.mission#' 
	AND        Pos.PositionNo    = '#PositionNo#'
</cfquery>		


<cfquery name="Schedule"
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">			
	SELECT * 
	FROM   Ref_PlanOrder
	WHERE  Code = '#PlanOrderCode#'
</cfquery>

<table>
<tr>
<td class="labelmedium">
<cfset link = "_cf_loadingtexthtml='';ColdFusion.navigate('Planner/WorkPlanDelete.cfm?action=revert&personno=#actor.personno#&workactionid=#url.workactionid#&dts=#url.dts#&mission=#url.mission#','#url.workactionid#_workplan')">																	
#Actor.firstname# #Actor.lastName# / #Schedule.Description# </td><td> <cf_img icon="delete" onclick="#link#">	
</td>
</tr>
</table>

</cfoutput>

	