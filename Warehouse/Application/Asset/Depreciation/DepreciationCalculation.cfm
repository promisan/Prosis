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

<!--- steps

1.  Select items that have a depreciation start <= selection year + mission 
2.  Define total amount value for each item from GLedger module (debit/credit)
--->
	
<cf_verifyOperational module="Accounting" Warning="No">

<cfif Operational eq "0">

	 <cf_tl id = "Depreciation requires the General Ledger module to be activated." class = "message" var = "vMsg1">
	 <cf_tl id = "Operation aborted." class = "message" var = "vMsg2">
     <cf_message message = "#vMsg1# #vMsg2#" return = "no">
     <cfabort>

</cfif>

 <cf_tl id="Accounting information has not been defined for" class="Message" var="accountinfo">
					

<cfquery name="Journal" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    TOP 1 *
    FROM      Journal J
	WHERE     SystemJournal = 'Asset'
	AND       Mission = '#URL.Mission#'
 </cfquery>
			 
<cfif Journal.recordcount eq "0">
 
 	 <cf_tl id = "Problem, Asset Journal has not been configured" class = "message" var = "vMsg3">
	 <cf_message message="#vMsg3#">
	 <cfabort>
 
</cfif>		

<cfquery name="Ledger" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_ParameterMission
	WHERE     Mission = '#URL.Mission#'
 </cfquery> 
  		 
<cfif Ledger.CurrentAccountPeriod eq "">
  	 <cf_tl id = "Problem, The default Accounting Period has not been configured for this tree" class = "message" var = "vMsg4">
	 <cf_message message="#vMsg4#">
	 <cfabort>
 
</cfif>		

<cfparam name="URL.Mission" default="">
<cfparam name="URL.Year"    default="#Form.Year#">

<cfquery name="check" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Period
	WHERE     AccountYear = '#url.year#'
</cfquery> 

<cfif check.recordcount eq "1">

	<cfset acp = Check.AccountPeriod>

<cfelse>
		
	<cfquery name="Ledger" 
	    datasource="appsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      Ref_ParameterMission
		WHERE     Mission = '#URL.Mission#'
	 </cfquery> 
 
	 <cfset acp = Ledger.CurrentAccountPeriod>

</cfif>


<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Depreciation1"> 

<cfquery name="Asset"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  I.AssetId, 
	        I.TransactionId,
			I.ReceiptId,
	        I.ItemNo,
			I.Description,
	        P.DepreciationScale,
			P.Category,
	        I.DepreciationBase, 
			I.DepreciationYearStart, 
			SUM(L.AmountBaseDebit) AS Debit, 
			SUM(L.AmountBaseCredit) AS Credit
	FROM    Materials.dbo.Item P INNER JOIN
	        Materials.dbo.AssetItem I ON P.ItemNo = I.ItemNo LEFT OUTER JOIN
	        TransactionLine L ON I.AssetId = L.ReferenceId 
				AND L.GLAccount IN
				         (SELECT   GLAccount
				  	      FROM     Accounting.dbo.Ref_Account
					  	  WHERE    AccountClass = 'Result')
		    	
	WHERE   I.Mission = '#URL.Mission#'
	AND     P.DepreciationScale is not NULL
	AND     I.DepreciationYearStart <= '#URL.Year#'
	AND     I.Operational = '1' <!--- exclude items that are disposed --->
	
	GROUP BY I.AssetId, 
	         I.TransactionId, 
	         I.ItemNo, 
			 I.ReceiptId,
			 I.Description, 
			 P.Category, 
			 P.DepreciationScale, 
			 I.DepreciationBase, 
			 I.DepreciationYearStart 		 
		 
</cfquery>

<cftransaction>

