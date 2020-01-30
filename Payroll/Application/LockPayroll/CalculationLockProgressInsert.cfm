
<cfoutput>
	
	<cfparam name="Attributes.ProcessNo"      default="">
	<cfparam name="Attributes.ProcessBatchId" default="">
	<cfparam name="Attributes.ActionStatus"   default="">
	<cfparam name="Attributes.Description"    default="">
	<cfparam name="Attributes.StepStatus"     default="0">
	<cfparam name="Attributes.StepException"  default="">
	
	<cfif attributes.ProcessBatchId neq "">
		
			<cfquery name="Last" 
				datasource="appsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM   Payroll.dbo.CalculationLogDetail
				WHERE  ProcessNo = '#Attributes.ProcessNo#'
				AND    ProcessBatchId = '#Attributes.ProcessBatchId#'
				ORDER BY StepSerialNo DESC
			</cfquery>
			
			<cfif last.StepSerialNo eq "">
				<cfset l = 1>
			<cfelse>	
				<cfset l = Last.StepSerialNo + 1>
			</cfif>	
				
			<cfquery name="LogStep" 
				datasource="appsOrganization"  
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Payroll.dbo.CalculationLogDetail   
				       	   (ProcessNo,
						    ProcessBatchId, 
						    StepSerialNo,
						    StepTimeStamp,				
							StepDescription,
							StepStatus,
							StepException) 
				VALUES ('#attributes.ProcessNo#',
				        '#Attributes.ProcessBatchId#',
				        '#l#',
				        getDate(),			
						'#attributes.Description#',
						'#Attributes.StepStatus#',
						'#Attributes.StepException#')
			</cfquery>
		
			<cfif attributes.ActionStatus neq "">
			
				<cfquery name="Update" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Payroll.dbo.CalculationLog
					SET    ActionStatus   = '#attributes.actionstatus#',
					       ActionMemo     = '#Attributes.description#'
					WHERE  ProcessNo      = '#Attributes.ProcessNo#'
					AND    ProcessBatchId = '#Attributes.ProcessBatchId#'		
				</cfquery>
									
			</cfif>
			
	</cfif>	

</cfoutput>