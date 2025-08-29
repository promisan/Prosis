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
<TITLE>Submit Funding</TITLE>

<cftransaction action="BEGIN">
 

<cfloop index="Rec" from="1" to="#CLIENT.RecordNo#">

  <cfparam name="FORM.selected_#Rec#" default="0">
  <cfset actionid   = Evaluate("FORM.actionid_" & #Rec#)>
  <cfset org        = Evaluate("FORM.organizationcode_" & #Rec#)>
  <cfset selected   = Evaluate("FORM.selection_" & #Rec#)>
  
  <cfquery name="ResetFunction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
    password="#SESSION.dbpw#">
DELETE From FunctionOrganization
WHERE FunctionNo         = '#Form.FunctionNo#'
  AND SubmissionEdition  = '#actionId#'
</cfquery>

<cfif selected eq "1">

<cfquery name="Insert" 
datasource="AppsSelection" 
username=#SESSION.login# 
password=#SESSION.dbpw#>
INSERT INTO FunctionOrganization 
         (SubmissionEdition, FunctionNo, OrganizationCode)
  VALUES ('#actionId#','#Form.FunctionNo#', '#org#')
</cfquery>		
</cfif>

</cfloop>

</cftransaction>
  	
<cflocation url="FunctionRoster.cfm?Id=#URLEncodedFormat(Form.FunctionNo)#" addtoken="No">		

	

