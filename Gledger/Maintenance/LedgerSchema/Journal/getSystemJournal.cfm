<cfquery name="Preset" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_SystemJournal
	WHERE Area NOT IN (SELECT DISTINCT SystemJournal 
	                   FROM   Journal 
					   WHERE  Mission  = '#url.mis#'
					   AND    TransactionCategory != '#url.Cat#'
					   AND    SystemJournal is not NULL) 
	</cfquery>
 
 	<select name="SystemJournal" class="regularxl">
		<option value="" selected>N/A</option>
    	   <cfoutput query="Preset">
       	<option value="#Area#">#area#</font>
		</option>
        	</cfoutput>
	</select>
	
	<script>
	<cfif url.cat eq "Payment" or url.cat eq "DirectPayment">
	  document.getElementById("bank").className = "regular"
	<cfelse>  
	  document.getElementById("bank").className = "hide"
	</cfif>
	</script>
		
		