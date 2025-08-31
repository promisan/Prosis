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
<cfquery name="Requisition" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT R.* 
	FROM ItemTransaction I, Request R
	WHERE I.TransactionId       = '#URL.ID#'
	AND I.RequestId = R.RequestId
	
</cfquery>

<cfquery name="Confirm" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE ItemTransactionShipping
	SET    ActionStatus          = '#url.status#', 
	       ConfirmationDate      = getDate(), 
		   ConfirmationUserId    = '#SESSION.acc#',
		   ConfirmationLastName  = '#SESSION.last#',
		   ConfirmationFirstName = '#SESSION.first#'
	WHERE  TransactionId       = '#URL.ID#'
</cfquery>

<cfoutput>

<cfif url.status eq "2">

	<table cellspacing="0" cellpadding="0">
	<tr><td>
	
		 <img src="#SESSION.root#/images/print_small5.gif" 
				    align="absmiddle" 
					style="cursor: pointer;"
					alt="Print Requisition" 
					border="0" 
					onclick="mail3('print','#Requisition.Reference#')">	
		</td>
		<td>&nbsp;</td>
		<td>
	
		<a href="javascript:ColdFusion.navigate('Requester/ShippingListConfirm.cfm?status=0&id=#url.id#','box#url.Id#')">
		 <font color="6688aa">
				 <cf_tl id="Reset"> #Dateformat(now(),CLIENT.DateFormatShow)#
		 </font>
		</a>
	
	</td> 
	
	</tr></table>

<cfelse>	

	<a href="javascript:ColdFusion.navigate('ShippingListConfirm.cfm?status=2&id=#url.id#','box#url.id#')">
	 <font color="6688aa">
		 <cf_tl id="Confirm">
	 </font>
	 </a>

</cfif>

</cfoutput>