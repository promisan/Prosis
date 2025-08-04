<!--
    Copyright © 2025 Promisan

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

<!--- Create a temporal table --->
<cfset FileNo = round(Rand()*1000)>
<cfset Answer1   = "tCollection_#SESSION.acc#_#FileNo#">
<cf_dropTable dbName="AppsQuery" tblName="#Answer1#">
<cfquery name="CreateAnswer" datasource="AppsQuery">
	CREATE TABLE userQuery.dbo.#Answer1# ( Id uniqueidentifier not null)
</cfquery>

<!--- populate the temporal table with the ID of the attachments that are stored in the collection ---> 
<cfsearch name="indexedDocuments" 
    collection="#lcase(collection.collectionname)#" 
	category="Document">

<cfloop query="indexedDocuments">

	<cfif Custom1 neq 'Document'>
		<cfquery name="Insert" datasource="AppsQuery">
			INSERT INTO userQuery.dbo.#Answer1# (Id) values ('#Custom1#')
		</cfquery>
	</cfif>
	
</cfloop>

<!--- Get the files to be deleted --->
<cfquery name="DeleteAttachment" datasource="AppsSystem">
	SELECT * From Attachment A
	INNER JOIN userQuery.dbo.#Answer1# T
		ON A.AttachmentId = T.Id
	WHERE A.FileStatus = '9'
	AND A.DocumentPathName = '#Folder.DocumentPathName#'
</cfquery>

<!--- Clean the collection --->
<cfloop query="DeleteAttachment">
	<cfif server eq "document">
	    <cfset svr = SESSION.rootdocumentpath>
	<cfelse>
		<cfset svr = server>
	</cfif>
	
	<cfindex collection="#lcase(collection.collectionname)#" action="delete" key="#svr#\#serverpath#\#filename#" >
</cfloop>

