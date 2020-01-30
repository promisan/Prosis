
<!--- store this as part of the action --->

<cfquery name="get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM   TransactionHeader
	WHERE  TransactionId = '#url.transactionid#'        
</cfquery>

<cfquery name="Check" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   Journal, 
             JournalSerialNo, 
			 TransactionCheckId, 
			 CheckNo, 
			 CheckDate, 
			 CheckPayee, 
			 CheckAmount, 
			 CheckAmountText, 
			 CheckMemo, 
			 CheckOfficer, 
             OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName, 
			 Created			 
	FROM     TransactionIssuedCheck
	WHERE    TransactionCheckId = '#url.id#'        
</cfquery>

<cfset amt = replace("#form.checkamount#",",","")>

<cfif not LSIsNumeric(amt)>
	
	<script>
	    alert('Incorrect amount #amt#')					
	</script>	 
		
	<cfabort>
	
</cfif>

<cfif Form.checkDate neq ''>
    <CF_DateConvert Value="#Form.CheckDate#">
	<cfset dte = dateValue>
<cfelse>
    <cfset dte = 'NULL'>
</cfif>	

<cfif form.actionBankId neq "">

<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   TransactionHeader
		SET      ActionBankId     = '#Form.ActionBankId#'		
		WHERE    TransactionId    = '#get.TransactionId#'  	   
	</cfquery>
	
</cfif>	

<cfif check.recordcount eq "1">
	
	<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   TransactionIssuedCheck
		SET      CheckDate          = #dte#,
		         CheckNo            = '#form.checkNo#',
		         CheckPayee         = '#Form.CheckPayee#',
			     CheckAmount        = '#amt#',
			     CheckAmountText    = '#Form.CheckAmountText#',
			     CheckMemo          = '#Form.CheckMemo#',
			     OfficerUserId      = '#session.acc#',
			     OfficerLastName    = '#session.last#',
			     OfficerFirstName   = '#session.first#'
		WHERE    TransactionCheckId = '#url.id#'  	   
	</cfquery>

<cfelse>	
	
	<cfquery name="Set" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO TransactionIssuedCheck
				(Journal,
				 JournalSerialNo,
				 TransactionCheckId, 
				 CheckNo, 
				 CheckDate, 
				 CheckPayee, 
				 CheckAmount, 
				 CheckAmountText, 
				 CheckMemo, 		
				 CheckOfficer,		 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName )			 
		VALUES ('#get.Journal#',
		        '#get.JournalSerialNo#',
				'#url.id#', <!--- organizationObject.ActionId --->
				'#Form.checkNo#', 
				#dte#,
				'#Form.CheckPayee#',
				'#amt#',
				'#Form.CheckAmountText#',
				'#Form.CheckMemo#',
				'#session.acc#',
				'#session.acc#',
				'#session.last#',
				'#session.first#')
	</cfquery>
		   
</cfif>		   
