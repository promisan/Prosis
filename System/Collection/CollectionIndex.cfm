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

<!--- this is a default index generator in case no custom index is defined --->

<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       Collection
	WHERE      CollectionId = '#url.collectionid#' 
</cfquery>

<!--- get the time as the process starts --->
<cfset timestamp = now()>

<!--- retrieve the info for the collection from the server --->
<cfcollection action="LIST" name="serverCollection" engine="#collection.searchengine#">

<cfquery name="Exist" dbtype="query">
   	   SELECT   *
	   FROM     serverCollection
	   WHERE    Name = '#lcase(collection.collectionname)#'		   
</cfquery>		

<!--- clean collection --->

<!--- <cfindex action="PURGE" collection="#collection.collectionname#">  --->

<!--- reload documents --->

<cfquery name="Folder" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     CollectionFolder
WHERE    CollectionId = '#url.collectionid#' 
</cfquery>

<cfloop query="Folder">
		
	<cfquery name="Document" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   A.*
	FROM     Attachment A
	WHERE    DocumentPathName = '#documentPathName#' 
	<cfif collection.indextimestamp neq "">
		AND      AttachmentId IN (SELECT  AttachmentId 
		                          FROM    AttachmentLog 
								  WHERE   AttachmentId = A.AttachmentId
								  AND     Created > '#collection.indextimestamp#'
								  AND     FileAction != 'Open')
	</cfif>						  
	AND      FileStatus != '9'
	</cfquery>
	
	<cfloop query="Document">
	
		<cfif server eq "document">
		    <cfset svr = SESSION.rootdocumentpath>
		<cfelse>
			<cfset svr = server>
		</cfif>
		
		<cfindex action = "UPDATE"
		    collection  = "#collection.collectionname#" 
			key         = "#svr#\#serverpath#\#filename#" 
			type        = "FILE"
			title       = "Documents" 
			extensions  = "#collection.extensions#" 			
			category    = "Document"
			language    = "English"> 
		
	</cfloop>	
	
</cfloop>	

<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE     Collection
	SET        IndexTimestamp = #timestamp#
	WHERE      CollectionId = '#url.collectionid#' 
</cfquery>
