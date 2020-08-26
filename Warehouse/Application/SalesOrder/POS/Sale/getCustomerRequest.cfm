
<cfparam name="url.scope" default="POS">

<cfquery name="getRequest"
		datasource="AppsMaterials"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
		SELECT *
		FROM   CustomerRequest
		WHERE  RequestNo = '#URL.RequestNo#'
</cfquery>

<cfif getRequest.recordcount eq "0">

<cfelse>
	
	<cfquery name="RequestNos"
			datasource="AppsMaterials"
			username="#SESSION.login#"
			password="#SESSION.dbpw#">
			SELECT *
			FROM   CustomerRequest
			WHERE  Warehouse  = '#getRequest.Warehouse#'
			AND    CustomerID = '#getRequest.Customerid#'
			AND    AddressId  = '#getRequest.AddressId#'		
			AND    ActionStatus != '9' 
			AND    BatchNo is NULL		
			ORDER BY RequestNo DESC		
	</cfquery>
	
	<cfoutput>
	
			
	<table style="height:100%">
	<tr>
	
	<cfif url.customerid neq "00000000-0000-0000-0000-000000000000" 
	  and url.customerid neq ""
	  and url.scope eq "POS">
	
	<td align="center" style="padding-left:6px;padding-right:6px">
		<i class="fas fa-minus-circle" style="cursor:pointer;color:##033F5D;font-size:18px;padding-top:3.5px;;min-width:25px" class="clsNoPrint" 
			onclick="_cf_loadingtexthtml='';javascript:ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applyCustomer.cfm?quote=delete&requestNo=#url.requestno#&&mission=#getRequest.Mission#&warehouse=#getRequest.warehouse#&category=&itemno=&search=&customerid='+document.getElementById('customeridselect').value+'&addressid=#getRequest.AddressId#','customerbox')">
    	</i>
				
	</td>	
			
	<td align="center" onclick="stockquotedialog('#url.requestNo#')" style="cursor:pointer;font-size:17px;padding-top:2px;background-color:white;padding-left:6px;padding-right:6px;cursor:pointer;border-left:1px solid gray">
		#getRequest.Source#				
	</td>		
		
	<td style="min-width:70px;border-right:1px solid gray">	
		
	<select name="RequestNo"  id="RequestNo" style="text-align:center;font-size:20px;height:100%;width:100%;border:0px;" class="regularXXL" 
	onchange="ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applyCustomer.cfm?requestNo='+this.value+'&mission=#getRequest.Mission#&warehouse=#getRequest.warehouse#&category=&itemno=&search=&customerid='+document.getElementById('customeridselect').value+'&addressid=#getRequest.AddressId#','customerbox')">						
							
		<cfloop query="RequestNos">
			<option value="#RequestNo#" <cfif url.requestNo eq RequestNo>selected</cfif>>#RequestNo#</option>
		</cfloop>
	</select>	
	
	</td>	
		
	<td align="center" style="padding-left:6px;padding-right:6px;;border-left:1px solid gray">
	<i class="fas fa-plus-circle" style="cursor:pointer;color:##033F5D;font-size:18px;padding-top:3.5px;;min-width:25px" class="clsNoPrint" 
			onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applyCustomer.cfm?quote=add&mission=#getRequest.Mission#&warehouse=#getRequest.warehouse#&category=&itemno=&search=&customerid='+document.getElementById('customeridselect').value+'&addressid=#getRequest.AddressId#','customerbox')">
	 </i>	
	
	</td>
		
	<cfelse>
	
	<td>		
	<input type="hidden" id="RequestNo" name="RequestNo" value="#url.RequestNo#">
	</td>
	
	</cfif>
	
	</tr>
	</table>
	
	</cfoutput>

</cfif>