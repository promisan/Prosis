<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<cfparam name="url.tbarcode" default="1">
<cfparam name="url.mission"     default="BCN">

<cfparam name="url.ReceiptNo" default="RCT-1417">

<html>
<head><title></title>
	
<style>

body {
	width:100%;
	height:100%;
	padding:0px;
	margin:0px;
}

#wrapper {
	padding:0px;
	margin:0px;
	display:block;
}

#navlist {
	padding:0px;
	margin:0px;
	height:100%;
	display:block;
	font-size: 0;
	}

#navlist li
{
display: inline-block;
list-style-type: none;
height:100%;
font-size: 0;
}

#wrapper {
	padding:0px;
	margin:0px;
}

#text {
	font:verdana;
	font-size:12px;
	line-height:11px;
	}
	
span {
	font-size:10px;
	line-height:10px}
</style>


</head>

<body>

<cfquery name="Receipt" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">

			SELECT *
			FROM   PurchaseLineReceipt
			WHERE  ReceiptNo = '#url.ReceiptNo#'
			ORDER  BY WarehouseItemNo

</cfquery>


<cfset vTop = 55>
<cfset vHeight = 25>
<cfset vType   = 8>


<cfset cnt = "0">

<cfloop query="Receipt">

	<cfquery name="Item" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT IU.UoM, I.ItemNo, I.ItemDescription, IU.ItemBarcode, I.CategoryItem, I.Classification, P.SalesPrice
			FROM   Materials.dbo.ItemUoM IU
				   INNER JOIN Materials.dbo.Item I
					   ON I.ItemNo = IU.ItemNo
  				   INNER JOIN Materials.dbo.ItemUoMPrice P
        	           ON IU.ItemNo = P.ItemNo AND  IU.UoM = P.UoM AND I.Mission = P.Mission AND P.Warehouse = '#Receipt.Warehouse#' 
					   	  AND P.PriceSchedule = ( SELECT Code FROM Materials.dbo.Ref_PriceSchedule WHERE FieldDefault = 'True' )
				   INNER JOIN Materials.dbo.Warehouse W
				   	   ON W.Warehouse = '#Receipt.Warehouse#' AND W.SaleCurrency = P.Currency
			WHERE  IU.ItemNo = '#Receipt.WarehouseItemNo#' AND  IU.UoM = '#Receipt.WarehouseUoM#'
				   AND P.DateEffective = (
				   		SELECT TOP 1 DateEffective
						FROM   Materials.dbo.ItemUoMPrice
						WHERE  P.ItemNo = ItemNo AND  P.UoM = UoM AND P.Mission = Mission AND P.Warehouse = Warehouse AND P.Currency = Currency
						AND    DateEffective <= '#Receipt.DeliveryDateEnd#'
						ORDER  BY DateEffective DESC
				   )
	</cfquery>

	<cfloop index="i" from="1" to="#Receipt.ReceiptQuantity#" step="1">	
	
		<cfset cnt = cnt+1>
		<cfif cnt eq "1">
			<div id="wrapper" style="width:100%; height:auto;">
			<ul id="navlist">
		</cfif>
				<li style="<cfif cnt eq "1" or cnt eq "2">width:180px;<cfelseif cnt eq "3">width:160px;<cfelseif cnt eq "4">width:100px</cfif><cfif currentrow eq "1">padding-top:52px<cfelse>padding-top:55px</cfif>">
					<TABLE>
						<TR>
							<TD><cfset code = Ucase(Item.ItemBarCode)>
								<CF_BarCodeGenerator BarCodeType="#vType#" BarCode="#code#" Height="#vHeight#">		
							</TD>
						</TR>
						<tr>
							<td id="text" valign="top">
								<cfoutput>#Item.ItemBarCode# #Item.CategoryItem# <br><span>#Item.Classification# #Item.UoM#</span>  <br>#DateFormat(Receipt.DeliveryDateEnd,"mmyy")# &nbsp;&nbsp;<b>Q.#Item.SalesPrice#.00</b></cfoutput>	
							</td>
						</tr>
					</TABLE>	
				</li>
		<cfif cnt eq "4">
			</ul>
		</div>
			<cfset cnt = "0">
		</cfif>
		
	</cfloop>

</cfloop>


</body>
</html>

