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
<cfparam name="attributes.left"   default="">
<cfparam name="attributes.right"  default="">
<cfparam name="attributes.output" default="">
<cfparam name="attributes.script" default="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\script.txt">
<cfparam name="attributes.bat"    default="#SESSION.rootPath#\cfrstage\user\#SESSION.acc#\bcbat.bat">
<cfparam name="attributes.delete" default="no">

<cfparam name="left"       default="#attributes.left#">
<cfparam name="right"      default="#attributes.right#">
<cfparam name="output"     default="#attributes.output#">
<cfparam name="batfile"    default="#attributes.bat#">
<cfparam name="scriptfile" default="#attributes.script#">
<cfparam name="delete"     default="#attributes.delete#">

<cfif right eq "" or left eq "" or output eq "">
   aborted
   <cfabort>
</cfif>

<cfoutput>

<cfquery name="Engine" 
datasource="appsInit">
	SELECT *
	FROM   Parameter
	WHERE HostName = '#CGI.HTTP_HOST#'
</cfquery>	

<cfset bc = "#Engine.CompareEngine#">
	
<cfsavecontent variable="script">
	file-report layout:Composite &
	options:ignore-unimportant,display-context &
	output-to:#output# &
	output-options:html-color,wrap-word &
	#right# &
	#left# 
</cfsavecontent>

<cftry>
	
	<cffile action="WRITE" file="#scriptfile#" 
	                       output="#script#" 
						   addnewline="Yes" fixnewline="No">		
						   
	<cfsavecontent variable="bat">"#bc#" @#scriptfile#</cfsavecontent>
	
	<cffile action="WRITE" file="#batfile#"
					       output="#bat#"
					       addnewline="Yes" fixnewline="No">		
	
	<cfsilent>
		<cfexecute name="#batfile#" timeOut="3"></cfexecute>
	</cfsilent>

	<cfcatch></cfcatch>
	
</cftry>

<cfif delete eq "yes">

	<cf_sleep seconds="1"> 
	<cftry>
		<cffile action="DELETE" file="#left#">
		<cffile action="DELETE" file="#right#">
	<cfcatch></cfcatch>
	</cftry>

</cfif>

</cfoutput>
