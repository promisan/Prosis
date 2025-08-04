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

<TITLE>Submit Experience</TITLE>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
<cfparam name="URL.entryScope"   default="Backoffice">

<!--- verify if a submission record exists --->

<cfinclude template="../SubmissionSubmit.cfm">
 
<cfif Form.ExperienceId eq "">

	<!--- add background --->
	
	<cfquery name="InsertBackground" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     INSERT INTO ApplicantBackground
	         (ApplicantNo,
			 ExperienceCategory,
			 ExperienceDescription,
			 Status,
		 	 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Updated,
			 Created)
	      VALUES ('#AppNo#',
		       'Miscellaneous', 
			   'Miscellaneous Skills', 
			   '0',
			   '#SESSION.acc#',
	    	   '#SESSION.last#',		  
		  	   '#SESSION.first#',
			   getdate(),
			   getdate())
	</cfquery>

<cfelse>
	
	<cfquery name="UpdateBackground" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     UPDATE ApplicantBackground
		 SET    OfficerUserId    = '#SESSION.acc#',
		        OfficerLastName  = '#SESSION.last#',
				OfficerFirstName = '#SESSION.first#',
				Updated          = getDate()
		 WHERE  ExperienceId = '#Form.ExperienceId#'
	</cfquery>

</cfif>

<!--- identify experience keywords --->

<cfquery name="Verify" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT ExperienceId
	FROM   ApplicantBackground
	WHERE  ApplicantNo         = '#AppNo#'
	<!---
	<cfif Form.ExperienceId eq "">
	WHERE  ApplicantNo         = '#AppNo#'
	AND    ExperienceDescription = 'Miscellaneous Skills'
	<cfelse>
	WHERE  ExperienceId = '#Form.ExperienceId#'
	</cfif>	
	--->
</cfquery>

<cfquery name="Clear" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	DELETE FROM ApplicantBackgroundField
	WHERE   ExperienceId IN (#QuotedValueList(Verify.ExperienceId)#)
	AND     ExperienceFieldId IN (
	                          SELECT E.ExperienceFieldId 
	                          FROM   Ref_ExperienceClass C, Ref_Experience E
							  WHERE  E.ExperienceClass = C.ExperienceClass
							  AND    C.Parent          = 'Miscellaneous'
							  )
</cfquery>

<cfif Verify.ExperienceId neq "">

<!--- add background fields level, geo, exp after identifying the assigned serialNo --->

<cfloop index="Rec" from="1" to="#Form.counted#">

	<cfset fieldId   = Evaluate("FORM.fieldId_" & #Rec#)>
    <cfset level     = Evaluate("FORM.level_" & #Rec#)>
	
	<cfif Level neq "">
	
		<cftry>
 		
		<cfquery name="InsertExperience" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO dbo.[ApplicantBackgroundField] 
		         (ApplicantNo,
				 ExperienceId,
				 ExperienceFieldId,
				 ExperienceLevel,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName,
		    	 Created)
		  VALUES ('#AppNo#', 
		          '#Verify.ExperienceId#',
		      	  '#fieldId#',
				  '#level#',
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#',
				  getdate())
		  </cfquery>
		  
		  <cfcatch></cfcatch>
		  
		  </cftry>
		  
	</cfif>		  
	
</cfloop>	

</cfif>

<cfoutput>
	
	<script>
	
		<cfif url.entryScope eq "Backoffice">
			window.location =  "../General.cfm?Source=#url.source#&ID=#PersonNo#&ID2=#URL.ID2#&Topic=#URL.Topic#";
		<cfelseif url.entryScope eq "Portal">
		
			<cfparam name="url.applicantno" default="0">
			<cfparam name="url.section" default="">
			
			window.location = '#SESSION.root#/Roster/PHP/PHPEntry/Computing/Computing.cfm?ID=#url.id#&entryScope=#url.entryScope#&applicantno=#url.applicantno#&section=#url.section#';
		</cfif>	
	</script>
	
</cfoutput>
