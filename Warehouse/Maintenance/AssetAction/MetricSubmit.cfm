
<cftransaction>

<!--- INSERT CATEGORIES --->
<cfquery name="Category" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM	Ref_Category
</cfquery>

<cfoutput query="Category">
	
	<cfset vcategory = replace('#category#',' ', '', 'ALL')>
	<cfif isDefined('Form.cat_#vcategory#')>
	
		<cftry>
		
			<cfquery name="insertCategory" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  	INSERT INTO Ref_AssetActionCategory
						(ActionCategory,
						Category,
				  		OfficerUserId,
					 	OfficerLastName,
						OfficerFirstName)					
					VALUES ('#url.id1#',
						  '#Category#',					  
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
			</cfquery>
		
			<cfcatch></cfcatch>
		</cftry>
		
		<!--- INSERT METRICS --->
		<cfquery name="Metric" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	Ref_Metric
		</cfquery>
		
		<cfloop query="Metric">
			<cfset vmetric = replace('#code#',' ', '', 'ALL')>
			<cfif isDefined('Form.met_#vcategory#_#code#')>
			
				<cftry>
			
					<cfquery name="insertMetric" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  	INSERT INTO Ref_AssetActionMetric
							(ActionCategory,
							Category,
							Metric,
					  		OfficerUserId,
						 	OfficerLastName,
							OfficerFirstName)					
						VALUES ('#url.id1#',
							  '#Category.category#',
							  '#code#',					  
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#')
					</cfquery>
				
					<cfcatch></cfcatch>
				</cftry>
				
			<cfelse>
			
				<cfquery name="deleteMetric" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  	DELETE 
					FROM	Ref_AssetActionMetric
					WHERE	ActionCategory = '#url.id1#'
					AND		Category = '#Category.category#'
					AND		Metric = '#code#'
				</cfquery>
			
			</cfif>
		</cfloop>
		
	<cfelse>
	
		<cfquery name="deleteCategory" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  	DELETE 
			FROM	Ref_AssetActionCategory
			WHERE	ActionCategory = '#url.id1#'
			AND		Category = '#category#'
		</cfquery>
		
		
	</cfif>	
	
</cfoutput>


</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('MetricListing.cfm?idmenu=#url.idmenu#&id1=#url.id1#','contentbox2')
	</script>
</cfoutput> 
