<!--
    Copyright © 2025 Promisan B.V.

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
			FROM   CustomerRequest L
			WHERE  Warehouse  = '#getRequest.Warehouse#'
			AND    CustomerID = '#getRequest.Customerid#'
			AND    AddressId  = '#getRequest.AddressId#'		
			AND    ActionStatus != '9' 
			AND    BatchNo is NULL	
			AND    (RequestNo NOT IN (SELECT Requestno 
			                         FROM CustomerRequestLine 
									 WHERE RequestNo = L.RequestNo 
									 AND BatchId is not NULL) or RequestNo = '#url.requestNo#')
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
			
	<td align="center" onclick="stockquotedialog('#url.requestNo#')" style="cursor:pointer;font-size:17px;padding-top:2px;background-color:white;padding-left:6px;padding-right:6px;cursor:pointer;border-left:0px solid gray">
		#getRequest.Source#				
	</td>		
		
	<td style="min-width:90px;border-right:0px solid gray">	
		
	<select name="RequestNo"  id="RequestNo" style="text-align:center;font-size:19px;height:100%;min-width:100%;border:0px;" class="regularXXL" 
	onchange="ptoken.navigate('#SESSION.root#/warehouse/application/salesorder/POS/sale/applyCustomer.cfm?requestNo='+this.value+'&mission=#getRequest.Mission#&warehouse=#getRequest.warehouse#&category=&itemno=&search=&customerid='+document.getElementById('customeridselect').value+'&addressid=#getRequest.AddressId#','customerbox')">													
		<cfloop query="RequestNos">
			<option value="#RequestNo#" <cfif url.requestNo eq RequestNo>selected</cfif>>#RequestNo#</option>
		</cfloop>
	</select>	
	
	</td>	
		
	<td align="center" style="padding-left:6px;padding-right:6px;;border-left:0px solid gray">
	
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