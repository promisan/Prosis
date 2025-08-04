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

<!--- initializae period --->

<cfparam name="url.code" default="2018.1">

<cfquery name="get"
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_ContractPeriod
	  WHERE  Code = '#url.code#'
</cfquery>

<!--- steps 

obtain data of valid incumbecnies 
loop per person
		record contract
		identify first reporting officer (highest level in unit unless the ame person, then highest level in unit above it)
		identify second reporting officer: how ?
		
--->		

<cfquery name="list"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT   A.AssignmentNo, A.PersonNo, A.FunctionNo, A.FunctionDescription, A.FunctionDescriptionActual, A.OrgUnitOperational, P.OrgUnitName
	  FROM     Employee.dbo.vwAssignment AS A INNER JOIN
               Organization.dbo.Organization AS P ON A.OrgUnitOperational = P.OrgUnit
	  WHERE    A.Mission = '#get.mission#' 
	  AND      A.AssignmentStatus IN ('0','1') 
	  AND      A.DateEffective  <= '#dateformat(get.PasPeriodStart,client.dateSQL)#' 
	  AND      A.DateExpiration >= '#dateformat(get.PasPeriodStart,client.dateSQL)#' 
	  AND      A.PostType IN (SELECT PostType
	                          FROM Employee.dbo.Ref_PostType WHERE EnablePAS = 1)
</cfquery>

<cfloop query="list">
	
	<cfquery name="check"
		datasource="AppsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Contract
		  WHERE  PersonNo = '#PersonNo#'
		  AND    Period   = '#url.Code#'
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
			    '#get.Mission#',
				'#AssignmentNo#',
				'#AssignmentNo#',
				'#PersonNo#',
				'#url.code#',
				'#OrgUnitOperational#',
				'#orgUnitName#',
				'#get.PasPeriodStart#',
				'#get.PasPeriodEnd#',
				'',
				'#FunctionNo#',
				'#FunctionDescriptionActual#',
				'Batch',
				'1',
				'#session.acc#',
				'#session.last#',
				'#session.first#')			
			</cfquery>		
	</cfif>

</cfloop>

<cfquery name="get"
	  datasource="AppsEPas" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT    R.Status, R.Description, COUNT(*) AS Counted
	  FROM      Contract AS C INNER JOIN
                Ref_Status AS R ON C.ActionStatus = R.Status
	  WHERE     R.ClassStatus = 'Contract' 
	  AND       C.Operational = 1
	  AND       C.Period = '#url.code#'
	  GROUP BY  R.Status,R.Description
	  ORDER BY  R.Status
	</cfquery> 
	
	<table width="100%">	
		
	<cfoutput query="get">
	
		<tr class="cellcontent line">						
			<td style="width:70%"></td>
			<td bgcolor="e8e8e8" style="padding-left:5px">#Description#</td>	
			<td bgcolor="e8e8e8" align="right" style="padding-right:10px">#Counted#</td>						
		</tr>
	
	</cfoutput>
	
	</table>
