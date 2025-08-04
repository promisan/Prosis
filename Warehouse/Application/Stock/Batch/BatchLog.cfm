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

<!--- log of line --->

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemTransaction IT INNER JOIN Item I ON IT.ItemNo = I.ItemNo
		WHERE    TransactionId = '#url.id#'								
	</cfquery>
	
<cfoutput>

<table width="97%" align="center">
<tr class="labelmedium2 line"><td style="height:40px;font-size:20px" colspan="6"><cf_tl id="This line"></td></tr>

<tr class="labelmedium line fixlengthlist">
       <td></td>
	   <td><cf_tl id="Officer"></td>
	   <td><cf_tl id="Date"></td>
	   <td><cf_tl id="Item"></td>
	   <td align="right"><cf_tl id="Quantity"></td>
	   <td align="right"><cf_tl id="COGS"></td>
    </tr>
	
	<cfif get.TransactionQuantity neq "">
	
		<tr class="labelmedium line fixlengthlist" style="background-color:ffffcf">
		    <td style="font-weight:bold"><cf_tl id="Now"></td>
		   <td>#get.OfficerLastName#</td>
		   <td>#dateformat(get.Created,client.dateformatshow)# #timeformat(get.Created,"HH:MM")#</td>
		   <td>#get.ItemNoExternal# #get.ItemDescription#</td>
		   <td align="right">#get.TransactionQuantity*-1#</td>
		   <td align="right">#get.TransactionValue*-1#</td>
	    </tr>
	
	</cfif>

   <cfquery name="ThisLine"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemTransactionDeny IT INNER JOIN Item I ON IT.ItemNo = I.ItemNo
		WHERE    ParentTransactionId = '#url.id#'								
	</cfquery>
	
	<tr class="labelmedium line fixlengthlist">
	   <td style="font-weight:bold"><cf_tl id="Prior"></td>
	   <td>#ThisLine.OfficerLastName#</td>
	   <td>#dateformat(ThisLine.Created,client.dateformatshow)# #timeformat(ThisLine.Created,"HH:MM")#</td>
	   <td>#ThisLine.ItemNoExternal# #ThisLine.ItemDescription#</td>
	   <td align="right">#ThisLine.TransactionQuantity*-1#</td>
	   <td align="right">#ThisLine.TransactionValue*-1#</td>
    </tr>

    <!--- all changes or this order --->

	<cfquery name="All"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     ItemTransactionDeny IT INNER JOIN Item I ON IT.ItemNo = I.ItemNo 
		WHERE    TransactionBatchNo = '#get.TransactionBatchNo#'	and TransactionId <> '#thisLine.Transactionid#'							
	</cfquery>
	
	<cfif all.recordcount gte "1">

		<tr><td style="height:40px"></td></tr>
		<tr class="labelmedium2 line"><td style="height:40px;font-size:20px" colspan="6"><cf_tl id="All amendments for ">#get.TransactionBatchNo#</td></tr>
		
		<cfloop query="All">
		
		<tr class="labelmedium line fixlengthlist">
		   <td></td>
		   <td>#OfficerLastName#</td>
		   <td>#dateformat(Created,client.dateformatshow)# #timeformat(Created,"HH:MM")#</td>
		   <td>#ItemNoExternal# #ItemDescription#</td>
		   <td align="right">#TransactionQuantity*-1#</td>
		   <td align="right">#TransactionValue*-1#</td>
	    </tr>
		
		</cfloop>
	
	</cfif>


</table>

</cfoutput>	
