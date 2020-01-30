
<cf_compression>

<cfoutput>

<cfif not IsNumeric(URL.quantity) and url.quantity neq "">
  
  <font color="FF0000"><b>#URL.quantity#</font>&nbsp;
  
<cfelse>  
	
	<!--- get location data --->
	
	<!--- check for strappingsheet --->
	
	<cfquery name="get"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#		
		WHERE  TransactionId = '#URL.Id#'
	</cfquery>
	
	<cfif mode eq "strapping">
	
	    <cf_getStrappingValue id="#get.ItemLocationId#" 
		   getType="Quantity" 
		   lookupvalue="#url.quantity#">
				
		<cfif resultStrappingValue gte "0">
		    <cfset calculated = resultStrappingValue>
		<cfelse>
		    <cfset calculated = "undefined"> 
		</cfif>
		
	<cfelseif mode eq "metric">	
	
		<cfquery name="Update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#				
				SET   Metric  = '#URL.quantity#' 
				WHERE TransactionId = '#URL.Id#'
		</cfquery>
		
		<!--- trigger correction based on temperature --->
	
	    <cfabort>	
	
	<cfelse>
	
		<cfset calculated = url.quantity>
	
	</cfif>
		
	<cfif calculated eq "undefined">
	
	    <table width="100%">
			<tr>
				<td height="24" align="center" bgcolor="FF8040">
			    <font color="black"><cf_tl id="Conversion not found"></font>
				</td>
			</tr>
		</table>
	
	<cfelse>
		
		<cf_tl id="Measured" var = "vMeasured">		
		<cf_tl id="Variance" var = "vVariance">
		
		<cftransaction>
						
			<cfquery name="Update"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
				<cfif URL.quantity eq "">
				SET   counted  = NULL,
				      ActualStock = NULL
				<cfelse>
				SET   counted  = '#URL.quantity#', 
				      ActualStock = '#calculated#'
				</cfif>
				WHERE TransactionId = '#URL.Id#'
			</cfquery>
				
			<!--- expand/collapse --->
			
		    <cfinclude template="doCheck.cfm">	
		
		</cftransaction>
		
	</cfif>
	
</cfif>	

</cfoutput>