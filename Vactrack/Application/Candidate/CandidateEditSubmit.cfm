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
<cfquery name="get" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM DocumentCandidate	
	WHERE DocumentNo        = '#Form.DocumentNo#'	
	AND   PersonNo          = '#Form.PersonNo#'
</cfquery>

<cfparam name="Form.Remarks"             default="">
<cfparam name="Form.DateArrivalExpected" default="#dateformat(get.DateArrivalExpected,client.dateformatshow)#">
<cfparam name="Form.DocumentNo"          default="0">

<cfset dateValue = "">
<cfif form.dateArrivalExpected neq "">
	<CF_DateConvert Value="#Form.DateArrivalExpected#">
	<cfset arr = dateValue>
<cfelse>
	<cfset arr = "NULL">	
</cfif>	

<cfif Len(Form.Remarks) gt 250>
	 <cf_alert message = "Your entered Remarks that exceed the allowed size of 250 characters."
	  return = "back">
	  <cfabort>
</cfif>
		
<cfquery name="UpdateCandidate" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE DocumentCandidate
	SET    Remarks             = '#Form.Remarks#',
	       PositionNo          = '#Form.PostNumber#',
	       DateArrivalExpected = #arr#	
	WHERE  DocumentNo          = '#Form.DocumentNo#'	
	AND    PersonNo            = '#Form.PersonNo#' 
</cfquery>


