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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>

<!--- End Prosis template framework --->
<cfparam name="Form.QuotationId" default="">
<cfparam name="Form.ActionId"    default="">
<cfparam name="Form.Select"      default="add">
<cfparam name="Form.PurchaseNo"  default="">
<cfparam name="Form.OrderClass"  default="">
<cfparam name="Form.OrderType"   default="">
<cfparam name="Form.Remarks"     default="">

<!--- ------------------------------------------------------------------ --->
<!--- --- verify if a user actually select a PO if he/she wants to add-- --->
<!--- ------------------------------------------------------------------ --->

<cfif Form.Select eq "exist" and Form.PurchaseNo eq "">

	<cf_tl id="REQ038" var="1">
	<cfset vReq038=#lt_text#>
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message="#vReq038#" return="close">
	<cfabort>

</cfif>

<cfif Form.QuotationId eq "">
	<cf_tl id="REQ048" var="1">
	<cfset vReq048=#lt_text#>	
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message = "#vReq048#"  return = "back">
	<cfabort>
</cfif>

<cfif Form.OrderClass eq "">
	
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message = "You must select an order class"  return = "back">			
	<cfabort>
	
</cfif>

<cfif Form.OrderType eq "">
	
	<script>parent.Prosis.busy('no')</script>
	<cf_alert message = "You must select an order type"  return = "back">			
	<cfabort>
	
</cfif>

<!--- ------------------------------------------------------------------ --->
<!--- A. do not allow lines of type warehouse to be part of invoice only --->
<!--- ------------------------------------------------------------------ --->

<cfquery name="OrderType" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_OrderType
	WHERE Code = '#Form.OrderType#' 
</cfquery>

	
<cfif OrderType.ReceiptEntry eq "9">

	<cfquery name="Check" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT R.RequisitionNo
		 FROM   RequisitionLineQuote Q, RequisitionLine R
		 WHERE  Q.RequisitionNo = R.RequisitionNo
		 AND    Q.QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)			  	 
		 AND    R.RequestType = 'Warehouse'
	</cfquery>
	
	<cfif check.recordcount gte "1">
	
		<script>parent.Prosis.busy('no')</script>
		<cf_alert message = "You must select a different order type, as the selected type does not allow for Receipt and Inspection as one or more lines include Warehouse items"  return = "back">
		<cfabort>
		
	</cfif>

</cfif>	

<!--- ------------------------------------------------------------------ --->
<!--- ------------------------end of check ----------------------------- --->
<!--- ------------------------------------------------------------------ --->


<!--- ------------------------------------------------------------------ --->
<!--- -----B. do not allow lines of different currency to be mixed------ --->
<!--- ------------------------------------------------------------------ --->

<cfquery name="Check" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT DISTINCT Currency 
	 FROM   RequisitionLineQuote
	 WHERE  QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)			  	 
</cfquery>

<cfif check.recordcount gte "2">

	<script>parent.Prosis.busy('no')</script>
	<cf_alert message = "You must select lines with the same quoted currency"  return = "back">
	<cfabort>
	
</cfif>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<!--- ------------------------------------------------------------------ --->
<!--- -----C. do not allow lines of different funding to be mixed------- --->
<!--- ------------------------------------------------------------------ --->

<cfif Parameter.AddToPurchaseFund eq "1" and form.Select eq "Exist">

<cfquery name="Object" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT DISTINCT F.ObjectCode
	 FROM   RequisitionLineQuote Q INNER JOIN
            RequisitionLineFunding F ON Q.RequisitionNo = F.RequisitionNo
	 WHERE  Q.QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)		
	 AND    F.ObjectCode NOT IN SELECT ObjectCode FROM PurchaseFunding WHERE PurchaseNo = '#Form.PurchaseNo#')
</cfquery>
	
	<cfif check.recordcount gte "1">
	
		<script>parent.Prosis.busy('no')</script>
		<cf_alert message = "You may no mix funding for existing purchase orders" return = "back">
		<cfabort>
		
	</cfif>

</cfif>

<!--- ------------------------------------------------------------------ --->
<!--- ------------------------end of check ----------------------------- --->
<!--- ------------------------------------------------------------------ --->

<cfquery name="Mode" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  MIN(J.ActionStatus) AS JobStatus
	FROM    RequisitionLineQuote L INNER JOIN
            Job J ON L.JobNo = J.JobNo
	WHERE   L.QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)			  
</cfquery>

