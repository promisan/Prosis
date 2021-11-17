
<cfparam name="URL.ID" default="0001">
<cfparam name="URL.Mission" default="Promisan">

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Item
		WHERE  ItemNo = '#URL.ID#'				
</cfquery>	

<cfquery name="Warehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    SELECT DISTINCT Warehouse
		FROM   ItemTransaction I
		WHERE  Mission = '#URL.Mission#'
		AND    ItemNo  = '#URL.ID#'	
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Operational = 1)		
							 
		UNION 
		
		SELECT DISTINCT Warehouse
		FROM   ItemWarehouse I
		WHERE  ItemNo  = '#URL.ID#'	
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Mission     = '#url.mission#'
							 AND    Operational = 1)		
							 
		UNION
		
		SELECT DISTINCT Warehouse
		FROM   WarehouseCategory I
		WHERE  Category = '#get.Category#'
		AND    Operational = 1
		AND    Warehouse IN (SELECT Warehouse 
		                     FROM   Warehouse 
							 WHERE  Warehouse   = I.Warehouse 
							 AND    Mission     = '#url.mission#'
							 AND    Operational = 1)						 
		 					 		
</cfquery>	

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   ItemUoM
		WHERE  ItemNo = '#URL.ID#'		
		AND    Operational = 1
		ORDER BY UoM	
</cfquery>	

<cfset row = 0>

