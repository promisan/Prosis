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
<cfflush>

<cfparam name="distribution" default="0">
<cfparam name="url.group" default="">

<cfif URL.site neq "">


	   <!--- site comparison with master code 
	   - get temp table with latest version form Q&A
	   	   
	   - list code in site but not in master
	   - list code in master but not in site
	   - list code in master <> code in site
	   --->
	   		   
	   <CF_DropTable dbName="AppsQueryControl" full="1" tblName="#SESSION.acc#Template"> 
	   
	   <cfquery name="LatestMaster" 
		datasource="AppsControl">
		    SELECT   RC.ApplicationServer,
			         R.PathName, 
					 R.FileName, 
					 R.Operational,
					 MAX(RC.VersionDate) AS VersionDate
	        INTO     userQuery.dbo.#SESSION.acc#Template
	        FROM     Ref_Template R INNER JOIN Ref_TemplateContent RC ON 
			         R.PathName = RC.PathName AND 
					 R.FileName = RC.FileName
	      	WHERE    RC.ApplicationServer = '#Master.ApplicationServer#'
			AND      RC.TemplateStatus = '1'
			<cfif Site.ServerRole eq "Design">
			<!--- for good comparison only the active files are taken here --->
			AND      R.Operational = 1 
			
			AND      RC.TemplateGroup IN (SELECT TemplateGroup 
			                              FROM ParameterSiteGroup
										  WHERE ApplicationServer = '#URL.Site#'
										  AND Operational = 1
										  <cfif url.group neq "">
										  AND TemplateGroup = '#url.group#'  
										  </cfif>
										  <cfif url.distribution eq "1">
										  AND Distribution = '1'
										  </cfif>) 
			
						
			<cfelse>
			
			AND      RC.TemplateGroup IN (SELECT TemplateGroup 
			                              FROM ParameterSiteGroup
										  WHERE ApplicationServer = '#URL.Site#'
										  AND Operational = 1
										  <cfif url.group neq "">
										  AND TemplateGroup = '#url.group#'  
										  </cfif>
										  <cfif url.distribution eq "1">
										  AND Distribution = '1'
										  </cfif>)
			</cfif>							  
	        GROUP BY RC.ApplicationServer, 
			         R.PathName, R.FileName, R.Operational 
	   </cfquery>
	   
	   
	   <CF_DropTable dbName="AppsQueryControl"  full="1" tblName="#SESSION.acc#TemplateQA"> 
	   
	    <!--- -------------------------------------------- --->	 
	    <!--- retrieve the templates for the master site-- --->
	    <!--- -------------------------------------------- --->
	 	   
	   <cfquery name="LatestMaster" 
		datasource="AppsControl">
		SELECT      C.ApplicationServer, 
		            C.PathName, 
					C.FileName, 
		            C.VersionDate, 
					C.TemplateOfficer, 
		            C.TemplateGroup, 
					C.TemplateModified, 
					C.TemplateModifiedBy, 
					C.TemplateComments, 
                    C.TemplateSize, 
					C.TemplateId, 
					C.PathName+'\'+C.FileName as Template,
					T.Operational
		INTO        userQuery.dbo.#SESSION.acc#TemplateQA
		FROM        userQuery.dbo.#SESSION.acc#Template T, 
                    Ref_TemplateContent C 
		WHERE       T.ApplicationServer = C.ApplicationServer 
		AND         T.PathName = C.PathName 
		AND         T.FileName = C.FileName 
		AND         C.TemplateStatus = '1'
		AND         T.VersionDate = C.VersionDate 
	  </cfquery>
	  
	  <CF_DropTable dbName="AppsQueryControl"  full="1" tblName="#SESSION.acc#Template"> 
	  <CF_DropTable dbName="AppsQueryControl"  full="1" tblName="#SESSION.acc#TemplateSite">
	 	 
	  <!--- -------------------------------------------- --->	 
	  <!--- retrieve the templates for the selected site --->
	  <!--- -------------------------------------------- --->
	  	  
	  <cfquery name="LatestSite" 
		datasource="AppsControl">
		    SELECT  C.ApplicationServer, 
			        C.PathName, 
					C.FileName, 
		            C.VersionDate, 
					C.TemplateOfficer, 
		            C.TemplateGroup, 
					C.TemplateModified, 
					C.TemplateModifiedBy, 
					C.TemplateComments, 
                    C.TemplateSize, 
					C.TemplateId, 
					C.PathName+'\'+C.FileName as Template,
					'1' as Operational
			INTO    userQuery.dbo.#SESSION.acc#TemplateSite
	        FROM    Ref_Template R INNER JOIN Ref_TemplateContent C ON 
			        R.PathName = C.PathName AND 
					R.FileName = C.FileName
	        WHERE   C.ApplicationServer = '#URL.Site#' 
			
			AND      C.TemplateGroup IN (SELECT TemplateGroup 
			                              FROM ParameterSiteGroup
										  WHERE ApplicationServer = '#URL.Site#'
										  AND Operational = 1
										  <cfif url.group neq "">
										  AND TemplateGroup = '#url.group#'  
										  </cfif>
										  <cfif url.distribution eq "1">
										  AND Distribution = '1'
										  </cfif>) 
      </cfquery>

	  <!--- ------------------------------------------------------ --->
	  <!--- compare the templates between master and selected site --->
	  <!--- ------------------------------------------------------ --->
	  	   
	  <cfquery name="Listing" 
		datasource="AppsQueryControl">
	    SELECT    *, 
		          '' as TemplateCompareId,
		          'Add' AS Comparison
		FROM      #SESSION.acc#TemplateQA
		WHERE     Template NOT IN (SELECT Template  FROM #SESSION.acc#TemplateSite)
		AND       Operational = 1
		 
		<cfif Site.ServerRole eq "Design">
		
			<!--- bi-directional freshcode --->
			
		    UNION
			<!--- ATTENTION : only on the design server templates are added, 
					  		  never on production server --->
			SELECT    S.*, 
			          '' as TemplateCompareId,
			          'Not found in master' AS Comparison
			FROM      #SESSION.acc#TemplateSite S
			WHERE     Template NOT IN (SELECT Template 
			                           FROM   #SESSION.acc#TemplateQA
									   WHERE  Template = S.Template)
			
			UNION 
			
			SELECT    QA.*, 
			          convert(varchar(40),Site.TemplateId) as TemplateCompareId,
			          'Update: #URL.site#' AS Comparison
			FROM      #SESSION.acc#TemplateQA QA, 
			          #SESSION.acc#TemplateSite Site
			WHERE     QA.Template = Site.Template 
			AND       QA.TemplateSize <> Site.TemplateSize
			AND       QA.TemplateModified >= Site.TemplateModified
			AND       QA.Operational = 1 
						
			UNION
			
			SELECT    QA.*, 
			          convert(varchar(40),Site.TemplateId) as TemplateCompareId,
			          'Update: Master' AS Comparison
			FROM      #SESSION.acc#TemplateQA QA, 
			          #SESSION.acc#TemplateSite Site
			WHERE     QA.Template = Site.Template 
			AND       QA.TemplateSize <> Site.TemplateSize
			AND       QA.TemplateModified < Site.TemplateModified
			AND       QA.Operational = 1 
											
		<cfelse>
		
			<!--- production site --->
		
		    UNION
			
		    <!--- deleted templates still in replica --->
			
			SELECT    QA.*, 
			          convert(varchar(40),Site.TemplateId) as TemplateCompareId,
			          'Remove' AS Comparison
			FROM      #SESSION.acc#TemplateQA QA, 
			          #SESSION.acc#TemplateSite Site
			WHERE     QA.Template = Site.Template 
			AND       QA.Operational = 0 
			
			UNION 
					
			SELECT    QA.*, 
			          convert(varchar(40),Site.TemplateId) as TemplateCompareId,
			          'Replace' AS Comparison
			FROM      #SESSION.acc#TemplateQA QA, 
			          #SESSION.acc#TemplateSite Site
			WHERE     QA.Template = Site.Template 
			AND       (QA.TemplateSize <> Site.TemplateSize or CONVERT(int, 
                      QA.TemplateModified - Site.TemplateModified) > 0)			
			AND       QA.Operational = 1 
			
		</cfif>
		
		ORDER BY ApplicationServer, PathName, FileName, VersionDate DESC

		</cfquery>
				
<cfelseif url.filter eq "0">
		
	 <cfquery name="Listing" 
		datasource="AppsControl">
		    SELECT RT.*, 
			       'Prior' as TemplateCompareId,
			       'Added/Changed' AS Comparison,
				   R.Operational 
			FROM   Ref_Template R, 
			       Ref_TemplateContent RT
			WHERE  R.PathName = RT.PathName
			AND    R.FileName = RT.FileName	 
			AND    RT.VersionDate = '#version#' 
			AND    RT.ApplicationServer = '#master.ApplicationServer#'
			AND    RT.TemplateStatus = '1'
			UNION ALL
			SELECT RT.*, 
			       'Prior' as TemplateCompareId,
			       'Deleted' AS Comparison,
				   R.Operational 
			FROM   Ref_Template R, 
			       Ref_TemplateContent RT
			WHERE  R.PathName = RT.PathName
			AND    R.FileName = RT.FileName	 
			AND    R.VersionDateRemoved = '#version#'
			AND    RT.ApplicationServer = '#master.ApplicationServer#'
			AND    R.Source = '#Master.ApplicationServer#'
			AND    RT.TemplateStatus = '1'
			ORDER BY RT.ApplicationServer, 
			         RT.TemplateGroup, 
					 RT.PathName, 
					 RT.FileName, 
					 RT.VersionDate DESC
					 
		</cfquery>
		
<cfelse>
	
	<CF_DateConvert Value="#Form.DateStart#">
	<cfset STR = dateValue>

	<CF_DateConvert Value="#Form.DateEnd#">
	<cfset END = dateValue>

	
	<cfquery name="Listing" 
		datasource="AppsControl">
		    SELECT TOP 800 RT.*, 
			       'Prior' as TemplateCompareId,
			       'Added/Changed' AS Comparison,
				   R.Operational 
			FROM   Ref_Template R, 
			       Ref_TemplateContent RT
			WHERE  R.PathName = RT.PathName
			AND    R.FileName = RT.FileName	
			AND    RT.ApplicationServer = '#master.ApplicationServer#'
			AND    RT.TemplateStatus    = '1'
			<cfif Form.FileName neq "">
			AND    RT.FileName LIKE '%#Form.FileName#%' 
			</cfif>
			AND    RT.VersionDate >= #str#
			AND    RT.VersionDate <= #end# 
			<cfif Form.Group neq "">
			AND    RT.TemplateGroup = '#Form.Group#' 
			</cfif>
			UNION ALL
			SELECT RT.*, 
			       'Prior' as TemplateCompareId,
			       'Deleted' AS Comparison,
				   R.Operational 
			FROM   Ref_Template R, 
			       Ref_TemplateContent RT
			WHERE  R.PathName = RT.PathName
			AND    R.FileName = RT.FileName	 
			AND    RT.ApplicationServer = '#master.ApplicationServer#'
			AND    R.Source = '#Master.ApplicationServer#'
			AND    RT.TemplateStatus = '1'
			AND    R.VersionDateRemoved >= #str#
			AND    R.VersionDateRemoved <= #end# 
			<cfif Form.FileName neq "">
			AND    RT.FileName LIKE '%#Form.FileName#%' 
			</cfif>			
			<cfif Form.Group neq "">
			AND    RT.TemplateGroup = '#Form.Group#'
			</cfif>
			ORDER BY RT.ApplicationServer, 
			         RT.TemplateGroup, 
					 RT.PathName, 
					 RT.FileName, 
					 RT.VersionDate DESC				 
		</cfquery>
				
</cfif>			
