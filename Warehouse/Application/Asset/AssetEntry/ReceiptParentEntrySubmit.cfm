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
<cf_screentop html="no">
  
<!--- loop through entries, populate AssetItem and AssetItem and AssetItem Topic --->

<cf_verifyOperational 
         module="Accounting" 
		 Warning="No">

<cfif URL.Mode eq "Purchase">

		<cfquery name="Receipt" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Receipt R, 
			        PurchaseLineReceipt L 
			 WHERE  R.ReceiptNo = L.ReceiptNo 
			 AND    ReceiptId = '#URL.ID#' 
		</cfquery>
	
		<cfset rct  = DateFormat(Receipt.DeliveryDate, CLIENT.DateSQL)>
		<cfset mis  = Receipt.Mission>
		<cfset req  = Receipt.RequisitionNo>
		<cfset line = Receipt.ReceiptQuantity>
		<cfset curr = APPLICATION.BaseCurrency>
		<cfset prc  = Receipt.ReceiptAmountBaseCost>
		<cfset whs  = Receipt.Warehouse>
		
		 <cfquery name="Transaction" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT *
			 FROM   ItemTransaction  
			 WHERE  ReceiptId = '#URL.ID#'
		</cfquery>	
	
	<!--- remove entry + GL in item transaction --->
		
	<cfset tra   = "#Transaction.TransactionId#">
	
