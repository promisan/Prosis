
<!--- add associations --->

	<cfloop from="1" to="#url.elements#" index="i">

		<cfset element = Evaluate("Form.element_#i#")>
		
		<!--- check if the element is an association source ---->
		<cfquery name="AssociationSource" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  EC.AssociationSource Value
			FROM    Element E
			INNER   JOIN    Ref_ElementClass EC
	                ON      E.ElementClass = EC.Code
			WHERE   ElementId = '#element#'
		</cfquery>
		
		<cfif AssociationSource.Value neq 1>
		
			<cfset document = Evaluate("Form.document_#i#")>
		
			<!--- validates if the document is already associated to the case file --->
			<cfquery name="AssociateDocument" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   ClaimElement
				WHERE  ElementId = '#document#'
				AND    ClaimId   = '#url.claimid#'
			</cfquery>
		
			<cfif AssociateDocument.recordcount eq 0  >
			
				<cfquery name="AssociateDocument" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 INSERT INTO ClaimElement
						 	(ClaimId,
							 ElementId,
							 OfficerUserId,
							 OfficerLastName,
							 OfficerFirstName)	
					 VALUES
						('#url.claimid#','#document#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')	
					</cfquery>
					
			</cfif>
		
		</cfif>
			
		<cfquery name="AssociateElement" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 INSERT INTO ClaimElement
			 	(ClaimId,
				 ElementId,
				 <cfif AssociationSource.Value neq 1>
				 SourceElementId,
				 </cfif>
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)	
		 VALUES
			('#url.claimid#',
			 '#element#',
			 <cfif AssociationSource.Value neq 1>
			 '#document#',
			 </cfif>
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')	
		</cfquery>
		
	</cfloop>

						
	<cfoutput>
	
		<script>	
		
		    try {
			parent.listingcontent.applyfilter('1','','content')
			} catch(e) {}
			// opener.document.getElementById("listingrefresh").click()	   		
			ColdFusion.Window.hide('addElements')
			
		</script>
		
	</cfoutput>		
				

