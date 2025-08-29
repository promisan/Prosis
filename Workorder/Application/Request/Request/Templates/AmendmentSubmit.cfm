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
<cfloop index="fld" list="TransferMode,PersonNo,Customer,OrgUnit,Funding,ServiceItem,Asset,Personal">

    <cfif fld eq "ServiceItem">
	
		<cfparam name="Form.#fld#From" default="#Form.ServiceItem#">
		<cfparam name="Form.#fld#To"   default="#Form.ServiceItem#">
	
	<cfelse>
	
		<cfparam name="Form.#fld#From" default="">
		<cfparam name="Form.#fld#To"   default="">
		
	</cfif>	
	
	<cfset fr = evaluate("Form.#fld#From")>
	<cfset to = evaluate("Form.#fld#To")>
	
	<cfif fr neq "" or to neq "">
	
	<cfquery name="InsertAmendment" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  
		  INSERT INTO RequestWorkorderDetail (
			   RequestId,
			   WorkorderId, 
			   WorkOrderLine,
			   Amendment,
			   ValueFrom,
			   ValueTo )
		   VALUES (  
			  '#url.requestid#',
			  '#checkLine.WorkorderId#',
			  '#checkLine.WorkOrderLine#',
			  '#fld#',
			  '#fr#',
			  '#to#' )
		</cfquery>	
		
		</cfif>

</cfloop>

<cfinclude template="RequestDeviceSubmit.cfm">

