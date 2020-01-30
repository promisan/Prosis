
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.SystemDefault" default="0">
<cfparam name="Form.Interface" default="0">

<cfif Form.SystemDefault eq "1">

<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemLanguage
		SET  SystemDefault  = '0'
	</cfquery>
	
</cfif>	

<cfif ParameterExists(Form.Update)>

	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemLanguage
		SET    LanguageName   = '#Form.Description#',
		       Interface = '#form.Interface#',
		       Operational    = '#Form.Operational#',
			   SystemDefault  = '#Form.SystemDefault#'
		WHERE  Code = '#Form.Code#'
	</cfquery>
	
</cfif>	

<cfif Form.SystemDefault eq "1">

<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemLanguage
		SET    Operational  = '2'
		WHERE  Operational < '2'
		AND    Code = '#Form.Code#' 		
	</cfquery>
	
</cfif>	

<!--- initializing --->

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
