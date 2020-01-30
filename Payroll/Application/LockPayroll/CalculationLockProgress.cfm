	
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
	<cfquery name="Process" 
		datasource="appsPayroll">
		SELECT   TOP 1 *
		FROM     CalculationLog
		WHERE    ProcessNo = '#url.Processno#'		
		ORDER BY Created
	</cfquery>	
	
	<tr><td style="padding:10px">
		
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<cfoutput>
	<tr class="labelmedium">
	<td width="120">&nbsp;#TimeFormat(Process.Created,"HH:MM:SS")#</td>
	<td><font color="408080"><b>Started</b></td>
	</tr>
	</cfoutput>
	
	<cfquery name="Process" 
		datasource="appsPayroll">
		SELECT   *
		FROM     CalculationLog
		WHERE    ProcessNo = '#url.Processno#'		
		ORDER BY Created
	</cfquery>
		
	<cfoutput query="Process">
			
		<tr class="labelmedium" bgcolor="f4f4f4">
			<td colspan="1">&nbsp;<b>Closing:</b></td><td>#Mission#&nbsp;#SalarySchedule# &nbsp;&nbsp; #dateformat(PayrollStart,CLIENT.DateFormatShow)#</b></td>		
		</tr>
		
			<cfquery name="Detail" 
			datasource="appsPayroll">
			SELECT   *
			FROM     CalculationLogDetail
			WHERE    ProcessNo = '#Processno#'	
			AND      ProcessBatchId = '#ProcessBatchId#'		
			</cfquery>
					
			<cfloop query="Detail">
						    	
					<cfif stepStatus eq "9">
					  <cfset color = "FFD5BF">
					<cfelse>
					  <cfset color = "white">	  
					</cfif>
					<tr class="labelmedium line" bgcolor="#color#">
						<td width="120">&nbsp;&nbsp;#TimeFormat(StepTimeStamp,"HH:MM:SS")#</td>
						<td>#StepDescription#</td>		
					</tr>
					<cfif stepException neq "">
						<tr class="labelmedium line"><td></td>
						    <td>#StepException#</td>
						</tr>
					</cfif>
				
			</cfloop>		
	
	</cfoutput>
	
	<!--- fully completed --->
				
	<cfif Process.ActionStatus eq "2">
	
		<script>
			stopprogress()
		</script>
		
		<cfoutput>	
			<tr class="labelmedium" bgcolor="C9F5D2">
				<td>#Process.duration# seconds</td>
				<td><b>Ended</b></td>
				<td></td>
			</tr>	
		</cfoutput>
		
	<cfelseif Process.ActionStatus eq "9">
	
		<script>
			stopprogress()
		</script>
		
		<cfoutput>	
			<tr class="labelmedium" bgcolor="FFD5BF">
			   <td colspan="3" align="center">
			   	#Process.actionMemo#"
			   </td>			
			</tr>	
		</cfoutput>			
		
	<cfelse>
	
		<cfoutput>
			<tr class="labelmedium">
				<td colspan="3" align="center">
					<img src="#SESSION.root#/Images/busy2.gif" alt="" border="0">
				</td>
			</tr>	
		</cfoutput>			
		
	</cfif>
	
</table>

</td></tr>

</table>
