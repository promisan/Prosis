
<cfparam name="url.action" default="edit">

<cfif url.action eq "edit"> 
	
	<cfif Len(Form.Remarks) gt 100>
	  <cfset remarks = left(Form.Remarks,100)>
	<cfelse>
	  <cfset remarks = Form.Remarks>
	</cfif>  
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = dateValue>
	
	<cfset dateValue = "">
	<cfif Form.DateExpiration neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset END = dateValue>
	<cfelse>
	    <cfset END = 'NULL'>
	</cfif>	
	
	<!--- verify if record exist --->
	
	<cfparam name="Form.IssuedPostalCode" default="">

	<cfquery name="Document" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   ApplicantDocument
		WHERE  PersonNo = '#Form.PersonNo#' 
		AND    DocumentId  = '#Form.DocumentId#'
	</cfquery>
	
	<cfif Form.IssuedPostalCode neq "">
	 	  
      <cfquery name="ZIP" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT  * 
		 FROM    Ref_PostalCode
		 WHERE   Code = '#Form.IssuedPostalCode#'
	 </cfquery>
	 	
	</cfif>
	
	<cfif Document.recordCount eq 1> 
	
	 <cfquery name="Edit" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE ApplicantDocument
	   SET   DateEffective      = #STR#,
			 DateExpiration     = #END#,
			 DocumentType       = '#Form.DocumentType#',
			 DocumentReference  = '#Form.DocumentReference#', 
			 <cfif Form.IssuedPostalCode neq "" and zip.recordcount eq "1">
			 IssuedPostalCode   = '#Form.IssuedPostalCode#',
			 </cfif>
			 IssuedCountry      = '#Form.Country#',
			 Remarks            = '#Remarks#'
	   WHERE PersonNo = '#Form.PersonNo#' AND DocumentId  = '#Form.DocumentId#' 
	   </cfquery>
	
	</cfif>

</cfif>

<cfif url.action eq "delete"> 

	<cfquery name="Document" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE  FROM ApplicantDocument
		WHERE   PersonNo = '#Form.PersonNo#' 
		AND     DocumentId  = '#Form.DocumentId#' 
	</cfquery>

</cfif>
	
<cfoutput>

     <script LANGUAGE = "JavaScript">	
	 
	   <cfif url.entryScope eq "website">		   
	   		// window.location = "../../../PHP/PHPEntry/Document/Document.cfm?owner=#url.owner#&entryscope=#url.entryscope#&ID=#Form.PersonNo#&section=#url.section#&ApplicantNo=#URL.ApplicantNo#";
	   <cfelseif url.entryScope eq "backoffice" or url.entryScope eq "Portal">
	   		ptoken.location("Document.cfm?owner=#url.owner#&entryscope=#url.entryscope#&ID=#Form.PersonNo#&section=#url.section#&ApplicantNo=#URL.ApplicantNo#");
	   	<cfelseif url.entryScope eq "Validation">			
			parent.validationsubmit()							
	   </cfif>	
	   
	 </script>	
	 
</cfoutput>	
	

