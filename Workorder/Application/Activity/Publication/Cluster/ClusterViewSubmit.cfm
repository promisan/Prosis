
<cfif form.selectedOrgUnit neq "">

	<cftransaction>

		<cfquery name="getPub" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM	Publication
				WHERE	PublicationId = '#url.PublicationId#'
		</cfquery>
	
		<cfquery name="getActions" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT	A.*
				FROM	WorkOrderLineAction A
						INNER JOIN Workorder W
							ON A.WorkOrderId = W.WorkOrderId
						INNER JOIN WorkOrderLine L
							ON A.WorkOrderId = L.WorkOrderId
							AND A.WorkOrderLine = L.WorkOrderLine
				WHERE	A.DateTimeActual IS NOT NULL
				and		A.ActionStatus = '3'
				AND		A.WorkOrderId = '#getPub.workOrderId#'
				AND		L.OrgUnit = '#form.selectedOrgUnit#'
				AND		A.DateTimeRequested BETWEEN '#getPub.PeriodEffective#' and '#getPub.PeriodExpiration#'
				ORDER BY A.DateTimeRequested ASC
		</cfquery>
		
		<cfquery name="getPubElement" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM	PublicationClusterElement
				WHERE	PublicationId = '#url.PublicationId#'
				AND		Cluster = '#url.code#'
				AND		OrgUnit = '#form.selectedOrgUnit#'
		</cfquery>
		
		<cfset vElementId = "">
		
		<cfif getPubElement.recordCount eq 0>
			
			<!--- Create element --->
			<cf_assignId>
			<cfquery name="insertPubElement" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO PublicationClusterElement
						(
							PublicationElementId,
							PublicationId,
							Cluster,
							OrgUnit,
							Memo,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#rowGuid#',
							'#url.publicationId#',
							'#url.code#',
							'#form.selectedOrgUnit#',
							'#trim(form.elementMemo)#',
							'#session.acc#',
							'#session.last#',
							'#session.first#'
						)
			</cfquery>
			
			<cfset vElementId = rowGuid>
			
		<cfelseif getPubElement.recordCount eq 1>
			<cfset vElementId = getPubElement.PublicationElementId>
			
			<cfquery name="updatePubElement" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					UPDATE	PublicationClusterElement
					SET		Memo = '#trim(Form.elementMemo)#'
					WHERE	PublicationElementId = '#vElementId#'
				
			</cfquery>
			
			<cfquery name="removePubWorkAction" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					DELETE
					FROM	PublicationWorkOrderAction
					WHERE	PublicationElementId = '#vElementId#'
				
			</cfquery>
		</cfif>
		
		<cfif vElementId neq "">
		
			<!--- Create Actions --->
			<cfset cntActions = 0>
			<cfoutput query="getActions">
				
				<cfset vId = replace(workActionId,'-','','ALL')>
				
				<cfif isDefined("Form.action_#vId#")>
				
					<cfquery name="insertPubWorkAction" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
							INSERT INTO PublicationWorkOrderAction
								(
									PublicationElementId,
									WorkActionId,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
								)
							VALUES
								(
									'#vElementId#',
									'#workActionId#',
									'#session.acc#',
									'#session.last#',
									'#session.first#'
								)
					</cfquery>
					
					<cfset cntActions = cntActions + 1>
					
				</cfif>
				
			</cfoutput>
			
			<cfif cntActions eq 0>
				<!--- remove the element if no actios are defined--->
				<cfquery name="removePubElement" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE
						FROM	PublicationClusterElement
						WHERE	PublicationElementId = '#vElementId#'
				</cfquery>
			</cfif>
		
		<cfelse>
		
			<!--- provision to remove duplicated elements (pub,cluster,orgunit) --->
			
			<cfquery name="removePubElement" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE
					FROM	PublicationClusterElement
					WHERE	PublicationId = '#url.PublicationId#'
					AND		Cluster = '#url.code#'
					AND		OrgUnit = '#form.selectedOrgUnit#'
			</cfquery>
		
		</cfif>
	
	</cftransaction>
	
	<cfoutput>
		<script>
			window.location = 'ClusterDetailForm.cfm?publicationId=#url.publicationId#&code=#url.code#&preselOrgUnit=#form.selectedOrgUnit#';
		</script>
	</cfoutput>

</cfif>