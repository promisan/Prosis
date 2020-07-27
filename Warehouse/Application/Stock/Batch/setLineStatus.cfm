
<cfoutput>
	
	<cfquery name="Update"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE ItemTransaction
		SET    ActionStatus = '#URL.act#'
		<!---, 
		       ActionUserId    = '#SESSION.acc#',
			   ActionDate      = getDate()
			   --->
		WHERE TransactionId = '#URL.TransactionId#'
	</cfquery>
			
	<cfif url.act eq "0">
	
		 <cfquery name="resetAction" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
                DELETE FROM ItemTransactionAction
				WHERE  TransactionId = '#url.transactionid#'
				AND    ActionCode = 'Consolidated'				
         </cfquery>	
									 
		 <img src="#SESSION.root#/Images/button.jpg"
	     border="0" onclick="setlinestatus('#transactionid#','1')" height="14" width="14" align="absmiddle" style="cursor: pointer;">
				 
	<cfelse>
	
		<cfquery name="recordAction" 
            datasource="AppsMaterials" 
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
              INSERT INTO [dbo].[ItemTransactionAction]
                        (TransactionId,ActionCode,ActionStatus,OfficerUserId,OfficerLastName,OfficerFirstName)
               VALUES ('#url.transactionid#',
                       'Consolidated',
                       '5',                        
                       '#session.acc#',
                       '#session.Last#',
                       '#session.First#')
        </cfquery>
				 
	   <img src="#SESSION.root#/Images/validate.gif"
	     border="0"
		 onclick="setlinestatus('#transactionid#','0')"
		 align="absmiddle"
		 height="14" width="14"
	     style="cursor: pointer;">
				 
	</cfif>

</cfoutput>

<script>
	checkconfirm()
</script>

