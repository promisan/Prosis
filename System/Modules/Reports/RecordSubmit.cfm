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
<title>Save Report</title>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Pass"       default="">
<cfparam name="Form.DataSource" default="">
<cfparam name="Form.Operational" default="">
<cfparam name="Form.EnableAttachment" default="0">
<cfparam name="Form.EnableButtonback" default="0">
<cfparam name="Form.SystemModule" default="">
<cfparam name="Form.FunctionClass" default="">
<cfparam name="Form.SystemFunctionName" default="">
<cfparam name="Form.MenuClass" default="">
<cfparam name="Form.EnableLanguageAll" default="0">

<!--- verify if workflow is enabled --->

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_EntityClassPublish
	WHERE     EntityCode = 'SysReport' 
	AND       EntityClass = '#Form.SystemModule#' 
</cfquery>

<cfif Check.recordcount eq "0">
   <cfset workflow = "0">
<cfelse>
   <!--- there is a workflow defined for this report --->
   <cfset workflow = "1">  
</cfif>

<cfif ParameterExists(Form.Delete)>

	<cfquery name="Line" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_ReportControl
	WHERE ControlId = '#URL.ID#'  
    </cfquery>

	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_ReportControl
	WHERE ControlId = '#URL.ID#'  
    </cfquery>
		
	<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ReportControl
	WHERE ControlId != '#URL.ID#'  
	AND ReportRoot = '#Line.ReportRoot#'
	AND ReportPath = '#Line.ReportPath#'
    </cfquery>
	
	<cfif len(Line.ReportPath) gte 8>
	
		<cfif Check.recordcount eq "0">
		
			<cfif Line.ReportRoot eq "Application">
			 	<cfset rt = SESSION.rootPath>
			<cfelse>
			    <cfset rt = SESSION.rootReportPath>
			</cfif>
			
			<cftry>
			
			<cfdirectory action="DELETE" 
			     directory="#rt#\#Line.ReportPath#" 
				 recurse="Yes">
				 
			<cfcatch></cfcatch>	 
			
			</cftry>
			 
		</cfif>	 
	
	</cfif>
	
	<script language="JavaScript">
	 window.close()
	 opener.history.go() 
    </script>  
	
<cfelseif ParameterExists(Form.Status)>

    <cfif Form.Operational eq "0">
	
	    <!--- make sure info is reset --->
		
		<!--- deactivate the work flow if exists --->
		
			<cfquery name="SaveOldFlow" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE OrganizationObject
			SET    Operational     = '0'
			WHERE  ObjectKeyValue4 = '#URL.ID#' 
			</cfquery>
		
		<cfif workflow eq "0">

			<cfquery name="Update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_ReportControl
			SET Operational = '#Form.Operational#' 
			<cfif Form.Operational eq "1">
			, TemplateSQLDate = getDate()
			</cfif>
			WHERE ControlId = '#URL.ID#'  
		    </cfquery>
		
		<cfelse>
								
			<!--- create a new instance if workflow is enabled --->
		
			<cfinclude template="RecordSubmitInstance.cfm">
			
		</cfif>	
								
	<cfelse>
	
	    <cfif workflow eq "0">
		
			<cfquery name="Update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_ReportControl
			SET Operational = '#Form.Operational#' 
			<cfif Form.Operational eq "1">
			, TemplateSQLDate = getDate()
			</cfif>
			WHERE ControlId = '#URL.ID#'  
		    </cfquery>
			
			<!--- deploy code to production --->
			
			<cfset url.controlid = url.id>
			<cfinclude template="../../../Tools/Process/EntityAction/ReportDeploy.cfm">
				
		<cfelse>
	
			<cfquery name="Group" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_SystemModule
			WHERE SystemModule  = '#Form.SystemModule#' 
			</cfquery>
			
			<cfquery name="SaveOldFlow" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE OrganizationObject
			SET    Operational     = '0'
			WHERE  ObjectKeyValue4 = '#URL.ID#' 
			</cfquery>
							
			<cfquery name="ResetFlow" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_SystemModule
			WHERE  SystemModule  = '#Form.SystemModule#'
			</cfquery>
			
			<cfset link = "System/Modules/Reports/RecordEdit.cfm?" & CGI.QUERY_STRING>
					
			<cf_ActionListing 
				EntityCode       = "SysReport"
				EntityClass      = "#Form.SystemModule#"
				EntityGroup      = "#Group.RoleOwner#"
				EntityStatus     = ""
				OrgUnit          = ""
				ObjectReference  = "Report: #Form.FunctionName#"
				ObjectReference2 = "#Group.Description#"
				ObjectKey4       = "#URL.ID#"
				ObjectURL        = "#link#"
				Show             = "No"
				CompleteFirst    = "Yes"
				ActionMail       = "No">
			
		 </cfif>
		 	
	</cfif>
	
	<script language="JavaScript">
		window.location = "RecordEdit.cfm?Id=<cfoutput>#URL.ID#</cfoutput>"
	</script> 	
	
