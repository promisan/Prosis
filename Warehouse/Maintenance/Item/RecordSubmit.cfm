<cf_screenTop height="100%" 
	bannerheight="4" 
	border="0" 
	html="No" 
	scroll="no">		
	
<cfparam name="form.operational"   default="1">			
<cfparam name="form.topic"         default="">		
<cfparam name="url.action"         default="">	
<cfparam name="Form.CommodityCode" default="">	
<cfparam name="Form.Warehouse" 	   default="">
<cfparam name="Form.ProgramCode"   default="">	
<cfparam name="Form.OfferMinimumVolume" default="0">

<cfparam name="Form.CategoryItem" default="">	

<cfif Form.CategoryItem eq "" and url.action neq "delete">
	 
 	<script>  
       alert("You need to define a Category for this item. Operation aborted!")	
	</script> 
	      
   <cfabort>
	   
</cfif>	   

<cfquery name="Mis" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT T.*
	FROM   Ref_ParameterMission T
	WHERE	Mission IN (SELECT M.Mission 
	                    FROM   Organization.dbo.Ref_MissionModule M
						WHERE  T.Mission = M.Mission
						AND    SystemModule = 'Warehouse')
</cfquery>

<cfif url.id eq "" and url.action neq "delete"> 

   <cfquery name="Verify" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM  Item
		WHERE ItemDescription  = '#Form.ItemDescription#' 
   </cfquery>
     
   <cfif Verify.recordCount gte 1 and Mis.PortalInterfaceMode neq "External">
   
	   <script language="JavaScript">	   
	     alert("An item with this name was already registered already. Operation aborted !")	     
	   </script>  	   
	   <cfabort>
  
   <cfelse>   
   
        <cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Item
			WHERE  Classification  = '#Form.Classification#' 
   		</cfquery>
   		
    	<cfif Verify.recordCount gte 1 and Mis.EarmarkManagement eq 1 and form.classification neq "">
		
      		<script language="JavaScript">	   
	     		alert("An item with this code was already registered already. Operation aborted !")	     
	   		</script>  	   
	   		<cfabort> 
			
    	</cfif>	 	
		
		<cfset datasource = "appsMaterials">   		   
   		<cfinclude template="AssignItemNo.cfm">
   
	   	<cftransaction>
				   
			<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Item
			         (ItemNo,
					  ItemMaster,				  
					  Mission,	
					  ProgramCode,				  
					  Make,		
					  Model, 
					  ItemDescription, 
					  ItemNoExternal, 
					  ItemDescriptionExternal, 
			          Category, 
					  CategoryItem,
			          Classification, 
			          Destination, 
			          ItemPrecision, 
			          ValuationCode, 
		              DepreciationScale, 
			          InitialApproval, 
			          ItemClass,
					  ItemProcessMode,
					  ItemShipmentMode,
					  ItemColor,	   
					  Reference1,
					  Reference2,
					  Reference3, 
					  Reference4,     
			          CommodityCode, 
			          Operational,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)
			  VALUES ('#No#',
			          '#Form.ItemMaster#',				 
					  '#Form.Mission#',		
					  '#Form.ProgramCode#',
					   <cfif Form.Make neq "">
					  '#Form.Make#',
					  <cfelse>
					  NULL,
					  </cfif>
					  N'#Form.Model#',		
			          N'#Form.ItemDescription#', 
					  '#Form.ItemNoExternal#', 
					  N'#Form.ItemDescriptionExternal#', 
			          '#Form.Category#', 
					  '#Form.CategoryItem#',
			          '#Form.Classification#', 
			          '#Form.Destination#', 
			          '#Form.ItemPrecision#', 
			          '#Form.ValuationCode#', 
		              '#Form.DepreciationScale#', 
			          '#Form.InitialApproval#', 
			          '#Form.ItemClass#',
					  '#Form.ItemProcessMode#',
					  '#Form.ItemShipmentMode#',
					  N'#Form.Color#',	   
					  N'#Form.Reference1#',
					  N'#Form.Reference2#',
					  N'#Form.Reference3#',
					  N'#Form.Reference4#',
					  <cfif Form.CommodityCode neq "">					        
			          '#Form.CommodityCode#', 
					  <cfelse>
					  NULL,
					  </cfif>
			          '#Form.Operational#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
	        </cfquery>
						
			<cf_LanguageInput
				TableCode    = "Item" 
				Mode         = "Save"
				DataSource   = "AppsMaterials"
				Key1Value    = "#No#"
				Name1        = "ItemDescription">			
			
			<cfquery name="Clear" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM ItemTopic
					WHERE ItemNo = '#No#'		
			</cfquery>	
	
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		         action="Insert"
				 datasource = "appsMaterials" 
				 content="#form#">
					
			<cfif Form.itemClass eq "Asset">			    
			
				<cfloop index="itm" list="#Form.Topic#" delimiters=",">
				
					<cfquery name="Insert" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO ItemTopic 
							(ItemNo,Topic)
							VALUES
							('#No#','#Itm#')	
					</cfquery>
				
				</cfloop>				
			
			</cfif>
			
			<!--- base UoM --->
			
			<cf_AssignUoM itemNo = No>
			
			<cfif Form.ItemBarCode eq "">
			
				<cfinvoke component = "Service.Process.Materials.Item"  
		           method           = "getBarcode" 
				   datasource       = "AppsMaterials"
		           Category         = "#Form.Category#"
		           ItemNo           = "#No#"
		           UoM              = "#UoM#"
		           returnvariable   = "vBarCode">
			   
			<cfelse>
			
				<cfset vBarCode = Form.ItemBarCode>
			
			</cfif>   
										
			<cfinclude template="UoMInsert.cfm">	
			
			<!--- insert ItemVendorNN --->		
			
			<cfif form.referenceorgunit neq "">
			
				<cfquery name="insertvendor"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO ItemVendor
							(ItemNo,
							 UoM,
							 OrgUnitVendor,
							 VendorItemNo,
							 VendorItemDescription,
							 Preferred,								 
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
						VALUES ('#No#',
						        '#UoM#',
								'#form.ReferenceOrgUnit#',
								'#Form.ItemNoExternal#',
								'#ItemDescriptionExternal#',
								'1',
								'#SESSION.acc#',
								'#SESSION.last#',
								'#SESSION.first#')														
				</cfquery>		
								
				<cf_DateConvert Value="#dateformat(now(),client.dateformatshow)#">
				<cfset vDateEffective = dateValue>		
			
				<cfquery name="insertoffer"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO ItemVendorOffer
							(ItemNo,
							 UoM,
							 OrgUnitVendor,
							 Mission,
							 LocationId,
							 DateEffective,
							 OfferMinimumQuantity,
							 OfferMinimumVolume,
							 Currency,
							 ItemPrice,
							 ItemTax,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
						VALUES ('#No#',
					        '#UoM#',
							'#form.ReferenceOrgUnit#',
							'#Form.Mission#',
							'#Form.LocationId#',
							#vDateEffective#,
							'#Form.OfferMinimumQuantity#',
							'#Form.OfferMinimumVolume#',
							'#Form.Currency#',
							'#Form.ItemPrice#',
							'#Form.ItemTax#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')									 
				</cfquery>				 		
			
			</cfif>				
				
			<!--- warehouse --->
				
			<!--- record into warehouse --->
									
			<cfquery name="Warehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      Warehouse
					WHERE     Mission = '#form.mission#'
					AND       Operational = 1	
					<cfif form.Warehouse eq "">
					AND       1 = 0
					<cfelse>
					AND       Warehouse IN (#preservesingleQuotes(form.warehouse)#)
					</cfif>
					ORDER BY  WarehouseName
			</cfquery>	
			
			<cfoutput query="warehouse">
			
			`	<cfset row = trim(warehouse)>
	
		    	<cfset min     = evaluate("Form.MinimumStock_#row#")>									
				<cfset max     = evaluate("Form.MaximumStock_#row#")>
				<cfset taxcode = evaluate("Form.TaxCode_#row#")>
				<!---
					<cfset minre   = evaluate("Form.MinReorderQuantity_#row#")>
					<cfset avgP     = evaluate("Form.AveragePeriod_#row#")>
				--->
				<cfset reord   = 1>
				<!---
					<cfif isDefined("Form.ReorderAutomatic_#row#")>
						<cfset reord   = evaluate("Form.ReorderAutomatic_#row#")>
					</cfif>
					<cfset reqtype = evaluate("Form.RequestType_#row#")>
				--->
				<cfset restock = evaluate("Form.Restocking_#row#")>
				<!---
					<cfset ship    = evaluate("Form.ShippingMemo_#row#")>		
				--->
									
				<cfquery name="insert"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO ItemWarehouse
							(Warehouse,
							 ItemNo,
							 UoM,
							 MinimumStock,
							 MaximumStock,
							 <!---
								 ReorderAutomatic,
								 MinReorderQuantity,							
								 AveragePeriod,
							 --->
							 Restocking,
							 <!---
								 RequestType,							 
								 ShippingMemo, 
							 --->
							 TaxCode,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)
						VALUES
						    ('#warehouse#',
							 '#No#',
							 '#UoM#',
							 '#min#',
							 '#max#',
							 <!---
								 '#reord#',
								 '#minre#',
								 '#avgP#',
							 --->
							 '#restock#',
							 <!---
								 '#reqtype#',							 
								 '#ship#',
							 --->
							 '#taxcode#',
							 '#session.acc#',
							 '#session.last#',
							 '#session.first#')				
				</cfquery>		
							
			</cfoutput>			
						  
		  </cftransaction>
		  		  
		<cfoutput>
			<script language="JavaScript">		
			   try {
		    		console.log(document.getElementById('divDetail'));
		   			if (document.getElementById('divDetail')) {
						opener.ptoken.navigate('ItemSearchResultDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divDetail');
					}						
				} catch(e) {}				
				
				ptoken.location('RecordEdit.cfm?ID=#no#&idmenu=#url.idmenu#&fmission=#url.fmission#');
			</script>
		</cfoutput>
				  
    </cfif>			
           
<cfelseif url.id neq "" and url.action neq "delete">

	<cftransaction>
	
	<cfquery name="Select" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Item
		WHERE  ItemNo       = '#URL.ID#'
	</cfquery>
	
	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Item
		SET    ItemDescription         = '#Form.ItemDescription#', 
			   ItemNoExternal          = '#Form.ItemNoExternal#', 			 
			   Mission                 = '#Form.Mission#',			 
			   ItemDescriptionExternal = N'#Form.ItemDescriptionExternal#', 
			   <cfif Form.Make neq "">
			   Make					   = N'#Form.Make#',
			   <cfelse>
			   Make					   = NULL,
			   </cfif>
			   Model				   = N'#Form.Model#',
			   <cfif Form.ProgramCode neq "">
			   		ProgramCode		   = '#Form.ProgramCode#',
			   <cfelse>
			   		ProgramCode		   = NULL,	
			   </cfif>	
			   Category                = '#Form.Category#', 
			   CategoryItem            = '#Form.CategoryItem#', 
			   ItemMaster              = '#Form.ItemMaster#',			  
			   Classification          = '#Form.Classification#', 
			   Destination             = '#Form.Destination#', 
			   <!--- the precision in which transactions are being recorded --->
			   ItemPrecision           = '#Form.ItemPrecision#', 
			   ValuationCode           = '#Form.ValuationCode#', 
		       DepreciationScale       = '#Form.DepreciationScale#', 
			   InitialApproval         = '#Form.InitialApproval#', 
			   ItemClass               = '#Form.ItemClass#', 
			   ItemProcessMode         = '#Form.ItemProcessMode#',
			   ItemShipmentMode        = '#Form.ItemShipmentMode#', 
			   ItemColor               = N'#Form.Color#',	
			   Reference1			   = N'#Form.Reference1#',
			   Reference2			   = N'#Form.Reference2#',
			   Reference3			   = N'#Form.Reference3#',
			   Reference4			   = N'#Form.Reference4#',
			   <cfif Form.CommodityCode neq "">		   
			   CommodityCode           = '#Form.CommodityCode#', 
			   <cfelse>
			   CommodityCode          = NULL, 
			   </cfif>
			   Operational             = '#Form.Operational#'
		WHERE ItemNo       = '#URL.ID#'
	</cfquery>
	
	<!--- 0. Updating the Item, may mean that the itemBarcode should change for all itemUoMs --->
	
	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 1 *
		FROM      ItemTransaction
		WHERE 	  ItemNo = '#url.id#'
	</cfquery>
	
	<cfif check.recordcount eq 0>
	
		<cfquery name="UoMList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     ItemUoM
			WHERE 	 ItemNo = '#url.id#'
		</cfquery>
		
		<cfloop query="UoMList">
		
			<cfinvoke component = "Service.Process.Materials.Item"  
	           method           = "getBarcode" 
	           Category         = "#Form.Category#"
	           ItemNo           = "#ItemNo#"
	           UoM              = "#UoM#"
			   datasource       = "AppsMaterials"
	           returnvariable   = "vBarCode">
						   
			<cfquery name="UpdateUoMList" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE ItemUoM
				SET		ItemBarcode = '#vBarCode#'
				WHERE 	ItemNo   = '#ItemNo#'
				AND		UoM      = '#uom#'
				AND     (ItemBarCode is NULL or ItemBarCode = '')
			</cfquery>
		
		</cfloop>
		
	</cfif>
		
	<!--- 1. A change of stock gl code requires a correction in the GL postings accordingly --->

	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	     action     = "Update"
		 datasource = "appsMaterials" 
		 content    = "#form#">	
		 
	<!--- 5/8/2016 this is no longer supported in the interface to change an used item to a different stock GL account
	  so I disabled this routine

		<cfif select.Category neq Form.Category>
		
			<!--- correction of the GL --->
				
				<cfinvoke component = "Service.Process.Materials.Stock"  
					   method           = "setStockLedger" 		
					   datasource       = "AppsMaterials"		  				   	  
					   categoryold      = "#select.Category#"			   
					   categorynew      = "#Form.Category#">	    
			
						  
		</cfif>	
	
	--->
	
	<!--- 2. Adjustment of the transaction values from a fifo base to Manual --->
	
	<cfif select.ValuationCode neq Form.ValuationCode and Form.ValuationCode eq "Manual">
	
		<cfquery name="Price" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   ItemUoMMission
			WHERE  ItemNo = '#URL.ID#'
		</cfquery>
		
		<cfloop query="Price">
		
		    <!--- adjust transaction and general ledger --->
			
			<cfinvoke component = "Service.Process.Materials.Stock"  
			   method           = "setStockPrice" 
			   mission          = "#Mission#"
			   ItemNo           = "#ItemNo#"			  
			   UoM              = "#UOM#"			   
			   Price            = "#standardcost#">	    
					
		</cfloop>	
	
	</cfif>
	
	<cf_LanguageInput
			TableCode       = "Item" 
			Mode            = "Save"
			DataSource      = "AppsMaterials"
			Key1Value       = "#URL.Id#"
			Name1           = "ItemDescription">
	
	<cfquery name="Clear" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM ItemTopic
				WHERE ItemNo = '#URL.ID#'		
		</cfquery>				
		
		<cfif Form.itemClass eq "Asset">
		
			<cfloop index="itm" list="#Form.Topic#" delimiters=",">
			
				<cfquery name="Insert" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO ItemTopic 
						(ItemNo,Topic)
						VALUES ('#URL.ID#','#Itm#')	
				</cfquery>
			
			</cfloop>				
		
		</cfif>
			
	</cftransaction>
	
	<cfoutput>
	
		<script language="JavaScript">
		   try {
	    		console.log(document.getElementById('divDetail'));
	   			if (document.getElementById('divDetail'))
	   			{
					opener.ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/ItemSearchResultDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divDetail');
				}						
			} catch(e) {}
		</script>
		
	</cfoutput>	
		
	<!--- this is an ajax submit in the same screen followed by a reload --->
	<cfset url.loadColor = 1>
	<cfinclude template="ItemForm.cfm">
		
<cfelse> 

	<cfquery name="CountTra" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT   TOP 1 ItemNo
      FROM     ItemTransaction
      WHERE    ItemNo = '#URL.ID#' 
    </cfquery>
	
	<cfquery name="CountReq" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT   TOP 1  ItemNo
      FROM     Request
      WHERE    ItemNo = '#URL.ID#' 
    </cfquery>
	
    <cfif CountTra.recordCount gt 0 or CountReq.recordcount gt 0>
		 
     <script language="JavaScript">
       alert("Item has one or more transactions. Operation aborted.")
	 </script>  
	 
    <cfelse>
	
		<cf_ModuleControlLog systemfunctionid = "#url.idmenu#" 
					         action			  = "Delete"
							 datasource 	  = "appsMaterials" 
							 contenttype 	  = "scalar"
							 content		  = "Code:#url.id#">
		 			
		<cfquery name="Delete" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM   Item
		    WHERE         ItemNo  = '#URL.ID#' 
    	</cfquery>
	
	</cfif>	
	
	<cfoutput>
	
		<script language="JavaScript">
		    try {
		    	console.log(document.getElementById('divDetail'));
	    		if (document.getElementById('divDetail')) {
	    			parent.opener.ptoken.navigate('#SESSION.root#/Warehouse/Maintenance/Item/ItemSearchResultDetail.cfm?idmenu=#url.idmenu#&fmission=#url.fmission#','divDetail');
	    		}	
			} catch(e) {}
		</script> 
		
	</cfoutput> 
	
	<cfset url.loadColor = 1>
	<cfset url.imageTab  = 1>
	
	<script>
		window.close()
	</script>
	
	<!---
	<cfinclude template  = "ItemForm.cfm">
	--->
	
</cfif>	

