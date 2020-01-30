
<cfset form.movementMultiplier = replace(form.movementMultiplier,',','','ALL')>
<cf_tl id="The movement uom already exists!" var = "msg1">

<cfset vMovementDefault = 0>
<cfif isDefined("Form.movementDefault")>

	<cfset vMovementDefault = 1>
	
	<cfquery name="updateDefault" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			UPDATE 	ItemWarehouseLocationUoM
		 	SET		MovementDefault 	= 0
			WHERE	Warehouse		 	= '#url.warehouse#'
			AND     Location 			= '#url.location#'		
			AND		ItemNo 				= '#url.itemNo#'
			AND		UoM 				= '#url.UoM#'
	</cfquery>
	
</cfif>
	
<cfif url.movement eq "">

	<cfquery name="validate" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT	*
		FROM	ItemWarehouseLocationUoM
		WHERE	Warehouse = '#url.warehouse#'
		AND     Location = '#url.location#'		
		AND		ItemNo = '#url.itemNo#'
		AND		UoM = '#url.UoM#'
		AND		MovementUoM = '#form.movementUoM#'
	</cfquery>

	<cfif validate.recordCount eq 0>

		<cfquery name="insert" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				 INSERT INTO ItemWarehouseLocationUoM
				 	(
						Warehouse,
						Location,
						ItemNo,
						UoM,
						MovementUoM,
						MovementMultiplier,
						MovementDefault,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName
					)
				 VALUES
				 	(
						'#url.warehouse#',
						'#url.location#',
						'#url.itemNo#',
						'#url.uom#',
						'#form.movementUoM#',
						#Form.movementMultiplier#,
						#vMovementDefault#,
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
					)
		</cfquery>
		
		<cfoutput>
			<script>
				ColdFusion.Window.hide('mydialog');
				ColdFusion.navigate('../LocationUoM/LocationUoM.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','contentbox2');
			</script>
		</cfoutput>
	
	<cfelse>
		<cfoutput>
			<script>
				alert('#msg1#');
			</script>
		</cfoutput>
	</cfif>

<cfelse>
	
	<cfquery name="update" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
			UPDATE 	ItemWarehouseLocationUoM
		 	SET		MovementMultiplier 	= #form.movementMultiplier#,
					MovementDefault 	= #vMovementDefault#
			WHERE	Warehouse		 	= '#url.warehouse#'
			AND     Location 			= '#url.location#'		
			AND		ItemNo 				= '#url.itemNo#'
			AND		UoM 				= '#url.UoM#'
			AND		MovementUoM 		= '#form.movementUoM#'
	</cfquery>

	<cfoutput>
			<script>
				ColdFusion.Window.hide('mydialog');
				ColdFusion.navigate('../LocationUoM/LocationUoM.cfm?warehouse=#url.warehouse#&location=#url.location#&itemNo=#url.itemno#&UoM=#url.uom#','contentbox2');
			</script>
		</cfoutput>

</cfif>