<!--- check if we have a workflow enabled on the PO level --->
 <cfquery name="CheckMission" 
		 datasource="AppsEmployee"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization.dbo.Ref_EntityMission 
			 WHERE    EntityCode     = 'ProcPO'  
			 AND      Mission        = '#URL.Mission#' 
</cfquery>	

<cfquery name="Class" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_OrderClass
	WHERE  Code = '#Form.OrderClass#' 
</cfquery>
		 
<cfif Mode.JobStatus gte "1" and
      CheckMission.WorkflowEnabled eq "0" and 
	  CheckMission.RecordCount eq 0>
	  
     <cfset createmode = "issued">
	 
<cfelseif Class.PreparationModeCreate eq "1">

	 <cfset createmode = "issued">	 
	 
<cfelse>  

     <cfset createmode = "pending">   
   
</cfif>

<!--- steps
      Both 1. verify amounts with requisition
	  New  2. define purchase No 
	  New  3. create purchase header  
	  New  4. insert address info 
	  New  5. define tracking records
	  Both   <!--- verify stock on order : real-time ??--->
	  Both 6. update reqline to status '3'
	  Both 7. insert purchase lines
--->

<!--- Both 1. verify amounts with requisition : pending Dev 14/1/05 --->

	<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
	</cfquery>
			
	<cfquery name="Root" 
 	datasource="AppsOrganization" 	
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 Org.OrgUnit
		FROM	 Ref_MissionPeriod P INNER JOIN
	             Ref_Mandate M ON P.Mission = M.Mission AND P.MandateNo = M.MandateNo INNER JOIN
	             Organization Org ON M.Mission = Org.Mission AND M.MandateNo = Org.MandateNo
		WHERE    P.Mission = '#URL.Mission#'
		AND      P.Period  = '#URL.Period#'
		AND      Org.TreeUnit = 1 		
	</cfquery>	
	
	<!--- default unit is rootunit --->
	
	<cfset unit = Root.OrgUnit>		
	
	<!--- get the unit from the requisition that are part here --->
		
	<cfquery name="getReq" 
	 	datasource="AppsPurchase" 		
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT  TOP 1 OrgUnit
		 FROM   RequisitionLineQuote Q, RequisitionLine R
		 WHERE  Q.QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)
		   AND  Q.RequisitionNo = R.RequisitionNo
		   AND  Selected = '1'				   
	</cfquery>		
	
	<cfif getReq.recordcount gte "1">
		
		<cfquery name="UnitParent" 
		 	datasource="AppsPurchase" 		
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			SELECT    O.OrgUnit
			FROM      Organization.dbo.Organization AS P INNER JOIN 
	                  Organization.dbo.Organization AS O ON P.HierarchyRootUnit = O.OrgUnitCode AND P.MandateNo = O.MandateNo AND P.Mission = O.Mission
			WHERE     P.OrgUnit = '#getReq.OrgUnit#'
		</cfquery>
		
		<cfif UnitParent.OrgUnit neq "">						
			<cfset unit = UnitParent.OrgUnit>		
		</cfif>
	
	</cfif>
		
	<cfquery name="Check" 
 	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     SUM(Q.QuoteAmountBase) AS AmountPurchase, 
	    	       SUM(R.RequestAmountBase) AS AmountRequisition
		FROM       RequisitionLineQuote Q, RequisitionLine R
		WHERE      Q.RequisitionNo = R.RequisitionNo
		AND        Q.QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)
	    AND        Selected = '1'				
	 </cfquery>		
	
	
	<cfset max = Check.AmountRequisition+(Check.AmountRequisition*Parameter.PurchaseExceed)/100>
	
	<!--- temp disabled for Kristina, pending business rule. Exclude the buyer lines and parameter --->
	
	<cfif Check.AmountPurchase gt max and max gt "0">
		
		<cf_tl id="Purchase amount" var="1">
		<cfset vPurchase=#lt_text#>

		<cf_tl id="REQ039" var="1">
		<cfset vReq039=#lt_text#>		

		<cf_tl id="REQ040" var="1">
		<cfset vReq040=#lt_text#>
				
		<cf_alert message = "#vPurchase# [#numberformat(Check.AmountPurchase,',.__')#] #vReq039# [#numberformat(max,',.__')#] #vReq040#"  return = "close">		
		<script>parent.Prosis.busy('no')</script>
		<cfabort>
		
	</cfif> 
		
<!--- generate the vendor variables --->
	
<cfset cnt = 0>
<cfloop index="itm" list="#form.contractor#" delimiters=",">
	 
	  <cfset cnt = cnt+1>
	  <cfif cnt eq "1">
	     <cfset vendor = itm>
	  <cfelse>
	     <cfset vclass = itm>	 
	  </cfif>  
	
