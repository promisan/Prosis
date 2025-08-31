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
<cfparam name="attributes.Datasource"   default="appsMaterials">
<cfparam name="attributes.TriggerGroup" default="Request">
<cfparam name="attributes.Mission"      default="Promisan">
<cfparam name="attributes.Source"       default="">
<cfparam name="attributes.SourceId"     default="">
<cfparam name="attributes.Result"       default="0">

<cfif attributes.sourceid neq "">
	
	<cfquery name="addValidation" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO  ValidationAction
			      (   ValidationLogId,
				      ValidationCode,
					  ValidationMemo,			  	 
					  OfficerUserid,
					  OfficerLastName,
					  OfficerFirstname 
				   )
			VALUES (  '#attributes.ValidationId#',
			      	  '#attributes.BusinessRule#', 
					  '#attributes.ValidationMemo#',
					  '#SESSION.acc#', 
					  '#SESSION.last#', 
					  '#SESSION.first#'
				   ) 
	</cfquery>
	      
	<cfquery name="addValidationSource" 
		datasource="#attributes.datasource#" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO  ValidationActionSource
			      (   ValidationLogId,
				      ValidationSource,
					  ValidationSourceId,
					  ValidationResult,
					  Created
				   )
			VALUES (  '#attributes.ValidationId#',
			      	  '#attributes.Source#', 
					  '#attributes.SourceId#',
					  '#attributes.Result#',
					  getDate()
				   ) 
	</cfquery>

</cfif>
