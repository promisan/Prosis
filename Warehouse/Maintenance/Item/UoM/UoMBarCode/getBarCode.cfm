<cfset vHeight = 90>
<cfset vType   = 8>

<cfparam name="URL.Lot" default="">

<cfif URL.Lot eq "">
	<cfquery name="Get" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT UoM.ItemBarCode, UoM.UoM, I.*
			FROM   ItemUoM UoM INNER JOIN Item I ON 
			 	   UoM.ItemNo = I.ItemNo
			WHERE  UoM.ItemNo = '#URL.id#'
			AND    UoM.UoM    = '#URL.uom#'
	</cfquery>
	
	<cfset vBarCode = Get.ItemBarCode>
<cfelse>

	<cfquery name="qWarehouse" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT Mission
			FROM   Warehouse  
			WHERE  Warehouse = '#URL.whs#'
	</cfquery>
	
	
	<cfif qWarehouse.Mission neq "">

		<cfquery name="qCheck" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT IML.ItemBarCode
				FROM   ItemUoMMissionLot IML 
				WHERE  IML.ItemNo = '#URL.id#'
				AND    IML.UoM    = '#URL.uom#'
				AND	   IML.TransactionLot = '#URL.Lot#'
				AND    IML.Mission        = '#qWarehouse.Mission#'  
		</cfquery>
	
		<cfquery name="Get" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT UoM.UoM, I.*
				FROM   ItemUoM UoM INNER JOIN Item I ON UoM.ItemNo = I.ItemNo 	     
				WHERE  UoM.ItemNo = '#URL.id#'
				AND    UoM.UoM    = '#URL.uom#'
		</cfquery>	
	
		<cfif qCheck.Recordcount eq 0>
			
				<cfinvoke component = "Service.Process.Materials.Item"  
		           method           = "getBarcode" 
				   datasource       = "AppsMaterials"
		           Category         = "#Get.CategoryItem#"
		           ItemNo           = "#Get.ItemNo#"
		           Mission          = "#qWarehouse.Mission#"
		           UoM              = "#Get.UoM#"
		           Lot              = "#URL.Lot#"
		           returnvariable   = "vBarCode">
	
				<!--- Inserting on ItemUoMMissionLot --->
				  <cfquery name="UoMMissionLot" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						INSERT INTO ItemUoMMissionLot
						            (ItemNo,
						             UoM,
						             Mission,
						             TransactionLot, 
								     ItemBarCode,
						             OfficerUserId,
						             OfficerLastName,
						             OfficerFirstName)
						     VALUES ('#Get.ItemNo#',
						             '#Get.UoM#',
								     '#qWarehouse.Mission#',
								     '#URL.Lot#', 
								     '#vBarCode#',
								     '#SESSION.acc#',
								     '#SESSION.last#',
								     '#SESSION.first#')				
					</cfquery>			
	
		<cfelse>
		
			<cfif qCheck.ItemBarCode eq "">
				<cfinvoke component = "Service.Process.Materials.Item"  
		           method           = "getBarcode" 
				   datasource       = "AppsMaterials"
		           ItemNo           = "#Get.ItemNo#"
		           Mission          = "#qWarehouse.Mission#"
		           UoM              = "#Get.UoM#"
		           Lot              = "#URL.Lot#"
		           returnvariable   = "vBarCode">
		           
		           <!--- Updating Bar Code--->
				  <cfquery name="UoMMissionLot" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE ItemUoMMissionLot
						SET    ItemBarCode = '#vBarCode#'
						WHERE  ItemNo      		  = '#Get.ItemNo#'
						       AND UoM     		  = '#Get.UoM#'
						       AND Mission 		  = '#qWarehouse.Mission#'
						       AND TransactionLot = '#URL.Lot#'   
					</cfquery>				           
		           				
			<cfelse>
				<cfset vBarCode = qCheck.ItemBarCode>
			</cfif>	
	
		</cfif>	
	
	</cfif>

</cfif>	


<table width="400">
	<tr>
		<td align="center">
			<cfoutput>#vBarCode#</cfoutput>
		</td>			
	</tr>
	
	<tr>
		<td align="center">
			<CF_BarCodeGenerator BarCodeType="#vType#" 
 			BarCode="#vBarCode#" 
 			Height="#vHeight#">		
		</td>	
	</tr>
	<tr>
	<td align="center" class="labelsmall">
	  Code128 (Characterset B) 
	</td>		
	</tr>
	<tr>
	<td align="center" class="labelit">
	   <cfoutput>#Get.Classification#</cfoutput>
	</td>		
	</tr>

</table>	
