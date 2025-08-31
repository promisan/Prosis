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
<cf_param name="url.openas" default="view" type="string">
<cf_param name="url.mode" default="" type="string">
<cf_param name="url.id" default="" type="string">

<cfquery name="Att" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	     SELECT    TOP 1 *
		 FROM      Attachment
		 WHERE     AttachmentId = '#url.id#'		
</cfquery>

<!--- cutt path --->
<cfif left(att.serverpath,9) eq "document/"> 
   <cfset path = mid(att.serverpath,10,len(att.serverpath))>
<cfelse>
  <cfset path = att.serverpath>   
</cfif>

<cfset docPath = replace(path,"/","\","ALL")>
<cfset docPath = replace(docPath,"|","\","ALL")> 
<cfset docPath = replace(docPath,"\\","\","ALL")> 

<cfset label = "#docpath#\#att.filename#">
<cfset label = replaceNoCase(label,"\\","\","ALL")> 

<cf_screentop label="Edit #label#" height="100%" scroll="No" layout="webapp" banner="yellow">

<cfoutput>

	<iframe src="FileEditContent.cfm?openas=#url.openas#&mode=#url.mode#&id=#url.id#"
	  width="100%" height="100%" frameborder="0">
	</iframe>

</cfoutput>

<cf_screenbottom layout="webapp">