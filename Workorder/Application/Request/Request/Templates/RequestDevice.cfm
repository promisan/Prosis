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


<!--- A needed hidden field to indicate data for saving from the request module not needed anymore --->
<!--- initially populate with the existing values of that service --->

<cfparam name="url.workorderlineid" default="">

<cfif url.workorderlineid neq "">

		<cfquery name="Last" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT    WL.WorkorderId, WL.WorkorderLine,
			           MAX(BillingEffective) as BillingDate
			 FROM      WorkOrderLine WL 
			           INNER JOIN  WorkOrderLineBilling P ON WL.WorkOrderId = P.WorkOrderId AND WL.WorkOrderLine = P.WorkOrderLine 
			 WHERE     WL.WorkOrderLineId     = '#url.workorderlineid#'		
			 GROUP BY  WL.WorkorderId, WL.WorkorderLine						
		</cfquery>	
		
		<cfif Last.recordcount eq "1">
		
			<cfquery name="Current" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT PD.ServiceItemUnit as Unit
				FROM   WorkOrderLineBillingDetail PD 				
				WHERE  WorkOrderId      = '#Last.workorderid#' 
				AND    WorkOrderLine    = '#Last.workorderline#' 
				AND    BillingEffective = '#Last.BillingDate#'
			</cfquery>
					
			<input type="hidden" name="Provisioning"  id="Provisioning"  value="<cfoutput>#valueList(Current.Unit)#</cfoutput>">
		
		<cfelse>
		
		<input type="hidden" name="Provisioning"  id="Provisioning"  value="">
		
		</cfif>
		
<cfelse>		

		<input type="hidden" name="Provisioning"  id="Provisioning"  value="">
		
</cfif>		


<cfquery name="check" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM   ServiceItemMaterials R
	    WHERE  ServiceItem  = '#url.ServiceItem#'	   
		AND    MaterialsCategory IN (SELECT Category 
			                         FROM   Materials.dbo.Ref_Category 
								     WHERE  Category = R.MaterialsCategory)
</cfquery>

<cfparam name="url.accessmode" default="view">

