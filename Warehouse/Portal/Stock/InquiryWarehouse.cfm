
<!--- show in this template the stock for the warehouse to which the person has access, then the option to open the
warehouse to process --->

<cfif url.mission eq "">
	<table align="center">
	   <tr><td class="labelit">No entity selected</td></tr>
    </table>
	<cfabort>
</cfif>

<cfparam name="url.init" default="1">

<cfinclude template="../Stock/InquiryWarehouseData.cfm">

<cfif WarehouseList.City eq "">
	<table align="center"><tr><td class="labelit">No access was granted to any facilities. Please contact your administrator.</td></tr></table>
	<cfabort>
</cfif>

<cfquery name="WarehouseSelect" datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    DISTINCT WC.ListingOrder, W.warehouseName, W.Warehouse, W.City
	FROM      Warehouse W, Ref_WarehouseCity WC
	WHERE     W.City      = WC.City
	AND       W.Mission   = WC.Mission
	AND       W.Mission   = '#url.mission#'	
	AND       W.Warehouse IN (#QuotedValueList(WarehouseList.Warehouse)#)				
	ORDER BY  WC.ListingOrder, WarehouseName 
</cfquery>

<!--- ----------------------- --->
<!--- ------end of check----- --->
<!--- ----------------------- --->

<table width="100%" height="100%" cellspacing="0" cellpadding="0" style="padding-left:12">	


    <!--- ---------------------------- --->
	<!--- check if anything is pending --->
	<!--- ---------------------------- --->
					
	<cfif WarehouseSelect.recordcount gte "5">
	
		<tr>
			<cfoutput>
				<td style="padding-top:6px; padding-left:8px; cursor:pointer;" class="labelmedium" onclick="toggleArea('##warehouseselect','##warehouseselect_twistie','#session.root#/images/arrowdown3.gif','#session.root#/images/arrowright.gif');">
					<table>
						<tr>
							<td style="padding:6px;">
								<img id="warehouseselect_twistie" src="#session.root#/images/arrowdown3.gif" height="11" width="11">
							</td>
							<td class="labelmedium" valign="middle">Select default facilities to be shown</td>
						</tr>
					</table>
				</td>
			</cfoutput>
		</tr>
		
		<cf_PortalDefaultValue 
			systemfunctionid = "#url.systemfunctionid#" 
			key       = "Warehouse" 
			ResultVar = "SelectedWarehouse">
	
		<!--- if we have more than 5 potential facilities then we show the filter ---> 
		
		<cfif selectedWarehouse eq "">
			<cfset cl ="regular">
		<cfelse>
			<cfset cl = "hide">
		</cfif>	
			
		<tr>
		   <td name="warehouseselect" id="warehouseselect" class="<cfoutput>#cl#</cfoutput>" style="padding-left:40px;border-bottom:0px dotted silver">
	
		    <cfif warehouseselect.recordcount gte "10">
				<cfset ht = "300">
			<cfelse>
				<cfset ht = "150">
			</cfif>
			
			<cf_divscroll height="#ht#">		
			<cfinclude template="InquiryWarehouseSelect.cfm">	
			</cf_divscroll>
						
		   </td>
	   </tr>			
		
		<tr><td height="3"></td></tr>		

		<cfset selwhs = "">
	
		<cfloop index="whs" list="#SelectedWarehouse#" delimiters=",">
		   <cfif selwhs eq "">
		     <cfset selwhs = "'#whs#'">
		   <cfelse>
		   	 <cfset selwhs = "#selwhs#,'#whs#'">
		   </cfif>
		</cfloop>	
		
		<!--- apply default filter --->
				
		<cfquery name="WarehouseList"  dbtype="query">
		    SELECT    *
			FROM      WarehouseList
			<cfif selwhs eq "">
			WHERE  1=0
			<cfelse>
			WHERE     Warehouse IN (#preservesingleQuotes(selwhs)#)	
			</cfif>
	    </cfquery>		
	
	<cfelse>
	
			<!--- regular user for one or more facilities then we show the notifier --->
	
			<tr><td colspan="13" align="center" >
				<cfdiv id="checkpending" bind="url:#session.root#/warehouse/portal/checkout/checkPending.cfm?mission=#url.mission#">				
			</td>
			</tr>
		
	</cfif>
		
			
	<tr>
		<td style="padding-left:10px;padding-right:18px">	
			<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">	
				<tr>	
					<td width="30%"></td> 
					<td align="center" bgcolor="ffffcf" class="verdana" colspan="2" height="20" style="border:1px dotted silver"><cf_tl id="Request"></td>
					<td width="30"></td>
					<td align="center" bgcolor="ECFFFF" class="verdana" colspan="4" height="20" style="border:1px dotted silver"><cf_tl id="Stock"></td>     
					<td width="30"></td>						
				</tr>	
				<tr><td height="2" colspan="12"></td></tr>	
				<tr>  
					<td width="30%" class="label"><cf_tl id="Storage"></td>   
					<td align="right" class="label"><cf_space spaces="23"><cf_tl id="Pending"><br><cf_tl id="Submission"></td>
					<td align="right" class="label"><cf_space spaces="23"><cf_tl id="Submitted"><br><cf_tl id="Quantity"></td>
					<td width="30" class="label"></td>
					<td align="right" class="label"><cf_space spaces="25"><cf_tl id="Minimum Stock"><br><cf_tl id="Requirement"></td>
					<td align="right" class="label"><cf_space spaces="20"><cf_tl id="Storage"><br><cf_tl id="Capacity"></td>
					<td align="right" class="label"><cf_space spaces="20"><cf_tl id="Storage"><br><cf_tl id="Ullage"></td>						
					<td align="right" class="label"><cf_space spaces="20"><cf_tl id="On Hand"></td>							
					<td width="30" class="label"></td>
					<td align="right" class="label"><cf_space spaces="20"><cf_tl id="Usable"><br><cf_tl id="Stock"></td>  
					<td align="right" class="label"><cf_space spaces="20"><cf_tl id="Days of"><br><cf_tl id="Supply"></td>   
					<td align="right" class="label"><cf_space spaces="20"><cf_tl id="Last"><br><cf_tl id="Updated"></td>  
					<td width="3"><cf_space spaces="2"></td>						
				</tr>				
				<tr>
					<td colspan="12" class="linedotted">&nbsp;</td>
				</tr>				
			</table>
		</td>
	</tr>	
		
	<tr>
		<td height="100%" valign="top">	
						
			<table cellpadding="0" cellspacing="0" width="100%" height="100%">				
				<tr>
					<td valign="top" height="100%" >	
					
					    <cf_divscroll id="whsdetail">
						<cfset url.init = "1">
						<cfinclude template="InquiryWarehouseMain.cfm">		
						</cf_divscroll>			
					
					</td>
				</tr>
			</table>
			
		</td>
	</tr>
	
</table>

	
