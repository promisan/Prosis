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
<cfparam name="url.entryScope" 		default="Backoffice">
<cfparam name="url.owner"           default="edit">
<cfparam name="url.mission" 		default="">

<cfif Len(Form.Remarks) gt 300>
  <cfset remarks = left(Form.Remarks,300)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<!---

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">
<cfif #Form.DateExpiration# neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	
--->

<!--- verify if record exist --->

<cfquery name="Address" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ApplicantAddress
    WHERE  PersonNo = '#Form.PersonNo#' 
	AND    AddressType  = '#Form.AddressType#' AND AddressPostalCode = '#Form.AddressPostalCode#'
	AND	   ActionStatus <> '9'
</cfquery>

<cfparam name="Address.RecordCount" default="0">

<cfif Address.recordCount gte 1> 
	<cf_tl id="You entered an existing address record. Operation not allowed." var="1">
    <cf_alert message = "#lt_text#">

<CFELSE>

     <cfquery name="InsertAddress" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO ApplicantAddress
         (PersonNo,		
		 AddressType,
		 Address1,
		 Address2,
		 City,
		 AddressPostalCode,
		 State,
		 Coordinates,		 
		 Country,
		 TelephoneNo,
		 FaxNo,
		 Cellular,
		 eMailAddress,		
		 Contact,
		 ContactRelationship,
		 Remarks,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
      VALUES ('#Form.PersonNo#',        
		  '#Form.AddressType#',
		  '#Form.Address#',
		  '#Form.Address2#',
		  '#Form.AddressCity#',
		  '#Form.AddressPostalCode#',
		  '#Form.State#',
		  '#Form.cLatitude#,#Form.cLongitude#',		 
		  '#Form.Country#',
		  '#Form.TelephoneNo#',
		  '#Form.Faxno#',
		  '#Form.Cellular#',
		  '#Form.eMailAddress#',		
		  '#Form.Contact#',
		  '#Form.ContactRelationship#',
		  '#Remarks#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')</cfquery>
	  		    
     <cfoutput>
	 
	 <script>
	 	
	 	<cfif url.entryScope eq "Backoffice">
	 		
		 	ptoken.navigate('#SESSION.root#/Roster/Candidate/Details/Address/Address.cfm?owner=#url.owner#&mission=#url.mission#&ID=#url.id#&entryScope=#url.entryScope#','addressbox');
		 	
		 <cfelseif url.entryScope eq "Portal">
		 
		 	<cfparam name="url.applicantno" default="0">
			<cfparam name="url.section" default="">
		 
		 	ptoken.location('#SESSION.root#/Roster/PHP/PHPEntry/Address/Address.cfm?owner=#url.owner#&mission=#url.mission#&ID=#url.id#&entryScope=#url.entryScope#&object=applicant&applicantno=#url.applicantno#&section=#url.section#');
			
	 	</cfif>
     </script>	
	 
	 </cfoutput>	   
	
</cfif>	

