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


<cf_param name="Form.DateEffective" default="" type="date">
<cf_param name="Form.DateExpiration" default="" type="date">

<cfoutput>

<script language="JavaScript">

	
</script>

</cfoutput>

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

<!--- Check for PersonNo as it can be different from PersonNo From userNames --->

<cfquery name="Check" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   ApplicantSubmission
	WHERE  ApplicantNo = '#url.applicantNo#'
</cfquery>
	
<cfif Check.PersonNo neq FORM.PersonNo and Check.PersonNo neq "">
	 <cfset FORM.PersonNo = Check.PersonNo>
</cfif>

<!--- verify if record exist --->

<cfquery name="Document" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ApplicantDocument
	WHERE  PersonNo          = '#Form.PersonNo#' 
	AND    DocumentType      = '#Form.DocumentType#'
	AND    DocumentReference = '#Form.DocumentReference#' 
</cfquery>

<cfparam name="Document.RecordCount"  default="0">
<cfparam name="Form.IssuedPostalCode" default="">


<cfquery name="DocumentType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  * 
    FROM    Ref_DocumentType
    WHERE   DocumentType = '#form.DocumentType#'   
</cfquery>

<cfif Form.DocumentReference eq "" and DocumentType.VerifyDocumentNo gte "1">

	<table align="center"><tr><td style="padding-top:30px" class="labellarge">
		
		<font color="FF0000">
		<cf_tl id="Please enter a DOCUMENT No">
		</font>

		<!---
		<cf_tl id="Return" var="1">
		<cfoutput>
		<input style="width:200px;height:30px" type="button" class="button10g" value="#lt_text#" onClick="javascript:history.go(-1);">
		</cfoutput>
		--->
		
	</td></tr></table>
	
	<cfabort>


</cfif>

<cfif Document.recordCount gte 1> 
	
	<cfoutput>
	
	<cfparam name="URL.ID" default="#Document.PersonNo#">
	
	<table align="center"><tr><td style="padding-top:40px" class="labellarge">
		
	<cf_tl id="A document with No">: #Form.DocumentReference# <cf_tl id="is already registered"></font></b></p>

		<cf_tl id="Edit Document" var="1">
		<input style="width:200px;height:30px" type="button" class="button10g" value="#lt_text#" onClick="editthis('#Document.PersonNo#','#Document.DocumentId#');">
		
	</td></tr></table>
	
	</cfoutput>

<cfelse>

    <cfif Form.IssuedPostalCode neq "">
	 	  
        <cfquery name="ZIP" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Ref_PostalCode
	  	   WHERE  Code = '#Form.IssuedPostalCode#'
		</cfquery>
	 	
	</cfif>
	
    <cfquery name="InsertDocument" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ApplicantDocument
	         (DocumentId,
			 PersonNo,
			 DateEffective,
			 DateExpiration,
			 DocumentType,
			 DocumentReference,
			 <cfif Form.IssuedPostalCode neq "">
			 IssuedPostalCode,
			 </cfif>
			 IssuedCountry,
			 Remarks,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
      VALUES (
		      '#Form.Documentid#',
		      '#Form.PersonNo#',
	          #STR#,
			  #END#,
			  '#Form.DocumentType#',
			  '#Form.DocumentReference#', 
			  <cfif Form.IssuedPostalCode neq "">
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
		
		<cfif URL.entryScope eq "BackOffice" or URL.entryScope eq "Portal">  				 
			 <script>			 
			   ptoken.location("#SESSION.root#/Roster/PHP/PHPEntry/Document/Document.cfm?ID=#Form.PersonNo#&Owner=#URL.Owner#&entryscope=#url.entryscope#&Section=#URL.Section#&ApplicantNo=#URL.ApplicantNo#")
			 </script>  
		<cfelseif URL.entryScope eq "Validation">
			<script>
				parent.validationsubmit()				
			</script>
		</cfif>	
	</cfoutput>	   
	
</cfif>	

