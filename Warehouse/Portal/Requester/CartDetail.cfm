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
<!--- check if the price is to be shown       --->

<cfparam name="url.itemlocationid" default="">

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT     *
	FROM       Ref_ParameterMission
	WHERE      Mission = '#url.mission#'	
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfoutput>
	
	<TR height="23">
	
	    <TD style="padding-left:2px"></TD>	
		<TD class="labelit" width="10%"><font color="808080"><cf_tl id="Request Date"></TD>	
		<TD class="labelit" width="10%"><font color="808080"><cf_tl id="Requester"></TD>		 		
		<TD class="labelit" width="10%" style="padding-left:2px"><font color="808080"><cf_tl id="Usage"></TD>				
		<TD class="labelit" width="20%" colspan="2"><font color="808080"><cf_tl id="Location"></TD>		
			
		<cfif url.itemlocationid eq "">	
			<TD class="labelit" width="25%"><font color="808080"><cf_tl id="Product"></TD>
		<cfelse>			
			<TD></TD>
		</cfif>		
		<TD class="labelit"><font color="808080"><cf_tl id="UoM"></TD>
		<TD class="labelit" align="right"><font color="808080"><cf_tl id="Quantity"></TD>	
		<cfif Param.RequestEnablePrice eq "1">
			<TD class="labelit" align="right"><font color="808080"><cf_tl id="Price"></TD>
			<TD class="labelit" align="right"><font color="808080"><cf_tl id="Amount"></TD>
		</cfif>
		<cf_assignid>
		<!--- ajax process box --->
		<TD id="process_#rowguid#" class="hide"></TD>
		<td></td>
	
	</TR>
	
	<tr><td colspan="12" class="linedotted"></td></tr>
				
	</cfoutput>
		
	<cfset total = 0>
	
	<cfoutput query="Cart" group="ShipToWarehouse">	
	
		<cfif url.itemlocationid eq "">
	
			<cfif shiptowarehouse neq "">
			
				<cfquery name="ShipTo" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT     *
					FROM       Warehouse
					WHERE      Warehouse = '#ShipToWarehouse#'	
				</cfquery>	
				
				<tr>
				<td colspan="11" style="height:30;padding-left:9px" class="labellarge">#ShipTo.WarehouseName# #ShipTo.City#</td>
				</tr>
						 													
			</cfif>
			
			<tr><td colspan="11" class="linedotted"></td></tr>
			
			<tr><td height="4"></td></tr>
			
		</cfif>	 
	
	    <cfoutput>		
			
		<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffef'))#" id="row#cartid#">			
						
			<td style="padding-left:6px;padding-right:6px" align="center">
						
			    <cfif url.mode eq "submit" or url.mode eq "regular">	<!--- the last one comes from --->
				    <input type="checkbox" name="selecteditem" value="'#cartid#'" checked>
				<cfelse>
				    <input type="hidden" name="selecteditem" id="selecteditem" value="'#cartid#'"> 	
				</cfif>
				
			</td>
			
			<cfquery name="Warehouse" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT     *
				FROM       Warehouse
				WHERE      Warehouse = '#warehouse#'	
		    </cfquery>	
			
			<td width="90" class="labelit">#Dateformat(Created, CLIENT.DateFormatShow)#</td>
			
			<TD class="labelit">
			
				<cfquery name="get" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT  * 
						FROM    UserNames 
						WHERE   Account = '#useraccount#'							
				</cfquery>
				
				#get.LastName#
			
			</TD>		
			
			<td style="padding-left:2px;height:24" class="labelit">#Category#</td>
						
			<TD colspan="2" width="15%" class="labelit">
			
				<cfif url.itemlocationid eq "">
			
					<cfif shiptowarehouse neq "" and shiptolocation neq "">
								
							<cfquery name="Ship" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
								SELECT  L.Location, 
										L.Description
								FROM    WarehouseLocation L 
								WHERE   L.Warehouse = '#ShipToWarehouse#' 
								AND     L.Location  = '#ShipToLocation#' 
							</cfquery>
							
							#Ship.Description#
										
					</cfif>
					
				<cfelse>
				
				--
				
				</cfif>
		
			</TD>
			
			
			<TD width="25%" class="labelit"><cfif url.itemlocationid eq "">#ItemNo# #ItemDescription#</cfif></TD>					
			<TD width="5%"	class="labelit">#UoMDescription#</td>			
			<TD align="right">
		
			   <input type = "text" 
			     name      = "quantity_#cartId#" 
				 id        = "quantity_#cartId#" 
				 value     = "#Quantity#" 
				 size      = "4" 
				 maxlength = "5" 
				 class     = "regularxl" 
				 style     = "border:1px solid gray;padding-top:0px;font-size:14px;height:20;background-color:yellow;text-align: center;"
		         onchange  = "cartedit('#cartId#',this.value,'process_#rowguid#')">
			 
			</TD>
			
			<cfif Param.RequestEnablePrice eq "1">
				<td class="labelit" align="right" style="padding-left:3px">#NumberFormat(CostPrice*UoMMultiplier,'__,____.__')#</td>
				<td align="right" class="labelit" style="padding-left:3px" id="total#cartid#">#NumberFormat(Quantity*CostPrice*UoMMultiplier,'__,____.__')#</td>
			</cfif>
			
			<td class="labelit" align="center" style="padding-top:3px;padding-left:10px;padding-right:10px">
			
			   <cf_img icon="delete" 
			        onclick="cartpurge('#cartid#','process_#rowguid#','#url.itemlocationid#')">
			   		 			   
	   		 </td>
			 
			 <cfif Param.RequestEnablePrice eq "1">	
				<cfset total = total + (Quantity*CostPrice*UoMMultiplier)>
			</cfif>	
			
		</TR>
		
		<cfif remarks neq "">		
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffef'))#" id="row#cartid#">			
				<td colspan="2" align="right" style="padding-right:5px"><font size="1" color="gray"><cf_tl id="Remarks">:</font></td>
				<td colspan="8"><font size="1" color="black">#Remarks#</td>				
			</tr>			
		</cfif>		
		
		<cfif ShipToLocationId neq "">		
			
			<cfquery name="Capacity" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				SELECT    SUM(MaximumStock) AS Total
				FROM      ItemWarehouseLocation IWL
				WHERE     Warehouse = '#ShipToWarehouse#' 
				AND       Location IN
	                           (SELECT   Location
	                            FROM     WarehouseLocation
	                            WHERE    Warehouse = IWL.Warehouse
								AND      Operational = 1 
								AND      LocationId = '#ShipToLocationid#')
				AND      Operational = 1				
				AND      ItemNo = '#ItemNo#' 
				AND      UoM    = '#UoM#' 
			</cfquery>				
			
			<cfif Capacity.Total lt Quantity and Capacity.total gte "1">
			
			<tr><td colspan="10" style="padding:2px">
			
				<cfquery name="Location" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   *
				FROM      Location
				WHERE     Location = '#ShipToLocationid#'
				</cfquery>				
			
				<table width="90%" bgcolor="E85226" style="border:1px solid gray" align="center"><tr><td class="labelmedium" style="padding-left:5px"><font color="FFFFFF">Requested quantity exceeds the #numberformat(Capacity.Total,'__,__')# capacity at <b>#Location.LocationName#</b></td></tr></table>
			
			</td></tr>
			
			</cfif>			
			
			<!---	Pending validation on capacity availability		
			
			<tr><td colspan="10" style="padding:2px">
			
				<table width="90%" bgcolor="yellow" style="border:1px solid gray" align="center"><tr><td class="labelmedium" style="padding-left:5px"><font color="black">Based on the current stock level; the average daily consumption there is by <b>31/6/2013</b> capacity to receive the requested quantity</b></td></tr></table>
					
			</td></tr>				
			
			--->
			
		
		</cfif>	
		
		<tr><td colspan="10" class="borderdotted"></td></tr>		
		
		</cfoutput>
	
	</cfoutput>
	
	<cfoutput>
		
	<cfif Param.RequestEnablePrice eq "1">	
		<tr>	    
			<td colspan="6" height="20"></td>		
			<td colspan="3" class="verdana"><cf_tl id="Total"></b></td>
		    <td colspan="1" align="right" class="verdana" style="border-top:1 px solid gray"><b>#NumberFormat(total,'__,____.__')#</b></td>
		</tr>	
	</cfif>
	
	</cfoutput>
	
</TABLE>
	