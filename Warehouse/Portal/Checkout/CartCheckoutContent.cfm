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

<cfparam name="url.mode"      default="submit">
<cfparam name="url.process"   default="entry">
<cfparam name="url.scope"     default="portal">

<!--- check access --->

<cfoutput>
	
	<cfsavecontent variable="access">
			
	      SELECT  DISTINCT Warehouse 
	      FROM    Warehouse R
		  WHERE   Mission = '#url.mission#'
		  <!--- AND   Distribution = 1 --->
		  AND    (
		            R. MissionOrgUnitId IN (
			                       SELECT MissionOrgUnitId
			                       FROM   Organization.dbo.Organization Org, 
								          Organization.dbo.OrganizationAuthorization O, 
										  Organization.dbo.Ref_EntityAction A
								   WHERE  O.UserAccount = '#SESSION.acc#'									   
								   AND    O.Role        = 'WhsRequester'		
								   AND    O.OrgUnit     = Org.OrgUnit									   
								   AND    A.ActionCode  = O.ClassParameter
								   AND    A.ActionType  = 'Create' 
							   )
				    OR 
					R.Mission  IN (
						           SELECT Mission 
			                       FROM   Organization.dbo.OrganizationAuthorization O, Organization.dbo.Ref_EntityAction A 
								   WHERE  O.UserAccount = '#SESSION.acc#'
								   AND    O.Role        = 'WhsRequester'		
								   AND    O.Mission     = '#url.mission#'		
								   AND    A.ActionCode  = O.ClassParameter
								   AND    A.ActionType  = 'Create'		   
								   AND    (O.OrgUnit is NULL or O.OrgUnit = 0)
		   )   
		   )
				
	</cfsavecontent>

</cfoutput>
				
<cfquery name="hasAccess" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Warehouse 
    WHERE  Mission =  '#url.mission#' 
	
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
	
	<cfelse>
	
	<!--- only if the user may indeed submit for the warehouse --->
	AND   Warehouse IN (
	#preservesinglequotes(access)#
	)
	
	</cfif>
	
</cfquery>	

<cfif hasAccess.recordcount eq "0">

  <table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" align="center">		  
							
		<tr><td align="center" height="80" style="padding-top:50px" class="labellarge"><font face="Verdana" size="4" color="gray">You do not have the authorization to submit requests</td></tr>	
					
  </table>	
  
</cfif>
				
<cfquery name="hasData" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT DISTINCT Warehouse
    FROM   WarehouseCart 
    WHERE  Warehouse IN (SELECT Warehouse 
	                     FROM   Warehouse 
						 WHERE  Mission = '#url.mission#')
						   
	<cfif url.mode eq "submit">
	
	AND ShipToWarehouse is NOT NULL
	
	<cfelse>
	
	AND ShipToWarehouse is NULL
	
	</cfif>					   
		
	<cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
	
	<cfelse>
	
		AND   ShipToWarehouse IN (
		<!--- only if the user may indeed submit for the warehouse --->
		#preservesinglequotes(access)#	
		)			
	</cfif>		
					
</cfquery>

<cfset whs = quotedvalueList(hasData.warehouse)>

