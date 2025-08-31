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
<cfparam name="URL.Source"    default="User">
<cfparam name="URL.Option"    default="All">
<cfparam name="URL.Context"   default="default">
<cfparam name="URL.Interface" default="Both">
<cfparam name="URL.ControlId" default="">
<cfparam name="URL.ID" 		  default="00000000-0000-0000-0000-000000000000">

<!--- validate access to report --->

<cfif url.controlid neq "">
    <cfset url.id = url.controlid>
</cfif>

<cfif url.context eq "subscription">
	
	<cfquery name="getLayout" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   UserReport R, Ref_ReportControlLayout L
		 WHERE  R.ReportId = '#URL.id#' 	
		 AND    R.Layoutid = L.LayoutId
	</cfquery>
	
	<cfset url.id    = getLayout.controlid>
	<cfset controlid = getLayout.ControlId>
	<cfset reportid  = getLayout.ReportId>
</cfif>
	
<cfquery name="get" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControl R 
	 WHERE  R.ControlId = '#URL.ID#' 	
</cfquery>

<cfinvoke component="Service.AccessReport"  
    	method="report"  
		ControlId="#url.id#" 
 		Owner="#get.Owner#"
		returnvariable="access">								 									 
					
<cfif get.FunctionClass eq "System" or access is "GRANTED">

	<!--- good to show --->

<cfelse>

 		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		 <tr>
		 <td align="center" height="40" class="label">
		   <font color="FF0000">
			   <cf_tl id="You are not authorized for this report"  class="Message">
		   </font>
		 </td>
		 </tr>
		 
	   </table>	
	   
	   <cfabort>	

</cfif>

<cfif URL.Context eq "Anonymous">

	<cfinclude template="Anonymous/init.cfm">
	
</cfif>

<cfajaximport>

<cfquery name="Report" 
 datasource="AppsSystem"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ReportControl R 
	 WHERE  R.ControlId = '#URL.ID#' 
	 <cfif URL.Source neq "Library">
	 AND    R.Operational = '1' 
	 </cfif>	
</cfquery>

<cfset lname = "<font size='3'>#Report.FunctionName#</font>">
<cfset tit   = "#Report.FunctionName#">
<cfset mode  = "new">

<cfif Report.recordcount eq "0">
	
	<cfquery name="Report" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 
		 SELECT *
		 FROM   Ref_ReportControl R INNER JOIN Ref_ReportControlLayout L ON L.ControlId = R.ControlId
		 WHERE  (R.ControlId = '#URL.ID#' or L.LayoutId = '#URL.ID#')
		 <cfif URL.Source neq "Library">
		 AND    R.Operational = '1' 
		 </cfif>
		
	</cfquery>
	
	<cfset lname = "<font size='3'>#Report.FunctionName#</font>">
	<cfset tit   = "#Report.FunctionName#">
	<cfset mode = "new">
	
	<cfif Report.recordcount eq "0">
	 	
		<cfquery name="Report" 
		 datasource="AppsSystem" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT  *
		     FROM    UserReport U INNER JOIN
		             Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId INNER JOIN
		             Ref_ReportControl R ON L.ControlId = R.ControlId
			 WHERE   U.ReportId = '#URL.ID#' 
			 <cfif URL.Source neq "Library">
				 AND R.Operational = '1' 
			 </cfif>	
		</cfquery>
		
		<cfset lname = "#Report.FunctionName# - #Report.LayoutName#">
		<cfset tit   = "#Report.FunctionName# - #Report.LayoutName#">
		<cfset mode = "variant">
	
	</cfif>

</cfif>

<cfif tit is "">
	<cf_tl id="undefined layout" var="1">
	<cfset tit   = "#Report.FunctionName# - #lt_text#">
</cfif>

<cfif Report.recordcount eq "0">

	<cf_tl id="Sorry" var="1">
	<cfset vSorry=#lt_text#>
	
	<cf_tl id="but this subscription is not longer available" var="1" class="Message">
	<cfset vMsg1=#lt_text#>
	
	<cf_tl id="Refresh your selection and try again" var="1" class="Message">
	<cfset vMsg2=#lt_text#>	
	
	<cfoutput>
	   <cf_Message message="#vSorry#, #vMsg1#. #vMsg2#.">
	</cfoutput>	
	
<cfelse>	

	<cfif Report.Operational neq "1">
		<cfset st = "Under development">
	<cfelse>
	    <cfset st = "Operational">
	</cfif>
	
	<cfoutput>
	
	<cfif url.context eq "default">
	    <cfset html = "Yes">
	<cfelse>
		<cfset html = "No">
	</cfif>
	
	<cfif Report.FunctionClass neq "System">
	
	   <cfif url.source neq "Library">
	   
		<cf_screentop scroll="yes" 
		    html="#html#" 		
			layout="webapp"
			label="#tit#"
			jquery="Yes"			
			banner="blue"
			validateSession="Yes"
			line="no" 		
			height="100%">		
			
		<cfelse>
		
		<cf_screentop scroll="yes" 
		    html="no" 		
			layout="webapp"
			label="#tit#"
			jquery="Yes"			
			banner="blue"
			validateSession="Yes"
			line="no" 		
			height="100%">		
			
		</cfif>	
						
	</cfif>
		
	   <cfinclude template="Select.cfm">
	
	<cfif Report.FunctionClass neq "System">
	
		<cf_screenbottom layout="webapp">
		
	</cfif>   
	
	</cfoutput>
	
</cfif>	


