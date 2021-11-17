
<cfif url.mission neq "">
		
	<cfquery name="whs" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Warehouse
			WHERE    Mission = '#url.mission#'		 
			AND      Operational = 1
	</cfquery>
				
	<cfif whs.recordcount eq "0">
	
		<cf_message message="No Facility defined for entity #url.mission#">
		<cfabort>				
				
	</cfif>

</cfif>

<cfquery name="Parameter" 
	   datasource="AppsPurchase" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#url.Mission#'		
</cfquery>		

<cfquery name="Param" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#url.Mission#'		
</cfquery>		

<cfquery name="whs" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT   *
			FROM     Warehouse
			WHERE    Warehouse = '#url.warehouse#'		
    </cfquery>		

<cfoutput>

<cfif url.mode neq "workorder">

	<!--- called from warehouse --->
				
	<cfinvoke component  = "Service.Access"  
		   method            = "RoleAccess" 
		   mission           = "#whs.mission#" 
		   missionorgunitid  = "#whs.missionorgunitid#" 
		   role              = "'WhsPick'"
		   parameter         = "#url.systemfunctionid#"
		   accesslevel       = "'1','2'"
		   returnvariable    = "accessright">	
	   	   
	 <cfif accessright eq "DENIED">
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr><td align="center" height="100" class="labelmedium"><cf_tl id="You have been granted only read rights. Option not available"></td></tr>
		</table>
		<cfabort>
	
	</cfif>   
	
</cfif>	

<cfif whs.ModeInitialStock eq "0" and url.mode eq "initial">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
			<tr><td align="center" height="100" class="labelmedium"><cf_tl id="Initial stock feature is no longer enabled for this facility"></td></tr>
	</table>
	<cfabort>
	
</cfif>

<cf_divscroll>

