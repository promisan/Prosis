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