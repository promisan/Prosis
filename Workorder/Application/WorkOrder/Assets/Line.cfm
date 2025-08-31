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
<cfparam name="URL.workorderid"   default="">	
<cfparam name="URL.workorderline" default="0">	
<cfparam name="URL.search"        default="">
<cfparam name="box"               default="">
<cfparam name="url.scope"         default="backoffice">
<cfparam name="url.page"          default="1">
<cfparam name="url.mode"          default="1">

<cfquery name="WorkOrder" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrder
	WHERE WorkorderId = '#URL.WorkOrderId#'	
</cfquery>

<cfquery name="WorkOrderLine" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  WorkOrderLine
	WHERE WorkorderId   = '#URL.WorkOrderId#'	
	AND   WorkOrderLine = '#url.workorderline#'
</cfquery>

<cfquery name="Parameter" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Ref_ParameterMission
	WHERE Mission = '#WorkOrder.Mission#'	
</cfquery>

<cfquery name="Customer" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Customer
	WHERE CustomerId = '#workorder.customerid#'	
</cfquery>

<cfif customer.orgunit eq "">

	<cfset access = "ALL">

<cfelse>

	<!--- define access --->

	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderProcessor" 
	   mission          = "#workorder.mission#" 
	   serviceitem      = "#workorder.serviceitem#"
	   returnvariable   = "access">	
	   
</cfif>	   

<cfquery name="Service" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  ServiceItem
	WHERE Code = '#WorkOrder.Serviceitem#'	
</cfquery>

<cfquery name="Domain" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ServiceItemDomain
	 WHERE   Code   = '#service.servicedomain#'	
</cfquery>

<cfquery name="CurrencyList" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Currency	
</cfquery>
	
<cfoutput>
	<cfsavecontent variable="qry">		
	    FROM    Materials.dbo.AssetItem A INNER JOIN 
		        WorkOrderLineAsset WO ON A.AssetId = WO.AssetId				
	    WHERE   WO.WorkOrderId = '#url.workorderid#'
		AND     WO.WorkOrderLine = '#url.workorderline#'	
		<cfif url.mode eq "1">	
		AND     WO.Operational = 1
		<cfelse>
		AND     WO.Operational = 0
		</cfif>
	</cfsavecontent>
</cfoutput>

<cfquery name="Total" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as Total 
    #preserveSingleQuotes(qry)#	
</cfquery>

<cf_pagecountN show="33" 
               count="#Total.Total#">
			   
<cfset counted  = total.total>		

<cfquery name="Detail" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP #last# A.SerialNo, 
	                  A.Make, 
					  A.Description, 
					  A.DepreciationBase, 
					  A.ItemNo,
					  
					  <!--- added to show an earlier date of the assignment if the same person had the device for the save reference --->
					  (
					  SELECT    MIN(WLA.DateEffective) AS DateInitial
					  FROM      WorkOrderLine WL INNER JOIN
                      			WorkOrderLineAsset WLA ON WL.WorkOrderId = WLA.WorkOrderId AND WL.WorkOrderLine = WLA.WorkOrderLine
					  WHERE     WL.Reference = '#workorderline.reference#' 
					  AND       WL.PersonNo  = '#workorderline.personno#' 
					  AND       WLA.AssetId  = A.AssetId
					  ) as DateInitial,					 
					  WO.*				
    #preserveSingleQuotes(qry)#		
	ORDER BY WO.Created DESC
</cfquery>

<cfif Detail.recordcount eq "0" and (access eq "EDIT" or access eq "ALL")>
     <cfparam name="URL.ID2" default="new">
<cfelse>
     <cfparam name="URL.ID2" default="">   
</cfif>
	
