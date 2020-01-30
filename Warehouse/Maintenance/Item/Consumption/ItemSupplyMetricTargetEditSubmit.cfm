
<cfparam name="url.type" default="Item">

<cfset vField = "ItemNo">
<cfset vPrefix = "">
<cfset vLabel = "Master">

<cfif url.type eq "AssetItem">
	<cfset vField = "AssetId">
	<cfset vPrefix = "Asset">
	<cfset vLabel = "Asset">
	
	<cfset dateValue = "">
	<cf_DateConvert Value="#form.dateEffective#">
	<cfset vDateEffective = dateValue>
</cfif>


<cftry>

	<cfquery name="insertMetric" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  	INSERT INTO #vPrefix#ItemSupplyMetric
			(#vField#,
			SupplyItemNo,
			SupplyItemUoM,
			Metric,
			TargetRatio,
	  		OfficerUserId,
		 	OfficerLastName,
			OfficerFirstName)					
		VALUES ('#url.id#',
			  '#url.SupplyItemNo#',
			  '#url.SupplyItemUom#',
			  '#url.metric#',
			  0,			  
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#')
	</cfquery>

	<cfcatch></cfcatch>
	
</cftry>

<cfset factorList = "0,25,50,75,100">

<cfquery name="Validate" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	#vPrefix#ItemSupplyMetricTarget
	WHERE 	#vField#      = '#URL.id#'
	AND   	SupplyItemNo  = '#url.SupplyItemNo#'
	AND		SupplyItemUom = '#url.SupplyItemUom#'
	AND		Metric        = '#url.metric#'
	<cfif url.type eq "Item">
	AND 	Mission       = '#Form.mission#'
	AND		Location	  <cfif trim(form.location) eq "">IS NULL<cfelse>= '#Form.location#'</cfif>
	</cfif>
	<cfif url.type eq "AssetItem">
	AND		DateEffective = #vDateEffective#
	</cfif>
</cfquery>

<cfquery name="getMetric" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	#vPrefix#ItemSupplyMetric
	WHERE 	#vField#      = '#URL.id#'
	AND   	SupplyItemNo  = '#url.SupplyItemNo#'
	AND		SupplyItemUom = '#url.SupplyItemUom#'
	AND		Metric        = '#url.metric#'
</cfquery>

<cfset vMetricQuantity = getMetric.MetricQuantity>

<cfif url.action eq "new">
	
	<cfif validate.recordCount eq 0>
	
		<cfloop index="factor" list="#factorList#">
			
			<cf_AssignId>
			<cfset vFunctionId = rowguid>
			
			<cfset vTargetRatio = 0>
			<cfif isDefined("Form.TargetRatio_#factor#")>
				<cfset vTargetRatio = Evaluate("Form.TargetRatio_#factor#")>
				<cfset vTargetRatio = replace(vTargetRatio,',','','ALL')>
			</cfif>
			
			<cfset vTargetRange = 10>
			<cfif isDefined("Form.TargetRange_#factor#")>
				<cfset vTargetRange = Evaluate("Form.TargetRange_#factor#")>
				<cfset vTargetRange = replace(vTargetRange,',','','ALL')>
			</cfif>
			
			<cfquery name="insert" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  	INSERT INTO #vPrefix#ItemSupplyMetricTarget
					(
					TargetId,
					#vField#,
					SupplyItemNo,
					SupplyItemUoM,
					Metric,
					<cfif url.type eq "Item">
					Mission,
					<cfif trim(form.location) neq "">Location,</cfif>
					</cfif>
					<cfif url.type eq "AssetItem">
					DateEffective,
					</cfif>
					OperationMode,
					TargetRatio,
					TargetDirection,
					TargetRange,
			  		OfficerUserId,
				 	OfficerLastName,
					OfficerFirstName,
					Created)					
				VALUES (
					  '#vFunctionId#',
					  '#url.id#',
					  '#url.SupplyItemNo#',
					  '#url.SupplyItemUoM#',
					  '#url.metric#',
					  <cfif url.type eq "Item">
					  '#Form.mission#',
					  <cfif trim(form.location) neq "">'#Form.location#',</cfif>
					  </cfif>
					  <cfif url.type eq "AssetItem">
					  #vDateEffective#,
					  </cfif>
					  '#factor#',
					  #vTargetRatio / vMetricQuantity#,
					  '#Evaluate("Form.TargetDirection_#factor#")#',  
					  #vTargetRange#,
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#',
					  getDate())
			</cfquery>
		
		</cfloop>
		
		<cfoutput>
			<script>
				ColdFusion.navigate('Consumption/ItemSupplyEdit.cfm?type=#url.type#&id=#url.id#&supply=#url.supplyitemno#&uom=#url.supplyitemuom#&ts='+new Date().getTime(),'mydialog'); 
			</script>
		</cfoutput>
	
	<cfelse>
		
		<cfset vMessage = "">
		
		<cfif url.type eq "Item">
			<cfset vMessage = "Location already defined for this metric.">
		</cfif>
		
		<cfif url.type eq "AssetItem">
			<cfset vMessage = "Date already defined for this metric.">
		</cfif>
		
		<cfoutput>
			<script>
				alert('#vMessage#');
				ColdFusion.navigate('Consumption/ItemSupplyEdit.cfm?type=#url.type#&id=#url.id#&supply=#url.supplyitemno#&uom=#url.supplyitemuom#&ts='+new Date().getTime(),'mydialog'); 
			</script>
		</cfoutput>
	
	</cfif>

<cfelse>
	
	<cfloop index="factor" list="#factorList#">
	
		<cfset vTargetRatio = 0>
		<cfif isDefined("Form.TargetRatio_#factor#")>
			<cfset vTargetRatio = Evaluate("Form.TargetRatio_#factor#")>
			<cfset vTargetRatio = replace(vTargetRatio,',','','ALL')>
		</cfif>
		
		<cfset vTargetId = "">
		<cfif isDefined("Form.TargetId_#factor#")>
			<cfset vTargetId = Evaluate("Form.TargetId_#factor#")>
		</cfif>
		
		<cfset vTargetRange = 10>
		<cfif isDefined("Form.TargetRange_#factor#")>
			<cfset vTargetRange = Evaluate("Form.TargetRange_#factor#")>
			<cfset vTargetRange = replace(vTargetRange,',','','ALL')>
		</cfif>
	
		<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE 	#vPrefix#ItemSupplyMetricTarget
			SET 	
				TargetRatio     = #vTargetRatio / vMetricQuantity#,
				TargetDirection = '#Evaluate("Form.TargetDirection_#factor#")#',
				TargetRange     = #vTargetRange#,
				OperationMode   = #factor#,
				<cfif url.type eq "Item">
				Mission         = '#Form.mission#',
				Location	    = <cfif trim(form.location) eq "">NULL<cfelse>'#Form.location#'</cfif>
				</cfif>
				<cfif url.type eq "AssetItem">
				DateEffective	= #vDateEffective#
				</cfif>
			WHERE 		
				TargetId 	  <cfif vTargetId eq "">IS NULL<cfelse>= '#vTargetId#'</cfif>
		</cfquery>
	
	</cfloop>
	
	<cfoutput>
		<script>
			ColdFusion.navigate('Consumption/ItemSupplyEdit.cfm?type=#url.type#&id=#url.id#&supply=#url.supplyitemno#&uom=#url.supplyitemuom#&ts='+new Date().getTime(),'mydialog'); 
		</script>
	</cfoutput>

</cfif>