
<cfset face = "Trebuchet MS">
<cfset size = "2">
<cfparam name="CLIENT.trialMode" default="0">
<cfparam name="URL.Batch" default="0">

<cfif CLIENT.reportingServer neq "">
    <cfset rptserver  = "#CLIENT.reportingServer#">
<cfelse>
    <cfset rptserver = "#rptserver#">
</cfif>

<cfif User.eMailAddress neq "">
    <cfset fail = "#User.eMailAddress#">
<cfelse>
    <cfset fail = "#Layout.eMailAddress#">
</cfif>

<cfparam name="attach" default="">

<cfquery name="Param" 
    datasource="AppsSystem">
	 SELECT   *
	 FROM     UserReport U 
	 WHERE    U.ReportId = '#URL.ReportId#' 
</cfquery>

<cfquery name="Admin" 
    datasource="AppsOrganization">
	 SELECT   *
	 FROM     OrganizationAuthorization 
	 WHERE    Role = 'Support'
	 AND      UserAccount = '#Param.account#' xxxx
</cfquery>

<!--- do not send mail if in trial mode unless it is an addmin --->

<cfif client.TrialMode neq "1" or Admin.recordcount gte "1">
	
	<cfset mail = "#User.DistributionEMailCC#">
	
	<cfif URL.Batch eq "1">
	
		<cfquery name="Mailing" 
		datasource="AppsSystem">
			SELECT    U.eMailAddress
			FROM      UserNamesGroup G INNER JOIN
	                  UserReportMailing M ON G.AccountGroup = M.Account INNER JOIN
	                  UserNames U ON G.Account = U.Account
			WHERE     M.ReportId     = '#URL.ReportId#'		
			AND       U.Disabled     = 0	  
			AND       U.eMailAddress > ''  
		</cfquery>
			
		<cfloop query="Mailing">
		
			<cfif FindNoCase("#Mailing.eMailAddress#", "#mail#") 
			   or FindNoCase("#Mailing.eMailAddress#", "#User.DistributionEMail#")>
			
			<cfelse>
		        
				<cfif mail eq "">
					<cfset mail = "#Mailing.eMailAddress#">
				<cfelse>
					<cfset mail = "#mail#,#Mailing.eMailAddress#">
				</cfif>
			
			</cfif>
		
		</cfloop>
	
	</cfif>
	
	<cfset headercolor = "ffffff">
			  
	<cfif User.DistributionEMail neq "">	
		
		<cfmail TO      = "#User.DistributionEMail#"
			CC          = "#mail#"        
			FROM        = "#SESSION.welcome# Reporter <#Layout.eMailAddress#>"
			REPLYTO     = "#User.DistributionReplyTo#"
			SUBJECT     = "REPORTER: #User.DistributionSubject#"
			FAILTO      = "#fail#"			
			MAILERID    = "#Layout.Owner# [#Layout.SystemModule#]"
			TYPE        = "html"
			SPOOLENABLE = "Yes"
			WRAPTEXT    = "100">
			
			<cfinclude  template="ReportMailContent.cfm">
			
			<cfmailparam file="#SESSION.root#/Images/prosis-logo-300.png" contentid="logo"       disposition="inline"/>
		    <cfmailparam file="#SESSION.root#/Images/prosis-logo-gray.png" contentid="logo-gray" disposition="inline"/>
			
			<cfif Param.DistributionMode eq "Attachment">	
				<cfloop index="att" list="#attach#" delimiters=","> 
					<cfmailparam file = "#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\#Att#">
				</cfloop>   
			</cfif>
												
		</cfmail>		
			
	</cfif>
	
</cfif>

