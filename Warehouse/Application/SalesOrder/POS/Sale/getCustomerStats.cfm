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
<cfoutput>

	<table class="gray" width="100%" class="formpadding">
		<tr class="labelmedium">
		<td valign="top" style="font-size:15px;padding-top:2px;padding-left:5px"><cf_tl id="Last Sale">:</font></td>
		</tr>
		
		<tr>
		<td style="font-size:15px;padding-top:2px;padding-left:15px">
									
		<table width="100%" class="gray formpadding navigation_table">
		    <cfloop query="Last">
			<tr style="height:20px" class="labelmedium line fixlengthlist navigation_row">
				<td>#dateformat(Created,"DD/MM/YY")# #timeformat(Created,"HH:MM")#</td>	
				<td></td>								
				<td style="padding-right:6px" align="right"><font size="1">#DocumentCurrency#</font> #numberformat(DocumentAmount,',.__')#</td>
			</tr>
			</cfloop>
		</table>
		
		</td>
		</tr>
		
		<tr><td height="10"></td></tr>
		
		<tr class="labelmedium">
		<td valign="top" style="font-size:15px;padding-top:2px;padding-left:10px"><cf_tl id="Year">:</td>
		</tr>
		
		<tr>
		
			<cfquery name="cum" 
			  datasource="AppsLedger" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">					  
			  		SELECT   DocumentCurrency, 
					         SUM(DocumentAmount) AS DocumentAmount, 
							 Year(TransactionDate) as Year
					FROM     TransactionHeader
					WHERE    ReferenceId = '#url.customerid#'	
					-- AND      TransactionDate >= getDate()-1200  
					AND      TransactionSource = 'SalesSeries' 	
					AND      ActionStatus = '1' AND RecordStatus !='9'	
					AND      TransactionCategory = 'Receivables'			
					GROUP BY DocumentCurrency,Year(TransactionDate)
					ORDER BY Year DESC  	
											
			</cfquery>
		
		<td style="font-size:15px;padding-top:2px;padding-left:15px">
		
			<table width="100%" class="formpadding navigation_table">
			
			<cfloop query="cum" startrow="1" endrow="3">	
			<tr style="height:20px" class="labelmedium line navigation_row fixlengthlist">
			<td style="width:100%">#year#</td>							
			<td style="padding-right:6px" align="right"><font size="1">#DocumentCurrency#</font> #numberformat(DocumentAmount,',.__')#</td>							
			</tr>
			</cfloop>					
			</table>
		
		</td>					
		
		</tr>
		
	</table>		
	
</cfoutput>			
<cfset ajaxOnLoad("doHighlight")>
					