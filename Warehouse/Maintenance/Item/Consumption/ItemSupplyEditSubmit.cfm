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

<cfset vField = "ItemNo">
<cfset vPrefix = "">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
</cfif>

<cfquery name="Check" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	#vPrefix#ItemSupply	
	WHERE 	#vField# = '#URL.id#'
	AND   	SupplyItemNo = '#Form.ItemNo#'
	AND		SupplyItemUoM = '#Form.ItemUoM#'
</cfquery>

<cfset Form.SupplyCapacity = replace(Form.SupplyCapacity, ",", "", "ALL")>
<cfset Form.SupplyDailyUsage = replace(Form.SupplyDailyUsage, ",", "", "ALL")>
<cfoutput>

<cf_tl id = "Supply already exists. Operation aborted" var = "vAlready">

<cfif ParameterExists(Form.Insert)> 	
	
	<cftransaction>
	
		<cfif Check.recordCount neq 0>
		
			<cfset displayMessage = 1>
			
			<cfif url.type eq "AssetItem" and isDefined("Form.autoInserted")>
				<cfif Form.autoInserted eq 1>
					<cfset displayMessage = 0>
					
					<cfquery name="Update" 
						datasource="appsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE #vPrefix#ItemSupply
							SET 
								SupplyCapacity   = #Form.SupplyCapacity#,
								SupplyDailyUsage = #Form.SupplyDailyUsage#
						WHERE 	#vField#         = '#URL.id#'
						AND   	SupplyItemNo  = '#form.itemNo#'
						AND		SupplyItemUom = '#form.ItemUoM#'
				    </cfquery>
					
				</cfif>
			</cfif>
			
		<cfelse>
		
			<cfset displayMessage = 0>
		
			<cfquery name="Insert" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO #vPrefix#ItemSupply
			         (
					  #vField#,
					  SupplyItemNo,
					  SupplyItemUoM,
					  SupplyCapacity,
					  SupplyDailyUsage,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName
					 )
			  VALUES (
			  		  '#URL.ID#',
			          '#Form.ItemNo#',
					  '#Form.ItemUoM#',
					  #Form.SupplyCapacity#,
					  #Form.SupplyDailyUsage#,
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#'
					 )
			  </cfquery>
			  
		</cfif>
		
		<cfif displayMessage eq 0>
		
			<!--- INSERT METRICS --->
			<cfquery name="ClearMetrics" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					DELETE FROM #vPrefix#ItemSupplyMetric
					WHERE 	#vField#      = '#URL.id#'
					AND   	SupplyItemNo  = '#Form.ItemNo#'
					AND		SupplyItemUom = '#Form.ItemUoM#'
			</cfquery>
			
			<cfquery name="Metric" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM	Ref_Metric				
			</cfquery>
			
			<cfloop query="Metric">
				<cfset vmetric = replace('#code#',' ', '', 'ALL')>
				
				<cfset vratio = evaluate("ratio_#code#")>
				<cfset vratio = replace(vratio,',','','ALL')>
				
				<cfset vmetricQuantity = evaluate("metricQuantity_#code#")>
				<cfset vmetricQuantity = replace(vmetricQuantity,',','','ALL')>
				
				<cfset vTargetDirection = evaluate("TargetDirection_#code#")>
				
				<cfset vTargetRange = evaluate("TargetRange_#code#")>
				<cfset vTargetRange = replace(vTargetRange,',','','ALL')>
				
				<cfif isDefined('Form.met_#vmetric#')>
				
					<cfquery name="insertCategory" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO #vPrefix#ItemSupplyMetric
								(
									#vField#,
									SupplyItemNo,
									SupplyItemUoM,
									Metric,
									MetricQuantity,
									TargetRatio,
									TargetDirection,
									TargetRange,
									OfficerUserId,
									OfficerLastName,
									OfficerFirstName
								)					
							VALUES 
								(
									'#url.id#',
									'#Form.ItemNo#',
									'#Form.ItemUoM#',
									'#code#',
									#vmetricQuantity#,
									#vratio / vmetricQuantity#,	
									'#vTargetDirection#',
									#vTargetRange#,
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#'
								)
					</cfquery>
				
				</cfif>
			</cfloop>
		
		</cfif>
		
	</cftransaction>

	<cfif displayMessage eq 1>
		<cfoutput>
			<script>
				alert("#vAlready#")
			</script>
		</cfoutput>
	<cfelse>
		<cfoutput>
			<script>
				ptoken.navigate('#session.root#/warehouse/maintenance/item/Consumption/ItemSupplyListing.cfm?type=#url.type#&id=#url.id#','supplylist');
				ColdFusion.Window.hide('mydialog');
			</script>	
		</cfoutput>
	</cfif>
		  
