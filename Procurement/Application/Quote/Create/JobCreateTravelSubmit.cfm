<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="Form.PurchaseNo" default="">
<cfparam name="SESSION.reqNo" default="">
<cfset url.selected = SESSION.reqNo>

<cfif Form.Select eq "exist" and Form.PurchaseNo eq "">

	<cf_tl id="REQ038" var="1">
	<cfset vReq038=#lt_text#>
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message="#vReq038#" return="close">
	<cfabort>

</cfif>

<cfset sel = replace(url.selected,":","'",  "all")> 

<!--- Both 1. initiatilization --->

	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
	</cfquery>
			
	<cfquery name="Root" 
 	datasource="AppsOrganization" 
	maxrows=1 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   Org.OrgUnit
		FROM	 Ref_MissionPeriod P INNER JOIN
	             Ref_Mandate M ON P.Mission = M.Mission AND P.MandateNo = M.MandateNo INNER JOIN
	             Organization Org ON M.Mission = Org.Mission AND M.MandateNo = Org.MandateNo
		WHERE    P.Mission = '#URL.Mission#'
		AND      P.Period  = '#URL.Period#'
		AND      Org.TreeUnit = 1
	</cfquery>		
	
	<cfif Root.OrgUnit neq "">
		
		<cfset unit = Root.OrgUnit>	
	
	<cfelse>
	
		<cfquery name="Unit" 
	 	datasource="AppsPurchase" 
		maxrows=1 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT OrgUnit
			 FROM   RequisitionLine
			 WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#)				  
		</cfquery>					  
		
		<cfset unit = Unit.OrgUnit>
	
	</cfif>
	
<!--- create PO --->
		
<cftransaction>
	