<cfelseif ParameterExists(Form.About)>

	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ReportControl
	SET     FunctionAbout     = '#Form.FunctionAbout#'
	WHERE ControlId = '#URL.ID#'
	</cfquery>
	
	<script language="JavaScript">
	 parent.window.close()
	</script>  	

<cfelse>

	<cfquery name="UserReport" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM    Ref_ReportControl
	  WHERE   ControlId = '#URL.ID#' 
	</cfquery>
	
	<cfif ParameterExists(Form.update3)>	
	
			<cfparam name="Form.TemplateMode"       default="">
			<cfparam name="Form.EnableAttachment"   default="0">
			<cfparam name="Form.EnableButtonBack"   default="0">			
			<cfparam name="Form.EnablePortal"       default="0">
			<cfparam name="Form.EnableLanguageAll"  default="0">
	
				<cfquery name="Update" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Ref_ReportControl
				SET      MenuClass           = '#Form.MenuClass#',
				         ReportLabel         = '#Form.ReportLabel#',
						 SystemFunctionName  = '#Form.SystemFunctionName#',
						 FunctionMemo        = '#Form.FunctionMemo#',
						 EnableAttachment    = '#Form.EnableAttachment#',
						 EnableButtonBack    = '#Form.EnableButtonBack#',
						 MenuOrder           = '#Form.MenuOrder#',
						 EnableLanguageAll   = '#Form.EnableLanguageAll#',
						 ReportHostName      = '#Form.ReportHostName#',
						 EnablePortal		 = '#Form.EnablePortal#',
						 FunctionIcon        = '#Form.FunctionIcon#' 
					<cfif form.templateMode neq "">
					,TemplateMode      = '#Form.TemplateMode#'				    
					</cfif>
				WHERE ControlId = '#URL.ID#'
				</cfquery>
	
	<cfelse>
	
		<cfif UserReport.FunctionClass neq "System">
		
			<cfparam name="Form.SystemModule" default="">
			<cfif #Form.SystemModule# eq "">
			
				<script language="JavaScript">
				     window.close()
					 opener.location.reload()
				</script>  
				<cfabort>
			
			</cfif>		
			
			<cfif UserReport.ReportRoot eq "Application">
			   <cfset rootpath  = "#SESSION.rootpath#">
			<cfelse>
			   <cfset rootpath  = "#SESSION.rootReportPath#">
			</cfif>
	
		    <cfset CLIENT.reportView = "#Form.pass#">
		
		    <cfif not IsNumeric("#Form.MenuOrder#")>
				
				<cf_message message = "You entered an invalid menu order. Operation not allowed."
				  return = "back">
				  <cfabort>
				
			</cfif>
			
			<cfif not IsNumeric("#Form.TemplateBoxes#")>
				
				<cf_message message = "You entered an invalid no of Horizontal Boxes. Operation not allowed."
				  return = "back">
				  <cfabort>
				
			</cfif>
			
			<cfif Form.TemplateSQL eq "SQL.cfm" >
			
			    <cfif Form.reportRoot eq "Application">
				 <cfset ValidSQL="#SESSION.rootpath#\#Form.ReportPath#">
				<cfelseif Form.reportRoot eq "Report">
				 <cfset ValidSQL="#SESSION.rootreportpath#\#Form.ReportPath#">
				</cfif>
				
				<cfif DirectoryExists("#validSQL#")>
						
				<cfelse>
			
					 <cfoutput>
				
						 <cf_message message = "You entered an invalid report directory (#validSQL#). Operation not allowed."
						  return = "back">
						  <cfabort>
				  
					  </cfoutput>
				  
				 </cfif> 
			
			</cfif>
			
			<cfparam name="Form.TemplateCondition" default="0">
												
			<cfif Len(#Form.FunctionName#) gt 40>
				 <cf_message message = "You entered a name that exceeded the allowed size of 40 characters."
				  return = "back">
				  <cfabort>
			</cfif>
			
			<cfif Len(#Form.FunctionMemo#) gt 150>
				 <cf_message message = "You entered a user hint that exceeded the allowed size of 150 characters."
				  return = "back">
				  <cfabort>
			</cfif>
			
			<cfif Len(Form.Remarks) gt 150>
				 <cf_message message = "You entered a memo that exceeded the allowed size of 150 characters."
				  return = "back">
				  <cfabort>
			</cfif>
			
			<cfset Path = replaceNoCase(Form.ReportPath,"/","\","ALL")> 
			<cfset Path = replaceNoCase(Path,"\\","\","ALL")> 
			<cfparam name="Form.EnablePortal"     default="0">
			<cfparam name="Form.TemplateSQLIsolation"     default="0">
						
			<cfquery name="Update" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_ReportControl
			SET      SystemModule        = '#Form.SystemModule#',
			         FunctionClass       = '#Form.FunctionClass#',
					 FunctionName        = '#Form.FunctionName#',
					 SystemFunctionName  = '#Form.SystemFunctionName#',
					 Owner               = '#Form.Owner#',
					 MenuClass           = '#Form.MenuClass#',
					 ReportLabel         = '#Form.ReportLabel#',
					 MenuOrder           = '#Form.MenuOrder#',
					 ReportHostName      = '#Form.ReportHostName#', 
					 EnablePortal		=  '#Form.EnablePortal#',
					 EnableMailingList   = '#Form.EnableMailingList#',					 
					 FunctionMemo        = '#Form.FunctionMemo#',
					 ReportRoot          = '#Form.ReportRoot#',
					 ReportPath          = '#Path#', 
					 DataSource          = '#Form.DataSource#',					
					 TemplateCondition   = '#Form.TemplateCondition#', 
					 TemplateSQL         = '#Form.TemplateSQL#',
					 TemplateSQLIsolation = '#Form.TemplateSQLIsolation#',
					 TemplateUserQuery   = '#Form.TemplateUserQuery#',
					 EnableButtonBack    = '#Form.EnableButtonBack#',
					 EnableLanguageAll   = '#Form.EnableLanguageAll#',
					 EnableAnonymous     = '#Form.EnableAnonymous#',
					 TemplateMode        = '#Form.TemplateMode#', 
					 LanguageCode        = '#Form.LanguageCode#',
					 EnableGlobal        = '#Form.EnableGlobal#',
					 EnableAttachment    = '#Form.EnableAttachment#', 
					 <!---
					 TemplateType      = '#Form.TemplateType#',
					 --->
					 TemplateBoxes       = '#Form.TemplateBoxes#',
					 Remarks             = '#Form.Remarks#',
					 NotificationEMail   = '#Form.NotificationEMail#',
					 FunctionIcon        = '#Form.FunctionIcon#'
			WHERE ControlId = '#URL.ID#'
			</cfquery>
			
			
			<cfif Form.TemplateMode eq "None">
			
				<cfquery name="Delete" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Ref_ReportControlCriteria
				WHERE ControlId = '#URL.ID#'  
		    	</cfquery>
					
			</cfif>
			
			<!--- create a default report for this module --->
			
			<cfquery name="Module" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * FROM Ref_SystemModule
			WHERE   SystemModule      = '#Form.SystemModule#'
			AND     EnableReportDefault = '1'
			</cfquery>
			
			<cfif Module.recordcount eq "1">
			
				<cfquery name="Check" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * FROM Ref_ReportControl
				WHERE   SystemModule      = '#Form.SystemModule#'
				AND     FunctionClass     = 'System'
				</cfquery>
				
				<cfif Check.recordcount eq "0">
				
					<cfquery name="Insert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_ReportControl 
					          (SystemModule, FunctionClass, FunctionName, FunctionMemo, FunctionIcon, MenuClass, TemplateSQL, TemplateMode, Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
					VALUES ('#Form.SystemModule#','System','Preset report criteria','Preset criteria values/defaults for reports','Maintain','Main','','Table','1','#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
					</cfquery>
					
					<cfquery name="Check" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM Ref_ReportControl 
					WHERE SystemModule = '#Form.SystemModule#'
					AND   FunctionClass = 'System'
					</cfquery>
					
					<cfquery name="InsertDummy" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_ReportControlLayout 
					          (ControlId, LayoutClass, Operational, OfficerUserId, OfficerLastName, OfficerFirstName, Created)
					VALUES ('#Check.ControlId#','System','1','#SESSION.acc#', '#SESSION.last#', '#SESSION.first#', getDate())
					</cfquery>
					
				</cfif>
			
			</cfif>
					
		<cfelse>
		
			<cfquery name="Update" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Ref_ReportControl
				SET   TemplateBoxes     = '#Form.TemplateBoxes#'
				WHERE ControlId = '#URL.ID#'
				</cfquery>
		
		</cfif>		
	
	</cfif>	
				
	<cfif ParameterExists(Form.Update2)>
	
	    <script language="JavaScript">
			
		  try {
		 opener.history.go() 
		 } catch(e) {}
		 window.close()
		
		</script>
			
	<cfelse>
	
		<script language="JavaScript">
		 window.location = "RecordEdit.cfm?Id=<cfoutput>#URL.ID#</cfoutput>"
		 try {
		 opener.history.go() 
		 } catch(e) {}
		
		 <cfif ParameterExists(Form.Update)>
	    	 alert("Report configuration has been saved.")
		 </cfif>
		 
		</script>  
		
	</cfif>
		
</cfif>	

	

	
