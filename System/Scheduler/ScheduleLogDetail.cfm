
<cfquery name="LogStepDetail" 
	datasource="appsSystem">
	SELECT *
	FROM ScheduleLogDetail  
	WHERE ScheduleRunId = '#url.idlog#'	
</cfquery>

<cfif LogStepDetail.recordcount neq "0">
	
	<cfoutput>
	
		<table width="100%">
		
			<cfloop query="LogStepDetail">
			
				<cfif stepStatus eq "9">
				  <cfset color = "FF8080">
				<cfelse>
				  <cfset color = "white">	  
				</cfif>
				<tr class="labelmedium" bgcolor="#color#" style="height:20px">
					<td width="100" align="right">#TimeFormat(StepTimeStamp,"HH:MM:SS")#:</td>
					<td width="100%" style="padding-left:10px">#StepDescription#</td>
				</tr>
				<cfif stepException neq "">
				<tr class="labelmedium"><td></td>	
					<td>#StepException#</td>
				</tr>
				</cfif>
			
			</cfloop>
	
		</table>

	</cfoutput>

</cfif>

