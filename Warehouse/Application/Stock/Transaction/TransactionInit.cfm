<cfparam name="URL.Mode"               default="Initial">
<cfparam name="URL.SystemFunctionId"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.WorkorderId"        default="00000000-0000-0000-0000-000000000000">
<cfparam name="URL.WorkOrderline"      default="">
<cfparam name="URL.Warehouse"          default="">
<cfparam name="URL.id"                 default="">


<cfoutput>
<script>

	function processStockIssue(mode,warehouse,transtype,location,itemno,uom,batchid,menuid) { 
		vOpenDate = '';
		vCloseDate = '';
		vOpenTime = '';
		vCloseTime = '';	
		vActorList = '';	
		ptoken.navigate('../Transaction/Submission/TransactionSubmit.cfm?systemfunctionid='+menuid+'&batchid='+batchid+'&mode='+mode+'&warehouse='+warehouse+'&tratpe='+transtype+'&location='+location+'&itemno='+itemno+'&uom='+uom+'&tsOpenDate='+vOpenDate+'&tsOpenTime='+vOpenTime+'&tsCloseDate='+vCloseDate+'&tsCloseTime='+vCloseTime+vActorList,'detail');
	}	

    function delete_tmp_transaction(id,whs,mode) {
        ptoken.navigate('#SESSION.root#/warehouse/application/stock/transaction/transactiondetaillinesdelete.cfm?id='+id+'&warehouse='+whs+'&mode='+mode,'line_'+id);                         
    }	

</script>

</cfoutput>

<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->


<input type="hidden" id="workorderid" value="<cfoutput>#url.workorderid#</cfoutput>">

<cfif url.mode neq "workorder">
				 
	 <cfinvoke component = "Service.Access"  
	     method             = "WarehouseProcessor"  
		 role               = "'WhsPick'"
		 mission            = "#url.mission#"
		 warehouse          = "#url.warehouse#"		
		 SystemFunctionId   = "#url.SystemFunctionId#" 
		 returnvariable     = "access">	 	
	
	<cfif access eq "NONE">	 
	
		<table width="100%" height="100%" 
		       border="0" 
			   cellspacing="0" 			  
			   cellpadding="0" 
			   align="center">
			   <tr><td align="center" height="40">
			    <font face="Verdana" color="FF0000">
				<cf_tl id="Detected a Problem with your access"  class="Message">
				</font>
				</td></tr>
		</table>	
		<cfabort>	
			
	</cfif>		
	
<cfelse>

	<cfset access = "ALL">	 

</cfif>

<!--- -------------------- --->
<!--- create storage table --->
<!--- -------------------- --->

<!--- Adjustment to define an entry table per warehouse instead, to allow collaboration --->

