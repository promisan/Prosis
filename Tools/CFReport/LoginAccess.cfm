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
<cfparam name="SESSION.login" default=""> 
<cfparam name="SESSION.dbpw"  default=""> 
<cfparam name="SESSION.root"  default="">

<cfquery name="Parameter" 
   	 datasource="AppsInit">
	 SELECT  *
	 FROM    Parameter
	 WHERE   HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfif SESSION.login eq "" or SESSION.root eq "">

	<cfif Len(Trim(Parameter.DefaultPassword)) gt 20> 
    	  <!--- encrypt password --->
	      <cf_decrypt text = "#Parameter.DefaultPassword#">
		  <cfset password = Decrypted>
	      <!--- end encryption --->
	<cfelse>	  
    	  <cfset password = Parameter.DefaultPassword>
	</cfif>	  

	<cfset SESSION.dbpw            = "#password#">
	<cfset SESSION.login           = "#Parameter.DefaultLogin#">	
		  
</cfif>	

<cfset SESSION.root            = "#Parameter.ApplicationRoot#"> 
<cfset SESSION.rootPath        = "#Parameter.ApplicationRootPath#"> 
<cfset SESSION.rootreport      = "#Parameter.ReportRoot#"> 
<cfset SESSION.rootReportPath  = "#Parameter.ReportRootPath#">      