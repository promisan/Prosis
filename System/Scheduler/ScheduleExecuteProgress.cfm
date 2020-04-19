
<cfparam name="url.init" default="0">

<cfquery name="Log" 
	datasource="appsSystem">
	SELECT *
	FROM   ScheduleLog
	WHERE  ScheduleId = '#url.id#'		
</cfquery>

<cfquery name="LogStepDetail" 
	datasource="appsSystem">
	SELECT   *
	FROM     ScheduleLogDetail  
	WHERE    ScheduleRunId = '#url.idlog#'	
	ORDER BY StepTimeStamp DESC
</cfquery>

<cfoutput>
	
	<table width="100%">
	
	<cfif Log.ProcessEnd neq "">
	
		<cfif url.init eq "0">
		
			<script>
				stopprogress()
			</script>	
			
			<cfif Log.ActionStatus eq "9">
			
				<tr bgcolor="FF7979" class="labelmedium">
					<td height="17" style="padding-left:3px">#TimeFormat(Log.ProcessEnd,"HH:MM:SS")#</td>
					<td><b>Interrupted</b></td>
					<td>#Log.EMailSentTo#</td>
				</tr>	
				
				<tr bgcolor="FF7979" class="labelmedium">
					<td colspan="3">#Log.ScriptError#</td>	
				</tr>	
				
			<cfelseif Log.ActionStatus eq "5">
			
			    <tr bgcolor="ffffaf" class="labelmedium">
				<td height="17" style="padding-left:3px">#TimeFormat(Log.ProcessEnd,"HH:MM:SS")#</td>
				<td><b>Please wait until other process ends</b></td>
				<td>#Log.EMailSentTo#</td>
				</tr>				
			
			<cfelse>
				
				<tr bgcolor="C9F5D2" class="labelmedium">
				<td height="17" style="padding-left:3px">#TimeFormat(Log.ProcessEnd,"HH:MM:SS")#</td>
				<td><b>Ended</b></td>
				<td>#Log.EMailSentTo#</td>
				</tr>	
			
			</cfif>
			
		</cfif>	
	
	</cfif>
		
	<cfloop query="LogStepDetail">
	
		<cfif stepStatus eq "9">
		  <cfset color = "ffffaf">
		<cfelse>
		  <cfset color = "white">	  
		</cfif>
		<tr bgcolor="#color#" class="labelmedium line">
			<td height="15" width="120" style="padding-left:3px">#TimeFormat(StepTimeStamp,"HH:MM:SS")#</td>
			<td colspan="2">&nbsp;&nbsp;#StepDescription#</td>		
		</tr>
		<cfif stepException neq "">
			<tr bgcolor="#color#" class="labelmedium line">
			<td></td>
			<td height="15" colspan="2" style="padding-left:3px">&nbsp;&nbsp;#StepException#</td></tr>
		</cfif>
	
	</cfloop>
	
	<tr class="labelmedium line">
	<td width="120" style="padding-left:3px">#TimeFormat(Log.ProcessStart,"HH:MM:SS")#</td>
	<td width="150"><font color="408080"><b>Started</b></td>
	<td><b>#Log.NodeIp#</b></td>
	</tr>
		
	</table>
	
</cfoutput>

