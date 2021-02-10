
<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes">

<cfparam name="Form.EnforcePassword"   default="0">
<cfparam name="Form.PasswordOverwrite" default="">
<cfparam name="Form.PasswordSupport"   default="">

<cfif form.PasswordOverwrite neq "">
	
	<cfif Len(Trim(Form.PasswordOverwrite)) lte 20> 
	      <!--- encrypt password --->
	      <cf_encrypt text = "#Form.PasswordOverwrite#">
		  <cfset passwordOverwrite = "#EncryptedText#">
	      <!--- end encryption --->
	<cfelse>	  
	      <cfset passwordOverwrite = "#Form.PasswordOverwrite#">
	</cfif>	
	
</cfif>	 
	
<cfif form.PasswordSupport neq "">	 
	
	<cfif Len(Trim(Form.PasswordSupport)) lte 20> 
	      <!--- encrypt password --->
	      <cf_encrypt text = "#Form.PasswordSupport#">
		  <cfset passwordSupport = "#EncryptedText#">
	      <!--- end encryption --->
	<cfelse>	  
	      <cfset passwordSupport = "#Form.PasswordSupport#">
	</cfif>	  

</cfif>
	
<cfquery name="Update" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	UPDATE Parameter
	SET DatabaseServer          = '#Form.DatabaseServer#',
	    DatabaseServerLicenseId = '#Form.DatabaseServerLicenseId#',
	    DatabaseServerTimeZone  = '#form.DatabaseServerTimeZone#',
		VirtualDirectory        = '#Form.VirtualDirectory#',
		EnforcePassword         = '#Form.EnforcePassword#',
		PasswordBasicPattern    = '#Form.PasswordBasicPattern#',
		PasswordMode			= '#Form.PasswordMode#',
		PasswordLength			= '#Form.PasswordLength#',
		PasswordHistory         = '#Form.PasswordHistory#',
		PasswordExpiration      = '#Form.PasswordExpiration#',
		SessionExpiration       = '#Form.SessionExpiration#',
		BruteForce              = '#Form.BruteForce#',
	
		PasswordTip             = '#Form.PasswordTip#',
		DocumentServer          = '#Form.DocumentServer#',
		ReportingServer         = '#Form.ReportingServer#',
		ExchangeServer          = '#Form.ExchangeServer#',
		MailSendMode            = '#Form.MailSendMode#',
		MailOutputMode          = '#Form.MailOutputMode#', 
		LogonMode               = '#Form.LogonMode#',
		ReportingFullScreen     = '#Form.ReportingFullScreen#',
		ReportMailTemplate      = '#Form.ReportMailTemplate#',
		SQLCollate              = '#Form.SQLCollate#',
		DateFormat              = '#Form.DateFormat#',
		DateFormatSQL           = '#Form.DateFormatSQL#',
		LanguageCode		    = '#Form.Language#',
	    DefaulteMail            = '#Form.DefaulteMail#',
		ExceptionControl        = '#Form.ExceptionControl#',
		DataBaseAnalysis        = '#Form.DatabaseAnalysis#',	
		<cfif form.PasswordOverwrite neq "">
		PasswordOverwrite       = '#passwordOverwrite#',
		</cfif>
		<cfif form.PasswordSupport neq "">
		PasswordSupport         = '#passwordSupport#',
		</cfif>
		UserGroupLogon          = '#Form.UserGroupLogon#',
		LogAttachment           = '#Form.LogAttachment#',
		LogonIndexNo            = '#Form.LogonIndexNo#',
		Version                 = '#Form.Version#',
		PromisanServer          = '#Form.PromisanServer#',
		PromisanAccount         = '#Form.PromisanAccount#',
		DisableDocument         = '#Form.DocumentServerDisable#',
		ReplyTo                 = '#Form.ReplyTo#',
		LogonAccountSize        = '#Form.LogonAccountSize#',
		EncodeEngine            = '#Form.EncodeEngine#',
		ExchangeDirectory	    = '#Form.ExchangeDirectory#'	
		<cfif '#Form.AnonymousUserId#' neq "">
		,AnonymousUserId        = '#Form.AnonymousUserId#'
		</cfif>
	WHERE ParameterKey          = '#Form.ParameterKey#'
</cfquery>

<cfquery name="Module" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    M.*
	FROM      Ref_Application A INNER JOIN
	          Ref_ApplicationModule AM ON A.Code = AM.Code INNER JOIN
	          Ref_SystemModule M ON AM.SystemModule = M.SystemModule
	WHERE     A.[Usage] = 'System'
	ORDER BY  A.ListingOrder, M.MenuOrder
</cfquery>

<cfoutput query="Module">
   
   <cftry>
   
   <cfparam name="FORM.Description_#SystemModule#_#client.languageId#" default="#SystemModule#">
     	  
   <cfset desc       = Evaluate("FORM.Description_#SystemModule#_#client.languageId#")>   
   <cfset menu       = Evaluate("FORM.MenuOrder_" & #SystemModule#)>
   <cfset role       = Evaluate("FORM.RoleOwner_" & #SystemModule#)>
   <cfset Lic        = Evaluate("FORM.LicenseId_" & #SystemModule#)>
   <cfparam name     = "FORM.enableReportDefault_#SystemModule#" default="0">
   <cfset rep        = Evaluate("FORM.enableReportDefault_" & #SystemModule#)>
   <cfparam name     = "FORM.operational_#SystemModule#" default="0">
   <cfset ope        = Evaluate("FORM.operational_" & #SystemModule#)>
 
	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_SystemModule
		SET    Description           = '#Desc#',
			   MenuOrder             = '#Menu#',
			   RoleOwner             = '#Role#',
			   LicenseId             = '#Lic#', 
			   EnableReportDefault   = '#rep#',
			   Operational           = '#ope#'
		WHERE  SystemModule          = '#SystemModule#'
	</cfquery>
	
	<cf_LanguageInput
		TableCode       		= "Ref_SystemModule" 
		Key1Value       		= "#SystemModule#"
		Mode            		= "Save"
		Name1            		= "Description"
		Name					= "Description"
		NameSuffix				= "_#SystemModule#"
		Operational     		= "1">
		
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Mission
		FROM   Ref_MissionModule
		WHERE  SystemModule = '#Module.SystemModule#' 
	</cfquery>
		
	<cfloop query = "Mission">	

		<cftry>
		
			   <cfset Lic = Evaluate("FORM.LicenseId_"& #Mission# & #Module.SystemModule#)>
			   
				<cfquery name="qUpdate" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">			
					UPDATE Ref_MissionModule
					SET    LicenseId = '#Lic#'
					WHERE  SystemModule = '#Module.SystemModule#'
					AND    Mission = '#Mission#'
				</cfquery>
				
		<cfcatch></cfcatch>		
		</cftry>
	   
	</cfloop>	
	
	<cfcatch></cfcatch>
	
	</cftry>		 
		 
</cfoutput>

<script> 
    alert('Saved')
    parent.Prosis.busy('no')		
</script>

	
