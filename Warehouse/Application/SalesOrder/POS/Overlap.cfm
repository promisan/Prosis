<cfquery name="get"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT S.*, P.FullName, C.CustomerName 
	FROM   Sale#URL.Warehouse# S LEFT OUTER JOIN Employee.dbo.Person P 
			ON S.SalesPersonNo = P.PersonNo LEFT OUTER JOIN Materials.dbo.Customer C
			ON C.CustomerId = S.CustomerId
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
<table width="100%">
	
	
	
	<tr height="30px">
		<td width="5%"></td>
		<td colspan="6" align="center" class="labelit" style="font-weight:bold">
			#get.ItemDescription#
		</td>
		<td width="5%"></td>
	</tr>
	<tr height="30px">
		<td width="5%"></td>
		<td colspan="6" align="left" class="labelit" style="font-weight:bold">
			<cf_tl id="Available">
		</td>
		<td width="5%"></td>
	</tr>	
	<tr>
		<td width="5%"></td>
		<td width="10%"></td>
		<td align="left" class="labelit"></td>
		<td width="20%">
		</td>	
		<td align="right" class="labelit">
			#numberformat(itemEntityStock,"__,__")#
		</td>			
		<td width="10%" align="right">
			#DateFormat(now(),CLIENT.DateFormatShow)#
			#TimeFormat(now(),"HH:MM:ss")#
		</td>
		<td width="5%"></td>	
	</tr>

	<tr height="30px">
		<td width="5%"></td>
		<td colspan="6" align="left" class="labelit" style="font-weight:bold">
			<cf_tl id="This request">
		</td>
		<td width="5%"></td>
	</tr>	
	
	<tr>
		<td width="5%"></td>
		<td width="10%"></td>
		<td width="20%" align="left" class="labelit">
			<cfif get.FullName neq "">
				#get.FullName#
			<cfelse>
				#SESSION.first# #SESSION.last#
			</cfif>	
		</td>
		<td width="20%" align="left" class="labelit">
			#get.CustomerName#
		</td>		
		<td align="right" class="labelit">
			-#numberformat(get.TransactionQuantity,"__,__")#
			<cfset itemBeingSold   = itemBeingSold + get.TransactionQuantity> 
		</td>			
		<td width="10%" align="right">
			#DateFormat(get.Created,CLIENT.DateFormatShow)#
			#TimeFormat(get.Created,"HH:MM:ss")#
		</td>
		<td width="5%"></td>	
	</tr>

	<tr height="30px">
		<td width="5%"></td>
		<td colspan="6" align="left" class="labelit" style="font-weight:bold">
			<cf_tl id="Other requests">
		</td>
		<td width="5%"></td>
	</tr>
	
	<cfquery name="getOthers"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT S.*, P.FullName, C.CustomerName
		FROM   Sale#URL.Warehouse# S LEFT OUTER JOIN Employee.dbo.Person P 
			ON S.SalesPersonNo = P.PersonNo  LEFT OUTER JOIN Materials.dbo.Customer C
			ON C.CustomerId = S.CustomerId 
		WHERE  Transactionid != '#url.Id#'
		AND ItemNo = '#get.ItemNo#'		
	</cfquery>
	
		
	<cfloop query="#getOthers#">
	<tr>
		<td width="5%"></td>
		<td width="10%"></td>
		<td width="20%" align="left" class="labelit">
			#getOthers.FullName#
		</td>
		<td width="20%" align="left" class="labelit">
			#getOthers.CustomerName#
		</td>		
		<td align="right" class="labelit">
			-#numberformat(getOthers.TransactionQuantity,"__,__")#
			<cfset itemBeingSold   = itemBeingSold + getOthers.TransactionQuantity>
		</td>			
		<td width="20%" align="right">
			#DateFormat(getOthers.Created,CLIENT.DateFormatShow)#
			#TimeFormat(getOthers.Created,"HH:MM:ss")#
		</td>
		<td width="5%"></td>	
	</tr>
	</cfloop>
	
	
	<tr height="30px">
		<td width="5%"></td>
		<td colspan="6" align="left" class="labelit" style="font-weight:bold">
			<cf_tl id="Remaining">
		</td>
		<td width="5%"></td>
	</tr>
	
	<tr>
		<td width="5%"></td>
		<td width="10%"></td>
		<td align="left" class="labelit"></td>
		<td width="20%" align="left" class="labelit">
		</td>			
		<td align="right" class="labelit">
			#numberformat(itemEntityStock-itemBeingSold,"__,__")#
		</td>			
		<td width="10%" align="right">
		</td>
		<td width="5%"></td>	
	</tr>	
	
	
</table>
</cfoutput>