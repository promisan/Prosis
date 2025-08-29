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
<!--- assignment and contract check up --->
<!--- -------------------------------- --->

<cfparam name="attributes.mission"   default="">
<cfparam name="Attributes.mandateno" default="">
<cfparam name="Attributes.personno"  default="">

<cfif attributes.mandateno eq "">
	
	<cfquery name="current" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT TOP 1 * 
		 FROM   Ref_Mandate
		 WHERE  Mission   = '#Attributes.Mission#'	 
		 ORDER BY MandateDefault DESC
	</cfquery>	

	<cfset mandateno = current.MandateNo>

<cfelse>

	<cfset mandateno = attributes.mandateno>

</cfif>

<cfquery name="MandateContractCheck" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_Mandate
	 WHERE  Mission   = '#Attributes.Mission#'
	 AND    MandateNo = '#MandateNo#' 
</cfquery>	

<cfquery name="AssignmentContractCheck" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   PersonAssignment PA, Position P
	 WHERE  PA.PositionNo = P.PositionNo
	 AND    P.Mission   = '#Attributes.Mission#'
	 AND    P.MandateNo = '#MandateNo#' 
	 AND    PA.Personno = '#attributes.Personno#'
	 AND    PA.AssignmentStatus IN ('0','1')
</cfquery>	

<!--- check if there are any valid contracts for this mandate --->

<cfquery name="ContractContractCheck" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonContract C
		WHERE    Mission          = '#Attributes.Mission#'
		AND      PersonNo         = '#Attributes.personno#'
		AND      ActionStatus    != '9'
		AND      HistoricContract = 0
		AND      DateEffective   <= '#mandateContractCheck.DateExpiration#'
		AND      (DateExpiration is NULL OR DateExpiration >= '#MandateContractCheck.DateEffective#')
		AND      C.ActionCode IN (SELECT ActionCode 
		                          FROM  Ref_Action
								  WHERE ActionCode = C.ActionCode) <!--- rules out ETL --->
		ORDER BY DateEffective DESC
		
</cfquery>		

<cfif ContractContractCheck.recordcount gte "1">

	<CFSET Caller.ValidContract = "1">
	
	<cfif ContractContractCheck.dateExpiration eq "" or (ContractContractCheck.dateexpiration gt mandateContractCheck.DateExpiration)>	 
		<CFSET Caller.ValidContractExpiration = MandateContractCheck.DateExpiration>
	<cfelse>	
		<CFSET Caller.ValidContractExpiration = ContractContractCheck.DateExpiration>
	</cfif>	
	
	<cfif AssignmentContractCheck.recordcount eq "0">
		<CFSET Caller.ValidAssignment = "0">
	<cfelse>
		<CFSET Caller.ValidAssignment = "1">
	</cfif>

<cfelse>

	<CFSET Caller.ValidContractExpiration = "0">

	<CFSET Caller.ValidContract = "0">

</cfif>
 
	 

