    <!--- input the completion status as determined by the prior script --->
			
	<cfquery name="NextStep" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM   Status
		 WHERE  StatusClass = 'Requisition'
		 AND    Status > '#st#' and Status <= '2q' 
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
				WHERE    R.RequisitionNo = '#req#'
		</cfquery>	
	
	<cfset stop = "0">
	<cfset prior = st>	
	
	<cfloop query="NextStep">
		
		<cfif stop eq "0">   <!--- to stop the loop --->		
	
			<cfif Status eq "2">
											 
				<cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">
				<cfset stop = 1>	
				
			<cfelseif Status eq "2a">
											 
				<cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">
				<cfset stop = 1>		
				
			<cfelseif Status eq "2b">
											 
				<cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">
				<cfset stop = 1>									
		
			<cfelseif Status eq "2f" and 
			     FlowSetting.EnableFundingClear eq "1" and 
				 Parameter.FundingClearPurchase eq "0">		
				 
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">			
								 	 
				 <cfset stop = 1>										 	

			<cfelseif Status eq "2i" and 
			     FlowSetting.EnableCertification eq "1">	
								 
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">					 
				 <cfset stop = 1>	
				 
			<cfelseif Status eq "2k">	
			
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">	
				 <cfset stop = 1>		
				 
		    <cfelseif Status eq "2q">	
			
				 <cf_RequisitionMailDue id="#req#" role="#role#" alertstatus="#prior#">	
				 <cfset stop = 1>				 
			
			</cfif>
		
		</cfif>
		
		<cfset prior = Status>
								
	</cfloop>