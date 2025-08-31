<!--
    Copyright © 2025 Promisan B.V.

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
			   <cfmailparam remove="no" file = "#SESSION.rootdocumentpath#\CFRStage\User\#SESSION.acc#\#Att#">
		</cfloop>   
	
	</cfdefaultcase>	
			
</cfswitch>	

</cfoutput>