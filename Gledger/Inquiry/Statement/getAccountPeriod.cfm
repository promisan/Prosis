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
<cfif url.mission neq "">
		
	<cfquery name="PeriodSelect" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT AccountPeriod 
	    FROM   Period
		WHERE  AccountPeriod IN (SELECT AccountPeriod 
		                         FROM   TransactionHeader 
								 WHERE  Mission = '#URL.Mission#'
								 AND RecordStatus !='9')
		ORDER BY AccountPeriod DESC
	</cfquery>
	
	<!--- default period --->
	<cfset per = PeriodSelect.AccountPeriod>
	
	<table cellspacing="0" cellpadding="0">		
		<tr>		
			<td style="pading-left:4px">			
			 <cfoutput>
			 				
				 <select name="period" class="regularxxl" id="period" style="background-color:f1f1f1;border:0px;width:200px;font-size:18px;height:30px"
				    onChange="transactionperiod()">
					
					<cfloop query="PeriodSelect">
						<option value="#AccountPeriod#" <cfif per eq AccountPeriod>selected</cfif>>#AccountPeriod#</option>													   
					</cfloop>
				  </select>
			  
			  </cfoutput>		  
			  		  		  
			</td>		
		</tr>		
	</table>
	
	<cfoutput>		
	
		<script language="JavaScript">   		 		 
			 rep = document.getElementById('report').value		
			 if (document.getElementById('boxtransactionperiod')) { 
			   ptoken.navigate('getTransactionPeriod.cfm?mission=#url.mission#&accountperiod=#per#&report='+rep,'boxtransactionperiod')
			 }  		 
			 
		</script>
		
	</cfoutput>

</cfif>	
