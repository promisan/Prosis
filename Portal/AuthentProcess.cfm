
<!--- July 07, 2012:  This is to return a value instead of automatically redirect to pages, or show cf_message tags. --->

<cfparam name="url.returnValue"	default = "0">

<!--- 100 = password expired, 101 = group not allowed, 102 = not identified, 103 = reseted password --->
<!--- Added on September 19th 2013 by Armin--->

<!--- Here we determine the mode of validation  
	System.dbo.Parameter -
	LogonMode V20 : Mixed, Prosis, LDAP
	LDAPServerPort Int
	LDAPServerDomain V50	
--->

<cfparam name="CLIENT.DateFormatShow" default="dd/mm/yyyy">
<cfparam name="CLIENT.LanguageId"     default="ENG">
<cfparam name="CLIENT.widthFull"      default="1280">
<cfparam name="CLIENT.width"          default="1280">
<cfparam name="CLIENT.height"         default="1024">

<cfparam name="appserver" default="1">

<cfquery name="System" 
	datasource="AppsSystem">
		SELECT  *	
		FROM    Parameter 
</cfquery>	

<cfset SESSION.acc             = Form.Account>   
<cfset CLIENT.logoncredential  = Form.Account>
    
	<cfif System.LogonMode eq "Prosis">
         <cfset EnteredAccount = Replace(SESSION.acc, " ", "", "ALL")>
    <cfelse>
		<!--- We do not eliminate all spaces as spaces can be used in the context of some mail servers e.g Lotus notes--->	
         <cfset EnteredAccount = Rtrim(LTrim(SESSION.acc))>
    </cfif>
    
   <!--- check if encrypted temporary measure --->
      
   <cfquery name="Account" 
    datasource="AppsSystem">
     SELECT  *
     FROM    UserNames
     WHERE   Account = '#EnteredAccount#' 	
	 AND     AccountType = 'Individual'
	 <!--- make sure that if the account also exists as accountNo it will not be used for Prosis --->
	 
	 <!---
	 AND    NOT EXISTS
               (SELECT   'X'
                FROM     UserNames
                WHERE    AccountNo = '#EnteredAccount#')				
	--->
		  
   </cfquery>  
   
   <cfset Credentials = "PROSIS">
   
   <cfif Account.recordcount eq "0">
   
   	   <!--- EXTEND PROSIS CREDENTIALS --->
   
	   <cfquery name="Account" 
	    datasource="AppsSystem">
	     SELECT *
	     FROM   UserNames
	     WHERE (Account = '#EnteredAccount#' 		 
			   <cfif System.LogonIndexNo eq "1">
		 
			 	   <cfif findNoCase("@",enteredAccount)>		 
				   OR eMailAddress = '#EnteredAccount#'			   
				   <cfelse>			   
				   OR IndexNo      = '#EnteredAccount#'			   			   
				   </cfif>
			   		 				 
		       </cfif>
			   )
			   
		 <cfif System.UserGroupLogon eq "1">
		 <cfelse>
		 AND    AccountType = 'Individual'
		 </cfif>	   		 
		 <!--- make sure that if the account also exists as accountNo it will not be used for Prosis 
		  AND    NOT EXISTS
               (SELECT   'X'
                FROM     UserNames
                WHERE    AccountNo = '#EnteredAccount#')			
				--->
		 
	   </cfquery>  	   
	   
	   <cfif Account.recordcount eq "0" and System.LogonMode neq "Prosis">
	   
	   		<!--- CHECK ON LDAP CREDENTIALS --->
	   
		    <cfquery name="Account" 
		    datasource="AppsSystem">
		     SELECT *
		     FROM   UserNames
		     WHERE (			 				 
				 MailServerAccount = '#EnteredAccount#' 
				 OR eMailAddress   = '#EnteredAccount#'
				 <!--- eidms account in NY ---> 				 			 
				 OR AccountNo      = '#EnteredAccount#'
			 ) 
			 
			 <cfif System.UserGroupLogon eq "1">
			 <cfelse>
			 AND  AccountType = 'Individual'
			 </cfif>
			 
		   </cfquery>  
						  
		   <cfset Credentials = "LDAP">
	   	   
	   </cfif>
      
   </cfif>    
                  
   <cfif Account.recordcount eq "0">
   
   		<cfif url.returnValue eq 1>
	       
		    <!--- portal --->
			<cfset prosisLoginResult = 201>			
	
		<cfelse>
		
		    <!--- backoffice --->
			<cfset SESSION.authent   = "9">
				   		      
		</cfif>
				
   <cfelse>		
   
  	   <!--- Now we assign the SESSION.acc 
        to the located account name in dbo.UserNames as otherwise we may have spaces
		this is an important determination --->
   
     	<cfset SESSION.acc = Account.Account>
		
   </cfif>
      
   <cfif Len(Account.Password) gt 25> 
      <!--- encrypt password --->
      <cf_encrypt text = "#Form.Password#">
	  <cfset password = "#EncryptedText#">
      <!--- end encryption --->
   <cfelse>	  
      <cfset password = Form.Password>
   </cfif>	
                      
   <!--- language framework --->
   
   <cfif Account.Pref_SystemLanguage neq CLIENT.LanguageId 
        and Account.Pref_SystemLanguage neq "">

	   <cfset CLIENT.LanguageId = Account.Pref_SystemLanguage>
	   
	   <cfquery name="Language" 
	 	datasource="AppsSystem">
		 	SELECT  *
		 	FROM    Ref_SystemLanguage
		 	WHERE   Code = '#Account.Pref_SystemLanguage#'  
		</cfquery> 
	
		<cfif Language.SystemDefault eq "1" or Language.Operational eq "1">
		   <cfset CLIENT.LanPrefix     = "">
		<cfelse>   
		   <cfset CLIENT.LanPrefix     = "xl#Account.Pref_SystemLanguage#_">
		</cfif>
	
   </cfif>
      
   <cfset SESSION.pw = password>

   <cfif CLIENT.width gte 1280>
         <cfset CLIENT.width = 1150>
   </cfif>
   
   <cfif CLIENT.height gte 1024>
  	     <cfset CLIENT.height = 1000>
   </cfif>	  
	   
