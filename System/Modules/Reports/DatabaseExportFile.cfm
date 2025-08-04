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
<cfparam name="URL.mode" default="Export">
<cfparam name="URL.execute" default="No">


<HTML>
<HEAD>
<TITLE>Report definition - database script
</TITLE>

<cfif URL.Execute eq "Yes">
	<style type="text/css">

	td.message_blue
	{
			font-family:"Verdana",Times,serif;
			font-size : 7.5pt;
			font-weight:bold;
			color: blue;
	}
		
	td.message_red
	{
			font-family:"Verdana",Times,serif;
			font-size : 7.5pt;
			font-weight:bold;
			color: red;
	}
	
</style>

</cfif>

</HEAD>
<body leftmargin="0" topmargin="0" rightmargin="0" bgcolor="FfFfFf" onLoad="window.focus()">



<cfif URL.Mode eq "Replica">
	<cf_assignId>
	<cfset vNewControlId = rowguid>	
</cfif>

<cfsavecontent variable="sqlscript">

<cfset list   = "Ref_ReportControl,Ref_ReportControlCriteria,Ref_ReportControlCriteriaField,Ref_ReportControlCriteriaList,Ref_ReportControlLayout,Ref_ReportControlRole,Ref_ReportControlOutput">



 <cfquery name="report" 
 	 datasource="appsSystem">
		   SELECT   * 
		   FROM     Ref_ReportControl 
		   WHERE    ControlId = '#URL.ID#'
    </cfquery>

<!---	disabled May 2009
<cfoutput>
UPDATE System.dbo.Ref_ReportControl
	SET FunctionName = FunctionName+'_old'
	WHERE SystemModule  = '#Report.SystemModule#'
	AND   FunctionClass = '#Report.FunctionClass#'
	AND   FunctionName  = '#Report.FunctionName#'
	AND   MenuClass     = '#Report.MenuClass#'
</cfoutput>	
--->
<cfif URL.Mode eq "Export">
--- <b>Reset old report</b> <BR>

<cfoutput>
    DELETE FROM System.dbo.Ref_ReportControl
	WHERE SystemModule  = '#Report.SystemModule#'
	AND   FunctionClass = '#Report.FunctionClass#'
	AND   FunctionName  = '#Report.FunctionName#'
	AND   MenuClass     = '#Report.MenuClass#'
</cfoutput>
</cfif>
				 
<cfloop index="tbl" list="#list#" delimiters=",">

    --- <cfoutput><b>#tbl#</b></cfoutput> <BR>
	
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
	
    <cfquery name="content" 
 	 datasource="appsSystem">
		   SELECT   * 
		   FROM     #tbl# 
		   WHERE    ControlId = '#URL.ID#'
    </cfquery>
	
	<cfif content.recordcount gte "1">

	    <cfoutput query="Content">
		
		--- <b>rec: #currentRow#</b> <BR>
			
			INSERT INTO System.dbo.#tbl#
			(<cfloop query="tablecontent">#name#<cfif #currentRow# neq #recordcount#>,</cfif></cfloop>)
			VALUES (			
			<cfloop index="nme" list="#field#" delimiters=",">
			<cfif evaluate(nme) eq "">			
				<cfquery name="check" dbtype="query">
				SELECT   userType 
			    FROM     TableContent
				WHERE    name = '#nme#'	
				</cfquery>				
				<cfif check.userType eq "0">NULL<cfelse>''</cfif><cfif last neq nme>,</cfif>			
			<cfelse>	
			    <cfset val = "#evaluate(nme)#">
				<cfset val = replace(val,  "'",  "''" ,  "ALL")> 
				
				<cfswitch expression="#URL.mode#">
				<cfcase value="Replica">
						<cfif Find('Id',nme) neq 0 and Find('Parent',nme) neq 0>
							<!--- Example ControlIdParent, and LayoutIdParent --->
							NULL
						<cfelseif nme eq "ControlId">	
							'#vNewControlId#'
						<cfelseif Find('Id',nme) neq 0 and nme neq "OfficerUserId">
							<cf_assignId>
							<cfset vNewId = rowguid>				
							'#vNewId#'
						<cfelseif Find('FunctionName',nme) neq 0>
							'#val#(replica)'
						<cfelseif Find ('ReportPath',nme) neq 0 >
								'#Left(val,Len(val)-1)#(replica)\'
						<cfelseif Find('Operational',nme) neq 0 and tbl eq "Ref_ReportControl">
							'0'					
						<cfelse>
							   '#val#'
						</cfif>
				</cfcase>
				<cfcase value="Export">
						'#val#'
				</cfcase>
				</cfswitch>
				
			   <cfif last neq nme>,</cfif>
			</cfif>
			
			</cfloop>)
			
			--- <Br>
								
	    </cfoutput>
	
	<cfelse>	
	--- No records	
	</cfif>
	

</cfloop>

</cfsavecontent>


<cfif report.reportRoot eq "Report">

    <cftry>
	<cffile action="DELETE" file="#SESSION.rootReportpath#\#report.reportPath#\dbscript.txt">
		<cfcatch></cfcatch>
	</cftry>
	<cftry>
	<cffile action="WRITE" file="#SESSION.rootReportPath#\#report.reportPath#\dbscript.txt" output="#sqlscript#">
	<cfcatch>
	<cf_message message="Could not write script to file. Directory (#report.reportPath#) does not exist">
	</cfcatch>
	</cftry>
	
<cfelse>

	<cftry>
	<cffile action="DELETE" file="#SESSION.rootpath#\#report.reportPath#\dbscript.txt">
		<cfcatch></cfcatch>
	</cftry>
	<cftry>
	<cffile action="WRITE" file="#SESSION.rootpath#\#report.reportPath#\dbscript.txt" output="#sqlscript#">
	<cfcatch>
	<cf_message message="Could not save script to file. Directory (#report.reportPath#) does not exist">
	</cfcatch>
	</cftry>
	
</cfif>	
	
<cfif URL.Execute eq "No" or URL.Mode eq "Export">
	<cfoutput>
		#sqlscript#
	</cfoutput>					

	
<cfelse>
	<cfoutput>
	<cftry>

			<cfquery name="ExecuteScript" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				#PreserveSingleQuotes(sqlscript)#
			</cfquery>

			<table width="100%">
				<tr valign="center">
					<td align="Center" class="message_blue" height="100">
					Script for #URL.mode# operation has been sucessfully executed
					</td>
				</tr>
				<tr valign="center">
					<td align="Center" class="message_blue" height="100">
					<img src="#SESSION.root#/Images/approval.gif">
					</td>
				</tr>				
			</table>
	
	
	<cfcatch>
			<table width="100%">
				<tr>
					<td align="center "class="message_red">An error has ocurred with the generated script</td>
				</tr>
				<tr>
					<td align="center" class="message_red">
					#CFCatch.Message# - #CFCATCH.Detail#
					</td>
				</tr>	
				<tr>
					<td align="center">
						<img src="#SESSION.root#/Images/attention1.gif">
					</td>
				</tr>
			</table>
	</cfcatch>					
	</cftry>	
	</cfoutput>		

</cfif>

</BODY>