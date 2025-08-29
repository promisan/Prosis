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
<cfparam name="attributes.type"       default="File">
<cfparam name="attributes.datasource" default="AppsSystem">
<cfparam name="attributes.listinfo"   default="name">

<cfquery name="Attachment" 
			datasource="#attributes.datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
		    FROM      System.dbo.Ref_Attachment
			WHERE     DocumentPathName = '#Attributes.DocumentPath#'	
		</cfquery>
		
<cfif Attachment.recordcount eq "1">

    <CFParam name="Attributes.DocumentHost"    default="#attachment.documentfileserverroot#">

<cfelse>

	<CFParam name="Attributes.DocumentHost"    default="#SESSION.rootDocumentPath#\">

</cfif>		

<cfset DocumentHost = Attributes.DocumentHost> 
<cfset DocumentPath = Attributes.DocumentPath> 
<cfset subdirectory = Attributes.subdirectory> 
<cfset filter       = Attributes.filter> 

<cfdirectory action="LIST"
             directory="#documenthost#\#DocumentPath#\#SubDirectory#"
             name="GetFiles"
             filter="#Filter#*.*"
             sort="DateLastModified DESC"
             type="#attributes.type#"
             listinfo="#attributes.listinfo#">

<cfset caller.filelist = getfiles>		
<cfset caller.files    = getfiles.recordcount>	