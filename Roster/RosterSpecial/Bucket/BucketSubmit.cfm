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

<cf_screentop html="No">

<cfif not ParameterExists(Form.PostGrade)>

  <cf_message message = "Please enter a valid grade!"
	  return = "back">
	  <cfabort>

</cfif>

<cfset dateValue = "">
<cfif Form.DateEffective neq ''>
    <CF_DateConvert Value="#Form.DateEffective#">
    <cfset STR = dateValue>
<cfelse>
    <cfset STR = 'NULL'>
</cfif>	

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = dateValue>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfif Form.ReferenceNo neq "">
	
	<!--- disabled 
	
	<cfquery name="Exist" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT *
		  FROM  stAnnouncement
		  WHERE VacancyNo   = '#Form.ReferenceNo#' 
	</cfquery>
	
	<cfif Exist.recordCount eq 0>
	   
		  <cf_message message = "<cfoutput>#Form.ReferenceNo#</cfoutput> does not exist!"
		  return = "back">
		  <cfabort>
		  
	</cfif>	  
	
	--->

	<cfquery name="Verify" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   FunctionOrganization
	  WHERE  ReferenceNo = '#Form.ReferenceNo#' 
	</cfquery>

	<cfif Verify.recordCount gte "1" and form.ReferenceNo neq "Direct">
   
	  <cf_alert message = "A bucket with this Vacancy no :#Form.ReferenceNo# was registered already! Operation not allowed"
	  return = "no">
	  
	  <cfabort>
  
	</cfif>
		
	<cf_assignId>
		
	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO FunctionOrganization
		         (   FunctionId,
					 FunctionNo,
					 AnnouncementTitle,
					 GradeDeployment,
					 <cfif Form.OrganizationCode neq "">
					 OrganizationCode,
					 </cfif>
					 SubmissionEdition,
					 PostSpecific,
					 Mission,
					 LocationCode,
					 ReferenceNo,
					 DateEffective,
					 DateExpiration,
					 OfficerUserId, 
					 OfficerLastName,
					 OfficerFirstName
				 )
		 VALUES  ('#RowGuid#',
		          '#Form.functionno#',
				  '#Form.FunctionDescription#',
				  '#Form.PostGrade#',
				  <cfif Form.OrganizationCode neq "">
					  '#Form.OrganizationCode#',
				  </cfif>
				  '#Form.SubmissionEdition#',
				   '0',
				  '#Form.Mission#',    
				  <cfif Form.LocationCode neq "">
				  	'#Form.LocationCode#',
				  <cfelse>
				  	NULL,
				  </cfif>
				  '#Form.ReferenceNo#',
				  #STR#,
				  #END#,
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	</cfquery>
			
<cfelse>

	<cf_assignId>	
	
	<cftry>
	
	<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO FunctionOrganization
	         (FunctionId,
			 FunctionNo,
			 GradeDeployment,
			 <cfif Form.OrganizationCode neq "">
			 OrganizationCode,
			 </cfif>
			 SubmissionEdition,
			 Mission,
			 PostSpecific,
			 DateEffective,
			 DateExpiration,
			 OfficerUserId, 
			 OfficerLastName,
			 OfficerFirstName)
	  VALUES ('#RowGuid#',
	          '#Form.functionno#',
			  '#Form.PostGrade#',
			  <cfif Form.OrganizationCode neq "">
			  '#Form.OrganizationCode#',
			  </cfif>
			  '#Form.SubmissionEdition#',
			   '#Form.Mission#',   
			  '1',
			   #STR#,
			  #END#,
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	</cfquery>
	
	<cfcatch>
	
	  <cf_alert message = "Generic bucket already exists, you would need to record a Vacancy Number to record a Post specific bucket!"
	  return = "no">
	  <cfabort>
	
	</cfcatch>
	
	</cftry>
	

</cfif>	

<!--- carry over job description --->

<cfquery name="Insert" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO FunctionOrganizationNotes
			   (FunctionId, LanguageCode,TextAreaCode, ProfileNotes)
	SELECT    '#rowguid#',LanguageCode, TextAreaCode, ProfileNotes
	FROM      FunctionTitleGradeProfile
	WHERE     FunctionNo = '#Form.functionno#' 
	AND       GradeDeployment = '#Form.PostGrade#'
</cfquery>	

<cfquery name="Function" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   FunctionOrganization
		WHERE  FunctionId = '#rowguid#'
</cfquery>

<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SubmissionEdition
		WHERE  SubmissionEdition = '#Form.SubmissionEdition#'		
</cfquery>

<cfoutput>
	
	<cfquery name="Exist" 
		datasource="AppsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   stAnnouncement
		  WHERE  VacancyNo   = '#Form.ReferenceNo#' 
	</cfquery>
	
	<cfif Exist.recordCount eq 0 and Form.ReferenceNo neq "">
		
	   <!--- if no text was recorded in the super track now is the time to do this this is more for if the 
	   ammouncements are extenrally recorded (like NY and you want to create buckets
	   26/9 not sure if this still works --->
	   	        
	   <script>	       
	       ptoken.location('BucketTextEntry.cfm?referenceno=#Form.ReferenceNo#&id=#rowguid#')	
	   </script>  
				
	<cfelse>
	 
		<script language="JavaScript">
					
			scope = parent.parent.document.getElementById('scope').value						
			parent.parent.document.getElementById('refresh'+scope).click()		
			parent.parent.ColdFusion.Window.destroy('myfunction',true)			
		  							       
		</script>  
			
	</cfif>	

</cfoutput>