<cfelse>

	<cfset rct  = DateFormat(now(), CLIENT.DateSQL)>
	<cfset mis  = URL.Mission>
	<cfset curr = "#APPLICATION.BaseCurrency#">
	<cfset req  = "">
	<!--- to be made more dynamic --->
	
	<cfquery name="Check" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
		SELECT    *
		FROM      Warehouse
		WHERE     Mission = '#url.mission#'
		ORDER BY  SupplyWarehouse
	</cfquery>	
	
	<cfset whs  = "#check.Warehouse#">
	<cfset ln = "0">
		
	<cfquery name="ItemSel" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     Item I, 
		       ItemUoM U, 
			   Ref_Category R
	  WHERE    U.ItemUoMId IN (#preservesinglequotes(FORM.ItemUoMId)#) 
	   AND     I.ItemNo = U.ItemNo
	   AND     I.Category = R.Category
	 ORDER BY  ItemDescription
	</cfquery>
	
	<cfloop index="itm" from="1" to="15">
	
	   <cfparam name="Form.Item_#ItemSel.ItemNo#_#itm#" default="">	
	   <cfset val   = Evaluate("Form.Item_#ItemSel.ItemNo#_#itm#")>  	   
	   <cfif val eq "1">
	       <cfset ln = ln+1>
	    </cfif>
		  
	</cfloop>
	
	<!--- lines to be split over the amount --->
	<cfset line = ln>
	
	<cfset tra = "{00000000-0000-0000-0000-000000000000}">

</cfif>

<cf_tl id="Asset journal has not been recorded." var="1">
<cfset msg1="#lt_text#">
		
<cf_tl id="Operation not allowed." var="1">
<cfset msg2="#lt_text#">

<cf_tl id="Accounting information has not been defined for" var="1" class="Message">
<cfset msg3="#lt_text#">			

<cf_tl id="Item does not have a standard cost defined." var="1">
<cfset msg4="#lt_text#">

<cftransaction>
	
	<cfquery name="Parameter" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM  Parameter
	</cfquery>
	
	<cfquery name="Mission" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  P.*, Org.OrgUnitName
	  FROM    Ref_ParameterMission P, 
	          Organization.dbo.Organization Org
	  WHERE   P.ReceiptOrgUnit = Org.OrgUnit
	  AND     P.Mission = '#mis#'
	  AND     Org.Mission = '#mis#' 
	</cfquery>
	
	<cfif Mission.recordcount eq "0">
	
		<cfquery name="Org" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT   TOP 1 *
		  FROM     Organization.dbo.Organization Org
		  WHERE    Mission = '#mis#'
		  ORDER BY HierarchyCode
		</cfquery>
	
		<cfquery name="UPDATE" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_ParameterMission
		  SET    ReceiptOrgUnit   = '#Org.OrgUnit#',
				 OfficerUserId 	  = '#SESSION.ACC#',
				 OfficerLastName  = '#SESSION.LAST#',
				 OfficerFirstName = '#SESSION.FIRST#',
				 Created          =  getdate()		  
		  WHERE  Mission = '#mis#'
		</cfquery>
		
		<cfquery name="Mission" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT  P.*, Org.OrgUnitName
		  FROM    Ref_ParameterMission P, 
		          Organization.dbo.Organization Org
		  WHERE   P.ReceiptOrgUnit = Org.OrgUnit
		  AND     P.Mission = '#mis#'
		  AND     Org.Mission = '#mis#' 
		</cfquery>
	
	</cfif>
	
	<!--- create a master movement id --->
	
	<cf_assignId>
	<cfset mid = RowGuid>
	
	<cfquery name="MovementRecord" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 INSERT INTO AssetMovement
		        (MovementId,
				 Mission,
				 MovementCategory, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName) 
		 VALUES ('#mid#',
		         '#mis#',
		         '001',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	</cfquery>
	
	<cfquery name="Item" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Item I, 
			       ItemUoM U, 
				   Ref_Category R
		  WHERE    U.ItemUoMId IN (#preservesinglequotes(FORM.ItemUoMId)#) 
		   AND     I.ItemNo = U.ItemNo
		   AND     I.Category = R.Category
		 ORDER BY  ItemDescription
	</cfquery>
	
	<!--- define the price --->
		
	<cfloop query="Item">
	    
		<!--- register a stock transaction and split this over the items selected  --->
		<cfset StandardCost = replace("#StandardCost#",",","")>
		
		<cfif URL.Mode eq "Purchase">
		
			<cfif item.recordcount gt "1">
		
				<cfquery name="Cost" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT  SUM(StandardCost) as Total
					  FROM    ItemUoM I
					  WHERE   ItemUoMId IN (#preservesinglequotes(FORM.ItemUoMId)#) 
				</cfquery>
			
				<cfif cost.total eq "0">
				
					<cf_waitEnd> 																			
					<cf_message message = "#msg2# #msg4#" return = "back">
					<cfabort>
					
				<cfelse>
				
					<cfset percent = StandardCost/Cost.Total>
					 
				</cfif>	 
			
			<cfelse>			
				
				<cfset percent = 1>
						
			</cfif>
			
			<!--- price	per lines * percentage if split over different items --->					
			<cfset price   = prc/line * percent>
			<cfset price   = (round(price*100))/100>
			
			<cfif ItemClass eq "Supply" and ValuationCode eq "Manual">	
							
				<cfset cst = StandardCost>
					  					
			<cfelse>						
			
				<cfset cst = price>						
				
			</cfif>							
			
		<cfelse>
		
		   <cfset price  = replace(Evaluate("Form.DepreciationBase_#ItemNo#"),",","")>
		   
		   <cfif ItemClass eq "Supply" and ValuationCode eq "Manual">	
							
				<cfset cst = StandardCost>
					  					
			<cfelse>						
			
				<cfset cst = price>						
				
			</cfif>	
				
		</cfif>	
		
		<cfset price  = replace(price,',','')>
		<cfset cst    = replace(cst,',','')>
			
		<cfif tra neq "">
		
		     <!--- undo prior entries here as part of confirmation --->
			 
			 <cfquery name="Transaction" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		    	 DELETE FROM ItemTransaction  
		    	 WHERE  TransactionId = '#tra#'
			 </cfquery>	
		 
		</cfif>
		 
		<cf_assignId>
		<cfset id = RowGuid>	
		
		<!--- record a stock transaction in quantity but NO ledger here --->
						
		<cf_StockTransact 
	            DataSource           = "AppsMaterials" 
				TransactionId        = "#id#"
	            TransactionType      = "1"
	            ItemNo               = "#ItemNo#" 
				Warehouse            = "#Whs#" 
				TransactionUoM       = "#UOM#"
				TransactionCurrency  = "#curr#"
				TransactionCategory  = "Receipt"
				ReceiptCostPrice     = "#price#"
				TransactionCostPrice = "#cst#"
				TransactionQuantity  = "#line#"
				TransactionDate      = "#dateFormat(now(), CLIENT.DateFormatShow)#"
				ReceiptId            = "#URL.ID#"
				OrgUnit              = "#Mission.ReceiptOrgUnit#"
				Remarks              = "Receipt"
				Ledger               = "No">  <!--- DO NOT MAKE A LEDGER ENTRY, THIS WILL HAPPEN BELOW --->
 
	    <!--- create asset item entry --->
	
	    <cfset ass = "#ItemNo#">
	
	    <cfset dMake               = Evaluate("Form.Make_#ItemNo#")>		
	    <cfset dModel              = Evaluate("Form.Model_#ItemNo#")>		
		
	    <cfset DescriptionAdd     = Evaluate("Form.Description_#ItemNo#")>
		
	    <cfif VolumeManagement eq "1">
		
			  <cfset ItemWeight         = Evaluate("Form.ItemWeight_#ItemNo#")>
			  <cfset ItemVolume         = Evaluate("Form.ItemVolume_#ItemNo#")>
		  
	    </cfif>
		
	    <cfset MakeNo             = Evaluate("Form.MakeNo_#ItemNo#")>
	    <cfset InspectionNo       = Evaluate("Form.InspectionNo_#ItemNo#")>
	    <cfset InspectionDate     = Evaluate("Form.InspectionDate_#ItemNo#")>
		<cfset Source             = Evaluate("Form.Source_#ItemNo#")>
	  
	    <cfset dateValue = "">
	    <CF_DateConvert Value="#InspectionDate#">
	    <cfset dte = dateValue>
	  
	    <cfset ln = 0>
		
	   <!--- record each item + ledger action one by one action to allow for depreciation --->
	       
	  <cfloop index="itm" from="1" to="#line#">
	        	
		   <cfparam name="Form.Item_#Ass#_#itm#" default="">	
		   
		   <cfset Item          = Evaluate("Form.Item_#Ass#_#itm#")>  
		   
		   <cfif Item eq "1">
		      
			   <cfset SerialNo      = Evaluate("Form.SerialNo_#Ass#_#itm#")>
			   <cfset DecalNo       = Evaluate("Form.DecalNo_#Ass#_#itm#")>
			   <cfset Barcode       = Evaluate("Form.Barcode_#Ass#_#itm#")>
			   <cfset SourceNo      = Evaluate("Form.SourceNo_#Ass#_#itm#")>
			   <cfset ItemMemo      = Evaluate("Form.Memo_#Ass#_#itm#")>
			  			  	 	   
			   <cfset ln = ln + 1>
			   
			   <cf_assignId>
			   
			   <cfset aid = rowguid>
			   
			   <!--- check serialNo --->
			   
			   <cfif Parameter.VerifySerialNo eq "1" and serialNo neq "">  
			   
				   <cfquery name="check" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  	SELECT   *
						FROM     AssetItem
						WHERE    SerialNo = '#SerialNo#'
					</cfquery>
				   
				   <cfif check.recordcount gte "1"> 
				   
					    <cf_waitEnd> 						
						<cf_message message = "This serialNo is already in use" return = "back">
						<cfabort>
				   	
				   </cfif>
			   
			   </cfif>	
			   
			   <cfquery name="Insert" 
				 datasource="appsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 INSERT INTO AssetItem
						 (AssetId,
						  TransactionId,
						  Mission, 
						  ItemNo, 
						  SerialNo,
						  Model,
						  Make,
						  MakeNo,
						  Source,
						  InspectionNo,
						  InspectionDate,
						  <cfif VolumeManagement eq "1">
							  ItemWeight,
							  ItemVolume,
						  </cfif>
						  ItemMemo,
						  Description,
						  AssetBarCode,		
						  AssetDecalNo,	  
						  AssetSourceNo,
						  ReceiptId,
						  ReceiptDate,
						  RequisitionNo,
						  DepreciationBase,
						  DepreciationCumulative,
						  DepreciationYearStart,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				 VALUES ('#aid#',
						 '#id#',
						 '#mis#',
						 '#ItemNo#',
						 '#SerialNo#',
						 '#dModel#',					 
						 '#dMake#',				
						 '#MakeNo#',
						 '#Source#',
						 '#InspectionNo#',
						 #dte#,
						 <cfif VolumeManagement eq "1">
							 '#ItemWeight#',
							 '#ItemVolume#',
						 </cfif>
						 '#ItemMemo#',
						 '#DescriptionAdd#',
						 '#BarCode#',	
						 '#DecalNo#',	
						 '#SourceNo#',		 
						 '#URL.ID#',
						 '#rct#',
						 '#req#',
						 '#round(baseprice*100)/100#',
						 '0',
						 '#year(now())#',
						 '#SESSION.acc#',
						 '#SESSION.last#',
						 '#SESSION.first#')
				</cfquery>
				
				<!--- ---------------------------------- --->
				<!--- ---- insert operation actions ---- --->
				<!--- ---------------------------------- --->
				
				<cfquery name="InsertOperations" 
				 datasource="appsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					INSERT INTO AssetItemAssetAction
							 (AssetId,
							 ActionCategory, 
							 Operational,							
							 OfficerUserId, OfficerLastName, OfficerFirstName)				  
					SELECT   '#aid#',
					         ActionCategory, 	
							 '1',						
							 '#SESSION.acc#', 
							 '#SESSION.last#', 
							 '#SESSION.first#'
					FROM     Ref_AssetActionCategory
					WHERE    Category = '#Category#'				
				</cfquery>		
				
				<!--- in case of initial entry there is nothing to log, this work
				differently now as per revised model, only when you
				change matters 				
				
				<!--- ---------------------------------- --->
				<!--- ------ logging of attributes------ --->
				<!--- ---------------------------------- --->
				
				<cfquery name="InsertLog" 
				 datasource="appsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 INSERT INTO AssetItemLog
					 
							(AssetId,
							 DateEffective, 
							 Mission, 
							 ProgramCode, 
							 ItemNo, 
							 SerialNo, 
							 Make,
							 MakeNo, 
							 Model, 
							 Description, 
							 AssetBarCode, 
							 AssetDecalNo,
							 AssetSourceNo,
							 ReceiptDate, 
							 InspectionNo,InspectionDate, 
							 ItemWeight,ItemVolume, 
							 ItemMemo, 
							 DepreciationBase,DepreciationYearStart, 
							 Operational,
							 OfficerUserId, 
							 OfficerLastName, 
							 OfficerFirstName)				  
							 
					SELECT   '#aid#',
					         getDate(), 
							 Mission, 
							 ProgramCode, 
							 ItemNo, 
							 SerialNo, 
							 Make, 
							 MakeNo, 
							 Model, 
							 Description, 
							 AssetBarCode, 
							 AssetDecalNo,
							 AssetSourceNo,
							 ReceiptDate, 
							 InspectionNo, 
							 InspectionDate, 
							 ItemWeight, 
							 ItemVolume, 
							 ItemMemo, 
							 DepreciationBase, 
							 DepreciationYearStart, 
							 Operational, 
							 '#SESSION.acc#', 
							 '#SESSION.last#', 
							 '#SESSION.first#'
							 
					FROM     AssetItem
					WHERE    AssetId = '#aid#'				
					
				</cfquery>		
				
				--->
				
				<!--- ---------------------------------- --->
				<!--- ---------- organization  --------- --->
				<!--- ---------------------------------- --->	
															
				<cfquery name="InsertOrganization" 
				 datasource="appsMaterials" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
					 INSERT INTO AssetItemOrganization
							 (AssetId, 
							  MovementId, 
							  OrgUnit, 
							  DateEffective, 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName)
					 VALUES 
							 ('#aid#', 
							  '#mid#', 
							  '#Mission.ReceiptOrgUnit#', 
							  '#DateFormat(now(),CLIENT.DateSQL)#', 
							  '#SESSION.acc#', 
							  '#SESSION.last#', 
							  '#SESSION.first#') 
				</cfquery>
				 
				 <!--- insert GL record for receipt --->
				 <!--- header --->
				 
				<cfset st = "1">
				 
				<cf_verifyOperational 
					 datasource="appsMaterials"
			         module="Accounting" 
					 Warning="No">
				 				 			 			 
				<cfif ModuleEnabled eq "1">
				 
					 <cfquery name="Journal" 
					    datasource="appsMaterials" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					    SELECT    *
						FROM      Accounting.dbo.Journal
						WHERE     Mission       = '#mis#' 
						AND       SystemJournal = 'Asset'
						AND       Currency      = '#curr#' 
					 </cfquery>
					 
					 <cfif Journal.recordcount eq "0">
						
						<cf_waitEnd> 						
						<cf_message message = "#msg1# #msg2#" return = "back">
						<cfabort>
			  
					</cfif>  
				 							
					 <cf_GledgerEntryHeader
					        Datasource            = "appsMaterials"
							Mission               = "#mis#"
						    OrgUnitOwner          = "#Mission.ReceiptOrgUnit#"
						    Journal               = "#Journal.Journal#"
							Description           = "#DescriptionAdd#"
							TransactionSource     = "AssetSeries"
							TransactionCategory   = "Memorial"
							MatchingRequired      = "0"
							Reference             = "Receipt"       
							ReferenceName         = "#Mission.OrgUnitName#"
							ReferenceId           = "#id#"
							ReferenceNo           = "#ItemNo#"
							DocumentCurrency      = "#curr#"
							DocumentDate          = "#DateFormat(now(),CLIENT.DateFormatShow)#"
							DocumentAmount        = "#price#"
							ParentJournal         = ""
							ParentJournalSerialNo = "">
			
					 <!--- Lines asset --->
						 
					 <!--- ---------------------- --->	 
					 <!--- define account receipt --->
					 <!--- ---------------------- --->
					 
					 <cfparam name="Form.ReceiptAccount" default="">
					 
					 <cfif Form.ReceiptAccount eq "">
					 
						 <cfquery name="Class" 
						    datasource="appsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Ref_CategoryGledger R
							WHERE     Category = '#Category#'
							AND       (Mission  = '#mis#' or Mission is NULL) 
							AND       Area = 'Receipt' 
							AND       GLAccount IN (SELECT GLAccount 
							                        FROM Accounting.dbo.Ref_Account
													WHERE GLAccount = R.GLAccount)
						 </cfquery>
						 
						 <cfset GLReceipt = Class.GLAccount>
					 
					 <cfelse>
					 						 
					 	<cfset GLReceipt = Form.ReceiptAccount>
						
					 </cfif>	
						 
					 <!--- define account asset --->
						 
						 <cfquery name="Class" 
						    datasource="appsMaterials" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
						    SELECT    *
						    FROM      Ref_CategoryGledger R
							WHERE     Category = '#Category#'
							AND       (Mission  = '#mis#' or Mission is NULL) 
							AND       Area     = 'Stock' 
							AND       GLAccount IN (SELECT GLAccount 
						                            FROM   Accounting.dbo.Ref_Account
												    WHERE  GLAccount = R.GLAccount)
						 </cfquery>
						 
						<cfset GLAsset = Class.GLAccount>
						
						<cfif GLAsset eq "" or GLReceipt eq "">
							  
							 <cf_message message = "#msg3# <cfoutput>#Category#</cfoutput>."
		            	         return = "back">
								 <cfabort>
													 								 
						<cfelse>		 
							                   								
							<cf_GledgerEntryLine
							    Datasource            = "appsMaterials"
								Lines                 = "2"
							    Journal               = "#Journal.Journal#"
								JournalNo             = "#JournalTransactionNo#"
								Currency              = "#curr#"
								
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
				 
				<!--- ---------------------------------- --->
				<!--- ------------ location    --------- --->
				<!--- ---------------------------------- --->
	 					 
				 <cfif Mission.ReceiptLocation neq "">
				 
					 <cfquery name="InsertLocation" 
					 datasource="appsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						 INSERT INTO AssetItemLocation
						 (AssetId, 
						  MovementId, 
						  Location, 
						  Status, 
						  DateEffective, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)
						 VALUES
						 ('#aid#', 
						  '#mid#', 
						  '#Mission.ReceiptLocation#', 
						  '#Parameter.ReceiptStatus#', 
						  '#DateFormat(now(),CLIENT.DateSQL)#',
						  '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#')
					 </cfquery>
				 
				 </cfif>
				 
				<!--- ------------------------------------- --->
				<!--- ---------- condition record --------- --->
				<!--- ------------------------------------- --->
	   
				 <cfquery name="Default" 
					 datasource="AppsMaterials" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 
					 INSERT INTO AssetItemAction
					 
						 (AssetId,ActionDate,ActionCategory,ActionCategoryList,OfficerUserid,OfficerLastName,OfficerFirstName)
						 
						 SELECT '#aid#',
						         '#dateformat(now(),client.dateSQL)#',
								 Code, 
								 ListCode,
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#'
								 
						 FROM    Ref_AssetActionList  
						 WHERE   Code = 'Condition'
						 AND     ListDefault = 1
						 
				 </cfquery>	   
								 
				<!--- ---------------------------------- --->
				<!--- ---------- custom fields --------- --->
				<!--- ---------------------------------- --->
					
				<cfquery name="GetTopics" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  SELECT *
						  FROM   Ref_Topic
						  WHERE  Code IN (SELECT Code 
				                 FROM   ItemTopic 
								 WHERE ItemNo = '#Ass#')
						  AND Operational = 1			
						  AND TopicClass = 'Asset'
				</cfquery>
							
				<cfloop query="getTopics">
				
				    <cfif ValueClass eq "List">
					
						<cfparam name="Form.Topic_#Ass#_#Code#" default="">			
		  		        <cfset value  = Evaluate("Topic_#Ass#_#Code#")>
																		
						 <cfquery name="GetList" 
								  datasource="AppsMaterials" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  SELECT *
								  FROM Ref_TopicList T
								  WHERE T.Code = '#Code#'
								  AND   T.ListCode = '#value#'				  
						</cfquery>
									
						<cfif value neq "">
									
						<cfquery name="InsertTopics" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  INSERT INTO AssetItemTopic
						 		 (AssetId,Topic,ListCode,TopicValue)
						  VALUES ('#aid#','#Code#','#value#','#getList.ListValue#')
						</cfquery>
						
						</cfif>
						
					<cfelse>
					
						<cfif ValueClass eq "Boolean">
						
							<cfparam name="Form.Topic_#Ass#_#Code#" default="0">
							
						</cfif>
						
						<cfparam name="Form.Topic_#Ass#_#Code#" default="">			
		  		        <cfset value  = Evaluate("Form.Topic_#Ass#_#Code#")>
						
						<cfif value neq "">
						
							<cfquery name="InsertTopics" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  INSERT INTO AssetItemTopic
							 		 (AssetId, Topic, TopicValue)
							  VALUES ('#aid#','#Code#','#value#')
							</cfquery>	
						
						</cfif>
					
					</cfif>	
							
				</cfloop>
							  				 	
			</cfif>	  
			
	  </cfloop>
	     
	  <cfquery name="Transaction" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE   ItemTransaction  
		 SET      TransactionQuantity = '#ln#'
		 WHERE    TransactionId       = '#id#'
	   </cfquery>		  
	        
	</cfloop>
	
</cftransaction>

<cfoutput>
	
	<cfif URL.Mode eq "Purchase">
	
		<script language="JavaScript">		   
		   parent.opener.history.go()	
		   parent.window.close()	  
		</script>
		
	<cfelseif URL.Mode eq "Workorder">
	
		<script language="JavaScript">		   
		   parent.opener.receiptrefresh('#aid#')			   
		   parent.window.close()
		</script>	
	
	<cfelse>
	
		<cfoutput>
		
			<cf_tl id="Non-Expendable item(s) were recorded." var="1" class="Message">
			
			<cfset msg1="#lt_text#">
				
			<script language="JavaScript">
			   alert("#ln# #msg1#")
			   ptoken.location("#SESSION.root#/Warehouse/Application/Asset/Item/ItemSearchMaster.cfm?Mission=#URL.Mission#")
			   
		    </script>
			
		</cfoutput>
	
	</cfif>

</cfoutput>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            