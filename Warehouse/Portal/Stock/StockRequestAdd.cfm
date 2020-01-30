
<!--- Query returning detail information for selected item --->

<cfparam name="url.category"   default="">
<cfparam name="url.itemno"     default="">
<cfparam name="url.storageid"  default="">
<cfparam name="url.shipto"     default="">
<cfparam name="url.uom"        default="0">
<cfparam name="url.warehouse"  default="">
<cfparam name="url.mission"    default="">
<cfparam name="url.mode"       default="">

<!--- adjust to take the category immediately --->

<cfquery name="ShipTo" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Warehouse
	WHERE   Warehouse  = '#URL.ShipTo#'	
</cfquery>

<cfquery name="Detail" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    Ref_category 
	WHERE   Category  = '#URL.Category#'		 
</cfquery>

<!---
<cfoutput>#url.storageid#</cfoutput>

this is the first storage one within the same geo location, so we roll up from that geo location to get all
storage location and then we only show products of enabled storage locations for request 
all the products based on ItemWarehouseLocation within that same geo location 

we list by tank and all items under it through the above. 

--->

<cfif url.warehouse eq "">

	<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
		FROM     Warehouse
		WHERE    Mission = '#URL.Mission#'	
		ORDER BY WarehouseDefault DESC 
	</cfquery>
	
	<cfif warehouse.recordcount eq "0">
		
		<table width="100%">
		
		<tr>
		<td height="30" bgcolor="ffffff" align="center" class="labelit">
			No facility configured yet
		</td>
		</tr>
		
		</table>
	
	    <cfabort>
	
	</cfif>

<cfelse>
	
	<cfquery name="Warehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Warehouse
		WHERE  Warehouse = '#URL.Warehouse#'	
	</cfquery>
	
	<cfif warehouse.recordcount eq "0">
		
		<table width="100%">
		
		<tr>
		<td height="30" bgcolor="ffffff" align="center" class="labelmedium">
			<font color="red">No facility configured yet</font>
		</td>
		</tr>
		
		</table>
	
	    <cfabort>
	
	</cfif>
	
</cfif>


<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT *
	 FROM   Ref_ParameterMission
	 WHERE  Mission   = '#warehouse.Mission#'
</cfquery>

<cfquery name="Special" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  *
	FROM    ItemWarehouse
	WHERE   ItemNo    = '#URL.ItemNo#'
	AND     Warehouse = '#warehouse.Warehouse#'
</cfquery>

<!--- this shows the header --->

<cfoutput>
	 <input type="hidden" name="shipto"            id="shipto"          value="#URL.ShipTo#"> 
	 <input type="hidden" name="storageid"         id="storageid"       value="#URL.StorageId#">
</cfoutput>
	
