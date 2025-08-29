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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfset dateValue = "">
<CF_DateConvert Value="#form.DateEffective#">
<cfset STR = dateValue>

<cfset sch = replaceNoCase(Form.SalarySchedule," ","","ALL")> 
<cfset sch = replaceNoCase(sch,"-","","ALL")> 
			
<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  SalarySchedule
	WHERE SalarySchedule  = '#sch#' 
	</cfquery>

   <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	      alert("A schedule with this code has been registered already!")
	   </script>  
  
   <cfelse>
   
   		<cftransaction>
   
			<cfquery name="Insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO SalarySchedule
			         (SalarySchedule, 
					  Description, 
					  PaymentCurrency, 
					  SalaryCalculationPeriod, 
					  SalaryBasePeriodDays, 
					  SalaryBaseRate, 
					  SalaryBasePayrollItem, 	                
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#sch#',
			          '#Form.Description#', 
					  '#Form.Currency#',
					  '#Form.SalaryCalculationPeriod#',
					  '#Form.SalaryBasePeriodDays#',
					  '#Form.SalaryBaseRate#',
					  '#Form.SalaryBasePayrollItem#',					 			  
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
			</cfquery>
			
			<cfquery name="Insert" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   INSERT INTO SalaryScheduleMission
			            (SalarySchedule, 
					     Mission, 
					     DateEffective,
					     OfficerUserId,
					     OfficerLastName,
					     OfficerFirstName)
			  VALUES  ('#sch#',
			           '#Form.Mission#', 
					   #STR#,
					   '#SESSION.acc#',
			    	   '#SESSION.last#',		  
				  	   '#SESSION.first#')
			</cfquery>
		
		</cftransaction>
		  
    </cfif>		  
           
</cfif>

<cfoutput>

	<cfparam name="url.mid" default="">

	<script language="JavaScript">   
    	 window.close()
		 opener.location = "RecordListing.cfm?idmenu=#url.idmenu#&init=1&mid=#url.mid#"       
	</script>  

</cfoutput>
