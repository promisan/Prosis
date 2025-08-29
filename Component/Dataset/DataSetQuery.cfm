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
<cfoutput>
<cfset link = "">
<cfloop index="itm" list="#CGI.QUERY_STRING#" delimiters="&">
   <cfif left("#itm#",9) eq "ControlId" or left("#itm#",11) eq "AjaxRequest">
   <cfelse>
     <cfif link eq "">
	   <cfset link = "#itm#">
	 <cfelse>
	   <cfset link = "#link#&#itm#">
	 </cfif>
   </cfif>
</cfloop>

</cfoutput>

<cfquery name="Report" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
		FROM      Ref_ReportControl R
	    WHERE     ControlId = '#URL.ControlId#'  
</cfquery>

<cfquery name="Check" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
		FROM      Ref_ReportControlOutput R
	    WHERE     ControlId         = '#URL.ControlId#'
		AND       OutputQueryString = '#link#'
</cfquery>
		
<cfif Check.recordcount eq "0">

	<cfquery name="Count" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT    count(*) as Total
		FROM      Ref_ReportControlOutput
	    WHERE     ControlId = '#URL.ControlId#'
	</cfquery>
					
	<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO Ref_ReportControlOutput
				(ControlId, 
				 DataSource, 
				 VariableName, 
				 OutputName, 
				 OutputQueryString,
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName) 
		 VALUES
			 ('#controlId#',
			  'appsOLAP',
			   '#replaceNoCase("#Report.FunctionName#"," ","_")#_fact_#count.total+1#',
			   '#Report.FunctionName#',
			   '#link#',
			   '#SESSION.acc#',
			   '#SESSION.last#',
			   '#SESSION.first#')
	</cfquery>
	
	<cfset tble = replaceNoCase("#Report.FunctionName#"," ","_")>
				
	<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    *
			FROM      Ref_ReportControlOutput R
		    WHERE     ControlId = '#URL.ControlId#'
			AND       OutputQueryString = '#link#'
	</cfquery>
		
		<cfset tble = "#Report.FunctionName#_fact_#count.total+1#">
		
<cfelse>	

		<cfset tble = "#Check.VariableName#">	
		
</cfif>

<cfset tble = replaceNoCase("#Check.VariableName#"," ","_")>

<!--- perform query --->

<cf_droptable 
  dbname="AppsOLAP" 
  tblname="#tble#">

<!--- locate the template and the querystring to be performed ---> 

<cfinclude template="../../#report.ReportPath#">

<cfparam name="DetailKey"      default="">
<cfparam name="DetailTemplate" default="">
	
<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_ReportControlOutput
	SET    DetailKey         = '#DetailKey#',
	       DetailTemplate    = '#DetailTemplate#',
	       OfficerUserId     = '#SESSION.acc#',
	       OfficerLastName   = '#SESSION.last#',
		   OfficerFirstName  = '#SESSION.first#',
		   Created = #now()#
	WHERE  OutputId = '#Check.OutputId#' 
</cfquery>

<cfinvoke component="Service.Dataset.Dataset" 
	 method="Listing"
	 ControlId        = "#URL.ControlId#">	 



