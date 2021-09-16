<cfquery name="get"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT S.*, P.FullName, C.CustomerName, I.ItemNoExternal
	FROM   vwCustomerRequest S 
	       LEFT OUTER JOIN Employee.dbo.Person P    ON S.SalesPersonNo = P.PersonNo 
		   LEFT OUTER JOIN Materials.dbo.Customer C	ON C.CustomerId = S.CustomerId
		   INNER JOIN Item I ON S.ItemNo = I.ItemNo
	WHERE  Transactionid = '#url.Id#'		
</cfquery>

<cfquery name="getStockEntity" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	    SELECT    SUM(TransactionQuantity) as OnHand
		FROM      ItemTransaction
		WHERE     ItemNo          = '#get.ItemNo#'
		AND       TransactionUoM  = '#get.TransactionUoM#'
</cfquery>

<cfset itemEntityStock = getStockEntity.onHand>
<cfset itemBeingSold   = 0>

<cfoutput>

<table width="96%" align="center" class="navigation_table">		
	
	<tr height="30px">		
		<td colspan="6" align="center" style="font-size:22px" class="labellarge">#get.ItemDescription# #get.ItemNoExternal#</td>		
	</tr>
		
	<tr style="background-color:e4e4e4;border-top:3px solid silver" class="line labelmedium2">
				
		<td colspan="4" style="padding-left:4px"><cf_tl id="Available"></td>		
		<td align="right">#numberformat(itemEntityStock,",__")#</td>			
		<td align="right" style="padding-right:5px">
			#DateFormat(now(),CLIENT.DateFormatShow)#
			#TimeFormat(now(),"HH:MM")#
		</td>
		
	</tr>
	
	<tr class="labelmedium2 line navigation_row">
		
		<td colspan="2" style="padding-left:4px;font-weight:bold"><cf_tl id="This request"></td>
		<td align="left">
			<cfif get.FullName neq "">
				#get.FullName#
			<cfelse>
				#SESSION.first# #SESSION.last#
			</cfif>	
		</td>
		<td align="left">#get.CustomerName#</td>		
		<td align="right">
			-#numberformat(get.TransactionQuantity,",__")#
			<cfset itemBeingSold   = itemBeingSold + get.TransactionQuantity> 
		</td>			
		<td align="right" style="padding-right:5px">
			#DateFormat(get.Created,CLIENT.DateFormatShow)#
			#TimeFormat(get.Created,"HH:MM")#
		</td>
		
	</tr>

	<tr class="line labelmedium2">		
		<td colspan="6" align="left" style="padding-left:4px;font-weight:bold">
			<cf_tl id="Quotations">
		</td>		
	</tr>
	
	<cfquery name="getOthers"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT S.*, P.FullName, C.CustomerName
		FROM   vwCustomerRequest S 
		       LEFT OUTER JOIN Employee.dbo.Person P ON S.SalesPersonNo = P.PersonNo  
			   LEFT OUTER JOIN Materials.dbo.Customer C	ON C.CustomerId = S.CustomerId 
		WHERE  Warehouse = '#url.warehouse#'		
		AND    BatchNo is NULL
		AND    ActionStatus != '9'
		AND    Transactionid != '#url.Id#'
		AND    BatchId is NULL		
		AND    ItemNo = '#get.ItemNo#'		
	</cfquery>	
		
	<cfloop query="#getOthers#">
	
	<tr class="labelmedium2 line navigation_row">
		<td style="padding-left:4px">#RequestClass#</td>
		<td>#RequestNo#</td>
		<td>#FullName#</td>
		<td>#CustomerName#</td>		
		<td align="right">
			-#numberformat(TransactionQuantity,",__")#
			<cfset itemBeingSold   = itemBeingSold + getOthers.TransactionQuantity>
		</td>			
		<td align="right" style="padding-right:4px">
			#DateFormat(Created,CLIENT.DateFormatShow)#
			#TimeFormat(Created,"HH:MM")#
		</td>		
	</tr>
	
	</cfloop>	
		
	<tr style="background-color:e4e4e4;" class="line labelmedium2">
				
		<td colspan="4" style="padding-left:4px"><cf_tl id="Virtual balance"></td>				
		<td align="right">#numberformat(itemEntityStock-itemBeingSold,",__")#</td>			
		<td align="right"></td>
		
	</tr>		
	
</table>

</cfoutput>

<cfset ajaxonload("doHighlight")>