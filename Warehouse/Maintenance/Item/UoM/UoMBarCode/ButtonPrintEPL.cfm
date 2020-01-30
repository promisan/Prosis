<cfparam name="url.lot" default="" >


<cfif URL.lot eq "">
	<cfquery name="Get" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				SELECT UoM.ItemBarCode, '' as ItemBarCodeAlternate, UoM.UoM, I.*
				FROM   ItemUoM UoM INNER JOIN Item I ON 
				 	   UoM.ItemNo = I.ItemNo
				WHERE  UoM.ItemNo = '#url.itemno#'
				AND    UoM.UoM    = '#url.uom#'
	</cfquery>
<cfelse>


	<cfquery name="qWarehouse" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT Mission
			FROM   Warehouse  
			WHERE  Warehouse = '#URL.whs#'
	</cfquery>

	<cfquery name="Get" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT IML.ItemBarCode, IML.ItemBarCodeAlternate,  UoM.UoM, I.*
			FROM   ItemUoM UoM INNER JOIN Item I ON 
			 	   UoM.ItemNo = I.ItemNo INNER JOIN ItemUoMMissionLot IML ON
			 	   IML.ItemNo = I.ItemNo AND IML.UoM = UoM.UoM  
				   AND    IML.TransactionLot = '#URL.Lot#' 	   
				   AND    IML.Mission        = '#qWarehouse.Mission#'	     
			WHERE  UoM.ItemNo = '#URL.itemno#'
			AND    UoM.UoM    = '#URL.uom#'
	</cfquery>
	
</cfif>


<cfquery name="GetDefault" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT TOP 1 Code
			FROM Ref_PriceSchedule
			WHERE FieldDefault ='1'
</cfquery>	
	
<cfquery name="GetPrice" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT TOP 1 SalesPrice
			FROM   ItemUoMPrice P 
			WHERE  P.ItemNo = '#url.itemno#'
			AND    P.UoM    = '#url.uom#'
			AND    Warehouse = '#url.whs#'
			AND    DateEffective <= getdate()
			AND    PriceSchedule = '#GetDefault.Code#'
			ORDER BY DateEffective DESC
</cfquery>

<cfif getPrice.recordcount lte 0>
	<cfquery name="GetPrice" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT TOP 1 SalesPrice
			FROM   ItemUoMPrice P 
			WHERE  P.ItemNo = '#url.itemno#'
			AND    P.UoM    = '#url.uom#'
			AND    Warehouse IS NULL
			AND    DateEffective <= getdate()
			AND    PriceSchedule = '#GetDefault.Code#'
			ORDER BY DateEffective DESC
	</cfquery>
</cfif>



<cfif getPrice.recordcount lte 0>
	<cfquery name="GetPrice" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT TOP 1 StandardCost as SalesPrice
			FROM   ItemUoM P 
			WHERE  P.ItemNo = '#url.itemno#'
			AND    P.UoM    = '#url.uom#'
			ORDER BY Created DESC
	</cfquery>
</cfif>


<cfquery name="qWarehouse" 
		datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		SELECT Mission,Warehouse,WarehouseName, SaleCurrency,TaskingMode
		FROM Warehouse
		WHERE Warehouse = '#url.whs#' 
</cfquery>


<cfif Get.ItemBarCodeAlternate eq "">
	<cfset code = Ucase(Get.ItemBarCode)>
<cfelse>
	<cfset code = Ucase(Get.ItemBarCodeAlternate)>
</cfif>	

	<cfoutput>
		<cfset wtext=trim(Wrap(get.Classification, 25,true))>
		<cfset br = "#chr(13)##chr(10)#">
		<cfset salesPrice =  #Numberformat(GetPrice.SalesPrice,"____.__")#>
		<cfif qWarehouse.TaskingMode eq 0>
			<cfset wtext="#Get.CategoryItem# #Get.ItemNo# #Get.UoM#|#wtext#|#URL.lot# #qWarehouse.SaleCurrency#.#salesPrice#|">
		<cfelse>
			<cfset wtext="#Get.CategoryItem# #Get.ItemNo# #Get.UoM#|#wtext# #get.ItemDescription#|#URL.lot#   #qWarehouse.SaleCurrency#.#salesPrice#|">
		</cfif>	

		<cfset wtext=replace(wtext,br,"|","All")>
		<input type="button" value="Print Barcodes EPL2" style="width:200" class="button10g" onclick="javascript:printEPL('#code#','#url.itemno#','#url.uom#','#wtext#')">
	</cfoutput>


<cfset AjaxOnload("launchQZ")>