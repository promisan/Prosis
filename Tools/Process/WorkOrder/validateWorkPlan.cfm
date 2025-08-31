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
<cfinvoke component = "Service.Process.WorkOrder.Delivery"  
	   method           = "checkWorkPlan" 
	   Validation       = "check"
	   Mission          = "#url.mission#" 		
	   CustomerId       = "#url.CustomerId#"	   
	   Date             = "#url.selecteddate#"
	   DateHour         = "#url.datehour#"
	   DateMinute       = "#url.dateMinute#"
	   PositionNo       = "#url.positionno#"
	   PlanOrderCode    = "#url.planordercode#"
	   returnvariable   = "Status">  
	 
<cfif status eq "9">
	<cfset cl = "red">
	<cfset title = "Spot is occupied">
<cfelseif status eq "7">
	<cfset cl = "yellow">
	<cfset title = "Spot is possible but in parallel">
<cfelse>
	<cfset cl = "green">	
	<cfset title = "Spot is available">	
</cfif>	 

<cfset dateValue = "">
<CF_DateConvert Value="#url.selecteddate#">
<cfset dte = dateValue>

<cfoutput>

	<table>
		<tr>
			<td title   = "#Title#" 
			    style   = "cursor:pointer;height:24px;border:1px solid black;background-color:#cl#;width:20px" 
			    onclick = "ptoken.navigate('#session.root#/Workorder/Application/Medical/Servicedetails/Workplan/Agenda/ActivityList.cfm?mission=#url.mission#&size=embed&positionno=#url.positionno#&selecteddate=#dateformat(dte,client.dateSQL)#','helpercontent');expandArea('mybox','helpercontent')">	
		    </td>
		</tr>
	</table>	
	
	<script>
	    if (document.getElementById('helpercontent')) {
		// is already open 
		} else {
		ProsisUI.createWindow('helpercontent', 'Schedule', '', { height:document.body.clientHeight-89,width:560,resizable:false,center:false,modal:false, position:{top:40, left:document.body.clientWidth-595}, animation:{ open: { effects: "slideIn:up" }, close: { effects: "slideIn:up", reverse: true} }});
		}
	  	ptoken.navigate('#session.root#/Workorder/Application/Medical/Servicedetails/Workplan/Agenda/ActivityList.cfm?mission=#url.mission#&size=embed&positionno=#url.positionno#&selecteddate=#dateformat(dte,client.dateSQL)#','helpercontent')
		// expandArea('mybox','helpercontent')
	</script>	

</cfoutput>   

			   
			    