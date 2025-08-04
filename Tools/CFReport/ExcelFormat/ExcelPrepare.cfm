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
<cf_screentop jquery="Yes" html="no">

<!----- JM: Added on 02/02/2010 for Evelyn's purpose ------>
<cfsetting requesttimeout="1000">

<cfparam name="URL.Id"           default="{4484FFD9-0AE7-4933-B972-0AAA1F456E32}">
<cfparam name="URL.tbl"          default="">
<cfparam name="URL.acc"          default="#SESSION.acc#">
<cfparam name="URL.Status"       default="1">
<cfparam name="client.PvtRecord" default="8000">
<cfset attach = "">
<!--- changed to xlsx 
<cfset vMaxRowsAllowed = 65535>
--->
<cfset vMaxRowsAllowed = 65535>


<cfquery name="Output" 
	datasource="appsSystem">
	SELECT   *
    FROM     Ref_ReportControlOutput
	WHERE    OutputId = '#URL.ID#'
</cfquery>

<cfquery name="Group1" 
	datasource="appsSystem">
	SELECT   TOP 1 *
    FROM     UserReportOutput
	WHERE    UserAccount = '#URL.acc#'
	AND      OutputId    = '#URL.Id#'
	AND      OutputClass = 'Group1'
</cfquery>

<cfquery name="Group2" 
	datasource="appsSystem">
	SELECT   TOP 1 *
    FROM     UserReportOutput
	WHERE    UserAccount = '#URL.acc#'
	AND      OutputId    = '#URL.Id#'
	AND      OutputClass = 'Group2'
</cfquery>

<cfquery name="OrderBy" 
	datasource="appsSystem">
	SELECT   *
    FROM     UserReportOutput
	WHERE    UserAccount = '#URL.acc#'
	AND      OutputId    = '#URL.Id#'
	AND      OutputClass = 'Detail'
	AND      OutputSorting IN ('ASC','DESC') 
	AND      OutputShow = 1
	ORDER BY FieldNameOrder
</cfquery>

<cfset ord = "">

<cfloop query = "OrderBy">
				
	 <cfif ord eq "">
	    <cfset ord="#FieldName# #OutputSorting#">
	 <cfelse>
	    <cfset ord="#ord#,#FieldName# #OutputSorting#"> 	
	 </cfif>

</cfloop>

<cfquery name="OutputFields" 
	datasource="appsSystem">
	SELECT   *
    FROM     UserReportOutput
	WHERE    UserAccount = '#URL.acc#'
	AND      OutputId = '#URL.Id#'
	AND      OutputClass = 'Detail'
	AND      OutputShow = 1
	ORDER BY FieldNameOrder
</cfquery>

<cfset fld = "">
<cfset col = ArrayNew(2)>

<cfloop query = "OutputFields">
	
	<cfset col[currentrow][1] = fieldname>
	<cfset col[currentrow][2] = outputformat>
	<cfset col[currentrow][3] = outputheader>
	<cfset col[currentrow][4] = groupformula>
	<cfif outputformat eq "numeric">
	
		<cfset col[currentrow][5] = "SUM(#fieldname#) as #fieldname#">
				
	<cfelse>
	
		<cfset col[currentrow][5] = fieldname>
	
	</cfif>	
	
	<cfif fieldname eq "#Group1.FieldName#" or fieldName eq "#Group2.FieldName#">
			<cfset col[currentrow][6] = "group">
	<cfelse>
			<cfset col[currentrow][6] = "show">
	</cfif>
					 
</cfloop>

<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFRStage\User\#URL.acc#\")>

	   <cfdirectory 
	     action="CREATE" 
         directory="#SESSION.rootDocumentPath#\CFRStage\User\#URL.acc#\">

</cfif>
		
