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

<cfoutput>

<cfset url.value = replace(url.value," ","","ALL")> 
<cfset url.value = replace(url.value,",","","ALL")> 

<cfparam name="url.value" default="">

	<cfif url.AssetActionId eq "">
			
		<cfif not LSIsNumeric(url.value)>
			
			<script>
			    alert('You entered an incorrect numeric value : #url.value#')
			</script>	 		
			<cfabort>
			
		<cfelse>
		
			<script>				
			  document.getElementById('#url.field#').value = #numberformat(url.value,'_')#
			</script>	
			
		</cfif>
	
	<cfelse>		
	
		<cfif not LSIsNumeric(url.value)>
			
			<script>
			    alert('You entered an incorrect numeric value : #url.value#')
			</script>	 		
			<cfabort>
			
		<cfelse>
		
			<script>	  
			  document.getElementById('#url.field#').value = #numberformat(url.value,'_')#
			</script>	
			
		</cfif>
		
		<cfquery name="qAssetActionPrevious" 
			datasource = "AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 AIA.*, R.ValidationMode 
				FROM   AssetItemAction AIA, AssetItem A, Ref_Source R
				WHERE  AIA.AssetActionId = '#url.AssetActionId#' 		
				AND    AIA.AssetId       = A.AssetId
				AND    R.Code            = A.Source
		</cfquery>
		
		<cfif qAssetActionPrevious.ValidationMode eq "1">
			
			<cfquery name="getMetric" 
				datasource = "AppsMaterials"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_Metric
					WHERE  Code    = '#url.Metric#'		
			</cfquery>
					
			<cfif getMetric.Measurement eq "Cumulative">
							
						<cfquery name="getAction" 
							datasource = "AppsMaterials"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT TOP 1 * 
								FROM   AssetItemActionMetric
								WHERE  AssetActionId = '#url.AssetActionId#' 
								AND    Metric        = '#url.Metric#'
								AND    MetricValue IS NOT NULL
						</cfquery>
						
						<script>
							document.getElementById("addbutton").disabled = false
							document.getElementById("addbutton").className = "regular"
						</script>
						
						<cfif getAction.recordcount neq 0>	
						
						    #getMetric.Code# <cf_tl id="On">#DateFormat(qAssetActionPrevious.ActionDate,CLIENT.DateFormatShow)# :<b>#NumberFormat(getAction.MetricValue,'9,999.9')#</b>		
								
							<cfif url.value lte getAction.MetricValue>
								<script>
									document.getElementById('#url.box#').className = "highlight5 labelmedium"
									<cfif getAdministrator("*") eq "0">
										alert("PROBLEM \n\nYou recorded #NumberFormat(url.value,'9,999.9')# #getMetric.description#. \n\nThis reading is lower than previously recorded value of: \n\n #NumberFormat(getAction.MetricValue,'9,999.9')# #getMetric.description#. \n\n You must adjust the measurement before you may save this record.")
										document.getElementById("addbutton").disabled = true
										document.getElementById("addbutton").className = "hide"
									<cfelse>
										alert("ALERT \n\n#NumberFormat(url.value,'9,999.9')# #getMetric.description# is lower than previously recorded metric:\n\n#NumberFormat(getAction.MetricValue,'9,999.9')#")							
									</cfif>	
								</script>
							<cfelseif url.value gte getAction.MetricValue+500>	
								<script>
									document.getElementById('#url.box#').className = "highlight5 labelmedium"
									alert("#NumberFormat(url.value,'9,999.9')# #getMetric.description# exceeds the previous measurement #NumberFormat(getAction.MetricValue,'9,999.9')# by more than 500.")
								</script>	
							<cfelse>
							 	<script>
								document.getElementById('#url.box#').className = "regular labelit"
								</script>
							</cfif>
						
						<cfelse>
						
					    	<!--- no inputs --->
						
						</cfif>
								
				<cfelse>
					
					<cfquery name="getAction" 
						datasource = "AppsMaterials"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT TOP 1 * 
							FROM   AssetItemActionMetric
							WHERE  AssetActionId = '#url.AssetActionId#' 
							AND    Metric        = '#url.Metric#'
							AND    MetricValue IS NOT NULL
					</cfquery>
					
					<cfif getAction.recordcount neq 0>	
						
						#getMetric.Code# <cf_tl id="On">#DateFormat(qAssetActionPrevious.ActionDate,CLIENT.DateFormatShow)# :<b>#NumberFormat(getAction.MetricValue,'999,999,999.9')#</b>	
					
					</cfif>	
				
			</cfif>	 
				
		</cfif>	
		
	</cfif>

</cfoutput>	