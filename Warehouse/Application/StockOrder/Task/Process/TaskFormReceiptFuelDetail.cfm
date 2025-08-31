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
<cfparam name="url.BatchNo" default="0">
<cfparam name="editmode" default="edit">

<cfquery name="UoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemUoM
	WHERE  ItemNo  = '#getTask.ItemNo#'							
</cfquery>

<input type="hidden" name="ItemNo"  value="<cfoutput>#getTask.ItemNo#</cfoutput>">
<input type="hidden" name="ItemUoM" value="<cfoutput>#getTask.UoM#</cfoutput>">

<cfoutput>

<style>
 td.cell { border:0px dotted silver }
</style>

<cfif getTask.ShipToMode eq "Deliver">
      <cfset whs = getTask.ShipToWarehouse>
<cfelse>
      <cfset whs = getTask.SourceWarehouse>
</cfif>		
 
<cfquery name="getWarehouse" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    Warehouse
		WHERE   Warehouse = '#whs#'						
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0" border="0">

    <tr bgcolor="fafafa">	
	
	    <td bgcolor="white"></td>
		<td height="20" colspan="1" width="32%" align="left" style="padding-left:2px" class="cell labelit">
		
		<cfif getTask.ShipToMode eq "Deliver"><b>TO</b><cfelse><b>FROM</b></cfif> #getWarehouse.WarehouseName#</td>			
		<td colspan="4"  align="center" class="labelit cell" style="padding-left:1px"><cf_tl id="Meter reading"></td>	
		<td colspan="2"  align="center" class="labelit cell" style="padding-left:1px"><cf_tl id="Observations"></td>				
		<td colspan="1"  align="center" class="labelit cell" style="padding-left:1px"><cf_tl id="Issued"></td>

	</tr>
	
	<tr><td colspan="9" class="linedotted"></td></tr>
	
	<tr bgcolor="ffffdf">
	
		<td bgcolor="white"></td>
		<td height="20" colspan="1" align="center">&nbsp;</td>					
		<td class="labelit cell" align="center"><cf_tl id="Pump"></td>			
		<td class="labelit cell" align="center" width="80"><cf_tl id="Initial"></td>
		<td class="labelit cell" align="center" width="80"><cf_tl id="Final"></td>	
		<td class="labelit cell" align="center" width="80"><cf_tl id="UoM"></td>	
		<td class="labelit cell" align="center" width="70"><cf_tl id="Temp."></td>
		<td class="labelit cell" align="center" width="70"><cf_tl id="Density"></td>	
		<td class="labelit cell" align="center" width="100">
		<cfif editmode eq "view">
		
			<cfquery name="getUoM" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			    SELECT *
			    FROM   ItemUoM
				WHERE  ItemNo  = '#getTask.ItemNo#'		
				AND    UoM    =  '#getTask.UoM#'					
			</cfquery>	
			
			#getUoM.UoMDescription#			
			
		<cfelse>
			<cf_tl id="Quantity">
		</cfif>
		
		</td>	
						
	</tr>	
		
	<tr class="hide"><td id="processlines"></td></tr>
		
	<!--- make row a parameter --->
	
	<cfset rows = "4">
				
	<cfquery name="CheckPrior" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ItemTransaction
		WHERE  TransactionBatchNo = '#URL.BatchNo#'		
		AND    TransactionQuantity < 0				
	</cfquery>
				
	<cfif checkprior.recordcount gt rows>
	    <cfset rows = checkprior.recordcount>
	</cfif>			
	
	<cfset total = "0">
	
	<!--- receipt / device --->
		
	<cfquery name="units" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT * 
	  FROM   Warehouse 
	  WHERE  (Warehouse = '#getTask.ShipToWarehouse#' OR Warehouse = '#getTask.SourceWarehouse#')
    </cfquery>		
	
	<cfquery name="Lookup" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   
		SELECT   DISTINCT AssetBarCode
		FROM     AssetItem A
		WHERE    Mission = '#getTask.Mission#'
		AND      Operational = 1 
		<!--- receipt devicde--->
		AND      ItemNo IN  (SELECT  ItemNo
                             FROM    Item
                             WHERE   ItemNo = A.ItemNo AND Category = '#param.ReceiptDevice#')
		<!--- is hold by the warehouse of the receipt --->			
		AND      AssetId IN
                          (SELECT  AssetId
                           FROM    AssetItemOrganization O
						<!--- all orgunit in different mandates --->
                          WHERE   OrgUnit IN  (SELECT OrgUnit
                                               FROM   Organization.dbo.Organization
                                               WHERE  MissionOrgUnitId IN (#QuotedValueList(units.MissionOrgUnitId)#))
						
						<!--- only the last effective date for an item --->					   
						AND     DateEffective  =   (SELECT  MAX(DateEffective)
                                                    FROM    AssetItemOrganization
                                                    WHERE   AssetId = A.AssetId) 
													  
					 )								  
												   
	</cfquery>			
			
	<cfloop index="itm" from="1" to="#rows#">
	
			<cfquery name="LineDetail" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   ItemTransactionDetail
				WHERE  TransactionId  IN (SELECT TransactionId 
				                          FROM   ItemTransaction 
										  WHERE  TransactionBatchNo = '#URL.BatchNo#')		
				AND    TransactionLineNo = '#itm#'				
			</cfquery>
			
			<cfquery name="Line" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  *
			    FROM    ItemTransaction
				<cfif LineDetail.transactionid eq "">
				WHERE   1 = 0
				<cfelse>
				WHERE   TransactionId  = '#LineDetail.transactionid#'
				</cfif>						
			</cfquery>
			
			<cfquery name="Location" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT  *
			    FROM    WarehouseLocation
				WHERE   Warehouse = '#line.warehouse#'
				AND     Location  = '#line.Location#'			
			</cfquery>
			
			<tr>		
						   
			    <cfif itm eq "9999">
								
				  <cfset cl = "f4f4f4">
				  <cfset md = "hide">
				<cfelse>
				  <cfset cl = "white">
				  <cfset md = "show">
				</cfif>			
			
			   <td align="center" class="cell labelsmall" height="20" width="35">#itm#.
				  
				  <input type="hidden" name="f#itm#_ReceiptLineNo" id="f#itm#_ReceiptLineNo" value="#itm#">
				  
			   </td>		
			   
			   <td style="padding:2px;" align="center" class="labelit cell" bgcolor="#cl#">
				  
				  <cfif editmode eq "view">#Location.Description# #Location.StorageCode#
				  					
				  <cfelse>	
				  
				   <cfif getTask.ShipToMode eq "Deliver">
				      <cfset whs = getTask.ShipToWarehouse>
				   <cfelse>
				      <cfset whs = getTask.SourceWarehouse>
				   </cfif>				   
				   
				   <cfquery name="getWarehouse" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT  *
					    FROM    Warehouse
						WHERE   Warehouse = '#whs#'						
					</cfquery>
				 			  			 			   
				   <cfselect name    = "f#itm#_storageid" 
				       style         = "width:100%" 
				   	   bind          = "cfc:service.Input.InputDropdown.getlocation('#whs#','#getTask.ItemNo#')"
					   bindonload    = "yes"					   
					   queryposition = "below"
				       value         = "storageid" 
					   display       = "Description" 	
					   class         = "regularxl enterastab"
					   onchange      = "ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/setQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','formtask')"				  
					   selected      = "#Location.storageid#">		
					   		   
				   </cfselect>
				   
				   </cfif>
				 				  
			   </td>	
			   			   			   
			   <td style="padding:2px" align="center" class="labelit cell" bgcolor="#cl#" width="100">
			   
			   <cfif editmode eq "view">
			   
			   	#LineDetail.Reference1#
			   
			   <cfelse>
			   
				   <cfif md eq "show">
				   			
						<cfif lookup.recordcount gte "1">		
						
							<select style="width:100%" class="regularxl enterastab" name="f#itm#_Reference1" id="f#itm#_Reference1">
								<option value="">n/a</option>
								<cfloop query="lookup">					
								<option value="#AssetBarCode#" <cfif LineDetail.Reference1 eq AssetBarCode>selected</cfif>>#AssetBarCode#</option>					
								</cfloop>					
							</select>														
				   
				        <cfelse>
				   				   
						    <cfinput type="Text" 
							  name="f#itm#_Reference1" 
							  value="#LineDetail.Reference1#" 						  						 
							  class="regularxl enterastab"
							  required="No" 
							  style="text-align: left;width:100%;padding-top:1px;padding-right:2px" 
							  maxlength="15">
						  
		 			   </cfif>
					   
				   </cfif>	
			   
			   </cfif>   
			  
			   </td>
			   
			   <td bgcolor="#cl#" align="right" class="labelit cell" style="padding:2px" width="100">
			   
			   <cfif editmode eq "view">
			   
			   	#LineDetail.MeterReadingInitial#
			   
			   <cfelse>
			   
				    <cfif md eq "show">
				   			   
					    <cfinput type="Text" 
						  name="f#itm#_meterreadinginitial" 
						  value="#LineDetail.MeterReadingInitial#" 
						  message="Enter a valid quantity" 
						  validate="float" 
						  class="regularxl enterastab"
						  required="No" 				  
						  style="text-align: right;width:100%;padding-top:1px;padding-right:2px" 
						  range="0,10000000"
						  onChange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/setQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','formtask')">
						  
					  </cfif>
					  
				</cfif>
			   			   
			   </td>
			   
			   <td bgcolor="#cl#" align="right" class="labelit cell" style="padding:2px" width="100" >
			   
				   <cfif editmode eq "view">
				   
				   	#LineDetail.MeterReadingFinal#
				   
				   <cfelse>
			   
				   	 <cfif md eq "show">
				   			   
					     <cfinput type="Text" 
						  name="f#itm#_meterreadingfinal" 
						  value="#LineDetail.MeterReadingFinal#" 
						  message="Enter a valid quantity" 
						  validate="float" 
						  class="regularxl enterastab"
						  required="No" 				  
						  style="text-align: right;width:100%;padding-top:1px;padding-right:2px" 
						  range="1,10000000"
						  onChange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/setQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','formtask')">
						  
					  </cfif>	
					  
					</cfif>  		   
			   
			   </td>
			   
			   <td bgcolor="#cl#" align="center" class="labelit cell" style="padding:2px">
			   
			   <cfif editmode eq "view">
			   								   		
					<cfquery name="getUoM" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT *
					    FROM   ItemUoM
						WHERE  ItemNo  = '#getTask.ItemNo#'		
						AND    UoM    = '#LineDetail.MeterReadingUoM#'					
					</cfquery>								   	
			   
			   		<cfif getUoM.UoMdescription neq "">
				   		#getUoM.UoMDescription#	
					<cfelse>
						#LineDetail.MeterReadingUoM#	
					</cfif>		   
			   
			   <cfelse>			   
								   	
					<cfquery name="UoM" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT *
					    FROM   ItemUoM
						WHERE  ItemNo  = '#getTask.ItemNo#'							
					</cfquery>
			   
			   		<select style="width:80" class="regularxl enterastab" name="f#itm#_meterreadinguom" id="f#itm#_meterreadinguom"
					onChange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/setQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','formtask')">
						
						<cfloop query="uom">					
						<option value="#uom#" <cfif gettask.uom eq uom>selected</cfif>>#UoMDescription#</option>					
						</cfloop>	
										
					</select>	
					
				</cfif>	
							
			   </td>		
			   
			    <td bgcolor="#cl#" align="right" class="labelit cell" style="padding:2px">
			   
				   <cfif editmode eq "view">
				   
				   	#LineDetail.Measurement0#
				   
				   <cfelse>
			   
				   	 <cfif md eq "show">
				   			   
					     <cfinput type="Text" 
						  name="f#itm#_measurement0" 
						  value="#LineDetail.measurement0#" 
						  message="Enter a valid temperature" 
						  validate="float" 
						  class="regularxl enterastab"
						  required="No" 				  
						  style="text-align: right;width:100%;padding-top:1px;padding-right:2px" 
						  range="1,200">
						  
					  </cfif>	
					  
					</cfif>  		   
			   
			   </td>
			   
			    <td bgcolor="#cl#" align="right" class="labelit cell" style="padding:2px">
			   
				   <cfif editmode eq "view">
				   
				   	#LineDetail.Measurement1#
				   
				   <cfelse>
			   
				   	 <cfif md eq "show">
				   			   
					     <cfinput type="Text" 
						  name="f#itm#_measurementl" 
						  value="#LineDetail.measurement1#" 
						  message="Enter a valid density" 
						  validate="float" 
						  class="regularxl enterastab"
						  required="No" 				  
						  style="text-align: right;width:100%;padding-top:1px;padding-right:2px" 
						  range="1,200">
						  
					  </cfif>	
					  
					</cfif>  		   
			   
			   </td>			   
			   
			   <td align="right" style="padding:2px" class="labelit cell">	
			   
			     <cfif editmode eq "view">
				   
				   <cfif line.transactionQuantity neq "">

					   <cfif line.TransactionQuantity lt "0">
					   	   #Line.TransactionQuantity*-1#
					   <cfelse>
						   #Line.TransactionQuantity#
					   </cfif>					   
					  					   
				   <cfelse>				   
				   
				   </cfif>	   
				   
				 <cfelse>
			   
				     <cfif Line.TransactionQuantity neq "">
					     <cfset total = total+Line.TransactionQuantity>	
					 </cfif>
				   
				     <cfif md eq "show">	   
				    
					    <cfinput type="Text" 
						  name="f#itm#_quantityaccepted" 
						  value="#Line.TransactionQuantity#" 				 
						  validate="float" 
						  readonly
						  class="regularxl enterastab"
						  required="No" 
						  size="6" 
						  style="text-align: right;width:100%;padding-top:1px;padding-right:2px">
						  
					  <cfelse>
					  
					  	 <cfinput type="Text" 
						  name="f#itm#_quantityaccepted" 
						  value="#Line.TransactionQuantity#" 				 
						  validate="float" 					  
						  class="regularxl enterastab"
						  required="No" 
						  size="6" 
						  style="text-align: right;width:100%;padding-top:1px;padding-right:2px"
						  onChange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/setQuantity.cfm?form=fuel&rows=#rows#','processlines','','','POST','formtask')">
					  				  
					  </cfif>	
					  
				</cfif>  
				 			   
			   </td>
			   			  				   
		   </tr>
		   
		   <tr><td></td><td colspan="8" class="line"></td></tr>
					
	</cfloop>
	
	<cfif editmode neq "view">
	
	<tr>
		<td style="border:0px;padding-right:4px" bgcolor="fafafa" height="15" colspan="8" align="right" class="labelit"><cfif getTask.ShipToMode eq "Collect">Issued<cfelse>Received</cfif> in #getTask.UoMDescription#:&nbsp;</td>
		
		<td align="right" colspan="1" width="80" style="padding-left:3px;padding-right:8px">		
		
		<cfif getTask.ItemPrecision eq "0">
			<cfset qt = "#numberformat(total,'__,__')#">
		<cfelseif getTask.ItemPrecision eq "1">
		    <cfset qt = "#numberformat(total,'__,__._')#"> 		
		<cfelseif getTask.ItemPrecision eq "2">
			 <cfset qt = "#numberformat(total,'__,__.__')#"> 
		<cfelseif getTask.ItemPrecision eq "3">
			 <cfset qt = "#numberformat(total,'__,__.___')#"> 
		</cfif>	
				
		<input type   =  "Text" 
		     id       =  "transactionquantity" 
			 name     =  "transactionquantity" 
			 message  =  "Enter a valid quantity" 
		     validate =  "float" 
			 required =  "No" 			
			 tabindex = "999"  			
			 class    = "enterastab"
			 readonly
			 style    =  "height:28;width:100;font-size:15px;border:0px;text-align:right" 
			 visible  =  "Yes" 
			 enabled  =  "Yes" 
			 value    =  "#qt#">
			 			 					  
	    </td>
		
		</tr>	
		
		<tr><td height="3"></td></tr>
		
	</cfif>	

</table>

</cfoutput>
	