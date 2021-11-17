
<cfparam name="Form.EnableURLCheck"          default="0">
<cfparam name="Form.EnableFormCheck"         default="0">
<cfparam name="Form.EnableError"             default="0">
<cfparam name="Form.EnableDetailError"       default="0">
<cfparam name="Form.DefaultPassword"         default="">
<cfparam name="Form.EnableReportAudit"       default="2">
<cfparam name="Form.DocumentServerPassword"  default="">
<cfparam name="Form.ApplicationTheme"        default="Standard">
<cfparam name="Form.ApplicationThemeLogo"        default="">
<cfparam name="Form.ApplicationThemeBackground"  default="">

<cfif item eq "Connection">	
		
	<cfif len(form.StartHour) eq "1">
		<cfset form.starthour = "0#Form.StartHour#">
	</cfif>	
		
	<cfif len(form.EndHour) eq "1">
		<cfset form.Endhour = "0#Form.EndHour#">
	</cfif>	
		
	<cfif len(form.StartMinute) eq "1">
		<cfset form.StartMinute = "0#Form.StartMinute#">
	</cfif>	
		
	<cfif len(form.EndMinute) eq "1">
		<cfset form.EndMinute = "0#Form.EndMinute#">
	</cfif>	
	
<cfelseif item eq "location">
	
	<cfset vPass = "">
	<cfif Form.DocumentServerPassword neq "">
		<cfif Len( Form.DocumentServerPassword) lte 25> 
		   <cf_encrypt text = "#Form.DocumentServerPassword#">
		   <cfset vPass = "#EncryptedText#">
		<cfelse>	  
		   <cfset vPass = "#Form.DocumentServerPassword#">
		</cfif>	
	</cfif>
	
<cfelseif item eq "security">
	
	<cfif Len(Trim(Form.DefaultPassword)) lte 20> 
	      <!--- encrypt password --->
	      <cf_encrypt text = "#Form.DefaultPassword#">
		  <cfset adminpw = "#EncryptedText#">
	      <!--- end encryption --->
	<cfelse>	  
	      <cfset adminpw = "#Form.DefaultPassword#">
	</cfif>	
	
<cfelseif item eq "Settings">

     <cfif Len(Trim(Form.CFAdminPassword)) lte 20> 
	      <!--- encrypt password --->		
	      <cf_encrypt text = "#Form.CFAdminPassword#">
		  <cfset adminpw = "#EncryptedText#">
	      <!--- end encryption --->
	<cfelse>	  
	      <cfset adminpw = "#Form.CFAdminPassword#">
	</cfif>		

</cfif>  

	
<cfquery name="Log" 
	datasource="AppsInit">
		SELECT Max(LogSerialNo) as Last
		FROM ParameterLog 		
	</cfquery>
	
<cfif Log.Last eq "">
	  <cfset No = "1">
<cfelse>
	  <cfset No = #Log.Last#+1>
</cfif>
	
