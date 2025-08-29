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