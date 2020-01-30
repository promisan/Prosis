<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Execution Queries">
	
	<cffunction name="checklot"
             access="public"
             returntype="any"
             displayname="Verify Lots">
		
		<cfargument name="Mission"   type="string"  required="false"  default="">
		<cfargument name="TransactionLot"  type="string"  required="true"   default="0">
		
		<cfquery name="getLot" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProductionLot
			WHERE     Mission        = '#Mission#' 			
			AND       TransactionLot = '#TransactionLot#'			
		</cfquery>		
						
		<cfreturn getLot.recordcount>
		
	</cffunction>	
	
	<cffunction name="addlot"
             access="public"
             returntype="any"
             displayname="Verify Lots">
		
		<cfargument name="Datasource"          type="string"  required="true"  default="AppsMaterials">
		<cfargument name="Mission"             type="string"  required="true"  default="">
		<cfargument name="TransactionLot"      type="string"  required="true"   default="0">
		<cfargument name="TransactionLotDate"  type="string"  required="true"   default="#dateformat(now(),client.dateformatshow)#">
		<cfargument name="OrgUnitVendor"       type="string" default="0">
		
		 <cfset dateValue = "">
		<CF_DateConvert Value="#TransactionLotDate#">
		<cfset dte = dateValue>
		
		<cfquery name="getLot" 
			datasource="#datasource#" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Materials.dbo.ProductionLot
			WHERE     Mission        = '#Mission#' 			
			AND       TransactionLot = '#TransactionLot#'			
		</cfquery>		
		
		<cfif getLot.recordcount eq "0">
		
			<cfquery name="addLot" 
				datasource="#datasource#" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO Materials.dbo.ProductionLot
				(Mission,TransactionLot,TransactionLotDate,OrgUnitVendor,OfficerUserId,OfficerLastName,OfficerFirstName)
				VALUES
					('#mission#',
					 '#TransactionLot#',
					 #dte#,
					 '#OrgUnitVendor#',
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#')			
			</cfquery>		
		
		</cfif>				
		
	</cffunction>	
	
</cfcomponent>	
