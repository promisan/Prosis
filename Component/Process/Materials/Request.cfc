<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Stock requests">
	
	<cffunction name="addRequestHeader"
             access="public"
             returntype="struct"
             displayname="Create Request header">
					
			<cfargument name = "Mission"    		type="string"  required="true"   default="">					
								
			<cfargument name = "CustomerId"		    type="GUID"    required="false"  default="00000000-0000-0000-0000-000000000000">				
			<cfargument name = "ProgramCode" 	    type="string"  required="false"  default="">											
			<cfargument name = "Category"  		    type="string"  required="false"  default="">	
			<cfargument name = "OrgUnit"            type="numeric" default="0">														
			<cfargument name = "Contact"     		type="string"  required="false"  default="">				
			<cfargument name = "RequestType"		type="string"  required="true"   default="">													
   			<cfargument name = "RequestAction"		type="string"  required="true"   default="">
			
			<cfargument name = "RequestShipToMode"	type="string"  required="true"   default="Deliver">
			<cfargument name = "EntityClass"	    type="string"  required="false"  default="">
			<cfargument name = "DateDue"	        type="string"  required="false"  default="#dateformat(now(),client.dateformatshow)#">
			<cfargument name = "Address1"	        type="string"  required="false"  default="">
			<cfargument name = "Address2"	        type="string"  required="false"  default="">
			<cfargument name = "City"	            type="string"  required="false"  default="">
			<cfargument name = "PortalCode"	        type="string"  required="false"  default="">
			<cfargument name = "State"	            type="string"  required="false"  default="">
			<cfargument name = "Country"	        type="string"  required="false"  default="">
			<cfargument name = "TelephoneNo"        type="string"  required="false"  default="">
			<cfargument name = "eMailAddress"       type="string"  required="false"  default="">
			<cfargument name = "Remarks"            type="string"  required="false"  default="">
			<cfargument name = "ActionStatus"       type="string"  required="false"  default="1">
			
			<!--- if reference is "" we defined it --->
			
			<cfinvoke component = "Service.Process.Materials.setReference"  
			   method           = "RequestSerialNo" 
			   mission          = "#mission#" 	  
			   returnvariable   = "reqno">
			   
			 <cfquery name="Check" 
			     datasource="AppsMaterials" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			      SELECT *
			      FROM   RequestHeader
				  WHERE  Reference = '#reqno#'
			 </cfquery>
				 
			 <cfif Check.recordcount eq "1">
			    
			     <cfoutput>
				 	 <cf_tl id = "Assigned Reference" var ="vAssigned">
					 <cf_tl id = "is already in use. Please try to submit again." var = "vAlready">
			  	     <cf_alert message = "#vAssigned# #reqno# #vAlready#">
				     <cfabort>
				 </cfoutput>
			  
			 </cfif>	
			 
			 <!--- created header --->
	
			<cfset dateValue = "">
			<CF_DateConvert Value="#datedue#">
			<cfset dte = dateValue>
			
			<cfquery name="Workflow" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Ref_RequestWorkflow	
				WHERE  RequestType   = '#RequestType#'	
				AND    RequestAction = '#RequestAction#'
			</cfquery>
			
			<cf_assignid>
			
			<!--- populate table --->
			
			<cfquery name="InsertHeader" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO RequestHeader 
			       (Reference, 
					Mission,
					RequestHeaderid,
					CustomerId,
					RequestShipToMode,
					RequestType,
					RequestAction,
					EntityClass,
					ProgramCode,
					Category,
					OrgUnit,
					Contact,
					DateDue,
					EMailAddress,
					Address1,		
					City,		
					Remarks,
					ActionStatus,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
			VALUES ('#reqno#', 
			        '#mission#',
					'#rowguid#',
					<cfif customerid eq "00000000-0000-0000-0000-000000000000">
					NULL,
					<cfelse>
					'#customerid#',
					</cfif>
					'#RequestShipToMode#',
			        '#RequestType#',
				    '#RequestAction#',
				    '#workflow.entityclass#',
					'#ProgramCode#',
					<cfif Category eq "">
					NULL,
					<cfelse>
					'#Form.Category#',
					</cfif>
			        '#OrgUnit#', 				  
					'#Contact#',
					#dte#,
					'#EMailAddress#',
					'#Address1#',		
					'#City#',		
					'#Remarks#',
					'1',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 
		    </cfquery>
			
			<cfset RequestHeader.Mission   = mission>
			<cfset RequestHeader.Reference = reqno>
						
			<cfreturn RequestHeader>
								
	</cffunction>	
	
	<cffunction name="getItemPrice"
             access="public"
             returntype="struct"
             displayname="get the Item Price to replace">
		
		<cfargument name="Mission"         type="string"  required="true"   default="">					
		<cfargument name="Warehouse"       type="string"  required="true"   default="">			
		<cfargument name="Scope"           type="string"  required="true"   default="Materials">						
		<cfargument name="ItemNo"          type="string"  required="true"   default="">
		<cfargument name="UoM"             type="string"  required="true"   default="">
		<cfargument name="Quantity"        type="string"  required="true"   default="1">
		<cfargument name="Currency"        type="string"  required="true"   default="USD">
		<cfargument name="Mode"            type="string"  required="true"   default="Last">		
			
		<cfset item.price         = 0>
										
		<cfquery name="getWarehouse" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *   
			FROM      Warehouse
			WHERE     Warehouse = '#Warehouse#' 
		</cfquery>	
		
		<cfif getWarehouse.recordcount eq "1">
			<cfset mission = getWarehouse.Mission>
		</cfif>
							
		<cfset item.mission = getWarehouse.Mission>	
				
		<cfquery name="getItem" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Item
			WHERE     ItemNo     = '#ItemNo#' 			
		</cfquery>			
		
		<cfset item.category        = getItem.Category>	
		<cfset item.itemdescription = getItem.ItemDescription>	
		<cfset item.itemclass       = getItem.ItemClass>	
		
		<!--- finally we take the price from the standard cost -in Base currency --->	
					
		 <cfquery name="getPrice" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">

				SELECT    TOP 1 *
				FROM      ItemVendorOffer AS ivo INNER JOIN
                          ItemVendor AS iv ON ivo.OrgUnitVendor = iv.OrgUnitVendor AND ivo.ItemNo = iv.ItemNo
				WHERE     iv.Preferred = 1 
				AND       ivo.DateEffective <= GETDATE() 
				AND       ivo.ItemNo = '#itemno#' 
				AND       ivo.UoM    = '#uom#'
				AND       Mission    = '#mission#'
				AND       Currency   = '#currency#'
				AND       (ivo.DateExpiration IS NULL OR ivo.DateExpiration >= GETDATE())						
				ORDER BY  DateEffective DESC 	
		</cfquery>
		
		<cfif getPrice.recordcount eq "1">
					
			<cfset item.price         = getPrice.ItemPrice>		
						
			<cfif getPrice.ItemTax gt "0" and getprice.TaxIncluded eq "1">
				   				   
			       <cfset item.price = getPrice.ItemPrice*(100/(100+getPrice.ItemTax))>
				   <cfset item.price = round(item.price*100)/100>
				  				   
		    </cfif> 		
					
		<!--- we check for a price in ANOTHER currency and convert it to the currency of selection --->
		
		<cfelse>
		
			 <cfquery name="getPrice" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    TOP 1 *
					FROM      ItemVendorOffer AS ivo INNER JOIN
	                          ItemVendor AS iv ON ivo.OrgUnitVendor = iv.OrgUnitVendor AND ivo.ItemNo = iv.ItemNo
					WHERE     iv.Preferred = 1 
					AND       ivo.DateEffective <= GETDATE() 
					AND       ivo.ItemNo = '#itemno#' 
					AND       ivo.UoM    = '#uom#'
					AND       Mission    = '#mission#'				
					AND       (ivo.DateExpiration IS NULL OR ivo.DateExpiration >= GETDATE())						
					ORDER BY  DateEffective DESC 	
			 </cfquery>
		
			<cfif getPrice.recordcount eq "1">
			
					<cf_exchangeRate datasource="AppsMaterials" 
					   	currencyFrom="#getPrice.Currency#" 
					    currencyTo="#Currency#">
						 					 					 
				   <cfset item.price         = getPrice.ItemPrice/exc>		
				   
				   <cfif getPrice.ItemTax gt "0" and getprice.TaxIncluded eq "1">
				   
				        <cfset item.price = item.price*(100/(100+getPrice.ItemTax))>
						<cfset item.price = round(item.price*100)/100>
				   
				   </cfif> 	
			
			<cfelse>		
								
				<cfquery name="getPrice" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      ItemUoMMission
					    WHERE     ItemNo        = '#itemno#' 
						AND       UoM           = '#uom#' 		
						AND       Mission       = '#Mission#'					
					</cfquery>		
					
					<cfquery name="getWarehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT    *
					    FROM      ItemWarehouse
					    WHERE     ItemNo        = '#itemno#' 
						AND       UoM           = '#uom#' 		
						AND       Warehouse     = '#getWarehouse.Warehouse#'					
					</cfquery>	
											
					<cfif getPrice.recordcount eq "1">		
				
					<cf_exchangeRate datasource="AppsMaterials" 
				     	currencyFrom="#APPLICATION.BaseCurrency#" 
					    currencyTo="#Currency#">
					 					 					 
					   <cfset item.price         = getPrice.StandardCost/exc>
					 
					<cfelse>
										
					   <cfset item.price         = "0.00">					
					
					</cfif> 
					
			</cfif>
		
		</cfif>
				
		<cfreturn item>				
		
		</cffunction>
	
	<cffunction name="addRequestLine"
             access="public"	         	 
             displayname="Create Request Line">

			<cfargument name = "Mission"    		type="string"  required="true"   default="">					
			<cfargument name = "Reference" 		    type="string"  required="true"   default="">	
			<cfargument name = "OrgUnit"            type="numeric" default="0">					
			
			<cfargument name = "Warehouse" 		    type="string"  required="true"   default="">		
			<cfargument name = "ShipToWarehouse"    type="string"  required="false"  default="">				
			<cfargument name = "LocationId"         type="GUID"    required="false"  default="00000000-0000-0000-0000-000000000000">				
			<cfargument name = "AssetId"            type="GUID"    required="false"  default="00000000-0000-0000-0000-000000000000">
			<cfargument name = "CustomerId"         type="GUID"    required="false"  default="00000000-0000-0000-0000-000000000000">
			<cfargument name = "WorkOrderId"        type="GUID"    required="false"  default="00000000-0000-0000-0000-000000000000">
			<cfargument name = "WorkOrderLine"      type="numeric" required="false"  default="0">
			
			<cfargument name = "RequestDate"	    type="string"  required="no"     default="#dateformat(now(),client.dateformatshow)#">							
			<cfargument name = "ItemNo"    		    type="string"  required="true"   default="">					
			<!--- drives the itemclass --->						
			<cfargument name = "UoM"     		    type="string"  required="true"   default="0">		
			<cfargument name = "RequestedQuantity"  type="numeric" default="0" required="yes">			
			
			<cfargument name = "StandardCost"  	    type="numeric" required="true"   default="0">											
			<cfargument name = "PriceSchedule"      type="string"  required="false"  default="">	
			<cfargument name = "Currency"           type="string"  required="true"   default="#application.basecurrency#">
			<cfargument name = "ItemPrice"          type="numeric" required="true"   default="0">	
			<cfargument name = "SalesPrice"         type="numeric" required="true"   default="0">		
			<cfargument name = "Remarks"     		type="string"  required="false"  default="">														
			<cfargument name = "Status"     		type="string"  required="true"   default="">				
			<cfargument name = "RequestType"   		type="string"  required="true"   default="Pickticket">												
						
			<cfset dateValue = "">
			<CF_DateConvert Value="#RequestDate#">
			<cfset dte = dateValue>
			
			<cf_assignid>
			
			<cfquery name="getUoM" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Item I, ItemUoM U
				WHERE  I.ItemNo = U.ItemNo
				AND    I.ItemNo = '#ItemNo#'
				AND    U.Uom    = '#UoM#'
			</cfquery>
			
			<cfif standardcost eq "0">
			
				<cfquery name="getStandard" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    ItemUoMMission
					WHERE   ItemNo   = '#ItemNo#'
					AND     UoM      = '#UoM#'
					AND     Mission  = '#Mission#'
				</cfquery>
				
				<cfset standardCost = getStandard.StandardCost>
				
				<cfif APPLICATION.BaseCurrency neq currency>
				
					<cf_exchangeRate datasource="AppsMaterials" 
				    	currencyFrom="#APPLICATION.BaseCurrency#" 
					    currencyTo="#Currency#">
					 					 					 
					<cfset standardCost         = standardCost/exc>
					 
				</cfif> 
						
			</cfif>
						
			<cfif Status eq "">
										
				<!--- set status as cleared --->  
				<cfset status   = "2">
	
				<cfif getUoM.InitialApproval is 1>
	
				    <cfset status   = "i">
	
			    <cfelse>
	  
					<cfquery name="Category" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT *
					  FROM   Ref_Category 
					  WHERE  Category = '#getUoM.Category#'
					</cfquery>  
		  
				    <cfif Category.InitialReview is 1>
		        		 <!--- enforces a review in legacy screen --->
				         <cfset status   = "1">
				    </cfif>
	
			    </cfif>
				
			</cfif>		
						
			<!--- if a request exists for this line under status = 'i' we remove it first --->
			
			<cfquery name="clear" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM Request
				WHERE ShipToWarehouse = '#shiptowarehouse#'
				AND   ItemNo = '#getUoM.ItemNo#'
				AND   UoM    = '#getUoM.UoM#'
				AND   Status = 'i'
			</cfquery>	
			
			
						
			<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			
				INSERT INTO Request 
				       (RequestId,
					    Mission,
						Reference,
						Warehouse,
						RequestDate,
						OrgUnit,
						ShipToWarehouse,
						LocationId,
						AssetId,
						ItemClass,
						ItemNo,
						UoM,
						RequestedQuantity,
						UoMMultiplier,
						StandardCost,
						PriceSchedule,
						Currency,
						ItemPrice,
						SalesPrice,
						CustomerId,
						WorkOrderId,
						WorkOrderLine,
						Status,
						OriginalItemNo,
						OriginalUoM,
						OriginalQuantity,
						Remarks,
						RequestType,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
					
				VALUES ('#rowguid#',
				        '#Mission#',
						'#Reference#',
						'#Warehouse#',
						#dte#,
						'#OrgUnit#',
						'#ShipToWarehouse#',
						<cfif LocationId neq "00000000-0000-0000-0000-000000000000">
							'#LocationId#',
						<cfelse>
							NULL,
						</cfif>
						<cfif AssetId neq "00000000-0000-0000-0000-000000000000">
							'#AssetId#',
						<cfelse>
							NULL,
						</cfif>
						'#ItemClass#',
						'#getUoM.ItemNo#',
						'#getUoM.UoM#',
						'#RequestedQuantity#',
						'#getUoM.UoMMultiplier#',
						'#StandardCost#',
						'#PriceSchedule#',
						'#Currency#',
						'#ItemPrice#',
						'#SalesPrice#',
						<cfif CustomerId neq "00000000-0000-0000-0000-000000000000">
						'#CustomerId#',
						<cfelse>
						NULL,
						</cfif>
						<cfif WorkOrderId neq "00000000-0000-0000-0000-000000000000">
						'#WorkOrderId#',
						<cfelse>
						NULL,
						</cfif>
						'#WorkOrderLine#',
						'#Status#', 
						
						'#getUoM.ItemNo#',
						'#getUoM.UoM#',
						'#RequestedQuantity#',
						'#Remarks#',
						'Warehouse',
						'#session.acc#',
						'#session.last#',
						'#session.first#')		
						
			</cfquery>			
	   			
	</cffunction>	
	
</cfcomponent>