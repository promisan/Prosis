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

<cfquery name="Lines" 
	 	datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    CI.*
		FROM      ClaimEventIndicatorCost CI INNER JOIN
                  ClaimEvent CE ON CI.ClaimEventId = CE.ClaimEventId
		WHERE     CI.IndicatorCode = 'Ticket' 
		AND       CE.ClaimId = '{D505AB80-CF15-4B33-907C-36802755DC0F}'		
</cfquery>

<cfoutput>

<cfparam name="URL.claimRequestId" default="{25D08AE4-2E02-4374-B96F-0BA7B9C07218}">

<cf_ajaxRequest>

<script>
	
	function refresh(no,req,val) {
	 	
		url = "DocumentSFTMatchingSubmit.cfm?claimrequestid=#url.claimrequestid#&transactionno="+no+"&claimrequestlineno=" + req + "&amount=" + val
			 
		 	AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 
					
		     document.getElementById("ln"+no).innerHTML = req.responseText;
					
			 },
						
	        'onError':function(req) { 
			
			 document.getElementById("ln"+no).innerHTML = req.responseText;
				}	
	         }
		 );	
		
	 }	
 
 </script>

<table width="100%">
<cfloop query="Lines">
<tr>
<td width="120">#InvoiceNo#</td>
<td width="50">#InvoiceCurrency#</td>
<td width="140">#InvoiceAmount#</td>
<td></td>
</tr>

	<tr><td></td>
	    <td colspan="3" id="ln#transactionno#">
    	<cfset url.transactionNo="#transactionNo#">
		<cfinclude template="DocumentSFTMatchingSubmit.cfm">
		
	</td></tr>

</cfloop>
</table>
		
</cfoutput>		