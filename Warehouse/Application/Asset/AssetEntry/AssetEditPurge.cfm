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
<cfparam name="URL.assetId" default="">

<!--- Asset deletion --->

<cfquery name="Get" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   Materials.dbo.AssetItem
		 WHERE  AssetId = '#URL.AssetID#' 
		</cfquery>
<!--- The following steps are taken

1. Remove AssetItem (and copy to AssetItemDelete) --->

<cftransaction>

<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 DELETE FROM Materials.dbo.AssetItem
	 WHERE  AssetId = '#URL.AssetID#' 
</cfquery>

<!--- 2. Deduction quatity in ItemTransaction or delete if = 1 - delete, 2 -> 1 etc. --->

<!--- this will adjust the value as well --->

<cfquery name="DeleteLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 UPDATE Materials.dbo.ItemTransaction
	 SET    TransactionQuantity = TransactionQuantity-1
	 WHERE  TransactionId = '#Get.TransactionId#' 
</cfquery>

<!--- check if theire is a remainder --->

<cfquery name="DeleteLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 DELETE FROM Materials.dbo.ItemTransaction
	 WHERE  TransactionId = '#Get.TransactionId#' 
	 AND    TransactionQuantity = 0
</cfquery>

<!--- clear any transactions for this AID --->

<!--- select account code for contract booking --->
		
<cf_verifyOperational 
	 datasource="appsPurchase"
     module="Accounting" 
     Warning="No">
				 				 			 			 
<cfif ModuleEnabled eq "1">
	
	<cfquery name="getLines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT * FROM Accounting.dbo.TransactionLine
		 WHERE  ReferenceId = '#url.assetid#' 	
	</cfquery>
	
	<cfloop query="GetLines">
		
		<cfquery name="deleteLines" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			 DELETE FROM Accounting.dbo.TransactionHeader
			 WHERE  Journal = '#journal#' 	
			 AND   JournalSerialNo = '#journalserialno#'
		</cfquery>
	
	</cfloop>

</cfif>


<!---

<!--- 3. Make a negative GL transaction based on the transaction already recorded in GL using the 
ItemTransaction.TransactionId as the linkage, do not deduct the existing transaction --->

 <cf_GledgerEntryHeader
		Datasource            = "appsMaterials"
		Mission               = "#Get.Mission#"
	    // OrgUnitOwner          = "#Mission.ReceiptOrgUnit#"
	    Journal               = "#Journal.Journal#"
		Description           = "#DescriptionAdd#"
		TransactionSource     = "AssetSeries"
		TransactionCategory   = "Memorial"
		MatchingRequired      = "0"
		Reference             = "Asset Removal"       
		ReferenceName         = "#Mission.OrgUnitName#"
		ReferenceId           = "#Get.TransactionId#"
		ReferenceNo           = "#Get.ItemNo#"
		DocumentCurrency      = "#APPLICATION.BaseCurrency#"
		DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
		DocumentAmount        = "-#Get.DepreciationBase#"
		ParentJournal         = ""
		ParentJournalSerialNo = "">
						
	<!--- define account receipt --->
				 
				 <cfquery name="Class" 
				    datasource="appsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Ref_CategoryGledger
					WHERE     Category = '#Category#'
					AND       Mission  = '#mis#'
					AND       Area = 'Receipt' 
				 </cfquery>
					 
				 <cfset GLReceipt = Class.GLAccount>
					 
				 <!--- define account asset --->
					 
					 <cfquery name="Class" 
					    datasource="appsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      Ref_CategoryGledger
						WHERE     Category = '#Category#'
						AND       Mission  = '#mis#'
						AND       Area = 'Stock' 
					 </cfquery>
					 
					<cfset GLAsset = Class.GLAccount>
					
					<cfif GLAsset eq "" or GLReceipt eq "">
												     
						 <cf_tl id="Accounting information has not been defined for" class="Message">
						 
						 <cf_message message = "#lt_text# <cfoutput>#Parent.AssetClass#</cfoutput>."
	            	         return = "back">
							 <cfabort>
												 								 
					<cfelse>		 
						                   								
						<cf_GledgerEntryLine
						    Datasource            = "appsMaterials"
							Lines                 = "2"
						    Journal               = "#Journal.Journal#"
							JournalNo             = "#JournalTransactionNo#"
							Currency              = "#APPLICATION.BaseCurrency#"
							
							TransactionSerialNo1  = "1"
							Class1                = "Debit"
							Reference1            = "Receipt"       
							ReferenceName1        = "#Mission.OrgUnitName#"
							Description1          = ""
							GLAccount1            = "#GLAsset#"
							Costcenter1           = "#Mission.ReceiptOrgUnit#"
							ProgramCode1          = ""
							ProgramPeriod1        = ""
							ReferenceId1          = "#aid#"
							ReferenceNo1          = "#ItemNo#"
							TransactionType1      = "Standard"
							Amount1               = "#price#"
							
							TransactionSerialNo2  = "2"
							Class2                = "Credit"
							Reference2            = "Receipt"       
							ReferenceName2        = "#Mission.OrgUnitName#"
							Description2          = ""
							GLAccount2            = "#GLReceipt#"
							Costcenter2           = "#Mission.ReceiptOrgUnit#"
							ProgramCode2          = ""
							ProgramPeriod2        = ""
							ReferenceId2          = "#aid#"
							ReferenceNo2          = "#ItemNo#"
							TransactionType2      = "Standard"
							Amount2               = "#price#">
							
					</cfif>		
					
			 </cfif>								

 --->


<cfoutput>    
	
	<script>		    
		try { window.dialogArguments.opener.refreshlist() } catch(e) {}
		window.close()
	</script>	
	
</cfoutput>		
