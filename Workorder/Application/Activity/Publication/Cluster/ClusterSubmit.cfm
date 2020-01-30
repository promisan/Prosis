
<cf_tl id="This code is already in use!" var="vErrorInsert">

<cfif trim(url.code) eq "">

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	PublicationCluster
			WHERE	PublicationId = '#url.publicationId#'
			AND		Code = '#trim(Form.code)#'
	</cfquery>
	
	<cfif get.recordCount eq 0>

		<cfquery name="addCluster" 
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
						'#url.publicationId#',
						'#trim(Form.code)#',
						'#trim(Form.Description)#',
						'#trim(Form.ListingOrder)#',
						'#session.acc#',
						'#session.last#',
						'#session.first#'
					)
		</cfquery>
		
		<cfoutput>
			<script>
				validateCluster('#url.publicationId#', '#trim(Form.code)#');
				ColdFusion.Window.hide('mydialog');
			</script>
		</cfoutput>
		
	<cfelse>
	
		<cfoutput>
			<script>
				alert('#vErrorInsert#');
			</script>
		</cfoutput>
	
	</cfif>

<cfelse>

	<cfquery name="editCluster" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	PublicationCluster
			SET		Description = '#trim(Form.Description)#',
					ListingOrder = '#trim(Form.ListingOrder)#'
			WHERE	PublicationId = '#url.publicationId#'		
			AND		Code = '#url.code#'
	</cfquery>
	
	<cfoutput>
		<script>
			validateCluster('#url.publicationId#', '#trim(Form.code)#');
			ColdFusion.Window.hide('mydialog');
		</script>
	</cfoutput>

</cfif>