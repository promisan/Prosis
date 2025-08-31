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
<cfparam name="FileNo" default="">
<cfparam name="Table1" default="">
<cfparam name="Table2" default="">
<cfparam name="Table3" default="">
<cfparam name="Table4" default="">
<cfparam name="Table5" default="">
<cfparam name="Table6" default="">
<cfparam name="Table7" default="">
<cfparam name="Table8" default="">
<cfparam name="Table9" default="">
<cfparam name="filter" default="">

<cfparam name="url.format" default="Excel">
<cfparam name="url.data" default="0">
<cfparam name="url.header" default="0">

<cfquery name="Report" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *     
	FROM      Ref_ReportControl R
    WHERE     ControlId = '#URL.ControlId#' 
</cfquery>

<cfoutput>

<cfif URL.Format eq "Analyse">

	<cfif url.header eq "1">
		<cfset html = "Yes">
	<cfelse>
	    <cfset html = "No">
	</cfif>
	
	<cf_screentop height="100%" html="#html#" label="#Report.FunctionName#" layout="webapp" banner="Gray" bannerforce="Yes" jquery="Yes">
		
	<cfif URL.Data eq "1">
		
		<!--- performs the facttable query that also assigns variable table1, table2, table3 used for the output --->			
		<cfinclude template="../../#Report.ReportPath#">		
	
	</cfif>	
	
	<cfparam name="url.header" default="0">
	<cf_systemscript>
		
	<iframe src="#SESSION.root#/Tools/CFReport/Analysis/SelectSource.cfm?ControlId=#controlId#&header=#url.header#&mid=#url.mid#" width="100%" height="100%" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe>
	
	<!---
	
	<script language="JavaScript">			    
		ptoken.location("#SESSION.root#/Tools/CFReport/Analysis/SelectSource.cfm?ControlId=#controlId#&header=#url.header#")		
	</script>
	
	--->

<cfelseif URL.Format eq "Excel">

	<cf_screentop height="100%" html="No" label="#Report.FunctionName#" layout="webapp" banner="Gray" jquery="Yes">
			
	<cfif URL.Data eq "1">	
	 
		<!--- performs the facttable query that also assigns variable table1, table2, table3 --->			
		<cfinclude template="../../#Report.ReportPath#">			
		
	</cfif>		
	
	<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   
						
	<iframe src="#SESSION.root#/Tools/CFReport/ExcelFormat/FormatExcel.cfm?ControlId=#controlId#&table1=#table1#&table2=#table2#&table3=#table3#&table4=#table4#&table5=#table5#&mid=#mid#" width="100%" height="100%" marginwidth="0" marginheight="0" scrolling="no" frameborder="0"></iframe>
	
			
<cfelse>

	<cfinclude template="../../#Report.ReportPath#">		
		
</cfif>
		
</cfoutput>

</body>