</cfloop>
	
<cfif vclass eq "applicant">
				
	<!--- return an associated employee No into variable personNo --->
	<cf_CandidateToEmployee applicantNo="#vendor#">
					
<cfelse>
	
	<cfset personno = vendor>
			
</cfif>
	
<cftransaction>

<cfif Form.Select eq "Add">

		<!---  2. define reference No  --->
		<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
					
				<cfset No = Parameter.PurchaseSerialNo+1>
				<cfif No lt 1000>
				     <cfset No = 1000+#No#>
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
		
		<!--- check if a job workflow is the basis for this submission --->		
		
		<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT DISTINCT Currency 
			 FROM   RequisitionLineQuote
			 WHERE  QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)			  	 			 
		</cfquery>						
						
		<!--- 3. create job header  --->
		<cfquery name="Header" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Purchase 
				 (PurchaseNo, 
				  OrgUnit, 
				  <cfif vclass eq "vendor">
				  OrgUnitVendor, 
				  <cfelse>
				  OrgUnitVendor,
				  PersonNo,
				  </cfif>
				  Period, 
				  Mission, 
				  OrderClass, 
				  OrderType, 
				  <cfif createmode is "Issued">
				  ActionStatus,  
				  OrderDate,
				  <cfelse>
				  ActionStatus, 
				  </cfif>
				  Currency,
				  Remarks,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
		     VALUES ('#pono#', 
			         '#unit#', 
					 <cfif vclass eq "vendor">
					  '#vendor#', 
					 <cfelse>
					  '0',
					  '#personno#',
					 </cfif>					
					 '#URL.Period#', 
					 '#URL.Mission#', 
					 '#Form.OrderClass#',
					 '#Form.OrderType#', 
					 <cfif createmode is "Issued">
					  '3',
					  getDate(),
					 <cfelse>
					  '0',
					 </cfif>	
					 '#Check.Currency#',				
					 '#Form.Remarks#',
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#')
		</cfquery>
		
		<!---  3b. enter actor --->
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
		
		<!---  3b. enter clauses --->
		<cfquery name="InsertActor" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseClause 
					 (PurchaseNo, 
					  ClauseCode,
					  ClauseName,
					  ClauseText, 					
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			 SELECT   '#pono#', 
			          Code, 
					  ClauseName, 
					  ClauseText,
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#'
			 FROM     Ref_Clause INNER JOIN
                      Ref_OrderTypeClause ON Ref_Clause.Code = Ref_OrderTypeClause.ClauseCode
			 WHERE    Ref_Clause.Operational = 1 
			 AND      Ref_OrderTypeClause.OrderType = '#Form.OrderType#'		  			
		</cfquery>
		
		<!--- 4. add default addresses --->
				
		<cfloop index="itm" 
		    list="#Parameter.AddressTypeInvoice#,#Parameter.AddressTypeShipping#,#Parameter.AddressTypeTransport#">

			<cfif itm neq "">	
					
			   <cfquery name="Insert" 
		         datasource="AppsPurchase" 
		         username="#SESSION.login#" 
		         password="#SESSION.dbpw#">
			     INSERT INTO PurchaseAddress
				 		(PurchaseNo, 
						 AddressType, 
						 Address1, 
						 Address2, 
						 City, 
						 PostalCode, 
						 State, 
						 Country, 
						 TelephoneNo,
				         FaxNo, 
						 eMailAddress, 
						 webURL, 
						 Contact, 
						 Remarks, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName)
			     SELECT  '#pono#', 
				         '#itm#', 
						 Address1, 
						 Address2, 
						 City, 
						 PostalCode, 
						 State, 
						 Country, 
						 TelephoneNo,
				         FaxNo, 
						 eMailAddress, 
						 webURL, 
						 Contact, 
						 Remarks, 
						 '#SESSION.acc#', 
						 '#SESSION.last#', 
						 '#SESSION.first#'
			     FROM    Organization.dbo.vwOrganizationAddress
			     WHERE   AddressType = '#Itm#'
			        AND  OrgUnit     = '#unit#'
		       </cfquery>
						 
			</cfif>	   
												
		</cfloop>			
		
<cfelse>

		<!--- ------------------------------------------------------------------ --->
		<!--- -----B. do not allow lines of different currency to be mixed------ --->
		<!--- ------------------------------------------------------------------ --->
		
		<cfquery name="Purchase" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		  	 SELECT *
			 FROM   PurchaseLine 
			 WHERE  PurchaseNo = '#Form.PurchaseNo#'
		</cfquery>
		
		<cfif Purchase.recordcount gte "1"> 

			<cfquery name="Check" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     SELECT DISTINCT Currency 
				 FROM   RequisitionLineQuote
				 WHERE  QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)			  	 
				 AND    Currency NOT IN (SELECT Currency 
				                         FROM   PurchaseLine 
										 WHERE  PurchaseNo = '#Form.PurchaseNo#')
										  
			</cfquery>
	
			<cfif check.recordcount gte "1">
	
				<script>parent.Prosis.busy('no')</script>
				<cf_alert message = "Sorry but you must select quoted lines with the same currency as for the issued Purchase Order."  
				      return = "back">
					  
				<cfabort>
		
			</cfif>
		
		</cfif> 	

		<cfset PoNo = Form.PurchaseNo>
				
		<cfquery name="Update" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     UPDATE   Purchase
			  <cfif createmode is "Issued">
			  SET     ActionStatus = '3',
			          OrderDate = getdate()
			  <cfelse>
			  SET     ActionStatus = '0'
			  </cfif>			 
			 WHERE    PurchaseNo = '#Form.PurchaseNo#'
		</cfquery>
		
		<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   PurchaseActor 
			 WHERE  PurchaseNo  = '#Form.PurchaseNo#'
			 AND    ActorUserId =  '#SESSION.acc#'
			 AND    Role        =  'ProcBuyer'
		</cfquery>
		
		<cfif check.recordcount eq "0">
	
			<!---  3b. enter actor --->
			<cfquery name="InsertActor" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseActor 
				    (PurchaseNo, Role, ActorUserId, ActorLastName, ActorFirstName, OfficerUserId, OfficerLastName, OfficerFirstName) 
				 VALUES ('#Form.PurchaseNo#','ProcBuyer', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#',
				 '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
			</cfquery>
			
		</cfif>
		
		<!---  3. enter action --->
			<cfquery name="InsertAction" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO PurchaseAction 
				 (PurchaseNo, ActionStatus, ActionReference,ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName) 
				 VALUES ('#Form.PurchaseNo#', '0', 'Amendment',getDate(), '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
			</cfquery>
		
</cfif>

<!---  6a. update requisition lines --->
<cfquery name="Update" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     UPDATE RequisitionLINE
	 SET    ActionStatus = '3'
	 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	                          FROM RequisitionLineQuote 
							  WHERE QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#))
</cfquery>

<!---  6b. enter action --->
<cfquery name="InsertAction" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
    	 INSERT INTO RequisitionLineAction 
		        (RequisitionNo, ActionStatus, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName) 
		 SELECT RequisitionNo, '3', getDate(), '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#'
		 FROM   RequisitionLine
		 WHERE  RequisitionNo IN (SELECT RequisitionNo 
	              	              FROM   RequisitionLineQuote 
							      WHERE  QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#) )
</cfquery>
		
<cfquery name="SelectLines" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT RequisitionNo, QuotationId	      	
		 FROM   RequisitionLineQuote
		 WHERE  QuotationId IN (#PreserveSingleQuotes(Form.QuotationId)#)
		 AND    Selected = '1'						  
		 AND    QuotationId NOT IN (SELECT QuotationId 
			                        FROM   PurchaseLine 
								    WHERE  QuotationId is not NULL)	
</cfquery>
	
	<cfloop query="selectlines">
	
		<cftry>
	
		<!--- 7. create entries --->
		<cfquery name="InsertLines" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO PurchaseLine 
			  (RequisitionNo, 
				  PurchaseNo, 
				  QuotationId, 
				  OrderItem, 
				  OrderItemNo, 
				  OrderQuantity, 
				  OrderMultiplier, 
				  OrderUoM, 
				  Currency, 
				  OrderZero, 
				  OrderPrice, 
				  OrderDiscount, 
				  OrderTax, 
				  TaxIncluded, 
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
					QuotationId, 
					VendorItemDescription, 
					VendorItemNo, 
					QuotationQuantity, 
					QuotationMultiplier, 
			        QuotationUoM, 
					Currency, 
					QuoteZero, 
					QuotePrice, 
					QuoteDiscount, 
					QuoteTax, 
					TaxIncluded, 
					QuoteAmountCost, 
					QuoteAmountTax,
			        ExchangeRate, 
					QuoteAmountBaseCost, 
					QuoteAmountBaseTax,  
					QuoteAmountBaseCost+QuoteAmountBaseTax,
					'0', 
					'#SESSION.acc#', 
					'#SESSION.last#', 
					'#SESSION.first#'
			 FROM   RequisitionLineQuote
			 WHERE  RequisitionNo = '#RequisitionNo#'
			 AND    QuotationId = '#QuotationId#'		
		</cfquery>
		
		<!--- check if position needs to be extended --->
		
		<cfquery name="Position" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT * 	      
			 FROM  Employee.dbo.PositionParentFunding
			 WHERE RequisitionNo = '#RequisitionNo#'		
		</cfquery>
		
		<cfif Position.recordcount eq "1">
			
			<!--- -------------requisitione funding -------------- --->
			<cfinvoke component = "Service.Process.Employee.PositionAction"  
			   method           = "PositionFunding" 
			   PositionParentId = "#Position.PositionParentId#"
			   RequisitionNo    = "#RequisitionNo#"
			   Datasource       = "appsPurchase">		
			
		</cfif>				
	
		<cfcatch>
		
				<script>
				   parent.Prosis.busy('no')
			    </script>
				
				<cf_alert message = "It appears that one or more awarded lines were already turned into a purchase line. Operational aborted">
				
				<cfabort>
		
		</cfcatch>

	</cftry>
	
    </cfloop> 

<!--- check if the workflow can be updated automatically now as all lines have been processed --->

<cfif url.actionId neq "" and url.jobno neq "">
 
		<cfquery name="CheckLines" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
			 SELECT    *
	  		 FROM      RequisitionLine L
	         WHERE     JobNo = '#URL.JobNo#' 
			 AND       ActionStatus NOT IN ('9','0z')
			 <!--- --------------------------------- --->
			 <!--- line was not yet turned into a PO --->
			 <!--- --------------------------------- --->
			 AND       RequisitionNo NOT IN (
			                                 SELECT  RequisitionNo
				                             FROM    PurchaseLine
											 WHERE   RequisitionNo = L.RequisitionNo
											) 
											
											
		</cfquery>					
		
		<cfif CheckLines.recordcount eq "0">
		
			<!--- finish the job --->
			
			<cfquery name="Object" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			  SELECT ObjectId 
			  FROM   Organization.dbo.OrganizationObjectAction
	          WHERE  ActionId = '#URL.ActionId#'		 
			</cfquery> 
			
			<cfquery name="Action" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT *
			 FROM   Organization.dbo.OrganizationObjectAction
			 WHERE  ActionId = '#URL.ActionId#'						
			 </cfquery>   
				
			<cfquery name="UpdateWorkflow" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 UPDATE Organization.dbo.OrganizationObjectAction
			    SET ActionStatus      = '2',
			        OfficerUserId     = '#SESSION.acc#',
				    OfficerLastName   = '#SESSION.last#',
  				    OfficerFirstName  = '#SESSION.first#',
				    OfficerDate       = getDate(),
				    TriggerActionType = 'Purchase'	 
			  WHERE ActionId          = '#URL.ActionId#'					
			 </cfquery>  	
		 	 
		 
		 </cfif>
		 
</cfif>		 

</cftransaction>	

<!--- ----------------------------------------------- --->
<!--- process the Job as part of the workflow as well --->
<!--- ----------------------------------------------- --->

<cfif url.actionId neq "" and url.jobno neq "">
 
 	 <cfif CheckLines.recordcount eq "0">
	 
		 <cf_ProcessActionMethod
			    methodname       = "Submission"
				location         = "file"
				ObjectId         = "#Object.ObjectId#"
				actioncode       = "#Action.ActionCode#"
				actionpublishno  = "#Action.ActionPublishNo#">				
					
		 <cf_ProcessActionMethod
			    methodname       = "Submission"
				location         = "text"
				ObjectId         = "#Object.ObjectId#"
				actioncode       = "#Action.ActionCode#"
				actionpublishno  = "#Action.ActionPublishNo#">		
			
	 </cfif>	
	 
 	<!---
	 <script language="JavaScript">
	      try {
			parent.parent.right.history.go(); } catch(e) {}			
		    parent.parent.ColdFusion.Window.destroy('mydialog',true)
	 </script>	
	 --->
					
</cfif>		

<cf_systemscript>	

<cfoutput>	

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<script language="JavaScript">    
    parent.Prosis.busy('no')	
	parent.history.go()
	ptoken.open("../Purchase/POView.cfm?header=#url.header#&ID=PO&ID1=#PoNo#&Mode=Edit&mid=#mid#","_blank")	
</script>

</cfoutput>	

