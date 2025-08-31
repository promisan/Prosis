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
<cfquery name="Get" 
datasource="AppsInit">
	SELECT *
	FROM Parameter 
	WHERE HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<CFParam name="Attributes.Root"      default="#SESSION.rootPath#">
<CFParam name="Attributes.Directory" default="yes"> 
<CFParam name="Attributes.File"      default="SQL.cfm">   
<CFParam name="Attributes.TimeStamp" default="01/01/01">

<cfset caller.filestatus = "same">
<cfset caller.filestamp  = "#Attributes.TimeStamp#">

<!---
<cftry>
--->

<cfif Get.EnableCM eq "1">
	
	<cfif DirectoryExists("#attributes.root#\#Attributes.Directory#")>
	      
		  <cfdirectory action="LIST" 
		directory="#attributes.root#\#Attributes.Directory#" 
		name="GetFiles" 
		sort="DateLastModified DESC" 
		filter="#Attributes.File#">
				
		<cfif GetFiles.DateLastModified gt Attributes.TimeStamp 
		   or getFiles.DateLastModified eq "">
		   	   
				<cfset caller.filestatus = "changed">
				<cfset caller.filestamp  = "#GetFiles.DateLastModified#">
				
		<cfelse>	
		
				<cfset caller.filestatus = "same">	
				<cfset caller.filestamp  = "#GetFiles.DateLastModified#">
						
		</cfif>			  		  
	
	<cfelse> 
	
			<cfset caller.filestatus = "notfound #attributes.root#\#Attributes.Directory#">		
		   <!--- <cfdirectory action="CREATE" 
             directory="#SESSION.rootDocumentPath#\#Attributes.DocumentPath#\#Attributes.SubDirectory#">
			 --->
	</cfif>
	
	<!---	
	<cfcatch></cfcatch>	
	</cftry>	
	--->

</cfif>
