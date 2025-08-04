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

	
<cf_distributer>

<cfif master eq "1">
	
	<cfparam name="Form.TemplateCondition" default="0">
	<cfparam name="Form.EnablePortal"      default="0">
	
	<!--- new instance --->
	
	<cfquery name="Check" 
	 datasource="AppsSystem" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_ReportControl 
		WHERE  ControlIdParent = '#URL.ID#'
	</cfquery>
		
	<cfif Check.recordcount eq "0">
	
		<cf_assignId>
		
		<cftransaction>
			
		<cfset id = RowGuid>
		
		<cfquery name="Register" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	INSERT INTO Ref_ReportControl
			(ControlId, 
			        Owner, 
					LanguageCode,
			        Operational, 
					SystemModule, 
					FunctionClass,
			        FunctionName, 
					MenuClass, 
					MenuOrder,
					ReportHostName,
					EnableMailingList,
					EnablePortal,
					FunctionMemo,
					FunctionIcon,
					FunctionAbout,
					ReportPath,
					TemplateMode,
					DataSource,					
					TemplateCondition, 
					TemplateSQL,
					TemplateSQLDate,
					EnableAnonymous,
					TemplateType,
					TemplateBoxes,
					ControlIdParent,
					OfficerUserid,
					OfficerLastName,
					OfficerFirstName)
			SELECT '#id#', 
			         Owner, 
					 LanguageCode,
			         '0',
			         SystemModule, 
					 FunctionClass, 
					 FunctionName,
					 MenuClass,
					 MenuOrder,
					 ReportHostName,
					 EnableMailingList,
					 EnablePortal,
					 FunctionMemo,
					 FunctionIcon,
					 FunctionAbout,
					 ReportPath,
					 TemplateMode,
					 DataSource,					
					 TemplateCondition, 
					 TemplateSQL,
					 getDate(),
					 EnableAnonymous,
					 TemplateType,
					 TemplateBoxes,
					 '#URL.ID#',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#'
					 FROM Ref_ReportControl WHERE ControlId = '#URL.ID#'
		</cfquery>
		
		
		
		<!--- copy --->
		
		<cfloop index="tbl" list="Criteria,CriteriaField,CriteriaList,Memo,Layout,LayoutCluster,Output,Role,UserGroup" delimiters=","> 
		
		<!--- Ref_ReportControlCriteria
		      Ref_ReportControlCriteriaField
			  Ref_ReportControlCriteriaList
			  Ref_ReportControlLayout
			  Ref_ReportControlLayoutCluster
			  Ref_ReportControlMemo
			  Ref_ReportControlOutput
			  Ref_ReportControlRole
			  Ref_ReportControlUserGroup--->
			  
			    <cfquery name="Table" 
				datasource="appsSystem"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   C.name
				    FROM     SysObjects S, SysColumns C 
					WHERE    S.id = C.id
					AND      S.name = 'Ref_ReportControl#tbl#'	
					ORDER BY C.ColId
				</cfquery>
				
				<cfset select = "">
				<cfset into = "">
				
				<cfloop query="Table">
				
				 	  <cfif into neq "">
						   <cfset into = "#into#,#name#">
					   <cfelse>
					       <cfset into = "#name#">
					   </cfif>	   
							
					<cfif Name eq "ControlId">
					    <cfif select neq "">
						   <cfset select = "#select#,'#id#'">
					   <cfelse>
					       <cfset select = "'#id#'">
					   </cfif>	
					<cfelseif (Name eq "LayoutId" or Name eq "OutputId") and tbl neq "LayoutCluster">
					     <cfif select neq "">
						   <cfset select = "#select#,newId()">
					   <cfelse>
					       <cfset select = "newId()">
					   </cfif>	
					<cfelseif Name eq "LayoutIdParent">
					     <cfif select neq "">
						   <cfset select = "#select#,LayoutId">
					   <cfelse>
					       <cfset select = "LayoutId">
					   </cfif>	       
					<cfelse>
					   <cfif select neq "">
						   <cfset select = "#select#,#name#">
					   <cfelse>
					       <cfset select = "#name#">
					   </cfif>	   
					   
					</cfif>
				
				</cfloop>
								
				<cfif tbl eq "LayoutCluster">
					
					<!--- I don't think this will inherit to the replica as planned --->				
				
					<cfquery name="Insert" 
					datasource="appsSystem"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO Ref_ReportControl#tbl#	
						SELECT   #preserveSingleQuotes(select)#
					    FROM     Ref_ReportControl#tbl#	
						WHERE    Layoutid IN (SELECT LayoutId 
						                    FROM   Ref_ReportControlLayout 
											WHERE  ControlId = '#ID#') 
					</cfquery>				
				
				<cfelse>
						
					<cfquery name="Insert" 
					datasource="appsSystem"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    INSERT INTO Ref_ReportControl#tbl# (#into#)
						SELECT      #preserveSingleQuotes(select)#
					    FROM        Ref_ReportControl#tbl#	
						WHERE       ControlId = '#URL.ID#'
					</cfquery>
					
				</cfif>	
				
				
		</cfloop>
		
		<!--- copy to archive directory --->
		
		<cfquery name="Check" 
		datasource="appsSystem"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    Ref_ReportControl	
			WHERE  ControlId = '#URL.ID#'
		</cfquery>
				
		<cfif Check.ReportRoot eq "Application">
		   <cfset rootpath  = "#SESSION.rootpath#">
		<cfelse>
		   <cfset rootpath  = "#SESSION.rootReportPath#">
		</cfif>
		
		<cfif DirectoryExists("#rootPath#\#check.ReportPath#\_backup")>
			
			<cfdirectory action="DELETE" 
				directory="#rootPath#\#check.ReportPath#\_backup" 
				recurse="Yes">
			
		</cfif>	
			
		<cfdirectory action="LIST"
             directory="#rootpath#\#check.ReportPath#"
             name="GetFiles"
             listinfo="name"> 	
	
		<cfdirectory 
		     action="CREATE" 
	         directory="#rootPath#\#check.ReportPath#\_backup">
			
		<cfloop query="GetFiles">		
		
			 <cfif FindOneOf(".", name)>
			 		 		 
				 <cffile action="COPY" 
			        source="#rootpath#\#check.ReportPath#\#Name#" 
					destination="#rootpath#\#check.ReportPath#\_backup\">
				
			 </cfif>	
						
		</cfloop>		
			
		</cftransaction>
	
	</cfif>

</cfif>
