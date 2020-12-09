
<cfquery name="Rules" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Ref_EntityDocument R
	 WHERE  R.EntityCode = '#Object.EntityCode#'
	 AND    R.Operational = 1
	 AND    R.DocumentType = 'rule'
	 AND    (

	        DocumentId IN (SELECT DocumentId 
	                       FROM   Ref_EntityDocumentMission 
						   WHERE  Mission = '#Object.Mission#')
			OR 
			
			DocumentId NOT IN (SELECT DocumentId 
			                   FROM   Ref_EntityDocumentMission 
							   WHERE  DocumentId = R.DocumentId)			   
			
			)
</cfquery>

<cfset ruleresult     = "1">
<cfset ruleresultmemo = "">

<cfoutput query="Rules">

	<!--- perform the validation --->
	
	<!--- logging --->
	
	<cfquery name="Last" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT TOP 1 *
		 FROM   OrganizationObjectValidation
		 WHERE  ObjectId = '#Object.ObjectId#'
		 ORDER BY ValidationSerialNo DESC		
	</cfquery>
			
	<cfif Last.recordcount eq "0">
	    <cfset ser = "1">
	<cfelse>
	    <cfset ser = last.ValidationSerialNo+1>  
	</cfif>
			
	<cfquery name="Logging" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO OrganizationObjectValidation
			 (ObjectId,
			  ValidationSerialNo,
			  DocumentId,
			  EntityValidationResult,
			  EntityValidationMemo,
			  OfficerUserId,
			  OfficerLastName,
			  OfficerFirstName)
		 VALUES
			 ('#Object.EntityCode#,
			  '#ser#',
			  '#documentid#',
			  '#ruleresult#',
			  '#ruleresultmemo#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
		  '#SESSION.first#')		
	</cfquery>
	
	<cfif ruleresult eq "0">
		
		  <cf_message message = "#MessageProcessor#">
		  <cfabort>
	
	</cfif>
	
</cfoutput>
		