
<!--- store this as part of the action --->

<cfquery name="get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM   TransactionHeader
	WHERE  TransactionId = '#form.key4#'        
</cfquery>

<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   TransactionHeader
		SET      ReferenceName    = '#Form.ReferenceName#',
          		 ReferenceNo      = '#Form.ReferenceNo#'				
		WHERE    TransactionId    = '#get.TransactionId#'  	   
</cfquery>
	