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

<cfset dateValue = "">
<CF_DateConvert Value="#form.DateChargesCalculate#">
<cfset chargesDate = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#form.DatePostingStart#">
<cfset postingDateStart = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#form.DatePostingCalculate#">
<cfset postingDate = dateValue>

<cfquery name="Update" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE 	Ref_ParameterMission
SET 	TreeCustomer          = <cfif trim(form.TreeCustomer) eq "">null<cfelse>'#Form.TreeCustomer#'</cfif>,
		CustomerDetail        = #Form.CustomerDetail#,
		DocumentHost          = <cfif trim(form.DocumentHost) eq "">null<cfelse>'#Form.DocumentHost#'</cfif>,
		DocumentLibrary       = <cfif trim(form.DocumentLibrary) eq "">null<cfelse>'#Form.DocumentLibrary#'</cfif>,
		DateChargesCalculate  = #chargesDate#,
		DatePostingStart      = #postingDateStart#,
		DatePostingCalculate  = #postingDate#,
		PostingMode           = <cfif trim(form.PostingMode) eq "">null<cfelse>'#Form.PostingMode#'</cfif>,
		OfficerUserId 	 	  = '#SESSION.ACC#',
		OfficerLastName  	  = '#SESSION.LAST#',
		OfficerFirstName      = '#SESSION.FIRST#',
		Created               =  getdate()		
WHERE 	mission               = '#Form.mission#'
</cfquery>

<cfoutput>
<script>
	ColdFusion.navigate('ParameterEditMiscellaneous.cfm?ID1=#Form.mission#','contentbox1')
</script>
</cfoutput>