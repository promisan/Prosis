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

<!--- ----------------------------------------------- --->
<!--- Add a template from design to the master server --->
<!--- ----------------------------------------------- --->

<!--- 
0.  pass fileid
1.  file copy template to master
2.  copy record from source to master in Ref_TemplateContent with master release date
3.  record entry in Ref_TemplateAction
--->

<cfquery name="Master" 
	  datasource="AppsControl">
      SELECT * 
	  FROM   ParameterSite
	  WHERE  ServerRole = 'QA'
	  ORDER BY ServerRole
</cfquery>

<cfquery name="Source" 
	  datasource="AppsControl">
      SELECT * 
	  FROM   ParameterSite
	  WHERE  ApplicationServer IN (SELECT ApplicationServer 
	                               FROM Ref_TemplateContent	
								   WHERE TemplateId = '#URL.id#')
</cfquery>

<cfquery name="new" 
datasource="AppsControl">
	SELECT *
	FROM   Ref_TemplateContent	
	WHERE TemplateId = '#URL.id#'
</cfquery>	

<cfif new.pathname eq "[root]">
  <cfset path = "">
<cfelse>
  <cfset path = new.pathname>
</cfif>    									
	
<!--- step 1 --->

    <cftransaction>
	
	<cfquery name="CreateAction" 
	datasource="AppsControl">
		INSERT INTO Ref_TemplateAction
		(PathName, 
		 FileName, 
		 ActionType, 
		 Source, 
		 TemplateSizeNEW, 
		 TemplateContentNew)
		VALUES
		('#new.pathname#',
		 '#new.filename#',
		 'New',
		 '#new.applicationserver#',
		 '#new.templateSize#',
		 '#new.templateContent#')
	</cfquery>			
	
		<cfquery name="SelectFile" 
		datasource="AppsControl">
			SELECT  *
			FROM   Ref_TemplateContent					  
			WHERE  TemplateId = '#URL.ID#'		
		</cfquery>	
		
		<cfquery name="Check" 
		datasource="AppsControl">
		SELECT TemplateId 
        FROM Ref_TemplateContent
	    WHERE ApplicationServer = '#Master.ApplicationServer#'
		  AND PathName = '#SelectFile.PathName#'
		  AND FileName = '#SelectFile.FileName#'
		  AND VersionDate  = '#dateformat(Master.VersionDate,client.dateSQL)#'
		</cfquery>
		
		<cfquery name="Update" 
		datasource="AppsControl">
		UPDATE Ref_Template
		SET Operational = 1
	    WHERE PathName = '#SelectFile.PathName#'
		  AND FileName = '#SelectFile.FileName#'
		</cfquery>
				
		<cfif check.recordcount eq "0">  
			
		<cfquery name="CreateEntry" 
		datasource="AppsControl">
			INSERT INTO Ref_TemplateContent	
			(ApplicationServer, PathName, FileName, VersionDate, TemplateStatus, TemplateOfficer, TemplateGroup, TemplateModified, TemplateModifiedBy, 
		                      TemplateComments, TemplateSize, TemplateContent)
			SELECT  '#Master.ApplicationServer#', 
			        PathName, 
					FileName, 
					'#dateformat(Master.VersionDate,client.dateSQL)#',
					TemplateStatus, 
					TemplateOfficer, 
					TemplateGroup, 
					TemplateModified, 
					TemplateModifiedBy, 
		            TemplateComments, 
					TemplateSize, 
					TemplateContent
			FROM   Ref_TemplateContent					  
			WHERE  TemplateId = '#URL.ID#'						
		</cfquery>			
		
		</cfif>
	
			
	<cftry>	
				
		<cfdirectory action="CREATE" directory="#master.replicaPath#\#path#">	
				
		<cfcatch></cfcatch>
	
	</cftry>
	
	<cf_sleep seconds="0.3"> 
	
	<cffile action="COPY" 
	        source="#source.replicaPath#\#path#\#new.fileName#" 
		    destination="#master.replicaPath#\#path#\#new.fileName#">
				
	</cftransaction>		

<font color="008000"><b>added</b></font>




