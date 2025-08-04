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

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="check" 
	datasource="AppsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * FROM Ref_ContractPeriod		
		WHERE   Code  = '#form.Code#'
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
		<cf_tl id="Code already exists!" var="1">
		<cfoutput>
			<script>   
				alert('#lt_text#'); 
			</script>
		</cfoutput> 
	
	<cfelse>

		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PASPeriodStart#">
		<cfset STR = dateValue>
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PASPeriodEnd#">
		<cfset END = dateValue>
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#Form.PASEvaluation#">
		<cfset DTE = dateValue>
		
		<cfquery name="Update" 
		datasource="AppsePas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Ref_ContractPeriod
				(Code,
				 Mission, 
				 ContractClass, 
				 PASPeriodStart, 
				 PASPeriodEnd, 
				 PASEvaluation, 			 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)
	        VALUES ('#Form.Code#','#Form.Mission#','#Form.ContractClass#',#STR#,#END#,#DTE#,'#session.acc#','#session.last#','#session.first#')
			
		</cfquery>	
		
		<cfset url.code = form.code>
	
		<cfinclude template="setContractPeriod.cfm">	
		
	 </cfif>	
	
</cfif>	

<cfif ParameterExists(Form.Update)>

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.PASEvaluation#">
	<cfset DTE = dateValue>
	
	<cfquery name="Update" 
	datasource="AppsePas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  Ref_ContractPeriod
		SET     PASEvaluation  = #dte#
		WHERE   Code           = '#url.Code#'
	</cfquery>
	
</cfif>
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
