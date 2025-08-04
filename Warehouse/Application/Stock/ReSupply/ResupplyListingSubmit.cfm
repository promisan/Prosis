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

<cfif url.restocking eq "Procurement">

    <cfif form.description eq "">
	
		<cfoutput>
		
	    <table width="100%" cellspacing="0" cellpadding="0">
		<tr><td align="center" height="34" class="labelmedium">
					
			<cf_tl id="Set a description for this resupply action" var="1" class="Message">	
			<cfset msg2="#lt_text#">
			
			<font color="FF0000">#msg2#</font>
			</td>
		</tr>
		</table>	
		
		</cfoutput>	
	
	</cfif>
		
	<cfquery name="Percentage" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		    SELECT sum(Percentage) as Percentage
		    FROM   RequisitionLineFunding F
			WHERE  RequisitionNo = '#URL.ReqNo#' 
	</cfquery>
	
	<cfif Percentage.Percentage neq "1">
		
		<cfoutput>
		
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td align="center" height="34" class="labelmedium">
			<cf_tl id="Problem you must define" var="1" class="Message">	
			<cfset msg1="#lt_text#">
		
			<cf_tl id="funding specification for this requisition" var="1" class="Message">	
			<cfset msg2="#lt_text#">
			
			<font color="FF0000">#msg1# #msg2#</font>
			</td>
		</tr>
		</table>	
			
		</cfoutput>
		
		<script>
		    Prosis.busy('no')			
		</script>	
		<cfabort>
	
	</cfif>
	
	
	<!--- -----------------------  --->
	<!---  1. define reference No  --->
	<!--- -----------------------  --->
	
	<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
	
		<cfquery name="Parameter" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#URL.Mission#' 
		</cfquery>
			
		<cfset No = Parameter.RequisitionSerialNo+1>
		<cfif No lt 1000>
		     <cfset No = 1000+No>
		</cfif>
			
		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    UPDATE Ref_ParameterMission
			SET    RequisitionSerialNo = '#No#'
			WHERE  Mission = '#URL.Mission#' 
		</cfquery>
			
	</cflock>
	
	<cfquery name="Param" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_ParameterMission
			WHERE  Mission = '#URL.Mission#' 
		</cfquery>
	
	<cf_tl id="Warehouse Resupply" var="tResupply">
	
	<cftransaction>
	
	<!--- ---------------------------- --->
	<!--- 2. create requisition header --->
	<!--- ---------------------------- --->
	
	<cfquery name="check" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT  *
			FROM    userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I 
			WHERE   Selected = '1' 
			AND     ToBeRequested > 0 	
			AND     Operational   = '1'
	</cfquery>		
	
	<cfif check.recordcount eq "0">
		
		<script>
		    Prosis.busy('no')
			alert("No lines selected")		
		</script>	
		<cfabort>
	
	</cfif>
	
	<cfquery name="Insert" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Requisition 
				 (Reference, 
				  RequisitionPurpose, 
				  Period, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
	     VALUES ('#Parameter.MissionPrefix#-#Parameter.RequisitionPrefix#-#No#', 
		         '#tResupply#:#Form.Description#','#Form.Period#', 
		         '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>
	
	<!--- ---------------------------- --->
	<!--- 3. submit requistion lines - --->
	<!--- ---------------------------- --->
	
	<cfquery name="getWarehouse" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT  *
			FROM    Materials.dbo.Warehouse 
			WHERE   Warehouse = '#url.warehouse#'			
	</cfquery>	
	
	<cfquery name="getList" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT  *
			FROM    userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I		
			WHERE   Selected      = '1'  <!--- selected                --->
		    AND     ToBeRequested > 0    <!--- have positive quantity  --->
		    AND     Operational   = '1'  <!--- visible on the screen   --->		
	</cfquery>			
			
	<!--- update the standard cost with the price found --->
	
	<cfloop query="getList">
	
		<cfquery name="getPrice" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">												
			SELECT    TOP 1 IVO.OfferMinimumQuantity, IVO.Currency, IVO.ItemPrice
			FROM      Materials.dbo.ItemVendor AS IV INNER JOIN
               		  Materials.dbo.ItemVendorOffer AS IVO ON IV.ItemNo = IVO.ItemNo AND IV.UoM = IVO.UoM
			WHERE     IV.ItemNo  = '#ItemNo#' 
			AND       IV.UoM     = '#UoM#'
		   ORDER BY   IV.Preferred DESC, DateEffective DESC																										
	    </cfquery>
		
		<cfif getPrice.recordcount gte "1">
		
			<cf_ExchangeRate datasource="AppsPurchase" CurrencyFrom="#getPrice.Currency#" CurrencyTo="#Application.BaseCurrency#">
			
			<cfset std = getPrice.ItemPrice / exc>
				
			<cfquery name="setPrice" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">							
				UPDATE 	userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc#
				SET     Currency     = '#getPrice.Currency#', 
				        Price        = '#getPrice.ItemPrice#',
						StandardCost = '#std#'		
				WHERE   ItemNo       = '#ItemNo#' 
				AND     UoM          = '#Uom#'																										
			</cfquery>
		
		</cfif>
		
	</cfloop>			
	
	<cfquery name="Register" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO RequisitionLine
		           (RequisitionNo, 
				    Mission, 
					Period, 
					OrgUnit, 
					OrgUnitImplement,
					Reference, 
					ItemMaster, 
					RequestDescription, 
					RequestType, 
					Warehouse, 
					WarehouseItemNo, 
					WarehouseUoM,
					QuantityUoM,
					Remarks,
					RequestDate, 
					RequestCurrency,
					RequestCurrencyPrice,
					RequestQuantity, 
					RequestCostPrice, 
					RequestAmountBase, 
					ActionStatus, 
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
		SELECT     '#URL.ReqNo#_'+Cast([LineNo] as varchar) as RequisitionNo, 
		            '#url.mission#', 
					'#Form.Period#', 
					'#Form.OrgUnit#',
					'#Form.OrgUnit#', 
					'#Parameter.MissionPrefix#-#Parameter.RequisitionPrefix#-#No#' AS Reference, 
					ItemMaster, 
					ItemDescription, 
					'Warehouse', 
					Warehouse, 
					ItemNo, 
					UoM,
					UoMDescription,
					'Warehouse Resupply',
					'#dateformat(now(),client.dateSQL)#',
					Currency,
					Price,																												
					ToBeRequested, 
					StandardCost, 
					ToBeRequested*StandardCost,
					'1p',
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
		FROM        userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I INNER JOIN
		            Organization.dbo.Ref_MissionPeriod P ON I.Mission = P.Mission INNER JOIN
		            Organization.dbo.Organization O ON P.MandateNo = O.MandateNo AND P.Mission = O.Mission AND I.MissionOrgUnitId = O.MissionOrgUnitId INNER JOIN
					Purchase.dbo.ItemMaster M ON M.Code = I.ItemMaster <!--- only valid item master --->
		WHERE       P.Period      = '#Form.Period#'
		AND         I.Selected      = '1'  <!--- selected                --->
		AND         I.ToBeRequested > 0    <!--- have positive quantity  --->
		AND         I.Operational   = '1'  <!--- visible on the screen   --->
		
	</cfquery>
	
	<!--- also record the topic on mimimum measurement --->
	
	<cfif Param.RequisitionTopicMinimum neq "">
	
		<cfquery name="Register" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RequisitionLineTopic
			(RequisitionNo, Topic, TopicValue, OfficerUserId, OfficerLastName, OfficerFirstName)
	
				SELECT        '#URL.ReqNo#_'+Cast([LineNo] as varchar) as RequisitionNo, 
				              '#Param.RequisitionTopicMinimum#',
				
			                   (SELECT     TOP (1) IVO.OfferMinimumQuantity
			                    FROM      Materials.dbo.ItemVendor AS IV INNER JOIN
			                              Materials.dbo.ItemVendorOffer AS IVO ON IV.ItemNo = IVO.ItemNo AND IV.UoM = IVO.UoM
			                    WHERE     IV.ItemNo = I.ItemNo 
								AND       IV.UoM = I.UoM 
								AND       IVO.Mission = I.Mission
			                    ORDER BY  IV.Preferred DESC, IVO.DateEffective DESC) AS Minimum,
								 
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#'
								 
			    FROM        userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I INNER JOIN
					        Organization.dbo.Ref_MissionPeriod P ON I.Mission = P.Mission INNER JOIN
					        Organization.dbo.Organization O ON P.MandateNo = O.MandateNo AND P.Mission = O.Mission AND I.MissionOrgUnitId = O.MissionOrgUnitId INNER JOIN
							Purchase.dbo.ItemMaster M ON M.Code = I.ItemMaster <!--- only valid item master --->
							
				WHERE       P.Period   = '#Form.Period#'
				AND         I.Selected   = '1' 
				AND         I.ToBeRequested > 0 
				AND         I.hasVendor  = '1'	
				AND         I.Operational = 1			
			
		</cfquery>	
	
	</cfif>
	
	<cfif Param.RequisitionTopicClassification neq "">
	
		<cfquery name="Register" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO RequisitionLineTopic
			(RequisitionNo, Topic, TopicValue, OfficerUserId, OfficerLastName, OfficerFirstName)
	
				SELECT        '#URL.ReqNo#_'+Cast([LineNo] as varchar) as RequisitionNo, 
				              '#Param.RequisitionTopicClassification#',ItemNoExternal,							                
								 
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#'
								 
			    FROM        userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I INNER JOIN
					        Organization.dbo.Ref_MissionPeriod P ON I.Mission = P.Mission INNER JOIN
					        Organization.dbo.Organization O ON P.MandateNo = O.MandateNo AND P.Mission = O.Mission AND I.MissionOrgUnitId = O.MissionOrgUnitId INNER JOIN
							Purchase.dbo.ItemMaster M ON M.Code = I.ItemMaster <!--- only valid item master --->
							
				WHERE       P.Period   = '#Form.Period#'
				AND         I.Selected   = '1' 
				AND         I.ToBeRequested > 0 				
				AND         I.Operational = 1			
			
		</cfquery>	
	
	</cfif>
		
	<!--- ---------------------------- --->
	<!--- 4. fund requisition lines -- --->
	<!--- ---------------------------- --->
	
	<cfquery name="Register" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO RequisitionLineFunding
		           (RequisitionNo, 
				    Fund, 
					ProgramCode, 
					ProgramPeriod,
					ObjectCode, 
					Percentage,
					OfficerUserId,
					OfficerLastName,
					OfficerFirstName)
		SELECT     '#URL.ReqNo#_'+Cast([LineNo] as varchar) as RequisitionNo, 
		            F.Fund, 
					F.ProgramCode,
					F.ProgramPeriod,						
					F.ObjectCode,
					F.Percentage, 
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#'
		FROM        userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I,
		            RequisitionLineFunding F 
		WHERE       F.RequisitionNo = '#URL.ReqNo#'
		AND         Selected = '1' 
		AND         ToBeRequested > 0		
		AND         Operational = 1
		AND         ItemMaster IN (SELECT Code FROM Purchase.dbo.ItemMaster)
	</cfquery>
	
	<cfquery name="Reset" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE  userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc#
		SET     Selected      = '0', 
		        ToBeRequested = 0
		WHERE   Selected      = '1' 
		AND     ToBeRequested > 0		
		AND     Operational   = 1		
		AND     ItemMaster IN (SELECT Code FROM Purchase.dbo.ItemMaster)
	</cfquery>
			
	</cftransaction>
	
<cfelse>

		<cfquery name="Warehouse" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	 
			SELECT  *
			FROM    Warehouse 
			WHERE   Warehouse = '#url.warehouse#'			
	</cfquery>		

       <!--- generate a warehouse requisition with lines and a header to be reviewed --->   
       <!--- request header --->
	  	        
	   <cfinvoke component = "Service.Process.Materials.Request"  
		   method           = "addRequestHeader" 
		   Mission          = "#url.mission#" 
		   RequestType      = "#Form.RequestType#"
		   RequestAction    = "#Form.RequestAction#"
		   Remarks          = "#Form.Description#"
		   returnvariable   = "Header">	 
		   
	   <cftransaction>   		   
		         
       <!--- request lines for this request --->   
	      
	   <cfquery name="Listing" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			
			SELECT   '#url.mission#', 					
					 (SELECT TOP 1 OrgUnit 
					  FROM   Organization.dbo.Organization 
					  WHERE  MissionOrgUnitId = I.MissionOrgUnitId
					  ORDER BY Created DESC) as OrgUnit,					 		
					 I.ItemMaster, 
					 I.ItemDescription, 					 
					 I.Warehouse, 
					 I.ItemNo, 
					 I.UoM,
					 R.ItemClass,
					 I.UoMDescription,									 
					 I.ToBeRequested, 
					 I.StandardCost, 
					 I.ToBeRequested*I.StandardCost
											
			FROM     userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc# I,
			         Item R
			WHERE    I.ItemNo = R.ItemNo		  
			AND      Selected = 1 
			<cfif url.status neq "i">
			AND      ToBeRequested > 0 
			</cfif>
			AND      I.Operational = '1'
		</cfquery>	
		
		<cfif url.status neq "i">
			
					<cfquery name="clear" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						DELETE Request 
						FROM  Request X
						WHERE ShipToWarehouse = '#url.warehouse#'
						AND   EXISTS (SELECT 'X' 
						              FROM   userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc#
									  WHERE  ItemNo = X.ItemNo
									  AND    UoM    = X.UoM)
						AND   Status = 'i'
					</cfquery>	
							
		</cfif>					
								
		<cfloop query="Listing">	
		
			<cfquery name="getwarehouse" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM   Warehouse
				WHERE  Warehouse = '#warehouse.supplywarehouse#'				
			</cfquery>	
			
			<cfif getWarehouse.saleCurrency neq "">
			    <cfset Cur = getWarehouse.saleCurrency>
			<cfelse>
			    <cfset Cur = application.baseCurrency>
			</cfif>
			
			<cfinvoke component = "Service.Process.Materials.Request"  
				   method           = "getItemPrice" 
				   warehouse        = "#warehouse#" 					   
				   currency         = "#Cur#"
				   ItemNo           = "#ItemNo#"
				   UoM              = "#UoM#"
				   quantity         = "#ToBeRequested#"
				   returnvariable   = "item">		
				   
			<!--- sale prince --->	   
			
			<cfif getWarehouse.SaleMode gte "1">  	  
						
				<cfinvoke component = "Service.Process.Materials.POS"  
					   method           = "getPrice" 
					   warehouse        = "#warehouse#" 					   
					   currency         = "#Cur#"
					   ItemNo           = "#ItemNo#"
					   UoM              = "#UoM#"
					   quantity         = "#ToBeRequested#"
					   returnvariable   = "sale">		
				   
				 <cfset saleprice = Sale.PriceNet>
				 <cfset schedule  = Sale.PriceSchedule>
				   
			<cfelse>
			
				 <cfset saleprice = "0">
				 <cfset schedule  = "">
			
			</cfif>	   	  
										
			  <cfinvoke component = "Service.Process.Materials.Request"  
				   method             = "addRequestLine" 
				   Mission            = "#Header.mission#" 
				   Reference          = "#Header.Reference#"
				   Warehouse          = "#warehouse.supplywarehouse#"
				   RequestDate        = "#dateformat(now(),client.dateformatshow)#"
				   OrgUnit            = "#orgunit#"
				   ShipToWarehouse    = "#warehouse#"
				   ItemClass          = "#ItemClass#"
				   ItemNo             = "#ItemNo#"
				   UoM                = "#UoM#"
				   PriceSchedule      = "#Schedule#"
				   Currency           = "#cur#"
				   ItemPrice          = "#Item.Price#"
				   SalesPrice         = "#saleprice#"
				   RequestedQuantity  = "#ToBeRequested#"
				   Status             = "#url.status#"
				   RequestType        = "Warehouse">	 
				
		</cfloop>
		
		<cfquery name="Reset" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE userTransaction.dbo.StockResupply#URL.Warehouse#_#SESSION.acc#
		SET    Selected = '0', ToBerequested = 0
		WHERE  Selected = '1' 
		AND    ToBeRequested > 0		
		AND     Operational = 1		
	</cfquery>
		
		</cftransaction>
   
</cfif>			
	
<cfoutput>

<cfif url.status eq "i">
	<cf_tl id = "Requested quantities were saved" var ="1">
<cfelse>
	<cf_tl id = "Request has been submitted for review" var ="1">
</cfif>	
<script>
    alert("#lt_text#.")	
	ptoken.navigate('#session.root#/Warehouse/Application/Stock/Resupply/ResupplyPrepare.cfm?systemfunctionid=#url.systemfunctionid#&mission=#url.mission#&warehouse=#url.warehouse#&restocking=#url.restocking#','subbox','','','POST','criteria')	
</script>	


</cfoutput>

