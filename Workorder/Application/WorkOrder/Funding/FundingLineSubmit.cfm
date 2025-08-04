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

<cfparam name="Form.FundOperational#url.tabno#_#url.row#" default="1">
<cfparam name="Form.FundingId#url.tabno#_#url.row#"       default="">
<cfparam name="Form.FundReference#url.tabno#_#url.row#"   default="0">
<cfparam name="Form.FundCurrency#url.tabno#_#url.row#"    default="USD">
<cfparam name="Form.FundAmount#url.tabno#_#url.row#"      default="0">
<cfparam name="Form.FundUnit#url.tabno#_#url.row#"        default="">

<!--- evaluate values --->

<cfset operational    = evaluate("Form.FundOperational#url.tabno#_#url.row#")>
<cfset reference      = evaluate("Form.FundReference#url.tabno#_#url.row#")>
<cfset dateeffective  = evaluate("Form.FundDateEffective#url.tabno#_#url.row#")>
<cfset dateexpiration = evaluate("Form.FundDateExpiration#url.tabno#_#url.row#")>
<cfset currency       = evaluate("Form.FundCurrency#url.tabno#_#url.row#")>
<cfset fundingid      = evaluate("Form.FundingId#url.tabno#_#url.row#")>
<cfset amount         = evaluate("Form.FundAmount#url.tabno#_#url.row#")>
<cfset unit           = evaluate("Form.FundUnit#url.tabno#_#url.row#")>

<cfif fundingid eq "">

	<cfoutput>
		<script>
		  alert("You must select a funding account.")
		</script>			
	</cfoutput>
	
	<cfinclude template="FundingLine.cfm">
	<cfabort>

</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#DateEffective#">
<cfset eff = dateValue>
		
<cfset dateValue = "">
<cfif DateExpiration neq ''>
    <CF_DateConvert Value="#DateExpiration#">
    <cfset exp = dateValue>
<cfelse>
    <cfset exp = 'NULL'>
</cfif>			

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   WorkOrder
	WHERE  WorkorderId = '#URL.WorkOrderId#'	
</cfquery>				
	
<!---	
<cfoutput><cf_logpoint>#URL.id2# #URL.mode# #url.billingdetailid#</cf_logpoint></cfoutput>
--->

