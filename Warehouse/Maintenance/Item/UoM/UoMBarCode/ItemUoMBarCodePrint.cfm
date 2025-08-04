<!--
    Copyright © 2025 Promisan

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
<cfparam name="url.tbarcode" default="1">
<cfparam name="url.mission"     default="BCN">
<cfparam name="url.ReceiptNo" default="RCT-1417">


<html>
<head>
<title></title>
	
<style>

body {
	padding-left:0px;
	padding-top:100px;
	font-size:13px;
	padding-top: 0px;
	margin-top: 0px;
	line-height:13px;
}

	
span {
	margin-top:0px;
	font-size:13px;
    display: inline-block;
    *display: inline;	
	}
	
	
</style>


</head>

<body>

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


<cfquery name="qWarehouse" 
		datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		SELECT Warehouse,WarehouseName, SaleCurrency
		FROM Warehouse
		WHERE Warehouse = '#url.whs#' 
</cfquery>


<cfset vTop = 55>
<cfset vHeight = 30>
<cfset vType   = 9>
<!--- Code128 8--->
<!--- EAN13 9--->
<cfset cont = 0>
<cfloop index="i" from="1" to="#url.numberOfLabels#" step="1">
			<cfset cont = cont + 1>
			<span> 
				<cfif Get.ItemBarCodeAlternate eq "">
					<cfset code = Ucase(Get.ItemBarCode)>
				<cfelse>
					<cfset code = Ucase(Get.ItemBarCodeAlternate)>
				</cfif>
				<cfif code neq "">
					<br>
					<CF_BarCodeGenerator BarCodeType="#vType#" BarCode="#code#"  Height="#vHeight#" ThinWidth="2">
					<br>
				</cfif>
				<cfoutput>#Get.ItemBarCode#&nbsp;&nbsp;#Get.CategoryItem#&nbsp;#Get.ItemNo#</cfoutput>
			</span>			 
			<br> 
			<cfoutput>
			#UCase(Get.Classification)#&nbsp;&nbsp;&nbsp;#Get.UoM#
			</cfoutput>	
			<br>
			<cfoutput>#URL.lot#&nbsp;<b>#qWarehouse.SaleCurrency#. #Numberformat(GetPrice.SalesPrice,"____.__")#</b></cfoutput>	
			<br>
</cfloop>

</body>
</html>
