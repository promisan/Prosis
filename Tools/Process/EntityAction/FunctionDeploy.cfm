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

<cfquery name="Source" 
	  datasource="AppsSystem">
		SELECT  *
		FROM    Ref_ModuleControl
		WHERE   SystemFunctionId = '#URL.ControlId#' 	
	</cfquery>	

<!--- 
0. Connect to DB server of the production environments
1. Determine current ControlId and then determine current layout ID
--->

<cfquery name="dbserverlist" 
	  datasource="AppsControl">
		SELECT  DISTINCT DatabaseServer as dbserver
		FROM    ParameterSite
		WHERE   ServerLocation = 'Local'
		AND     ServerRole     = 'Production'	
		AND     Operational    = 1
		AND     DatabaseServer > ''		
	</cfquery>	
	
<cfset dblist =  ValueList(dbserverlist.dbserver,";")>

<!--- issue by Khurshid in NY on 16/4/2009

dbserver is the db server of the production systems, the function
will fail in case you want to deploy a function which is on the same server
as the server of the production database. AppsSystem should not be pointing
to the same database as [#dbserver#].system does --->
	
<cfloop index="dbserver" list="#dblist#" delimiters=";">
			
	<cfset new = Source.SystemFunctionId>
	
	<!--- check destination --->
	
	<cfquery name="ReportExist" 
	  datasource="AppsSystem">
		SELECT  *
		FROM    Ref_ModuleControl
		WHERE   SystemFunctionId = '#Source.SystemFunctionId#' 
		AND     SystemFunctionId IN
	                 (SELECT SystemFunctionId
	                  FROM   [#dbserver#].system.dbo.Ref_ModuleControl )
	</cfquery>		
	
	<cfif ReportExist.recordcount eq "0">
	
		<!--- find matching record --->
	
		<cfquery name="ReportExist" 
		  datasource="AppsSystem">
			SELECT  top 1 *
			FROM    [#dbserver#].System.dbo.Ref_ModuleControl
			WHERE   SystemModule  = '#Source.SystemModule#'
			AND     FunctionClass = '#Source.FunctionClass#'
			AND     FunctionName = '#Source.FunctionName#'
		</cfquery>
		
		<cfif ReportExist.recordcount eq "0">
					
			<cf_assignId>
			
			<cfquery name="Update" 
				 datasource="AppsSystem">
				 UPDATE   [#dbserver#].System.dbo.Ref_ModuleControl
				 SET      SystemFunctionId = '#rowguid#' 
				 WHERE    SystemFunctionId = '#new#'      
			</cfquery>
			
			<cfset oldid = rowguid>		
				
		<cfelse>
		
			<cfset oldid = reportExist.controlid>
			
		</cfif>	
				
	<cfelse>
	
		<!--- same id is used in destination database, hereto we change the id in destination 
		in order to create a temp duplicate --->
		
		<!--- provision to make sure the destination DBMS <> source DBMS --->
		
		<cf_assignId>
		
		<cfquery name="Update" 
			 datasource="AppsSystem">
			 UPDATE   [#dbserver#].System.dbo.Ref_ModuleControl
			 SET      SystemFunctionId = '#rowguid#' 
			 WHERE    SystemFunctionId = '#new#'      
		</cfquery>
		
		<cfset oldid = rowguid>		
	
	</cfif>		
	
	<!--- 2. insert report into operational database --->
	
	<cfset list   = "Ref_ModuleControl,Ref_ModuleControlDetail,Ref_ModuleControlDetailField,Ref_ModuleControl_Language, Ref_ModuleControlRole, Ref_ModuleControlRoleLevel">
					 
	<!--- in order to prevent duplication for reportcontrollayout and output 
	we simply give these records a new id in the source table --->		
	
	<cfquery name="reset" 
		datasource="appsSystem">
		DELETE FROM [#dbserver#].System.dbo.Ref_ModuleControl
		WHERE      ( SystemModule  = '#Source.SystemModule#'
			AND    FunctionClass = '#Source.FunctionClass#'			
			AND    FunctionName = 'old' )
				OR SystemFunctionId = '#new#'
	</cfquery>		
	
	<cfquery name="reset" 
		datasource="appsSystem">
		UPDATE    [#dbserver#].System.dbo.Ref_ModuleControl
		SET        FunctionName = 'old', Operational = '0'
		WHERE      SystemModule  = '#Source.SystemModule#'
			AND    FunctionClass = '#Source.FunctionClass#'
			AND    FunctionName = '#Source.FunctionName#'
	</cfquery>		 
		
	<!--- now we add the info --->
					 
	<cfloop index="tbl" list="#list#" delimiters=",">
	 
		<cfquery name="tablecontent" 
		datasource="appsSystem">
				SELECT   C.name, C.userType 
			    FROM     SysObjects S, SysColumns C 
				WHERE    S.id = C.id
				AND      S.name = '#tbl#'	
				AND      C.name <> 'detailserialno'
				ORDER BY C.ColId
		</cfquery>
				
		<cfset field = "">
		<cfloop query="tablecontent">
		    
			    <cfset field = "#field#,#name#">
				<cfset last = "#name#">
				
		</cfloop>	
		
		<cfif tablecontent.recordcount gte "1">
		
		<cftry>
		
		<cfquery name="insert" 
		 datasource="appsSystem">
		
				INSERT INTO  [#dbserver#].System.dbo.#tbl#
				(<cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
				SELECT <cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>
				FROM #tbl#
				WHERE    SystemFunctionId = '#new#'					
				
		</cfquery>		
		
		<cfcatch></cfcatch>
		</cftry>
		
		</cfif>		
			
		
	</cfloop>
	
		
</cfloop>

