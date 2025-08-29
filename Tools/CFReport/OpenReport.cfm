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
<cfparam name="url.id1" 		default="">
<cfparam name="url.id2" 		default="">
<cfparam name="url.id3" 		default="">
<cfparam name="url.id4"			default="">
<cfparam name="url.id5" 		default="">
<cfparam name="url.id6" 		default="">
<cfparam name="url.id7" 		default="">
<cfparam name="url.id8" 		default="">
<cfparam name="url.id9" 		default="">
<cfparam name="url.id10" 		default="">
<cfparam name="URL.filename"    default="Document">

<cfset url.template = replace(url.template,"/","\","ALL")>

<cfset vTemplate = "#SESSION.rootpath##url.template#">

<cfif not DirectoryExists("#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\")>

	   <cfdirectory action="CREATE" 
            directory="#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\">

</cfif>

<cfset FileNo = round(Rand()*100)>
<cfset attach = "#URL.FileName#_#FileNo#.pdf">

<cfset vpath="#SESSION.rootDocumentPath#\CFRStage\User\#SESSION.acc#\#attach#">

<cfset vpath=replace(vpath,"\\","\","ALL")>
<cfset vpath=replace(vpath,"//","/","ALL")>

<cfif FileExists(vpath)>
	<cffile action="DELETE" file="#vpath#">
</cfif>

<cfreport template = "#vTemplate#" format="PDF" overwrite="yes" filename = "#vPath#">
	<cfreportparam name = "id1"  value="#url.id1#"> 
	<cfreportparam name = "id2"  value="#url.id2#">
	<cfreportparam name = "id3"  value="#url.id3#">
	<cfreportparam name = "id4"  value="#url.id4#">
	<cfreportparam name = "id5"  value="#url.id5#">
	<cfreportparam name = "id6"  value="#url.id6#">
	<cfreportparam name = "id7"  value="#url.id7#">
	<cfreportparam name = "id8"  value="#url.id8#">
	<cfreportparam name = "id9"  value="#url.id9#">
	<cfreportparam name = "id10"  value="#url.id10#">
</cfreport>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>

<cfoutput>
<script language="JavaScript">
		window.location = "#SESSION.root#/CFRStage/getFile.cfm?File=#attach#&mid=#mid#";
</script>
</cfoutput>
