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
<cfparam name="url.idmenu" default="">

<!--- url.idmenu was set with url.id because in case of reports there is no systemFunctionId, only a controlId that comes in url.id --->
<cfif url.idmenu eq "">
	<cfset url.idmenu = url.id>
</cfif>

<cfparam name="CLIENT.reportview" default="">
<cfset URL.ID = "#Replace(URL.ID," ","","ALL")#"> 

<cfquery name="Line" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ReportControl L
	WHERE  ControlId = '#URL.ID#'
</cfquery>

<cfif Line.Functionname eq "">
 <cfset lbl = "New Report">
<cfelse>
 <cfset lbl = Line.Functionname>
</cfif>

<cf_screenTop height="100%" 
			  label="#lbl#" 
			  band="No" 
			  scroll="yes" 
			  line="no"
			  layout="webapp" 		
			  jquery="Yes"	  			  
			  menuAccess="Context"
			  systemfunctionid="#url.idmenu#">
			 
<cfif Line.ReportRoot eq "Application" or Line.ReportRoot eq "">
   <cfset rootpath  = "#SESSION.rootpath#">
<cfelse>
   <cfset rootpath  = "#SESSION.rootReportPath#">
</cfif>

<cf_distributer>

<cfset op = Line.Operational>

<cfif master eq "0">
	<!--- prevent any changes on non production --->
	<cfset op = "1">	
</cfif>

<cfinclude template="RecordEditScript.cfm">
<cf_fileLibraryScript>
<cf_menuscript>

<cfparam name="Status" default="1">

<cfif master eq "1">
	
	<!--- verify changes preparation --->
	
	<cfif Line.templateSQL eq "SQL.cfm">
	
		<cf_fileVerifyN
		    Root      = "#RootPath#"
		    Directory = "#Line.ReportPath#"
			File      = "#Line.templateSQL#"
			Timestamp = "#Line.TemplateSQLDate#">
			
		 <cfinclude template="RecordEditReset.cfm">	
			
	</cfif>		
	
	<!--- verify changes template --->
	
	<cfif Line.FunctionClass neq "System">
	
		<cfif Line.Operational eq "1">
		
			<cfquery name="Template" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ReportControlLayout
				WHERE     TemplateReport LIKE '%.cf_'
				AND       ControlId = '#URL.ID#'
			</cfquery>
		
			<cfloop Query="template">
		
				<cf_fileVerifyN
				    Root      = "#RootPath#"
				    Directory = "#Line.ReportPath#"
					File      = "#Template.templateReport#"
					Timestamp = "#Line.TemplateSQLDate#">
					
				 <cfinclude template="RecordEditReset.cfm">		
					
		   </cfloop>	
		
		</cfif>
		
	</cfif>	
	
<cfelse>	
	
</cfif>	

<table width="100%" height="100%" align="center">
      
    <tr id="field">
	<td colspan="3" height="100%" valign="top">
	   	  	  	  	 
		  <cfif Line.FunctionClass neq "System">	    
			  <cfinclude template="RecordEditFields.cfm">			
		  <cfelse>	 
		  	<cf_divscroll> 		  
		      <cfinclude template="RecordEditFieldsSystem.cfm">			
			 </cf_divscroll>  
		  </cfif>
	 	 
	  </td></tr>
		  
	  </table>
	</td></tr>  
	
</table>

	