<CFOUTPUT query="Detail">

	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
		 
	  <tr>
	    <td width="170" align="center" valign="top" style="padding-top:2px;border-right:1px dotted silver;padding-right:6px">
		
		<table cellspacing="0" cellpadding="0">
		
		<tr>
	  		<td colspan="2" class="labelit" height="24" style="padding-top:6px">
			  Resupply <b>#ShipTo.WarehouseName#</b>
			</td>	  
	  
	    </tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>	
		
		<tr><td colspan="2" align="center" style="padding:4px">
						
		 <cfif FileExists("#SESSION.rootPath#/#TabIcon#")>		 
		 
		       <cftry>
			   
			       <cfinvoke component="Service.Image.CFImageEffects" method="init" returnvariable="effects">
			   
			       <cfimage action="RESIZE" 
					  source="#SESSION.root#/#TabIcon#" 
					  name="showimage" 
					  height="80" 
					  width="130">	
					  		 						  
					  <cfset showimage = effects.applyReflectionEffect(showimage, "gray", 60)>
						  
				    <cfimage action="WRITETOBROWSER" source="#showimage#">
															  
				<cfcatch>
								
				     <img src="#SESSION.root#/#TabIcon#"
					     alt="#Description#"
					     width="80"
					     height="80"
					     border="0"
					     align="absmiddle">
				  
				</cfcatch>	  
				
				</cftry>
		 
		  	 <cfelse>		 
			 
			      <b><img src="#SESSION.root#/images/image-not-found1.gif" alt="#Description#" border="0" align="absmiddle"></b>
				  
		  </cfif>
		  
		  </td>
		  </tr>
		  
		  <tr>
	  		<td colspan="2" class="labelit" height="24" style="padding-top:6px">Request Submitters</td>	  
	  
	    </tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>	
	  
	   <cfquery name="Reviewer" 
       datasource="AppsMaterials" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">	    
			   SELECT *
			   FROM   System.dbo.UserNames	
			   WHERE  Account IN (
		               SELECT DISTINCT UserAccount
		               FROM   Organization.dbo.Organization Org, 
					          Organization.dbo.OrganizationAuthorization O, 
							  Organization.dbo.Ref_EntityAction A
					   WHERE  O.Role        = 'WhsRequester'		
					   AND    O.OrgUnit     = Org.OrgUnit									   
					   AND    Org.MissionOrgUnitId = '#shipto.MissionOrgUnitId#'
					   AND    A.ActionCode  = O.ClassParameter
					   AND    A.ActionType  = 'Create')
			   AND AccountType = 'Individual'		   
		</cfquery>	
							
	  <cfif Reviewer.recordcount gte "1">
	
		  <tr><td colspan="2" class="linedotted"></td></tr>	
		  
		  <cfloop query="reviewer">
			  
			  <tr>
			  
			  <td height="20">
			   <cfif isValid("email",eMailAddress) or isValid("email",emailaddressexternal)>
				  <input type="checkbox" name="selecteduser" value="#account#">
			   </cfif>	  
			  </td>			  
			  <td class="label" style="padding-top:3px;padding-left:1px">#Left(FirstName,1)# #LastName#</td>
			  
			  </tr>
			  
		  </cfloop> 
	  
	  </cfif>				
				  
	  </table>
		  
		</td>
		
		<td valign="top" style="padding-left:9px">
				
		    <table width="97%" align="center" valign="top" cellpadding="0" cellspacing="0" class="formpadding">
						    
			  <tr><td height="10"></td></tr>
			  				  
			  <tr>						   
			        
					<TD height="20" colspan="1" class="labelit"><cf_tl id="Direct to">:
					
					<td colspan="2" width="90%">
					
						 <cfquery name="WarehouseList" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   * 
								FROM     Warehouse P
								WHERE    Mission = '#URL.Mission#' 
								AND      Warehouse IN (SELECT Warehouse 
								                       FROM   WarehouseCategory 
													   WHERE  Warehouse = P.Warehouse
													   AND    Category  = '#Detail.Category#'
						                               AND    Operational = 1
													   AND    SelfService = 1)
								AND      Distribution = 1										   
												   
								ORDER BY WarehouseDefault DESC
						   </cfquery>
						   
						   <cfif WarehouseList.recordcount eq "0">
						   
							   <cfquery name="WarehouseList" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     Warehouse P
									WHERE    Mission = '#URL.Mission#' 
									AND      Distribution = 1	
									ORDER BY WarehouseDefault DESC
							   </cfquery>
						   						   
						   </cfif>
						   
						   <cfquery name="getRequester" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT   * 
									FROM     Warehouse W,WarehouseLocation L
									WHERE    W.Warehouse = L.Warehouse
									AND      Storageid   = '#url.storageid#'							
							</cfquery>
								  
						  <cfquery name="WarehouseSelect" dbtype="query">
								SELECT    * 
								FROM      WarehouseList
								WHERE     City = '#getRequester.city#'								 			   												   
								ORDER BY  WarehouseDefault DESC
							</cfquery>
						   
						   <cfif warehouseSelect.recordcount neq "0">
						   
						   		<cfset sel = warehouseSelect.Warehouse>
								
						   <cfelse>
							
								<cfset sel = warehouseList.Warehouse>
								
						   </cfif>								   					    
							
						   <cfparam name="URL.Warehouse" default="#WarehouseSelect.warehouse#">
							
						   <cfif url.warehouse eq "">						
								<cfset url.warehouse = WarehouseSelect.warehouse>							
						   </cfif>															
							
						   <select class="regularxl" name="warehouse" id="warehouse">
								<cfloop query="WarehouseList">
									<option value="#Warehouse#" <cfif URL.Warehouse eq Warehouse>selected</cfif>>#WarehouseName#</option>
								</cfloop>
						   </select>		
				  
				   </td>
				   
			  </TR>	
				  
			  <tr><td height="5"></td></tr>
			  <tr><td colspan="3" class="linedotted"></td></tr>
			  <tr><td height="5"></td></tr>
			  					  				
			  <cfquery name="get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   * 
					FROM     WarehouseLocation
					WHERE    Storageid = '#url.storageid#'							
			  </cfquery>
								
				<!--- all storage locations in the SAME geo location and only if enabled for one or more items  --->
				   
				<cfquery name="LocationSelect" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   L.*, 
						         (SELECT SerialNo FROM AssetItem WHERE Assetid = L.AssetId) as SerialNo
						FROM     WarehouseLocation L
						WHERE    Warehouse  = '#get.Warehouse#'
						<cfif get.Locationid eq "">
						AND      LocationId is NULL			
						<cfelse>
						<!--- geo location --->
						AND      LocationId = '#get.Locationid#'							
						</cfif>		
						AND      Location IN (SELECT Location 
						                      FROM   ItemWarehouseLocationTransaction IWLT
											  WHERE  Warehouse = L.Warehouse												
											  AND    Location  = L.Location											 
											  AND    ItemNo IN (SELECT  ItemNo
														        FROM    Item
																WHERE   ItemNo = IWLT.ItemNo
														        AND     Category = '#Detail.Category#')
											  AND    TransactionType = '9'
											  AND    Operational = 1 
											  )
						AND      Operational = 1
						ORDER BY LocationClass,ListingOrder
						
				</cfquery>						
				
				<!--- added a safeguard to always show --->
								
				<cfif LocationSelect.recordcount eq "0">
									
					<!--- only geo locations --->
					   
					<cfquery name="LocationSelect" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   L.* , (SELECT SerialNo FROM AssetItem WHERE Assetid = L.AssetId) as SerialNo
							FROM     WarehouseLocation L
							WHERE    Warehouse  = '#get.Warehouse#'
							<cfif get.Locationid eq "">
							AND      LocationId is NULL			
							<cfelse>
							AND      LocationId = '#get.Locationid#'							
							</cfif>		
							AND      Location IN (SELECT Location 
							                      FROM   ItemWarehouseLocation IWL
												  WHERE  Warehouse = L.Warehouse												
												  AND    Location  = L.Location
												  AND    ItemNo IN (SELECT  ItemNo
														        	FROM    Item
																	WHERE   ItemNo = IWL.ItemNo
														        	AND     Category = '#Detail.Category#')
												 )
							AND      Operational = 1
							ORDER BY LocationClass,ListingOrder
														
					</cfquery>						
				
				</cfif>	
				
				<tr>
					 <td height="30" colspan="1" style="height:30" class="labelit"><cf_tl id="Usage">:</td>
					 
					 <TD colspan="2" style="height:30;padding-right:15px">
				
					<!--- check categories that have supplies defined --->
					
					<cfquery name="CategoryList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_Category
						WHERE  Category IN ( 
										      SELECT DISTINCT I.Category 
			                                  FROM   AssetItem AI, Item I
											  WHERE  AI.ItemNo = I.ItemNo
											  AND    AI.Mission = '#ShipTo.mission#'
											  AND    AI.AssetId IN (SELECT DISTINCT AssetId 
												                    FROM   AssetItemSupply P																			   
																	WHERE  AI.Assetid = P.Assetid)
											)					
						ORDER BY TabOrder			
					</cfquery>	
												
					<select name="usage_#left(storageid,8)#" id="usage_#left(storageid,8)#" class="regularxl">
					   
						<cfloop query="CategoryList">
							<option value="#Category#">#Description#</option>
						</cfloop>
						 <option value="">--- any of the above ---</option>
					</select>	
				
					</td>
				</tr>		

				<tr class="labelit">
				    <td class="labelit" valign="top" style="padding-top:3px">Request:</td>
				    <td colspan="2">
						<table width="100%" cellspacing="0" cellpadding="0" align="right">
																											  												
				<cfloop query="LocationSelect">

					<!--- now we show the items enabled under this storage location --->
					
					<cfquery name="getItems" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						
						SELECT I.ItemNo, I.ItemDescription, U.UoM, U.UoMDescription, ItemUoMDetails
						FROM   Item I, ItemUoM U
						WHERE  I.ItemNo  = U.ItemNo
						
						AND    I.ItemNo IN (												
											
								SELECT DISTINCT IWL.ItemNo
								FROM   WarehouseLocation AS WL INNER JOIN
								       ItemWarehouseLocation AS IWL ON WL.Warehouse = IWL.Warehouse AND WL.Location = IWL.Location
								
								<!--- all items in that storage that are enabled for request --->			
								
								WHERE   WL.StorageId = '#storageId#'		
								AND     IWL.UoM	= U.UoM																									 
								AND     WL.Location IN
								
								            (SELECT    Location
								              FROM     ItemWarehouseLocationTransaction
								              WHERE    Warehouse       = WL.Warehouse
											  AND      Location        = WL.Location
											  AND      ItemNo          = I.ItemNo
											  AND      UoM             = U.UoM		
											  AND      TransactionType = '9'
											  AND      Operational     = 1)
					
							)
						</cfquery>					
						
						
						<cfif getItems.recordcount eq "0">
									
							<!--- safeguard if no records are to be show for a selected location which is unlikely to happen --->
							   
							<cfquery name="getItems" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT I.ItemNo, I.ItemDescription, U.UoM, U.UoMDescription, ItemUoMDetails
									FROM   Item I, ItemUoM U
									WHERE  I.ItemNo  = U.ItemNo
									
									AND    I.ItemNo IN (												
														
												SELECT DISTINCT IWL.ItemNo
												FROM   WarehouseLocation AS WL INNER JOIN
												       ItemWarehouseLocation AS IWL ON WL.Warehouse = IWL.Warehouse AND WL.Location = IWL.Location
												
												<!--- all items in that storage that are enabled for request --->			
												
												WHERE   WL.StorageId = '#storageId#'		
												AND     IWL.UoM	= U.UoM		
											    AND     IWL.Operational = 1
											
											)
																
							</cfquery>		
						
						</cfif>					

						<cfset vLocation    = Location>	
						<cfset vDescription = Description>
						<cfset vStorageCode = StorageCode>
						<cfset vSerialNo    = SerialNo>																	
											
						<cfloop query="getItems">		
												
						    <!--- we show the description of the tank if we have also another storage location enabled for this warehouse, geolocation with the same item 
							otherwise we consider it as consolidated : also for validation --->
							  
							    <cfquery name = "qCheck" 
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">	
								  	  SELECT  RequestMode
									  FROM    WarehouseCategory WC
									  WHERE   WC.Warehouse   = '#get.warehouse#' 
									  AND     WC.Operational = 1 
									  AND     WC.Category    = '#URL.Category#'	
							    </cfquery>
																					
							    <!--- the location description is only shown if it is the only storage location for that geo location where the item is enabled --->
														
								<tr>					
								
									<td colspan="2" class="labelsmall">														
													
										<cfif qCheck.RequestMode eq "0">
																				
											<table cellspacing="0" cellpadding="0">
											
												<tr><td class="labelmedium" colspan="2" height="20" style="padding-right:4px">#vDescription#</td></tr>
												
												<cfif vSerialNo neq "" and len(vStorageCode) gte "5">
												<tr>
													<td class="labelit" style="padding-left:20px;padding-right:4px">#vStorageCode# <cfif vSerialNo neq ""><font color="808080">[#vSerialNo#]</cfif>:</td>									
												</tr>
												</cfif>
												
											</table>
																					
										<cfelse>
										
											Consolidated
											
										</cfif>												   
																					
									</td>
									
									<td align="right">
									
										<table width="100%" align="right" style="padding-right:15px">
										<tr>
										
										<td class="labelmedium" style="padding-right:5px;padding-left:15px">							
																				
											#ItemDescription#:
			
										</td>
										
										<td align="right" style="padding-right:4px">
										
											<cf_tl id="Invalid Quantity" var="1">
																										
											<cfinput type = "text" 
										       name       = "requestquantity_#locationSelect.Location#_#ItemNo#_#UoM#" 
											   id         = "requestquantity_#locationSelect.Location#_#ItemNo#_#UoM#" 
											   validate   = "float"
											   message    = "#lt_text#"
											   value      = "" 
											   class      = "regularxl" 
											   size       = "6" 
											   maxlength  = "8" 
											   style      = "text-align: center;"> 								   
																				   
									    </td>	
										
										<td width="80" class="labelit">#UoMDescription#</td>
										
										</tr>
										</table>
									
									</td>
																		
								</tr>													
								
								<tr><td colspan="3" class="linedotted"></td></tr>
																	
						</cfloop>
						   					
				</cfloop>
				
				</td>
				</tr>
				</table>	
				</td>
				</tr>
										
				
				<tr>
					 <td height="20" colspan="1" valign="top" style="padding-top:5px" class="labelit"><cf_tl id="Remarks">:</td>
					 
					 <TD colspan="2" style="padding-top:5px;padding-left:0px;padding-right:15px">
						 
								<textarea class="regular" 
								    name="requestremarks_#left(storageid,8)#" 
							        id="requestremarks_#left(storageid,8)#" totlength="200" onkeyup="return ismaxlength(this)" 
									style="width:100%;height:50;padding:4px;font-size:14px"></textarea>				
				     </td>
						 
				</tr>		
											  		
	      </table>
		 		  
		  </td>    
	   </tr>
	   	   
	   <tr><td colspan="3" height="6"></td></tr>	
	   
	   <tr><td colspan="3" class="linedotted"></td></tr>	
	   
	   <tr><td height="30" colspan="3" style="padding-left:10px;padding-top:4px" id="process">
	   
	     <table><tr>
		 	 
		      <td>
	      
		   	   <cf_tl id="Add to Request" var="vAdd">
	   	   	   <cf_tl id="Send Request for submission" var="vQuestion">
		   
			   <cf_button 
			   		ID="add3"
			   		icon="Images/add2.png" 
					iconheight="19" 
					mode="graylarge"
					width="180x" 
					label="#vAdd#" 
					fontweight="normal" 
					fontsize="15px" 
					height="20"
					color="black" 
					onclick="if (confirm('#vQuestion# ?')) { addtostock('#url.mission#') }">	
					
				</td>
				
				 <td style="padding-bottom:5px;padding-left:4px" valign="bottom"><input type="checkbox" name="notification" value="1"></td>
			     <td style="padding-bottom:5px;padding-left:4px" valign="bottom" class="labelit">Notify Submitter by EMail</td>
				
				</tr></table>	
		  		 
		   </td>
	   </tr>
	   
	   <tr><td colspan="3" class="linedotted"></td></tr>	
	   
	   <tr><td colspan="3" height="6"></td></tr>	

	</table>

</cfoutput>
