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

<cfquery name="Contract" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Contract C 
		WHERE    ContractId = '#URL.ContractId#'
</cfquery>

<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ContractActor C 
		WHERE    ContractId = '#URL.ContractId#'
		AND      ActionStatus = '1' 
		AND      Role = 'Evaluation'
</cfquery>

<cfloop query="Role">
	<cfset url.personNo = PersonNo>
	<cfinclude template="../PASView/CreatePASAccessWorkflow.cfm">
</cfloop>	

<cfif Contract.ActionStatus gte "2">

 <cf_Navigation
	 Alias         = "AppsEPAS"
	 Object        = "Contract"
	 Group         = "Contract"
	 Section       = "#URL.Section#"
	 Id            = "#URL.ContractId#"
	 BackEnable    = "0"
	 HomeEnable    = "0"
	 ResetEnable   = "0"
	 ProcessEnable = "0"
	 NextEnable    = "1"
	 ButtonWidth   = "300"
	 NextName      = "Open for Midterm review"
	 NextMode      = "1"
	 SetNext       = "1">		
	 
</cfif>	 