<cfquery name="Log" 
	datasource="AppsInit">
		INSERT INTO ParameterLog 
		(LogSerialNo,LogStamp,OfficerUserId,OfficerLastName,OfficerFirstName)
		VALUES
		('#No#',getDate(),'#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
</cfquery>


<cfloop index="itm" list="parameter,parameterlog">
		
	<cfquery name="Update" 
		datasource="AppsInit">
		UPDATE #itm#
		SET    
			   
			   <cfif item is "Connection">
			   
				   SystemContact         = '#Form.SystemContact#',
				   SystemContactEMail    = '#Form.SystemContactEMail#',
				   <cfif Form.SystemSupportPortalId neq "">
				   SystemSupportPortalId = '#Form.SystemSupportPortalId#',
				   <cfelse>
				   SystemSupportPortalId = NULL,
				   </cfif>
			       AccountNotification   = '#Form.AccountNotification#',
				   Operational           = '#Form.Operational#',
				   <cfif form.StartHour neq "" and Form.EndHour neq "">
					DisableTimeStart      = '#form.StartHour#:#form.StartMinute#',
					DisableTimeEnd        = '#form.EndHour#:#form.EndMinute#',
				   <cfelse>	
				    DisableTimeStart      = NULL,
					DisableTimeEnd        = NULL,
				   </cfif>				   
				   OperationalMemo       = '#Form.OperationalMemo#',
				   EnableCM              = '#Form.EnableCM#',
				   PasswordReset         = '#Form.PasswordReset#',
				   
			   <cfelseif item is "Owner">
			   
			   	   EnableError           = '#Form.EnableError#',
			   	   EnableDetailError     = '#Form.EnableDetailError#', 
				   ErrorMailToOwner      = '#Form.ErrorMailToOwner#',
				   <!---  ErrorWorkflow         = '#Form.ErrorWorkFlow#', --->
				   EnableReportAudit     = '#Form.EnableReportAudit#',
				   EnableReportArchive   = '#Form.EnableReportArchive#',
				   
			   <cfelseif item is "Settings">  
			   
			   	   SystemTitle           = '#Form.SystemTitle#',
				   SystemSubTitle        = '#Form.SystemSubTitle#',
				   SystemNote            = '#Form.SystemNote#', 
				   SystemDevelopment     = '#Form.SystemDevelopment#',
				   SystemLabelBanner     = '#Form.SystemLabelBanner#',
				   SystemLabelFooter     = '#Form.SystemLabelFooter#',
			       ApplicationTheme      = '#Form.ApplicationTheme#',
			       ApplicationThemeLogo  = '#Form.ApplicationThemeLogo#',
			       ApplicationThemeBackground = '#Form.ApplicationThemeBackground#',		
				   ApplicationServer     = '#Form.ApplicationServer#',
				   CFAdminUser			 = '#Form.CFAdminUser#',
				   CFAdminPassword       = '#adminpw#',
			       HostName              = '#Form.HostName#',
				   GoogleMAPId           = '#Form.GoogleMAPId#',
				   GoogleSigninKey       = <cfif trim(Form.GoogleSigninKey) neq "">'#trim(Form.GoogleSigninKey)#'<cfelse>NULL</cfif>,
				   TreeAnimationPath	 = '#Form.TreeAnimationPath#',		
				   
			   <cfelseif item is "Location">    	
			   
			   	   ApplicationRoot       = '#Form.ApplicationRoot#',	
				   ApplicationHome       = '#Form.ApplicationHome#',					  	 
				   ApplicationRootPath   = '#Form.ApplicationRootPath#',	
				   		 
				   DocumentRoot          = '#Form.DocumentRoot#',
				   DocumentRootPath      = '#Form.DocumentRootPath#',	
				   DocumentServer        = '#Form.DocumentServer#',
				   DocumentServerLogin   = '#Form.DocumentServerLogin#',
				   DocumentServerPassword = '#vPass#',		
				   
				   ReportRoot            = '#Form.ReportRoot#',
				   ReportRootPath        = '#Form.ReportRootPath#',		
				   ReportPageType        = '#Form.ReportPageType#',
				   
				   LogoPath              = '#Form.LogoPath#', 
				   LogoFileName          = '#Form.LogoFileName#',   
				   
				   AppLogoPath           = '#Form.AppLogoPath#', 
				   AppLogoFileName       = '#Form.AppLogoFileName#', 
				   
				   XLSEngine             = '#Form.XLSEngine#',
				   PDFEngine             = '#Form.PDFEngine#',			  	 
				   
				   SchedulerRoot         = '#Form.SchedulerRoot#',	
					
			   <cfelseif item is "Security"> 
				 			      			  
				   DefaultLogin              = '#Form.DefaultLogin#',				 
				   <cfif Form.DefaultPassword neq "">
				    DefaultPassword          = '#adminpw#',
				   </cfif>		
				   SessionProtectionMode     = '#Form.SessionProtectionMode#',
				   SessionProtectionInterval = '#Form.SessionProtectionInterval#',	 				 		 			 			
				   URLProtectionMode         = '#Form.URLProtectionMode#',
				   MIDThreshold              = '#Form.MIDThreshold#',
				   EnableURLCheck            = '#Form.EnableURLCheck#',
				   EnableFORMCheck           = '#Form.EnableFormCheck#',
				   TemplateLogging           = '#Form.TemplateLogging#',
				   DisableIPRouting          = '#Form.DisableIPRouting#',
			   	   			   
			   </cfif>
			   			   
			   OfficerUserId         = '#SESSION.acc#',
			   OfficerLastName       = '#SESSION.last#',
			   OfficerFirstName      = '#SESSION.first#',
			   
		<cfif itm eq "Parameter">
			   DateUpdated           = getDate() 
		WHERE  HostName            = '#url.host#' 	
		<cfelse>	
		       LogStamp            = getDate()	
		WHERE  LogSerialNo         = '#No#' 	
		</cfif>
		
		</cfquery>
	
</cfloop>

<cfinclude template="ParameterEdit#item#.cfm">

<script>
	Prosis.busy('no')
</script>
