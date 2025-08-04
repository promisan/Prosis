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

<!--- add or remove the action in 
  PublicationWorkOrderAction and 
  update the total
  update the tree
--->

<cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   WorkOrderLineAction
	WHERE  WorkActionId  = '#url.workactionid#'
</cfquery>

<cfquery name="getLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	WorkOrderLine
	WHERE  	WorkOrderId   = '#get.WorkOrderId#'
	AND		WorkOrderLine = '#get.WorkOrderLine#'
</cfquery>

<!--- provision to add the element --->

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

<!--- ----------- end of provision --------------- --->

<cfquery name="getClusterElement" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	PublicationClusterElement
	WHERE  	PublicationElementId = '#url.PublicationElementId#'
</cfquery>

<cfquery name="getPublishAction" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    PublicationWorkOrderAction
	WHERE   PublicationElementId = '#url.PublicationElementId#'
	AND     WorkActionId         = '#url.workactionid#'
</cfquery>

<cfif url.action eq "false">

	<!--- clear any pictures that you might have added to this action --->
	
	<cfquery name="getPicture" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   System.dbo.Attachment
		WHERE  Reference = '#getPublishAction.PublicationActionId#'		
	</cfquery>
	
	<!--- clear pictures itself --->
	
	<cfloop query="getPicture">	
		<cf_fileDelete attachmentid="#attachmentid#" mode="hide">
	</cfloop>		
	
	<!--- clear the record itself --->
	
	<cfquery name="clearAction" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM PublicationWorkOrderAction
		WHERE PublicationElementId = '#url.PublicationElementId#'
		AND   WorkActionId         = '#url.workactionid#'
	</cfquery>
		
<cfelse>
	
	<!--- add record --->
		
	<cfif getPublishAction.recordcount eq "0">

		<cfquery name="addAction" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO PublicationWorkOrderAction
				(PublicationElementId,
				 WorkActionId,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
				('#url.PublicationElementId#',
				 '#url.workactionid#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
		</cfquery>
	
	</cfif>

</cfif>

<CF_DateConvert Value="#DateFormat(get.DateTimeRequested,CLIENT.DateFormatShow)#">
<cfset STR = dateValue>
<cfset END = dateAdd("D","1",str)>

<cfquery name="getActions" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   PublicationWorkOrderAction
	WHERE  PublicationElementId = '#url.PublicationElementId#'
	AND    WorkActionId  IN (SELECT WorkActionId
	                         FROM   WorkOrderLineAction
							 WHERE  WorkOrderId = '#get.WorkOrderId#'
							 AND    DateTimeRequested BETWEEN #str# and #end#)
</cfquery>

<cfquery name="getTotalActionsByOrgUnit" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   PublicationWorkOrderAction
	WHERE  PublicationElementId = '#url.PublicationElementId#'
	AND    WorkActionId  IN (
								SELECT 	A.WorkActionId
	                         	FROM   	WorkOrderLineAction A
							 			INNER JOIN WorkOrderLine L
											ON A.WorkOrderId = L.WorkOrderId
											AND A.WorkOrderLine = L.WorkOrderLine		
							 	WHERE  	L.OrgUnit = '#getLine.OrgUnit#'
							)
</cfquery>

<cfquery name="getTotalActionsByCluster" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM   	PublicationWorkOrderAction
	WHERE  	PublicationElementId IN
				(
					SELECT 	PublicationElementId
					FROM	PublicationClusterElement
					WHERE	PublicationId = '#url.PublicationId#'
					AND		Cluster = '#url.cluster#'
				)
</cfquery>

<!--- show the totals --->

<cfoutput>

	<script>
		window.parent.$('##countActionsCluster_#getClusterElement.Cluster#').html('[#getTotalActionsByCluster.recordcount#]');
		$('##countActionsOrgUnit_#getLine.OrgUnit#').html('[#getTotalActionsByOrgUnit.recordcount#]');
	</script>

   	<!--- refresh the content --->

   	<cfif getActions.recordcount gte "1">
		<div style="color:##5C5C5C; border:1px solid ##5C5C5C; background-color:##FFFFBD; text-align:center; padding-top:3px; padding-left:1px; border-radius:20px; height:20px; width:20px; font-size:13px;">
			#getActions.recordcount#
		</div>
   	</cfif>
	
</cfoutput>
