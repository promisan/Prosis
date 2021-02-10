
<!--- clear prior client variables --->

<cfparam name="SESSION.authent"  default="0">

<cfif SESSION.authent eq "0">
	
	<cfquery name="Parameter" 
	   datasource="AppsSystem">
	    SELECT * 
		FROM Parameter
	</cfquery>
	
	<cfset client.style = "/Portal/Logon/Bluegreen/pkdb.css">
	
	<cfparam name="client.width"                 default="1000">
	<cfparam name="client.height"                default="760">
	<cfparam name="client.IndexNo"               default="">
	<cfparam name="SESSION.isAdministrator"      default="No">
	<cfparam name="client.IndexNoName"           default="IndexNo">
	<cfparam name="client.color"                 default="f4f4f4">
	<cfparam name="SESSION.welcome"              default="#Parameter.ReportServerName#">
	<cfparam name="APPLICATION.BaseCurrency"     default="#Parameter.BaseCurrency#">
	<cfparam name="SESSION.acc"                  default="#Parameter.AnonymousUserid#">
	<cfparam name="client.version"               default="#Parameter.Version#">
	<cfparam name="CLIENT.LanguageId"            default="ENG">
	<cfparam name="CLIENT.LanPrefix"             default="">		
		
	<cfif find("MSIE","#CGI.HTTP_USER_AGENT#")>
	    <cfset client.browser = "Explorer">
	<cfelseif find("Firefox","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Firefox">	
	<cfelseif find("Opera","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Opera">
	<cfelseif find("Chrome","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Chrome">	 
	<cfelseif find("Safari","#CGI.HTTP_USER_AGENT#")>
	     <cfset client.browser = "Safari">	 
	<cfelse>	
		<cfset client.browser = "undefined"> 
	</cfif>
			
	<cfset client.os = "Windows">
	
	<cfif find("Windows","#CGI.HTTP_Platform#")>
	    <cfset client.os = "Windows">
	<cfelse>
	    <cfset client.os = "Other">
	</cfif> 
	
	<cfset SESSION.authent= "1">
		
	<cfset SESSION.acc    =  "#Parameter.AnonymousUserid#">
	<cfset SESSION.first  =  "Anonymous">
	<cfset SESSION.last   =  "User">
	<cfset CLIENT.eMail  =  "">
			
	<cfset CLIENT.SessionNo =  "0">
	
	<cftry> 
	
			<cfquery name="Init" 
			datasource="AppsInit">
				SELECT * 
				FROM   Parameter
				WHERE  HostName = '#cgi.http_host#'		
			</cfquery>
			
			<cfif len(CGI.HTTP_USER_AGENT) gte 200>
			 <cfset bws = left(CGI.HTTP_USER_AGENT,200)>
			<cfelse>
			 <cfset bws = CGI.HTTP_USER_AGENT>
			</cfif> 
			
			<cfinvoke component = "Service.Process.System.Client"  
			   method           = "getBrowser"
			   browserstring    = "#bws#"			   
			   returnvariable   = "userbrowser">	
			   
			<cf_getHost host="#cgi.http_host#">     
										
			<cfquery name="insert" 
			datasource="AppsSystem">
			INSERT INTO UserStatus 
				(Account, 
				 ApplicationServer,
				 HostName, 
				 NodeIP, 
				 NodeVersion, 
				 NodeBrowser,
				 NodeBrowserVersion,
				 TemplateGroup,
				 ActionTimeStamp, 
				 ActionTemplate)
			VALUES
				('#SESSION.acc#',
				 '#init.applicationserver#',
				 '#host#', 
				 '#CGI.Remote_Addr#', 
				 '#bws#', 
				 '#userbrowser.name#',
				 '#userbrowser.release#',
				 'Tools',
				 getDate(), 
				 '#CGI.SCRIPT_NAME#')
			</cfquery>
				
			<cfcatch>
			
				<cfquery name="update" 
				datasource="AppsSystem">
					UPDATE UserStatus 
					SET    ActionTimeStamp  = getDate(),
					       ActionTemplate   = '#CGI.SCRIPT_NAME#',
						   TemplateGroup    = 'Tools',
						   ActionExpiration = '0'
					WHERE  Account       = '#SESSION.acc#' 
					AND    HostName      = '#host#' 
					AND    HostSessionid = '#SESSION.Sessionid#'
				</cfquery>
					
			</cfcatch>
		
	</cftry>
		 
	<cfset CLIENT.reportingServer = "#Parameter.ReportingServer#"> 
	<cfset SESSION.rootDocument    = "#Parameter.DocumentServer#"> 
	
	<cfset APPLICATION.DateFormat      = "#Parameter.DateFormat#">
	<cfif Parameter.DateFormat is "EU">
	       <cfset CLIENT.DateFormatShow   = "dd/mm/yyyy">
		   <cfset APPLICATION.DateFormatCal = "%d/%m/%Y">
	<cfelse> 
	       <cfset CLIENT.DateFormatShow   = "mm/dd/yyyy">
		   <cfset APPLICATION.DateFormatCal = "%m/%d/%Y">
	</cfif>
	
	<cfset CLIENT.DateFormatShowS  = "MMM yyyy">
	<cfset CLIENT.Interface        = "HTML">
	<cfset APPLICATION.DateFormatSQL    = "#Parameter.DateFormatSQL#">
	
	<cfif APPLICATION.DateFormatSQL is "EU">
	      <cfset CLIENT.dateSQL   = "yyyy-mm-dd">
	<cfelse> 
	      <cfset CLIENT.dateSQL   = "yyyy-mm-dd">
	</cfif>
	
	<cfquery name="Init" 
	        datasource="AppsInit">
			SELECT * 
			FROM Parameter
			WHERE HostName = '#CGI.HTTP_HOST#'
	</cfquery>
	
	<cfset SESSION.rootpath         = "#Init.ApplicationRootPath#">
	
	<cfset SESSION.root             = "#Init.ApplicationRoot#">
	<cfset CLIENT.root              = "#Init.ApplicationRoot#">
	
	<cfif Parameter.DocumentRoot neq "">	
	    <cfset SESSION.rootDocument = "#Init.DocumentRoot#"> 
	</cfif>
	<cfset SESSION.rootDocumentPath = "#Init.DocumentRootPath#">	
	<cfset SESSION.rootReport       = "#Init.ReportRoot#">
	<cfset SESSION.rootReportPath   = "#Init.ReportRootPath#">
	<cfset CLIENT.servername        = "#Init.ApplicationServer#"> 
	<cfset SESSION.login            = "#Init.DefaultLogin#">
	
	<cfif Len(Trim(Init.DefaultPassword)) gt 20> 
	      <!--- encrypt password --->
	      <cf_decrypt text = "#Init.DefaultPassword#">
		  <cfset SESSION.dbpw = Decrypted>
	      <!--- end encryption --->
	<cfelse>	  
	      <cfset SESSION.dbpw = Init.DefaultPassword>
	</cfif>	  
	
	<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\")>
	
	   <cfdirectory 
	       action="CREATE" 
		   directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">
	
	</cfif>

</cfif>


