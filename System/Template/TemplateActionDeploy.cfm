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
<cfparam name="URL.mode" default="dialog">

<!--- ------------------------------------------------------------------------ --->
<!--- Template used for deploy (update/insert) a Master template to production --->
<!--- ------------------------------------------------------------------------ --->

<!--- 
0.  pass fileid and siteid
1.  file copy template to client
2.  copy record from source to master in Ref_TemplateContent with master release date
3.  record entry in Ref_TemplateAction with reference to the reviewid if exisits
--->

<cfquery name="Master" 
	  datasource="AppsControl">
      SELECT   * 
	  FROM     ParameterSite
	  WHERE    ServerRole = 'QA'
	  ORDER BY ServerRole
</cfquery>

<cfquery name="Client" 
	  datasource="AppsControl">
      SELECT   * 
	  FROM     ParameterSite
	  WHERE    ApplicationServer = '#url.client#' 	 
</cfquery>

<cfquery name="New" 
datasource="AppsControl">
	SELECT    *
	FROM      Ref_TemplateContent	
	WHERE     TemplateId = '#URL.new#'
</cfquery>	

<cfquery name="Old" 
datasource="AppsControl">
	SELECT    *
	FROM      Ref_TemplateContent	
	WHERE     TemplateId = '#URL.old#'
</cfquery>	

<cfif new.pathname eq "[root]">
  <cfset path = "">
<cfelse>
  <cfset path = new.pathname>
</cfif>    

<cfif old.recordcount eq "0">
 <cfset Action = "New">
<cfelse>
 <cfset Action = "Update"> 
</cfif>		

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

<cfif binary(new.filename) eq "yes">				
	<cfset contentnew = "binary">			
	<cfset contentold = "binary">
<cfelse>												
	<cfset contentnew = "#new.TemplateContent#">	
	<cfset contentold = "#old.templateContent#">
</cfif>							
	
<!--- step 1 --->

    <cftransaction>
	
	<!--- Record the action --->
	
	<cfquery name="CreateAction" 
	datasource="AppsControl">
		INSERT INTO Ref_TemplateAction
		(PathName, 
		 FileName, 
		 ActionType, 
		 Source, 
		 ReviewId,
		 TemplateSizeNEW, 
		 TemplateContentNew, 
		 TemplateSizeOLD, 
		 TemplateContentOLD,
		 OfficerUserId,
		 OfficerLastName,
		 OfficerFirstName)
		VALUES
		('#new.pathname#',
		 '#new.filename#',
		 '#Action#',
		 '#new.applicationserver#',
		 '#URL.reviewid#',
		 '#new.templateSize#',
		 '#contentnew#',
		 '#old.templateSize#',
		 '#contentold#',
		 '#SESSION.acc#',
		 '#SESSION.last#',
		 '#SESSION.first#')
	</cfquery>		
	
	<!--- 2a. Make entry in the replica tables --->
	
	<cfquery name="Check" 
	datasource="AppsControl">
		SELECT * 
		FROM   Ref_TemplateContent
		WHERE  ApplicationServer = '#url.client#'
		AND    PathName          = '#new.pathname#'
		AND    FileName          = '#new.filename#'	
	</cfquery>
	
	<cfif check.recordcount eq "0">
				
		<cfquery name="UpdateClient" 
		datasource="AppsControl">
			INSERT INTO Ref_TemplateContent	
			(ApplicationServer, 
			 PathName, 
			 FileName, 
			 VersionDate, 
			 TemplateStatus, TemplateOfficer, TemplateGroup, 
			 TemplateModified, TemplateModifiedBy, 
		     TemplateComments, TemplateSize, TemplateContent)
			SELECT  '#url.client#', 
			        PathName, 
					FileName, 
					'#dateformat(Client.VersionDate,client.dateSQL)#',
					TemplateStatus, 
					TemplateOfficer, 
					TemplateGroup, 
					TemplateModified, 
					TemplateModifiedBy, 
		            TemplateComments, 
					TemplateSize, 
					TemplateContent
			FROM   Ref_TemplateContent					  
			WHERE TemplateId = '#URL.New#'
		</cfquery>	
	
	<cfelse>
	
		<cfquery name="UpdateEntry" 
		datasource="AppsControl">
			UPDATE Ref_TemplateContent
			SET TemplateSize        = '#new.templateSize#',
			    TemplateContent     = '#new.templateContent#',
			    TemplateModified    = '#new.templateModified#',
				TemplateModifiedBy  = '#new.TemplateModifiedBy#'
			WHERE ApplicationServer = '#url.client#'
			AND PathName = '#new.pathname#'
			AND FileName = '#new.filename#'			
		</cfquery>	
	
	</cfif>
	
	<!--- 2b and copy file to also to file system --->
	
	<cftry>
		<cfdirectory action="CREATE" directory="#client.replicaPath#\#path#\">	
		<cfcatch></cfcatch>
	</cftry>
	
	<cf_sleep seconds="0.3"> 
	
	<cffile action="COPY" 
	        source="#master.replicaPath#\#path#\#new.fileName#" 
		    destination="#client.replicaPath#\#path#\#new.fileName#">
		
	</cftransaction>	
	
	<!--- ajax return --->
	
	<font color="359C29">Updated</font>

