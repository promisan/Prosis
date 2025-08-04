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
