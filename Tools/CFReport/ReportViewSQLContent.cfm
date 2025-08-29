<!--
    Copyright Â© 2025 Promisan B.V.

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
 <cfquery name="UserReport" 
     datasource="AppsSystem" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControl
	 WHERE  ControlId = '#url.Id#'
	</cfquery>

	<cfif UserReport.ReportRoot eq "Application">
		
			<cfinvoke component="Service.Presentation.ColorCode"  
			   method="colorfile" lineNumbers="#url.format#"
			   filename="#SESSION.rootpath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#" 
			   returnvariable="result">			
	           <cfset result = replace(result, "Â", "", "all") />
				   				  
	<cfelse>
		
		<cfinvoke component="Service.Presentation.ColorCode"  
			   method="colorfile" linenumbers="#url.format#"
			   filename="#SESSION.rootReportPath#\#UserReport.ReportPath#\#UserReport.TemplateSQL#" 
			   returnvariable="result">			
	           <cfset result = replace(result, "Â", "", "all") />
			
	</cfif>		   
		
	<table width="100%" height="100%" align="center">
	<tr><td class="labelit"> 
	
		<cfoutput> 
				
			<font face="Courier"  style="font: 10px;">
				#RESULT#
			</font>

	    </cfoutput>	
				
	</td></tr>    
	</table>