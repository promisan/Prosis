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

<!--- ---------------------------------------------------------------- --->
<!--- utility to move report from external central to local directory- --->
<!--- performed prior to launching the report ------------------------ --->
<!--- ---------------------------------------------------------------- --->

<!--- explanations :

if a report is defined a centrally maintained the field : Ref_ReportControl.report root has the valuu : REPORT

this will trigger that prior to launching the report, the report definition will be copied
from the central location to a local file on the web-server that launches the report. The
local file is located in CFRstage/Report/[controlid].

This facilitate works only of the report is self contained and does not use files outside the report directory
such as central files. However you may use Prosis procedures as stored in <tools>

The advantage is obvious if you have several servers. This procedure will allow you to maintain
a single copy of your report and sql.cfm in a single location !!!
--->

<cfparam name="Attributes.layoutid" 
         default="00000000-0000-0000-0000-000000000000">

<cfquery name="report" 
			datasource="AppsSystem">
			SELECT R.ControlId, 
			       TemplateSQL, 
				   R.ReportRoot, 
				   R.ReportPath, 
				   R.TemplateSQL, 
				   O.TemplateReport
			FROM   Ref_ReportControl R, Ref_ReportControlLayout O
			WHERE  R.ControlId = O.ControlId
			AND    O.LayoutId = '#Attributes.layoutId#'				
</cfquery>


<!--- check if report exists locally --->

<cfif Report.TemplateSQL eq "SQL.cfm">

	<cfif FileExists("#SESSION.rootPath#\#Report.ReportPath#\#Report.TemplateSQL#") and report.reportRoot eq "Application">
	
	<!--- prior, added condition

	<cfif FileExists("#SESSION.rootPath#\#Report.ReportPath#\#Report.TemplateSQL#")>
	
	--->
	
		<cfset caller.root          = "#SESSION.root#">
		<cfset caller.rootpath      = "#SESSION.rootpath#">
		<cfset caller.reppath       = "#SESSION.rootPath#/#Report.ReportPath#">
		<cfset caller.reportSQL     = "../../#Report.ReportPath#/#Report.TemplateSQL#">
		<cfset caller.reportLayout  = "../../#Report.ReportPath#/#Report.TemplateReport#">
		
	<cfelse>
	
		<!--- if not exist locally check for central db and copy over --->
						
		<cfdirectory action="LIST" 
		    directory="#SESSION.rootReportPath#/#Report.ReportPath#" 
			name="GetFiles" recurse="No"> 	
			
		<cfif not DirectoryExists("#SESSION.rootpath#/CFRStage/Report/#Report.ControlId#")>
					
			<cfdirectory action="CREATE" 
			   directory="#SESSION.rootpath#/CFRStage/Report/#Report.ControlId#">
		  
		</cfif>  	
											
		<cfoutput query="GetFiles">		
							
			 <cfif FindOneOf(".", name)>
			
				<cfset SourceFile = CreateObject("java", "java.io.File")>
				<cfset SourceFile.init("#SESSION.rootReportPath#\#Report.ReportPath#\#name#")>
				<cfset SourceFileModified = SourceFile.lastModified()>

				<cfset DestinationFile = CreateObject("java", "java.io.File")>
				<cfset DestinationFile.init("#SESSION.rootpath#\CFRStage\Report\#Report.ControlId#\#name#")>
				<cfset DestinationFileModified = DestinationFile.lastModified()>

				<cfif SourceFileModified gt DestinationFileModified>
					 <cffile action="COPY" 
			    		source      = "#SESSION.rootReportPath#\#Report.ReportPath#\#name#" 
			   			destination = "#SESSION.rootpath#\CFRStage\Report\#Report.ControlId#\#name#">															
				</cfif>
 						 		 
			 </cfif>	
										
		</cfoutput>
		
		<cfset caller.root          = "#SESSION.rootReport#">
		<cfset caller.rootpath      = "#SESSION.rootReportPath#">
		<cfset caller.reppath       = "#SESSION.rootpath#/CFRStage/Report/#Report.ControlId#">
		<cfset caller.reportSQL     = "../../CFRStage/Report/#Report.ControlId#/#Report.TemplateSQL#">
		<cfset caller.reportLayout  = "../../CFRStage/Report/#Report.ControlId#/#Report.TemplateReport#">
							
	</cfif>
	
<cfelse>

	

</cfif>	