<cfparam name="Attributes.VerifyMultipleLogon"  default="0">
<cfparam name="Attributes.VerifyCSRF"           default="0">
<cfparam name="Attributes.VerifyAuthentication" default="0">
<cfparam name="Attributes.TrackUser"            default="0">
<cfparam name="Attributes.ErrorHandling"        default="1">

<cfparam name="CLIENT.LanguageId"				default="ENG">

<cfquery name="Parameter" 
	datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#'  
</cfquery>
 
<cfquery name="System" 
	datasource="AppsSystem">
	SELECT * 
	FROM   Parameter
</cfquery>		

<cfif Parameter.recordcount eq 0>
	
    <cfoutput>
       
     <table width="100%" height="100%">
	 <tr><td align="center" class="labelmedium" style="font-size: 23px;">
	     Rquested domain: <b>#CGI.HTTP_HOST#</b> is not serviced. <br>Contact your administrator.
	 </td></tr></table>
	  <cfabort>
      
   </cfoutput>
   
<cfelse>  

	<!--- this method is made to check if the session of the user is considered cancelled based on the content
	of the parameter table for this application server --->

    <cfparam name="SESSION.rootpath"           default="">
	<cfparam name="SESSION.isAdministrator"    default="No">
	<cfparam name="CLIENT.style"               default="">
	<cfparam name="SESSION.acc"                default="">
					
	<!--- set global variables for client --->
						
    <cfoutput query="Parameter">

		<cfset SESSION.rootpath          = "#ApplicationRootPath#">
		<cfset SESSION.root              = "#ApplicationRoot#"> 
		<cfif ApplicationTheme eq "Classic">
			<cfset client.style          = "/Portal/Logon/Classic/pkdb.css">
		<cfelse>
			<cfset client.style          = "/Portal/Logon/Bluegreen/pkdb.css">
		</cfif>
		<cfset SESSION.welcome           = "#SystemTitle#">
		<cfset CLIENT.ApplicationHeader  = "#SystemLabelBanner#">
		<cfset CLIENT.ApplicationFooter  = "#SystemLabelFooter#">
		
	    <cfset SESSION.author            = "#SystemSubtitle#">
	    <cfset SESSION.authorMemo        = "#SystemNote#">
	    <cfset CLIENT.Manager            = "#SystemDevelopment#">
	
	</cfoutput>
		 
</cfif>

<!--- set locale for date expressions --->

<cfswitch expression="#CLIENT.LanguageId#">

	<cfcase value="ENG">
		<cfset setLocale("English (US)")>
	</cfcase>
	
	<cfcase value="ESP">
		<!---<cfset setLocale("Spanish (Standard)")>--->
		<cfset setLocale("English (US)")>
	</cfcase>
	
	<cfcase value="FRA">
		<cfset setLocale("French (Standard)")>
	</cfcase>
	
	<cfcase value="GER">
		<cfset setLocale("German (Standard)")>
	</cfcase>
	
	<cfcase value="ITA">
		<cfset setLocale("Italian (Standard)")>
	</cfcase>
	
	<cfcase value="NET">
		<cfset setLocale("Dutch (Standard)")>
	</cfcase>
	
	<cfcase value="POR">
		<cfset setLocale("Portuguese (Standard)")>
	</cfcase>
	
	<cfdefaultcase>
		<cfset setLocale("English (US)")>
	</cfdefaultcase>	

</cfswitch>

<!--- verify syntax for SQL intrusion --->

<cfif Parameter.EnableURLCheck eq "1">
	
	<cfif CGI.QUERY_STRING neq "">
	
		<cfquery name="Check" 
		datasource="AppsSystem">
			SELECT *
			FROM   SyntaxVerification
			WHERE  SecurityClass = 'URL' 
		</cfquery>		
		
		<cfloop query="Check">
										
			<cfif FindNoCase("#VerificationString#", "#URLDecode(CGI.QUERY_STRING)#")>			
			
			 	<cf_ErrorInsert	 ErrorSource      = "SQLSyntax"
								 ErrorReferer     = ""
								 ErrorDiagnostics = "#CGI.QUERY_STRING#"
								 Email = "1">
													 								   			
				<cf_message status = "Alert"
					message="<br>Alert : There are reasons to believe that the URL has been compromised. <br><br><b><font color='804040'>Your request can not be executed!</font><br>" return="No">
					
				<cfabort>
			
			</cfif>
	
		</cfloop>
		
	</cfif>