<cfset fileName = replace("#Output.OutputName#"," ","_","ALL")>
<cfset fileName = replace("#fileName#","\","","ALL")>
<cfset fileName = replace("#fileName#","/","","ALL")>
<cfif attach neq "">
  <cfset attach = "#attach#,#FileName#.xlsx">
<cfelse>
  <cfset attach = "#FileName#.xlsx">  
</cfif>

<cfquery name="Filter" 
	datasource="appsSystem">
	SELECT   *
    FROM     UserReportOutput
	WHERE    UserAccount   = '#URL.acc#'
	AND      OutputId      = '#URL.Id#'
	AND      OutputClass LIKE 'Filter%'	
	AND      FieldName     IN (SELECT FieldName 
	                           FROM   UserReportOutput 
							   WHERE  OutputId = '#url.id#' 
							   AND    OutputClass = 'Detail')
</cfquery>

<!--- --------- --->
<!--- filtering --->
<!--- --------- --->

<CFSET Criteria = ''>

<cfloop query="Filter">

	<CF_Search_AppendCriteria
	    FieldName = "#FieldName#"
	    FieldType = "#FilterType#"
	    Operator  = "#FilterOperator#"
	    Value     = "#FilterValue#">
	
</cfloop>

<cfif criteria neq "">

    <cfsavecontent variable="xlsquery">
		<cfoutput>			
			FROM   #URL.Tbl#
			WHERE   1 = 1
			AND    #preservesinglequotes(criteria)#
			<cfif ord neq "">
			ORDER BY #ord#
			</cfif>
		</cfoutput>	
	</cfsavecontent>
	
<cfelse>

	<cfsavecontent variable="xlsquery">
		<cfoutput>						
			FROM   #URL.Tbl#	
			<cfif ord neq "">					
			ORDER BY #ord#
			</cfif>
		</cfoutput>	
	</cfsavecontent>

</cfif>


<!--- to be done --->

<cfquery name="Aggregate" 
	datasource="appsSystem">
	SELECT   *
    FROM     UserReportOutput
	WHERE    UserAccount = '#URL.acc#'
	AND      OutputId    = '#URL.Id#'
	AND      OutputClass = 'Aggregate'	
</cfquery>

<cfif Aggregate.recordcount eq "1">

	<cfset grp = "">
	
	<cfloop index="x" from="1" to="#ArrayLen(col)#">
			
		    <cfif x eq "1">
			    <cfset sel = "#col[x][5]#">
			<cfelse>
				<cfset sel = "#sel#,#col[x][5]#">
			</cfif>	
						
			<cfif col[x][2] neq "numeric">
			    <cfset grp = "#col[x][1]#">			
			</cfif>	
		
		</cfloop>		

    <cftry>

		<CF_DropTable dbName="#Output.DataSource#" full="1" tblName="#URL.Tbl#_agg"> 
	
		<cfquery name="Aggregate" 
		datasource="#Output.DataSource#">
			SELECT DISTINCT #sel#, count(*) as Counted 
			INTO #URL.Tbl#_agg
			FROM #URL.Tbl# 
			GROUP BY #grp#
			<cfif ord neq "">					
			ORDER BY #ord#
			</cfif>
		</cfquery>
		
		<cfset no = Outputfields.recordcount+1>
		
		<cfset col[no][1] = "Counted">
		<cfset col[no][2] = "Integer">
		<cfset col[no][3] = "Counted">
		<cfset col[no][4] = "Sum">
		<cfset col[no][5] = "Counted">	
		
		<cfsavecontent variable="xlsquery">
			<cfoutput>						
				FROM   #URL.Tbl#_agg				
			</cfoutput>	
		</cfsavecontent>
			
		<cfcatch></cfcatch>
	
	</cftry>
	
</cfif>

<!--- ----------------------- --->
<!--- generate the excel file --->
<!--- ----------------------- --->

<cfquery name="qValidateRecordCount" 
	datasource="#Output.DataSource#">
		SELECT 	*
		#preserveSingleQuotes(xlsquery)#
</cfquery>

<cfif qValidateRecordCount.recordCount gt vMaxRowsAllowed>
	<cf_tl id="Operation not allowed." var="lblMaxRecError1">
	<cf_tl id="The maximum number of records allowed is" var="lblMaxRecError2">
	<cf_tl id="Please narrow your results and try again." var="lblMaxRecError3">
	<cfoutput>
		<script>
			alert('#lblMaxRecError1#\n\n#lblMaxRecError2# #numberFormat(vMaxRowsAllowed, ",")#.\n\n#lblMaxRecError3#');
		</script>
	</cfoutput>
	<cfabort>
</cfif>


<cfset xlsformat = "xlsx">

<cfif qValidateRecordCount.recordCount lte 25000>

	<cfset batch = 0>	
		
	<cfinvoke component = "Service.Excel.Excel"  
	   method           = "ExcelTable" 
	   datasource       = "#Output.DataSource#"
	   cols             = "#col#"  <!--- array with fieldname, format, label, formula --->
	   format           = "#xlsformat#"
	   dataquery        = "#xlsquery#"
	   GroupByOne       = "#Group1.FieldName#"
	   GroupByTwo       = "#Group2.FieldName#"   
	   filename         = "#SESSION.rootDocumentPath#\CFRStage\User\#URL.acc#\#FileName#.#xlsformat#" 
	   filenamepreview  = "#SESSION.rootDocumentPath#\CFRStage\User\#URL.acc#\#FileName#_Preview.#xlsformat#" 
	   sheetname        = "#filename#"
	   rowstart         = "2"
	   returnvariable   = "excel">	

<cfelse>

	<cfset batch = 1>

	<cfsavecontent variable="xlsquery">
		<cfoutput>						
			FROM   #URL.Tbl#	
		</cfoutput>	
	</cfsavecontent>
		
	<cfset filename = "#filename#_#left(createUUID(),5)#">
	
	<cfinvoke component = "Service.Excel.Excel"  
	   method           = "DumpExcelTable" 
	   datasource       = "#Output.DataSource#"
	   dataquery        = "#xlsquery#"
	   cols             = "#col#" 
	   filename         = "#SESSION.rootDocumentPath#\CFRStage\User\#URL.acc#\#FileName#.#xlsformat#" 
	   sheetname        = "#filename#"
	   returnvariable   = "excel">

</cfif>
       

<cfif status neq "9">

	<cfif URL.Mode eq "View">
		
		<cfoutput>
		<cfset ts = timeFormat(now(),"MMSS")>
		
		<script language="JavaScript">	
		    <!--- expand and collapse --->	
			// document.getElementById('mainmenu').className = "regular"		
			// document.getElementById('menu2').click()			  
			<!--- open the excel file --->
			
			<cfif batch eq 0>
				ptoken.open("#SESSION.root#/cfrstage/getFile.cfm?file=#FileName#_Preview.#xlsformat#","_blank") 
			<cfelse>
				ptoken.open("#SESSION.root#/cfrstage/getFile.cfm?file=#FileName#.#xlsformat#","_blank") 
			</cfif>
			
			<!--- show menu --->
			// ColdFusion.navigate('#SESSION.root#/tools/cfreport/ExcelFormat/ExcelMenu.cfm?id=#url.id#&table=#filename#','excelmenu')
		</script>	
		
		</cfoutput>			
		
	<cfelseif URL.Status eq "5">
	
		<cfoutput>
		<script language="JavaScript">			
			ProsisUI.createWindow('maildialog', 'Mail Excel', '',{x:100,y:100,height:665,width:890,resizable:false,modal:true,center:true});
			ptoken.navigate('#SESSION.root#/tools/cfreport/ExcelFormat/FormatExcelmail.cfm?ID1=Extracts&ID2=#FileName#.#xlsformat#&Source=ReportExcel&Sourceid=#URL.ID#&Mode=cfwindow&GUI=HTML','maildialog')				
	    </script>	
		</cfoutput>		
		
	<cfelse>
	
		<cfoutput>
		<script language="JavaScript">		   
		   ProsisUI.createWindow('maildialog', 'Mail Excel', '',{x:100,y:100,height:665,width:890,resizable:false,modal:true,center:true});
		   ptoken.navigate('#SESSION.root#/tools/cfreport/ExcelFormat/FormatExcelmail.cfm?ID1=Extracts&ID2=#FileName#.#xlsformat#&Source=ReportExcel&Sourceid=#URL.ID#&Mode=cfwindow&GUI=HTML','maildialog')				
		</script>	
		</cfoutput>	
	
	</cfif>

</cfif>
	

