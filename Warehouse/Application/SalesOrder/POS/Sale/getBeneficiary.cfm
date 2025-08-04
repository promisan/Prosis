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

<cfquery name="qRelationship"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT Relationship
      ,Description
      ,ListingOrder
      ,OfficerUserId
      ,OfficerLastName
      ,OfficerFirstName
      ,Created
  	FROM Employee.dbo.Ref_Relationship
</cfquery>

<cfquery name="qTransaction"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
	SELECT   *
	FROM  vwCustomerRequest
	<cfif url.id neq "">
		WHERE    TransactionId = '#url.id#'
	<cfelse>
		WHERE    1=0
	</cfif>
</cfquery>


<cfinclude template="PreparationBeneficiary.cfm">

<cfquery name="qBeneficiaries"
	datasource="AppsTransaction"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT * FROM dbo.Sale#URL.Warehouse#Beneficiary
	WHERE TransactionId = '#URL.Id#'
	AND Operational = '1'
</cfquery>


<cfoutput>
<!-- <cfform> -->
<table  width="99%">
	
			<cfset i = 0>
			<cfloop query="qBeneficiaries">
				<cfset i = i + 1>
				
				<cfquery name="checkBeneficiary"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    CustomerBeneficiary CB
						WHERE   CustomerId 		= '#qBeneficiaries.CustomerId#'
				</cfquery>				
				
			 	<tr class="line" style="height:20px">
			 		
					<td style="height:20px;padding-left:3px" width="2%" align="right">
						<img src="#SESSION.root#/images/Clear-Blue.png" 
						     alt="Remove Beneficiary" border="0" width="18" height="16" style="cursor:pointer" class="clsNoPrint" 
						     onclick="_cf_loadingtexthtml='';ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setBeneficiary.cfm?warehouse=#url.warehouse#&BeneficiaryId=#qBeneficiaries.BeneficiaryId#&id=#transactionid#&CustomerId=#qBeneficiaries.CustomerId#&crow=#url.crow#&action=delete','Beneficiary_#url.crow#')">
						
					</td>
					<td style="height:20px;padding-left:3px" width="2%" align="right">						
						
						<cfquery name="AllBeneficiaries"
							datasource="AppsTransaction" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT CustomerId,BeneficiaryId, FirstName,LastName
							FROM dbo.Sale#URL.Warehouse#Beneficiary WB
							WHERE CustomerId 	= '#qBeneficiaries.CustomerId#'
							AND   BeneficiaryId != '#qBeneficiaries.BeneficiaryId#'
							AND   Operational = '1'
							AND   Len(FirstName)>2
							AND NOT EXISTS
							(
								SELECT 'X'
								FROM dbo.Sale#URL.Warehouse#Beneficiary WB2
								WHERE WB2.TransactionId = '#URL.Id#'
								AND   WB2.CustomerId    = WB.CustomerId
								AND   WB2.BeneficiaryId = WB.BeneficiaryId
								AND   WB2.Operational = '1'				
							)			
							UNION
							SELECT CustomerId,BeneficiaryId, FirstName,LastName
							FROM Materials.dbo.CustomerBeneficiary CB
							WHERE  CustomerId 	= '#qBeneficiaries.CustomerId#'
							AND NOT EXISTS
							(
								SELECT 'X'
								FROM dbo.Sale#URL.Warehouse#Beneficiary WB
								WHERE WB.TransactionId = '#URL.Id#'
								AND   WB.CustomerId    = CB.CustomerId
								AND   WB.BeneficiaryId   = CB.BeneficiaryId
								AND   WB.Operational = '1'				
							)
							AND   Len(FirstName)>2
						</cfquery>							
												
						<cfif AllBeneficiaries.recordcount neq 0>
							<img src="#SESSION.root#/images/circulation-blue.png" 
						     alt="Change Beneficiary" border="0" width="24" height="24" style="cursor:pointer" class="clsNoPrint" 
						     onclick="_cf_loadingtexthtml='';ptoken.navigate('#client.virtualdir#/warehouse/Application/SalesOrder/POS/Sale/setBeneficiary.cfm?warehouse=#url.warehouse#&BeneficiaryId=#qBeneficiaries.BeneficiaryId#&id=#transactionid#&CustomerId=#qBeneficiaries.CustomerId#&crow=#url.crow#&action=change','Beneficiary_detail_#url.crow#_#i#')">
							 
						</cfif>     
						
					</td>					
					
					<td  align="right" style="height:20px;padding-right:5px" width="80%" id="Beneficiary_detail_#url.crow#_#i#">
						<cfinclude template="getBeneficiaryLine.cfm">
					</td>
					<td width="30%"></td>
				</tr>
				
			</cfloop>
</table>	
<!-- </cfform> -->		
</cfoutput>

<cfset ajaxonload("doCalendar")>