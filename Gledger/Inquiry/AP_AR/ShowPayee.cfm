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
<cfparam name="CLIENT.payables" default="">

   <cfif url.mode eq "AP">   
	<cfset journalfilter = "'Payables'">
   <cfelse>
    <cfset journalfilter = "'Receivables'">
   </cfif>	
			
   <cfquery name="Payee"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   DISTINCT TOP 10 ReferenceName, ReferenceId,
		         Currency, 
				 				 
				  <cfif url.mode eq "xx">   
				  
					  (SELECT    SUM(AmountOutstanding)
	             	   FROM      Accounting.dbo.TransactionHeader
	              	   WHERE     TransactionCategory IN ('Advances') 
					   AND       Mission = '#url.mission#'
		               AND       ReferenceId = P.ReferenceId 
					   AND       Currency = P.Currency
	             	   AND       ActionStatus <> '9' 
	             	   AND       RecordStatus <> '9' 		              
					  ) as AmountAdvance,
				  				  
				  </cfif>
				  
				 SUM(Amount) as Amount, 
				 SUM(CASE WHEN Amount > 0 THEN AmountOutstanding ELSE AmountOutstanding*-1 END) as Outstanding
				 
		FROM     Inquiry_#url.mode#_#session.acc# P
											 
				  <cfif client.payables eq "">
				   WHERE 1=1
				   <cfelse>
		         #PreserveSingleQuotes(Client.Payables)#	
				 </cfif>
				 
		GROUP BY ReferenceName, ReferenceId, Currency
		ORDER BY SUM(CASE WHEN Amount > 0 THEN AmountOutstanding ELSE AmountOutstanding*-1 END) DESC
	</cfquery>	
	
    <!---	
	<cfoutput>#cfquery.executiontime#</cfoutput>
	--->
		
	<table width="97%" align="center" class="navigation_table">
		
	<cfif findNoCase("ReferenceName","#CLIENT.Payables#")> 
	<tr><td colspan="4" class="labelmedium"><cf_tl id="Summary"></td></tr>
	<cfelse>	
	<!---
	<tr><td colspan="4" height="20" class="labelmedium"><cf_tl id="Top 12"></td></tr>		
	--->
	</cfif>
	
	<cfif url.mode eq "AP">
		<cf_tl id="Payee" var="vLabel">		
	<cfelse>
		<cf_tl id="Debitor" var="vLabel">		
	</cfif>
	
	<tr class="labelmedium fixlengthlist">
		<td style="border:1px solid silver" align="center"></td>
		<td style="border:1px solid silver;padding-left:4px"><cf_tl id="#vLabel#"></td>		
		<td style="border:1px solid silver" align="center"><cf_tl id="Curr"></td>
		<td style="border:1px solid silver;padding-right:3px" align="right"><cf_tl id="Amount"></td>
		<td style="border:1px solid silver;padding-right:3px" align="right"><cf_tl id="Outstanding"></td>
	</tr>
	
	<cfoutput query="Payee">
	
		<tr class="navigation_row linedotted labelmedium fixlengthlist" onclick="javascript:Prosis.busy('yes');_cf_loadingtexthtml='';ptoken.navigate('InquiryListing.cfm?mode=#url.mode#&mission=#url.mission#&systemfunctionid=#url.systemfunctionid#&filter=customer&value=#referencename#','listbox')">
		    <td align="center">#Currentrow#</td>
		    <td style="height:19px;padding-left:4px" title="#referencename#">#ReferenceName#</td>		
			<td style="min-width:40px;padding-right:3px" align="center">#Currency#</td>
			<td style="min-width:70px;padding-right:3px" align="right">#numberformat(amount,',__')#</td>
			<td style="min-width:70px;padding-right:3px" align="right">#numberformat(outstanding,',__')#</td>
		</tr>
		
	</cfoutput>
	
	</table>
	
	<cfset ajaxonload("doHighlight")>
		
<script>
	Prosis.busy('no')
</script>



