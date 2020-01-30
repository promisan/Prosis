
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cftry>

<cftransaction>

<cfquery name="Export" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   stExportFile
	WHERE ExportNo = '#URL.ID#'
</cfquery>

<cf_wait text="Revoking export file">

<!--- update Claim records --->
<cfquery name="Delete" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE    Claim
	SET   ExportNo = NULL
	WHERE ExportNo = '#URL.ID#'  
</cfquery>    

<!--- delete file in library --->
<cfquery name="Parameter" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Parameter
</cfquery>

<cftry>
<cffile action="DELETE" file="#SESSION.rootPath#\#Parameter.DocumentLibrary#\#Export.ExportFileId#">
<cfcatch></cfcatch> </cftry> 

<!--- set status = 9 --->

<cfquery name="Delete" 
datasource="AppsTravelClaim" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	DELETE FROM stExportFile
	WHERE ExportNo = '#URL.ID#'  
</cfquery> 

<!--- update Claim records 

	<cfquery name="Delete" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE    stExportFile
		SET   ActionStatus = '9'
		WHERE ExportNo = '#URL.ID#'  
	</cfquery> 
	
---> 

</cftransaction>

	
	<cfcatch>
			
			<cf_waitEnd>
	    	<cftransaction action = "rollback"/>
						    		
				 <cf_ErrorInsert
					 ErrorSource      = "CFCATCH"
					 ErrorReferer     = ""
					 ErrorDiagnostics = "#CFCatch.Message# - #CFCATCH.Detail#"
					 Email = "1">
											 								   			
				<cf_message message="An internal error has occurred and was sent to the administrator for review. <br><br><b>The reversal was NOT processed!" return="back">
					
				<cfabort>
								
		</cfcatch>
		
		
 </cftry>  

<cf_waitEnd>

<cfoutput>

	<script language="JavaScript">
		window.location = "ExportList.cfm?#URL.string#"
	</script> 
</cfoutput>