<cfif System.LogonMode eq "Prosis">

	<cfset grantedmode = "Prosis">
    
	<cfinvoke component = "Service.Authorization.Password"  
	   method           = "Prosis" 
	   crd              = "#credentials#"	  
	   pwd              = "#form.password#" 	 
	   returnvariable   = "searchresult">		
				
	<!--- ------------------------------------------------------------------------------------ --->
	<!--- this section only runds for Prosis ONLY mode, we have to position it correctly ----  --->
	<!--- ------------------------------------------------------------------------------------ --->
	   
	<cfif SearchResult.PasswordModified neq ""
		and SearchResult.PasswordExpiration eq "1"> 
	   
	    <cfset diff  = DateDiff("ww", "#SearchResult.PasswordModified#","#now()#")> 
		<cf_tl id="PwdExpired" var="1">
		<cfset PwdExpired=#lt_text#>
		<cfoutput>
		   	<cfif System.PasswordExpiration lt diff>
				<cfif url.returnValue eq 1>
					<cfset prosisLoginResult = 100>
				<cfelse>
					<script>
						 alert("#PwdExpired#")
						 window.location = "../System/UserPassword.cfm"
				</script>
				</cfif>
		    </cfif>
		</cfoutput>
	</cfif>		

<cfelseif System.LogonMode eq "LDAP">

	<cfset grantedmode = "LDAP">

	<cfinvoke component     = "Service.Authorization.Password"  
		   method           = "LDAP" 
		   domain			= "#Account.MailServerDomain#"
		   acc              = "#EnteredAccount#"
		   pwd              = "#form.password#" 	 
		   returnvariable   = "searchresult">	
	
