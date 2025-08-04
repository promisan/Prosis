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

<cf_wait1 text="Preparing Excel file" icon="clock" flush="yes">

<cf_screentop height="100%" title="Excel" html="No">

<cfparam name= "id"     default="#URL.Id#">
<cfparam name= "tbl"    default="">
<cfparam name= "type"   default="#URL.tpe#">
<cfparam name= "mode"   default="#URL.mode#">

<cfquery name="Output" 
	datasource="appsSystem">
	SELECT    Pvt.ControlId, 
	          Pvt.DataSource, 
			  Pvt.TableName, 
			  Rpt.OutputName
    FROM      UserPivot Pvt INNER JOIN
              Ref_ReportControlOutput Rpt ON Pvt.OutputId = Rpt.OutputId
    WHERE     Pvt.ControlId = '#id#'
</cfquery>	

<cfif tbl eq "">
 <cfset tbl = "#Output.TableName#">
</cfif>

<body onLoad="window.focus()">

<cfset attach = "">

<cfif tpe eq "CrossTabdata">
		
		<cfset ord  = "">		
		<cfset fil  = "">
		<cfset grp1 = "">
		<cfset grp2 = "">
				
		<!--- apply the filter --->			
		
		<!--- end application of the filter --->

		<cfquery name="Fields" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT FieldName, 
				       Presentation, 
					   PresentationOrder,
					   FieldDataType
				FROM   UserPivotDetail
				WHERE  ControlId    = '#Id#'
				AND    Presentation != 'Details'
				AND    Presentation NOT LIKE 'Graph%' and Presentation NOT LIKE 'Drill%'
				ORDER BY PresentationOrder
			</cfquery>			
			
			<cfset col = ArrayNew(2)>
			
			<cfoutput query="Fields">
			
			    <!--- fields --->
				<cfset fln    = "">
				<!--- read the crosstab table and correct entries --->
				<cfset flN    = "#replaceNoCase(Presentation,'-','')#">
				
				<cfif find("Formula", "#Presentation#")>
				
				   <cfset flN    = "#replaceNoCase(flN,'Formula','CellValue')#">
				   
				   <cfquery name="Formula" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT DISTINCT FieldValue 
					FROM   UserPivotDetail
					WHERE  ControlId    = '#Id#'
					AND    Presentation = '#Fields.Presentation#' 
				   </cfquery>
				   
				   <cfset col[currentrow][1] = "#flN#">
				   <cfset col[currentrow][2] = "integer">						
				   <cfset col[currentrow][3] = FieldName>
				   <cfset col[currentrow][4] = "">
				   <cfset col[currentrow][5] = "SUM(#flN#) as #FieldName#">
					
				   <cfif FieldName eq "#grp1#" or FieldName eq "#grp2#">
						<cfset col[currentrow][6] = "group">
				   <cfelse>
						<cfset col[currentrow][6] = "show">
				   </cfif>				 
												   
				 <cfelse>
				 
				   <cfset col[currentrow][1] = "#flN#">
				   <cfset col[currentrow][2] = "varchar">						
				   <cfset col[currentrow][3] = FieldName>
				   <cfset col[currentrow][4] = "">
				   <cfset col[currentrow][5] = FieldName>
					
				   <cfif FieldName eq "#grp1#" or FieldName eq "#grp2#">
						<cfset col[currentrow][6] = "group">
				   <cfelse>
						<cfset col[currentrow][6] = "show">
				   </cfif>				
				 				   
				 </cfif> 
								
				<cfif grp1 eq "">			 	 
					<cfset grp1 = "#Fln#">				
				</cfif>	
											
				<cfset ord = "">
				 									   
			</cfoutput>
						
			
			<cfsavecontent variable="xlsquery">
		
				<cfoutput>			
					FROM    #tbl#_#type#
					WHERE   1 = 1
					<!---
					AND    #preservesinglequotes(criteria)# 
					--->
					<cfif ord neq "">
					ORDER BY #ord#
					</cfif>
				</cfoutput>	
				
		   </cfsavecontent>
		   
		   
			
