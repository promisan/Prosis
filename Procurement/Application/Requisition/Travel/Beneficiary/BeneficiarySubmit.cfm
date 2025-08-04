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
<cfquery name="validate" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	*
	    FROM 	RequisitionLineBeneficiary 
		WHERE 	1=1
		<cfif url.Beneficiaryid neq "">
		AND 	Beneficiaryid = '#URL.Beneficiaryid#'
		<cfelse>
		AND 	1=0
		</cfif>
</cfquery>

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  RequisitionLine 
	WHERE RequisitionNo = '#URL.requisitionno#'
</cfquery>

<cfset dateValue = "">
<cf_DateConvert Value="#Form.birthdate#">
<cfset vBirthdate = dateValue>

<cfif validate.recordcount eq 0>

	<cfquery name="validatePerson" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	*
		    FROM 	RequisitionLineBeneficiary 
			WHERE 	PersonNo = '#form.personno#'
			AND 	Requisitionno = '#url.requisitionno#'
			AND 	PersonNo != ''
	</cfquery>
	
	<cfif validateperson.recordcount gt 0>
	
		<cfoutput>
			<cf_tl id="This person has been added already." var="vErrormessage">
			<script>
				alert('#vErrormessage#');
			</script>
		</cfoutput>
	
	<cfelse>

		<cfquery name="insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO [dbo].[RequisitionLineBeneficiary]
				           ([RequisitionNo]
				           ,[PersonNo]
				           ,[LastName]
				           ,[FirstName]
				           ,[Nationality]
				           ,[BirthDate]
				           ,[Reference]
				           ,[OfficerUserId]
				           ,[OfficerLastName]
				           ,[OfficerFirstName])
				     VALUES
				           (
						   	'#url.requisitionno#'
							,'#form.personno#'
							,'#trim(form.LastName)#'
							,'#trim(form.FirstName)#'
							,'#form.Nationality#'
							,#vBirthdate#
							,'#trim(form.reference)#'
							,'#session.acc#'
							,'#session.last#'
							,'#session.first#')
		</cfquery>
	
	</cfif>
	
<cfelse>

	<cfquery name="update" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE 	RequisitionLineBeneficiary 
			SET		PersonNo = '#form.personno#',
					LastName = '#trim(form.LastName)#',
					FirstName = '#trim(form.FirstName)#',
					Nationality = '#form.Nationality#',
					birthdate = #vBirthdate#,
					reference = '#trim(form.reference)#'
			WHERE 	Beneficiaryid = '#URL.Beneficiaryid#'
	</cfquery>

</cfif>

<cfoutput>
	<script>
		ProsisUI.closeWindow('dialogbeneficiary');
		ptoken.navigate('#session.root#/procurement/application/requisition/travel/beneficiary/beneficiarylisting.cfm?requisitionno=#url.requisitionno#&mission=#line.mission#&access=#url.access#', 'divBeneficiary');
	</script>
</cfoutput>