<cfif URL.ID2 neq "new">

	<!--- achive record --->
	<!----- Begin Proposed fix for funding change at Line level --->
	
	<cfif url.mode eq "billingline" or url.mode eq "billingunit">
	
		<cfquery name="Billing" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   WorkOrderLineBilling
		  WHERE  BillingId = '#url.billingdetailid#'
		</cfquery>	
			
		<cfquery name="Check" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   WorkOrderFunding
		  WHERE  FundingDetailId = '#URL.ID2#' 
		</cfquery>
		
		<cfif Check.recordcount gte "1" >
			<cfif Check.WorkorderLine neq "">
				<cfset level = "line">
			<cfelse>
				<cfset level = "parent">
			</cfif>
		<cfelse>
			<cfset level = "parent">
		</cfif>
		
		<cfif level eq "line" >
			<!--- at the line level --->			
				<cfquery name="Check" 
			  		datasource="AppsWorkOrder" 
			  		username="#SESSION.login#" 
			  		password="#SESSION.dbpw#">
				  	UPDATE WorkOrderFunding
				  	SET    Operational = 0
					WHERE FundingDetailId = '#URL.ID2#'
				</cfquery>		
		<cfelse>
		
			<!--- at the unit level --->
			<cfquery name="BillingDetail" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM   WorkOrderLineBillingDetail
			  WHERE  BillingDetailId = '#url.billingdetailid#'
			</cfquery>
			
			<cfquery name="Check" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM   WorkOrderFunding
			  WHERE  BillingDetailId = '#url.billingdetailid#'
			  AND    DateEffective   = #eff#
			</cfquery>		
		
			<cfif Check.recordcount gte "1">
			
				<cfquery name="Check" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				  UPDATE WorkOrderFunding
				  SET    Operational = 0
				  WHERE  BillingDetailId = '#url.billingdetailid#'
				  AND    DateEffective   = #eff#
				</cfquery>		
			
			</cfif>		
		
		</cfif>
	
		<cfquery name="Insert" 
	    	datasource="AppsWorkOrder" 
	     	username="#SESSION.login#" 
	     	password="#SESSION.dbpw#">			
			
			INSERT INTO WorkOrderFunding
	         (WorkOrderId,
			 <cfif url.mode eq "billingunit">		
			 	 ServiceItem,
				 ServiceItemUnit,
				 BillingDetailId,	
			 <cfelseif url.mode eq "billingline">
			     WorkorderLine,
				 BillingEffective,
			 <cfelseif unit neq "">
			  	 Serviceitem,
			     ServiceItemUnit,				  
			 </cfif>
				Memo,
				FundingId,
				DateEffective,
				DateExpiration,
				Currency,
				Amount,
				OfficerUserId,
				OfficerLastname,
				OfficerFirstName)
				
		      VALUES ('#URL.WorkOrderId#',				        
			 <cfif url.mode eq "billingunit">	
			 	 '#BillingDetail.ServiceItem#',
				 '#BillingDetail.ServiceItemUnit#',
				 '#url.BillingDetailId#',
			 <cfelseif url.mode eq "billingline">
			  	 '#Billing.WorkorderLine#',
				 '#Billing.BillingEffective#',
			 <cfelseif unit neq "">	
			 	 '#Workorder.ServiceItem#',
				 '#unit#',											
			 </cfif>	      
				'#Reference#',
				'#FundingId#',
				#eff#,
				#exp#,
				'#Currency#',
				'#Amount#',
			    '#SESSION.acc#',
				'#SESSION.last#',
				'#SESSION.first#')
		</cfquery>
		
		<!----- END Proposed fix for funding change at Line level --->		

	<cfelse>
		
	
		<cftransaction>
		
			<cfquery name="Log" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO WorkOrderFunding 
			  (FundingDetailId, 
			   WorkOrderId, 
			   WorkOrderLine, 
			   BillingEffective, 
			   Serviceitem, 
			   ServiceItemUnit, 
			   BillingDetailId, 
			   DateEffective, 
			   DateExpiration, 
			   FundingId, 
	           Currency, 
			   Amount, 
			   Memo, 
			   Operational, <!--- archive --->
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName, 
			   Created )
			   
			   SELECT  newid(), 
					   WorkOrderId, 
					   WorkOrderLine, 
					   BillingEffective, 
					   Serviceitem, 
					   ServiceItemUnit, 
					   BillingDetailId, 
					   DateEffective, 
					   DateExpiration, 
					   FundingId, 
			           Currency, 
					   Amount, 
					   Memo, 	
					   '0',			  
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName, 
					   Created
				FROM WorkOrderFunding 				
				WHERE FundingDetailId = '#URL.ID2#' 
		 	</cfquery>
	
		 	<cfquery name="Update" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE   WorkOrderFunding 
				 SET   			  
		 		       Memo            = '#Reference#',
					   FundingId       = '#FundingId#',
					   <cfif unit neq "">
						   Serviceitem      = '#workorder.serviceitem#',
						   ServiceItemUnit  = '#unit#',
					   <cfelse>
						   Serviceitem      = NULL,
						   ServiceItemUnit  = NULL,
					   </cfif>
					   DateEffective    = #Eff#,
	 				   DateExpiration   = #Exp#,				 
					   Currency         = '#Currency#',
					   Amount           = '#Amount#',		
					   Operational      = 1,		 
					   OfficerUserId    = '#SESSION.acc#',
					   OfficerLastName  = '#SESSION.last#',
					   OfficerFirstName = '#SESSION.first#',
					   Created          = getDate()
				 WHERE FundingDetailId = '#URL.ID2#' 
		    </cfquery>
			
		</cftransaction>
		
	</cfif>				
	
	<cfoutput>
		<script>
		  #ajaxLink('../Funding/FundingLine.cfm?tabno=#url.tabno#&row=#url.row#&workorderid=#URL.workorderid#&billingdetailid=#url.billingdetailid#&search=#url.search#')#
		</script>			
	</cfoutput>		

