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


<!--- batch routune update client site : development 
or production (only when confirmed by site) --->

<!--- 
1.	receive a list of templateId + destination
2.	loop through the templates of the database table
3.  determine binary vs text
4.  retrieve record
	binary : write file to destination	
	text : copy record content to destination
5.	remove db template entry for the site
6.	add template entry for the site
endloop		
7.	reload page
--->

<!---
<cf_wait Text="Update templates on development server">
--->


<cfparam name="URL.Site" default="">

<cfquery name="Master" 
		  datasource="AppsControl">
		      SELECT * 
			  FROM   ParameterSite
			  WHERE  ServerRole = 'QA' 
		</cfquery>
	
<cfquery name="Site" 
	  datasource="AppsControl">
	      SELECT * 
		  FROM   ParameterSite
		  WHERE  ApplicationServer = '#URL.Site#'
	</cfquery>
	
<cffunction name="binary" returntype="string">

	<cfargument name="name" type="string">

	<cfif FindNoCase(".cfr", name) or 
	  FindNoCase(".rpt", name) or 
	  FindNoCase(".swf", name) or 
	  FindNoCase(".ico", name) or 
	  FindNoCase(".png", name) or 
	  FindNoCase(".gif", name) or 
	  FindNoCase(".jpg", name) or 
	  FindNoCase(".bmp", name)>
	  <cfreturn "yes"> 
	<cfelse>
	  <cfreturn "no">  
    </cfif>
	
</cffunction>

<cfset client.progress = "">
<cfset row = "0">


<cfloop index="Id" list="#Form.Templates#" delimiters=",">
		
	<cfquery name="Select" 
		datasource="AppsControl">
		SELECT   TOP 1 *
		FROM     Ref_TemplateContent
		WHERE    TemplateId = '#id#' 
	</cfquery>	
	
	<cfset row = row+1>
	
	<cfoutput query="Select">
	
	    <!--- check if template exists --->
		
		<cfif pathName eq "[root]">
			<cfset path = "">
		<cfelse>
			<cfset path = pathName>
		</cfif>		
		
		<cfif not FileExists("#Master.ReplicaPath#\#Path#\#FileName#")>
		
			<cfsavecontent variable="prg">
						<tr><td>#row# : #Path#\#FileName# : not found</td></tr>
			</cfsavecontent>
		
		    <cfset client.progress = "#client.progress# #prg#">		
						
		
		<cfelse>
 				
			<cfif pathName eq "[root]">
				<cfset path = "">
			<cfelse>
				<cfset path = pathName>
			</cfif>		
			
			<cfsavecontent variable="prg">
					<tr><td>#row# : #Path#\#FileName#</td></tr>
			</cfsavecontent>			
			<cfset client.progress = "#client.progress# #prg#">		
			
						
			<cfset subdir = "">
			<cfloop index="itm" list="#fileName#" delimiters="\">
			<cfif find(".",itm)>
			    <!--- do nothing --->
			<cfelse>
				<cfset subdir = "#subdir#\#itm#">
			</cfif>	
			</cfloop>
			
			<cftry>
				<cfdirectory action="CREATE" directory="#Site.ReplicaPath#\#Path##subdir#">
				<cfcatch></cfcatch>
			</cftry>
			
			<cftransaction>
			
			<cffile action="COPY"
		        source="#Master.ReplicaPath#\#Path#\#FileName#"
		        destination="#Site.ReplicaPath#\#Path##subdir#\">
			
			<cfif binary(filename) eq "yes">
				
				<cfset content = "binary">
			
			<cfelse>
												
				<cfset content = "#TemplateContent#">
		
			</cfif>
			
			<!--- remove table entry --->
			
			<cfquery name="Delete" 
				datasource="AppsControl">
			    DELETE Ref_TemplateContent
				WHERE  PathName          = '#pathname#'
				AND    FileName          = '#filename#'
				AND    ApplicationServer = '#URL.Site#'
			</cfquery>
			
			<!--- add logging entry --->
							
			<cfquery name="CreateAction" 
			datasource="AppsControl">
				INSERT INTO Ref_TemplateAction
				(PathName, 
				 FileName, 
				 ActionType, 
				 Source, 				
				 TemplateSizeNEW, 
				 TemplateContentNew, 				
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
				SELECT PathName,
					 FileName,
					 'BatchSync',
					 '#URL.Site#',										
					 TemplateSize,
					 TemplateContent,
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#'					  
				FROM Ref_TemplateContent
				WHERE TemplateId = '#TemplateId#'  				
			</cfquery>		
			
			<!--- add table entry --->
			
			<cfquery name="Insert" 
			datasource="AppsControl">
		   		INSERT INTO Ref_TemplateContent
					(PathName,
					 FileName,
					 ApplicationServer,
					 VersionDate,
					 TemplateOfficer,
					 TemplateGroup,
					 TemplateModified,
					 TemplateModifiedBy,
					 TemplateComments,
					 TemplateSize,
					 TemplateContent)
				SELECT 
					 PathName,
					 FileName,
					 '#URL.Site#',
					 VersionDate,
					 TemplateOfficer,
					 TemplateGroup,
					 TemplateModified,
					 TemplateModifiedBy,
					 TemplateComments,
					 TemplateSize,
					 TemplateContent 
				FROM Ref_TemplateContent
				WHERE TemplateId = '#TemplateId#' 
			</cfquery>
			
			</cftransaction>
			
		</cfif>	
		
	</cfoutput>

</cfloop>
		
<cfoutput>	
	<script>
	   stopprogress() 
	   ColdFusion.navigate('TemplateActionDeployProgress.cfm','detail')	
	   alert("Batch Synchronization successfully completed.")
	   ColdFusion.navigate('TemplateLog.cfm?group=#url.group#&site=#URL.site#','detail')	   
	</script>
	
</cfoutput>


