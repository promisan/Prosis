
<cfparam name="url.action" default="">
<cfparam name="url.warehouse" default="">


<cfif url.action eq "new">

	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.InspectionDate#">
	<cfset inspectionDate = dateValue>

	<cfquery name="InsertInspection" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 	INSERT INTO WarehouseLocationInspection
					( Warehouse,InspectionDate,Reference, Memo, EntityClass, ActionStatus, OfficerUserId, OfficerLastName, OfficerFirstName )
				VALUES
					( '#url.Warehouse#',#inspectionDate#, '#Form.reference#', '#Form.Memo#', '#Form.Workflow#', '0', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
			 
	</cfquery>
	
<cfelseif url.action eq "delete">

	<!--- make sure action status is 0 --->
	<cfquery name="Check" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT ActionStatus
			 FROM   WarehouseLocationInspection
			 WHERE  InspectionId = '#url.InspectionId#' 
	</cfquery>
	
	<cfif Check.recordcount eq 0>
		
		<cfset vMessage = "This record has been processed and it cannot be deleted">
		
		<cfoutput>
			<script language="javascript">
				alert("#vMessage#.");
			</script>
		</cfoutput>
	
	<cfelse>
	
		<!--- make sure action status is 0 --->
		<cfquery name="Delete" 
			 datasource="AppsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				DELETE 
				FROM   WarehouseLocationInspection
				WHERE  InspectionId = '#url.InspectionId#'
		</cfquery>
		
	</cfif>

</cfif>

<cfinclude template="InspectionListing.cfm">