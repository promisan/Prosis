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

<!--- add copy over the attachment and record entry undo remove attachment and remove entry --->


<cfif url.PublicationElementId eq "">

	<cfquery name="validatePubElement" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	PublicationClusterElement
			WHERE	PublicationId = '#url.PublicationId#'
			AND		Cluster       = '#url.cluster#'
			AND		OrgUnit       = '#url.orgUnit#'
	</cfquery>
	
	<cfif validatePubElement.recordcount eq 0>

		<!--- Create element --->
		<cf_assignId>
		
		<cfquery name="insertPubElement" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO PublicationClusterElement (
						PublicationElementId,
						PublicationId,
						Cluster,
						OrgUnit,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
				) VALUES (
						'#rowGuid#',
						'#url.publicationId#',
						'#url.cluster#',
						'#url.orgunit#',
						'#session.acc#',
						'#session.last#',
						'#session.first#' )
		</cfquery>
		
		<cfset url.PublicationElementId = rowGuid>
	
	<cfelse>
	
		<cfset url.PublicationElementId = validatePubElement.PublicationElementId>
	
	</cfif>
	
</cfif>


<cfquery name="getPubElement" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM	PublicationWorkOrderAction
		WHERE	PublicationElementId = '#url.PublicationElementId#'
		AND		WorkActionId         = '#url.WorkActionId#'	
</cfquery>

<cfquery name="attachment" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   System.dbo.Attachment
			WHERE  AttachmentId = '#url.attachmentid#'		
	</cfquery>

<cfif url.action eq "true">
	
	<!--- create a record and refresh the screen with the click action --->

	<cfif getPubElement.recordcount eq "0">
	
			<cf_assignid>
	
			<cfquery name="addAction" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PublicationWorkOrderAction
					(PublicationElementId,
					 WorkActionId,
					 PublicationActionId,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES
					('#url.PublicationElementId#',
					 '#url.workactionid#',
					 '#rowguid#',
					 '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
			</cfquery>
		
	</cfif>
	
	<cfquery name="getPubElement" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	PublicationWorkOrderAction
			WHERE	PublicationElementId = '#url.PublicationElementId#'
			AND		WorkActionId         = '#url.WorkActionId#'	
	</cfquery>	
		
	<!--- copy over the file : pending --->		
			
	<cfif not DirectoryExists("#SESSION.rootDocumentPath#/Publication/#getPubElement.PublicationActionId#")>
								  
	      <cfdirectory action   = "CREATE" 
				      directory= "#SESSION.rootDocumentPath#/Publication/#getPubElement.PublicationActionId#">
					  
	</cfif>		
	
	<cfif FileExists("#SESSION.rootDocumentPath#/Publication/#getPubElement.PublicationActionId#/#attachment.fileName#")>	
		<cffile action="delete" file="#SESSION.rootDocumentPath#/Publication/#getPubElement.PublicationActionId#/#attachment.fileName#">		
	</cfif>	
	
	<cffile action="COPY" source="#SESSION.rootDocumentPath#/#attachment.ServerPath#/#attachment.fileName#" 
		    destination="#SESSION.rootDocumentPath#/Publication/#getPubElement.PublicationActionId#">
			
	<cfquery name="getAtt" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   System.dbo.Attachment
			WHERE  Reference    = '#getPubElement.PublicationActionId#'		
			AND    FileName     = '#Attachment.FileName#'		
	</cfquery>
	
	<cfset attid = getAtt.attachmentId>
	
	<cfif getAtt.recordcount eq "0">		
			
		<cf_assignid>
		
		<cfset attid = rowguid>
			
		<cfquery name="getAttachment" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Attachment
					(
					 AttachmentId,
					 DocumentPathName,
					 Server,
					 ServerPath,
					 FileName,	 
					 FileStatus,
					 FileEncryption,
					 SystemModule,
					 AttachmentMemo,
					 Reference,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 Created)
					 
			SELECT   '#attid#',
					 'Publication',
					 Server,
					 'Publication/#getPubElement.PublicationActionId#/',
					 FileName,	 
					 FileStatus,
					 FileEncryption,
					 SystemModule,
					 AttachmentMemo,
					 '#getPubElement.PublicationActionId#',
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,
					 Created
			FROM     Attachment
			WHERE    AttachmentId = '#url.attachmentId#'
		</cfquery>		
		
	<cfelse>
	
		<cfset attid = getAtt.attachmentId>	
		
		<cfquery name="update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Attachment
			SET    FileStatus = '1'
			WHERE  AttachmentId = '#attid#'														
		</cfquery>
	
	</cfif>	
		
	<!--- show the memo --->
	
	<cfquery name="getMemo" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Attachment
		WHERE  	AttachmentId = '#attid#'														
	</cfquery>
	
	<cfoutput>
	
		<script>	
			_cf_loadingtexthtml='';	
			$('##PublicationActionId_#url.attachmentId#_#url.currentrow#').val('#attid#');
			ColdFusion.navigate('../Picture/getMemo.cfm?attachmentid=#url.attachmentid#&newattachmentid=#attid#&memo=#URLEncodedFormat(getMemo.AttachmentMemo)#','box_#url.attachmentid#')	
		</script>
	
	</cfoutput>
	
<cfelse>

	<cfquery name="getPicture" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   System.dbo.Attachment
			WHERE  Reference    = '#getPubElement.PublicationActionId#'		
			AND    FileName     = '#Attachment.FileName#'		
	</cfquery>
					
	<cfloop query="getPicture">		
					
		<cf_fileDelete attachmentid="#attachmentid#" mode="hide">		
		
		<cfoutput>
			<script>	
				$('##PublicationActionId_#attachmentid#_#url.currentrow#').val('');
			</script>	
		</cfoutput>	
	
	</cfloop>

</cfif>
