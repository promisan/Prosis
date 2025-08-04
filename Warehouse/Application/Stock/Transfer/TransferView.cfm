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

<!--- create transaction table ---> 
<cfparam name="URL.mission"            default="">
<cfparam name="Object.ObjectKeyValue4" default="">

<!--- selected location --->
<cfparam name="URL.height"             default="900">
<cfparam name="URL.systemfunctionid"   default="">

<!--- selection --->
<cfparam name="URL.mde"                default="">
<cfparam name="URL.loc"                default="0">
<cfparam name="URL.fnd"                default=""> <!--- search --->
<cfparam name="URL.stockorderid"       default="#Object.ObjectKeyValue4#">

<cfparam name="URL.Group"              default="Location">
<cfparam name="URL.Page"               default="1">

<cfquery name="Param"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_ParameterMission
		WHERE   Mission = '#URL.Mission#'
</cfquery>	

<cfset selloc = url.loc>

<cfif url.Group eq "">
    <cfset url.Group = "Location">
</cfif>

<cfif url.loc eq "0" and url.stockorderid eq "">

	<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		<tr><td align="center" height="60" class="labelmedium">
		Function was deprecated, use Receipt distribution function instead	
		</td></tr>
	</table>
	<cfabort>

</cfif>

<cfif url.stockorderid eq "">

	<cfinvoke component = "Service.Access"  
     method             = "WarehouseProcessor"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 warehouse          = "#url.warehouse#"		
	 SystemFunctionId   = "#url.SystemFunctionId#" 
	 returnvariable     = "access">	 	
	
	<cfif access eq "NONE" or access eq "READ">	 
	
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			   <tr><td align="center" height="40" class="labelit">			   
					<cf_tl id="Detected a Problem with your access"  class="Message">				
				   </td>
			    </tr>
		</table>	
		<cfabort>	
			
	</cfif>		
	
</cfif>	

<cfif URL.Page eq "1">
    <!--- prepare dataset --->	
	<cfinclude template="InitStockTransfer.cfm">	
</cfif>
		
<!--- show the result --->

<cfquery name="SearchResult"
	datasource="AppsTransaction" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Transfer#URL.Warehouse#_#SESSION.acc#	
	WHERE    1 = 1
	
	<cfif URL.fnd neq "">
	
		<!--- sync this search with the other receipt search --->
		AND 	(ItemNo                 LIKE '%#URL.fnd#%' 
			    	 OR ItemBarCode     LIKE '%#URL.fnd#%' 
					 OR ItemNoExternal  LIKE '%#URL.fnd#%' 
					 OR ItemDescription LIKE '%#URL.fnd#%'
					 OR TransactionLot  LIKE '%#URL.fnd#%'
					 OR TransactionReference LIKE '%#URL.fnd#%')		
					 
					 
					 
				  
	</cfif> 
						
	<cfif url.loc neq "" and url.stockorderid eq "">			
		AND  Location = '#selloc#' 
	</cfif>	
	
	<cfif url.mde eq "pending">
	AND     TransferQuantity is NOT NULL
	</cfif>
	
	ORDER BY #URL.Group#, 
	         Detail DESC, 
			 ItemDescription		 
</cfquery>

<form name="transferform" id="transferform" style="height:100%">

