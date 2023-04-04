<cfparam name="url.directprint" 	default="0">

<cfquery name="Get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	I.*,
			UoM.ItemBarCode, 
			UoM.UoM, 
			UoM.UoMDescription,
			(
				SELECT 	MinReorderQuantity
				FROM 	ItemWarehouse IWx
				WHERE 	IWx.ItemNo = UoM.ItemNo
				AND  	IWx.UoM = UoM.UoM
				AND 	IWx.Warehouse = (
					SELECT TOP 1 Wx.Warehouse
					FROM	Warehouse Wx
					WHERE	Wx.SupplyWarehouse IS NULL
					AND		Wx.Mission = '#url.fmission#'
					AND		Wx.Distribution = 1
					ORDER BY Wx.Warehouse ASC
				)
			) AS CTN
	FROM   	ItemUoM UoM 
			INNER JOIN Item I 
				ON UoM.ItemNo = I.ItemNo
	WHERE  	UoM.ItemNo = '#url.item#'
	AND    	UoM.UoM    = '#url.uom#'
</cfquery>

<cfquery name="GetPrices" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	P.*
		FROM   	skMissionItemPrice P
		WHERE  	P.ItemNo = '#url.item#'
		AND    	P.UoM    = '#url.uom#'
		AND   	P.Mission = '#url.fmission#'
		ORDER BY P.ListingOrder ASC
</cfquery>

<cfoutput>
	<cfset toPrint = ArrayNew(1)>

	<!--- description --->
	<cfif isDefined("url.fdescription")>
		<cfif evaluate("url.fdescription") eq "true">
			<cfset el = StructNew()>
			<cfset el.name = "description">
			<cfset el.text = TRIM(Get.ItemDescription)>
			<cfset el.size = 2>
			<cfset el.height = 25>
			<cfset el.textHeight = 1>
			<cfset el.print = true>
			<cfset ArrayAppend(toPrint, el)>
		</cfif>
	</cfif>

	<!--- prices --->
	<cfloop query="GetPrices">
		<cfif isDefined("url.fprice#priceSchedule#")>
			<cfif evaluate("url.fprice#priceSchedule#") eq "true">
				<cfset vSalesPrice =  Numberformat(SalesPrice,",.__")>
				<cfset vPriceQuantity =  Numberformat(PriceQuantity,",")>
				<cfset el = StructNew()>
				<cfset el.name = "price#priceSchedule#">
				<cfset el.text = "#LEFT(UCASE(TRIM(PriceScheduleDescription)),3)#: #LEFT(UCASE(Currency),1)#.#vSalesPrice# (#vPriceQuantity#)">
				<cfset el.size = 4>
				<cfset el.height = 47>
				<cfset el.textHeight = 2>
				<cfset el.print = true>
				<cfset ArrayAppend(toPrint, el)>
			</cfif>
		</cfif>
	</cfloop>

	<!--- code --->
	<cfset el = StructNew()>
	<cfset el.name = "code">
	<cfset el.text = TRIM(Get.ItemNoExternal)>
	<cfset el.size = 2>
	<cfset el.height = 25>
	<cfset el.textHeight = 1>
	<cfset el.print = false>
	<cfset ArrayAppend(toPrint, el)>

	<!--- code display --->
	<cfset el = StructNew()>
	<cfset el.name = "codedisplay">
	<cfset vCTN =  Numberformat(Get.CTN,",")>
	<cfset el.text = "#TRIM(Get.ItemNoExternal)# - #vCTN#">
	<cfset el.size = 2>
	<cfset el.height = 25>
	<cfset el.textHeight = 1>
	<cfset el.print = true>
	<cfset ArrayAppend(toPrint, el)>

	<!--- object to print --->
	<cfset oToPrint = serializeJSON(toPrint)>

	<cfif url.directprint eq "0">

		<cf_tl id="Print Labels" var="vPrintLabel">
		<input 
			type="button" 
			value="#vPrintLabel#" 
			style="width:200px" 
			class="button10g" 
			onclick='javascript:printLabelEPL("#UCASE(TRIM(Get.ItemBarCode))#","#url.item#","#url.uom#",#oToPrint#,#url.fqty#,#url.fbarcode#);'>
		
		<script>
			$( document ).ready(function() {
				launchQZ();
			});
		</script>

	<cfelse>

		<script>
			/*
			console.log('--------------------------------');
			console.log("#UCASE(TRIM(Get.ItemBarCode))#");
			console.log("#url.item#");
			console.log("#url.uom#");
			console.log(#oToPrint#);
			console.log(#url.fqty#);
			console.log(#url.fbarcode#);
			*/
			printLabelEPL("#UCASE(TRIM(Get.ItemBarCode))#","#url.item#","#url.uom#",#oToPrint#,#url.fqty#,#url.fbarcode#);
		</script>

	</cfif>

	
</cfoutput>