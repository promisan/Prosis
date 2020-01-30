
<cfset selDate = replace("#Form.PeriodEffective#","'","","ALL")>
<cfset dateValue = "">
<cf_dateConvert Value="#SelDate#">
<cfset initDate = dateValue>

<cfset selDate = replace("#Form.PeriodExpiration#","'","","ALL")>
<cfset dateValue = "">
<cf_dateConvert Value="#SelDate#">
<cfset endDate = dateValue>

<cf_tl id="These dates overlap with an existing publication" var="vOverlapMessage">
<cf_tl id="The expiration date must be greater or equal to the effective date" var="vGreaterMessage">

<!--- Overlap validation --->
<!--- <cfquery name="validateOverlapPublication" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT 	*
		FROM 	Publication
		WHERE	(
					#initDate# BETWEEN PeriodEffective AND PeriodExpiration
					OR 
					#endDate# BETWEEN PeriodEffective AND PeriodExpiration
				)
		<cfif trim(url.publicationId) neq "">
		AND		PublicationId != '#url.publicationId#'
		</cfif>
</cfquery> --->

<!--- <cfif validateOverlapPublication.recordCount eq 0> --->

	<cfset vPubId = "">

	<cfif endDate gte initDate>

		<cfif trim(url.publicationId) eq "">
		
			<cf_assignId>
			
			<cftransaction>
			
				<cfquery name="addPublication" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Publication
						 	(
								PublicationId,
								WorkOrderId,
								PeriodEffective,
								PeriodExpiration,
								Description,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#RowGuid#',
								'#url.workOrderId#',
								#initDate#,
								#endDate#,
								'#trim(Form.Description)#',
								'#session.acc#',
								'#session.last#',
								'#session.first#'
							)
				</cfquery>
				
				<cfquery name="addDefaultCluster" 
					datasource="AppsWorkOrder" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO PublicationCluster
						 	(
								PublicationId,
								Code,
								Description,
								ListingOrder,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#RowGuid#',
								'01',
								'Default',
								1,
								'#session.acc#',
								'#session.last#',
								'#session.first#'
							)
				</cfquery>
				
				<cfset vPubId = RowGuid>
			
			</cftransaction>
		
		<cfelse>
		
			<cfquery name="addDefaultCluster" 
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
					UPDATE 	Publication
					SET		Description = '#trim(Form.Description)#',
							PeriodEffective = #initDate#,
							PeriodExpiration = #endDate#
					WHERE	PublicationId = '#url.publicationId#'
					
			</cfquery>
			
			<cfset vPubId = url.publicationId>
		
		</cfif>
		
		<cfoutput>
			<script>
				<cfif url.publicationid neq "">
					ColdFusion.Window.hide('mydialog'); 
					ColdFusion.navigate('getPublicationInfo.cfm?publicationId=#vPubId#','divPublicationInfo');
				<cfelse>
					ColdFusion.Window.hide('mydialog'); 
					ColdFusion.navigate('#SESSION.root#/Workorder/Application/Activity/Publication/PublicationListingContent.cfm?systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#','divPublication');
					ptoken.open('#SESSION.root#/WorkOrder/Application/Activity/Publication/PublicationView.cfm?systemfunctionid=#url.systemfunctionid#&workOrderId=#url.workorderid#&drillid=#vPubId#'+'&ts='+new Date().getTime(), '_blank', 'toolbar=no, scrollbars=no, resizable=no, top=10, left=10, width=1400, height=800');
				</cfif>
			</script>
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#vGreaterMessage#');
			</script>
		</cfoutput>
	
	</cfif>

<!--- <cfelse>

	<cfoutput>
		<script>
			alert('#vOverlapMessage#');
		</script>
	</cfoutput>

</cfif> --->