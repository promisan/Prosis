<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cfif len(CGI.HTTP_USER_AGENT) gt "120">
		<cfset version = "#left(CGI.HTTP_USER_AGENT,120)#">
<cfelse>
		<cfset version = "#CGI.HTTP_USER_AGENT#">
</cfif>
   
<cfparam name="Attributes.ErrorReferer"     default="">
<cfparam name="Attributes.ErrorTemplate"    default="#CGI.SCRIPT_NAME#">
<cfparam name="Attributes.ErrorString"      default="#CGI.QUERY_STRING#">
<cfparam name="Attributes.ErrorNodeIp"      default="#CGI.Remote_Addr#">
<cfparam name="Attributes.ErrorBrowser"     default="#version#">
<cfparam name="Attributes.ErrorDateTime"    default="#now()#">
<cfparam name="Attributes.ErrorDiagnostics" default="">
<cfparam name="Attributes.ErrorSource"      default="CFERROR">
<cfparam name="Attributes.eMail"            default="0">
<cfparam name="Attributes.ControlId"        default="">
<cfparam name="Attributes.ErrorId"          default="">
<cfparam name="Attributes.ActionId"         default="">
<cfparam name="Attributes.Templates"         default="">

<cfquery name="Sys" 
datasource="AppsSystem">
	SELECT * 	FROM   Parameter
</cfquery>

<cfquery name="Parameter" 
datasource="AppsInit">
	SELECT * 
	FROM   Parameter
	WHERE  HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<cfset to = "#Parameter.SystemContactEMail#">

<cfset ccto = "">

<cfset pathname = "">
<cfset filename = "">
<cfset group    = "[root]">
<cfset cnt      = 0>

<cfloop index="itm" list="#CGI.SCRIPT_NAME#" delimiters="/">
	
		<cfif find(".",itm)>
		    <cfset fileName = "#itm#">
		<cfelse>
		    <cfif itm neq "nucleus" and itm neq "Prosis" and itm neq "dw">
			    <cfif itm eq sys.virtualdirectory and cnt eq "0">
					<!--- DO NOTHING --->				
				<cfelse>
				    <cfif pathname eq "">
					<cfset group = itm>
					</cfif>
					<cfset pathname = "#pathname#\#itm#">
				</cfif>
			</cfif>
		</cfif>
		<cfset cnt = cnt+1>
	
</cfloop>
		
<cfif pathname eq "">
	  <cfset pathname = "[root]">
</cfif>

<cftry>
	
	<cfquery name="check" 
		datasource="AppsControl">
		SELECT * 
		FROM Ref_Template
		WHERE FileName = '#filename#'
		AND   PathName = '#pathname#'
	</cfquery>
	
	<cfset cc = "">
	
	<cfif check.recordcount eq "1">
	
		<!--- check if template has responsible account and retrieve the email address --->
		
		<cfquery name="Last" 
		datasource="AppsControl">
		SELECT   *
		FROM     Ref_TemplateContent T 
		WHERE    T.FileName = '#filename#'
		AND      T.PathName = '#pathname#'
		ORDER BY T.VersionDate DESC 
	    </cfquery>
	
		<cfquery name="cc" 
		datasource="AppsSystem">
		SELECT   *
		FROM     UserNames 
		WHERE    Account = '#Last.Templateofficer#'	
	    </cfquery>
		
		<cfif cc.recordcount eq "1">
		
			<cfif Parameter.ErrorMailToOwner eq "1">
				<cfset to   = cc.eMailAddress>
			<cfelse>
				<cfset ccto = cc.eMailAddress>
			</cfif>
		
		</cfif>
	
	</cfif>
	
		<cfcatch>
		
		<cfquery name="check" 
					datasource="AppsSystem">
					SELECT   *
					FROM     UserNames 
					WHERE    1=0	
			</cfquery>	
			
			<cfset to = "">
			<cfset ccto = "">	
				
	
		</cfcatch>

</cftry>

<cfif attributes.errorid eq "">

 	<cf_AssignId>
	<cfset attributes.errorid = rowguid>
	
</cfif>

<cf_param name="Session.acc" default="undefined"    type="String">
<cf_param name="CLIENT.acc" default="#SESSION.acc#" type="String">

<cfquery name="Insert" 
datasource="AppsSystem">
	INSERT INTO UserError
		(ErrorId, 
		 Source,
		 Account, 
		 HostName, 
		 HostServer,
		 NodeIP, 
		 NodeVersion, 
		 ErrorTimestamp, 
		 ErrorReferer,
		 ErrorTemplate, 
		 TemplateGroup,
		 <cfif attributes.actionid neq "">
		 ActionId,
		 </cfif>
		 <cfif attributes.controlid neq "">
		 ControlId,
		 </cfif>	 
		 <cfif check.recordcount eq "1">	
		 FileName,
		 PathName,	
		 </cfif>
		 ErrorContent,
		 ErrorString, 
		 ErrorDiagnostics, 
		 ErrorEMail,
		 ErrorEMailCC )
	VALUES ('#attributes.errorid#',
		'#Attributes.ErrorSource#',
		'#CLIENT.acc#',
		'#CGI.HTTP_HOST#',
		'#Parameter.ApplicationServer#',
		'#Attributes.ErrorNodeIP#',
		'#left(Attributes.ErrorBrowser,120)#',
		#Attributes.ErrorDateTime#,
		'#left(Attributes.ErrorReferer,200)#',
		'#left(Attributes.ErrorTemplate,200)#',	
		'#group#',
		<cfif attributes.actionid neq "">
		 '#Attributes.actionId#',
		</cfif>
		<cfif attributes.controlid neq "">
		 '#Attributes.ControlId#',
		</cfif>
		<cfif check.recordcount eq "1">
		'#FileName#',
		'#PathName#',	
		</cfif>
		'#Attributes.Templates#',
		'#left(Attributes.ErrorString,300)#',
		'#Attributes.ErrorDiagnostics#',
		'#to#',
		'#ccto#') 
</cfquery>

<!--- mail is triggered to the system manager --->
<cfif attributes.eMail eq "1" and check.recordcount eq "1">
	<cf_ErrorInsertMail errorid="#attributes.errorid#">	
</cfif>