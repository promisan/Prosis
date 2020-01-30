
<cfquery name="qMission" 
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT *
		FROM   WorkOrder.dbo.WorkOrder
		WHERE  WorkOrderId = '#URL.WorkOrderId#'
</cfquery>

<cfquery name="qSource" 
     datasource="AppsMaterials" 
	 username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT *
		FROM   userTransaction.dbo.FinalProduct_#session.acc#
		WHERE  WorkOrderId   = '#WorkOrderId#'
		AND    WorkOrderLine = '#URL.WorkOrderLine#'
		AND    Quantity > 0 
		AND    Quantity IS NOT NULL
		AND    Price > 0 
		AND    Price IS NOT NULL
</cfquery>

<cfset LIMIT = 6>
<cfset vResponse = "">

<CFLOOP query="qSource">	

	<cfif Memo eq "">
		<cfset SaleType = "Standard">
	<cfelse>
		<cfset SaleType = Memo>	
	</cfif>
		
	<cfquery name="qItem" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT ItemDescription,
			       ItemMaster,
				   Category,
				   CategoryItem,
				   Classification
			FROM   Materials.dbo.Item
			WHERE  ItemNo = '#ItemNo#'
	</cfquery>
	
	<cfquery name="qCost" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT  StandardCost
			FROM    ItemUoM
			WHERE   ItemNo = '#ItemNo#'
			AND     UoM    = '#UoM#'
	</cfquery>
	
	<cfquery name="qEntryClass" 
	     datasource="AppsMaterials" 
		 username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT EntryClass
			FROM   Purchase.dbo.ItemMaster
			WHERE  Code = '#qItem.ItemMaster#'
	</cfquery>

	<!--- 
	<cfif NOT ISDEFINED("APPLICATION.BaseCurrency")>
		<cfquery name="Parameter" 
	   	datasource="AppsSystem">
		    SELECT * 
			FROM Parameter
		</cfquery>
		<cfset 	APPLICATION.BaseCurrency= Parameter.BaseCurrency>
	</cfif>	
	<cfset vCurrency = APPLICATION.basecurrency>	
	--->
	
	<cfset vCurrency = qMission.currency>
	
	<cfset tPrice = Replace(qSource.Price, ",", "", "all")>
	
	<cfif qSource.Price neq "">
		<cfif qSource.Currency eq "">
			<cfset vPrice = tPrice>
		<cfelse>
			<cfif qSource.Currency neq vCurrency>
				<cfset exc = 0.00>
				<cf_exchangerate currencyfrom="#qSource.Currency#" currencyto="#vCurrency#" 
				                 datasource="AppsPurchase">
				<cfset vPrice = round(tPrice / exc * 100) / 100>
			<cfelse>
				<cfset vPrice = tPrice>
			</cfif>
		</cfif>
	<cfelse>
		<cfset vPrice = 0>
	</cfif>	
	
	<cfif qSource.ItemUoMIdFinalProduct eq "">
	
		<cfset aClassification = ArrayNew(1)>
		<cfset f_itm    = 1>
		<cfset UoMFound = FALSE>
		<cfset vItemUoM = "">
	
		<cfloop from="1" to="#LIMIT#" index="i">
		
			<cfset Class = Evaluate("qSource.Class#i#")>
			
			<cfif Class neq "">
			
				<cfquery name="qTopic" 
				      datasource="AppsMaterials" 
					  username="#SESSION.login#" 
				      password="#SESSION.dbpw#">					  
						SELECT T.Code, T.TopicLabel, ItemPointer
						FROM   Ref_Topic T, Ref_TopicEntryClass C
						WHERE  T.Code        = C.Code
						AND    EntryClass    = '#qEntryClass.EntryClass#'
						AND    T.Code        = '#Class#'
						AND    T.Operational = 1					
				</cfquery>
			
				<cfset ListCode  = Evaluate("qSource.Class#i#ListCode")>
				<cfset ListValue = Evaluate("qSource.Class#i#ListValue")>
			
				<cfif qTopic.ItemPointer eq "Uom">
				
					<cfif ListCode neq "">
					
						<cfset UoMFound = TRUE>
						<cfset vItemUoMCode = ListCode>
						
						<!--- we also try to re-associate this to the try UoM Id of the parent --->
						
						<cfquery name="getParentUoM" 
					      datasource="AppsMaterials" 
						  username="#SESSION.login#" 
					      password="#SESSION.dbpw#">					  
								SELECT *
								FROM   ItemUoM
								WHERE  ItemNo   = '#qSource.ItemNo#'
								AND    UoMCode  = '#vItemUoMCode#'										
						</cfquery>
						
						<cfif getParentUoM.recordcount eq "1">
						
							<!--- we inherit the id and the description --->
						
							<cfset vItemUoM      = getParentUoM.UoM>
							<cfset vItemUoMLabel = getParentUoM.UoMDescription>
												
						<cfelse>
						
							<cfset vItemUoM      = vItemUoMCode>
							<cfset vItemUoMLabel = vItemUoMCode>
						
						</cfif>						
						
					</cfif>
					
				<cfelse>
				
				     <!--- Hanno added the value on 6/10/2014 --->
				
					<cfset aClassification[f_itm] = {Item       = "#f_itm#", 
													Topic       = "#Class#", 
													ListCode    = "#ListCode#", 
													ListValue   = "#ListValue#", 
				                                	ItemPointer = "#qTopic.ItemPointer#"}>
					<cfset f_itm = f_itm + 1>
					
				</cfif>
			
			</cfif>
		
		</cfloop>
	
		<cfif NOT UoMFound>
		
			<!--- What should we do in this case as there is no UOM? --->
			<cfset vresponse = vresponse & "#qSource.ItemNo# unknown UoM -item was not added to your Work Order\n">
			
		<cfelse>
		
			<cfif qCost.StandardCost neq "" and qCost.recordcount neq 0>
				<cfset vCost = qCost.StandardCost>
			<cfelse>
				<cfset vCost = 0>
			</cfif>
		
			<cfinvoke component="Service.Process.Materials.Item" 
				  method		          = "GenerateItem" 
		          mission		          = "#qMission.Mission#" 
		 		  itemmaster	          = "#qItem.ItemMaster#" 
				  category		          = "#qItem.Category#" 
				  categoryitem	          = "#qItem.CategoryItem#"
		          classification          = "#aClassification#" 
		 		  uom			          = "#vItemUoM#" 
				  uomcode                 = "#vItemUoMCode#"
				  uomdescription          = "#vItemUoMLabel#"
				  cost			          = "#vCost#" 
				  datasource	          = "AppsMaterials"
		          currency		          = "#vCurrency#" 
				  price		         	  = "#vPrice#" 
				  parentItemNo            = "#qSource.ItemNo#"
				  InheritedDescription    = "#qItem.ItemDescription#"
				  InheritedClassification = "#qItem.Classification#"
				  returnvariable          = "Item">
				  
		</cfif>
	
	<cfelse>
	
		<cfquery name="Item" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT  ItemNo,UoM as ItemUoM
			FROM    ItemUoM
			WHERE   ItemUoMId = '#qSource.ItemUoMIdFinalProduct#'
		</cfquery>
	
		<cfif Item.Recordcount neq 0>
			<cfset UoMFound = TRUE>
		<cfelse>
			<cfset UoMFound = FALSE>
		</cfif>
		
	</cfif>
	
	<cfquery name="getItem" 
		   datasource="AppsMaterials" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT  *
			FROM    Item
			WHERE   ItemNo = '#Item.ItemNo#'
	</cfquery>	

	<cfif ISDEFINED("Item.ItemUoM") && UoMFound>
	
		<!---- Adding the final product to the WorkOrderLineItem table --->
		
		<cfquery name="validate" 
		    datasource="AppsMaterials" 
			username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT *
			FROM    WorkOrder.dbo.WorkOrderLineItem
			WHERE   WorkOrderId   = '#WorkOrderId#'
			AND		WorkOrderLine = '#WorkOrderLine#'
			AND		ItemNo        = '#Item.ItemNo#'
			AND		UoM           = '#Item.ItemUoM#'	
			AND     SaleType      = '#SaleType#'		
		</cfquery>
	
		<cfif validate.recordCount neq 0>
		
			<cfquery name="qDelete" 
			    datasource="AppsMaterials" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				DELETE  FROM WorkOrder.dbo.WorkOrderLineItem
				WHERE   WorkOrderId    = '#WorkOrderId#'
				AND		WorkOrderLine  = '#WorkOrderLine#'
				AND		ItemNo         = '#Item.ItemNo#'
				AND		UoM            = '#Item.ItemUoM#'
				AND     SaleType       = '#SaleType#'	
			</cfquery>
			
		</cfif>

		<cfquery name="CheckTaxCode" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT TOP 1 *
			FROM   Materials.dbo.WarehouseCategory
			WHERE  Category    = '#qItem.Category#'			
			AND    Warehouse IN (SELECT   Warehouse 
			                     FROM     Materials.dbo.Warehouse 
								 WHERE    Mission='#qMission.Mission#') 
	    </cfquery>					

		<cfif CheckTaxCode.recordcount eq 0>
		
				<cfoutput>
					<script language="JavaScript1.1">
						alert('Tax code could not be identified for warehouse #CheckTaxCode.Warehouse# and item category: #qItem.Category#')
					</script>
				</cfoutput>
				
				<cfabort>	
				
		</cfif>	
		
		<cfquery name="Tax" 
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT *
			FROM   Ref_Tax
			WHERE  TaxCode = '#CheckTaxCode.TaxCode#'
	    </cfquery>			
		
		<cfif Tax.TaxCalculation eq "Inclusive">
		  <cfset taxcal = "1">
		<cfelse>
		  <cfset taxcal = "0">  
		</cfif>
					
		<cfset vTaxCode = ChecktaxCode.TaxCode>
				
		<cfquery name="Customer" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">			
			SELECT TaxExemption
			FROM   WorkOrder.dbo.Customer
			WHERE  CustomerId = '#qMission.CustomerId#'
	    </cfquery>
		
		<cfset fpqty = Replace(qSource.Quantity, ",","", "all")>
					
		<cf_getQuotation 
			    element      = "netsale"
				quantity     = "#fpqty#"
				price        = "#Replace(vPrice,',','','all')#"
				taxcode      = "#vTaxCode#"
				taxexemption = "#Customer.TaxExemption#">
		
		<cfif isValid("numeric",amount)>
			<cfset vSaleAmountIncome = round(amount*1000)/1000>
		<cfelse>
			<cfset vSaleAmountIncome = 0>				
		</cfif>

		<cf_getQuotation 
			    element      = "nettax"
				quantity     = "#fpqty#"
				price        = "#Replace(vPrice,',','','all')#"
				taxcode      = "#vTaxCode#"
				taxexemption = "#Customer.TaxExemption#">
		
		<cfif isValid("numeric",amount)>
			<cfset vSaleAmountTax = round(amount*1000)/1000>
		<cfelse>
			<cfset vSaleAmountTax = 0>
		</cfif>	
		
		<cf_assignid>
		
		<cfset wlid = rowguid>			
	
		<cfquery name="add" 
		        datasource="AppsMaterials" 
				username="#SESSION.login#" 
		        password="#SESSION.dbpw#">
				
				INSERT INTO WorkOrder.dbo.WorkOrderLineItem
						(WorkOrderItemId,
						WorkOrderId,
						WorkOrderLine,
						ItemNo,
						UoM,
						CommodityCode,
						Quantity,
						Currency,
						SalePrice,
						SaleTax,
						TaxCode,
						TaxIncluded,
						TaxExemption,
						SaleAmountIncome,
						SaleAmountTax,
						SaleType,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
				VALUES ('#wlid#',
				        '#WorkOrderId#',
						'#WorkOrderLine#',
						'#Item.ItemNo#',
						'#Item.ItemUoM#',
						'#getItem.CommodityCode#',						
						'#fpqty#',
						'#vCurrency#',
						#vPrice#,
						'#Tax.Percentage#',
						'#vTaxCode#',
						'#taxcal#',
						'#Customer.TaxExemption#',						
						'#vSaleAmountIncome#',
						'#vSaleAmountTax#',
						'#SaleType#',
						'#session.acc#',
						'#session.last#',
						'#session.first#')
					
		</cfquery>
		
		
	
		<cfset vResponse = vResponse & "#Item.ItemNo#/#Item.ItemUoM# defined">
	
		<!---- Hanno 9/8/2103 we check if the bill of materials for the item would need to be refreshed based on the
		parent item, this we likely adjust because of the need to add an instance record
		to the ItemMaterals which indicates such a situation --->
		
		<!--- ------------------------------------------ --->
		<!--- retored Hanno to be moved to the component --->
		<!--- ------------------------------------------ --->
		
		<cfquery name="BOMParent" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   TOP 1 *
			FROM     ItemBOM 
			WHERE    ItemNo  = '#qSource.ItemNo#'
			AND	     UoM     = '#qSource.UoM#'  
			AND      Mission = '#qMission.Mission#'
			ORDER BY DateEffective DESC
		</cfquery>
		
		<cfquery name="BOMChild" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM   ItemBOM  
			WHERE  ItemNo   = '#Item.ItemNo#'
			AND	   UoM      = '#Item.ItemUoM#'
			AND    Mission  = '#qMission.Mission#'
		</cfquery>
		
		<cfif BOMParent.recordcount neq "0" AND BOMChild.recordcount eq 0>
										
				<!--- apply the BOM of the parent to the -new- child --->
				
				<cf_AssignId>
				<cfset bomId = rowguid>
				
				<cfquery name="InheritBOM" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
					INSERT INTO ItemBOM
							(BOMId,
							 Mission,
							 ItemNo,
							 UoM,
							 DateEffective,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
					VALUES  ('#bomId#',
					         '#qMission.Mission#',
						     '#Item.ItemNo#',
						     '#Item.ItemUoM#',
						     '#BOMParent.DateEffective#',
						     '#session.acc#',
						     '#session.last#',
						     '#session.first#') 
				</cfquery>

				<cfquery name="InheritBOM" 
				   datasource="AppsMaterials" 
				   username="#SESSION.login#" 
		           password="#SESSION.dbpw#">
					INSERT INTO ItemBOMDetail
						   (BOMId,
							MaterialItemNo,
							MaterialUoM,
							MaterialQuantity,
							MaterialCost,
							MaterialMemo,
			  			    OfficerUserId,
							OfficerLastName,
							OfficerFirstName)
					SELECT '#bomId#',
						    IBD.MaterialItemNo,
						    IBD.MaterialUoM,
						    IBD.MaterialQuantity,
						    IBD.MaterialCost,
						    IBD.MaterialMemo,
						    '#session.acc#',
						    '#session.last#',
						    '#session.first#' 
					FROM    ItemBOMDetail IBD
					WHERE   IBD.BomId = '#BOMParent.BOMID#'					
				</cfquery>
				
				<cfset vResponse = vResponse & " and BOM has been inherited">
				
		</cfif>
		
		<!--- ---------------------------- --->
		<!--- ---------------------------- --->
		
		<!---  now we pass the box --->
								
		<cfquery name="BOMcheck" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM   ItemBOM  
				WHERE  ItemNo   = '#Item.ItemNo#'
				AND	   UoM      = '#Item.ItemUoM#'
				AND    Mission  = '#qMission.Mission#'
				ORDER BY DateEffective DESC
		</cfquery>
		
		<cfif Bomcheck.recordcount eq "1">
		
				<!--- apply the bom and also adjust the higher level --->
				
				<cfquery name="ItemMaterial" 
					datasource="AppsWorkOrder"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT   IBD.*,
					         MIS.StandardCost AS MissionStandardCost, 
							 UoM.StandardCost AS StandardCost
					FROM     Materials.dbo.ItemBOM IB INNER JOIN Materials.dbo.ItemBOMDetail IBD ON IB.BOMId = IBD.BOMId INNER JOIN
	                	     Materials.dbo.ItemUoMMission MIS ON IB.ItemNo = MIS.ItemNo 
							                                 AND IB.UoM = MIS.UoM 
															 AND IB.Mission = MIS.Mission 
							 INNER JOIN  Materials.dbo.ItemUoM UoM ON IB.ItemNo = UoM.ItemNo AND IB.UoM = UoM.UoM
							 
					WHERE    IB.BOMId   = '#BOMCheck.BOMID#'  <!--- only for that mission --->
					
				</cfquery>			
				
				<!--- generate the item on the workorderlineresource level --->
																
				<cfloop query="ItemMaterial">	
							
					<cfset qty = fpqty * MaterialQuantity>
					
					<cfif MaterialCost neq "0">
					    <!--- inherit from bom --->
						<cfset prc = MaterialCost>
					<cfelse>
						<cfif MissionStandardCost gt 0>
							<cfset prc = MissionStandardCost>
						<cfelse>
						    <cfset prc = StandardCost>
						</cfif>
					</cfif>	
					
					<cfif prc eq "">
						<cfset prc = 0>
					</cfif>		
													
					<cfquery name="insertBOMRecord" 
						datasource="AppsWorkOrder"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
							INSERT INTO WorkOrderLineItemResource
					           	(WorkOrderItemId,							
					           	 ResourceItemNo,
					           	 ResourceUoM,	
								 OrgUnit,
								 Quantity,
								 Price,		
								 Memo,	          
					           	 OfficerUserId,
					           	 OfficerLastName,
					           	 OfficerFirstName)
					     	VALUES
					           	('#wlid#',				           
					           	'#MaterialItemNo#',
					           	'#MaterialUoM#',
								'0',
								'#qty#',
								'#prc#',
								'#MaterialMemo#',
					            '#Session.acc#',
					           	'#Session.last#',
					           	'#Session.acc#')
					</cfquery>
				
				</cfloop>
				
				<!--- sync the BOM table on the higher level --->
				
				<cfinvoke component="Service.Process.WorkOrder.WorkOrderLineItem" 
					  method		 = "SyncWorkOrderLineResource" 
			          workorderid 	 = "#WorkOrderId#" 
			 		  workorderline  = "#WorkOrderLine#">							
		
		</cfif>	
					
		<cfset vResponse = vResponse & "\n">
	
		<cfquery name="qDeleteProcessed" 
		    datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM userTransaction.dbo.FinalProduct_#session.acc#
				WHERE  WorkorderItemId = '#qSource.WorkorderItemId#'		
		</cfquery>		

	<cfelse>
				
		<cfset vResponse = vResponse & "Original Product was deleted, remove the line and try again\n">

	</cfif>

</CFLOOP>

<script>	
   parent.opener.Prosis.busy('yes')
   parent.opener._cf_loadingtexthtml='';	   	 
   parent.opener.document.getElementById('menu2').click()	 
   window.close()	
</script>	
	