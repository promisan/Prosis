
<cfswitch expression="#URL.ID#">

	<cfcase value="Budget">
	
	    <cfquery name="Check" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_AccountReceipt
			WHERE   GLAccount   = '#URL.IDSelect#' 
		</cfquery>
			
		<cfquery name="Update" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Ref_AccountReceipt
				SET     GLAccount   = '#URL.IDSelect#' 
				WHERE   Fund        = '#URL.ID1#'
				AND ObjectCode = '#URL.ID2#' 
		</cfquery>
					
	</cfcase>

</cfswitch>

<cfoutput>
	
	<script>     
		 parent.document.getElementById('refresh#url.id1#_#url.id2#').click()	
		 parent.ColdFusion.Window.destroy('mydialog',true)	
	</script>

</cfoutput>
