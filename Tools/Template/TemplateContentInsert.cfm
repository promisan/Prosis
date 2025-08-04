<!--
    Copyright Â© 2025 Promisan

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

<!--- scan content for structured fields --->
								
<cfparam name="usr" default="Administrator">		
<cfparam name="nme" default="Administrator">	
						
<cfset com = "">
<cfset des = "">

<cfset posUS = Find("<proUsr>",  content)>
<cfset posUE = Find("</proUsr>", content)>					
<cfset posNS = Find("<proOwn>",  content)>
<cfset posNE = Find("</proOwn>", content)>
<cfset posCS = Find("<proCom>",  content)>
<cfset posCE = Find("</proCom>", content)>
<cftry>
     <cfset usr = Mid(content, posUS+8, posUE-PosUS-8)>
	 <cfset nme = Mid(content, posNS+8, posNE-PosNS-8)>
	 <cfset com = Mid(content, posCS+8, PosCE-PosCS-8)>
 <cfcatch></cfcatch>
</cftry>

<!--- #sys.AuthorizationServer#. --->

<cfquery name="User" 
datasource="AppsControl">
    SELECT *
	FROM   System.dbo.UserNames
	WHERE  Account = '#usr#'
</cfquery>

<cfif User.recordcount eq "0">
  <cfset usr = "administrator">
</cfif>

<cfset grp = "[root]">
<cfloop index="itm" list="#dir#" delimiters="\">
   <cfif grp eq "[root]">
     <cfset grp = "#itm#">
   </cfif>
</cfloop>

<cfset oVersion = "8,0,1">
<cfset cVersion = Server.Coldfusion.ProductVersion>

<cfset newerVersion = 0>

<cfif ListGetAt(cVersion,1) gt ListGetAt(oVersion,1)>
	<cfset newerVersion = 1>
<cfelseif ListGetAt(cVersion,1) eq ListGetAt(oVersion,1)>
	
	<cfif ListGetAt(cVersion,2) gt ListGetAt(oVersion,2)>
			<cfset newerVersion = 1>
	<cfelseif ListGetAt(cVersion,2) eq ListGetAt(oVersion,2)>
			
			<cfif ListGetAt(cVersion,3) gt ListGetAt(oVersion,3)>
				<cfset newerVersion = 1>
			</cfif>
			
	</cfif>
	
</cfif>
			
<cfif newerVersion eq 1>
  
    <cfset fdate = "'#DateLastModified#'">
	 <cfset fdate = Mid(fdate, 2, len(fdate)-2)>					
 
 <cfelse>
  
    <cfset fdate = "'#DateLastModified#'">
 
 </cfif>
							
<cfquery name="Log" 
	datasource="AppsControl">
   		INSERT INTO Ref_TemplateContent
		(PathName,
		 FileName,
		 ApplicationServer,
		 VersionDate,
		 TemplateOfficer,
		 TemplateGroup,
		 TemplateModified,
		 TemplateModifiedBy,
		 TemplateComments,
		 TemplateSize,
		 TemplateContent)
		VALUES
		('#dir#',
		 '#name#',
		 '#site#',
		 '#version#',
		 '#usr#',
		 '#grp#',
		 #preservesingleQuotes(fdate)#,
		 '#nme#',
		 '#com#',
		 '#size#',
		 '#content#')
</cfquery>