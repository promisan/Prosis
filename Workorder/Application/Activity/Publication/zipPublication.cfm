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
<cfquery name="getPictures" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  A.ServerPath,
				A.FileName
		FROM	Publication P
				INNER JOIN PublicationCluster PC
					ON P.PublicationId = PC.PublicationId
				INNER JOIN PublicationClusterElement PCE
					ON PC.PublicationId = PCE.PublicationId
					AND PC.Code = PCE.Cluster
				INNER JOIN PublicationWorkOrderAction PWA
					ON PCE.PublicationElementId = PWA.PublicationElementId
				INNER JOIN WorkOrderLineAction WOLA
					ON PWA.WorkActionId = WOLA.WorkActionId
				INNER JOIN Ref_Action AC
					ON WOLA.ActionClass = AC.Code
				INNER JOIN Organization.dbo.Organization O
					ON PCE.OrgUnit = O.OrgUnit
				LEFT OUTER JOIN System.dbo.Attachment A
					ON CONVERT(VARCHAR(36),PWA.PublicationActionId) = A.Reference
		WHERE 	1=1
		<cfif url.id neq "">
		AND		P.PublicationId = '#url.id#'
		<cfelse>
		AND		1=0
		</cfif>
		AND		A.FileStatus <> '9'
		AND		SUBSTRING(A.FileName,LEN(A.FileName)-2,LEN(A.FileName)) IN ('JPG', 'PNG', 'GIF')
		ORDER BY 
				A.Created ASC
</cfquery>

<cfset vDirectory = "#session.rootdocumentpath#\User\#session.acc#">

<cfif not directoryExists(vDirectory)>
	 <cfset DirectoryCreate(vDirectory)> 
</cfif>

<cfset vZipFileName = "#vDirectory#\publication_#url.id#.zip">

<cfif FileExists("#vZipFileName#")>
	<cffile action="delete" file="#vZipFileName#">
</cfif>

<cfset vSourceList = "">

<cfloop query="getPictures">

	<cfset vSourcePicture = "#session.rootdocumentpath#\#ServerPath#\#filename#">
	<cfset vSourcePicture = replace(vSourcePicture, "/", "\", "ALL")>
	
	<cfset vSourceList = vSourceList & vSourcePicture & ",">
	
</cfloop>

<cfif trim(vSourceList) neq "">
	<cfset vSourceList = mid(vSourceList,1,len(vSourceList)-1)>
</cfif>

<cf_zip 
	filelist="#vSourceList#" 
	recursedirectory="No" 
	savepath="No"
	output="#vZipFileName#">       


<cfcontent file="#vZipFileName#" deletefile="true" />
<cfheader name="Content-Disposition" value="attachment; filename=publication.zip">

<script>
	window.close();
</script>
