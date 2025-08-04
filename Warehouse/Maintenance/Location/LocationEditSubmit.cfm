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

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = dateValue>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
	  <CF_DateConvert Value="#Form.DateExpiration#">
	  <cfset END = dateValue>
<cfelse>
	  <cfset END = 'NULL'>
</cfif>	

<cfparam name="form.stocklocation" default="0">

<cfif Len(Form.Remarks) gt 100>
	  <cfset remarks = left(Form.Remarks,100)>
<cfelse>
	  <cfset remarks = Form.Remarks>
</cfif>  

<cfif ParameterExists(Form.Update)>

		<!--- Remove quotes from Organization Name (can affect tree view)--->
		<cfset LocName=Replace(Form.LocationNameEdit,'"','','ALL')>
		<cfset LocName=Replace(LocName,"'","",'ALL')>
				
		<cfset Parent = "#Form.ParentLocation#">
				
		<cfquery name="Check" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Location
			WHERE  Location = '#Form.Location#'
		</cfquery>
		
		<cfif Check.ParentLocation eq "" and Form.ParentLocation neq "root"> <!--- was a root unit --->
		
			<cfquery name="Check2" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Location
			WHERE  Location = '#Form.ParentLocation#'
			</cfquery>
			
			<cfif Check2.ParentLocation eq "#Check.Location#">
			   <cfset Parent = "reset">
			</cfif> 
		
		</cfif>
		
		<cfif Form.OrgUnit neq "">
		
				<cfquery name="Org" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT MissionOrgUnitId
				FROM Organization
				WHERE OrgUnit = '#FORM.OrgUnit#'
				</cfquery>
		
		</cfif>
					   
		<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Location
		SET     LocationClass    = '#Form.LocationClassEdit#',
				LocationCode     = '#Form.LocationCode#',
				LocationName     = '#LocName#',
				Country          = '#Form.Country#', 
				AddressCity      = '#Form.AddressCity#',
				Address          = '#Form.Address#',
				Latitude         = '#Form.cLatitude#', 
				Longitude        = '#Form.cLongitude#',
				DateEffective    = #STR#,
				DateExpiration   = #END#,
				TreeOrder        = '#Form.TreeOrder#',
				StockLocation    = '#Form.StockLocation#',
				PersonNo         = '#Form.PersonNo#',
				<cfif Form.OrgUnit neq "">
					MissionOrgUnitId = '#Org.MissionOrgUnitId#', 
				</cfif>
				<cfif Parent eq "reset">
					ParentLocation = NULL,
				<cfelse>
					<cfif parent eq "Root">
						 ParentLocation   = NULL,
					<cfelse>
					     ParentLocation   = '#Form.ParentLocation#',
					</cfif>
				</cfif>
				<cfif Form.ParentLocationOld neq Form.ParentLocation>
				HierarchyCode = '',
				</cfif>
				Remarks          = '#remarks#'
		WHERE Location = '#Form.Location#'
		</cfquery>
						
		<cfif Form.ParentLocationOld neq Form.ParentLocation>
					
			<cfset #URL.Mis#   = "#Form.Mission#">
						
			<cfinclude template="LocationHierarchy.cfm">
				
		</cfif>
		
				
		<script language="JavaScript">
		   parent.parent.right.history.go()
		   parent.parent.ColdFusion.Window.destroy('mylocation',true)   
		</script>	
		
</cfif>	

<cfif ParameterExists(Form.Delete)> 
	
	<cfset st = "Go">	
		
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#LocDelete">
	
	<cfquery name="Verify" 
	      datasource="AppsMaterials" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT Location as Id
		  INTO   userQuery.dbo.tmp#SESSION.acc#LocDelete
	      FROM   Location
	      WHERE  Location = '#Form.Location#' 
	</cfquery>
	
	<cfloop index="Itm" from="1" to="6">
	
		<cfquery name="Level01" 
		      datasource="AppsMaterials" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
		      INSERT INTO UserQuery.dbo.tmp#SESSION.acc#LocDelete (Id)
			  SELECT Location
		      FROM   Location
		      WHERE  ParentLocation IN (SELECT DISTINCT Id 
			                            FROM UserQuery.dbo.tmp#SESSION.acc#LocDelete)
		      AND    Mission = '#Form.Mission#'
		</cfquery>
	
	</cfloop>	
		
	<cfquery name="CountRec" 
      datasource="appsMaterials" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM   AssetItemLocation
      WHERE  Location IN (SELECT Id 
	                      FROM   UserQuery.dbo.tmp#SESSION.acc#LocDelete)
	  
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">
	       alert("Location is in use. Operation aborted.")
		 </script>  
	 
    <cfelse>
	
		<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM ItemVendorOffer			
			WHERE  LocationId IN  (SELECT Id 
			                       FROM userQuery.dbo.tmp#SESSION.acc#LocDelete)
	    </cfquery>
	
		<cfquery name="Update" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Warehouse
			SET    LocationId = NULL
			WHERE  LocationId IN  (SELECT Id 
			                       FROM userQuery.dbo.tmp#SESSION.acc#LocDelete)
	    </cfquery>
	
		<cfquery name="Delete" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM Location
			WHERE Location IN  (SELECT Id 
			                    FROM userQuery.dbo.tmp#SESSION.acc#LocDelete)
	    </cfquery>
	
	</cfif>	
	
		
	<script language="JavaScript">
	   parent.parent.right.history.go()
	   parent.parent.document.getElementById('refresh').click()
	   parent.parent.ColdFusion.Window.destroy('mylocation',true)   
	</script>	
					
</cfif>	