<cfloop query = "Asset">

	<cfquery name="Unit"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  TOP 1 *
		FROM    AssetItemOrganization
		WHERE AssetId = '#AssetId#'
		ORDER By DateEffective DESC
	</cfquery>
	
	<cfquery name="Org"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Organization.dbo.Organization
		WHERE  OrgUnit = '#UNIT.OrgUnit#'		
	</cfquery>

	<!--- define difference between years --->
	
	<cfset yr = URL.Year - Asset.DepreciationYearStart + 1>
	
	<!--- Check if Item exist for a receipt transaction --->
	
	<cfquery name="Check"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Accounting.dbo.TransactionLine
		WHERE    ReferenceId = '#AssetId#'
		AND      Reference = 'Receipt'		
	</cfquery>	
	
	<cfif Check.recordcount eq "0">
	
			 <cf_GledgerEntryHeader
				        Datasource            = "appsMaterials"
						Mission               = "#URL.Mission#"
					    OrgUnitOwner          = "#Unit.OrgUnit#"
					    Journal               = "#Journal.Journal#"
						Description           = "#Description#"
						TransactionSource     = "AssetSeries"
						AccountPeriod         = "#acp#"
						TransactionCategory   = "Memorial"
						MatchingRequired      = "0"
						Reference             = "Receipt"       
						ReferenceName         = "#Org.OrgUnitName#"
						ReferenceId           = "#Receiptid#"
						ReferenceNo           = "#ItemNo#"
						DocumentCurrency      = "#APPLICATION.BaseCurrency#"
						DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
						DocumentAmount        = "#DepreciationBase#"
						ParentJournal         = ""
						ParentJournalSerialNo = "">
		
				 <!--- Lines asset --->
					 
				 <!--- define account receipt --->
				 
				 <cfquery name="Class" 
				    datasource="appsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Ref_CategoryGledger
					WHERE     Category = '#Category#'
					AND       (Mission  = '#URL.Mission#' or Mission is NULL) 
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
						AND       (Mission  = '#URL.Mission#' or Mission is NULL) 
						AND       Area     = 'Stock' 
					 </cfquery>
					 
					<cfset GLAsset = Class.GLAccount>
					
					<cfif GLAsset eq "" or GLReceipt eq "">
												     
						 <cf_tl id="Accounting information has not been defined for" class="Message" var="1">
						 
						 <cf_message message = "#lt_text# <cfoutput>#Category#</cfoutput>."  return = "back">
							 <cfabort>
												 								 
					<cfelse>		 
						                   								
						<cf_GledgerEntryLine
						    Datasource            = "appsMaterials"
							Lines                 = "2"
						    Journal               = "#Journal.Journal#"
							JournalNo             = "#JournalTransactionNo#"
							AccountPeriod         = "#acp#"
							Currency              = "#APPLICATION.BaseCurrency#"
							
							TransactionSerialNo1  = "1"
							Class1                = "Debit"
							Reference1            = "Receipt"       
							ReferenceName1        = "#Org.OrgUnitName#"
							Description1          = ""
							GLAccount1            = "#GLAsset#"
							Costcenter1           = "#Unit.OrgUnit#"
							ProgramCode1          = ""
							ProgramPeriod1        = ""
							ReferenceId1          = "#AssetId#"
							ReferenceNo1          = "#ItemNo#"
							TransactionType1      = "Standard"
							Amount1               = "#DepreciationBase#"
							
							TransactionSerialNo2  = "2"
							Class2                = "Credit"
							Reference2            = "Receipt"       
							ReferenceName2        = "#Org.OrgUnitName#"
							Description2          = ""
							GLAccount2            = "#GLReceipt#"
							Costcenter2           = "#Unit.OrgUnit#"
							ProgramCode2          = ""
							ProgramPeriod2        = ""
							ReferenceId2          = "#AssetId#"
							ReferenceNo2          = "#ItemNo#"
							TransactionType2      = "Standard"
							Amount2               = "#DepreciationBase#">
							
					</cfif>		
					
	</cfif>		
	
	
	<!--- define cum depreciation --->
	
	
<cfquery name="GetAsset"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  SUM(L.AmountBaseDebit) AS Debit, 
			SUM(L.AmountBaseCredit) AS Credit
	FROM    Materials.dbo.Item P INNER JOIN
	        Materials.dbo.AssetItem I ON P.ItemNo = I.ItemNo LEFT OUTER JOIN
	        Accounting.dbo.TransactionLine L ON I.AssetId = L.ReferenceId 
				AND L.GLAccount IN
				         (SELECT   GLAccount
				  	      FROM     Accounting.dbo.Ref_Account
					  	  WHERE    AccountClass = 'Result')
		    	
	WHERE   I.Mission 		= '#URL.Mission#'
	AND		I.AssetId 		= '#AssetId#'
	AND 	L.Reference 	!= 'Receipt'
	AND     P.DepreciationScale is not NULL
	AND     I.DepreciationYearStart <= '#URL.Year#'
	AND     I.Operational = '1' <!--- exclude items that are disposed --->
		 
