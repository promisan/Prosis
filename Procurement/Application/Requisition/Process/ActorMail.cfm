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