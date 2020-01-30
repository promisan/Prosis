
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
