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

<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<cfform>			 		  

<cf_tl id ="Pending for Order" var = "vPending">
<cf_tl id ="Task Orders" var = "vTasks">

<cfinvoke component = "Service.Access"  
		   method           = "WarehouseAccessList" 
		   mission          = "#url.mission#" 					   					 
		   Role             = "'WhsShip'"
		   accesslevel      = "" 					  
		   returnvariable   = "Access">

<!---

<cfsavecontent variable="access">		              
				 
		 AND    (
		            W.MissionOrgUnitId  IN (
			                       SELECT S.MissionOrgUnitId <!--- all possible orgunits based on the linkage --->
			                       FROM   Organization.dbo.OrganizationAuthorization A, 
								          Organization.dbo.Organization O, 
										  Organization.dbo.Organization S
								   WHERE  A.OrgUnit = O.OrgUnit
								   AND    O.MissionOrgUnitId = S.MissionOrgUnitId
								   AND    A.UserAccount = '#SESSION.acc#'
								   AND    A.Role        = 'WhsShip'											   
							   )
				    OR 
					W.Mission  IN (
						           SELECT Mission 
			                       FROM   Organization.dbo.OrganizationAuthorization 
								   WHERE  UserAccount = '#SESSION.acc#'
								   AND    Role        = 'WhsShip'		
								   AND    Mission     = '#url.mission#'				   
								   AND    (OrgUnit is NULL or OrgUnit = 0)
		        )  
				
				) 			 

</cfsavecontent>
--->

<!--- ------------------------------------------------------------------------ --->
<!--- safeguard as sometimes the tasking was not setting the purchase properly --->

<cfquery name="Safeguard" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  UPDATE RequestTask
	  SET    TaskType = 'Internal'
	  WHERE  TaskType = 'Purchase'
	  AND    SourceWarehouse is not NULL 
	  AND    SourceLocation  is not NULL					 
 </cfquery>	

<!--- ------------------------------------------------------------------------ --->

