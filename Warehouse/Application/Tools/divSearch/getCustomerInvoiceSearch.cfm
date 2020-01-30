
<cfif url.search eq "">

	<script>
		 document.getElementById("customerinvoiceselectbox").className = "hide"
	</script> 

<cfelse>

	<script>
		 document.getElementById("customerinvoiceselectbox").className = ""
	</script> 
	
</cfif>

<cfquery name="Get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     TOP 10 A.*		
		FROM       Customer A 			
		WHERE      (Reference LIKE '%#url.search#%' OR CustomerName LIKE '%#url.search#%' OR PhoneNumber LIKE '%#url.search#%' OR eMailAddress LIKE '%#url.search#%')		
		AND        Operational = 1
		AND        Mission = '#url.mission#'
		ORDER BY   CustomerName 
</cfquery>

<table width="500" style="border:1px solid silver" cellspacing="0" cellpadding="0" bgcolor="white" class="formpadding">
	
	<input type = "hidden" 
	    name    = "customerinvoiceselectrow" 
		id      = "customerinvoiceselectrow" 
		value   = "0">
	
	<cfif get.recordcount eq "0">
	
		<tr><td height="50" align="center" class="labelmedium"><cf_tl id="No records found."> [<cf_tl id="Press enter to add">]</td></tr>
		
		  <script>
			document.getElementById('customerinvoiceidselect').value='insert' // this will prevent the message to appear
		  </script>
	
	</cfif>

	<cfoutput query="get">
	
		<cfif currentrow eq "1">
	
	    <script>
			document.getElementById('customerinvoiceidselect').value='#customerid#'
		</script>
		
		</cfif>
	
		<tr><td id       = "customerinvoiceline#currentrow#" 
		    name         = "customerinvoiceline#currentrow#" 
		    onclick      = "document.getElementById('customerinvoiceselectbox').className ='hide';ColdFusion.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=billing&warehouse=#url.warehouse#&customerid='+document.getElementById('customeridselect').value+'&customeridinvoice=#customerid#','salelines');" 														
		    class        = "regular" 
			style        = "cursor:pointer"
		    onmouseover  =  "if (this.className=='regular') { this.className='highlight2' }"
			onmouseout   =  "if (this.className=='highlight2') { this.className='regular' }">
										
			<input type="hidden" name="r_#currentrow#_customerinvoicemeta" id="r_#currentrow#_customerinvoicemeta" value="#get.Reference#">				
			<input type="hidden" name="r_#currentrow#_customerinvoiceid"   id="r_#currentrow#_customerinvoiceid"   value="#CustomerId#">
						
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
				<tr>				  
				    <td colspan="3" height="20" style="padding-left:10px" class="labelmedium">
					#get.CustomerName# 
					</td>	
				</tr>
				
				<tr>				
				    <td width="20%" style="padding-left:20px;padding-right:10px" class="labelmedium">
					#get.Reference#
				</td>								  
			    <td height="20" style="padding-left:10px" width="70%" class="labelmedium">
					#get.PhoneNumber#
				</td>				
			    <td width="20%" style="padding-right:10px" class="labelmedium">
					#get.eMailAddress#
				</td>		
				</tr>			
								
				<cfif currentrow neq recordcount>
					<tr><td colspan="4" class="linedotted"></td></tr>
				</cfif>
			
			</table>
		
		</td></tr>
				
	</cfoutput>

</table>
