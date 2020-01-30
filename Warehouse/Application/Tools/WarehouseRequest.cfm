
<!--- 

   A. ETL for generating requests based on the ItemWarehouseLocationRequest object 
   B. ETL for generating requests based on minimum and maximum stock levels  : PENDING 
   
--->


<!--- A Get all objects that do not have an occurance in the request for this month --->

<!--- we go one day ahead --->

<cfset seldate   = now()+2>

<!--- define the full month period --->

<cfset mthstr  = CreateDate(Year(seldate),Month(seldate),1)>
<cfset mthend  = CreateDate(Year(seldate),Month(seldate),DaysInMonth(seldate))>

<!--- pending to group this by mission --->

<cfquery name="getRequest" 
 datasource="AppsMaterials"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	SELECT     W.Mission, W.MissionOrgUnitId, W.Contact, W.eMailAddress, R.*
	FROM       Warehouse W, ItemWarehouseLocationRequest R
	WHERE      W.Warehouse = R.Warehouse
	
	<!--- only valid request objects --->
	
	AND        ScheduleEffective =
                   (SELECT     MAX(ScheduleEffective) AS Last
                    FROM       ItemWarehouseLocationRequest
                    WHERE      ScheduleEffective <= #seldate# 
					AND        Warehouse = R.Warehouse 
					AND        Location = R.Location 
					AND        ItemNo = R.ItemNo 
					AND        UoM = R.UoM
                    GROUP BY Warehouse, Location, ItemNo, UoM) 

    <!--- was not raised this moth already --->
								
	AND      ScheduleId NOT IN
                    (SELECT     ScheduleId
                     FROM       Request
                     WHERE      ScheduleId = R.ScheduleId AND RequestDate >= #mthstr# AND RequestDate <= #mthend#) 
					 
	<!--- only monthly reuqests for now --->
					 
	AND      ScheduleMode = 'Month'
	ORDER BY W.Warehouse, R.ItemNo
</cfquery>	
	
<cfoutput query="getRequest" group="Warehouse">
		
	<cfquery name="getOrgUnit" 
	 datasource="AppsMaterials"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	 SELECT TOP 1 * 
		 FROM   Organization.dbo.Organization 
		 WHERE  Mission = '#Mission#'
		 AND    MissionOrgUnitId = '#MissionOrgUnitId#'
		 ORDER BY MandateNo DESC
	</cfquery> 
		
	<cfoutput group="ItemNo">
	
		<cfquery name="getItem" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				 SELECT    *            
				 FROM      Item I, Ref_Category R   
				 WHERE     ItemNo     = '#ItemNo#'  								
				 AND       I.Category = R.Category
		</cfquery>				
	
	<cfoutput group="UoM">
	
		<cfquery name="getItemUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				 SELECT    *            
				 FROM      ItemUoM   
				 WHERE     ItemNo   = '#ItemNo#'  								
				 AND       UoM      = '#UoM#'
		</cfquery>		
		
		<cfif getOrgUnit.recordcount gte "1">
			
			<cf_assignid>
			
			<!--- assign a reference number --->
							
			<cfquery name="Workflow" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_RequestWorkflow	
					WHERE  RequestType   = '#requestType#'	
					AND    RequestAction = '#RequestAction#'
			</cfquery>	
			
			 <cfinvoke component = "Service.Process.Materials.setReference"  
			   method           = "RequestSerialNo" 
			   mission          = "#mission#" 
			   alias            = "AppsMaterials"	  
			   returnvariable   = "reqno">		
					
			<!--- create a request header for each item --->
			
			<cftransaction>
			
			<cfset headerid = rowguid>
		
			<cfquery name="InsertHeader" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO RequestHeader 
					       (Reference, 
							Mission,
							RequestHeaderId,
							RequestShipToMode,
							RequestType,
							RequestAction,
							EntityClass,										
							OrgUnit,
							Contact,
							DateDue,
							EMailAddress,							
							Remarks,
							ActionStatus,							
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName)
				VALUES 	   ('#reqno#', 
					        '#mission#',
							'#headerid#',
							'#ShipToMode#',
					        '#RequestType#',
					        '#RequestAction#',
					        '#workflow.entityclass#',										
					        '#getOrgUnit.OrgUnit#', 				  
						    '#Contact#',
							'#dateformat(now(),client.dateSQL)#',
						    '#EMailAddress#',							
							'Auto Request',
							<cfif getItem.InitialReview is "1">
							'1',
							<cfelse>
							'i',
							</cfif>											
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#') 
			</cfquery>
					
			<cfoutput>
				
					<!--- create a request line for each request storage location --->
					
					<cf_assignid>
				
					<cfquery name="Insert" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO Request 
							        (RequestId,
									 ScheduleId,
									 RequestDate,
									 Reference, 
									 Mission,				
									 ItemNo,
									 OriginalItemNo,
									 UoM,
									 OriginalUoM,
									 UoMMultiplier,
									 Currency,
									 OrgUnit,
									 RequestedQuantity,
									 OriginalQuantity,
									 ShipToWarehouse,											 
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
							        '#ScheduleId#',		
							        '#dateformat(now(),client.dateSQL)#',
							        '#reqno#',
							        '#Mission#',				
							        '#ItemNo#', 
									'#ItemNo#', 
									'#UoM#', 
									'#UoM#', 
									'#getItemUoM.UoMMultiplier#', 
									'#APPLICATION.basecurrency#',
									'#getOrgUnit.OrgUnit#', 	
									'#ScheduleQuantity#', 
									'#ScheduleQuantity#', 
									'#Warehouse#',				
									'#ScheduleMemo#', 				
									'#getItem.ItemClass#', 
									'#SourceWarehouse#', 
									'2.00', <!--- '#CostPrice#', --->
							        '2', 
									'#getItem.ItemProcessMode#',    <!--- picking or taskorder --->
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#')			
						</cfquery>
						
				</cfoutput>
				
				</cftransaction>
				
				<!--- ------------------- --->
				<!--- create the workflow --->
				<!--- ------------------- --->
		
				<cfquery name="Request" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * FROM RequestHeader		
					WHERE  RequestHeaderid = '#headerid#'	
				</cfquery>
				
				<cfquery name="RequestType" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT * 
					FROM   Ref_Request		
					WHERE  Code = '#RequestType#'	
				</cfquery>
				
				<cfset wflink = "Warehouse/Application/StockOrder/Request/Create/Document.cfm?drillid=#headerid#">
										
				<cf_ActionListing 
					EntityCode       = "WhsRequest"
					EntityClass      = "#Request.EntityClass#"
					EntityGroup      = ""
					EntityStatus     = ""
					Mission          = "#Request.mission#"
					OrgUnit          = "#Request.orgunit#"		
					PersonEMail      = "#Request.EmailAddress#"
					ObjectReference  = "#Request.Reference#"
					ObjectReference2 = "#RequestType.description#"						
					ObjectKey4       = "#headerid#"
					AjaxId           = "#headerid#"
					ObjectURL        = "#wflink#"
					Show             = "No">
					
			</cfif>		
			
		</cfoutput>	
	
	</cfoutput>

</cfoutput>