<cfform name="transactionform" id="transactionform" method="post">

  <table width="98%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="center" align="center">		
	 
 <cfparam name="url.systemfunctionid" default="00000000-0000-0000-0000-000000000000">
		
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">
	
	<cfif url.mode eq "initial">	
		
		<tr><td height="5px"></td></tr>
		<tr>
		  <td colspan="2" height="57" style="padding:6px">	 
		  		  	 
			 <table cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">												
							
				<tr>
					<td>
						<h1 style="font-weight: 200;font-size: 28px;margin: 0;"><img width="64" height="64" style="	float: left;margin-right: 10px;position: relative;top: -7px;" src="#SESSION.root#/images/Tasks.png"><cfoutput>#lt_content#</cfoutput></h1>
                        <cf_LanguageInput
							TableCode       = "Ref_ModuleControl" 
							Mode            = "get"
							Name            = "FunctionMemo"
							Key1Value       = "#url.SystemFunctionId#"
							Key2Value       = "#url.mission#"				
							Label           = "Yes">
							
						<h3 style="font-weight: 200;font-size: 14px;margin: 0;"><cfoutput>#lt_content#</cfoutput></h3>
					</td>
				</tr>
						
			</table>
			  
		  </td>
		</tr>	
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
	<cfelseif url.mode eq "issue">
				
		<tr><td height="5px"></td></tr>
		<tr bgcolor="fafafa">
		  <td style="border:1px solid silver" colspan="2" height="20" style="padding:6px">			 
		  <cfoutput><img src="#SESSION.root#/images/logos/warehouse/fuel.png" alt="" border="0"></cfoutput>
		  &nbsp;<font size="3" color="C0C0C0"><cfoutput>#lt_content#</cfoutput></b>	    	   
		  </td>
		</tr>		
		
	<cfelseif url.mode eq "sale">
	
		<!--- this option is menat for internal issuance of goods to units, the external sale is no longer used as we 
		has POS and WorkOrder options now --->
		
		<tr><td height="5px"></td></tr>
		<tr>
		  <td style="border:0px solid silver" colspan="2" height="67" style="padding:6px">	
		  
		  <table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:15px; left:35px; ">
						<img src="#SESSION.root#/images/logos/warehouse/sale.png" height="52px">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:27px; left:90px; color:##45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:14px; left:90px; color:##e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:55px; left:90px; color:##45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
										
					 <cf_LanguageInput
						TableCode       = "Ref_ModuleControl" 
						Mode            = "get"
						Name            = "FunctionMemo"
						Key1Value       = "#url.SystemFunctionId#"
						Key2Value       = "#url.mission#"				
						Label           = "Yes">
					
					<cfoutput>#lt_content#</cfoutput>

					</td>
				</tr>							
			</table>
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			 		   
	   	  </td>
		</tr>			
				
		<cfelseif url.mode eq "externalsale">
	
		<tr><td height="5px"></td></tr>
		<tr>
		  <td style="border:0px solid silver" colspan="2" height="67" style="padding:6px">	
		  
		  <table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:15px; left:20px; ">
						<img src="#SESSION.root#/images/logos/warehouse/sale2.png" height="52px">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:27px; left:100px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:14px; left:100px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:55px; left:100px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
										
					 <cf_LanguageInput
						TableCode       = "Ref_ModuleControl" 
						Mode            = "get"
						Name            = "FunctionMemo"
						Key1Value       = "#url.SystemFunctionId#"
						Key2Value       = "#url.mission#"				
						Label           = "Yes">
					
					<cfoutput>#lt_content#</cfoutput>

					</td>
				</tr>							
			</table>
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			 		   
	   	  </td>
		</tr>	
		
		<tr><td class="labelmedium" colspan="2" align="center"><cf_tl id="Function deprecated"></td></tr>
		<cfabort>
		
		<cfelseif url.mode eq "disposal">	
		
		<tr>
		  <td colspan="2" style="padding:2px">	
		  		  		  
		  <!---
		  <table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
		  		    			
				<tr>
					<td style="z-index:5; position:absolute; top:15px; left:35px; ">
						<img src="#SESSION.root#/images/logos/warehouse/disposal.png" height="52px">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:27px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:14px; left:90px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:55px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
										
					 <cf_LanguageInput
						TableCode       = "Ref_ModuleControl" 
						Mode            = "get"
						Name            = "FunctionMemo"
						Key1Value       = "#url.SystemFunctionId#"
						Key2Value       = "#url.mission#"				
						Label           = "Yes">
					
					<cfoutput>#lt_content#</cfoutput>

					</td>
				</tr>		
				
								
			</table>
			
			<tr><td colspan="2" class="linedotted"></td></tr>
			
			--->		 
		   
	   	  </td>
		</tr>	
		  	
	</cfif>	
			
	<tr><td height="4"></td></tr>
	
	<tr><td>	
		
		<table width="100%" border="0" class="formspacing" align="center">
		  
		  <tr>
		    <td> 	 
					
			  <table width="98%" class="formpadding"  align="center">
			  		
				<tr><td colspan="2" height="1"></td></tr>
				
				<input type="hidden" name="workorderid"   id="workorderid"    value="#URL.workorderid#">	
				<input type="hidden" name="workorderline" id="workorderline"  value="#URL.workorderline#">	
				<input type="hidden" name="mission"       id="mission"        value="#URL.mission#">								
						
				<cfif url.warehouse neq "">
				
			        <TR class="labelmedium2"> 
			          <TD height="20" width="100"><cf_space spaces="60"><cf_tl id="Facility">:</TD>
			          <td width="80%" align="left">
					  
					  <cfquery name="whs" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Warehouse
								WHERE    Warehouse = '#URL.Warehouse#'		 
						</cfquery>
					  
					  	#whs.WarehouseName# #whs.City# [#URL.Warehouse#]
						
				  	  </td>
					</tr>  
					<input type="hidden" name="warehouse" id="warehouse" value="#URL.warehouse#">	
				
				<cfelse>
				
					 <TR class="labelmedium2"> 
			          <TD height="22" width="120"><cf_tl id="Warehouse">:</TD>
			          <td width="80%" align="left" >
					 						
						<cfquery name="whs" 
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Warehouse
								WHERE    Mission = '#url.mission#'	
								<cfif filter neq "">
								AND      Warehouse IN (SELECT Warehouse 
								                       FROM   WarehouseCategory
											   		   WHERE  Category = '#filter#')
								</cfif>	 
						</cfquery>
																		
						<select name="warehouse" id="warehouse" class="regularxxl">
							<!---
							  onchange="document.getElementById('itemno').value='';document.getElementById('itemdescription').value=''">
						  --->
							<cfloop query="whs">
								<option value="#Warehouse#">#Warehouse# #WarehouseName#</option>
							</cfloop>
						</select>				
					
				  	  </td>
					</tr>  
				
				</cfif>							
									
				<!--- Query returning search results --->
				
				<cfquery name="TransactionType"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						    SELECT *
							FROM   Ref_TransactionType
							WHERE  TransactionType = '#URL.ID#'
				</cfquery>	
					
				<cfif url.mode eq "Disposal">
						
					<tr class="labelmedium2 line">  
					 
				      <td colspan="2" style="height:32px;font-size:18px"><cf_tl id="Disposal"> (#TransactionType.Description#)</td>			  	   
				    </TR>	
						
				</cfif>						
					
				<input type="hidden" name="tratpe" id="tratpe" value="#url.id#">
								
				
				<tr class="labelmedium2">  
				  <TD width="100"><cf_tl id="Local Date/Time">:</TD>
				  
				     <cf_getWarehouseTime warehouse="#url.warehouse#">
					 				  
				     <cfset hr = "#timeformat(localtime,'HH')#">
					 <cfset mn = "#timeformat(localtime,'MM')#">
					 
				  <td>
				  
					<table>
					<tr>
					
					<td>
									
					<cf_intelliCalendarDate9
						FieldName  = "TransactionDate" 
						Default    = "#dateformat(localtime,CLIENT.DateFormatShow)#"
						Class      = "regularxxl enterastab"
						AllowBlank = "false"> 		
					
				    </td>
					
					<td>&nbsp;</td>
					
					<td>					
					
					<select name="Transaction_hour" id="Transaction_hour" class="regularxxl enterastab">
					
						<cfloop index="it" from="0" to="23" step="1">
						
							<cfif it lte "9">
							  <cfset it = "0#it#">
							</cfif>				 						
						    <option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
						
						</cfloop>	
						
					</select>
					
					</td>
					<td>-</td>
					<td>
					
					<select name="Transaction_minute" id="Transaction_minute" class="regularxxl enterastab">
						
						<cfloop index="it" from="0" to="59" step="1">							
							<cfif it lte "9">
								  <cfset it = "0#it#">
							</cfif>				 							
							<option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>							
						</cfloop>	
										
					</select>						
					
					</td>
					<td style="padding-left:7px">[UTC#timezone#]</td>
					</tr>
					</table>			
		         
				 </td>
			  	   
		        </TR>						
							
				<cfif url.mode eq "sale">
				
				<TR class="labelmedium2"> 
		          <TD height="22"><cf_tl id="Equipment Item">:</TD>
		          <td align="left">
				    <table width="99%" cellspacing="0" cellpadding="0">
					
						<tr>
						<td width="98%" style="height:30px;padding:2px;border:1px solid silver" id="assetbox"></td>
						<td width="30" style="padding-left:3px" valign="top">
										  				
					       <cfset link = "#SESSION.root#/warehouse/application//stock/Transaction/getAsset.cfm?">								   
							
						   <cf_selectlookup
							    box          = "assetbox"
								link         = "#link#"
								title        = "Item Selection"
								icon         = "contract.gif"
								button       = "No"
								close        = "Yes"	
								filter1      = "mission"
								filter1value = "#url.mission#"				
								class        = "Asset"
								des1         = "AssetId">							
							
							<input type="hidden" name="assetid" id="assetid" size="4" value="" class="regular" readonly style="text-align: center;">	
			
						</td>						
						</tr>
									
					</table>  
			  	  </td>			  	   
		        </TR>
				
				</cfif>
				
				<cfif url.mode eq "sale">
				
					<TR class="labelmedium2"> 
			          <TD><cf_tl id="Unit">: <font color="FF0000">*</font></TD>
			          <td align="left">
					    <table width="99%">
						<tr>
						
						    <td width="98%" style="height:20;padding:2px;border:1px solid silver" id="unitbox"></td>	
							<td width="20" style="padding-left:0px;padding-left:3px" valign="top">
							
						       <cfset link = "#SESSION.root#/Warehouse/Application/Stock/Transaction/getUnit.cfm?">	
										   
							   	  <cf_selectlookup
								    box          = "unitbox"
									link         = "#link#"
									title        = "Unit"
									icon         = "contract.gif"
									button       = "No"
									close        = "Yes"	
									filter1      = "mission"
									filter1value = "#url.mission#"					
									class        = "organization"
									des1         = "OrgUnit">	
									
								<input type="hidden" name="orgunit" id="orgunit" size="4" value="" class="regular" readonly style="text-align: center;">		
												
							</td>
										
						</tr>
						</table>  
				  	  </td>			  	   
			        </TR>
				
				</cfif>
				
				<cfif url.mode eq "sale" or url.mode eq "Disposal">
				
					<TR class="labelmedium2"> 
			          
					  <TD>
					  <cfif url.mode eq "sale">
					  	<cf_tl id="Receiver">:
					  <cfelse>
					    <cf_tl id="Responsible">:
					  </cfif>
					  
					  <font color="FF0000">*</font></TD>
					  
			          <td align="left">
					  
					    <table width="99%">
						
						<tr>
						
						    <td width="98%" style="height:30;border:1px solid silver;" id="personbox"></td>	
							
							<td width="30" style="padding-left:3px" valign="top">
													
						        <cfset link = "#SESSION.root#/warehouse/application//stock/Transaction/getPerson.cfm?mission=#url.mission#">	
						   													   
						   		<cf_selectlookup
								    box          = "personbox"
									link         = "#link#"
									title        = "Item Selection"
									icon         = "contract.gif"
									button       = "No"
									close        = "Yes"	
									filter1      = "mission"
									filter1value = "#url.mission#"						
									class        = "employee"
									des1         = "personno">	
								
								<input type="hidden" name="personno" id="personno" size="4" value="" class="regular" readonly style="text-align: center;">	
																
						</td>
							
						</tr>
					  </table>  
				  	</td>			  	   
			       </TR>
			   
			   </cfif>
			   
			   <cfif url.mode eq "externalsale">
				
				<tr class="labelmedium2">  
				  <td height="22" width="100"><cf_tl id="Customer">:</TD>
		        				  				  
				  <td align="left">
					    <table width="99%">
						<tr>
						
						    <td width="98%" style="height:20;padding:2px;border:1px solid silver" id="customerbox"></td>								
							<td width="20" style="padding-left:3px" valign="top">
							
						      <cfset link = "#SESSION.root#/Warehouse/Application/Stock/Transaction/getCustomer.cfm?">	
										   
						   	  <cf_selectlookup
							    box          = "customerbox"
								link         = "#link#"
								title        = "Customer"
								icon         = "contract.gif"
								button       = "No"
								close        = "Yes"	
								datasource   = "AppsMaterials"
								filter1      = "mission"
								filter1value = "#url.mission#"					
								class        = "customer"
								des1         = "CustomerId">										
												
							</td>
							
							<input type="hidden" id="customerid" name="customerid" value="">
										
							
						</tr>
						</table>  
				   </td>					     	   
				 			  	   
		        </TR>
							
				</cfif>		
							
			
			   <cfif url.mode eq "workorder">	
			   
			    <cfquery name="Unit"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				  
					SELECT DISTINCT O.OrgUnit, O.OrgUnitCode, O.OrgUnitName
					FROM   WorkOrderLineBilling WB INNER JOIN
	                       Organization.dbo.Organization O ON WB.OrgUnit = O.OrgUnit
					WHERE  WB.WorkOrderId   = '#url.workorderid#' 
					AND    WB.WorkOrderLine = '#url.workorderline#'
					UNION
					SELECT DISTINCT O.OrgUnit, O.OrgUnitCode, O.OrgUnitName
					FROM   WorkOrderLine WL INNER JOIN
	                       Organization.dbo.Organization O ON WL.OrgUnitImplementer = O.OrgUnit
					WHERE  WL.WorkOrderId   = '#url.workorderid#' 
					AND    WL.WorkOrderLine = '#url.workorderline#'
				</cfquery>
				
				<cfif unit.recordcount gte "1">				
				<TR class="labelmedium2"> 
		          <TD height="22"><cf_tl id="OrgUnit">:</TD>
		          <td align="left">
				  		
				    <select name="orgunit" id="orgunit" class="regularxxl">							    
						<cfloop query="unit">
							<option value="#orgunit#">#OrgUnitCode# #OrgUnitName#</option>
						</cfloop>
					</select>					  
									
			  	  </td>			  	   
		        </TR>		
				</cfif>
			   
			   <!--- Query returning search results --->
				<cfquery name="ServiceUnit"
				datasource="AppsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				    SELECT *
					FROM   ServiceItemUnit
					WHERE  ServiceItem = '#serviceitem.ServiceItem#'
					AND    UnitClass = 'Regular'			
					AND    Operational = 1
					AND    Unit IN (SELECT ServiceItemUnit 
					                FROM   ServiceItemUnitMission 
					                WHERE  ServiceItem      = '#serviceitem.ServiceItem#'
									AND    Mission          = '#url.mission#'
									AND    BillingMode      = 'Supply'
									and    Operational      = 1)
				</cfquery>		
			   
				   <cfif ServiceUnit.recordcount eq "0">
				   
				   	<tr class="labelmedium2">  
						  <TD height="22" width="100"><cf_tl id="Service unit">:</TD>
				          <td>
						  <font color="FF0000"><cf_tl id="Issued item will not be billed"></font>												
						  <input type="hidden" name="billingunit" id="billingunit" value="">
						  </td>
						
						</TR>
								
					<cfelse>				   
					
						<tr class="labelmedium2">  
						  <TD height="22" width="100"><cf_tl id="Service unit">:</TD>
				          <td>
						 						
							<select name="billingunit" id="billingunit" class="regularxxl">							    
								<cfloop query="ServiceUnit">
									<option value="#unit#">#UnitCode# #UnitDescription#</option>
								</cfloop>
							</select>	
							
						  </td>
			  	   
					        </TR>
							
					</cfif>			
							
				</cfif>		
								
				<TR class="labelmedium2"> 
		          <TD><cf_tl id="Reference">:</TD>
		          <td align="left">
				  	<input type="text" name="TransactionReference" id="TransactionReference" 
					  class="regularxxl enterastab" style="width:50%" maxlength="20">
			  	  </td>			  	   
		        </TR>			
							
				<TR class="labelmedium2"> 
		          <TD valign="top" style="padding-top:4px"><cf_tl id="Stock Item">: <font color="FF0000">*</font></TD>
		          <td align="left" width="80%">
				  
				    <table width="99%">
					<tr>
					
					   <td width="98%" style="height:30px;padding-left:0px;border:1px solid silver" id="itembox"></td> 
					   <td width="30" style="padding-left:3px" valign="top">
					   					   					   	
				       <cfset link = "#SESSION.root#/warehouse/application//stock/Transaction/getItem.cfm?warehouse=#url.warehouse#&mode=#url.mode#">
					   
					   <cfif url.mode eq "sale">	
					   
					       <!--- internal sale --->
					   																
					       <cfif filter eq "">
						   						   						   
						   		<cf_selectlookup
								    box          = "itembox"
									link         = "#link#"
									title        = "Item Selection"
									icon         = "contract.gif"
									button       = "Yes"
									close        = "Yes"	
									filter1      = "warehouse"
									filter1value = "#url.warehouse#"	
									filter2      = "Destination"
									filter2value = "sale,internal,distribution"						
									class        = "Item"
									des1         = "ItemNo">	
							
							<cfelse>
														
							   <cf_selectlookup
								    box          = "itembox"
									link         = "#link#"
									title        = "Item Selection"
									icon         = "contract.gif"
									button       = "Yes"
									close        = "Yes"	
									filter1      = "category"
									filter1value = "#filter#"	
									filter2      = "Destination"
									filter2value = "sale,internal,distribution"						
									class        = "Item"
									des1         = "ItemNo">							
							
							</cfif>		
							
						<cfelse>
						
							 <cfif filter eq "">
						   
						   		<cf_selectlookup
								    box          = "itembox"
									link         = "#link#"
									title        = "Item Selection"
									icon         = "contract.gif"
									button       = "Yes"
									close        = "Yes"	
									filter1      = "warehouse"
									filter1value = "#url.warehouse#"						
									class        = "Item"
									des1         = "ItemNo">	
							
							<cfelse>
							
							   <cf_selectlookup
								    box          = "itembox"
									link         = "#link#"
									title        = "Item Selection"
									icon         = "contract.gif"
									button       = "Yes"
									close        = "Yes"	
									filter1      = "category"
									filter1value = "#filter#"				
									class        = "Item"
									des1         = "ItemNo">							
							
							</cfif>		
						
						
						</cfif>	
	
						<input type="hidden" name="itemno" id="itemno" size="4" value="" class="regular" readonly style="text-align: center;">	
					
					</td>
					
						
					</tr>
					</table>  
			  	  </td>			  	   
		        </TR>
				
				<tr id="uomlabel" class="hide"><td height="22" class="labelmedium2"><cf_tl id="UoM">: <font color="FF0000">*</font></td>
				    <td id="uombox"></td>
				</tr>		
								
				<cfif url.mode eq "initial">
																				
					<cfif Param.LotManagement eq "1">
		
						<tr class="labelmedium2">
						
							<td width="100"><cf_tl id="Production Lot">:</td>
						
						    <td>
							
							<table cellspacing="0" cellpadding="0">
								<tr>
								<td>
							         <input type="text"
								  	   name  = "TransactionLot"
							           id    = "TransactionLot"
								       value = ""
									   class="regularxl enterastab"
									   onchange="ptoken.navigate('#session.root#/tools/process/stock/getLot.cfm?mission=#url.mission#&transactionlot='+this.value,'TransactionLot_content')"										     
									   maxlength="20"
									   size  = "20"
									   style = "text-align:right;padding-top:1px;padding-right:2px">
																	  
								 </td>
								
								 <td id="TransactionLot_content" class="labelmedium" style="padding-left:7px;width:20"></td>
								 
								 </tr>
							 </table>
							 
							 </td>
							 				  
						</tr>
					
					</cfif>		
				
				</cfif>	
				
				<tr id="loclabel" class="hide"><td height="20" valign="top" class="labelmedium" style="padding-top:4px"><cf_tl id="Quantity">: <font color="FF0000">*</font></td>
				    <td id="locbox"></td>
				</tr>
							
				<TR class="labelmedium2"> 
		            <TD  valign="top" style="padding-top:6px"><cf_tl id="Memo">:</TD>
		            <td align="left">
					
					    <textarea name="remarks" 
							 id="remarks"					     
							 class="regular enterastab" 
							 totlength="200"
							 onkeyup="return ismaxlength(this)"					
							 style="height:42;width:99%;padding:3px;font-size:14px"></textarea>
					
			  	    </td>			  	   
		        </TR>					
				
				<tr id="submitbox0" class="hide"><td class="line" colspan="2" height="1"></td></tr>
				
				<TR id="submitbox1" class="hide"> 
		          <TD colspan="2" align="center" height="28">
				  
					  <cf_tl id="Add Line" var="1">			  
					  <input type="button" 
					      class="button10g" style="height:24px;width:190" 
						  value="#lt_text#" 
						  onclick="ptoken.navigate('../Transaction/TransactionEntrySubmit.cfm?systemfunctionid=#url.systemfunctionid#&mode=#url.mode#&warehouse=#url.warehouse#','detail','','','POST','transactionform')" 
						  name="addline" id="addline">
					  
				  </TD>
		        </TR>
							
				<tr><td colspan="2" height="5"></td></tr>
								
				<tr><td colspan="4" id="detail" style="padding:3px">
				
				    <cfset url.tratpe = url.id>	
					
					<cfinclude template="TransactionDetailLines.cfm">			
					
				</td></tr>	
			 				
		      </TABLE>
			  					  
			</td> 
			</tr>
			</table>	
	 
 </td></tr>
 </table>
 
</cfform>

</cf_divscroll>

</cfoutput>		

<cfset ajaxOnLoad("doCalendar")>
