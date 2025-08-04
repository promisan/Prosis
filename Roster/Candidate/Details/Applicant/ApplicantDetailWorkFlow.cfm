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
<cfquery name="Candidate" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT   A.*, 
		         R.Description
   		FROM     Applicant A LEFT OUTER JOIN Ref_ApplicantClass R ON A.ApplicantClass = R.ApplicantClassId
	    WHERE    PersonNo = '#URL.ajaxid#'
</cfquery>

<!--- based on the source --->
	
<cfquery name="Source" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   		SELECT   *
   		FROM     Ref_Source
		WHERE    Source = '#candidate.source#'	
</cfquery>	
	
<cfif source.entityClass neq "">	
	
	 <cfset link = "Roster/Candidate/Details/PHPView.cfm?id=#URL.ajaxid#">
	 
	 <!--- candidate enrollment flow, include creating useraccount and customer record --->
	 							
	 <cf_ActionListing 
	    EntityCode        = "Candidate"
		EntityCodeForce  = "Yes"
		EntityClass      = "Standard"
		EntityGroup      = ""
		EntityStatus     = ""
		OrgUnit          = ""
		PersonNo         = "#URL.ajaxid#"
		PersonEMail      = "#Candidate.EMailAddress#"
		ObjectReference  = "Person Enrollment"
		AjaxId           = "#url.ajaxid#"
		ObjectReference2 = "#Candidate.FirstName# #Candidate.LastName#"
		ObjectKey1       = "#URL.ajaxid#"			    
		ObjectURL        = "#link#">	
	
</cfif>		