<cftry>
		
	<cfquery name="Test"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT * FROM #tableName#
	</cfquery>

	<cfcatch>
		
		
		<CF_DropTable dbName="AppsTransaction" tblName="#tableName#"> 
		
		<cfquery name="CreateTable"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		CREATE TABLE dbo.#tableName# ( 
		    [TransactionId]  uniqueidentifier NULL ,
			[TransactionType] [varchar] (2) NULL ,
			[TransactionDate] [datetime] NULL ,
			[ItemNo] [varchar] (20) NULL ,
			[ItemDescription] [varchar] (200) NULL ,
			[ItemCategory] [varchar] (20) NULL ,
			[Mission] [varchar] (30) NULL ,
			[Warehouse] [varchar] (20) NULL ,
			[Location] [varchar] (20) NULL ,			
			[LocationTransfer] [varchar] (20) NULL ,
			[BillingMode] [varchar] (10) NULL ,
			[TransactionReference] [varchar] (20) NULL ,
			[TransactionLot] [varchar] (10) NULL ,
			[MovementUoM] [varchar] (30) NULL ,
			[MovementQuantity] [float] NULL ,
			[MovementUoMMultiplier] [float] NULL , 
			[TransactionUoM] [varchar] (30) NULL ,
			[TransactionQuantity] [float] NULL ,
			[TransactionUoMMultiplier] [float] NULL , 
			[TransactionQuantityBase] AS ([TransactionQuantity] * [TransactionUoMMultiplier]) , 
			[TransactionCostPrice] [float] NULL,
			[TransactionValue] AS ([TransactionQuantity] * [TransactionCostPrice]) ,
			[TransactionBatchNo] [int] NULL ,
			[CustomerId] [uniqueidentifier] NULL,
			[WorkorderId] [uniqueidentifier] NULL,
			[WorkorderLine] [int] NULL,
			[BillingUnit] [varchar] (10) NULL ,
			[Source] [varchar] (10) NULL ,
			[ProgramCode] [varchar] (20) NULL ,		
			[SalesCurrency] [varchar] (4) NOT NULL DEFAULT ('#application.BaseCurrency#') ,		
			[SalesPrice] [float] NULL ,
			[SalesValue] AS ([TransactionQuantity] * [SalesPrice]) ,
			[TaxCode] [varchar] (10) NULL ,
			[SalesTax] [float] NULL ,
			[SalesTotal] AS ([TransactionQuantity] * [SalesPrice] + [SalesTax]) ,	
			[AssetId] [uniqueidentifier] NULL,
			[AssetMetric1] [varchar] (40) NULL ,
			[AssetMetricValue1] [float] NULL ,
			[AssetMetric2] [varchar] (40) NULL ,
			[AssetMetricValue2] [float] NULL ,
			[AssetMetric3] [varchar] (40) NULL ,			
			[AssetMetricValue3] [float] NULL ,
			[AssetMetric4] [varchar] (40) NULL ,			
			[AssetMetricValue4] [float] NULL ,
			[AssetMetric5] [varchar] (40) NULL ,			
			[AssetMetricValue5] [float] NULL ,		

			[Event1] [varchar] (10) NULL ,			
			[EventDate1] [datetime] NULL ,			
			[EventDetails1] [varchar] (100) NULL,
			[Event2] [varchar] (10) NULL ,			
			[EventDate2] [datetime] NULL ,			
			[EventDetails2] [varchar] (100) NULL,
			[Event3] [varchar] (10) NULL ,			
			[EventDate3] [datetime] NULL ,			
			[EventDetails3] [varchar] (100) NULL,
			[Event4] [varchar] (10) NULL ,			
			[EventDate4] [datetime] NULL ,			
			[EventDetails4] [varchar] (100) NULL,
			[Event5] [varchar] (10) NULL ,			
			[EventDate5] [datetime] NULL ,			
			[EventDetails5] [varchar] (100) NULL,

			[PersonNo] [varchar] (20) NULL ,
			[OrgUnit] [int] NULL ,
			[OrgUnitCode] [varchar] (20) NULL ,
			[OrgUnitName] [varchar] (100) NULL ,
			[Remarks] [varchar] (200) NULL ,
			[GLAccountDebit] [varchar] (20) NULL ,
			[GLAccountCredit] [varchar] (20) NULL ,
			[OfficerUserId] [varchar] (20) NULL ,
			[Created] [datetime] NULL CONSTRAINT [DF_#tableName#] DEFAULT (getdate()) ,)
			
		</cfquery>		
	
	</cfcatch>

</cftry>

<cfset filter = "">

<cfif url.mode eq "initial">

    <cfset filter = "">
	<cfinclude template="TransactionEntry.cfm">
	
<cfelseif url.mode eq "sale">

    <cfset filter = "">
	<cfset url.id = "2">
	<cfinclude template="TransactionEntry.cfm">
	
<cfelseif url.mode eq "externalsale">

    <cfset filter = "">
	<cfset url.id = "2">
	<cfinclude template="TransactionEntry.cfm">	
	
<cfelseif url.mode eq "disposal">

    <cfset filter = "">
	<cfset url.id = "2">
	<cfinclude template="TransactionEntry.cfm">	
	
<cfelseif url.mode eq "issue">

    <cfset filter = "">
	<cfset url.id = "2">
	<cfinclude template="TransactionLogSheet.cfm">
	
<cfelse>
	
    <script src="TransactionScript.js"></script>
	<cfset url.id = "2">
	<cfajaximport tags="cfwindow,cfdiv">
	
	<cfquery name="Serviceitem"
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM   ServiceItemMaterials 
		WHERE  Serviceitem IN (SELECT ServiceItem 
		                      FROM   Workorder 
			  		          WHERE  WorkOrderId = '#url.workorderid#')	
		AND    MaterialsClass = 'Supply'			   
	</cfquery>		
		
	<cfset filter = "#Serviceitem.MaterialsCategory#">

	<cf_screentop height="100%"
		     label="Record Materials Transaction" 
			 option="Select supplies or service items" 
			 jQuery="Yes"
			 scroll="yes" 
			 layout="webapp" 
			 banner="blue">
			 		 
		 
		  <cfinclude template="TransactionEntry.cfm">
		  
	<cf_screenbottom layout="webapp">

</cfif>	

