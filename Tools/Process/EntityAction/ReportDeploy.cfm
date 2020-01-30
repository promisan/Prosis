

<!--- --------------------------------------------------------------------------------------------------- --->
<!---

In order for this routine to work destination servers need to be defined as 

a. Linked servers in SQL of the deployment server and 
b. CFMX instance on the deployment need to be running under an account (like CFMX) which same account has full access to the
directories on the distination server. I suggest to standardise all cf services under CFMX, CFMX account for 
all instances

--->
<!--- --------------------------------------------------------------------------------------------------- --->


<cfparam name="Object.ObjectKeyValue4"    default="">
<cfparam name="url.controlid"    default="#Object.ObjectKeyValue4#">

<cfquery name="Source" 
	  datasource="AppsSystem">
		SELECT  *
		FROM    Ref_ReportControl
		WHERE   ControlId = '#URL.ControlId#' 	
	</cfquery>	

<!--- 
0. Connect to DB server production
1. Determine current ControlId and then determine current layout ID
--->

<cfquery name="dbserverlist" 
	  datasource="AppsControl">
		SELECT  DISTINCT DatabaseServer as dbserver
		FROM    ParameterSite
		WHERE   ServerLocation = 'Local'
		AND     ServerRole     IN ('Production','Design')	
		AND     Operational    = 1
		AND     DatabaseServer > ''		
	</cfquery>	
	
<cfset dblist =  ValueList(dbserverlist.dbserver,";")>
	
