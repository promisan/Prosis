
<!--- 1 depreciate the value of the times 
      2. set status = 2 of AssetDisposal
	  3. set operation = 0 for asset item --->
	  
<cfparam name="Object.ObjectKeyValue4"    default="">
<cfparam name="url.disposalid"    default="#Object.ObjectKeyValue4#">

<cfquery name="Disposal" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM AssetDisposal
	WHERE DisposalId = '#object.ObjectKeyValue4#'	 
</cfquery>

<cfquery name="Journal" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    TOP 1 *
    FROM      Journal J
	WHERE     SystemJournal = 'Asset'
	AND       Mission = '#Disposal.Mission#'
 </cfquery>
			 
<cfif Journal.recordcount eq "0">
	 <cf_tl id="Problem, Asset Journal has not been configured" var="1"> 
	 <cf_message message="#lt_text#">
	 <cfabort>
 
</cfif>		

<cfquery name="Ledger" 
    datasource="appsLedger" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_ParameterMission
	WHERE     Mission = '#Disposal.Mission#'
</cfquery> 
  		 
<cfif Ledger.CurrentAccountPeriod eq "">
 
 	 <cf_tl id="Problem, The default Accounting Period has not been configured for this tree" var="1"> 
	 <cf_message message="#lt_text#">
	 <cfabort>
 
</cfif>		

<cfquery name="ListingDisposal" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM AssetItemDisposal
	WHERE DisposalId = '#object.ObjectKeyValue4#'	 
</cfquery>

<cftransaction>

	<cfloop query = "ListingDisposal">
		
		<cfquery name="Asset" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   AssetItem
			WHERE  AssetId = '#AssetId#'	 
		</cfquery>
		
		<cfquery name="Item" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Item
			WHERE  ItemNo = '#Asset.ItemNo#'	 
		</cfquery>
	
		<cfquery name="Unit"
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  TOP 1 *
			FROM    AssetItemOrganization
			WHERE   AssetId = '#AssetId#'
			ORDER By DateEffective DESC
		</cfquery>
						
		<cfset cum = Asset.DepreciationBase>
	
		<cfquery name="Update" 
		   datasource="appsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   UPDATE AssetItem
			   SET    DepreciationCumulative = '#cum#', 
			          Operational = 0
			   WHERE  AssetId = '#AssetId#'
		</cfquery>				
				
		<cfquery name="Value"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  SUM(L.AmountBaseDebit) AS Debit, 
				SUM(L.AmountBaseCredit) AS Credit
		FROM    Accounting.dbo.TransactionLine L
		WHERE   L.ReferenceId = '#Assetid#'
		AND    (L.GLAccount IN
		              (SELECT   GLAccount
		               FROM     Accounting.dbo.Ref_Account
		               WHERE    AccountClass = 'Result'))
		</cfquery>
	
		<cfif Value.Credit eq "">
		 <cfset Cr = 0>
		<cfelse>
		 <cfset Cr = Value.Credit>   
		</cfif>
		
		<cfif Value.Debit eq "">
		 <cfset Db = 0>
		<cfelse> 
		 <cfset Db = Value.Debit>   
		</cfif>
		
		<cfset diff = cum - (Db - Cr)>
		
		<cfif abs(diff) gt 1 and Unit.OrgUnit neq "">
						
				 <cf_GledgerEntryHeader
				        Datasource            = "appsMaterials"
						Mission               = "#Disposal.Mission#"
					    OrgUnitOwner          = "#Unit.OrgUnit#"
					    Journal               = "#Journal.Journal#"
						Description           = "#Asset.Description#"
						TransactionSource     = "AssetSeries"
						AccountPeriod         = "#Ledger.CurrentAccountPeriod#"
						TransactionCategory   = "Memorial"
						MatchingRequired      = "0"
						Reference             = "Disposal"       
						ReferenceName         = "Disposal"
						ReferenceId           = "#Disposal.DisposalId#"
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
						WHERE     Category = '#Item.Category#'
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
						WHERE     Category = '#Item.Category#'
						AND       Area = 'WriteOff' 
					 </cfquery>
					 
					<cfset GLDisposal = Class.GLAccount>
					
					<cfif GLAsset eq "" or GLDisposal eq "">

					 	 <cf_tl id="Disposal Account has not been defined for" var="1"> 

						 <cf_message message = "#lt_text# <cfoutput>#Category#</cfoutput>."
		           	         return = "back">
		                    <cfabort>
					</cfif>	   
								
					<cf_GledgerEntryLine
					    Datasource            = "appsMaterials"
						Lines                 = "2"
					    Journal               = "#Journal.Journal#"
						JournalNo             = "#JournalTransactionNo#"
						AccountPeriod         = "#Ledger.CurrentAccountPeriod#"
						ExchangeRate          = "1"
						Currency              = "#APPLICATION.BaseCurrency#"
						ExchangeRateBase      = "1"					
						Description           = "#Asset.Description#"
						
						TransactionSerialNo1  = "1"
						Class1                = "Debit"
						Reference1            = "Disposal"       
						ReferenceName1        = "Disposal"
						Description1          = ""
						GLAccount1            = "#GLDisposal#"
						Costcenter1           = "#Unit.OrgUnit#"
						ProgramCode1          = ""
						ProgramPeriod1        = ""
						ReferenceId1          = "#AssetId#"
						ReferenceNo1          = "#Asset.ItemNo#"
						TransactionType1      = "Standard"
						Amount1               = "#diff#"
						
						TransactionSerialNo2  = "2"
						Class2                = "Credit"
						Reference2            = "Stock"       
						ReferenceName2        = "Disposal"
						Description2          = ""
						GLAccount2            = "#GLAsset#"
						Costcenter2           = "#Unit.OrgUnit#"
						ProgramCode2          = ""
						ProgramPeriod2        = ""
						ReferenceId2          = "#AssetId#"
						ReferenceNo2          = "#Asset.ItemNo#"
						TransactionType2      = "Standard"
						Amount2               = "#diff#">
					
		</cfif>		
		
	</cfloop>
		
	<cfquery name="Disposal" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE AssetDisposal
		SET ActionStatus = '2'
		WHERE DisposalId = '#object.ObjectKeyValue4#'	 
	</cfquery>

</cftransaction>