<cfif check.recordcount gte "1">

	  <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">	
	   	  
	  <cfif url.requestid neq ""> 	    		   
		   
		   <cfif url.AccessMode eq "Edit">  
		   
		       <!--- edit mode --->
		   						
				<cfoutput query="check">
								
				<tr><td height="6"></td></tr>
				<tr class="labelmedium">
				<td width="30">								
									 					 
					  <cfset link = "../Templates/RequestDeviceGet.cfm?requestid=#url.requestid#&materialsclass=#materialsclass#">		
																
						<cf_selectlookup
						    box          = "process_#materialsclass#"
							link         = "#link#"
							button       = "Yes"
							close        = "No"	
							title        = "Select device"					
							icon         = "search.png"
							iconheight   = "17"
							iconwidth   = "17"
							class        = "item"
							filter1      = "category"
							filter1value = "#MaterialsCategory#"
							des1         = "ItemNo">
					 
				
				</td>
				<td colspan="11"><cf_tl id="#MaterialsClass#"></font></td>				
				</tr>
				
				<tr><td colspan="12" class="line">
				
				    <!--- capture ---> 
					
				 	<cfquery name="ItemList" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					  	   SELECT   * 
					  	   FROM     RequestItem
						   WHERE    RequestId      = '#url.requestid#'					  
					</cfquery>	
				
					<cfset client.itemselect = "#QuotedValueList(ItemList.ItemNo)#">	
												
					<input type="hidden" name="ItemNo" id="ItemNo" value="#client.itemselect#">
				
				</td>
				</tr>
							
				<tr>				 					 
				   <td colspan="12" id="process_#MaterialsClass#">
				 
				        <cfset url.materialsclass = materialsclass>
				        <cfinclude template="RequestDeviceGet.cfm">
					 
					    					 
				    </td>
				</tr>
														
				</cfoutput>
		   		   
			<cfelse>
			
				 <table width="100%" border="0" cellspacing="1" cellpadding="2" align="center">		 
			
			      <!--- view mode --->
						
			      <cfquery name="RequestItem" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					  	   SELECT   S.*,I.*, 
						            R.Description as DescriptionCategory
					  	   FROM     RequestItem S,
						            Materials.dbo.Item I, Materials.dbo.Ref_Category R
						   WHERE    S.ItemNo = I.ItemNo
						   AND      S.Requestid = '#URL.requestid#'  
						   AND      I.Category = R.Category						 				  
						   ORDER BY R.category	  
				 </cfquery>			
				
				 
				 <cfif requestItem.recordcount eq "0">
				 <tr class="labelmedium"><td>No items recorded</td></tr>
				 </cfif>				 				 
				
				 <cfoutput query="RequestItem" group="DescriptionCategory">
				 
					 <tr><td height="4"></td></tr>
					 <tr><td colspan="2"><font face="Verdana" size="3" color="808080">#DescriptionCategory#</td></tr>
					 <tr><td colspan="2" class="line"></td></tr>
					 <tr><td height="4"></td></tr>
					 
					 <cfoutput>		
					 		
						<tr>				   
						  <td>&nbsp;&nbsp;&nbsp;#currentrow#.</td>
						  <td>#itemdescription# (#ItemMaster#)</td>				  
						</tr>  
						
						<tr><td></td>
						
							<cfquery name="UoM" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
							  	  SELECT    *
								  FROM      ItemUoM
								  WHERE     ItemNo = '#itemno#'		 				 
							</cfquery>	
							
							<cfloop query="UoM">
								<td>
									#UoMDescription#: #APPLICATION.BaseCurrency# #numberformat(StandardCost,"__,__.__")#		
								</td>
							</cfloop>
						
						</tr>		
						
					  </cfoutput>	  
					  
				 </cfoutput>	  					
			
			</cfif> 
		
		<cfelse>	
						
			<cfquery name="CategoryList" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		  	   SELECT   *
		  	   FROM     ServiceitemMaterials R
			   WHERE    ServiceItem = '#url.serviceitem#'	
			   AND      MaterialsCategory IN (SELECT Category 
			                                  FROM   Materials.dbo.Ref_Category 
											  WHERE  Category = R.MaterialsCategory)
		    </cfquery>		
			
			<cfoutput query="categoryList">
						
			<cfif ModeEntry eq "1">			
					
				<tr>				
				 <td width="100%" height="24" style="padding-left:1px;padding-right:5px">	
				
				 <cfset client.itemselect = "''">	
								  			 
				 <cfset link = "../Templates/RequestDeviceGet.cfm?module=workorder&requestid=#url.requestid#&materialsclass=#materialsclass#">		
				
				 <!--- picture list --->	
				 		 									
				 
				 <cf_selectlookup
					    box          = "process_#materialsclass#"
						link         = "#link#"
						button       = "No"						
						close        = "Yes"	
						title        = "Select a device"					
						icon         = "selectgray.png"
						iconheight   = "18"
						iconwidth    = "18"
						module       = "workorder"
						functionscript = "captureprovision()"
						formname     = "requestform"
						class        = "itemextended"  				
						filter1      = "serviceitem"
						filter1value = "#url.serviceitem#"
						filter2      = "category"
						filter2value = "#MaterialsCategory#"
						des1         = "ItemNo">
						
				</td>		
									
																		
				</tr>
						
			<cfelse>
						
				<tr>
				
					 <td width="100%" height="24" style="padding-left:1px;padding-right:5px">
																									 
							 <cfset client.itemselect = "''">	
							 
							 <cfset link = "../Templates/RequestDeviceGet.cfm?requestid=#url.requestid#&materialsclass=#materialsclass#">		
												
							 <cf_selectlookup
								    box          = "process_#materialsclass#"
									link         = "#link#"
									button       = "No"
									close        = "No"	
									title        = "Select a #MaterialsClass#"					
									icon         = "selectgray.png"
									iconheight   = "18"
									iconwidth    = "18"
									class        = "item"
									filter1      = "category"
									filter1value = "#MaterialsCategory#"
									des1         = "ItemNo">
														 
							 </td>
					
					
				</tr>	
				
			
			</cfif>
							
			<tr><td colspan="2" class="line"></td></tr>										
				
			<tr><td colspan="2" id="process_#MaterialsClass#" style="padding-left:0px"></td></tr>
						
			</cfoutput>
		
		</cfif>
		
		</table>
	  
</cfif>
