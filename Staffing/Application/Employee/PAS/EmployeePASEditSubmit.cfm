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
<link href="<cfoutput>#SESSION.root#</cfoutput>/<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cfif ParameterExists(Form.Delete)> 
	
	<cfquery name="Contract" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE Contract		
		WHERE  ContractId          = '#URL.ContractId#'
	</cfquery>

<cfelse>

	<cfset dateValue = "">
	   <CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
					
	<cfset dateValue = "">
	   <CF_DateConvert Value="#Form.DateExpiration#">
	<cfset END = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.PasEvaluation neq "">
	     <CF_DateConvert Value="#Form.PASEvaluation#">
    	<cfset EVAL = dateValue>
	<cfelse>
		<cfset EVAL = 'NULL'>
	</cfif>	
		
	<cfquery name="Parameter" 
		datasource="appsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
        FROM Ref_ContractPeriod
		WHERE Code = (SELECT Period FROM Contract WHERE ContractId = '#URL.ContractId#')
		
	</cfquery>
	
		
	<cfquery name="Contract" 
	 datasource="AppsEPAS" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Contract
	    WHERE  ContractId = '#URL.ContractId#'
	</cfquery>
	
	<cfinvoke component = "Service.Access"  
		   method           = "staffing" 
		   mission          = "#Contract.Mission#" 
		   orgunit          = "#Contract.OrgUnit#" 
		   returnvariable   = "accessStaffing">	  		
		
	<cfquery name="setContract" 
		datasource="AppsEPAS" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Contract
		SET    DateEffective       = #STR#,
		       DateExpiration      = #END#,
			   OrgUnit             = '#Form.OrgUnit#',
			   OrgUnitName         = '#Form.OrgUnitName#',	
			   FunctionDescription = '#Form.FunctionDescription#',
			   Objective           = '#Form.Objective#',
			   EnableTasks         = '#Form.EnableTasks#',
			   PASEvaluation       = #EVAL#,
			   ActionStatus        = '#Form.ActionStatus#'
		WHERE  ContractId          = '#URL.ContractId#'
	</cfquery>
			
	<cfloop index="RoleFunction" list="FirstOfficer,SecondOfficer">
	
		<cfparam name="Form.#rolefunction#" default="">
		<cfset per = evaluate("Form.#rolefunction#")>
		
		<cfquery name="Check" 
		datasource="appsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      ContractActor C
			WHERE     ContractId   = '#url.ContractId#'			
			AND       RoleFunction = '#rolefunction#'			
			AND       PersonNo     = '#per#'   		
		</cfquery>
		
		 <cfquery name="Reset" 
		   datasource="AppsEPAS" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE ContractActor  
			   SET    ActionStatus = '9'		  
			   WHERE  ContractId   = '#URL.ContractId#'			  			  
			   AND    RoleFunction = '#rolefunction#'
		 </cfquery>	
		
		<cfif check.recordcount eq "1">
	
			 <cfquery name="UpdateEvaluate" 
			   datasource="AppsEPAS" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				   UPDATE ContractActor  
				   SET    ActionStatus = '1'		  
				   WHERE  ContractId   = '#URL.ContractId#'
				   AND    PersonNo     = '#per#'
				   AND    Role         = 'Evaluation'
				   AND    RoleFunction = '#rolefunction#'
			 </cfquery>	
		 
		<cfelse>
		
			 <cfquery name="Insert" 
			   datasource="AppsEPAS" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   INSERT INTO ContractActor  
				         (ContractId, 
						  PersonNo, 
						  RoleFunction,
						  Role,
						  ActionStatus,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				VALUES ('#URL.ContractId#', 
				       '#Per#',
					   '#RoleFunction#',
					   'Evaluation', 
					   '1',
					   '#SESSION.acc#', 
					   '#SESSION.last#', 
					   '#SESSION.first#')
			  </cfquery>	
			  
		</cfif>	  			  		 
	
	</cfloop>
	
	<cfif (AccessStaffing eq "EDIT" or AccessStaffing eq "ALL") 
				    and (Contract.ActionStatus lte "2" or Contract.ActionStatus eq "8" or Contract.ActionStatus eq "9")>
	
			<cfquery name="getsteps" 
				datasource="appsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
				SELECT    *
				FROM      Ref_ContractSection
				WHERE     TriggerGroup = 'Contract' 
				AND       Operational = 1
			</cfquery>
			
			<cfloop query="getsteps">	
			
				<cfparam name="Form.field_#code#" default="0">	
				<cfset val = evaluate("Form.field_#code#")>
			
				<cfquery name="setsteps" 
					datasource="appsEPAS" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						UPDATE  ContractSection 
						SET     Operational     = '#val#'
						WHERE   ContractId      = '#Contractid#'
						AND     ContractSection = '#code#'										
				</cfquery>
			
			</cfloop>
	
	</cfif>
	
</cfif>
		
<script>
	window.close()
	opener.history.go()
</script>
					
	