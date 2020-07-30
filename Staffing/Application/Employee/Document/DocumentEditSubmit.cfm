
<cfparam name="form.DependentId" default="">


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

<cfif ParameterExists(Form.Submit)> 

	<cfquery name="Document" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM PersonDocument
	WHERE PersonNo  = '#Form.PersonNo#' 
	AND DocumentId  = '#Form.DocumentId#'
	</cfquery>
			
	<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   Ref_DocumentType
	   WHERE  DocumentType = '#Form.DocumentType#'   
	</cfquery>
	
	<cfif Parameter.VerifyDocumentNo eq "1">
		
		<cfquery name="check" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT *
		   FROM   PersonDocument
		   WHERE  PersonNo          = '#Form.PersonNo#' 
		   <cfif form.dependentid neq "">
		   AND    DependentId       = '#Form.DependentId#' 
		   <cfelse>
		   AND    DependentId       = NULL 
		   </cfif>
		   AND    DocumentType      = '#Form.DocumentType#'
		   AND    DocumentReference = '#Form.DocumentReference#' 
		   AND    IssuedCountry     = '#Form.Country#'
		   AND    DocumentId != '#Form.DocumentId#'
		</cfquery>
	
		<cfset chk = check.recordcount>
	
	<cfelse>
	
		<cfset chk = "0">
		
	</cfif>
		
	<cfif chk gte 1> 
	
	<cfoutput>
	
		<cfparam name="URL.ID" default="#Document.PersonNo#">
		<cfinclude template="../PersonViewHeader.cfm">
		
		<table width="100%" align="center"><tr><td align="center" height="30">
			
		<font size="2" color="FF0000"><cf_tl id="A document with No">: #Form.DocumentReference# <cf_tl id="is already registered"></font></b>
		
		</td>
		</tr>
		<tr><td align="center">
		
		<cf_tl id="Edit Document" var="1">
		
		<input type="button" class="button10s" value="#lt_text#" onClick="javascript:edit('#Document.PersonNo#','#Document.DocumentId#');">
		
		</td></tr></table>
	
		<cfabort>
	
	</cfoutput>

	<cfelse>
	
		<cfparam name="Form.IssuedPostalCode" default="">
	
		<cfif Form.IssuedPostalCode neq "">
		 	  
	      <cfquery name="ZIP" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 SELECT * FROM Ref_PostalCode
		 WHERE Code = '#Form.IssuedPostalCode#'
		 </cfquery>
		 	
		</cfif>
		
		<cfif Document.recordCount eq 1> 
		
			 <cfquery name="Edit" 
			   datasource="AppsEmployee" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   UPDATE PersonDocument
			   SET   DateEffective      = #STR#,
					 DateExpiration     = #END#,
					 <cfif form.dependentid neq "">
					 DependentId        = '#Form.Dependentid#',
					 <cfelse>
					 DependentId        = NULL,
					 </cfif>
					 DocumentType       = '#Form.DocumentType#',
					 DocumentReference  = '#Form.DocumentReference#', 
					 <cfif Form.IssuedPostalCode neq "" and zip.recordcount eq "1">
					 IssuedPostalCode   = '#Form.IssuedPostalCode#',
					 </cfif>
					 IssuedCountry      = '#Form.Country#',
					 Remarks            = '#Remarks#'
			   WHERE DocumentId  = '#Form.DocumentId#' 
			   </cfquery>
		
		</cfif>
		
	</cfif>	

</cfif>

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="Document" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM PersonDocument
		WHERE       PersonNo = '#Form.PersonNo#' 
		AND         DocumentId  = '#Form.DocumentId#' 
	</cfquery>

</cfif>

<cfoutput>
		
	<script>	
		 ptoken.navigate('EmployeeDocumentContent.cfm?ID=#Form.PersonNo#','detail')    
	</script>	

</cfoutput>	   
	

