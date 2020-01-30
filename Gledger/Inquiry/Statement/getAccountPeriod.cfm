
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
			 				
				 <select name="period" class="regularh" id="period" style="width:200px;font-size:18px;height:30px"
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
