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
<cfquery name="list"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT   P.Mission, A.AssignmentNo, A.DateEffective, A.PersonNo, A.FunctionNo, A.FunctionDescription, A.FunctionDescriptionActual, A.OrgUnitOperational, P.OrgUnitName
	  FROM     Employee.dbo.vwAssignment AS A INNER JOIN
               Organization.dbo.Organization AS P ON A.OrgUnitOperational = P.OrgUnit
	  WHERE    A.AssignmentNo = '#url.assignmentno#' 	 
	  AND      A.PostType IN (SELECT PostType FROM Employee.dbo.Ref_PostType WHERE EnablePAS = 1)
</cfquery>

<!--- obtain EOD --->


<cfif list.recordcount eq "1">
	
	<cfinvoke component = "Service.Process.Employee.PersonnelAction"
	    Method          = "getEOD"
    	PersonNo        = "#list.personno#"
		Mission         = "#list.mission#"
    	ReturnVariable  = "EOD">	
		
	<cfset dte = dateadd("m",0,eod)>	
		
	<!--- obtain existing --->
	
	<cfquery name="last"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Contract 
		  WHERE     PersonNo      = '#list.PersonNo#' 		
		  AND       Mission       = '#list.mission#'
		  AND       ContractClass = 'Standard'
		  AND       ActionStatus != '9'
		  AND       DateExpiration >= '#eod#'
		  ORDER BY  DateEffective DESC 
	</cfquery>	
			
	<cfquery name="class"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Ref_ContractClass 
		  WHERE     Code = 'Standard' 	 
	</cfquery>
			
	<cfif last.recordcount gte "1">
	
		<cfif last.dateExpiration gte eod>
		
			<cfset dte = dateadd("d",1,last.dateExpiration)>
			
		</cfif>
		
	<cfelse>
	
		<cfset dte = dateadd("m",class.PASLatency,eod)>
	
	</cfif>
			
	<cfquery name="class"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Ref_ContractClass 
		  WHERE     Code = 'Standard' 	 
	</cfquery>
	
	<cfquery name="get"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		  SELECT    *
		  FROM      Ref_ContractPeriod 
		  WHERE     ContractClass = '#class.Code#' 
		  AND       PASPeriodEnd >= #dte# 
		  AND       Mission       = '#list.mission#'
		  ORDER BY  PASPeriodStart	  
	</cfquery>
	
	<cfloop query="list">
		
		<cfquery name="check"
			datasource="AppsEPas" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Contract
			  WHERE  PersonNo = '#PersonNo#'
			  AND    Period   = '#get.Code#'
			  AND    ContractClass = 'Standard'			  
			  AND    ActionStatus != '9'
			  AND    DateExpiration >= #dte#
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="insert"
			  datasource="AppsEPas" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO Contract
					(Mission, 
					 ContractNo, 
					 AssignmentNo, 
					 PersonNo, 
					 Period, 
					 OrgUnit, 
					 OrgUnitName, 
					 DateEffective, 
					 DateExpiration, 
					 LocationCode, 
					 FunctionNo, 
		             FunctionDescription, 
					 Source, 
					 EnableTasks,
					 OfficerUserId, 
					 OfficerLastName, 
					 OfficerFirstName)
				VALUES (
				    '#Mission#',
					'#AssignmentNo#',
					'#AssignmentNo#',
					'#PersonNo#',
					'#get.code#',
					'#OrgUnitOperational#',
					'#orgUnitName#',
					#dte#,
					'#get.PasPeriodEnd#',
					'',
					'#FunctionNo#',
					'#FunctionDescriptionActual#',
					'Manual',
					'1',
					'#session.acc#',
					'#session.last#',
					'#session.first#')			
				</cfquery>
			
		</cfif>
	
	</cfloop>
	
	<!--- refresh --->
	
	<script>
		history.go()
	</script>
	
</cfif>	


