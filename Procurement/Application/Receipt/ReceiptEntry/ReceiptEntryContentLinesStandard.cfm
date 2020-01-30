
<cfoutput>

<table width="99%">

	<tr class="line labelmedium">
	<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;"><cf_tl id="No"></td>
	<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;"><cf_tl id="Description"></td>
	<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;"><cf_tl id="Reference"></td>
	<cfif Purchase.ReceiptEntryForm eq "Standard">
		<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;"><cf_tl id="Shipped"></td>
	</cfif>
	<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;"><cf_tl id="Accepted"></td>
	<cfif Purchase.ReceiptEntryForm eq "Standard">
		<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;"><cf_tl id="Difference"></td>
	</cfif>	
	<td align="center" style="border-top:1px solid silver;border-bottom:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;"><cf_tl id="Memo"></td>			
	</tr>		
	
	<cfquery name="CheckPrior" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PurchaseLineReceiptDetail
		WHERE  ReceiptId = '#URL.Rctid#'						
	</cfquery>
				
	<cfif checkprior.recordcount gt rows>
	    <cfset rows = checkprior.recordcount>
	</cfif>			
			
	<cfloop index="itm" from="1" to="#rows#">
	
			<cfquery name="LineDetail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   PurchaseLineReceiptDetail
				WHERE  ReceiptId = '#URL.Rctid#'
				AND    ReceiptLineNo = '#itm#'
			</cfquery>
			
			<tr>
			   <td class="labelit" style="height:22px;min-width:30px;text-align:center;border-bottom:1px solid silver;border-left:1px solid silver;">#itm#.			   
			   <input type="hidden" name="f#itm#_ReceiptLineNo" id="f#itm#_ReceiptLineNo" value="#itm#">
			   </td>
			   
			    <td width="35%" style="min-width:100px;border:0px;border-left:1px solid silver;border-bottom:1px solid silver;height:100%">				
			    <cfinput type="Text" 
				  name="f#itm#_containername" 
				  id="f#itm#_containername"
				  value="#LineDetail.Containername#" 						  						
				  class="regularh enterastab"
				  required="No"
				  maxlength="50" 
				  style="font-size:12px;border:0px;width:100%;height:100%"
				  size="16">
			   </td>
			   
			    <td style="min-width:90px;border:0px;border-left:1px solid silver;border-bottom:1px solid silver;height:100%">
			    <cfinput type="Text" 
				  name="f#itm#_containerseal" 
				  id="f#itm#_containerseal" 
				  value="#LineDetail.ContainerSeal#" 						  						 
				  class="regularh enterastab"
				  required="No" 
				  maxlength="10" 
				  style="font-size:12px;text-align:left;border:0px;width:100%;height:100%"
				  size="8">
			   </td>
			   					   
			   <cfif Purchase.ReceiptEntryForm eq "Standard">
			   <td style="min-width:70px;border:0px;border-left:1px solid silver;border-bottom:1px solid silver;height:100%">
				    <cfinput type="Text" 
					  name="f#itm#_quantityshipped" 
					  id="f#itm#_quantityshipped"
					  value="#LineDetail.QuantityShipped#" 
					  message="Enter a valid quantity" 
					  validate="float" 
					  class="regularh enterastab"
					  required="No" 
					  size="7" 					  
					  style="font-size:12px;text-align:right;border:0px;width:100%;height:100%"
					  range="1,10000000"
					  onChange="ColdFusion.navigate('ReceiptLineEditSetQuantity.cfm?rows=#rows#','processlines','','','POST','entry')">
			   </td>
			   <cfelse>
			   	   <input type="hidden" id="f#itm#_quantityshipped" name="f#itm#_quantityshipped" value="">
			   </cfif>	   
			   
			   <td style="min-width:70px;border:0px;border-left:1px solid silver;border-bottom:1px solid silver;height:100%">
			    <cfinput type="Text" 
				  name="f#itm#_quantityaccepted" 
				  id="f#itm#_quantityaccepted" 
				  value="#LineDetail.QuantityAccepted#" 
				  message="Enter a valid quantity" 
				  validate="float" 
				  class="regularh enterastab"
				  required="No" 
				  size="6" 
				  style="font-size:12px;text-align:right;border:0px;width:100%;height:100%"
				  range="1,10000000"
				  onChange="ColdFusion.navigate('ReceiptLineEditSetQuantity.cfm?rows=#rows#','processlines','','','POST','entry')">
			   </td>	
			   
			   <cfif Purchase.ReceiptEntryForm eq "Standard">
				   <td style="min-width:70px;border:0px;border-left:1px solid silver;border-bottom:1px solid silver;height:100%">
				    <input type="Text" 
					  name="f#itm#_quantityvariance" 
	                  id="f#itm#_quantityvariance"
					  value="#LineDetail.QuantityVariance#" 
					  message="Enter a valid quantity" 
					  readonly
					  tabindex="999"
					  class="regularh enterastab"						
					  size="6" 
					  style="font-size:12px;text-align:right;border:0px;width:100%;height:100%">
				   </td>
				<cfelse>
					<input type="hidden" id="f#itm#_quantityvariance" name="f#itm#_quantityvariance" value="">				
			   </cfif>		   	
			   
			   <td width="85%" style="border:0px;border-left:1px solid silver;border-right:1px solid silver;border-bottom:1px solid silver;width:100%;height:100%">
			    <cfinput type="Text" 
				  name="f#itm#_Observation" 
				  id="f#itm#_Observation" 
				  value="#LineDetail.Observation#" 						  						 
				  class="regularh enterastab"
				  required="No" 
				  maxlength="50"
				  style="font-size:12px;border-right:1px solid silver;border:0px;width:100%;height:100%"
				  size="14">
			   </td>
			   
		   </tr>
					
	</cfloop>

</table>

</cfoutput>	