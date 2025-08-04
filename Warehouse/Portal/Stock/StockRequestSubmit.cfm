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

<!--- define the request status --->
<cfparam name="url.storageid"  default="">
<cfparam name="url.mode"       default="standard">

<cfoutput>	
  
	<!--- saving from a storage location for predefined items --->

	<cfquery name="get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	  	SELECT *
	    FROM   WarehouseLocation
		WHERE  Warehouse = '#url.shipto#'
		AND    StorageId = '#url.storageid#'
	</cfquery>  
	
	<!--- looping --->
	
	<cfquery name="getWhs" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Warehouse
			WHERE    Warehouse  = '#url.shipto#'			
	</cfquery>			
	
	<cfquery name="LocationList" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     WarehouseLocation
			WHERE    Warehouse  = '#getWhs.Warehouse#'
			<cfif get.Locationid eq "">
			AND      LocationId is NULL			
			<cfelse>
			AND      LocationId = '#get.Locationid#'							
			</cfif>
			<!--- AND      LocationClass = '#get.LocationClass#' --->
			AND      Operational = 1
	</cfquery>			
	
	<!--- ---------- --->
	<!--- validation --->
	
	<cfloop query="LocationList">
						
		<cfquery name="getItem" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   * 
			FROM     ItemWarehouseLocation
			WHERE    Warehouse  = '#Warehouse#'
			AND      Location   = '#Location#'			
			AND      Operational = 1
		</cfquery>		
				
		<cfloop query="getItem">
		
			<cfparam name="Form.requestquantity_#LocationList.Location#_#ItemNo#_#UoM#" default="0">
		
			<cfset qty      = evaluate("Form.requestquantity_#LocationList.Location#_#ItemNo#_#UoM#")>
					
			<!--- set status as cleared --->  
			<cfset status   = "2">
			
			<cfquery name="Item" 
				datasource= "AppsMaterials" 
				username  = "#SESSION.login#" 
				password  = "#SESSION.dbpw#">
			    SELECT *
				FROM   Item I, ItemUoM U
				WHERE  I.ItemNo = U.ItemNo
				AND    I.ItemNo = '#ItemNo#'
				AND    U.Uom    = '#UoM#'
			</cfquery>
			  
			<cfif Item.InitialApproval is 1>
			
			    <cfset status   = "i">
			
			  <cfelse>
			  
				<cfquery name="Category" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT *
				  FROM   Ref_Category 
				  WHERE  Category = '#Item.Category#'
				</cfquery>  
			  
			   <cfif Category.InitialReview is 1>
			       <!--- enforces a review in legacy screen --->
			       <cfset status   = "1">
			   </cfif>
			
			</cfif>
						
			<cfif qty gte "1">
			
			     <!--- apply the validation rule enabled for this object --->			
			
			     <cf_applyBusinessRule			 
				       datasource   = "appsMaterials" 
				       triggergroup = "itemlocation"
					   mission      = "#getWhs.mission#"
					   sourceid     = "#ItemLocationId#"
					   sourcevalue  = "#qty#">
				
				 <cfif _ValidationStopper eq "yes">
				 	<cfabort>
				 </cfif>	 
						
			</cfif>
			
		</cfloop>	
		
	</cfloop>			
		
	<!--- -------------------- --->
	<!--- ------- SAVING ----- --->
	<!--- -------------------- --->
	
	<cfparam name="FORM.requestremarks_#left(url.storageid,8)#" default="">
	
	<cfset remarks   = evaluate("FORM.requestremarks_#left(url.storageid,8)#")>
	<cfset category  = evaluate("FORM.usage_#left(url.storageid,8)#")>
	
	<cfloop query="LocationList">
	
		<!--- check if record exists already --->
		
		<cfquery name="getItem" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   * 
			FROM     ItemWarehouseLocation
			WHERE    Warehouse  = '#Warehouse#'
			AND      Location   = '#Location#'			
			AND      Operational = 1
		</cfquery>		
				
		<cfloop query="getItem">
		
			<cfparam name="Form.requestquantity_#left(storageid,8)#_#ItemNo#_#UoM#" default="0">
		
			<cfset qty = evaluate("Form.requestquantity_#LocationList.Location#_#ItemNo#_#UoM#")>			
						
			<cfif qty gt "0">
				
					<cfquery name="Check" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT *
						   FROM   WarehouseCart
						   WHERE  Warehouse       = '#url.warehouse#' 
						   AND    ItemNo          = '#ItemNo#' 
						   AND    UoM             = '#UoM#'
						   AND    UserAccount     = '#SESSION.acc#' 
						   AND    ShipToWarehouse = '#Warehouse#'
						   AND    ShipToLocation  = '#Location#'
						   <cfif Category neq "">
						   AND    Category        = '#Category#'  
						   <cfelse>
						   AND    Category IS NULL
						   </cfif>
					</cfquery>
							
					<cfif Check.recordCount eq "0">
					
						<cfquery name="getLocation" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT * 
							FROM   WarehouseLocation 
							WHERE  Warehouse = '#Warehouse#' 
							AND    Location  = '#Location#'				
						</cfquery>				
			
						<cfquery name="Insert" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO WarehouseCart (
									  Warehouse,
									  UserAccount, 
									  ItemNo,
									  UoM,
									  ShipToWarehouse,			
									  ShipToLocation,	  
									  <cfif getLocation.LocationId neq "">
									  ShipToLocationId,  			
									  </cfif>		
									  Category,				
									  Quantity,
									  CostPrice,
									  Status,
									  Remarks
									 )
							VALUES  ('#url.warehouse#',
							         '#SESSION.acc#', 
							         '#itemno#', 
							         '#uom#',							
									 '#Warehouse#',
									 '#Location#',	
									  <cfif getLocation.LocationId neq "">
									 '#getLocation.LocationId#',			
									 </cfif>		
									 <cfif Category neq "">									 
									 	'#Category#',							
									 <cfelse>
									 	NULL,
									 </cfif>
									 ROUND(#qty#,#item.itemprecision#),
									 '#Item.StandardCost#',
									 '#Status#',
									 '#remarks#')
						 </cfquery>
						
					<cfelse>
										 											
						<cfquery name="Update" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
						
							UPDATE WarehouseCart
							
							   SET Quantity        = Quantity + round(#qty#,#item.itemprecision#),
							       UserAccount     = '#SESSION.acc#',
								   Remarks         = '#remarks#'  							   
							WHERE  Cartid          = '#Check.CartId#'
							
						</cfquery>
							  
					</cfif>
															
					<!--- -------------------------------------------- --->
					<!--- update the underlying details for the amounts --->
					<!--- -------------------------------------------- --->
														
					<script language="JavaScript">
						if (document.getElementById("draft_#itemlocationid#")) {
							ColdFusion.navigate("#session.root#/warehouse/portal/Stock/InquiryWarehouseGetCart.cfm?itemlocationid=#itemlocationid#",'draft_#itemlocationid#')							
							}
					</script>					
									
			</cfif>
		
		 </cfloop>
			
	 </cfloop>
	 
	 <cfparam name="Form.Notification" default="0">
	 
	 <!--- ------------------------------------------------------------------------------------------------------ --->
	 <!--- here we trigger an email to the user which is tashed to submit the request for this warehouse/facility --->
	 <!--- ------------------------------------------------------------------------------------------------------ --->
			
	 <cfif form.notification eq "1">
	 
	 	<cfparam name="Form.SelectedUser" default="">
	
		<cfloop index="user" list="#Form.SelectedUser#">
																					
			<cfsavecontent variable="body">		
				<font face="Verdana" size="4" color="blue"><b><u>#ucase(session.welcome)# ALERT</u></b></font>
				<br><br>
				<font face="Verdana" size="2">
					A Stock replenishment request for <u>#getWhs.WarehouseName#</u> was prepared by #SESSION.first# #SESSION.last#.					
					<br><br>
					This request is now pending your review and submission.			
				</font>
				<br><br>					
			</cfsavecontent>
						
			<cf_mailsend class="Request" subject="#ucase('#SESSION.welcome# ALERT')#" referenceid="Stock Portal Request" 
			    ToClass="User" To="#user#" 												
				bodycontent="#body#">
							
		</cfloop>
		
	</cfif>	
	 
	<!--- ------------------------------------------------------------------------------------------------------ --->
		 
	<!--- items in the geo location and then we do a refresh --->
		
	<cfquery name="ItemsInGeo" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT   DISTINCT ItemNo, UoM 
			FROM     ItemWarehouseLocation
			WHERE    Warehouse  = '#get.Warehouse#'
			AND      Location IN (#QuotedValueList(LocationList.Location)#)
						
	</cfquery>									
	
	<!--- refreshing the header lines --->
	
	<cfloop query="ItemsInGeo">
	
	    <script>		    			 
		    if (document.getElementById("draft_#url.shipto#_#url.storageid#_#itemno#_#uom#")) {
				ColdFusion.navigate('#session.root#/warehouse/portal/Stock/InquiryWarehouseGetCartTotal.cfm?shipto=#url.shipto#&storageid=#url.storageid#&itemno=#itemno#&uom=#uom#','draft_#url.shipto#_#url.storageid#_#itemno#_#uom#')							
			}
		</script>
	
	</cfloop>

</cfoutput>

<script>		    	
		ColdFusion.Window.hide('dialogrequest')		
		// we also refresh the portal home screen to show request and refresh the yellow bar  
		se = document.getElementById('checkpending')
		if (se) {
		ColdFusion.navigate('#session.root#/warehouse/portal/checkout/checkPending.cfm?mission=#getWhs.mission#','checkpending')	
		}
</script>
	

