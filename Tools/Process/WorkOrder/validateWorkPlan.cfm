
<!--- validate workplan availability --->

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
<cfelseif status eq "7">
	<cfset cl = "yellow">
<cfelse>
	<cfset cl = "green">		
</cfif>	 

<cfset dateValue = "">
<CF_DateConvert Value="#url.selecteddate#">
<cfset dte = dateValue>

<cfoutput>

	<table>
	<tr>
		<td style="height:24px;border:1px solid black;background-color:#cl#;width:20px" 
		onclick="ptoken.navigate('#session.root#/Workorder/Application/Medical/Servicedetails/Workplan/Agenda/ActivityList.cfm?mission=#url.mission#&size=embed&positionno=#url.positionno#&selecteddate=#dateformat(dte,client.dateSQL)#','helpercontent');expandArea('mybox','helpercontent')">					
	</td>
	</tr>
	</table>		

</cfoutput>   

			   
			    