<table align="center" cellpadding="0" cellspacing="0" width="100%" height="100%">

	
	<tr>
		<td valign="top">
		
			<br>
									
			  <table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" align="center">							
								
				<tr>
				  <td colspan="2" align="left" valign="bottom">	 
				  
				  	<cfif hasData.recordcount gte "1">	
				  
					  <table cellspacing="0" width="100%" cellpadding="0" class="formpadding">
					  <tr><td align="left" valign="middle" width="5%">
					  <img src="#SESSION.root#/images/logos/warehouse/checkout.png" height="50" width="50" border="0" align="absmiddle">
					  </td>
					  <td style="padding-left:4px" width="95%" valign="bottom" class="labellarge">
					  <b><cf_tl id="Submit Pending Requests"></b>	
					  <br>
					  <font face="verdana" size="1" color="gray">&nbsp;<cf_tl id="Submit the requested items to the selected supplier for processing" class="message"></b></font>	 							 
					  </td></tr>
					  </table>	 
					  
				  <cfelseif url.process eq "refresh">	  				  
				  
				  	<script>
						try { ColdFusion.Window.destroy('dialogprocessrequest',true)} catch(e){};
					</script>
					
					<cfabort>
					
				  <cfelse>
				  
				  	  <table cellspacing="0" width="100%" cellpadding="0" class="formpadding">
					  <tr><td align="left" valign="middle" width="5%">
					  <img src="#SESSION.root#/images/logos/Procurement/Pending.png" height="50" width="50" border="0" align="absmiddle">
					  </td>
					  <td style="padding-left:4px" width="95%" valign="bottom" class="labellarge">
					  <b><cf_tl id="Add a Requests"></b>	
					  <br>
					  <font face="verdana" size="1" color="gray">&nbsp;<cf_tl id="Submit the requested items to the selected supplier for processing" class="message"></b></font>	 							 
					  </td></tr>
					  </table>	 			  
				  
				  </cfif>
				     
				  </td>
				</tr>	
				
				<tr><td height="5"></td></tr>	
				
				<tr><td id="cartcheckoutprocess"></td></tr>
				
				<tr><td colspan="2" class="linedotted"></td></tr>
				
				<tr><td height="5"></td></tr>										
								
				<cfif hasData.recordcount eq "0">							
								
					<tr><td height="46" align="center" style="padding-left:10px;padding-top:20px" class="labelmedium">
					<!---
					<u><cf_tl id="There are no requests pending submission" class="message"></font>
					--->
					</td></tr>	
					
					<tr><td height="20"</td></tr>
					
					<cfif url.mode eq "submit">
									
					<tr>
						<td style="padding-top:10px;padding-left:7px;" align="center" class="labelmedium" id="newrequest">	
						
							<cfdiv bind="url:../../Application/StockOrder/Request/Create/LineTransfer/AddRequest.cfm?scope=#url.scope#&mission=#url.mission#&warehouse=&refresh=refresh" id="newrequest">																				
							 
						</td>
					</tr>
					
					</cfif>
					
				<cfelse>
				
					<tr><td>
					
					<cfform method="POST" name="cartcheckout" id="cartcheckout">		
					<table width="100%" align="center">
				
					<tr><td>	
					    				
				    	<cfinclude template="../../Application/StockOrder/Request/Create/RequestEntryForm.cfm">		  							
						
					</td>
					</tr>		
														
					<cfif url.mode eq "submit">
									
						<tr>
						
							<td style="padding-left:7px;" align="left" class="labelmedium"><i>
							 <a href="javascript:addrequest('#url.scope#','#url.mission#',document.getElementById('warehouse').value,'0')">
								 <font color="0080C0">
								 [<cf_tl id="Add Request">]
								 </font>
							 </a>									 
							</td>
							
						</tr>
					
					</cfif>
						
					<tr><td style="padding:5px">   
							  				
					    <table width="99%"
						       style="border:1px dotted silver"
						       border="0"
						       cellspacing="0"
						       cellpadding="0"
						       align="center"
						       bordercolor="C0C0C0">
						   
							<tr><td id="cartdetail">
							
							    <cfparam name="url.warehouse" default="#warehouseselect.warehouse#">							  																	
								<cfinclude template="CartCheckOutDetail.cfm">										
								
							</td></tr>	
						
						</table>											
															
						</td>
				    </tr>
				
					<cfif hasAccess.recordcount gt "0">
											
					<tr>
						
						 <td align="center" style="padding-top:7px">
							 
							 <table cellspacing="0" align="center" border="0" cellpadding="0">
							 
								  <tr>							  
								  							     
									 <cfif url.mode eq "request">
									 
									     <td align="right">
										 
										   <input type="button" name="Back" class="button10s" style="width:180;height:28" value="Back" onclick="undocheckout()">
													 
									     </td>
									 
									 </cfif>
									 
									 <td>
									 
									   <input type="button" name="Submit" class="button10s" style="width:180;height:28" value="Submit Request" onclick="return doit()">
											 
									 </td>
								 </tr>
								 
								 <tr><td height="10"></td></tr>
								 
							 </table>
							 
						 </td>
								
					<tr>
					
					</cfif>
										
					</table>
					
					</cfform>
					
					</td></tr>
								
				</cfif>
					
				</table>					
			
		
		</td>
	</tr>
</table>

</cfoutput>

