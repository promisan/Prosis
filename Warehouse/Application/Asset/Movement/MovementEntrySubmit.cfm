
<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset DTE = #dateValue#>

<cfquery name="Movement" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   userQuery.dbo.#SESSION.acc#AssetMove2	
</cfquery>

<cfif Movement.recordcount gt "0">

<cftransaction>
	
	<cfquery name="MovementRecord" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 INSERT INTO AssetMovement
	 (MovementCategory, 
	  Mission,
	  Reference, 
	  <cfif Form.Location neq "">
	  Location,
	  </cfif>
	  OrgUnit,
	  PersonNo,
	  ActionStatus,
	  OfficerUserId, 
	  OfficerLastName, 
	  OfficerFirstName) 
	  
	 VALUES ('002',
	         '#URL.Mission#',
	         '#Form.Reference#',
			 <cfif Form.Location neq "">
			 '#Form.Location#',
			 </cfif>
			 '#Form.OrgUnit#',
			 '#Form.PersonNo#',
			 '0',
			 '#SESSION.acc#',
			 '#SESSION.last#',
			 '#SESSION.first#')
			 
	</cfquery>
	
	<cfquery name="SelectMovement" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT TOP 1 MovementId
	 FROM AssetMovement
	 WHERE OfficerUserId = '#SESSION.acc#'
	 ORDER BY Created DESC
	</cfquery>
	
	<cfset mid = "#SelectMovement.MovementId#">
	
	<!--- physical movement --->
	
	<cfif Form.Location neq "">
	
		<cfquery name="RemoveSame" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 DELETE FROM AssetItemLocation
		 WHERE AssetId IN (SELECT AssetId 
		                   FROM userQuery.dbo.#SESSION.acc#AssetMove2)
		 AND   DateEffective >= #dte#
		</cfquery>
	
		<cfquery name="InsertMovement" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 INSERT INTO AssetItemLocation
			 (AssetId, 
			 MovementId, 
			 Status, 
			 Location, 
			 DateEffective, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
		 SELECT AssetId, 
		        '#mid#', 
				'0', 
				'#Form.Location#',
				#dte#, 
				'#SESSION.acc#', 
				'#SESSION.last#', 
				'#SESSION.first#'
		 FROM userQuery.dbo.#SESSION.acc#AssetMove2
		</cfquery>
		
		<cfquery name="UpdateListing" 
		 datasource="appsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 UPDATE userQuery.dbo.#SESSION.acc#AssetBase#url.tbl#
		 SET    Location = '#Form.Location#',
			    LocationMovementId = '#mid#'
		 WHERE  AssetId IN (SELECT AssetId 
		                    FROM userQuery.dbo.#SESSION.acc#AssetMove2) 		 
		 AND    LocationEffective < #dte#
		 
		</cfquery>

</cfif>

<!--- organizational movement --->

<cfif Form.OrgUnit neq "" or Form.PersonNo neq "">
    
	<cfquery name="RemoveSame" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 DELETE FROM AssetItemOrganization
	 WHERE  AssetId IN (SELECT AssetId 
	                   FROM userQuery.dbo.#SESSION.acc#AssetMove2)
	 AND    DateEffective >= #dte#
	</cfquery>	

	<cfquery name="InsertMovement" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 INSERT INTO AssetItemOrganization
		 (AssetId, 
		  MovementId, 
		  ActionStatus, 
		  OrgUnit, 
		  PersonNo, 
		  DateEffective, 
		  OfficerUserId, 
		  OfficerLastName, 	  
		  OfficerFirstName)
	 SELECT AssetId, 
	        '#mid#', 
			'0', 
			<cfif Form.OrgUnit eq "">
			OrgUnit,
			<cfelse>
			'#Form.OrgUnit#',
			</cfif>
			<cfif Form.PersonNo eq "">
			PersonNo,
			<cfelse> 
			'#Form.PersonNo#', 
			</cfif>
			#dte#, 
			'#SESSION.acc#', 
			'#SESSION.last#', 
			'#SESSION.first#'
	 FROM userQuery.dbo.#SESSION.acc#AssetMove2
	</cfquery>
	
	<cfquery name="UpdateListing" 
	 datasource="appsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE userQuery.dbo.#SESSION.acc#AssetBase#url.tbl#
	 SET    OrgMovementId = '#mid#'
			<cfif form.OrgUnit neq "">
	        ,OrgUnit       = '#Form.OrgUnit#'
			</cfif>
			<cfif form.PersonNo neq "">
	        ,PersonNo      = '#Form.PersonNo#'		
		    </cfif>
	 WHERE AssetId IN (SELECT AssetId 
	                   FROM userQuery.dbo.#SESSION.acc#AssetMove2)
	 AND   DateEffective <= #dte# 	 
	</cfquery>

</cfif>

</cftransaction>

<cfset link = "Warehouse/Application/Asset/Movement/MovementView.cfm?movementId=#mid#">
		
		<cf_ActionListing 
		    EntityCode       = "AssMovement"
			EntityClass      = "Standard"
			EntityGroup      = ""
			EntityStatus     = ""
			Mission          = "#Movement.Mission#"			
			ObjectReference  = "Equipment Movement Request"
			ObjectReference2 = ""
		    ObjectKey4       = "#mid#"
			ObjectURL        = "#link#"
			Show             = "No"
			CompleteFirst    = "No">
			
</cfif>
  			
<cfoutput>

	<script language="JavaScript">
	   try { parent.opener.listreload('#url.id#','#url.id1#','#url.id2#','#url.page#','#url.sort#','#url.view#','#url.mde#') } catch(e) {}
	   parent.window.close()
	   // self.close()
	   // returnValue = 1
    </script>
	
</cfoutput>

