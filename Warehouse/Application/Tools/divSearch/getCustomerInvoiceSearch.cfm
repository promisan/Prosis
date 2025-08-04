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

<table style="width:100%;border:1px solid silver" bgcolor="white" class="formpadding">
	
	<input type = "hidden" 
	    name    = "customerinvoiceselectrow" 
		id      = "customerinvoiceselectrow" 
		value   = "0">
	
	<cfif get.recordcount eq "0">
	
		<tr><td height="50" align="center" class="labelmedium" style="padding-left:5px;padding-right:5px"><cf_tl id="No records found."><cf_tl id="Press enter to add"></td></tr>
		
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
		    onclick      = "document.getElementById('customerinvoiceselectbox').className ='hide';ptoken.navigate('#SESSION.root#/warehouse/application/SalesOrder/POS/Sale/applySaleHeader.cfm?field=billing&warehouse=#url.warehouse#&customerid='+document.getElementById('customeridselect').value+'&customeridinvoice=#customerid#&requestno='+document.getElementById('RequestNo').value,'salelines');" 														
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
