
<cfparam name="Form.Pref_LoadDashboard" default="0">
<cfparam name="Form.Pref_BCC" default="0">
<cfparam name="Form.Pref_LoadDashboard" default="1:3:1">

<cfif url.id eq "Identification">

	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   UserNames 		
		WHERE  Account = '#SESSION.acc#'  
	</cfquery>
	
	<cfquery name="Mail" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Parameter 	
	</cfquery>
	
	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE   UserNames 
	SET      LastName                 = '#Form.LastName#',
			 FirstName                = '#Form.FirstName#',
			 IndexNo                  = '#Form.IndexNo#',
			 AccountNo                = '#Form.AccountNo#',
			 eMailAddress             = '#Form.eMailAddress#',
			 eMailAddressExternal     = '#Form.eMailAddressExternal#',	
			 MailServerAccount        = '#Form.MailServerAccount#'
			 <cfif Mail.ExchangeServer neq "">			 
			 ,MailServerPassword       = '#Form.MailServerPassword#'			
			 </cfif>
	WHERE Account = '#SESSION.acc#'
	</cfquery>
		
	<cfif check.eMailAddressExternal neq Form.eMailAddressExternal>
	
		<!--- ----------------------- --->
	    <!--- send email notification --->
	   	
		<cf_MailUserAddressChange 
		     account="#check.account#">			 						 
		   
   </cfif>	  
   
<cfelseif url.id eq "Signature">	

	<cfparam name="form.Pref_Signature" default="0">

	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   UserNames 
		SET      Pref_Signature           = '#Form.Pref_Signature#',
		         Pref_SignatureBlock      = '#Form.Pref_SignatureBlock#' 
		WHERE Account = '#SESSION.acc#'
	</cfquery>
	
	
<cfelseif url.id eq "Presentation">	

	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE   UserNames 
		SET      Pref_Color               = '#Form.Pref_Color#',
		         Pref_GoogleMAP           = '#Form.Pref_GoogleMAP#',
	        	 Pref_PageRecords         = '#Form.Pref_PageRecords#',
				 Pref_Timesheet           = '#Form.Pref_Timesheet#',
				 <cfif Form.SystemLanguage neq "">
				 Pref_SystemLanguage      = '#Form.SystemLanguage#'
				 <cfelse>
				 Pref_SystemLanguage      = NULL
				 </cfif>	
		WHERE Account = '#SESSION.acc#'
	</cfquery>
	
	<cfif client.googlemapid neq "">	
		<cfset Client.GoogleMap = "#Form.Pref_GoogleMAP#">
	</cfif>	
		
<cfelseif url.id eq "Workflow">		

	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			UPDATE   UserNames 
			SET      AccountDelegate          = '#Form.AccountDelegate#',
					 <!---
					 Pref_WorkflowMail        = '#Form.Pref_WorkflowMail#',
					 --->
					 Pref_WorkflowMailAccount = '#Form.Pref_WorkflowMailAccount#',
			         Pref_BCC                 = '#Form.Pref_BCC#',
					 Pref_SMS                 = '#Form.Pref_SMS#'	
			WHERE Account = '#SESSION.acc#'
	</cfquery>
	
	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Entity 
		WHERE  Operational = 1
		AND    Role NOT IN (SELECT Role 
		                    FROM   Ref_AuthorizationRole 
							WHERE  SystemModule = 'System')
	</cfquery>
	
	<cfloop query="Get">
	
	    <cfset ent = replace(entityCode,"-","","ALL")> 
	
		<cfparam name="Form.Mail_#ent#" default="0">
		<cfparam name="Form.Task_#ent#" default="0">
		
		<cfset mail = evaluate("Form.Mail_#ent#")>
		<cfset task = evaluate("Form.Task_#ent#")>
	
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    UserEntitySetting
			WHERE   Account     = '#SESSION.acc#'
			AND     EntityCode  = '#EntityCode#'
		</cfquery>
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="INSERT" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT  UserEntitySetting
				        (Account,EntityCode,EnableMailNotification,EnableExchangeTask)
				VALUES  ('#SESSION.acc#','#EntityCode#','#mail#','#task#')
			</cfquery>		
		
		<cfelse>		
		
			<cfquery name="Update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE  UserEntitySetting
				SET     EnableMailNotification = '#mail#',
				        EnableExchangeTask = '#task#'
				WHERE   Account = '#SESSION.acc#'
				AND     EntityCode = '#EntityCode#'
			</cfquery>		
		
		</cfif>
	
	</cfloop>
	
	
<cfelseif url.id eq "Dashboard">		

	<cfquery name="UpdateUser" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  UserNames 
	SET     Pref_LoadDashboard       = '#Form.Pref_LoadDashboard#',	
			Pref_DashBoard           = '#Form.Pref_Dashboard#'  
	WHERE   Account = '#SESSION.acc#'
	</cfquery>	

</cfif>

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM   UserNames 
WHERE  Account = '#SESSION.acc#'
</cfquery>

<cfoutput>
<cfset SESSION.first        = "#Get.FirstName#">
<cfset SESSION.last         = "#Get.LastName#">
<cfset CLIENT.eMailExt      = "#Get.eMailAddressExternal#">
<cfset CLIENT.Pagerecords   = "#Get.Pref_PageRecords#">
<cfset CLIENT.interface     = "#Get.Pref_Interface#">

<!---

<cfif Form.SystemLanguage neq "">

   <cfset CLIENT.LanguageId = "#Form.SystemLanguage#">
	   
   <cfquery name="Language" 
 	datasource="AppsSystem"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT *
	 FROM Ref_SystemLanguage
	 WHERE Code = '#Form.SystemLanguage#'  
	</cfquery> 
	
	<cfif #Language.SystemDefault# eq "1" or #Language.Operational# eq "1">
	   <cfset CLIENT.LanPrefix     = "">
	<cfelse>   
	   <cfset CLIENT.LanPrefix     = "xl"&#URL.ID#&"_">
	</cfif>
	
<cfelse>

    <!--- system default --->

	<cfquery name="Language" 
	 datasource="AppsSystem">
	 SELECT *
	 FROM   Ref_SystemLanguage
	 WHERE SystemDefault = '1'
	</cfquery> 

	<cfset CLIENT.LanguageId = "#Language.Code#">
	<cfset CLIENT.LanPrefix  = "">	
	
</cfif>

--->

<script>
	Prosis.busy('no')
</script>
  
</cfoutput>	