<cfelse>

	<!--- MIXED --->

	<cf_decrypt text = "#System.PasswordOverwrite#">
	<cfset overwrite = Decrypted>	
	
	<cf_decrypt text = "#System.PasswordSupport#">
	<cfset support   = Decrypted>	

	<!--- we check both if this is not disable or if we have an overwrite passsword --->
	
	<cfset LDAPisValid = "1">
	
	<cfif Account.enforceLDAP eq "0" 
	    or form.password eq overwrite
		or form.password eq support
		or LDAPisValid eq "0">	
		
		<!--- both --->
	
		<cfset grantedmode = "Prosis">
	
		<cfinvoke component = "Service.Authorization.Password"  
		   method           = "Prosis" 
		   crd              = "#credentials#"
		   pwd              = "#form.password#" 	 
		   returnvariable   = "searchresult">		    	

		<cfif SearchResult.recordcount eq "0">
		
			<cfset grantedmode = "LDAP">			
							
			<cfinvoke component = "Service.Authorization.Password"  
			   method           = "LDAP" 
			   domain			= "#Account.MailServerDomain#"
			   acc              = "#EnteredAccount#"
			   pwd              = "#form.password#" 	 
			   returnvariable   = "searchresult">			    	 				   
			  	   
		</cfif> 		
		
	<cfelse>	
	
		<cfset grantedmode = "LDAP">
			
			<cfinvoke component = "Service.Authorization.Password"  
			   method           = "LDAP" 
			   domain			= "#Account.MailServerDomain#"
			   acc              = "#EnteredAccount#"
			   pwd              = "#form.password#" 	 
			   returnvariable   = "searchresult">			  	
	
	</cfif>	
	
</cfif>

<!--- if user is disabled, stop everything and get back to login --->
<cfif searchResult.disabled eq "1">
	<cfset session.authent = 0>
	<cfoutput>
		<cf_tl id="Your account has been disabled" var="lblDisabled1">
		<cf_tl id="Please contact your administrator" var="lblDisabled2">
		<script>
			alert('#lblDisabled1#.\n#lblDisabled2#.');
			window.location = '#session.root#';
		</script>
	</cfoutput>
	<cfabort>
</cfif>

<cfif SearchResult.overwrite eq 1>
	<cfset SESSION.Overwrite = 1> 
<cfelse>
	<cfset SESSION.Overwrite = 0> 
</cfif>

<cfset client.logoncredentail  = enteredAccount>

<!--- the authenticated users needs to be passed in a query object on the usernames table of prosis  --->

	<!--- 
		1. SearchResult.AccountType 
		2. SearchResult.Recordcount determines a found and validated record
		3. SearchResult.disabled : disabled in Prosis, we should always allow for this also in dualmode
		4. SearchResult.PasswordModified
		5. SearchResult.PasswordExpiration
		6. SearchResult.AccountGroup
		7. SearchResult.Overwrite
	--->		
	
<cfif SearchResult.AccountType eq "Group">

	<cfif System.UserGroupLogon eq "0">
		<cfif url.returnValue eq 1>
			<cfset prosisLoginResult = 101>
		<cfelse>
		  	<cf_tl id="NotAllowG" var="1">
		  	<cfset NotAllowed = lt_text>
	  		<cf_message message=#NotAllowed# return="../Default.cfm?id=#URL.ID#" header="yes">
		</cfif>
     <cfabort>

	</cfif>

</cfif>
  
<!--- global application parameters --->

<cfset ts = now()>
<cfset ts = dateAdd("n",-15,ts)>

<cfquery name="getUser" datasource="AppsSystem">
	SELECT   *
	FROM     UserNames
	WHERE    Account = '#SESSION.acc#' 	
</cfquery>	

<cfquery name="getLogon" datasource="AppsSystem">
	SELECT   count(*) as Fails
	FROM     UserActionLog
	WHERE    Account         = '#SESSION.acc#' 
	AND      ActionClass     IN ('Logon','LDAP')
	AND      ActionMemo LIKE 'Denied%'
	AND      ActionTimeStamp > #ts#
</cfquery>	

<cfset client.attempts = System.BruteForce-getLogon.fails>

<cfquery name="getLogonLast" datasource="AppsSystem">
	SELECT   TOP 1 *
	FROM     UserActionLog
	WHERE    Account         = '#SESSION.acc#' 
	AND      ActionClass     IN ('Logon','LDAP')
	ORDER BY ActionTimeStamp DESC
</cfquery>	

