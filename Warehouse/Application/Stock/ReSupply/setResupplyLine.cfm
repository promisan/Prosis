
<cfoutput>

<cfset qty = replace(URL.quantity,',','',"ALL")> 
<cfset val = 0>


<cfif not IsNumeric(qty)>

	<script>
		alert('Wrong quantity')
	</script>	
      
<cfelse>  

	<cfquery name="get"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  * 
		FROM    StockResupply#URL.Warehouse#_#SESSION.acc#		
		WHERE   [LineNo] = '#URL.LineNo#' 	
	</cfquery>	
  
	<cfquery name="Update"
		datasource="AppsTransaction" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE StockResupply#URL.Warehouse#_#SESSION.acc#
		SET    Selected = '#URL.Status#', 
		       ToBeRequested = '#qty#' 
		WHERE  [LineNo] = '#URL.LineNo#' 	
	</cfquery>
	
	<cfquery name="getMinimumQuantity" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">		
		SELECT     TOP 1 IVO.OfferMinimumQuantity, IVO.Currency, IVO.ItemPrice
		FROM       ItemVendor AS IV INNER JOIN
                    		   ItemVendorOffer AS IVO ON IV.ItemNo = IVO.ItemNo AND IV.UoM = IVO.UoM
		WHERE      IV.ItemNo   = '#get.ItemNo#' 
		AND        IV.UoM      = '#get.UoM#'
		AND        IVO.Mission = '#get.Mission#'
	    ORDER BY   IV.Preferred DESC, 
		           IVO.DateEffective DESC																							
	</cfquery>
		
	<cfif getMinimumQuantity.recordcount gte "1" 
	    and getMinimumQuantity.OfferMinimumQuantity gt "0" 
		and qty gt "0">
	
		 <cfset val = qty mod getMinimumQuantity.OfferMinimumQuantity>
	
	</cfif>
	
</cfif>

<cf_tl id="The quantity does not match the default minimum reorder quantity" var="1">


<script>
   	
	
	try {	
			
    <cfif val gt "0">		 
		 document.getElementById('requestedqtycell_#url.lineno#').className = 'highLightC4'
	<cfelse>
		 document.getElementById('requestedqtycell_#url.lineno#').className = 'regular'
	</cfif>
								
	ptoken.navigate('../Resupply/getTotal.cfm?warehouse=#url.warehouse#&lineno=#url.lineno#&section=#url.section#&sort=#url.sort#','c#lineno#')
		
	<cfif url.status eq "0">
	  // document.getElementById('requestedqty_#url.lineno#').value = '0'	 
	  $('##requestedqty_#url.lineno#').prop( 'disabled', true );	
	  $('##requestedqty_#url.lineno#').css( 'background-color', 'f4f4f4' );
	 
	<cfelse>
	
	  $('##requestedqty_#url.lineno#').css( 'background-color', 'C6F2E2' );	 
	  $('##requestedqty_#url.lineno#').prop( 'disabled', false );		
	</cfif>
		
	} catch(e) {}
	
</script>




</cfoutput>