<cfloop index="dbserver" list="#dblist#" delimiters=";">	
				
	<cfset new = Source.Controlid>
	
	<!--- check destination --->
	
	<cfquery name="ReportExist" 
	  datasource="AppsSystem">
		SELECT  *
		FROM    Ref_ReportControl
		WHERE   ControlId = '#Source.Controlid#' 
		AND ControlId IN
	                 (SELECT ControlId
	                  FROM   [#dbserver#].system.dbo.Ref_ReportControl )
	</cfquery>		
	
	<cfif ReportExist.recordcount eq "0">
	
		<!--- find matching record --->
	
		<cfquery name="ReportExist" 
		  datasource="AppsSystem">
			SELECT  ControlId
			FROM    [#dbserver#].System.dbo.Ref_ReportControl
			WHERE   SystemModule  = '#Source.SystemModule#'
			AND     FunctionClass = '#Source.FunctionClass#'
			AND    (ReportPath    = '#Source.ReportPath#' OR FunctionName = '#Source.FunctionName#')
		</cfquery>
		
		<cfif ReportExist.recordcount eq "0">
					
			<cf_assignId>
			
			<cfquery name="Update" 
				 datasource="AppsSystem">
				 UPDATE   [#dbserver#].System.dbo.Ref_ReportControl
				 SET      ControlId = '#rowguid#' 
				 WHERE    ControlId = '#new#'      
			</cfquery>
			
			<cfset oldid = rowguid>		
				
		<cfelse>
		
			<cfset oldid = reportExist.controlid>
			
		</cfif>	
				
	<cfelse>
	
		<!--- same id is used in destination, hereto we change the id in destination 
		in order to create a temp duplicate --->
		
		<cf_assignId>
		
		<cfquery name="Update" 
			 datasource="AppsSystem">
			 UPDATE   [#dbserver#].System.dbo.Ref_ReportControl
			 SET      ControlId = '#rowguid#' 
			 WHERE    ControlId = '#new#'      
		</cfquery>
		
		<cfset oldid = rowguid>		
	
	</cfif>		
	
	<!--- 2. insert report into operational database --->
						 
	<!--- in order to prevent duplication for reportcontrollayout and output 
	we simply give these records a new id in the source table --->		
	
	<!--- create the menu class --->
	
	<cfquery name="classcheck" 
			datasource="appsSystem">
			SELECT * FROM [#dbserver#].System.dbo.Ref_ReportMenuClass
			WHERE SystemModule = '#Source.SystemModule#'
			AND   MenuClass    = '#Source.MenuClass#'				
	</cfquery>		
		
	<cfif classcheck.recordcount eq "0">
		
		<cfquery name="insertclass" 
			datasource="appsSystem">
			INSERT INTO [#dbserver#].System.dbo.Ref_ReportMenuClass
			(SystemModule,MenuClass,Description)
			VALUES	
			('#Source.SystemModule#','#Source.MenuClass#','#Source.MenuClass#')			
		</cfquery>		
		
	</cfif>
	
	<cfquery name="reset" 
		datasource="appsSystem">
		DELETE FROM [#dbserver#].System.dbo.Ref_ReportControl
		WHERE      SystemModule  = '#Source.SystemModule#'
			AND    FunctionClass = '#Source.FunctionClass#'			
			AND    FunctionName = 'old'
	</cfquery>		
	
	<cftry>
	
		<cfquery name="reset" 
			datasource="appsSystem">
			UPDATE    [#dbserver#].System.dbo.Ref_ReportControl
			SET        FunctionName = 'old', 
			           Operational = '0'
			WHERE      SystemModule  = '#Source.SystemModule#'
				AND    FunctionClass = '#Source.FunctionClass#'
				AND    FunctionName  = '#Source.FunctionName#'
				<!--- DGACM had reports with same path 
				AND    (ReportPath    = '#Source.ReportPath#' OR FunctionName = '#Source.FunctionName#')
				--->
		</cfquery>			
		
		<cfcatch></cfcatch> 
	</cftry>
	
	<cfquery name="reset" 
		datasource="appsSystem">
		UPDATE   [#dbserver#].System.dbo.Ref_ReportControlLayout
		SET      LayoutId  = newid()
		WHERE    ControlId = '#oldid#'
	</cfquery>
	
	<cfquery name="reset" 
		datasource="appsSystem">
		UPDATE   [#dbserver#].System.dbo.Ref_ReportControlOutput
		SET      OutputId  = newid()
		WHERE    ControlId = '#oldid#'
	</cfquery>
	
	<cfset list   = "Ref_ReportControl,Ref_ReportControlCriteria,Ref_ReportControlMemo,Ref_ReportControlCriteriaField,Ref_ReportControlCriteriaList,Ref_ReportControlRole,Ref_ReportControlRoleMission,Ref_ReportControlLayout,Ref_ReportControlLayoutCluster,Ref_ReportControlOutput,Ref_ReportControlUserGroup">
		
	<!--- now we add the info --->		
					 
	<cfloop index="tbl" list="#list#" delimiters=",">
	 
		<cfquery name="tablecontent" 
		datasource="appsSystem">
				SELECT   C.name, C.userType 
			    FROM     SysObjects S, SysColumns C 
				WHERE    S.id = C.id
				AND      S.name = '#tbl#'	
				ORDER BY C.ColId
		</cfquery>
				
		<cfset field = "">
		<cfloop query="tablecontent">
		    <cfset field = "#field#,#name#">
			<cfset last = "#name#">
		</cfloop>
		
		<cfif tbl eq "Ref_ReportControlLayoutCluster">
				
					<cfquery name="Insert" 
					datasource="appsSystem">
					    INSERT INTO  [#dbserver#].System.dbo.#tbl#
						(<cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
						SELECT <cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>
						FROM #tbl#
						WHERE  Layoutid IN (SELECT LayoutId 
						                    FROM   Ref_ReportControlLayout 
											WHERE  ControlId = '#new#')
					</cfquery>
					
		<cfelse>	
		
						
			<cfquery name="insert" 
			 datasource="appsSystem">
					INSERT INTO  [#dbserver#].System.dbo.#tbl#
					(<cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
					SELECT <cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>
					FROM #tbl#
					WHERE    ControlId = '#new#'	
					<cfif tbl eq "Ref_ReportControlRole">
					AND Role IN (SELECT Role FROM [#dbserver#].Organization.dbo.Ref_AuthorizationRole)
					</cfif>		
					<cfif tbl eq "Ref_ReportControlUserGroup">
					AND Account IN (SELECT Account FROM [#dbserver#].System.dbo.UserNames)
					</cfif>													
			</cfquery>
		
		</cfif>
		
		<cfif tbl eq "Ref_ReportControl">
		
			<cfquery name="insert" 
			 datasource="appsSystem">
			 UPDATE   [#dbserver#].System.dbo.Ref_ReportControl
			 SET      ReportRoot = 
					 <cfif source.reportRoot eq "Application">
			 			'Application',
					<cfelse>
						'Report',
					</cfif>
			          OfficerUserId = '#SESSION.acc#',
					  OfficerFirstName = '#SESSION.first#',
					  OfficerLastName = '#SESSION.last#',
					  Created         = getDate()			 
			 WHERE    ControlId = '#new#'			 
			 </cfquery>
		
		</cfif>
		
		<cfif tbl eq "Ref_ReportControlRole" 
		   or tbl eq "Ref_ReportControlUserGroup">
		
			<cfquery name="Add" 
			  datasource="AppsSystem">
				INSERT INTO  [#dbserver#].System.dbo.#tbl#
					(<cfloop query="tablecontent">#name#<cfif currentRow neq recordcount>,</cfif></cfloop>)
					SELECT <cfloop query="tablecontent">
					<cfif name eq "ControlId">'#new#'<cfelse>#name#</cfif><cfif currentRow neq recordcount>,</cfif></cfloop>
					FROM [#dbserver#].System.dbo.#tbl#
					WHERE    ControlId = '#oldid#'	
					<cfif tbl eq "Ref_ReportControlRole">
					AND Role NOT IN (SELECT Role 
					                 FROM [#dbserver#].System.dbo.#tbl# 
									 WHERE ControlId = '#new#')
					</cfif>		
					<cfif tbl eq "Ref_ReportControlUserGroup">
					AND Account NOT IN (SELECT Account 
					                FROM [#dbserver#].System.dbo.#tbl# 
									WHERE ControlId = '#new#')
					</cfif>			      
			</cfquery>		
		
		</cfif>
		
	</cfloop>
	
	<!--- 3. Determine mapping for history and subscription --->
	
	<cfif reportExist.recordcount eq "1">	
	
		<cfquery name="Mapping" 
		  datasource="AppsSystem">
			SELECT    N.ControlId, 
			          N.LayoutId, 
					  N.LayOutCode, 
		    	      O.ControlId AS ControlCurrent, 
					  O.LayoutId  AS LayoutCurrent, 
					  O.LayOutCode AS LayoutCodeCurrent
			FROM      Ref_ReportControlLayout N INNER JOIN
	        	      [#dbserver#].System.dbo.Ref_ReportControlLayout O ON N.LayOutCode = O.LayOutCode COLLATE SQL_Latin1_General_CP1_CI_AS
			WHERE    (N.ControlId = '#new#') 
			AND      (O.ControlId = '#oldid#')
		</cfquery>
	
		<!--- 3a. Update UserReport : LayoutId mapping --->
		<!--- 3b. Update UserReport distribution : ControlId  --->
		
		<cfset srv = dbserver>
	
		<cfloop query="Mapping">
	
			<cfif layoutcurrent neq layoutid>
		
				<cfquery name="Update" 
				  datasource="AppsSystem">
					UPDATE    [#srv#].System.dbo.UserReport
					SET       LayoutId = '#LayoutId#'
					WHERE LayoutId = '#LayoutCurrent#'      
				</cfquery>
			
			</cfif>
			
			<cfif controlid neq controlid>
			
				<cfquery name="Update" 
				  datasource="AppsSystem">
					UPDATE    [#srv#].System.dbo.UserReportDistribution
					SET       ControlId = '#ControlId#'
					WHERE ControlId = '#ControlCurrent#'      
				</cfquery>
			
			</cfif>
						
		</cfloop>	
				
		<!--- 4. Remove old report --->
	
		<cfquery name="Delete" 
		  datasource="AppsSystem">
			DELETE FROM [#dbserver#].System.dbo.Ref_ReportControl
			WHERE ControlId = '#oldid#'      
		</cfquery>
		
	</cfif>	
	
	<!---
	10. copy code from dev to production servers
	--->
	
</cfloop>

<cfif source.reportRoot eq "Application">
	
	<cfquery name="appserverlist" 
		  datasource="AppsControl">
			SELECT  DISTINCT SourcePath as DestinationPath
			FROM    ParameterSite
			WHERE   ServerLocation = 'Local'
			AND     ServerRole     IN ('Production','Design')	
			AND     Operational    = 1
			AND     Sourcepath > ''		
	</cfquery>	

<cfelse>
	
	<cfquery name="appserverlist" 
		  datasource="AppsControl">
			SELECT  DISTINCT ReportPath as DestinationPath
			FROM    ParameterSite
			WHERE   ServerLocation = 'Local'
			AND     ServerRole     IN ('Production','Design')	
			AND     Operational    = 1
			AND     Sourcepath > ''		
	</cfquery>	

</cfif>

<cfloop query="appserverlist">

	<!--- 1. remove directory on destination 
    	  2. copy directory from source
    --->	
	
	<cfif source.reportPath neq "">
	
		<cftry>
		
		<cfif directoryExists("#DestinationPath#/#Source.ReportPath#")>
			<cfdirectory action="DELETE" 
			    directory="#DestinationPath#/#Source.ReportPath#" 
				recurse="Yes">
		</cfif>
		
		<cfdirectory action="CREATE" directory="#DestinationPath#\#Source.ReportPath#">
			
		<cfif Source.ReportRoot eq "Application">
			<cfset rootpath  = "#SESSION.rootpath#">
		<cfelse>
			<cfset rootpath  = "#SESSION.rootReportPath#">			
		</cfif>
			    
		<cfdirectory action="LIST"
		        directory="#rootPath#/#Source.ReportPath#"
				type="File"
	            name="get">		
		
		
		<cfloop query="get">	
				<cffile action="COPY"
		        source="#RootPath#/#Source.ReportPath#/#Name#"
		        destination="#appserverlist.DestinationPath#/#Source.ReportPath#\">
		</cfloop>
		
		<cfcatch>
		
			<cfoutput>
				<script>
					alert("Deployment Interrupted. No access granted to #DestinationPath# #Source.ReportPath# #cfcatch.message#   Please check if the ColdFusion instance of the QA server has access to the destination Production server ")					
				</script>
				<font color="FF0000">Deployment Interrupted. &nbsp;&nbsp;</font>
				<cfabort>
			</cfoutput>
	
		</cfcatch>
		</cftry>
	
	</cfif>

</cfloop>