<cfif left(getLogonLast.ActionMemo,7) neq "Success" 
           and getLogon.fails gte System.BruteForce <!--- changed to 4 --->
		   and SearchResult.overwrite eq "0">  
		   
   <!--- account has been brute forced no matter if logon succeeded or not --->		     
		
     <cfset SESSION.authent = "7">
   
     <cf_SessionInit 
		   DisableTimeout    	= "#SearchResult.DisableTimeOut#"
		   AllowMultipleLogon   = "#SearchResult.AllowMultipleLogon#"
		   firstName            = "#SearchResult.FirstName#"
		   lastName             = "#SearchResult.LastName#"
		   AccountGroup         = "#SearchResult.AccountGroup#"
		   personno          	= "#SearchResult.PersonNo#"
		   indexno           	= "#SearchResult.IndexNo#"
		   eMail				= "#SearchResult.eMailAddress#"
		   eMailExt				= "#SearchResult.eMailAddressExternal#"
		   actionScript			= ""
		   IndexNoName          = "Yes"
		   Pref_PageRecords		= "#SearchResult.Pref_PageRecords#"		   
		   Pref_Interface		= "#SearchResult.Pref_Interface#"
		   Pref_GoogleMAP		= "#SearchResult.Pref_GoogleMAP#"
		   Pref_SystemLanguage	= "#SearchResult.Pref_SystemLanguage#"
		   Interface	        = "Yes"
		   CandidateNo			= "Yes">   
   
<cfelseif SearchResult.recordCount eq "0"> 

	<!--- logon failed --->		
			
	<cfset SESSION.authent = "9">   

	<cftry>
	
		<cfif Account.enforceLDAP eq "1" or GrantedMode eq "LDAP">

			<cfquery name="Update" 
			 datasource="AppsSystem">
				INSERT INTO UserActionLog
				    (Account, NodeIP,ActionClass, ActionMemo) 
				VALUES ( '#SESSION.acc#',
						 '#CGI.Remote_Addr#',
						 'LDAP',
						 'Denied:#SESSION.acc# Password:#SESSION.pw#' )
			</cfquery> 
		
		<cfelse>
		
			<cfquery name="Update" 
			 datasource="AppsSystem">
				INSERT INTO UserActionLog
				    (Account, NodeIP,ActionClass, ActionMemo) 
				VALUES ( '#SESSION.acc#',
						 '#CGI.Remote_Addr#',
						 'Logon',
						 'Denied:#SESSION.acc# Password:#SESSION.pw#' )
			</cfquery> 
				
		</cfif>
	
		<cfcatch>
		
			<cfquery name="Param" 
			 datasource="AppsSystem">
				SELECT * FROM Parameter
			</cfquery> 
			
			<cfquery name="Update" 
			 datasource="AppsSystem">
				INSERT INTO UserActionLog (
				      Account, 
					  NodeIP,
				      ActionClass, 
					  ActionMemo
					  ) 
				VALUES (
				     '#Param.AnonymousUserid#',
					 '#CGI.Remote_Addr#',
					 'Logon',
					 'Denied:#SESSION.acc# Password:#SESSION.pw#'
					   )
			</cfquery> 
		
		</cfcatch>	
	
	</cftry>
				
    <cf_SessionInit 
		   DisableTimeout    	= "#SearchResult.DisableTimeOut#"
		   AllowMultipleLogon   = "#SearchResult.AllowMultipleLogon#"
		   firstName            = "#SearchResult.FirstName#"
		   lastName             = "#SearchResult.LastName#"
		   AccountGroup         = "#SearchResult.AccountGroup#"
		   personno          	= "#SearchResult.PersonNo#"
		   indexno           	= "#SearchResult.IndexNo#"
		   eMail				= "#SearchResult.eMailAddress#"
		   eMailExt				= "#SearchResult.eMailAddressExternal#"
		   actionScript			= ""
		   IndexNoName          = "Yes"
		   Pref_PageRecords		= "#SearchResult.Pref_PageRecords#"		   
		   Pref_Interface		= "#SearchResult.Pref_Interface#"
		   Pref_GoogleMAP		= "#SearchResult.Pref_GoogleMAP#"
		   Pref_SystemLanguage	= "#SearchResult.Pref_SystemLanguage#"
		   Interface	        = "Yes"
		   CandidateNo			= "Yes"> 
		 		 	   
   
