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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<body leftmargin="2" topmargin="2" rightmargin="2" bottommargin="2"></body>

<cf_wait text="Comparing templates">

<cfquery name="New" 
datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent R, ParameterSite P
	WHERE  R.ApplicationServer = P.ApplicationServer
	AND    TemplateId = '#URL.new#'
</cfquery>	

<cfquery name="Old" 
datasource="appsControl">
	SELECT *
	FROM   Ref_TemplateContent R, ParameterSite P
	WHERE  R.ApplicationServer = P.ApplicationServer	
	AND    TemplateId = '#URL.old#'
</cfquery>	

<cfif new.pathName eq "[root]">
  <cfset path = "">
<cfelse>
  <cfset path = "#new.pathName#">
</cfif>

<cfoutput>
<title>Template Comparison #New.replicaPath# vs #Old.replicaPath#</title>
</cfoutput>

<cfset nme = "">

<cfloop index="itm" list="#new.filename#" delimiters=".">
  <cfif nme eq "">
	  <cfset nme = itm>
  </cfif>
</cfloop>

<!--- read files from source and then compare --->

<cftry>

	<cffile action="COPY" 
	        source="#new.ReplicaPath#\#path#\#new.fileName#" 
	        destination="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#">
			
	<cffile action="RENAME" 
	        source="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#new.fileName#" 
	        destination="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#nme#_new.txt">		
			
	<cffile action="COPY" 
	        source="#Old.replicaPath#\#path#\#old.fileName#" 
	        destination="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#">		
			
	<cffile action="RENAME" 
	        source="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#old.fileName#" 
	        destination="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#nme#_old.txt">			
	
	<cf_TemplateCompare 
	 left   = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#nme#_new.txt"
	 right  = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#nme#_old.txt"
	 output = "#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\#nme#.html"
	 delete = "yes">
	 
	 <cf_sleep seconds="2">
	  
	 <cf_waitEnd>
	   
		 <cfoutput>
	 
		 <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
		 <tr>
		 <td class="top4n">&nbsp;
		  <img src="#SESSION.root#/Images/comparison2.gif" 
					 			order="0" align="absmiddle">&nbsp;
		 <b>#SESSION.welcome# release management tool</td>
		 </tr>
		 <tr><td height="4"></td></tr>
		 <tr><td>	 	 	 	 
		 <cfinclude template="../../CFRStage/User/#SESSION.acc#/#nme#.html">
		 </td></tr>
		 </table>
		 
		 </cfoutput>
	  
 	<cfcatch>
	
	  <cf_message message="The source file could not be located">
	
	</cfcatch>
 
 </cftry>
 
 