</cfquery>
	
	<cfquery name="Scale"
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ScaleDetail
		WHERE    Code = '#Asset.DepreciationScale#'
		AND      AgeYear <= '#yr#'
		ORDER BY AgeYear DESC 
	</cfquery>
	
	<cfif scale.cumDepreciation neq "">
		<cfset cum = Scale.CumDepreciation>		
	<cfelse>
	    <cfset cum = "0">
	</cfif>
			
	<cfset cum = DepreciationBase * cum>

	<cfquery name="Update" 
	   datasource="appsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   UPDATE AssetItem
		   SET DepreciationCumulative = '#cum#'
		   WHERE AssetId = '#AssetId#'
	</cfquery>

	<cfif Operational eq "1">

	<cfif GetAsset.Credit eq "">
	 <cfset Cr = 0>
	<cfelse>
	 <cfset Cr = #GetAsset.Credit#>   
	</cfif>
	
	<cfif GetAsset.Debit eq "">
	 <cfset Db = 0>
	<cfelse> 
	 <cfset Db = #GetAsset.Debit#>   
	</cfif>
	
	<cfset diff = cum - (#Db# - #Cr#)>
		
	<cfif abs(diff) gt 1 and Unit.OrgUnit neq "">
					
			 <cf_GledgerEntryHeader
			        Datasource            = "appsMaterials"
					Mission               = "#URL.Mission#"
				    OrgUnitOwner          = "#Unit.OrgUnit#"
				    Journal               = "#Journal.Journal#"
					Description           = "#Description#"
					TransactionSource     = "AssetSeries"
					AccountPeriod         = "#acp#"
					TransactionCategory   = "Memorial"
					MatchingRequired      = "0"
					Reference             = "Depreciation"       
					ReferenceName         = "#URL.Year#"
					ReferenceId           = "#Asset.TransactionId#"
					ReferenceNo           = "#Asset.ItemNo#"
					DocumentCurrency      = "#APPLICATION.BaseCurrency#"
					DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
					DocumentAmount        = "#diff#"
					ExchangeRate          = "1"
					Currency              = "#APPLICATION.BaseCurrency#"
					ExchangeRateBase      = "1"
					Amount                = "#diff#"
					ParentJournal         = ""
					ParentJournalSerialNo = "">			    		 				  
				 
				  <!--- define balance depreciation --->
			 
				 <cfquery name="Class" 
				    datasource="appsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Ref_CategoryGledger
					WHERE     Category = '#Category#'
					AND       Area = 'Stock' 
				 </cfquery>
				 
				 <cfset GLAsset = Class.GLAccount>
				 
				  <!--- define account asset --->
				 
				 <cfquery name="Class" 
				    datasource="appsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
				    SELECT    *
				    FROM      Ref_CategoryGledger
					WHERE     Category = '#Category#'
					AND       Area = 'Depreciation' 
				 </cfquery>
				 
				<cfset GLDepreciation = Class.GLAccount>
				
				<cfif GLAsset eq "" or GLDepreciation eq "">
					 
					 <cf_message message = "#accountinfo# #Category#">
	                    <cfabort>
				</cfif>	   
							
				<cf_GledgerEntryLine
				    Datasource            = "appsMaterials"
					Lines                 = "2"
				    Journal               = "#Journal.Journal#"
					JournalNo             = "#JournalTransactionNo#"
					AccountPeriod         = "#acp#"
					ExchangeRate          = "1"
					Currency              = "#APPLICATION.BaseCurrency#"
					ExchangeRateBase      = "1"					
					TransactionSerialNo1  = "1"
					Description           = "#Description#"
					Class1                = "Debit"
					Reference1            = "Depreciation"       
					ReferenceName1        = "#URL.Year#"
					Description1          = ""
					GLAccount1            = "#GLDepreciation#"
					Costcenter1           = "#Unit.OrgUnit#"
					ProgramCode1          = ""
					ProgramPeriod1        = ""
					ReferenceId1          = "#AssetId#"
					ReferenceNo1          = "#ItemNo#"
					TransactionType1      = "Standard"
					Amount1               = "#diff#"
					
					TransactionSerialNo2  = "2"
					Class2                = "Credit"
					Reference2            = "Stock"       
					ReferenceName2        = "#URL.Year#"
					Description2          = ""
					GLAccount2            = "#GLAsset#"
					Costcenter2           = "#Unit.OrgUnit#"
					ProgramCode2          = ""
					ProgramPeriod2        = ""
					ReferenceId2          = "#AssetId#"
					ReferenceNo2          = "#ItemNo#"
					TransactionType2      = "Standard"
					Amount2               = "#diff#">
				
		 </cfif>		
	 	 
	</cfif>
	
</cfloop>


<cfquery name="Parameter" 
    datasource="appsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    UPDATE  Ref_ParameterMission
	SET     LastYearDepreciation = '#URL.Year#'
	WHERE   Mission = '#URL.Mission#'
 </cfquery>

</cftransaction>

<cf_tl id="Depreciation processing for" var="1">
<cfset msg1="#lt_text#">

<cf_tl id="has been completed and posted" var="1">
<cfset msg2="#lt_text#">

<table width="100%" height="100%"><tr><td bgcolor="white">

<cf_message message="#msg1# #URL.Year# #msg2#" return="false">

</td></tr></table>
 
<!---

3.  Define the real value based on the schedule

4.  Create transaction for the difference

--->