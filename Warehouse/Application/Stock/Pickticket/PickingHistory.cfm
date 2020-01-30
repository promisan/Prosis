
<!--- history --->


<cfquery name="whs" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Warehouse
	WHERE     Warehouse = '#url.warehouse#'	
</cfquery>

<cf_ExchangeRate EffectiveDate="#dateformat(now(),client.dateformatshow)#" CurrencyFrom="#Application.BaseCurrency#" CurrencyTo="#whs.SaleCurrency#">

<!---- added by Armin on 12/7/2015 --->
<cfset yr = year(now())-1>

<cfif month(now())+1 gt 12>
	<cfset mt = 1>
<cfelse>
	<cfset mt = month(now())+1>		
</cfif>	


<cfset sel = createDate(yr,mt,1)>

<cfquery name="gethistory" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    MONTH(TransactionDate) AS TransactionMonth, SUM(TransactionValue/#exc#) AS Total
	FROM      ItemTransaction
	<cfif shiptowarehouse neq "">
	WHERE     Warehouse = '#shiptowarehouse#' 
	<cfelseif customerid neq "">
	WHERE     CustomerId = '#customerid#'
	</cfif>
	AND       TransactionType = '8' 
	AND       TransactionDate >= #sel#
	GROUP BY MONTH(TransactionDate)
</cfquery>

<cfif gethistory.recordcount gte "1">
	
	<cfset init = month(now())>
	
	<cfoutput>
	<table>
	<tr>	
	<td style="height:20px;width:45px;border:1px solid silver" align="center" class="labelit">#whs.SaleCurrency#<br>#numberformat(exc,'.,___')#</td>
	
		<cfloop index="itm" from="1" to="12">				
			<cfset mth = itm + init>
			<cfif mth gt "12">
				<cfset mth = mth - 12>
			</cfif>
			<td style="height:20px;width:45px;border:1px solid silver">
							
				<cfquery name="get"  dbtype="query">
					SELECT  Total
					FROM    gethistory
					WHERE   TransactionMonth = #mth#
				</cfquery>
				
				<table width="100%">
					<tr bgcolor="DAF9FC" class="line labelit">			
						<td align="center" style="font-size:11px">#left(monthasstring(mth),3)#</td>
					</tr>
					<tr class="labelit">
						<td align="right" style="padding-right:3px">#numberformat(get.Total,",")#</td>
					</tr>
				</table>
			
			</td>			
		</cfloop>
		
	</td>	
	</tr>
	</table>
	
	</cfoutput>	

</cfif>