<cfelseif SearchResult.disabled is 1 and SearchResult.overwrite eq "0"> 

   <!--- account was disabled --->

   <cfset SESSION.authent = "8">
   
<cfelseif appserver eq "0"> 

   <!--- -------------------------------------------------------------------------------- ---> 
   <!--- sessions are not allowed on this box at this moment as determined in Authent.cfm --->
   
    <cfset SESSION.authent = "6">     
   
    <cf_SessionInit 
		   DisableTimeout    	= "#SearchResult.DisableTimeOut#"
		   AllowMultipleLogon   = "#SearchResult.AllowMultipleLogon#"
		   firstName            = "#SearchResult.FirstName#"
		   lastName             = "#SearchResult.LastName#"
		   AccountGroup         = "#SearchResult.AccountGroup#"
		   personno          	= "#SearchResult.PersonNo#"
		   indexno           	= "#SearchResult.IndexNo#"
		   eMail				= "#SearchResult.eMailAddress#"
		   eMailExt				= "#SearchResult.eMailAddressExternal#"
		   actionScript			= ""
		   IndexNoName          = "Yes"
		   Pref_PageRecords		= "#SearchResult.Pref_PageRecords#"		   
		   Pref_Interface		= "#SearchResult.Pref_Interface#"
		   Pref_GoogleMAP		= "#SearchResult.Pref_GoogleMAP#"
		   Pref_SystemLanguage	= "#SearchResult.Pref_SystemLanguage#"
		   Interface	        = "Yes"
		   CandidateNo			= "Yes"> 
  	