<table width="100%" align="center">
			
	<cfset cols = "12">
		
	<tr><td height="3" id="assetboxprocess"></td></tr>
			      
	<tr>
	
	    <td style="width:99%" colspan="4" align="center">
			
			<cfform name="assetform">
				  
		    <table width="99%" class="navigation_table">
					
		    <TR class="labelmedium line">
			   
			   <td height="20"></td>
			   <td width="90" height="25">
			     
				 <cfoutput>
				 
				 <table><tr><td style="padding-right:5px" class="labelmedium">
				 
				 <cfif URL.ID2 neq "new" and url.scope eq "Backoffice">
					 <cfif access eq "EDIT" or access eq "ALL">
				     <A href="javascript:ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/assets/Line.cfm?WorkOrderId=#URL.WorkOrderId#&workorderline=#url.workorderline#&search=#url.search#&ID2=new','assetbox')">
					 <font color="0080C0">
					  <cf_tl id="Add">
					 </a>
					 </cfif>
				 </cfif>
				 
				 </td></tr></table>
				
				 </cfoutput>
				 
			   </td>
			   <td width="25%"><cf_tl id="SerialNo"></td>		
			   <td width="30%"><cf_tl id="Description"></td>		
			   <td width="6%"><cf_tl id="Make"></td>		
			   <td style="padding-right:2px"><cf_tl id="Price"></td>	
			   <td style="padding-right:2px"><cf_tl id="Issued"><cf_space spaces="30"></td>  		  
			   <td style="padding-right:2px"><cf_tl id="Effective"><cf_space spaces="30"></td>  		
			   <td style="padding-right:2px"><cf_tl id="Expiration"><cf_space spaces="30"></td>  	    		  	   	  		   		  
			   <td><cf_tl id="Officer"></td>	  		  
			   <td align="right" width="7%" colspan="2"></td>		  
		    </TR>	
					
			<cfif detail.recordcount gte "1" and url.scope eq "Backoffice">
			
				<cfoutput>
					<tr><td height="20" colspan="#cols#">			
						 <cfinclude template="LineNavigation.cfm">
					</td></tr>
				</cfoutput>
			
			</cfif>	
									
			<cfif URL.ID2 eq "new" and url.scope eq "Backoffice">
			
				<cf_assignid>
				<cfoutput><input type="hidden" name="TransactionId" id="TransactionId" value="#rowguid#"></cfoutput>
											
				<TR>
				
				<td rowspan="3">
				
					<table cellspacing="0" cellpadding="0">
					<tr>
																				
						<td style="padding:1px;border:1px solid silver">	
							
						   <cfset link = "#SESSION.root#/workorder/application/workorder/assets/getAsset.cfm?">	
						
						   <cf_selectlookup
							    box          = "assetselectbox"
								link         = "#link#"
								title        = "Asset Selection"
								icon         = "search.png"
								button       = "no"
								iconheight   = "23"
								iconwidth    = "23"
								close        = "Yes"
								filter1      = "Mission"
								filter1value = "#workorder.mission#"
								filter2      = "ServiceItem"
								filter2value = "#Service.Code#"
								class        = "asset"
								des1         = "assetid">
								
						</td>
						
						<td style="width:40px;padding:1px;border:1px solid silver">	
						
						    <cf_tl id="Record Device" var="vRecordDevice">
						
							<cfoutput>
						    <cf_img icon="add" onclick="newreceipt('#workorder.mission#')" tooltip="#vRecordDevice#">
							</cfoutput>
								
							<!---	
							
							<input type="button" style="width:120;height:25" name="Record Asset" id="Record Asset" value="<cfoutput>#vRecordDevice#</cfoutput>" class="button10s"
								onclick="newreceipt('<cfoutput>#workorder.mission#</cfoutput>')">			
								
								--->
						
						</td>
					
					</tr>
					</table>			
							
				</td>
				
				<td id="assetselectbox"><input type="hidden" name="AssetId" id="AssetId"></td>
				
			    <td style="padding-right:3px">
					<table cellspacing="0" cellpadding="0" style="width:100%">
					   <tr class="labelmedium"><td bgcolor="fafafa" id="assetserialno" style="padding-left:3px;padding:1px;width:98%;border:1px solid silver;height:24px"></td></tr>
					</table>
				</td>
				  
				<td style="padding-right:3px">
				    <table cellspacing="0" cellpadding="0" style="width:100%">
						<tr class="labelmedium"><td bgcolor="fafafa" id="description" style="padding-left:3px;padding:1px;width:98%;border:1px solid silver;height:24px"> </td></tr>
				    </table>
				</td>
				   
				<td style="padding-right:3px">
				   <table cellspacing="0" cellpadding="0" style="width:100%">
						<tr class="labelmedium"><td bgcolor="fafafa" id="make" style="padding-left:3px;padding:1px;width:98%;border:1px solid silver;height:24px"></td></tr>
				   </table>
				</td>
				  				   
				<td style="padding-right:3px">
				   <table cellspacing="0" cellpadding="0" style="width:100%">
					   <tr class="labelmedium"><td bgcolor="fafafa" id="price" style="padding-right:3px;text-align:right;padding:1px;width:98%;border:1px solid silver;height:24px"></td></tr>
				   </table>
				</td>		
				
				<td>
				
				</td>
						  			
										
				<td width="110" style="z-index:#10-currentrow#; position:relative;padding:0px;padding-top:1px;">
				
					  <cf_space spaces="42">
							
					  <cf_intelliCalendarDate9
						FieldName="dateeffective" 
						class="regularxl"						
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"		
						AllowBlank="False">	
				
				</td>
				
				<td width="110" style="z-index:#10-currentrow#; position:relative;padding:0px;padding-top:1px;">
				
					 <cf_space spaces="42">
				
					  <cf_intelliCalendarDate9
						FieldName="dateexpiration" 
						class="regularxl"						
						Default=""		
						AllowBlank="True">	
				
				</td>		
												
				<td colspan="3"></td>											   
							    
				</TR>	
				
				<tr><td height="3"></td></tr>		
				
				<tr>
					<td></td>
					<td colspan="6" style="padding-left:0px">
					
					 <cfinput type="Text"
					       name="Memo"					  
					       required="No"
					       visible="Yes"
					       enabled="Yes"				     
					       size="1"
					       maxlength="100"
					       class="regularxl"
					       style="text-align:left;width:100%">
					
					</td>	   
									
					</tr>
					<tr><td height="4"></td></tr>
					<tr><td colspan="9" class="line"></td></tr>
					<tr>
					<td colspan="9" align="center" height="35">
					
					<cfoutput>
					
						<cf_tl id="Save" var="vSave">
						<input type="button" 
						  onclick = "javascript:ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/assets/LineSubmit.cfm?Search=#url.search#&WorkOrderId=#URL.WorkOrderId#&workorderline=#url.workorderline#&ID2=#URL.ID2#','assetboxprocess','','','POST','assetform')"
						  style   = "width:140;height:25" 
						  value   = "#vSave#" 
					      class   = "button10g">
						  
					</cfoutput>
					
					</td>
																
			</cfif>	
			
			<cfoutput>
			
			<cfset currrow = 0>
			
			<cfif detail.recordcount eq "0" and url.scope eq "Portal">
			
			<tr><td colspan="9" align="center" height="30"><font color="808080"><cf_tl id="There are no records to show in this view" class="message"></td></tr>
			
			</cfif>
			
			<cfloop query="Detail">
			
				<cfset currrow = currrow + 1>
			 
			    <cfif currrow lt last and currrow gte first>					
																													
				<cfif URL.ID2 eq transactionid>
												   												
					<tr class="navigation_row line labelmedium">						   
					  
					   <td>
					   
					       <cfset link = "../Assets/getAsset.cfm?">	
				
						   <cf_selectlookup
						    box          = "assetbox0"
							link         = "#link#"
							title        = "Asset Selection"
							icon         = "contract.gif"
							button       = "Yes"
							close        = "Yes"
							filter1      = "ServiceItem"
							filter1value = "#Service.Code#"
							class        = "asset"
							des1         = "AssetId">
							
					   </td>	
					   
					   <td id="assetbox0">
							<input type="hidden" value="#assetid#" name="AssetId" id="AssetId">
							
						</td>
					   		  
					   <td style="padding-right:3px">
						   <table style="width:100%;padding-right:3px">
							   <tr><td class="labelmedium" bgcolor="fafafa" id="assetserialno" style="height:24px;padding:2px;width:98%;border:1px solid silver">#serialno#</td></tr>
						   </table>
					  </td>
					  
					  <td style="padding-right:3px">
					    <table cellspacing="0" cellpadding="0" style="width:100%;padding-right:3px">
							   <tr><td class="labelmedium" bgcolor="fafafa" id="description" style="height:24px;padding:2px;width:98%;border:1px solid silver">#description#</td></tr>
					   </table>
					  </td>
					   
					  <td style="padding-right:3px">
					   <table cellspacing="0" cellpadding="0" style="width:100%;padding-right:3px">
							   <tr><td class="labelmedium" bgcolor="fafafa" id="make" style="height:24px;padding:2px;width:98%;border:1px solid silver">#make#</td></tr>
					   </table>
					  </td>
					  				   
					  <td style="padding-right:3px">
					   <table cellspacing="0" cellpadding="0" style="width:100%;padding-right:3px">
						<tr><td class="labelmedium" align="right" bgcolor="fafafa" id="price" style="padding-right:5px;height:24px;padding:2px;width:98%;border:1px solid silver"> #numberformat(DepreciationBase,"__,__.__")#</td></tr>
					   </table>
					  </td>
					  
					  <td style="padding-right:3px">
					   <table cellspacing="0" cellpadding="0" style="width:100%;padding-right:3px">
						<tr><td class="labelmedium" bgcolor="fafafa" id="price" style="height:24px;padding:2px;width:98%;border:1px solid silver"> #dateformat(DateInitial,CLIENT.DateFormatShow)#</td></tr>
					   </table>
					  </td>
					  			   
					  <td style="z-index:#1000-currentrow#; position:relative;padding:0px">		
					   
					   	 <cf_space spaces="42">		  
					  							   				
						 <cf_intelliCalendarDate9
							FieldName="dateeffective" 					
							Default="#Dateformat(dateEffective, CLIENT.DateFormatShow)#"	
							class="regularxl"	
							AllowBlank="False">	
					
					  </td>
					
					  <td width="110" style="z-index:#1000-currentrow#; position:relative;padding:0px">
					
					   <cf_space spaces="42">
				
					   <cf_intelliCalendarDate9
						FieldName="dateexpiration" 
						class="regularxl"						
						Default="#Dateformat(dateexpiration, CLIENT.DateFormatShow)#"		
						AllowBlank="True">	
				
					</td>
					
					<td></td>
					<td colspan="2" align="right" style="padding-right:10px">
					
					  <cf_tl id="Save" var="vSave">
					  <input type="button" 
						onclick = "javascript:ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/assets/LineSubmit.cfm?Search=#url.search#&WorkOrderId=#URL.WorkOrderId#&workorderline=#url.workorderline#&ID2=#URL.ID2#','assetboxprocess','','','POST','assetform')"				
						style="width:60;height:25" 
						value="#vSave#" 
						class="button10g">
						
					</td>
					
				    </TR>	
					
					<tr><td height="30"></td>
					<td>
					<td colspan="7">
					
					 <cfinput type="text" 
					         name="Memo" 
							 size="1" 							 								
							 class="regularxl" 
							 style="width:100%" 
							 MaxLength="100"
							 visible="Yes" 
							 VALUE="#Memo#"
							 enabled="Yes">
					
					</td>	   
									
					</tr>
													
					<tr>	
					    <td></td>
				   		<td></td>
				        <td colspan="#cols-2#">		
				   
				   		<cf_filelibraryN
					    	DocumentHost="#parameter.documenthost#"
							DocumentPath="AssetOrder"
							SubDirectory="#url.workorderid#" 
							Box="box_0"
							Filter="#left(transactionid,8)#"						
							Insert="yes"
							Remove="yes"
							reload="true">		
				  
				        </td>
			        </tr>	
								
							
				<cfelse>
				
					<cfif operational eq "0">
						<cfset cl = "FEBBAF">
					<cfelse>
					    <cfset cl = "white">
					</cfif>
							   									
					<TR class="navigation_row labelmedium line" bgcolor="#cl#" id="agreementline#currentrow#">		   
					
	                    <cfif operational eq "1">				
							<cfif access eq "EDIT" or access eq "ALL">   
								<cfset link = "ColdFusion.navigate('#SESSION.root#/workorder/application/workorder/assets/Line.cfm?WorkOrderId=#URL.WorkOrderId#&WorkOrderLine=#URL.workorderline#&ID2=#transactionid#&search=#url.search#','assetbox')">
							<cfelse>
								<cfset link = "">
							</cfif>
						<cfelse>
							<cfset link = "">	
						</cfif>
					   
					   <td width="2"></td>
					   
					   <cfif url.scope eq "portal">
					   	   <td height="20"
						       style="padding-left:3px;padding-right:4px">#currentrow#.</td>		
					       <td>#serialno#</td>
						   <td>#description#</td>
						   <td>#make#</td>	  
						   <td align="right" style="padding-right:5px;">#numberformat(DepreciationBase,",.__")# <cf_space spaces="20"></td>		
						   <td style="padding-right:3px">#dateformat(DateInitial,CLIENT.DateFormatShow)#</td>
						   <td style="padding-right:3px">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
						   <td style="padding-right:3px">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>				   	  				  
						   <td>#OfficerLastName#</td>						   
					   <cfelse>
					   	   <td height="20"
						       style="padding-left:3px;padding-right:4px">#currentrow#.</td>		
					       <td><a href="javascript:AssetDialog('#assetid#')">#serialno#</a></td>
						   <td><a href="javascript:AssetDialog('#assetid#')">#description#</a></td>
						   <td>#make#</td>	  
						   <td align="right" style="padding-right:5px;">#numberformat(DepreciationBase,",.__")#<cf_space spaces="20"></td>	
						   <td style="padding-right:3px">#dateformat(DateInitial,CLIENT.DateFormatShow)#</td>			   
						   <td style="padding-right:3px">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
						   <td style="padding-right:3px">#dateformat(DateExpiration,CLIENT.DateFormatShow)#</td>				   	  				  
						   <td>#OfficerLastName#</td>					   
					   </cfif>	   
					 
					   <td align="right">	
					   
					   		<cfif operational eq "1">	
					   
					   		<cf_space spaces="4">	
							
								<cfif url.scope eq "backoffice">
						   				   								
							   		<cfif access eq "EDIT" or access eq "ALL">  
									
										<cf_img icon="edit" navigation="yes"
										   onclick="ptoken.navigate('#SESSION.root#/Workorder/Application/Workorder/Assets/Line.cfm?WorkOrderId=#URL.workorderid#&WorkOrderLine=#URL.workorderline#&ID2=#transactionid#&search=#url.search#','assetbox')">
																			
									</cfif>		
								
								</cfif>		
							
							</cfif> 
										 
					   </td>
					   
					   <td align="left" style="padding-left:2px;padding-top:1px" id="agreementdelete#currentrow#">
					   
					   	    <cfif operational eq "1">	
							
						   		<cfif url.scope eq "backoffice">
						   						
							   		<cfif access eq "ALL"> 
									
										<cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Workorder/Application/Workorder/Assets/LinePurge.cfm?WorkOrderId=#URL.workorderid#&WorkOrderLine=#URL.workorderline#&ID2=#transactionid#&search=#url.search#','assetbox')">
									  
									 </cfif> 
								 
								 </cfif>
							 
							 </cfif>
								 
					  </td>				  
					 				   
				    </TR>	
					
					<cfif Memo neq "">
						<tr class="labelmedium"><td></td><td></td>
							<td colspan="6">#Memo#</td>
						</tr>
						<tr><td height="3"></td></tr>
					</cfif>		
					
					<cfif operational eq "1">					
						<cfinclude template="checkAsset.cfm">						
					</cfif>
					
				</cfif>
										
				</cfif>	
								
									
			</cfloop>	
			
			<cfif url.scope eq "Backoffice">
			
			<tr><td height="24" colspan="#cols#">
				 <cfinclude template="LineNavigation.cfm">
			</td></tr>	
			
			</cfif>	
			
			</cfoutput>			
															
			</table>
			
			</cfform>		
		
		</td>
		</tr>		
					
</table>	

<cfset ajaxonload("doHighlight")>
<cfset ajaxonload("doCalendar")>