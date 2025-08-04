<!--
    Copyright © 2025 Promisan

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

<!--- set the selected account --->

<cfquery name="get" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      SalaryScaleLine L INNER JOIN
                  SalaryScale S ON L.ScaleNo = S.ScaleNo
		WHERE     L.ScaleNo       = '#url.scaleno#' 
		AND       L.ServiceLevel  = '#url.grade#' 
		AND       L.ServiceStep   = '#url.step#' 
		AND       L.Currency      = '#url.currency#'			
</cfquery>

<cfif get.recordcount eq "0">
	
	<cfquery name="get" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      SalaryScaleLine L INNER JOIN
	                  SalaryScale S ON L.ScaleNo = S.ScaleNo
			WHERE     L.ScaleNo       = '#url.scaleno#' 
			AND       L.ServiceLevel  = '#url.grade#' 
			AND       L.ServiceStep   = '#url.step#' 				
	</cfquery>

</cfif>
	
<cfquery name="loc" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_PayrollLocation
	WHERE    LocationCode = '#get.ServiceLocation#'
</cfquery>		

<cfquery name="sch" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     SalarySchedule
	WHERE    SalarySchedule = '#get.SalarySchedule#'
</cfquery>	

<cfparam name="url.contractid" default="">	

<cfoutput>
	
	<script>	
						   
		document.getElementById("contractlevel").value         = '#get.ServiceLevel#'							
		document.getElementById("contractstep").value          = '#get.ServiceStep#'	
		document.getElementById("servicelocation").value       = '#get.ServiceLocation#'	
		document.getElementById("servicelocationname").value   = '#loc.Description#'			
		document.getElementById("salaryschedule").value        = '#get.SalarySchedule#'		
		
		try {
		document.getElementById("salaryschedulename").value    = '#sch.Description#'				
		} catch(e) {}
		
		try {
		document.getElementById("currency").value              = '#get.Currency#'	
		} catch(e) {}
					
		if (document.getElementById('boxentitlement'))	{					
			ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/getFinancialEntitlement.cfm?id=#url.personno#&contracttype=#url.contracttype#&salaryschedule=#get.SalarySchedule#','boxentitlement')
		} else {				     		
           ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditFormPayroll.cfm?id=#url.personno#&id1=#url.contractid#&mode='+document.getElementById('mode').value+'&last='+document.getElementById('last').value+'&contracttype=#url.contracttype#&salaryschedule=#get.SalarySchedule#','boxeditentitlement')
		   effective_selectdate()
		  
		}
												
	</script>	
	

</cfoutput>