<cfelse>
		
		<!--- set Grouping 1 fields --->
		
		<cfset fil = "">
		
		<cfquery name="Group1" 
			datasource="appsSystem">
			SELECT   TOP 1 *
		    FROM     UserPivotDimension
			WHERE    ControlId    = '#Id#'
			AND      Presentation = 'Y-ax' 
		</cfquery>
		
		<cfif Group1.recordcount eq "0">
		
			<cf_waitEnd Frm="result">
			<br>
			<cf_message message="Problem, you must define one grouping" return="No">
			<cfabort>
		
		</cfif>
		
		<cfset grp1 = "#Group1.FieldName#">
		
		<cfquery name="Group2" 
			datasource="appsSystem">
			SELECT   TOP 1 *
		    FROM     UserPivotDimension
			WHERE    ControlId    = '#Id#'
			AND      Presentation = 'Grouping1'
		</cfquery>
		
		<cfset grp2 = "#Group2.FieldName#">
				
		<!---
		
		<cfquery name="OrderBy" 
			datasource="appsSystem">
			SELECT   TOP 1 *
		    FROM     UserPivotDetail
			WHERE    OutputId = '#URL.Id#'
			AND      OutputClass LIKE 'Sort%'
		</cfquery>
		
		--->
		
		<cfset ord = "">
		
		<!---
		<cfloop query = "OrderBy">
						
				 <cfif #ord# eq "">
				    <cfset ord="#OrderBy.FieldName#">
				 <cfelse>
				    <cfset ord="#fld#,#OrderBy.FieldName#"> 	
				 </cfif>
		
		</cfloop>
		--->
		
		<!--- table for fieldorder--->
		
		<cfset col = ArrayNew(2)>
								
		<cfquery name="Fields" 
			datasource="#Output.DataSource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT c.name, c.xtype as type
			FROM      sysobjects S INNER JOIN
                      syscolumns C ON S.id = C.id INNER JOIN
                      systypes T ON C.xtype = T.xtype 
			WHERE     S.name = '#tbl#_#type#' 
			ORDER BY S.name, C.colid  
		</cfquery>
			
		<cfloop query="Fields">
		
			<cfset col[currentrow][1] = name>
			<cfif type eq "61">
				<cfset col[currentrow][2] = "datetime">				
			<cfelseif type eq "56">
				<cfset col[currentrow][2] = "integer">
			<cfelseif type eq "62">
				<cfset col[currentrow][2] = "numeric">
			<cfelse>
				<cfset col[currentrow][2] = "varchar">
			</cfif>			
			
			<cfset col[currentrow][3] = name>
			<cfset col[currentrow][4] = "">
			
			<cfif type eq "62">
			
				<cfset col[currentrow][5] = "SUM(#name#) as #name#">
										
			<cfelse>
			
				<cfset col[currentrow][5] = name>
			
			</cfif>	
			
			<cfif name eq "#grp1#" or Name eq "#grp2#">
					<cfset col[currentrow][6] = "group">
			<cfelse>
					<cfset col[currentrow][6] = "show">
			</cfif>				 
			 
		</cfloop>
				
		<cfsavecontent variable="xlsquery">
		<cfoutput>			
			FROM    #tbl#_#type#
			WHERE   1 = 1
			<!---
			AND    #preservesinglequotes(criteria)# 
			--->
			<cfif ord neq "">
			ORDER BY #ord#
			</cfif>
		</cfoutput>	
	   </cfsavecontent>
		
</cfif>	

<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\")>

	   <cfdirectory 
	     action="CREATE" 
         directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">

</cfif>
	
<cfset FileNo = round(Rand()*10)>
		
<cfset fileName = replace("#Output.OutputName#"," ","_","ALL")>
<cfset fileName = replace("#fileName#","\","","ALL")>

<cfset fileName = "#fileName#_#fileNo#"> 

<cfif attach neq "">
  <cfset attach = "#attach#,#FileName#.xls">
<cfelse>
  <cfset attach = "#FileName#.xls">  
</cfif>

<cfinvoke component = "Service.Excel.Excel"  
   method           = "ExcelTable" 
   datasource       = "#Output.DataSource#"
   cols             = "#col#"  <!--- array with fieldname, format, label, formula --->
   dataquery        = "#xlsquery#"
   GroupByOne       = "#grp1#"
   GroupByTwo       = "#grp2#"   
   filename         = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#FileName#.xls" 
   filenamepreview  = "#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\#FileName#_Preview.xls" 
   sheetname        = "#filename#"
   rowstart         = "2"
   returnvariable   = "excel">	
   	
   <cf_waitEnd>	
			
   <cfoutput>
	<cfset ts = timeFormat(now(),"MMSS")>										
	<script language="JavaScript">
	   	window.location = "#SESSION.root#/cfrstage/user/#SESSION.acc#/#FileName#.xls?ts=#ts#"
	</script>	
	</cfoutput>	