<cfelse>
		
		<cfif url.billingdetailid neq "">	
		
		    <!--- check if this is a billing level or the billing detail level --->
		
			<cfquery name="Billing" 
			  datasource="AppsWorkOrder" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT * 
			    FROM   WorkOrderLineBilling
			    WHERE  BillingId = '#url.billingdetailid#'
			</cfquery>	
			
			<cfif Billing.recordcount eq "1">
				
				<cfset mode = "billingline">
				
				<cfquery name="Check" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   WorkOrderFunding
					  WHERE  WorkorderId      = '#Billing.WorkOrderid#'
					  AND    WorkorderLine    = '#Billing.WorkOrderLine#'
					  AND    BillingEffective = '#Billing.BillingEffective#'				
				</cfquery>
					
				<cfif Check.recordcount gte "1">
					
					  <cfquery name="Check" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  DELETE FROM  WorkOrderFunding
						  WHERE  WorkorderId      = '#Billing.WorkOrderid#'
					      AND    WorkorderLine    = '#Billing.WorkOrderLine#'
						  AND    BillingEffective = '#Billing.BillingEffective#'							    						 
					  </cfquery>		
					
				</cfif>			
				
			<cfelse>
				
				<cfset mode = "billingunit">
	
				<cfquery name="BillingDetail" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   WorkOrderLineBillingDetail
					  WHERE  BillingDetailId = '#url.billingdetailid#'
				</cfquery>
					
				<cfquery name="Check" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   WorkOrderFunding
					  WHERE  BillingDetailId = '#url.billingdetailid#'
					  AND    DateEffective   = #eff#
				</cfquery>
					
				<cfif Check.recordcount gte "1">
					
					<cfquery name="Check" 
					  datasource="AppsWorkOrder" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
						  UPDATE WorkOrderFunding
						  SET    Operational = 0
						  WHERE  BillingDetailId = '#url.billingdetailid#'
						  AND    DateEffective   = #eff#
					</cfquery>		
					
				</cfif>
			
			</cfif>
		
		</cfif>
		
		<cfquery name="Insert" 
	     datasource="AppsWorkOrder" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 
		     INSERT INTO WorkOrderFunding
			         (WorkOrderId,
					 <cfif url.mode eq "billingunit">		
					 	 ServiceItem,
						 ServiceItemUnit,
						 BillingDetailId,	
					 <cfelseif url.mode eq "billingline">
					     WorkorderLine,
						 BillingEffective,						
					 <cfelseif unit neq "">
					  	 Serviceitem,
					     ServiceItemUnit,				  
					 </cfif>
					 Memo,
					 FundingId,
					 DateEffective,
					 DateExpiration,
					 Currency,
					 Amount,
					 OfficerUserId,
					 OfficerLastname,
					 OfficerFirstName)
					 
		      VALUES ('#URL.WorkOrderId#',	
			        
					 <cfif url.mode eq "billingunit">	
					 	 '#BillingDetail.ServiceItem#',
						 '#BillingDetail.ServiceItemUnit#',
						 '#url.BillingDetailId#',
					 <cfelseif url.mode eq "billingline">
					  	 '#Billing.WorkorderLine#',
						 '#Billing.BillingEffective#',						
					 <cfelseif unit neq "">	
					 	 '#Workorder.ServiceItem#',
						 '#unit#',											
					 </cfif>		      
					 
					  '#Reference#',
					  '#FundingId#',
					   #eff#,
					   #exp#,
					  '#Currency#',
					  '#Amount#',
			      	  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
		</cfquery>
	
	<cfif url.billingdetailid neq "">
	
	<cfif mode eq "billingunit">
	
		<cfoutput>
			<script>
			  #ajaxLink('../Funding/FundingLine.cfm?tabno=#url.tabno#&row=#url.row#&workorderid=#URL.workorderid#&billingdetailid=#url.billingdetailid#&search=#url.search#&id2=')#
			</script>			
		</cfoutput>
	
	<cfelse>
	
		<cfoutput>
			 <script>
		    	 ColdFusion.navigate('../ServiceDetails/Billing/DetailBillingList.cfm?workorderid=#URL.workorderid#&workorderline=#Billing.workorderline#','billingdata')
			 </script>
		</cfoutput> 	 
	
	</cfif>
	
	<cfelse>
			
		<cfoutput>
			<script>
			  #ajaxLink('../Funding/FundingLine.cfm?tabno=#url.tabno#&row=#url.row#&workorderid=#URL.workorderid#&billingdetailid=#url.billingdetailid#&search=#url.search#&id2=new')#
			</script>			
		</cfoutput>
	
	</cfif>
	
		   	
</cfif>