<cfoutput>
<input type="hidden" id="totalrecords" value="#Searchresult.recordcount#">
</cfoutput>

	<table width="100%" height="100%"> 
	
			<cfif url.stockorderid neq "">
			
			    <!---  this means the transactions comes from a workflow object --->
			
				<cfquery name="get"
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT  *
					FROM    TaskOrder
					WHERE   StockOrderId = '#URL.StockOrderId#'
				</cfquery>	
				
				<!--- get the location --->
				
				<cfoutput>
				
					<input type="hidden" name="mission"   id="mission"   value="#get.mission#">
					<input type="hidden" name="warehouse" id="warehouse" value="#get.warehouse#">	
				
					<cfset url.mission   = get.Mission>
					<cfset url.warehouse = get.Warehouse>
					<cfset url.locto     = get.Location>
					
					<cfquery name="getLocation"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  *
						FROM    WarehouseLocation
						WHERE   Warehouse = '#URL.warehouse#'
						AND     Location  = '#url.locto#'
					</cfquery>			
					
					<tr>
					<td style="border:0px dashed gray;padding-left:20;padding-top:7px;height:40" class="labellarge">
						<font color="0080C0"><cf_tl id="Transfer stock to tank">:&nbsp;</font><font size="4"><b>#getLocation.Description# (#getLocation.StorageCode#)</b></font>
					</td>
					</tr>
									
					<cfquery name="OnHand"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						
						SELECT     I.ItemDescription, 
						           U.UoMDescription, 
								   SUM(T.TransactionQuantity) AS OnHand  <!--- crosses UoM --->
						
						FROM       ItemTransaction AS T 
						           INNER JOIN Item I ON T.ItemNo = I.ItemNo 
								   INNER JOIN ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
								   
						WHERE      Warehouse = '#getLocation.Warehouse#'
						AND        Location  = '#getLocation.Location#'
						AND        T.ItemNo IN (SELECT R.ItemNo 
						                        FROM   RequestTask RT, Request R
												WHERE  R.RequestId =  RT.RequestId
												AND    RT.StockOrderId = '#URL.StockOrderId#'
												AND    R.ItemNo = T.ItemNo)
						GROUP BY   I.ItemDescription, 
						           U.UoMDescription
						
					</cfquery>
					
					<tr>
				
						<td>
							<table cellspacing="0" width="100%" cellpadding="0">
							
							<cfloop query="OnHand">
								<tr>
								<td align="right" style="padding-left:5px" class="labelit">#Itemdescription# on hand: </td>
								<td style="padding-right:4px;border:1px dotted silver" align="right" class="labellarge">
								#numberformat(OnHand,",__")#&nbsp; <font face="Verdana" size="2" color="gray">#uomdescription#</font>
								</td>
								</tr>
							</cfloop>
							</table>
						
						</td>
					
				    </tr>			
				
				</cfoutput>
				
			<cfelse>
				
				<cfinvoke component = "Service.Access"  
				     method             = "function"  
					 role               = "'WhsPick'"
					 mission            = "#url.mission#"
					 warehouse          = "#url.warehouse#"
					 SystemFunctionId   = "#url.SystemFunctionId#" 
					 returnvariable     = "access">			
				
				<cfif access eq "DENIED">	 
				
					<table width="100%" height="100%" 					       
						   align="center">
						   <tr><td align="center" height="40" class="labelit">
						    <font color="FF0000">
								<cf_tl id="Detected a Problem with your access"  class="Message">
							</font>
							</td></tr>
					</table>	
					<cfabort>	
						
				</cfif>		
			
			</cfif>
	
	 <tr>
	 
	 <td height="100%" valign="top">   
	    
		 <table width="100%" border="0" height="100%" align="center">	
		    	    
		  <tr class="hide"><td height="1" id="transferprocess"></td></tr>
		      
		  <cfif url.stockorderid eq "">			
					   	
			 <cfset rows = ceiling((url.height-110)/17)>
			 <cfset first   = ((URL.Page-1)*rows)+1>
			 <cfset pages   = Ceiling(SearchResult.recordCount/rows)>
			 <cfif pages lt "1">
			     <cfset pages = '1'>
		     </cfif>    
			
			 <cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Mode            = "get"
				Name            = "FunctionName"
				Key1Value       = "#url.SystemFunctionId#"
				Key2Value       = "#url.mission#"				
				Label           = "Yes">	  
				    	  		  
				  <!--- ------------------------------------------- --->
				  <!--- search bar for the standard transfer option --->
				  <!--- ------------------------------------------- --->
			
				  <tr class="line">
				  
					  <td style="width:100%">
					  
						  <table width="100%">
						 
						  <tr><td style="width:100%;padding-left:4px">
						  					  
						  		<table style="width:100%">		
								
								<tr class="labelmedium" style="height:35px">
								
								<cfoutput>
								<td style="font-size:20px;min-width:300px;">
								<cfif lt_content eq ""><cf_tl id="Stock transfer"><cfelse>#lt_content#</cfif></td>
								</cfoutput>
								 
								 <td align="right">
								
									 <table style="width:100%" border="0" align="right">
									 <tr>														
									 <td style="padding-left:20px;padding-right:20px;min-width:60px"><cf_tl id="Date/Time"></td>
									 <td align="right" style="padding-right:10px">
											
											 <cf_getWarehouseTime warehouse="#url.warehouse#">
											
											 <cf_setCalendarDate
											      name     = "transaction"     
												  id       = "transaction"   
											      timeZone = "#tzcorrection#"     
											      font     = "13"
												  edit     = "Yes"
												  class    = "regular"				  
											      mode     = "datetime"> 
												  
											</td>										
																																					  									
															
									 </td>			  											  
									 </tr>																				 
									 </table>
									  
								  </td>
								  </tr>
								  </table>
																				
							</td>							
							</tr>							
							</table>
							
						</td>
														
				  </tr>		
				  
				  <tr class="line">
				  
				  	<td style="height:25px;">
									  
				  	  <table width="100%">
					 							  
				      <td style="background-color:ffffaf;width:100px;padding-left:20px;font-size:16px;"><cf_tl id="Destination"></td>
								
					  <td>
								
						<table><tr><td>
				  				  										
						<cfquery name="Warehouse"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT 	*
								FROM   	Warehouse W
								WHERE  	1=1
								AND     (
								
								         (Mission   = '#url.Mission#' AND Warehouse = '#URL.Warehouse#')
										 OR 
										 Warehouse IN (SELECT AssociationWarehouse
								                       FROM   WarehouseAssociation 
													   WHERE  Warehouse           = '#URL.Warehouse#'
													   AND    AssociationType     = 'Transfer'
													   AND    AssociationWarehouse = W.Warehouse
													   )
																						
										)												
								
																						
						 </cfquery>	
							 
						 <cfoutput>
											
						  <select name  = "warehouseto"
						    id         = "warehouseto" 
							class      = "regularxxl"
							style      = "width:300px;border-left;1px solid silver;border:0px;font-size:16px;background-color:f1f1f1"
						    onchange   = "_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/warehouse/application/stock/Transfer/setLocation.cfm?systemfunctionid=#url.systemfunctionid#&whs=#url.warehouse#&warehouseto='+this.value,'locationbox')">
							
							<option value=""><cf_tl id="Select"></option>
						   
						   <cfloop query="Warehouse">
						   						   										
								<option value="#Warehouse#"><cfif mission neq url.mission><cf_tl id="Interoffice">:</cfif> #warehouse# #WarehouseName#</option>
														
							</cfloop>
						
						 </select>		
						 
						 </cfoutput>
						 
						 </td>
						 
						 <td class="labelmedium hide" style="padding-left:3px" id="locationrow">
						 <!--- <cf_tl id="Location">: --->
						 </td>
						 							 
						 <td id="locationbox" style="padding-left:4px;width:200px;border-left:1px solid silver;background-color:f1f1f1">							 							 		
								<input type="hidden" name="locationto" id="locationto" value="">																		
						 </td>									 
																			 
						 <td id="setvalue"></td>
						 
						 </tr>
						 </table>
								 
				 </td>
				  
				 </tr>
				 
				</table>
				
				</td>
				
				</tr>   
				  
		  <cfelse>
		  
		  	 <cfset rows    = 99>
			 <cfset first   = 1>
			 	  
		  </cfif>
		   		 					
		  <TR>
		  
		    <td valign="top" style="height:100%">
			
			   <table width="100%" height="100%" align="right">
							
					  <cfquery name="LocationList"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT    Location, 
							          CASE WHEN WL.StorageCode <> WL.Description THEN WL.StorageCode+' '+WL.Description ELSE WL.StorageCode END as Description,							         
									  R.Description as Class
							FROM      WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass R
							ON        WL.LocationClass = R.Code
							WHERE     WL.Warehouse = '#URL.Warehouse#'
							AND       Operational = 1
							ORDER BY  R.Description
						</cfquery>	
					
					<cfoutput>		
													
						<tr>
						
						<cfif LocationList.recordcount eq "1">
						
						  <input type="hidden" id="location" name="location" value="#LocationList.Location#">
						
						<cfelse>
						
						  <td valign="top" style="background-color:ffffff;height:100%;min-width:200px;width:200px;border-right:1px solid silver">
						
							<table height="100%">
							
							    <!---
								<tr class="line">						
									<td class="labelmedium" width="120" style="background-color:f1f1f1;height:27px;padding-left:10px;padding-right:10px;padding-bottom:0px"><cf_tl id="Filter Location"></td>
								</tr>
								--->						
								
								<tr>
								
								<td height="100%" style="padding-right:5px">
								
								<!-- <cfform> -->
								
									<!--- search option --->
										
									<cfselect id="location" name="location"
									     onchange="_cf_loadingtexthtml='';Prosis.busy('yes');_cf_loadingtexthtml='';stocktransfer('n','#url.systemfunctionid#')" 
										 query="LocationList" 
										 value="Location" 
										 queryposition="below"
										 display="Description" 
										 multiple="Yes"
										 style="background-color:ffffff;width:200px;height:100%;border:0px"
										 group="Class" 
										 class="regularxl"
										 selected="#selloc#">
																			
										<option value=""><cf_tl id="View all locations"></option>
										 
									</cfselect>	
								
								<!-- </cfform> -->
																		
								</td>								
								</tr>
							
							</table>
							
						</td>
						
						</cfif>
						
						<td height="100%" width="100%" valign="top" colspan="1" style="padding-bottom:4px">
						
							<table style="width:100%;height:100%">
											
							<TR bgcolor="ffffff" class="line"> 
					         
							  	<td style="padding-left:10px;padding-right:20px">
								 
								<table style="width:100%;height:100%"><tr>
																									
								<td style="padding-left:3px">			
										
								    <table width="98%" style="border-left:1px solid Silver;border-right:1px solid Silver;height:22px">
								   
									    <tr>
																			
										<td>					 				  	
										 <input style="border:0px;width:100%" type="text" name="find" id="find" value="#URL.Fnd#" maxlength="25" class="regularxl" onKeyUp="go()">							   
										</td>
										
										<td align="right" style="padding-right:1px;padding-right:4px"> 	   
									    							
										 <img src="#SESSION.root#/Images/search.png" 
											  alt         = "Search" 
											  id          = "locate" 								  
											  style       = "cursor: pointer;" 
											  border      = "0" 
											  height      = "22"
											  align       = "absmiddle" 
											  onclick     = "stocktransfer('n','#url.systemfunctionid#')"> 	  							  
									   	
									    </td>
										
										</tr>
									
									</table>					
											
								</td>	
								
								<TD height="14">		
								 
								<cfoutput>  
								
									<table width="100%">
									
										<tr>								
									
										<td>
										
										<select name="group" id="group" size="1" class="regularxl" style="border:0px;width:100%;border-left:1px solid silver;border-right:1px solid silver"					
											 onChange="stocktransfer('n','#url.systemfunctionid#')">
											 
										     <option value="Location" <cfif URL.Group eq "Location">selected</cfif>><cf_tl id="Group by Location">
										     <option value="ItemNo"   <cfif URL.Group eq "ItemNo">selected</cfif>><cf_tl id="Group by Item">
											 
										</select> 
										
										</td>
									
										<td colspan="1" style="padding-left:3px">
													
										     <select style="width:160px;border:0px;border-left:1px solid silver;border-right:1px solid silver" class="regularxl" onchange= "stocktransfer('n','#url.systemfunctionid#')" id="selmode">
											 	<option value="" <cfif url.mde eq "">selected</cfif>><cf_tl id="All items"></option>
												<option value="pending" <cfif url.mde eq "pending">selected</cfif>><cf_tl id="In Process"></option>
											 </select>
														
										</td>
									
									</tr>
									
									</table>
											
								</td>
								
								<td align="right" style="width:100px">
										
										<cf_securediv id="pagebox" 
										   bind="url:#session.root#/Warehouse/Application/Stock/Transfer/setPage.cfm?mde=#url.mde#&systemfunctionid=#url.systemfunctionid#&height=#url.height#&total=#SearchResult.recordCount#">
										
										</td>
										
								</cfoutput>		
								
								</tr>
								
								</table>	
											
								</TD>	
								
					        </TR>
											
							<tr><td style="height:100%;padding:5px">
						
						   <cf_divscroll id="content" overflowy="scroll">								
							   <cfinclude template="TransferViewContent.cfm">		  					
							</cf_divscroll>
							
							</td></tr>
							
							<tr style="border-top:1px solid silver">
		 							
									<td colspan="1" align="center">		
								  
									    <table width="100" align="center">
										
										<cfquery name="check"
							                dbtype="query">
											SELECT  *
											FROM    SearchResult
											WHERE   Quantity > 0
										</cfquery>			
										
										<cfif check.recordcount eq "0">			
											<tr><td id="save" class="hide" align="center" style="border:0px solid silver;padding:4px">			
										<cfelse>			
											<tr><td id="save" class="regular" align="center" style="border:0px solid silver;padding:4px">			
										</cfif>
									  
									    <!--- option to post the transaction --->
										
										<cfoutput>
										
										<!--- called from warehouse --->
										
										<cfquery name="whs"
										datasource="AppsMaterials" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										    SELECT  *
											FROM    Warehouse
											WHERE   Warehouse = '#URL.Warehouse#'
										</cfquery>						
														
										<cfinvoke component  = "Service.Access"  
										   method            = "RoleAccess" 
										   mission           = "#whs.mission#" 
										   missionorgunitid  = "#whs.missionorgunitid#" 
										   role              = "'WhsPick'"
										   parameter         = "#url.systemfunctionid#"
										   accesslevel       = "'1','2'"
										   returnvariable    = "accessright">	
										   
										<cfif accessright eq "GRANTED">		
															
											<cf_tl id="Post Transfer" var="vSubmit">
										   	<input name="Save" id="Save" type="button"
												 value="#vSubmit#" 
												 class="Button10g" 
												 style="width:270px;height:29px;font-size:13px" 
												 onclick="trfsubmit('#url.mission#','#url.systemfunctionid#','#url.stockorderid#','#url.loc#')">
											    					
										<cfelse>
										
											<cf_tl id="Transfer Quantities" var="vTransfer">
											<button name="Save" id="Save"
												 value="#vTransfer#" 
												 class="Button10s" disabled
												 style="width:230px;height:29px;font-size:13px">
											    	<cf_tl id="Submit Transfer">
											</button>								
															
										</cfif>   
										
										</cfoutput>
										
										</td></tr>
										</table>				
							  	   						  
								      </td></tr>
								  
								</table>	
							
							</td></tr>
											
						</table>					
													
						</td>	
						
						</tr>	
										
																										
					</cfoutput>					
															
			</table>
			
			</td>	  
						
		  </TR>		
	</table>    

</form>

      