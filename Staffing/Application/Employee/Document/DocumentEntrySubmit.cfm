

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
	</cfquery>

	<cfset chk = check.recordcount>

<cfelse>

	<cfset chk = "0">
	
</cfif>

<cfif chk gte 1> 
	
	<cfoutput>
	
		<cfparam name="URL.ID" default="#Document.PersonNo#">
		<cfinclude template="../PersonViewHeader.cfm">
		
		<table width="100%" align="center">
		<tr>
			<td align="center" height="30" class="labelmedium">			
			<font size="2" color="FF0000"><cf_tl id="A document with No">: #Form.DocumentReference# <cf_tl id="is already registered"></font></b>		
			</td>
		</tr>
		<tr><td align="center">		
			<cf_tl id="Edit Document" var="1">		
			<input type="button" class="button10g" value="#lt_text#" onClick="edit('#Document.PersonNo#','#Document.DocumentId#');">		
		</td>
		</tr>
		</table>
		
		<cfabort>
	
	</cfoutput>

<CFELSE>

	<cfparam name="Form.IssuedPostalCode" default="">

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
		
      <cfquery name="InsertDocument" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PersonDocument
		         (DocumentId,
				 PersonNo,
				 DependentId,
				 DateEffective,
				 DateExpiration,
				 DocumentType,
				 DocumentReference,
				 <cfif Form.IssuedPostalCode neq "" and ZIP.recordcount eq "1">
				 IssuedPostalCode,
				 </cfif>
				 IssuedCountry,
				 Remarks,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
	      VALUES ('#url.documentid#',
			      '#Form.PersonNo#',		  
				  <cfif form.dependentid neq "">
				   	'#Form.DependentId#', 
				  <cfelse>
				   	NULL, 
				  </cfif>
		          #STR#,
				  #END#,
				  '#Form.DocumentType#',
				  '#Form.DocumentReference#', 
				  <cfif Form.IssuedPostalCode neq "" and ZIP.recordcount eq "1">
				  '#Form.IssuedPostalCode#',
				  </cfif>
				  '#Form.Country#',
				  '#Remarks#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#'
				  )
	  </cfquery>	  
		    
     <cfoutput>
	
    <script>	 
	   ptoken.navigate('#session.root#/Staffing/Application/Employee/Document/EmployeeDocumentContent.cfm?ID=#Form.PersonNo#','dialog');
    </script>	
	
</cfoutput>	   
	
</cfif>	

