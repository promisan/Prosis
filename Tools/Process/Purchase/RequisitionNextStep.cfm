
<cfquery name="get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT   *
	FROM     RequisitionLine R
	WHERE    R.RequisitionNo = '#attributes.requisitionno#'
</cfquery>	

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#get.Mission#'
</cfquery>		

<!--- input the completion status as determined by the prior script --->
			
<cfquery name="NextStep" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT *
	 FROM   Status
	 WHERE  StatusClass = 'Requisition'
	 AND    Status > '#get.ActionStatus#' and Status <= '2q' 
	 ORDER BY Status					
</cfquery>
 
<cfquery name="FlowSetting" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">		
	SELECT   S.*
	FROM     RequisitionLine R INNER JOIN
             ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
             Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
	WHERE    R.RequisitionNo = '#get.requisitionno#'
</cfquery>	
	
<cfset stop = "0">
<cfset prior = get.actionstatus>
		
<cfloop query="NextStep">
		
		<cfif stop eq "0">
					
			<cfif Status eq "2">
														 
				<!---							 
				<cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">
				--->
				<cfset stop = 1>	
				
			<cfelseif Status eq "2a">
									
				<!---								 
				<cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">
				--->
				<cfset stop = 1>								
		
			<cfelseif Status eq "2f" and 
			     FlowSetting.EnableFundingClear eq "1" and 
				 Parameter.FundingClearPurchase eq "0">		
						   			
				 <!---	 
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">			
				 --->
								 	 
				 <cfset stop = 1>										 	

			<cfelseif Status eq "2i" and 
			     FlowSetting.EnableCertification eq "1">	
					
				 <!---				 
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">					 
				 --->
				 <cfset stop = 1>	
				 
			<cfelseif Status eq "2k">	
			
				<!---
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">	
				 --->
				 <cfset stop = 1>		
			
			</cfif>
			
			<cfset prior = Status>
		
		</cfif>
										
</cfloop>

<cfquery name="Status" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Status
	WHERE  StatusClass = 'Requisition'
	AND    Status      = '#prior#' 
</cfquery>		

<CFSET Caller.NextStepStatus      = prior>	
<CFSET Caller.NextStepDescription = status.StatusDescription>				