<cfif Form.Select eq "Add">
	
	
		<!---  2. define reference No  --->
		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
					
				<cfset No = Parameter.PurchaseSerialNo+1>
				<cfif No lt 1000>
				     <cfset No = 1000+No>
				</cfif>
					
				<cfquery name="Update" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE Ref_ParameterMission
					SET    PurchaseSerialNo = '#No#'				
					WHERE  Mission = '#URL.Mission#'
				</cfquery>
				
		</cflock>
		
		<cfset PoNo = "#Parameter.MissionPrefix#-#Parameter.PurchasePrefix#-#No#">		
				
			<!--- 3. create job header  --->
			<cfquery name="Header" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Purchase 
					 (PurchaseNo, 
					  OrgUnit, 
					  PersonNo, 
					  Period, 
					  Mission, 
					  OrderClass, 
					  OrderType, 
					  Userdefined1,
					  Userdefined2,
					  Userdefined3,
					  Userdefined4,
					  ActionStatus, 				 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			     VALUES ('#pono#', 
				         '#unit#', 
						 '#Form.SelPersonNo#', 
						 '#URL.Period#', 
						 '#URL.Mission#', 
						 '#Form.OrderClass#',
						 '#Form.OrderType#', 
						 '#Form.Userdefined1#',
					     '#Form.Userdefined2#',
					     '#Form.Userdefined3#',
					     '#Form.Userdefined4#',
						 '0',					 					
						 '#SESSION.acc#', 
						 '#SESSION.last#', 
						 '#SESSION.first#')
			</cfquery>
			
			<!---  4. enter actor --->
			<cfquery name="InsertActor" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseActor 
						 (PurchaseNo, 
						  Role, 
						  ActorUserId, 
						  ActorLastName, 
						  ActorFirstName, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
				 VALUES  ('#pono#',
				          'ProcBuyer', 
						  '#SESSION.acc#', 
						  '#SESSION.last#', 
						  '#SESSION.first#',
						 '#SESSION.acc#', 
						 '#SESSION.last#', 
						 '#SESSION.first#')
			</cfquery>
			
			<!---  5. update requisition lines --->
			<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE RequisitionLINE
			 SET    ActionStatus = '3'
			 WHERE  RequisitionNo IN (SELECT RequisitionNo 
		                              FROM   RequisitionLine
								      WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#))
			 <cfif form.SelPersonNo neq "">
			 AND   PersonNo = '#Form.SelPersonNo#'
			 </cfif>						  
						  
	</cfquery>

<cfelse>

	<cfset PONo = Form.PurchaseNo>
	
	<!---  5. update requisition lines --->
		<cfquery name="Update" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     UPDATE RequisitionLine
		 SET    ActionStatus = '3'
		 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                              FROM   RequisitionLine
							      WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#))					  
		</cfquery>
	
	<cfquery name="Purchase" 
     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		  	 SELECT *
			 FROM   PurchaseLine 
			 WHERE  PurchaseNo = '#Form.PurchaseNo#'
	</cfquery>
	
	<cfset curr = Purchase.Currency>

</cfif>
	
	<!---  6. enter action --->
	
	<cfquery name="InsertAction" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO RequisitionLineAction 
				 (RequisitionNo, 
				  ActionStatus, 
				  ActionDate, 
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
				  
		 SELECT  RequisitionNo, 
		         '3', 
				 getDate(), 
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#'
				 
		 FROM    RequisitionLine
		 WHERE   RequisitionNo IN (SELECT RequisitionNo 
		                           FROM   RequisitionLine 
								   WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#))
		 AND     PersonNo = '#Form.SelPersonNo#'								  
	</cfquery>
	
	<!--- 7. create PO entries --->	
		
	<cfquery name="SelectLines" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			SELECT RequisitionNo 	      
			 FROM  RequisitionLine
			 WHERE RequisitionNo IN (#PreserveSingleQuotes(sel)#)					  
			 AND   RequisitionNo NOT IN (SELECT RequisitionNo FROM PurchaseLine)
			 <cfif form.SelPersonNo neq "">
			 AND   PersonNo = '#Form.SelPersonNo#'
			 </cfif>
	</cfquery>
	
	<cfloop query="selectlines">
				
		<cfif Parameter.TaxExemption eq "1">
			<cfset OrderTax = 0>			
		<cfelse>
			<cfset OrderTax = Parameter.TaxDefault>
		</cfif>		
	
		<cfquery name="InsertLines" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseLine 
				     (RequisitionNo, 
					  PurchaseNo, 		 
					  OrderItem, 		 
					  OrderQuantity, 
					  OrderMultiplier, 
					  OrderUoM, 
					  Currency, 
					  OrderPrice, 		 
					  OrderAmountCost,
					  OrderAmountTax, 		
					  ExchangeRate, 
					  OrderAmountBaseCost, 
					  OrderAmountBaseTax, 
					  OrderAmountBaseObligated,
					  ActionStatus, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
					  
			 SELECT RequisitionNo, 
			        '#PoNo#', 			
					RequestDescription, 			
					RequestQuantity, 
					1, 
			        QuantityUOM, 
					RequestCurrency, 
					
					RequestCurrencyPrice,
					<cfif Parameter.DefaultTaxIncluded eq 1>					 									
					#(1/(1+OrderTax))#*RequestQuantity*RequestCurrencyPrice,
					<cfelse>
					RequestQuantity*RequestCurrencyPrice,	
					</cfif>	
					
					<cfif Parameter.DefaultTaxIncluded eq 1>					 			
					#(OrderTax/(1+OrderTax))#*RequestQuantity*RequestCurrencyPrice,
					<cfelse>
					#OrderTax#*RequestQuantity*RequestCurrencyPrice,
					</cfif>	

				   <!--- Exchange --->					
			        RequestAmountBase/(RequestQuantity*RequestCurrencyPrice), 
			         
			        <!--- OrderAmountCost --->
					<cfif Parameter.DefaultTaxIncluded eq 1>			        
						#(1/(1+OrderTax))#*RequestAmountBase,
					<cfelse>
						RequestAmountBase,
					</cfif>
					 
					<cfif Parameter.DefaultTaxIncluded eq 1>					 			
						#(OrderTax/(1+OrderTax))#*RequestAmountBase,
					<cfelse>
						#OrderTax#*RequestAmountBase,
					</cfif>	
					 
					RequestAmountBase, 
					'0', 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
					
			 FROM   RequisitionLine
			 WHERE  RequisitionNo = '#requisitionno#'	
			 
		</cfquery>
		
		<!--- ---------STAFIING INTEGRATION -------- --->	
		<!--- check if position needs to be extended --->
		<!--- -------------------------------------- --->
				
		<cfquery name="Position" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT * 	      
			 FROM   Employee.dbo.PositionParentFunding
			 WHERE  RequisitionNo = '#RequisitionNo#'		
		</cfquery>
		
		<cfif Position.recordcount eq "1">
			
			<!--- -------------requisitione funding -------------- --->
			<cfinvoke component = "Service.Process.Employee.PositionAction"  
			   method           = "PositionFunding" 
			   PositionParentId = "#Position.PositionParentId#"
			   RequisitionNo    = "#RequisitionNo#"
			   Datasource       = "appsPurchase">		
			
		</cfif>
	
	</cfloop>
	
	<cfquery name="Currency" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			UPDATE Purchase
			SET    Currency = (SELECT TOP 1 Currency 
			                   FROM   PurchaseLine 
							   WHERE  PurchaseNo = '#PoNo#'),							   
				   ModificationNo     = ModificationNo+1,
			       ModificationDate   = getDate(),
			       ModificationUserId = '#session.acc#'		   
			WHERE  PurchaseNo = '#PoNo#'			
	</cfquery>	
	
	<!--- 8.Travel Lines --->
	
	<cfquery name="InsertLines" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			INSERT INTO PurchaseLineTravel
			       (RequisitionNo, DetailId, ClaimCategory, DateEffective, DateExpiration, LocationCode, Quantity, UoM, Currency, CurrencyRate, UOMPercentage, UoMRate, Memo, OfficerUserId, 
                    OfficerLastName, OfficerFirstName, Created )

			SELECT  RequisitionNo, DetailId, ClaimCategory, DateEffective, DateExpiration, LocationCode, Quantity, UoM, Currency, CurrencyRate, UOMPercentage, UoMRate, Memo, OfficerUserId, 
                    OfficerLastName, OfficerFirstName, Created

			FROM    RequisitionLineTravel
			WHERE   RequisitionNo IN (#PreserveSingleQuotes(sel)#)		
	</cfquery>	
	
	<!--- 9.Travel Indicator Lines --->
	
	<cfquery name="InsertLines" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			INSERT INTO PurchaseLineTravelPointer
			SELECT *
			FROM   RequisitionLineTravelPointer
			WHERE  RequisitionNo IN (#PreserveSingleQuotes(sel)#)		
	</cfquery>	

</cftransaction>	

<script language="JavaScript">

	<cfoutput>
	
		try {  
			  parent.opener.reloadForm()	} 
		catch(e) {}		
		
		ColdFusion.navigate('SelectLines.cfm?mission=#url.mission#&period=#url.period#','pending')
		ColdFusion.navigate('../../PurchaseOrder/Purchase/POViewView.cfm?header=No&ID=PO&ID1=#PoNo#&Mode=Edit','contentbox2')
		window.focus()
		
	    // ColdFusion.navigate('SelectLines.cfm?mission=#url.mission#&period=#url.period#','pending')
		// ColdFusion.navigate('SelectLines.cfm?mode=travel&personno=#form.selpersonno#&mission=#url.mission#&period=#url.period#','travelpending')
		// document.getElementById("trvsubmit").className = "hide"
		// ret = ptoken.showModalDialog("../../PurchaseOrder/Purchase/POViewView.cfm?header=No&ID=PO&ID1=#PoNo#&Mode=Edit&ts="+new Date().getTime(), null, "unadorned:yes; edge:raised; status:yes; dialogHeight:920px; dialogWidth:1040px; help:no; scroll:no; center:yes; resizable:yes",'','');
				
	</cfoutput>	
	
</script>