<cfoutput query="warehouse">
		
	<cfset w = warehouse>
	
	<cfloop query="ItemUoM">
		
		<cfset row = row+1>
	
	    <cfset min     = evaluate("Form.MinimumStock_#row#")>				
		
		<cfset max     = evaluate("Form.MaximumStock_#row#")>
		<cfset taxcode = evaluate("Form.TaxCode_#row#")>
		<cfset minre   = evaluate("Form.MinReorderQuantity_#row#")>
		<cfset avgP     = evaluate("Form.AveragePeriod_#row#")>
		<cfset reord   = 0>
		<cfif isDefined("Form.ReorderAutomatic_#row#")>
			<cfset reord   = evaluate("Form.ReorderAutomatic_#row#")>
		</cfif>
		<cfset reqtype = evaluate("Form.RequestType_#row#")>
		<cfset restock = evaluate("Form.Restocking_#row#")>
		<cfset ship    = evaluate("Form.ShippingMemo_#row#")>		
				
		<cfquery name="Check"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT DISTINCT Warehouse
				FROM   ItemWarehouse
				WHERE  Warehouse = '#w#'
				AND    ItemNo    = '#URL.ID#'	
				AND    UoM       = '#UoM#'			
		</cfquery>	
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="insert"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ItemWarehouse
					(Warehouse,
					 ItemNo,
					 UoM,
					 MinimumStock,
					 MaximumStock,
					 ReorderAutomatic,
					 MinReorderQuantity,
					 AveragePeriod,
					 Restocking,
					 RequestType,
					 ShippingMemo, 
					 TaxCode,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES
				    ('#w#',
					 '#URL.ID#',
					 '#UoM#',
					 '#min#',
					 '#max#',
					 '#reord#',
					 '#minre#',
					 '#avgP#',
					 '#restock#',
					 '#reqtype#',
					 '#ship#',
					 '#taxcode#',
					 '#session.acc#',
					 '#session.last#',
					 '#session.first#')				
			</cfquery>		
				
		<cfelse>
	
			<cfquery name="whs"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE ItemWarehouse
				SET    MinimumStock       = '#min#',
				       MaximumStock       = '#max#',
					   ReorderAutomatic   = '#reord#',
					   MinReorderQuantity = '#minre#',
					   TaxCode            = '#taxcode#',
					   Restocking         = '#restock#',
					   AveragePeriod      = '#avgP#',
					   RequestType        = '#reqtype#',
					   ShippingMemo       = '#ship#'			
				WHERE  Warehouse          = '#W#'
				AND    ItemNo             = '#URL.ID#'
				AND    UoM                = '#UoM#'
			</cfquery>		
		
		</cfif>	
		
		<!--- relevant acquisition and sale topics --->
		
		<cfquery name="getTopics" 
			datasource="AppsMaterials"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT	 P.Description,P.SearchOrder,T.*, T.Description as TopicDescription
				FROM     Ref_Topic T 
							-- AND  ValueClass IN ('List','Lookup')
						 INNER JOIN Ref_TopicParent P ON T.Parent = P.Parent	
				WHERE    T.TopicClass = 'ItemUoM'															
				
		</cfquery>
		
		
		<cfloop query="getTopics">
				
			 <cfloop index="src" list="System,OE">	
			 
				   <cfparam name="Form.DateEffective_#row#_#code#_#src#_date" default="">		         				   
				   <cfset dte  = evaluate("Form.DateEffective_#row#_#code#_#src#_date")>				   
				   
				   <cfparam name="Form.Memo_#row#_#code#_#src#"      default="">
				   <cfparam name="Form.ListCode_#row#_#code#_#src#"  default="">
				   <cfparam name="Form.Topic_#row#_#code#_#src#"     default="">
				   
				   <cfset mem  = evaluate("Form.Memo_#row#_#code#_#src#")>
				   <cfset cde  = evaluate("Form.ListCode_#row#_#code#_#src#")>	
				   <cfset val  = evaluate("Form.Topic_#row#_#code#_#src#")>		
				  				  				   
				   <cfif dte neq "" and val neq "">
				   
					   <CF_DateConvert Value="#dte#">
					   <cfset eff  = dateValue>					   		
				 			 
			           <cfquery name="getValue" 
						  datasource="AppsMaterials"
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  
							 	SELECT   DateEffective, 
								         ListCode, TopicValue, 
										 TopicAttribute1, TopicAttribute2, TopicAttribute3
			                    FROM     ItemUoMTopic
			                    WHERE    ItemNo        = '#URL.Id#' 
							    AND      UoM           = '#ItemUoM.UoM#' 
								AND      Warehouse     = '#W#' 
								AND      Topic         = '#Code#' 								
								AND      Source        = '#src#' 
								AND      DateEffective = #eff#
								AND      Mission is NULL 
								AND      Operational   = 1
			                    ORDER BY DateEffective DESC
						</cfquery>	
						
						<cfif getValue.recordcount eq "1">
						
							<!--- we update --->
							
							 <cfquery name="setValue" 
							  datasource="AppsMaterials"
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  
							 	UPDATE   ItemUoMTopic
								SET      ListCode         = '#cde#',
								         TopicValue       = '#val#',
										 OfficerUserId    = '#session.acc#', 
										 OfficerLastName  = '#session.last#', 
										 OfficerFirstName = '#session.first#', 
										 Created          = getDate()
										 
								WHERE    ItemNo        = '#URL.Id#' 
							    AND      UoM           = '#ItemUoM.UoM#' 
								AND      Warehouse     = '#W#' 
								AND      Topic         = '#Code#' 								
								AND      Source        = '#src#' 
								AND      DateEffective = #eff#
								AND      Mission is NULL 
								AND      Operational   = 1
			                   
							</cfquery>	
						
						<cfelse>
						
							 <cfquery name="setValue" 
							  datasource="AppsMaterials"
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  
							 	INSERT INTO  ItemUoMTopic
								
									(ItemNo, 
									 UoM, 
									 Topic, 
									 Mission, 
									 Warehouse, 
									 DateEffective, 
									 Source, 
									 ListCode, 
									 TopicValue, 
									 <!--- 	 -- TopicAttribute1, TopicAttribute2, TopicAttribute3,  --->
									 Memo, 
									 OfficerUserId, OfficerLastName, OfficerFirstName)
								 
								VALUES
								
									('#URL.Id#',
									 '#ItemUoM.UoM#',
									 '#Code#',
									 NULL,
									 '#W#',
									 #eff#,
									 '#src#',
									 '#cde#',
									 '#val#',  
									 '#mem#',
									 '#session.acc#','#session.last#','#session.first#')
			                   
							</cfquery>	
					
						</cfif>
						
					</cfif>				 
				 
			 </cfloop>		
		
		</cfloop>
		
		
		<!--- insert or update itemWarehouseStockClass --->
		
		<cfquery name="stockC"
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT 	C.*,
					(SELECT TargetQuantity FROM ItemWarehouseStockClass WHERE Warehouse = '#w#' AND ItemNo = '#url.id#' AND UoM = '#uom#' AND StockClass = C.Code) as TargetQuantity
			FROM   	Ref_StockClass C
		</cfquery>
		
		<cfloop query="stockC">
		
			<cfset vTargetQuantity = 0>
			<cfif isDefined("Form.TargetQuantity_#row#_#code#")>
				<cfset vTargetQuantity = evaluate("Form.TargetQuantity_#row#_#code#")>
				<cfset vTargetQuantity = replace(vTargetQuantity,",","","ALL")>
			</cfif>
			
			<cfif TargetQuantity eq "">
			
				<cfquery name="insertSC"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO ItemWarehouseStockClass	(
							Warehouse,
							ItemNo,
							UoM,
							StockClass,
							TargetQuantity,
							OfficerUserId,
							OfficerLastname,
							OfficerFirstName
						) VALUES (
							'#w#',
							'#url.id#',
							'#ItemUoM.uom#',
							'#code#',
							'#vTargetQuantity#',
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
				</cfquery>
				
			<cfelse>
			
				<cfif vTargetQuantity neq TargetQuantity>
				
					<cfquery name="updateSC"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE 	ItemWarehouseStockClass
						SET		TargetQuantity = '#vTargetQuantity#'
						WHERE	Warehouse      = '#w#'
						AND		ItemNo         = '#url.id#'
						AND		UoM            = '#ItemUoM.uom#'
						AND		StockClass     = '#code#'
					</cfquery>
					
				</cfif>
				
			</cfif>
			
		</cfloop>
			
	</cfloop>
	
</cfoutput>

<table width="98%" align="center" cellspacing="0" cellpadding="0">
	<tr><td><font color="008000">Saved !</td></tr>
</table>

<cfinclude template="StockMinMax.cfm">		
	
