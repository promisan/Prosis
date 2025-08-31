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
<cfquery name="getPerson" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	Employee.dbo.Person 
		WHERE 	PersonNo = '#url.personno#'
</cfquery>

<cfquery name="getPersonPassport" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT TOP 1 *
		FROM    Employee.dbo.PersonDocument
		WHERE 	PersonNo = '#URL.Personno#'
		AND       DocumentType = 'Passport'
		AND       ActionStatus = '1'
		ORDER BY DateEffective DESC
</cfquery>

<cfoutput>
	<script>
		$('##PersonNo', '##beneficiaryform').val('#getPerson.personno#');
		$('##lastname', '##beneficiaryform').val('#getPerson.lastname#');
		$('##firstname', '##beneficiaryform').val('#getPerson.firstname#');
		$('##nationality', '##beneficiaryform').val('#getPerson.nationality#');
		$('##birthdate', '##beneficiaryform').val('#dateformat(getPerson.birthdate,client.dateformatshow)#');
		$('##reference', '##beneficiaryform').val('#getPersonPassport.documentReference#');
	</script>
</cfoutput>