</cfif>


	<!--- Track user actions and presence in the table System.dbo.UserStatus, also if the user was expired by the
	administrator here is the moment that SESSION.Authent = 0 which is then picked up by the 
	scheduled method --->
				
	<cfif Attributes.TrackUser eq "1">
		<cf_trackUser>
	</cfif>
					
	<cfif Attributes.VerifyCSRF eq "1">
								
		<cfif (CGI.SCRIPT_NAME eq "/apps/Component/Process/Workorder/UploadPicture.cfm" AND 
		       findNoCase("android", GetHttpRequestData().Headers["user-agent"]) neq 0) 
			   AND 
			   (StructKeyExists(GetHttpRequestData().Headers, "content-type") AND 
			   findNoCase("multipart/form-data", GetHttpRequestData().Headers["content-type"]) neq 0)
			   OR
			   (findNoCase("Edge/", GetHttpRequestData().Headers["user-agent"]) neq 0
			   OR findNoCase("EdgiOS/", GetHttpRequestData().Headers["user-agent"]) neq 0
			   OR findNoCase("EdgA/", GetHttpRequestData().Headers["user-agent"]) neq 0
			   OR findNoCase("Edg/", GetHttpRequestData().Headers["user-agent"]) neq 0
			   OR findNoCase("rv:11.0", GetHttpRequestData().Headers["user-agent"]) neq 0
			   OR findNoCase("Firefox", GetHttpRequestData().Headers["user-agent"]) neq 0
			   OR findNoCase("FxiOS", GetHttpRequestData().Headers["user-agent"]) neq 0)>
		
			<!--- 2015-03-07 kherrera: if upload picture and android then exception or if it is an upload --->
			<!--- 2020-06-02 kherrera: OR if it is Edge OR IE11 --->
			<!--- 2020-06-02 kherrera: OR FF --->
			
		<cfelse>
						
			<cfif CGI.REQUEST_METHOD eq "POST">
		
				<cfset vProtocol = "http://">
				<cfif CGI.HTTPS eq "on">
					<cfset vProtocol = "https://">
				</cfif>
				
				<cfset vValidServer = vProtocol & CGI.SERVER_NAME>
				
				<cfset vReqClient = "">
				<cfif StructKeyExists(GetHttpRequestData().Headers, "origin")>
					<cfset vReqClient = GetHttpRequestData().Headers["origin"]>
				<cfelseif StructKeyExists(GetHttpRequestData().Headers, "referer")>
						<cfset vReqClient = GetHttpRequestData().Headers["referer"]>
				<cfelse>
					<!--- it is expected to flow this way when it is an upload from multiplefile form (flash) because in those 
					      cases neither origin nor referrer are passed, so we rely only on the host--->
					<cfif StructKeyExists(GetHttpRequestData().Headers, "host")>
						<cfset vReqClient = GetHttpRequestData().Headers["host"]>
					</cfif>
					<!--- do not include protocol in this case, as "host" header variable does not include it --->
					<cfset vValidServer = CGI.SERVER_NAME>
				</cfif>

				<cfset source = ListToArray(vReqClient,'.')>
				<cfset destination = ListToArray(vValidServer,'.')>
				<cfset ports = ListToArray(vReqClient,':')>

				<cfset slen = ArrayLen(source)>
				<cfset sdest = ArrayLen(destination)>
				<cfset sports = ArrayLen(ports)>

				<cfset vPass = 1>
				<cfif slen gt 2>
					<cfif source[slen] neq destination[sdest] OR source[slen-1] neq destination[sdest-1]>
						<cfset vPass = 0>
					</cfif>
				<cfelse>
					<cfif mid(vReqClient,1,len(vValidServer)) neq vValidServer>
						<cfset vPass = 0>
					</cfif>
				</cfif>
				<cfif ports[sports] neq "3000">
					<cfif vPass eq 0>
						<cfheader statusCode="403" statusText="Forbidden">
						<!--- generic error page --->
						#vReqClient#-#vValidServer#
						<cflocation url="#session.root#/CSRFGet.cfm?#ports[sports]#" addtoken="No">
					</cfif>
				</cfif>
				
			</cfif>		
			
		</cfif>
				
		<!--- we determine if we have reasons to believe this template is geared to	be opened as on CSRF controlled --->
		
		<cfquery name="checkenabled" 
			datasource="AppsSystem">
				SELECT  TOP 1 * 
				FROM    UserStatusController
				WHERE   HostName           = '#CGI.http_host#'
				AND     ActionTemplate     = '#CGI.SCRIPT_NAME#'										
		</cfquery>			
		
		<!--- ---------------------------------------- --->
		<!--- sanitize invalid MID in the query string --->
		<!--- ---------------------------------------- --->
		
		<cfset str = "1">
		<cfset end = "1">
		<cfset cnt = "0">
		<cfset mid = "">		
						
		<cfloop condition="findNoCase('mid=',CGI.QUERY_STRING,str)">
									
			<cfset str = findNoCase("mid=",CGI.QUERY_STRING,str)>
			
			<cfset str = str+4>
			<cfset end = findNoCase("&",CGI.QUERY_STRING,str)>
						
			<cfif end eq "0">
				<cfset end = len(CGI.QUERY_STRING)>
			<cfelse>
				<cfset end = end-1>	
			</cfif>
			
			<cfset mid = mid(CGI.QUERY_STRING,str,40)>
						
		</cfloop>	
		
		<!--- Hanno detect if template may be opened without any MID included which them bypasses the
		MIP validation as soon as we have reason to believe this link is controlled by MID before
		
		right now we do this for ajax links but i think we should do this for any links
		
		--->		
	
		<cfif mid eq "" and checkenabled.recordcount gte "1" and findNoCase("cf_clientid",CGI.QUERY_STRING) eq "1">
		
			<!--- ----------------------------------------------------------------- --->
			<!--- we let this fail if MID does not exist and this is an ajax call  --->
			<!--- ----------------------------------------------------------------- --->
		
			<cfset mid = "9999999">		
		
		<cfelseif mid eq "" and checkenabled.recordcount gte "1">
													
			<!--- ----------------------------------------------------------------- --->
			<!--- we let this fail if MID does not exist -------------------------- --->
			<!--- ----------------------------------------------------------------- --->
			
			<cfset mid = "9999999">	
									
														
		</cfif>		
					
		<!--- we check if the template is launched by this user within a certain time frame based on an 
		id created upon triggering the termplate --->		
		
													
		<cfif mid neq "" 
		     and not findNoCase("default.cfm",CGI.SCRIPT_NAME) 
			 and not findNoCase("actionview.cfm",CGI.SCRIPT_NAME)
			 and not findNoCase("errorrequest.cfm",CGI.SCRIPT_NAME)
			 and not findNoCase("error.cfm",CGI.SCRIPT_NAME)
			 and not findNoCase("selectFormContainer.cfm",CGI.SCRIPT_NAME)
			 and not findNoCase("mainmenuopen.cfm",CGI.SCRIPT_NAME)>
																									
			<cfinvoke component   = "Service.Process.System.UserController"  
				method            = "RecordSessionTemplate"  
				Hash              = "#mid#"
				ActionTemplate    = "#CGI.SCRIPT_NAME#"				
				ActionQueryString = "#CGI.QUERY_STRING#"
				AccessValidate    = "Yes">		
															
				<!--- -------------------------------------------------------------------------------- --->
				<!--- if access revoke = Yes, it will only 10 seconds to be loaded, no bookmarking---- --->
				<!--- -------------------------------------------------------------------------------- --->
		
		</cfif>	
		
	</cfif>	
		
	<cfif findNoCase("cf_clientid",CGI.QUERY_STRING)>

	   <!--- added 26/8/2011. An ajax request is not considered as a visit and for check to prevent cramped messages --->
   
	<cfelse>
						
		<cfif Attributes.VerifyAuthentication eq "1"> 	
				
			<!--- esnure the application.cfm does not check for authentixation otherwise we have a double
			check of the template as well 
			because submitting it will trigger a validate which is then subject for its own validation as well --->				
			<cf_validateSession scope="standard"> 					
			
		</cfif>
		
		<!--- verify multiple user logon --->
		
		<cfif Attributes.VerifyMultipleLogon eq "1">
			<cf_verifyMultiple>
		</cfif>
	
	</cfif>	
	
<!--- Enable error management --->

<cfif Attributes.ErrorHandling eq "1" AND System.ExceptionControl eq "1">
	
	<cfquery name="System" 
		datasource="AppsSystem">
			SELECT * 
			FROM   Parameter
	</cfquery>	
				 
	<cfif Parameter.EnableError neq "0">
						      
		<cferror type = "exception"
		  template = "/#System.VirtualDirectory#/Error.cfm"
		  exception = "any"> 	
		    			   
		  				
	<cfelse>
	
		<!--- default behavior --->
			
	</cfif>

</cfif>

   