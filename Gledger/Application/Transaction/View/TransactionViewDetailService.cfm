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
<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">
						
	<tr class="cellcontent linedotted">

		 <td></td>
		 <td>Class</td>
		 <td>Reference</td>
		 <td>IndexNo</td>
		 <td colspan="2">Name</td>
		 <td>Charge</td>
		 <td>Curr</td>
		 <td align="right">Amount</td>
	 
	</tr>
			
	<cfset amt = 0>
	
	<cfoutput query="ChargeDetails">	
	    				
		<cfset amt = amt + TransactionAmount>
		
		<tr class="cellcontent linedotted navigation_row">
		
			<td>#currentrow#.</td>
			<td>#UnitClass#</td>	
			<td>#Reference#</td>					
			<td>#IndexNo#</td>
			<td>#LastName#</td>
			<td>#FirstName#</td>
			<td>#Charged#</td>
			<td>#Currency#</td>					
			<td align="right" style="padding-right:3px">#numberformat(TransactionAmount,",__.__")#</td>
						
		</tr>	
					
	</cfoutput>	
	
	<cfif abs(amt-documentAmount) gt 1>
	
		<tr>
		   <td colspan="9" align="center" class="labelmedium"><font color="FF0000">Details are not in sync !</td>
	    </tr>
	
	</cfif>	

</table>