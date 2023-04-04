
<cfquery name="ReceiptLines" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT  *
        FROM    PurchaseLineReceipt
        WHERE   ReceiptId = '#url.receiptid#'
</cfquery>

<cfquery name="GetPrices" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT PriceSchedule
		FROM   	skMissionItemPrice P
		WHERE  	Mission = '#url.mission#'
</cfquery>

<cfset vParams = "">
<cfset vParams = "#vParams#&fmission=#url.mission#">
<cfset vParams = "#vParams#&item=#ReceiptLines.WarehouseItemNo#">
<cfset vParams = "#vParams#&uom=#ReceiptLines.WarehouseUoM#">
<cfset vParams = "#vParams#&fdescription=#url.description#">
<cfset vParams = "#vParams#&fbarcode=#url.barcode#">
<cfset vParams = "#vParams#&fqty=1">

<cfoutput query="GetPrices">
    <cfif isDefined("url.price#priceSchedule#")>
		<cfif evaluate("url.price#priceSchedule#") eq "true">
            <cfset vParams = "#vParams#&fprice#priceSchedule#=true">
        </cfif>
    </cfif>
</cfoutput>

<cfparam name="url.mid" default="">
<cf_securediv bind="url:#session.root#/warehouse/maintenance/item/uom/uomlabel/itemUoMLabelButtonEPL.cfm?mid=#url.mid#&directprint=1#vParams#">