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
<cfquery name="qUpdate" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  UPDATE Ref_SubmissionEditionAddressType
  SET    Operational = <cfif URL.op eq "enable">1<cfelse>0</cfif>
  WHERE  SubmissionEdition = '#URL.ID#'  
  AND    AddressType = '#URL.at#'
</cfquery>

<cfoutput>
	<script>
		ptoken.navigate('#SESSION.root#/roster/maintenance/rosteredition/Recipient/RecipientAddressType.cfm?submissionedition=#url.ID#','types');
	</script>
</cfoutput>
