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
	
	<cfif validatePubElement.recordCount eq 0>
	
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


<cfquery name="setPubElementMemo" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE 	PublicationClusterElement
		SET		Memo = '#url.val#'
		WHERE	PublicationElementId = '#url.publicationElementId#'
</cfquery>

<div style="color:#47A0ED; font-weight:bold;">
	<cf_tl id="Saved">
</div>