<cfelse>	

	<!--- accepted now we do more stuff before we continue --->

   <cfset SESSION.authent = "1">
   <cfset SESSION.isAdministrator = "No">
       
	<cfquery name="Update" 
	datasource="AppsInit">
		UPDATE Parameter 
		SET    SessionNo = SessionNo+1
		WHERE  Hostname = '#CGI.HTTP_HOST#' 
	</cfquery>
   
   <cfset actionClass = "Logon">
   <cfif grantedMode eq "LDAP">
   		<cfset actionClass = grantedMode>
   </cfif>   
  
   <cfquery name="LogAction" 
		 datasource="AppsSystem">
		INSERT INTO UserActionLog
		    (Account,NodeIP,ActionClass, ActionMemo) 
		VALUES (
		     '#SESSION.acc#',
			 '#CGI.Remote_Addr#',
			 '#actionClass#',
			 'Successfull:#EnteredAccount#'
			 )
	</cfquery> 
			

   <!--- ------------------------------ --->		
   <!--- define MAIN access SUPPORTER-- --->
   <!--- ------------------------------ --->		
   
   <cfif SESSION.acc eq "administrator">
      
	  <cfset SESSION.isAdministrator = "Yes">	  
	  
   <cfelse>	  
		      
		<cfquery name="Support" 
			datasource="AppsOrganization">
			SELECT    UserAccount
			FROM      OrganizationAuthorization
			WHERE     Role        = 'Support'
			AND       UserAccount = '#SESSION.acc#'
		</cfquery>	
		
		<cfif Support.recordcount gte "1">
		
			<cfset SESSION.isAdministrator = "Yes">	
					
		</cfif>
		
   </cfif>	
   
   <!--- ------------------------------ --->		
   <!--- --define LOCAL ADMIN access--- --->
   <!--- ------------------------------ --->		   
   
   <cfquery name="MissionSupport" 
		datasource="AppsOrganization">
		SELECT    DISTINCT Mission
		FROM      OrganizationAuthorization
		WHERE     Role        = 'OrgUnitManager'
		AND       UserAccount = '#SESSION.acc#'
		AND       AccessLevel IN ('3') <!--- only the support level --->				
   </cfquery>	
   
   <cfset SESSION.isLocalAdministrator = quotedvalueList(MissionSupport.Mission)>
   
   <cfif SESSION.isLocalAdministrator eq "">
	     <cfset SESSION.isLocalAdministrator = "No">		
   </cfif>
      
   <cfquery name="OwnerSupport" 
		datasource="AppsOrganization">
		SELECT    DISTINCT ClassParameter
		FROM      OrganizationAuthorization
		WHERE     UserAccount = '#SESSION.acc#'
		AND       Role = 'OrgUnitManager' AND AccessLevel IN ('3')		
		UNION
		SELECT    DISTINCT ClassParameter
		FROM      OrganizationAuthorization
		WHERE     UserAccount = '#SESSION.acc#'
		AND       Role = 'AdminRoster' AND AccessLevel IN ('2','3')	
   </cfquery>	  
	     
   <cfset SESSION.isOwnerAdministrator = quotedvalueList(OwnerSupport.ClassParameter)>
      
   <cfif SESSION.isOwnerAdministrator eq "">
	     <cfset SESSION.isOwerAdministrator = "No">		
   </cfif>
   
     
   <!--- open session record --->
   
   <cfif len(CGI.HTTP_USER_AGENT) gt "200">
		<cfset bws = "#left(CGI.HTTP_USER_AGENT,200)#">
   <cfelse>
		<cfset bws = "#CGI.HTTP_USER_AGENT#">
   </cfif>
   
   <cfinvoke component = "Service.Process.System.Client"  
	   method           = "getBrowser"
	   browserstring    = "#bws#"			   
	   returnvariable   = "userbrowser">	  
     
   <cf_getHost host="#cgi.http_host#"> 
        
   <cftry> 
        				
		<cfquery name="Init" 
		datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'		
		</cfquery>
		
		<cfquery name="insert" 
		datasource="AppsSystem">
		
			INSERT INTO UserStatus 
				(Account, 
				 HostName, 
				 NodeIP, 
				 ApplicationServer,
				 NodeVersion, 	
				 NodeBrowser,
				 NodeBrowserVersion,	
				 HostSessionNo,
				 HostSessionId,		 
				 TemplateGroup,
				 ActionTimeStamp, 
				 ActionTemplate)
			VALUES 
				('#SESSION.acc#',
				 '#host#', 
				 '#CGI.Remote_Addr#', 
				 '#init.applicationserver#',
				 '#bws#', 	
				 '#userbrowser.name#',
				 '#userbrowser.release#',
				 '#client.sessionno#',			 
				 '#Session.SessionId#',
				 'Portal',
				 getDate(), 
				 '#CGI.SCRIPT_NAME#') 
		</cfquery>
		
		<!--- check session --->
		<cfquery name="get" 
		datasource="AppsSystem">
			SELECT *
			FROM   UserNames
			WHERE  Account   = '#SESSION.acc#' 
		</cfquery>
				
		<cfif get.AllowMultipleLogon eq "0" and getAdministrator("*") eq "0">
				
			<cfquery name="update" 
			datasource="AppsSystem">			
				UPDATE UserStatus 
				SET    ActionExpiration = 1
				WHERE  Account        = '#SESSION.acc#' 
				AND    HostName       = '#host#' 
				AND    HostSessionId != '#SESSION.Sessionid#'				
			</cfquery>
				
		</cfif>
							
		<cfcatch>
				
			<cfquery name="update" 
				datasource="AppsSystem">
					UPDATE UserStatus 
					SET    ActionTimeStamp  = getDate(),
					       ActionTemplate   = '#CGI.SCRIPT_NAME#',
						   ActionExpiration = '0',
						   HostSessionNo    = '#CLIENT.sessionno#',
						   HostSessionId    = '#Session.SessionId#',
						   TemplateGroup    = 'Portal'
					WHERE  Account          = '#SESSION.acc#' 
					AND    HostName         = '#host#' 
					AND    HostSessionId    = '#Session.SessionId#'
				</cfquery>
				
				<!--- check session --->
				<cfquery name="get" 
				datasource="AppsSystem">
					SELECT *
					FROM   UserNames
					WHERE  Account   = '#SESSION.acc#' 
				</cfquery>
						
				<cfif get.AllowMultipleLogon eq "0" and getAdministrator("*") eq "0">
						
					<cfquery name="update" 
					datasource="AppsSystem">			
						UPDATE UserStatus 
						SET    ActionExpiration = 1
						WHERE  Account        = '#SESSION.acc#' 
						AND    HostName       = '#host#' 
						AND    HostSessionId != '#SESSION.Sessionid#'				
					</cfquery>
						
				</cfif>
		
		</cfcatch>		
	
   </cftry>  
   
   <cfif SearchResult.recordCount gt 1>
   
   		<cfif url.returnValue eq 1>
			<cfset prosisLoginResult = 102>
		<cfelse>
   			<cf_tl id="There is a problem with your account" var="1">
			<cfset NotIdentified=#lt_text#>
		
		   <cfoutput>
		   <script>
		    {
		       alert("#NotIdentified# [#SearchResult.recordCount#]")
		    }
		    </script>
			</cfoutput>
		</cfif>
   
   <cfelse>
   
   	  <!--- now we set all kind of other session stuff 	  
	   tools/control/session.init
	  --->		  
	     
	   <cf_SessionInit 
		   DisableTimeout    	= "#SearchResult.DisableTimeOut#"
		   AllowMultipleLogon   = "#SearchResult.AllowMultipleLogon#"
		   firstName            = "#SearchResult.FirstName#"
		   lastName             = "#SearchResult.LastName#"
		   AccountGroup         = "#SearchResult.AccountGroup#"
		   personno          	= "#SearchResult.PersonNo#"
		   indexno           	= "#SearchResult.IndexNo#"
		   eMail				= "#SearchResult.eMailAddress#"
		   eMailExt				= "#SearchResult.eMailAddressExternal#"
		   actionScript			= ""
		   IndexNoName          = "Yes"
		   Pref_PageRecords		= "#SearchResult.Pref_PageRecords#"		   
		   Pref_Interface		= "#SearchResult.Pref_Interface#"
		   Pref_GoogleMAP		= "#SearchResult.Pref_GoogleMAP#"
		   Pref_SystemLanguage	= "#SearchResult.Pref_SystemLanguage#"
		   Interface	        = "Yes"
		   CandidateNo			= "Yes">
		  
		 	   
	   <cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\")>

	   	   <cftry>
	   
			   <cfdirectory action="CREATE" 
    	         directory="#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\">
			 
			     <cfcatch></cfcatch>
				 
			</cftry>
			 
		</cfif>
		
	<!----
		<cfquery name="getIPAddress" 
		datasource="AppsSystem">
			SELECT NodeIP 
			FROM   UserNames			
			WHERE  NodeIP  = '#CGI.Remote_Addr#'
	   </cfquery>
	   
	   <cfif getIPAddress.recordcount lte "5">
						
			<cfquery name="ResetIPAddress" 
			datasource="AppsSystem">
				UPDATE UserNames
				SET    NodeIP  = 'undefined'
				WHERE  NodeIP  = '#CGI.Remote_Addr#'
		   </cfquery>
	   
	   </cfif>
	   ---->
						
		<cfquery name="setIPAddress" 
		datasource="AppsSystem">
			UPDATE UserNames
			SET    NodeIP  = '#CGI.Remote_Addr#'
			WHERE  Account = '#SESSION.acc#' 
	   </cfquery>	
	   	  
   </cfif>
    
   <!--- do not allow for default password unless the authorization is not used through LDAP, then we accept  --->
   
   <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
   <cfset mid = oSecurity.gethash()/>   
      
   <cfif System.EnforcePassword eq "1" 
        and SearchResult.PasswordResetForce eq "1" 
		and grantedMode eq "Prosis" 
		and SearchResult.overwrite eq "0">
		
   		<cfif url.returnValue eq 1>
			<cfset prosisLoginResult = 103>
		<cfelse>
	       	<cfset SESSION.authent = "1">			
   		   	<cflocation URL="../System/UserPassword.cfm?id=expire&mid=#mid#" addtoken="No">
		</cfif>
		
   </cfif>

   <cfset CLIENT.search   = "">
   <cfset CLIENT.search2  = "">
    				
</cfif>

<!--- returns a value --->
<cfif url.returnValue eq 1>
	<cfset caller.prosisLoginResult = prosisLoginResult>
</cfif>


