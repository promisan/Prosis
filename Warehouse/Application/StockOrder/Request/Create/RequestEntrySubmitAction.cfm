
<cfparam name="form.selecteditem"  default="">
<cfparam name="form.RequestAction" default="">
<cfparam name="url.resultRequisitionNo" default="">

<!--- server side validations --->

<cfif form.selecteditem eq "">
   <table align="center">
   <tr><td height="50" align="center" class="labelmedium"><font color="FF0000"><cf_tl id="No Products were selected"></td></tr>
   </table>	
   <cfabort>
</cfif>

<cfif form.RequestAction eq "">
   <table align="center">
   <tr><td height="50" align="center" class="labelmedium"><font color="FF0000"><cf_tl id="No Action was selected"></td></tr>
   </table>	
   <cfabort>
</cfif>

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Warehouse
		WHERE  Warehouse = '#form.Warehouse#'	
</cfquery>		

<cfquery name="Facility" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT ShipToWarehouse
	    FROM   WarehouseCart
		WHERE  Warehouse = '#form.Warehouse#'	
		
		<cfif form.selecteditem neq "">
		AND    CartId IN (#preservesingleQuotes(form.selecteditem)#) 
		</cfif>
		
		<!--- limit access to only valid warehouses --->		
				
		<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->

		<cfelse>
		
		AND    (

    	     (UserAccount = '#SESSION.acc#' AND ShipToWarehouse is NULL)
	                OR 
			 ShipToWarehouse IN (SELECT Warehouse 
			                     FROM   Warehouse 
								 WHERE  Mission = '#url.mission#'
								 AND    MissionOrgUnitid IN 			 
	
							           (
									   
						                  SELECT DISTINCT O.MissionOrgUnitId 
						                  FROM   Organization.dbo.Organization O, 
										         Organization.dbo.OrganizationAuthorization OA
										  WHERE  O.Mission      = '#url.Mission#'
										  AND    O.OrgUnit      = OA.OrgUnit
										  AND    OA.UserAccount = '#SESSION.acc#'											  
										  AND    OA.Role        = 'WhsPick'  
						
										  UNION
										  
										  SELECT DISTINCT O.MissionOrgUnitId 
						                  FROM   Organization.dbo.Organization O, 
										         Organization.dbo.OrganizationAuthorization OA
										  WHERE  O.Mission      = '#url.Mission#'
										  AND    O.Mission      = OA.Mission
										  AND    OA.OrgUnit is NULL
										  AND    OA.UserAccount = '#SESSION.acc#'											  
										  AND    OA.Role        = 'WhsPick'  
																							  
									   )	
									   
								)
								
			)		
			
		</cfif>				
										
</cfquery>

<cfif Facility.recordcount eq "0">
   <table align="center">
   	     <tr>
		   <td height="50" align="center"><font size="2" color="0080C0"><cf_tl id="No Products selected in order to be sumitted for facility"><cfoutput>#get.WarehouseName#</cfoutput></td>
	     </tr>
   </table>	
	<cfabort>
</cfif>

<cfparam name="form.duedate" default="">

<cfset dateValue = "">
<CF_DateConvert Value="#form.datedue#">
<cfset dte = dateValue>

<cfif form.DateDue eq "">
   <table align="center">
   <tr><td height="50" align="center" class="labelmedium"><font color="FF0000"><cf_tl id="You must set a Due Date"></td></tr>
   </table>	
   <cfabort>
</cfif>

<cfif datediff("d",now(),dte) lt "0">

   <table align="center">  
   <tr><td height="50" align="center" class="labelmedium"><font color="FF0000"><cf_tl id="You set a Due date that lies before today's date. This is not allowed."></td></tr>
   </table>	
   <cfabort>

</cfif>

<!--- end of validations --->

<cftransaction> 

<cfloop query="Facility">

	<cfquery name="getWarehouse" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   Warehouse
		 WHERE  Warehouse = '#ShipToWarehouse#'  
	</cfquery>

	<cfset city = getWarehouse.City>
	
	<!--- assign requestNo --->
	
	<cfquery name="Acc" 
	     datasource="AppsSystem" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   UserNames 
		 WHERE  Account = '#SESSION.acc#'  
	 </cfquery>
		 		
	 <cfinvoke component = "Service.Process.Materials.setReference"  
	   method           = "RequestSerialNo" 
	   mission          = "#url.mission#" 	  
	   returnvariable   = "reqno">
	   
	 <cfset url.resultRequisitionNo = reqno>	
		  
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
	<CF_DateConvert Value="#form.datedue#">
	<cfset dte = dateValue>
	
	<cfquery name="Workflow" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_RequestWorkflow	
		WHERE  RequestType   = '#form.requestType#'	
		AND    RequestAction = '#form.RequestAction#'
	</cfquery>
	
	<cf_assignid>
	
	<cfparam name="Form.ProgramCode" default="">
		
	<cfquery name="InsertHeader" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO RequestHeader 
		       (Reference, 
				Mission,
				RequestHeaderid,
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
		        '#url.mission#',
				'#rowguid#',
				'#Form.ShipToMode#',
		        '#Form.RequestType#',
			    '#Form.RequestAction#',
			    '#workflow.entityclass#',
				'#Form.ProgramCode#',
				<cfif form.Category eq "">
				NULL,
				<cfelse>
				'#Form.Category#',
				</cfif>
		        '#Form.OrgUnit#', 				  
				'#Form.Contact#',
				#dte#,
				'#Form.EMailAddress#',
				'#Form.Address1#',		
				'#City#',		
				'#Form.Remarks#',
				'1',
				'#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#') 
	</cfquery>
	
	<cfset url.drillid = rowguid>
	
	<!--- insert line for this warehouse --->
	
	<cfif ShipToWarehouse eq "">
		
		<cfquery name="Cart" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		    SELECT *
		    FROM   WarehouseCart C, 
			       Item I, 
				   ItemUoM U
		    WHERE  C.ItemNo = I.ItemNo 
			AND    C.UoM = U.UoM
			AND    I.ItemNo = U.ItemNo
			AND    C.UserAccount     = '#SESSION.acc#'  
			AND    C.Warehouse       = '#form.warehouse#'		
			AND    C.ShipToWarehouse is NULL 			
			<cfif form.selecteditem neq "">
		    AND    C.CartId IN (#preservesingleQuotes(form.selecteditem)#) 
		   </cfif>					
		</cfquery>
		
	<cfelse>
	
	    <!--- ---------------------------------------------------------------- --->
		<!--- aggregate on the warehouse, shiptowarehouse and the geo location --->
		<!--- ---------------------------------------------------------------- --->
	
		<cfquery name="Cart" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		
		 SELECT    C.ItemNo, 
		           C.UoM, 
				   U.UoMMultiplier, 
				   I.ItemClass,
				   C.Status,
				   C.ShipToWarehouse, 	
				   C.ShipToLocationId,				    
				   C.CostPrice, 
				   SUM(C.Quantity) AS Quantity, 			   
				   MAX(C.Remarks) AS Remarks 
	            
		 FROM      WarehouseCart C INNER JOIN
	               Item I ON C.ItemNo = I.ItemNo INNER JOIN
	               ItemUoM U ON C.ItemNo = U.ItemNo AND C.UoM = U.UoM 
				   
		 WHERE     C.Warehouse       = '#FORM.warehouse#'		
		 AND       C.ShipToWarehouse = '#ShipToWarehouse#'		
		 <cfif form.selecteditem neq "">
		 AND       C.CartId IN (#preservesingleQuotes(form.selecteditem)#) 
		 </cfif>  
							   
	     GROUP BY  C.ItemNo, 
		           C.UoM, 
				   C.ShipToWarehouse, 	
				   C.ShipToLocationId,			  		  
				   C.CostPrice, 
				   U.UoMMultiplier, 
				   I.ItemClass, 
				   C.Status		 
			
		</cfquery>
		
	</cfif>		
	
	<cfloop query="Cart">
	
			<cf_assignid>
			
			<cfset whs = FORM.warehouse>	
			
			<!--- the warehouse to perform the task --->
			
			<cfquery name="getWarehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				 SELECT    *            
				 FROM      Warehouse			   
				 WHERE     Warehouse   = '#FORM.warehouse#'  								
			</cfquery>
								
			<cfif getWarehouse.distribution eq "0">
			
				<cfquery name="getWarehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					 SELECT    TOP 1 *            
					 FROM      Warehouse			   
					 ORDER BY  WarehouseDefault DESC												
				</cfquery>
			
				<cfset whs = getWarehouse.warehouse>
			
			</cfif>		
			
			<cfquery name="getItem" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				    SELECT    *            
				    FROM      Item	   
				    WHERE     ItemNo   = '#ItemNo#'  								
			</cfquery>		
	
			<cfquery name="Insert" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				INSERT INTO Request 
				        (RequestId,
						 RequestDate,
						 Reference, 
						 Mission,				
						 ItemNo,
						 OriginalItemNo,
						 UoM,
						 OriginalUoM,
						 UoMMultiplier,
						 OrgUnit,
						 RequestedQuantity,
						 OriginalQuantity,
						 <cfif ShipToWarehouse neq "">
						    ShipToWarehouse,	
							<cfif ShipToLocationId neq "">
							LocationId,			
							</cfif>
						 </cfif>
						 Remarks,				 
						 ItemClass,
						 Warehouse,
						 StandardCost,
						 Status,
						 RequestType,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				VALUES ('#rowguid#',
				        getDate(),
				        '#reqno#',
				        '#URL.Mission#',				
				        '#ItemNo#', 
						'#ItemNo#', 
						'#UoM#', 
						'#UoM#', 
						'#UoMMultiplier#', 
						'#Form.OrgUnit#',
						'#Quantity#', 
						'#Quantity#', 
						<cfif ShipToWarehouse neq "">
						    '#ShipToWarehouse#',	
							<cfif ShipToLocationId neq "">
							'#ShipToLocationId#',			
							</cfif>
						</cfif>
						'#Remarks#', 				
						'#ItemClass#', 
						'#whs#', 
						'#CostPrice#',
				        '#Status#', 
						'#getItem.ItemProcessMode#',    <!--- picking or taskorder, in case of taskorder we have an option to directly process the pickticket dbo.Ref_RequestType  --->
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')			
			</cfquery>
			
			<cfif ShipToWarehouse neq "">
			
				<cfquery name="CartDetails" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					 SELECT  ShipToWarehouse, ShipToLocation, SUM(Quantity) as Quantity, Remarks            
					 FROM    WarehouseCart			   
					 WHERE   UserAccount     = '#SESSION.acc#'  
					 AND     Warehouse       = '#whs#'		
					 AND     ShipToWarehouse = '#ShipToWarehouse#'	
					<cfif ShipToLocationId neq "">
					 AND     ShipToLocationId = '#ShipToLocationId#'
					 <cfelse>
					 AND     ShipToLocationId is NULL
					 </cfif>
					 AND     ItemNo          = '#itemNo#'
					 AND     UoM             = '#uom#'
					 AND     CostPrice       = '#costprice#'
					 AND     Status          = '#status#'	  
					 <cfif selecteditem neq "">
					 AND     CartId IN (#preservesingleQuotes(form.selecteditem)#)
					 GROUP BY ShipToWarehouse, ShipToLocation, Remarks
					</cfif> 	
									
				</cfquery>
				
				<cfloop query="CartDetails">
				
					<cfquery name="Insert" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
					INSERT INTO RequestDetail 
						        (RequestId,				
								 ShipToWarehouse,
								 ShipToLocation,
								 RequestedQuantity,		
								 Remarks,		
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
								 
					VALUES ('#rowguid#',
					        '#ShipToWarehouse#',		
							'#ShipToLocation#',			
							'#Quantity#',		
							'#Remarks#',		
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#')		
									
					</cfquery>
				
				</cfloop>
					
			</cfif>
			
	</cfloop>	
		
	<cfquery name="ClearCart" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	    	DELETE WarehouseCart
			WHERE  Warehouse       = '#Form.Warehouse#'
			<cfif shiptowarehouse neq "">
			AND    ShipToWarehouse = '#shiptowarehouse#'
			<cfelse>
			AND    ShipToWarehouse IS NULL
			</cfif>
			<cfif form.selecteditem neq "">
			AND    CartId IN (#preservesingleQuotes(form.selecteditem)#)
			</cfif> 	
	</cfquery>
	
</cfloop>

<cftransaction> 

<!--- create the workflow --->

<cfquery name="Request" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM RequestHeader		
	WHERE  RequestHeaderid = '#url.drillid#'	
</cfquery>

<cfquery name="RequestLine" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    L.LocationName
	FROM      Request R INNER JOIN
              RequestDetail RD ON R.RequestId = RD.RequestId INNER JOIN
              WarehouseLocation WL ON RD.ShipToWarehouse = WL.Warehouse AND RD.ShipToLocation = WL.Location INNER JOIN
              Location L ON WL.LocationId = L.Location	
	WHERE     R.Mission   = '#Request.Mission#' 
	AND       R.Reference = '#Request.Reference#'
</cfquery>	

<cfquery name="RequestType" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Request		
	WHERE  Code = '#Request.RequestType#'	
</cfquery>

<cfset wflink = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid=#url.drillid#">
						
<cf_ActionListing 
	EntityCode       = "WhsRequest"
	EntityClass      = "#Request.EntityClass#"
	EntityGroup      = ""
	EntityStatus     = ""
	Mission          = "#Request.Mission#"
	OrgUnit          = "#Request.Orgunit#"		
	PersonEMail      = "#Request.EmailAddress#"
	ObjectReference  = "#Request.Reference#"
	ObjectReference2 = "Deliver to: #RequestLine.LocationName#"						
	ObjectKey4       = "#url.drillid#"
	AjaxId           = "#url.drillid#"
	ObjectURL        = "#wflink#"
	Show             = "No"
	ToolBar          = "Yes">
		



