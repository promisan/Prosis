
<cfparam name="url.detailmode" default="edit">

<cfif URL.Mode eq "Entry">
  <!--- save the info in a temp table --->
  <cfset tbld = "stPurchaseLineReceiptDetail">  
<cfelse>
  <cfset tbld = "PurchaseLineReceiptDetail">
</cfif>  

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table" style="border:1px solid silver">

    <tr bgcolor="e1e1e1" class="line">	
	
	    <td height="18"></td>
		<td colspan="2" align="center" class="labelit">Source</td>	
		<td colspan="3" align="center" class="labelit" style="border-left:1px solid gray">Meter Reading</td>		
		<td colspan="3" align="center" class="labelit" style="border-left:1px solid gray">Received</td>
		<td colspan="2" align="center" class="labelit" style="border-left:1px solid gray">Dipping</td>
		<td colspan="2" align="center" class="labelit" style="border-left:1px solid gray">Density %</td>
		<td colspan="2" align="center" class="labelit" style="border-left:1px solid gray">Temperature oC</td>
		
	</tr>
	
	<tr bgcolor="f1f1f1" class="line">
	
		<td></td>
		<td class="labelit" style="border-left:0px solid silver">Name</td>
		<td class="labelit" align="center">Shipped</td>	
		
		<td align="center" class="labelit" style="border-left:1px solid gray"><cf_tl id="Pump"></td>
		<td align="center" class="labelit">Initl</td>
		<td align="center" class="labelit">Final</td>		
		
		<td align="center" class="labelit" style="border-left:1px solid silver">Quantity</td>	
		<td align="center" class="labelit">Diff.</td>	
		<td align="center" class="labelit"><cf_tl id="Storage"></td>		
		
		<td align="center" class="labelit" style="border-left:1px solid gray">Vendor</td>
		<td align="center" class="labelit" width="30">OnSite</td>
		<!--- hidden 
		<td align="center" width="30">2nd.</td>
		<td align="center" width="30">3rd.</td>
		--->
		
		<td align="center" class="labelit" style="border-left:1px solid gray">Vendor</td>
		<td align="center" class="labelit">OnSite</td>
		
		<td align="center" CLASS="LABELIT"  STyle="border-left:1px solid gray">Vendor</td>
		<td align="center" class="labelit">OnSite</td>
		
	</tr>	
			
	 <cfquery name="CheckPrior" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	    SELECT *
	    FROM   #tbld#
		WHERE  ReceiptId = '#URL.Rctid#'						
	 </cfquery>
	
	<cfif url.detailmode eq "edit">
	
		<cfquery name="param" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			   SELECT    *
			   FROM      Ref_ParameterMission
			   WHERE     Mission = '#PO.mission#'  
		</cfquery>	
			
		<cfparam name="TaskOrder.ShipToWarehouse" default="">	
		<cfparam name="TaskOrder.SourceWarehouse" default="">	
		
		<cfquery name="units" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * 
		  FROM   Warehouse 
		  WHERE  (Warehouse = '#TaskOrder.ShipToWarehouse#' 
		       OR Warehouse = '#TaskOrder.SourceWarehouse#') 
	    </cfquery>		
	
		<cfquery name="Lookup" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   
			SELECT   DISTINCT AssetBarCode
			FROM     AssetItem A
			WHERE    Mission     = '#PO.Mission#'
			AND      Operational = 1 
			
			<!--- receipt devicde--->
			
			AND      ItemNo IN  (SELECT  ItemNo
	                             FROM    Item
	                             WHERE   ItemNo = A.ItemNo AND Category = '#param.ReceiptDevice#') 
									
			<!--- is hold by the warehouse of the receipt --->		
			
			<cfif units.MissionOrgUnitId neq "">
				
			AND      AssetId IN
	                           (SELECT  AssetId
	                            FROM    AssetItemOrganization O
								<!--- all orgunit in different mandates --->
	                            WHERE   OrgUnit IN  (SELECT OrgUnit
	                                                 FROM   Organization.dbo.Organization
	                                                 WHERE  MissionOrgUnitId IN (#QuotedValueList(units.MissionOrgUnitId)#))
								
								<!--- only the last effective date for an item --->					   
								AND     DateEffective  =  (
															SELECT  MAX(DateEffective)
	                                                        FROM    AssetItemOrganization
	                                                        WHERE   AssetId = A.AssetId
														  ) 
															  
							 )		
							 
			</cfif>				 						  
													   
		</cfquery>	
	
		<cfif checkprior.recordcount gt rows>
		    <cfset rows = checkprior.recordcount>
		</cfif>			
		
	
	</cfif>		
	
	<cfif rows eq "0">
			
		<tr><td colspan="15" height="25" align="center" class="labelit">No details</td></tr>
			
	</cfif>	
						
	<cfloop index="itm" from="1" to="#rows#">
	
			<cfquery name="LineDetail" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   #tbld#
				WHERE  ReceiptId     = '#URL.Rctid#'
				AND    ReceiptLineNo = '#itm#'
			</cfquery>
						 
			<tr class="line labelmedium navigation_row">
			
			   <td align="center" class="labelit" style="height:21px;padding-left:3px;padding-right:4px">#itm#.
				   <input type="hidden" name="f#itm#_ReceiptLineNo" id="f#itm#_ReceiptLineNo" value="#itm#">
			   </td>
			   
			   <td style="padding-left:2px" align="left">
			   			   
			   	<cfif LineDetail.Containername eq "" and LineDetail.recordcount eq "0">
				
				   <cfif itm eq rows>
				   
				      <cfset nm = "Drain / Sample">
					  
				   <cfelse>
				   
				      <cfset nm = "Compartment">
					  
				   </cfif>	  
				   
				<cfelse>
				
				   <cfset nm = "#LineDetail.Containername#">   
				   
				</cfif>
				
				<cfif url.detailmode eq "edit">
			    
				    <cfinput type="Text" 
					  name   = "f#itm#_containername" id   = "f#itm#_containername"
					  value  = "#nm#" 						  						
					  class  = "regular3 enterastab"				  
					  required="No"
					  maxlength="50" 				  
					  style="padding-left:2px;border:0px solid silver;height:100%;text-align: left;width:100%;padding-top:1px">
				  
				 <cfelse>
				 
				 	#nm#
				 
				 </cfif>
				
			   </td>
			   
			    <cfif itm eq rows>
				  <cfset cl = "ffffef">
				  <cfset md = "hide">
				<cfelse>
				  <cfset cl = "ffffef">
				  <cfset md = "show">
				</cfif>
			   				
				<td align="right" style="border-left:1px solid gray;padding-right:1px;padding-left:1px">
				
				<cfif url.detailmode eq "edit">
				
			    <cfinput type="Text" 
				  name="f#itm#_quantityshipped" id="f#itm#_quantityshipped" 
				  value="#LineDetail.QuantityShipped#" 
				  message="Enter a valid quantity" 
				  validate="float" 
				  class="regular3 enterastab"
				  required="No" 
				  size="6" 
				  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px" 
				  range="0,10000000"
				  onChange="ColdFusion.navigate('ReceiptLineEditSetQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','entry')">
				  
				 <cfelse>
				 
				 #LineDetail.QuantityShipped#
				 
				 </cfif> 
				  
			   </td>
			   
			   <td style="width:100;border-left:1px solid gray;padding-left:3px;padding-right:1px" bgcolor="#cl#" align="center">
			   
			   <cfif url.detailmode eq "edit">
			   
				   <cfif md eq "show">				   
				   
					   <cfif lookup.recordcount gte "1">		
						
							<select class="enterastab" style="border:0px;font-size:14px;width:100%;height:100%;" name="f#itm#_containerseal" id="f#itm#_containerseal">
							<cfloop query="lookup">					
								<option value="#AssetBarCode#" <cfif LineDetail.ContainerSeal eq AssetBarCode>selected</cfif>>#AssetBarCode#</option>					
							</cfloop>					
							</select>														
				   
				        <cfelse>
				   				   
						     <cfinput type="Text" 
							  name="f#itm#_containerseal" id="f#itm#_containerseal" 
							  value="#LineDetail.ContainerSeal#" 						  						 
							  class="regular3 enterastab"
							  required="No" 
							  style="border:0px solid silver;height:100%;text-align: center;width:100%;padding-top:1px;padding-right:2px" 
							  maxlength="10" 
							  size="10">
						  
		 			   </cfif>				   
				   					  
	 			   </cfif>			   
				   
			   <cfelse>
			   
			   	   #LineDetail.ContainerSeal#
			   
			   </cfif>
				  
			   </td>
			   
			   <td bgcolor="#cl#" align="right" style="border-left:1px solid gray;padding-left:1px;padding-right:1px">
			   
			    <cfif md eq "show">
			   			   
				    <cfif url.detailmode eq "edit">		
					   
				    <cfinput type="Text" 
					  name="f#itm#_meterreadinginitial" 
					  id="f#itm#_meterreadinginitial" 
					  value="#LineDetail.MeterReadingInitial#" 
					  message="Enter a valid quantity" 
					  validate="float" 
					  class="regular3 enterastab"
					  required="No" 				  
					  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px" 
					  range="0,10000000"
					  onChange="ColdFusion.navigate('ReceiptLineEditSetQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','entry')">
					  
					<cfelse>
					
					#LineDetail.MeterReadingInitial#
					
					</cfif>  
					  
				  </cfif>
			   			   
			   </td>
			   
			   <td bgcolor="#cl#" align="right" style="border-left:1px solid gray;padding-right:1px;padding-left:1px;">
			   
			   	 <cfif md eq "show">
				 
				 	<cfif url.detailmode eq "edit">	
			   			   
				     <cfinput type="Text" 
					  name="f#itm#_meterreadingfinal" 
					  id="f#itm#_meterreadingfinal" 
					  value="#LineDetail.MeterReadingFinal#" 
					  message="Enter a valid quantity" 
					  validate="float" 
					  class="regular3 enterastab"
					  required="No" 				  
					  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px" 
					  range="1,10000000"
					  onChange="ColdFusion.navigate('ReceiptLineEditSetQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','entry')">
					  
					<cfelse>
					
					#LineDetail.MeterReadingFinal#
					
					</cfif>
					  
				  </cfif>			   
			   
			   </td>
			   
			   <td style="padding-left:2px;border-left:1px solid gray;background-color:f1f1f1;padding-right:1px" align="right">				   
			   
			     <cfif url.detailmode eq "edit">		
			   
				     <cfif md eq "show">	   
				    
					    <cfinput type="Text" 
						  name="f#itm#_quantityaccepted" id="f#itm#_quantityaccepted"
						  value="#LineDetail.QuantityAccepted#" 				 
						  validate="float" 
						  readonly
						  class="regular3 enterastab"
						  required="No" 
						  size="6" 
						  style="border:0px solid silver;height:100%;background-color:f1f1f1;text-align: right;width:100%;padding-top:1px;padding-right:2px">
						  
					  <cfelse>
					  
					  	 <cfinput type="Text" 
						  name="f#itm#_quantityaccepted" id="f#itm#_quantityaccepted" 
						  value="#LineDetail.QuantityAccepted#" 				 
						  validate="float" 					  
						  class="regular3 enterastab"
						  required="No" 
						  size="6" 
						  style="border:0px solid silver;height:100%;background-color:f1f1f1;text-align: right;width:100%;padding-top:1px;padding-right:2px"
						  onChange="ColdFusion.navigate('ReceiptLineEditSetQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','entry')">
					  				  
					  </cfif>	 
					  
				 <cfelse>
				 
				 	#LineDetail.QuantityAccepted#				 
				 				 				 
				 </cfif> 
				 			   
			   </td>
			   
			   <td align="right" style="border-left:1px solid gray;background-color:f1f1f1;padding-right:1px;padding-left:1px">
			   
			   <cfif url.detailmode eq "edit">	
			   
			    <input type="Text" 
					  name="f#itm#_quantityvariance" 
                      id="f#itm#_quantityvariance"
					  value="#LineDetail.QuantityVariance#" 
					  readonly
					  tabindex="999"					  
					  class="regular3 enterastab"						
					  size="6" 
					  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px">
					  
				<cfelse>
				
				<!--- #LineDetail.QuantityVariance# --->
				
				</cfif>  
				  
			   </td>	
			   
			   <td style="border-left:1px solid gray;padding-right:1px" bgcolor="#cl#" width="150" align="center">
			 		 
			 			   
			    <cfif url.detailmode eq "edit">	
							   
				   <cfif md eq "show">
				   				   										   
					   <cfquery name="getInit" 
						 datasource="AppsSystem"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						   SELECT * 
						   FROM   Parameter			 
					   </cfquery>		
						
					   <cfif getInit.VirtualDirectory neq "">						   
					       <cfset lnk = "#getInit.VirtualDirectory#.component">						
					   <cfelse>					   
					   	   <cfset lnk = "component">						
					   </cfif>
					  
										  <!--- 				
						<cfset lnk = "service">	   
					  --->	
					  
					  <!---
					  cfc:#lnk#.Input.InputDropdown.getlocation({warehouse},'#whsitemno#')
					  --->		
					 					 					  					  		   		  			 			   
					   <cfselect name = "f#itm#_storageid" id = "f#itm#_storageid" 
					       style      = "border:0px;font-size:14px;width:100%;height:100%;" 
					   	   bind       = "cfc:#lnk#.Input.InputDropdown.getlocation({warehouse},'#whsitemno#')"
						   bindonload = "yes"
						   queryposition="below"
						   class      = "enterastab"
					       value      = "storageid" 
						   display    = "Description" 					  
						   selected   = "#LineDetail.storageid#"/>		
						  					   
				   </cfif>
				   
				 <cfelse>			
				 
				 	<cfif linedetail.storageid eq "">
					
						<cfif LineDetail.QuantityAccepted neq "">[default]</cfif>
					
					<cfelse>
								 
						<cfquery name="Location" 
						  datasource="AppsMaterials" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						    SELECT *
						    FROM   WarehouseLocation					    
							WHERE  StorageId = '#lineDetail.storageId#' 
						</cfquery>
						
						<cfif Location.recordcount eq "0">
						
						[default]
						
						<cfelse>
											 
					 	#Location.Description#
						
						</cfif>	 
					
					</cfif>
				 
				 </cfif>
			  
			   </td>
			   
			   <td style="border-left:1px solid gray;padding-right:1px;padding-left:1px" bgcolor="#cl#" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	 <cfif md eq "show">
			   
				     <cfinput type="Text" 
						  name="f#itm#_measurement0" id="f#itm#_measurement0" 
						  value="#LineDetail.Measurement0#" 				 
						  validate="float" 				 
						  class="regular3 enterastab"
						  required="No" 
						  size="6" 
						  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px">	
				  
				  </cfif>	
				  
			   <cfelse>
			   
			   #LineDetail.Measurement0#
			   
			   </cfif>	   
			   
			   </td>
			   
			   <td bgcolor="#cl#" align="right" style="border-left:1px solid gray;padding-right:1px;padding-left:1px">
			   
			   <cfif url.detailmode eq "edit">
			   
			   	 <cfif md eq "show">
			   
			      <cfinput type="Text" 
					  name="f#itm#_measurement1" id="f#itm#_measurement1"
					  value="#LineDetail.Measurement1#" 				 
					  validate="float" 				 
					  class="regular3 enterastab"
					  required="No" 
					  size="6" 
					  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px">
				  
				  </cfif>
				  
			   <cfelse>
			   
			   		#LineDetail.Measurement1#
			   
			   </cfif>
			   
			   </td>
			   
			   <!--- hidden for now as per request 17/12
			   
			   <td bgcolor="#cl#" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	 <cfif md eq "show">
			   
			      <cfinput type="Text" 
				  name="f#itm#_measurement2" 
				  value="#LineDetail.Measurement2#" 				 
				  validate="float" 				 
				  class="regular3"
				  required="No" 
				  size="6" 
				  style="text-align: right;width:100%;padding-top:1px;padding-right:2px">
				  
				  </cfif>
				  
			   <cfelse>
			   
			   #LineDetail.Measurement2#
			   
			   </cfif>
			   
			   </td>
			   
			   <td bgcolor="#cl#" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	 <cfif md eq "show">
				 	
			   
			      <cfinput type="Text" 
				  name="f#itm#_measurement3" 
				  value="#LineDetail.Measurement3#" 				 
				  validate="float" 				 
				  class="regular3"
				  required="No" 
				  size="6" 
				  style="text-align: right;width:100%;padding-top:1px;padding-right:2px">
				  
				 </cfif> 
				 
			   <cfelse>
			   
			   #LineDetail.Measurement3#
			   
			   </cfif>
			    
			   </td>
			   
			   --->
			   					   
			   <td style="border-left:1px solid gray;padding-right:1px;padding-left:1px" bgcolor="#cl#" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	 <cfif md eq "show">
			   
			       <cfinput type="Text" 
				  name="f#itm#_receiptmetric1" id="f#itm#_receiptmetric1"
				  value="#LineDetail.receiptmetric1#" 				 
				  validate="float" 				 
				  class="regular3 enterastab"
				  required="No" 
				  size="6" 
				  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px">
				  
				 </cfif> 
				 
			   <cfelse>
			   
			   #LineDetail.receiptmetric1#
			   
			   </cfif>
			   
			   </td>
			   
			   <td bgcolor="#cl#" style="border-left:1px solid gray;padding-right:1px;padding-left:1px" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	 <cfif md eq "show"> 
			   
			      <cfinput type="Text" 
				  name="f#itm#_receiptmetric2" id="f#itm#_receiptmetric2"
				  value="#LineDetail.receiptmetric2#" 				 
				  validate="float" 				 
				  class="regular3 enterastab"
				  required="No" 
				  size="6" 
				  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px">
				  
				  </cfif>
				  
			   <cfelse>
			   
			   #LineDetail.receiptmetric2#
			   
			   </cfif>
			    
			   </td>	
			   
			   <td style="border-left:1px solid gray;padding-right:1px;padding-left:1px" bgcolor="#cl#" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	   <cfif md eq "show">	
			   
			   	     <cfinput type="Text" 
					  name="f#itm#_receiptmetric3" id="f#itm#_receiptmetric3"
					  value="#LineDetail.receiptmetric3#" 				 
					  validate="float" 				 
					  class="regular3 enterastab"
					  required="No" 
					  size="6" 
					  style="border:0px solid silver;height:100%;text-align: right;width:100%;padding-top:1px;padding-right:2px">
				  
				  </cfif>
				  
			   <cfelse>
			   
			   #LineDetail.receiptmetric3#
			   
			   </cfif>
			  				  
			   </td>	
			   
			   <td bgcolor="#cl#" style="border-left:1px solid gray;padding-right:1px;padding-left:1px" align="right">
			   
			   <cfif url.detailmode eq "edit">	
			   
			   	   <cfif md eq "show">	
				   			   
			        <cfinput type="Text" 
					  name="f#itm#_receiptmetric4" id="f#itm#_receiptmetric4"
					  value="#LineDetail.receiptmetric4#" 				 
					  validate="float" 				 
					  class="regular3 enterastab"
					  required="No" 
					  size="6" 
					  style="border:0px solid silver;height:100%x;text-align: right;width:100%;padding-top:1px;padding-right:2px">
			  
			      </cfif>
				  
			   <cfelse>
			   
			   #LineDetail.receiptmetric4#
			   
			   </cfif>
				  
			   </td>
			   
		   </tr>
		   
		  
		
					
	</cfloop>

</table>

</cfoutput>
	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             