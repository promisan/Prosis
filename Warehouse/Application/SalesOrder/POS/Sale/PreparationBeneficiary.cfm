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
<cfquery name="qBeneficiaries"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM dbo.Sale#URL.Warehouse#Beneficiary
	WHERE TransactionId = '#URL.Id#'
	AND Operational = '1'
</cfquery>
  

<cfset ExistingRows = qBeneficiaries.recordcount>

<cfif URL.clines gte ExistingRows>

	<cfquery name="qBeneficiariesDisabled"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM dbo.Sale#URL.Warehouse#Beneficiary
		WHERE TransactionId = '#URL.Id#'
		AND Operational = '0'
	</cfquery>
	
	<cfif qBeneficiariesDisabled.recordCount neq 0>
		<cfset toRestore     = URL.clines-ExistingRows>
		
		<cfset CountVar = 1>
		<cfloop condition = "CountVar lte toRestore">
			<cfquery name="qCandidateDisable"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 * FROM dbo.Sale#URL.Warehouse#Beneficiary
				WHERE TransactionId = '#URL.Id#'
				AND   Operational = '0'
				ORDER BY Created ASC
			</cfquery>
	
			<cfif qCandidateDisable.recordcount neq 0>
				<cfquery name="qUpdate"
					datasource="AppsTransaction" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE dbo.Sale#URL.Warehouse#Beneficiary
					SET Operational = '1'
					WHERE TransactionId = '#qCandidateDisable.TransactionId#'
					AND CustomerId = '#qCandidateDisable.CustomerId#'
					AND BeneficiaryId = '#qCandidateDisable.BeneficiaryId#'
				</cfquery>
			<cfelse>
				<cfbreak>	
			</cfif>
			<cfset CountVar = CountVar + 1>		
		</cfloop>	
	</cfif>
	
	<cfquery name="qBeneficiaries"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM dbo.Sale#URL.Warehouse#Beneficiary
		WHERE TransactionId = '#URL.Id#'
		AND Operational = '1'
	</cfquery>
	
	<cfset ExistingRows = qBeneficiaries.recordcount>
	
	<cfset toCreate     = URL.clines-ExistingRows>
	<cfset CountVar = 1>
	<cfloop condition = "CountVar lte toCreate">

		<cfquery name="qGetCandidate"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Materials.dbo.CustomerBeneficiary CB
			WHERE CustomerId = '#qTransaction.CustomerId#'
			AND  NOT EXISTS
			(
				SELECT 'X' 
				FROM dbo.Sale#URL.Warehouse#Beneficiary WB
				WHERE WB.TransactionId = '#URL.Id#'
				AND WB.CustomerId = CB.CustomerId
				AND WB.BeneficiaryId = CB.BeneficiaryId
				AND WB.Operational = '1'
			)
			AND EXISTS
			(
				SELECT 'X'
				FROM 
				Materials.dbo.ItemTransaction IT INNER JOIN 
					Materials.dbo.ItemTransactionBeneficiary IB
					ON IT.TransactionId = IB.TransactionId 
				WHERE IB.CustomerId  = CB.CustomerId
				AND IB.BeneficiaryId = CB.BeneficiaryId
				AND IT.ItemNo        = '#qTransaction.ItemNo#' 
				
			)
		</cfquery>
			
		<cfif qGetCandidate.recordcount eq 0>
			
			<cf_assignid>
				
			<cfquery name="qInsert"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO dbo.Sale#URL.Warehouse#Beneficiary(TransactionId,
														   CustomerId,
														   BeneficiaryId,
														   Operational,						
														   OfficerUserId,
														   OfficerLastName,
														   OfficerFirstName)
			VALUES ('#URL.Id#',
				    '#qTransaction.CustomerId#',
					'#rowguid#',
					'1',
					'#session.acc#',
					'#session.last#',
					'#session.first#' )		  
			</cfquery>
		<cfelse>
			<cfquery name="qCheck"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM dbo.Sale#URL.Warehouse#Beneficiary
				WHERE TransactionId = '#URL.Id#'
				AND CustomerId = '#qTransaction.CustomerId#'
				AND BeneficiaryId = '#qGetCandidate.BeneficiaryId#'
			</cfquery>
		
			<cfif qCheck.recordcount eq 0>
				<cfquery name="qInsert"
				datasource="AppsTransaction" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO dbo.Sale#URL.Warehouse#Beneficiary(TransactionId,
														   CustomerId,
														   BeneficiaryId,
														   LastName,
														   FirstName,
														   Relationship,
														   BirthDate,
														   Gender,
														   Operational,						
														   OfficerUserId,
														   OfficerLastName,
														   OfficerFirstName)
				VALUES ('#URL.Id#',
				    '#qTransaction.CustomerId#',
					'#qGetCandidate.BeneficiaryId#',
					'#qGetCandidate.LastName#',
					'#qGetCandidate.FirstName#',
					'#qGetCandidate.Relationship#',
					'#qGetCandidate.BirthDate#',
					'#qGetCandidate.Gender#',
					'1',
					'#session.acc#',
					'#session.last#',
					'#session.first#' )		  
				</cfquery>
			</cfif>			
		
		</cfif>	
		
		<cfset CountVar = CountVar + 1>
	</cfloop>	  
<cfelse>
	<cfset toRemove   = ExistingRows-URL.clines>
	<cfset CountVar = 1>
	<cfloop condition = "CountVar lte toRemove">

		<cfquery name="qCandidateDisable"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT TOP 1 * FROM dbo.Sale#URL.Warehouse#Beneficiary
			WHERE TransactionId = '#URL.Id#'
			AND   Operational = '1'
			ORDER BY Created DESC
		</cfquery>

		<cfquery name="qUpdate"
			datasource="AppsTransaction" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE dbo.Sale#URL.Warehouse#Beneficiary
			SET Operational = '0'
			WHERE TransactionId = '#qCandidateDisable.TransactionId#'
			AND CustomerId = '#qCandidateDisable.CustomerId#'
			AND BeneficiaryId = '#qCandidateDisable.BeneficiaryId#'
		</cfquery>


		
		<cfset CountVar = CountVar + 1>
	</cfloop>	  
		
</cfif>