<cfquery name="WarehouseList" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT   *,			 
			 (SELECT COUNT(DISTINCT Reference)  
	          FROM   Request R
			  WHERE  Warehouse = W.Warehouse) AS counted
				 
    FROM     Warehouse W
    WHERE    Mission = '#url.mission#'	
	AND      (Distribution = 1 OR SupplyWarehouse IN (SELECT Warehouse FROM Warehouse WHERE Mission = W.Mission AND Operational = 1))

	<!--- only warehouses to which this person has access --->
	
	<cfif getAdministrator(url.mission) eq "1">	
		<!--- no filtering --->
    <cfelse>						  
	  AND Warehouse IN  (#preservesinglequotes(access)#)	
	</cfif>
								   
</cfquery>
	
<!--- limit access through role WarehousePick --->

<!---
<tr><td height="8"></td></tr>
<tr><td height="20" style="padding-left:5px"><font face="Verdana" size="2">Taskorder Fulfillment</font></td></tr>
<tr><td border="1" class="linedotted"></td></tr>
--->
	  
<cfif warehouselist.recordcount eq "0">
		
	<tr>
		<td colspan="2" align="center" height="30" class="labelit">   		
		<cf_tl id ="No records or no access granted">		
		</td>	
	</tr>
	
<cfelse>

	<tr><td height="4"></td></tr>
		 
	<!--- box used for refreshing --->	 
	<tr class="hide">
		<td id="tasktreerefresh"></td>         					
	</tr>	
		
	<tr><td height="100%" style="padding-top:6px">		
	
		<cftree name="roottask"
		    font="verdana"
		    fontsize="11"		
		    bold="No"   
		    format="html"    
		    required="No">   
				
				<cf_tl id = "Task Order Status" var ="1">
				
  			    <cftreeitem value="deliver"
				  display = "<span style='padding-bottom:8px' class='labellarge'>#lt_text#</span>"
				  parent  = "roottask"						  		 				 		  								
				  expand  = "yes">				
				  				  
				  <cfquery name="TaskType" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT * 
					  FROM   Ref_TaskType R					  
				  </cfquery>	
				  	  										  
				  <cfloop query="tasktype">
				  
				  <cfif code eq "Purchase">
				  				  
				  	 <cfquery name="check" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT TOP 1 *  
						  FROM   Request R, RequestTask RT
						  WHERE  R.Warehouse = '#url.warehouse#'
						  AND    R.RequestId = RT.RequestId
						  AND    RT.SourceRequisitionNo is not NULL
						  AND    RT.RecordStatus = 1					  
					  </cfquery>	
				  
					  <cfset go = check.recordcount>
				  	
				  <cfelse>
				  
				  	<cfset go = "1">
					
				  </cfif>				  
				  
				  <cfif go eq "1">
				  
				  <!--- check for access --->
				  <cfset URL.TaskType = Code>
				  <cfinclude template = "../Task/Shipment/TaskDeliveryStatus.cfm">
								   
				  <cfinvoke   component = "Service.Access"  
							  method           = "WarehouseShipper" 
							  mission          = "#url.mission#" 
							  warehouse        = "#url.warehouse#"
							  tasktype         = "#code#"
							  returnvariable   = "access">	
					   
					<cfif access neq "NONE">  									 
					  
					   <cftreeitem value="#code#"
							display="<span class='labelmedium'>#description#</span>"
							parent="deliver"									  				  	 				 		  								
							expand="yes">								  
						
						<!--- get the tasklist --->
						
						<cfinvoke component = "Service.Process.Materials.Taskorder"  
							   method           = "TaskorderList" 
							   mission          = "#url.mission#"
							   warehouse        = "#url.warehouse#"
							   tasktype         = "#code#"
							   stockorderid     = ""
							   selected         = ""
							   returnvariable   = "gettask">		    	  
					  
					   <cftreeitem value="#code#_unassigned"
						    display  = "#vPending# (<a id='treestatus_#code#_unassigned'><cfif getTask.recordcount gt 0></cfif>#getTask.recordcount#</a>)"
						    href     = "javascript:showtaskpending('#url.mission#','#code#')"							  
						    parent   = "#code#">	
					  
						  <cfquery name="qClass" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">					  
							    SELECT   * 
								FROM     Ref_ShipToMode	
						  </cfquery>			
						
						  <cfquery name="sStatus" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">					  
							  SELECT   Class,Status,ListingOrder,Description
							  FROM     Status
							  WHERE    Class   = 'TaskOrder'
							  AND      Show    = '1'
							  ORDER BY ListingOrder				  
						  </cfquery>							  					  
						  
						 <cftreeitem value="#code#_issued"
						   display="<span class='labelmedium'>#vTasks# </span>"							   						 						 
						   parent="#code#"
						   expand="yes">				
						  
						  <cfset cde = code>							  
						  
						  <!--- show the status --->
							  
						  <cfloop query = "sStatus"> 	
						  						 					
							<cfinvoke component = "Service.Process.Materials.Taskorder"  
							   method           = "CountStatus" 
							   mode             = "counting"
							   mission          = "#url.mission#"
							   warehouse        = "#url.warehouse#"
							   tasktype         = "#tasktype.code#"
							   STA              = "#sStatus.Status#"							  
							   returnvariable   = "total">														  
						  
			  			    <cftreeitem value="#cde#_#sStatus.Class#_#sStatus.Status#"
								display="#sStatus.Description# (<a id='#cde#_treestatus_#sStatus.Class#_#sStatus.Status#'>#total#</a>)"
								parent="#cde#_issued"										
								img="#SESSION.root#/Images/order.png"			 				 		  								
								href="javascript:showtask('#url.systemfunctionid#','#url.mission#','#cde#','#sStatus.class#','#sStatus.status#','')"													  
								expand="no">	
							  
								<cfloop query="qClass">
									
									  <cftreeitem value= "#cde#_#sStatus.Class#_#sStatus.Status#_#Code#"
									        display    = "#Description#"
											parent     = "#cde#_#sStatus.Class#_#sStatus.Status#"	
											img        = "#SESSION.root#/Images/select.png"											
											href       = "javascript:showtask('#url.systemfunctionid#','#url.mission#','#cde#','#sStatus.Class#','#sStatus.Status#','#code#')"									
									        expand     = "No">	
											
								</cfloop>						  
									
						  </cfloop>
						  
						  <cfinvoke component = "Service.Process.Materials.Taskorder"  
							   method           = "CountStatus" 
							   mode             = "counting"
							   mission          = "#url.mission#"
							   warehouse        = "#url.warehouse#"
							   tasktype         = "#tasktype.code#"						  
							   returnvariable   = "total">		
						  
						   <cftreeitem value="#cde#_TaskOrder_"
								display   = "All (<a id='#cde#_treestatus_TaskOrder_'>#total#</a>)"
								parent    = "#cde#_issued"										
								img       = "#SESSION.root#/Images/order.png"			 				 		  								
								href      = "javascript:showtask('#url.systemfunctionid#','#url.mission#','#cde#','TaskOrder','','')"													  
								expand    = "no">	
								
							<cfloop query="qClass">
									
									  <cftreeitem value= "#cde#_TaskOrder__#Code#"
									        display    = "#Description#"
											parent     = "#cde#_TaskOrder_"	
											img        = "#SESSION.root#/Images/select.png"											
											href       = "javascript:showtask('#url.systemfunctionid#','#url.mission#','#cde#','TaskOrder','','#code#')"									
									        expand     = "No">	
											
							</cfloop>			
							
							
						</cfif>								  						  
	
					</cfif>	

				  </cfloop>
				  
				   <cftreeitem value="dummy"
					  display=""
					  parent="roottask">	

				  <cf_tl id = "Task Order Receipts" var ="1">	
				  								  
				  <cftreeitem value="receipts"
					  display="<span style='padding-bottom:8px' class='labellarge'>#lt_text#</span>"
					  parent="roottask"							  		 				 		  								
					  expand="yes">	
					  
				 				  
				   <cf_tl id = "Internal" var = "1">
				   <cftreeitem value="internalreceipt"
					  display = "<span class='labelmedium'>#lt_text#</span>"
					  parent  = "receipts"										 		  								
					  expand  = "yes">	
					  
		  				   <cf_tl id = "Pending Recording" var = "1">
						   
						   <cftreeitem value="pendinginternalreceipt"
							  display = "#lt_text#"
							  parent  = "internalreceipt"									 			  		 				 		  								
							  href    = "javascript:stocktaskorder('')"	
							  expand  = "yes">	 
							  
						  <!--- determine if confirmation ins needed from the provider perspective --->
							  
							 <cfquery name="qClass" 
							  datasource="AppsMaterials" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">					  
							    SELECT   DISTINCT R.Code, R.Description 
								FROM     Ref_ShipToMode R, Ref_ShipToModeMission M
								WHERE    R.Code = M.Code
								AND      Mission = '#url.mission#'
								AND      ModeShipmentEntry = 1     
						     </cfquery>									
							 
							<cfif qClass.recordcount gte "1"> 
							
								<cf_tl id = "Confirmation" var = "1">
								
								<cftreeitem value="pendinginternalconf"
								  display = "#lt_text#"
								  parent  = "internalreceipt"														  		 				 		  															
								  expand  = "yes">	    
							 
								<cfloop query="qClass">
								
									<cf_tl id = "#Description#" var = "1">
									<cftreeitem value="pendinginternalconf#code#"
									  display = "#lt_text#"
									  parent  = "pendinginternalconf"		
									  img     = "#SESSION.root#/Images/select.png"						  		 				 		  								
									  href    = "javascript:stocktaskorderconfirm('','#url.systemfunctionid#','#Code#')">	  
							
								</cfloop> 
							
							</cfif>
							  							  
		  				    <cf_tl id = "Inquiry Receipts" var = "1">  
							<cftreeitem value="internalreceiptlist"
							  display = "#lt_text#"
							  parent  = "internalreceipt"									 	  		 				 		  								
							  href    = "javascript:showreceipttransfer('#url.mission#','issued')"	
							  expand  = "yes">	   
							  
						   <cftreeitem value="dummy"
							  display=""
							  parent="internalreceipt">	  
							  
				   <cfif check.recordcount gte "1">			  
				  
					   <cf_tl id = "External" var = "1">  
					   <cftreeitem value="externalreceipt"
						  display = "<span class='labelmedium'>#lt_text#</span>"
						  parent  = "receipts"
						  expand  = "yes">	
						  						  	  		
							   <cf_tl id = "Pending for Clearance" var = "1">  																			  
							   <cftreeitem value="pendingexternalreceipt"
								  display = "#lt_text#"
								  parent  = "externalreceipt"		
								  img     = "#SESSION.root#/Images/select.png"						  		 				 		  								
								  href    = "javascript:showreceipt('#url.mission#','pending')"	
								  expand  = "yes">	
								  
							    <cf_tl id = "Rejected deliveries" var = "1">  
							    <cftreeitem value="rejectedexternalreceipt"
								  display = "<font color=FF0000>#lt_text#</font>"
								  parent  = "externalreceipt"		
								  img     = "#SESSION.root#/Images/select.png"						  		 				 		  								
								  href    = "javascript:showreceipt('#url.mission#','locate','9')"	
								  expand  = "yes">	  
								  
							   <cf_tl id = "Inquiry" var = "1">  
							   <cftreeitem value="inquiryexternalreceipt"
								  display = "#lt_text#"
								  parent  = "externalreceipt"			
								  img     = "#SESSION.root#/Images/select.png"					  		 				 		  								
								  href    = "javascript:showreceipt('#url.mission#','locate','1')"	
								  expand  = "yes">	 
								  
						       <cftreeitem value="dummy"
								  display=""
								  parent="externalreceipt">	  
							  
					</cfif>		  
					  				  
		</cftree>
			
	</td></tr>

</cfif>  

</cfform>

</cfoutput>

</table>