<cfelseif ParameterExists(Form.Update)>

	<cfif Check.recordCount neq 0 and url.supply neq form.ItemNo>
	
		<script>
		   alert("#vAlready#")
		</script>		
		
	<cfelse>

		<cftransaction>
		
		<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE #vPrefix#ItemSupply
			SET 
				SupplyItemNo     = '#Form.ItemNo#',
				SupplyItemUoM    = '#Form.ItemUoM#',
				SupplyCapacity   = #Form.SupplyCapacity#,
				SupplyDailyUsage = #Form.SupplyDailyUsage#
		WHERE 	#vField#         = '#URL.id#'
		AND   	SupplyItemNo  = '#URL.supply#'
		AND		SupplyItemUom = '#URL.uom#'
	    </cfquery>
		
		<!--- UPDATE METRICS --->
	  		  
		<cfquery name="Metric" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM	Ref_Metric				
		</cfquery>
		
		<cfloop query="Metric">
			<cfset vmetric = replace('#code#',' ', '', 'ALL')>
			
			<cfset vratio = evaluate("ratio_#code#")>
			<cfset vratio = replace(vratio,',','','ALL')>
			
			<cfset vmetricQuantity = evaluate("metricQuantity_#code#")>
			<cfset vmetricQuantity = replace(vmetricQuantity,',','','ALL')>
			
			<cfset vTargetDirection = evaluate("TargetDirection_#code#")>
				
			<cfset vTargetRange = evaluate("TargetRange_#code#")>
			<cfset vTargetRange = replace(vTargetRange,',','','ALL')>
			
			<cfif isDefined('Form.met_#vmetric#')>
				
				<cftry>
					<cfquery name="insert" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  	INSERT INTO #vPrefix#ItemSupplyMetric
							(
							#vField#,
							SupplyItemNo,
							SupplyItemUoM,
							Metric,
							MetricQuantity,
							TargetRatio,
							TargetDirection,
							TargetRange,
					  		OfficerUserId,
						 	OfficerLastName,
							OfficerFirstName
							)					
						VALUES (
						      '#url.id#',
							  '#Form.ItemNo#',
							  '#Form.ItemUoM#',
							  '#code#',
							  #vmetricQuantity#,
							  #vratio / vmetricQuantity#,
							  '#vTargetDirection#',
							  #vTargetRange#,
							  '#SESSION.acc#',
							  '#SESSION.last#',
							  '#SESSION.first#'
							  )
					</cfquery>
					
					<cfcatch>
						<cfquery name="update" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							UPDATE 	#vPrefix#ItemSupplyMetric
							SET		TargetRatio     = #vratio / vmetricQuantity#,
									MetricQuantity  = #vmetricQuantity#,
									TargetDirection = '#vTargetDirection#',
									TargetRange     = #vTargetRange#
							WHERE 	#vField#        = '#URL.id#'
							AND   	SupplyItemNo    = '#Form.ItemNo#'
							AND		SupplyItemUom   = '#Form.ItemUoM#'
							AND		Metric          = '#code#'
						</cfquery>
					</cfcatch>
				
				</cftry>
				
			<cfelse>
			
				<cftry>
				
				  	<cfquery name="delete" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE FROM #vPrefix#ItemSupplyMetric
						WHERE 	#vField#        = '#URL.id#'
						AND   	SupplyItemNo  = '#Form.ItemNo#'
						AND		SupplyItemUom = '#Form.ItemUoM#'
						AND		Metric        = '#code#'
					</cfquery>
					
					<cfcatch></cfcatch>
					
				</cftry>
			
			</cfif>
		</cfloop>
		
		</cftransaction>
		
		<cfoutput>
			<script>
				ptoken.navigate('#session.root#/warehouse/maintenance/item/Consumption/ItemSupplyListing.cfm?type=#url.type#&id=#url.id#','supplylist');
				ColdFusion.Window.hide('mydialog');
			</script>	
		</cfoutput>
	
	</cfif>
	
<cfelseif ParameterExists(Form.Delete)> 

	<cfquery name="Delete" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM #vPrefix#ItemSupply
		WHERE   #vField#      = '#URL.id#'
		AND     SupplyItemNo  = '#URL.supply#'
		AND		SupplyItemUom = '#URL.uom#' 
    </cfquery>	
	
	<cfoutput>
		<script>
			ptoken.navigate('#session.root#/warehouse/maintenance/item/Consumption/ItemSupplyListing.cfm?type=#url.type#&id=#url.id#','supplylist');
			ProsisUI.closeWindow('mydialog');
		</script>	
	</cfoutput>

</cfif>		 

</cfoutput>