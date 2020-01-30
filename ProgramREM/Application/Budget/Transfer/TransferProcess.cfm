
<cfquery name="Lines"
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Sum(Amount) as Amount, 
		       count(*) as Lines
		FROM #SESSION.acc#BudgetTransfer_#client.sessionNo# 
	</cfquery>
	
	<cfif Lines.Amount eq "0" and Lines.Lines gte "2">
	   		
			<input type="button" name="Close" value="Close" class="button10s" style="width:120;height:22" onclick="window.close()">	
			<input type="button" name="Submit" style="width:120;height:22"
				value="Transfer" 
				class="button10g" 
				onclick="ColdFusion.navigate('TransferSubmit.cfm','result','','','POST','transferform')">	
			
	</cfif>
