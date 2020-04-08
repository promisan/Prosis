
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
		<td style="height:24px;border:1px solid black;background-color:#cl#;width:20px">
		
		<cf_UITooltip
			id         = "myresult"
			ContentURL = "#session.root#/workorder/application/medical/servicedetails/workplan/Agenda/ActivityList.cfm?mission=#url.mission#&size=embed&positionno=#url.positionno#&selecteddate=#dateformat(dte,client.dateSQL)#"
			CallOut    = "true"
			Position   = "left"
			Width      = "400"
			Height     = "200"
			Duration   = "300">***</cf_UItooltip>		
			
		</td>
	</tr>
	</table>	
	
	
	<!---	
	
	<!--- show full details of the scheduling --->
	<script>	
	ptoken.navigate('#session.root#/workorder/application/medical/servicedetails/workplan/Agenda/ActivityList.cfm?mission=#url.mission#&size=embed&positionno=#url.positionno#&selecteddate=#dateformat(dte,client.dateSQL)#','helper')	
	</script>
	
	--->

</cfoutput>   

			   
			    