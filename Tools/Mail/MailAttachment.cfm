
<!--- Mail Attachment script --->

<cfoutput>

<cfswitch expression="#attributes.class#">
			
	<cfcase value="ReportConfig">
	
			<cfquery name="report" 
			datasource="appsSystem">
			SELECT   *
			FROM     Ref_ReportControl 
			WHERE    ControlId = '#Attributes.ClassId#' 
			</cfquery>
						
			<cfif report.ReportRoot eq "Application" or report.ReportRoot eq "">
			   <cfset rootpath  = "#SESSION.rootpath#">
			<cfelse>
			   <cfset rootpath  = "#SESSION.rootReportPath#">
			</cfif>
					
			<cfset path = "#Report.ReportPath#">
																		
			<cfdirectory action="LIST" 
				directory="#rootpath#\#path#"
				type="File" 
				name="GetFiles">
												
			<cfloop query="getFiles"> 
				   <cfmailparam file = "#rootPath#/#path#/#name#">
			</cfloop> 
			
	</cfcase>	
				
	<cfcase value="Release">				 
				
		 <cfquery name="Release" 
			datasource="appsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT S.DistributionEMail,V.*
		    FROM ParameterSite S, ParameterSiteVersion V
			WHERE S.ApplicationServer = V.ApplicationServer  
			AND VersionId ='#Attributes.ClassId#'
		</cfquery>				
		
		<cfdirectory action="LIST" 
			directory="#SESSION.rootPath#\_Distribution\#Release.ApplicationServer#\v#DateFormat(Release.VersionDate,'YYYYMMDD')#" 
			name="GetFiles" filter="*.pdf|*.zip">
			
			<cfloop query="getFiles"> 
				  <cfmailparam file = "#SESSION.rootPath#\_Distribution\#Release.ApplicationServer#\v#DateFormat(Release.VersionDate,'YYYYMMDD')#\#name#">
			</cfloop> 
							 			
	</cfcase>	
	
	<cfdefaultcase>
		
		<cfloop index="att" list="#attachment#" delimiters=","> 			
			   <cfmailparam remove="no" file = "#SESSION.rootPath#/CFRStage/User/#SESSION.acc#/#Att#">
		</cfloop>   
	
	</cfdefaultcase>	
			
</cfswitch>	

</cfoutput>