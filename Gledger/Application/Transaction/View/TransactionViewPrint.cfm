<cfparam name="Object.ObjectKeyValue4" default="">		  
<cfparam name="URL.TransactionId" default="#Object.ObjectKeyValue4#">	

<cfquery name="Header" 
	  datasource="AppsLedger" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT * 
		FROM   TransactionHeader
		WHERE  TransactionId  ='#URL.TransactionId#'		
</cfquery>	

<cfif Header.PrintDocumentId neq "">

    <cfset url.docid = Header.PrintDocumentId>
	<cfset url.id  = "Print">
	<cfset url.id1 = "Financial Transaction">
			
	<cfinclude template="../../../../Tools/Mail/MailPrepare.cfm">
			
<cfelse>
	
	<!--- not defined --->

</cfif>		


