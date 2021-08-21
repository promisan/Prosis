
<script>
_cf_loadingtexthtml='';	
</script>

<cfset vTotal = 0 >
<cfif url.requirementid neq "">

	<cfquery name="Requirement" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramAllotmentRequest
		WHERE     RequirementId = '#url.requirementid#'
	</cfquery>
	
	<cfif requirement.recordcount eq "1">

		<cfset parentid = requirement.RequirementIdParent>
		
	<cfelse>
	
		<cfset parentid = "00000000-0000-0000-0000-000000000000">
	
	</cfif>

<cfelse>

	<cfset parentid = "00000000-0000-0000-0000-000000000000">

</cfif>

<cfquery name="itm" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    IM.*, O.BudgetEntryLines, O.BudgetEntryQuantity2
	FROM      ItemMaster IM	INNER JOIN ItemMasterObject O ON IM.Code = O.ItemMaster	
	WHERE     ObjectCode = '#url.objectcode#'
		
	AND       (Operational = 1 or Code IN (SELECT ItemMaster 
	                                       FROM   Program.dbo.ProgramAllotmentRequest 
										   WHERE  RequirementIdParent = '#parentid#'))
	ORDER BY   O.ListingOrder
</cfquery>			
	
<cfoutput>
	 
	 <tr>
		   <td valign="top" id="labelmemo" style="padding-top:6px" class="labelit"><cf_tl id="Memo">: <font color="FF0000">*)</font></td>
		   <TD colspan="3" class="labelit">
		      		   
		   <cfif URL.Mode neq "edit" and url.mode neq "add">
		    <cfif entry.requestremarks neq "">
		   	#entry.requestRemarks#
			<cfelse>
			--
			</cfif>
		   
		   <cfelse>
		   
		   		<textarea style="padding:4px;width:98%;font-size:14px;height:55" name="RequestRemarks" class="enterastab regular">#entry.requestRemarks#</textarea>
				
			</cfif>	
		   
		   </TD>
	   </tr>
	   
	    <tr>
	   
		 	<td colspan="2">
				<table width="100%">
						<tr>							
								<td style="padding-left:8px;">
									<cf_tl id="View Instructions" var="1">
									<table>
										<tr>
											<td>
												<img id="imgViewInstructions"
													name="imgViewInstructions"
													src="#session.root#/images/expand.png" 
													style="height:15px; cursor:pointer;" 
													title="#lt_text#" 
													onclick="getItemObjectInstructions('#url.objectcode#', '#itm.code#', '#url.programcode#','#url.period#','#url.editionid#','InstructionsDetail', this, 'collapse.png', 'expand.png');">
											</td>
											<td style="padding-left:3px;" class="labelmedium">
											    <font color="0080C0">
												<label for="imgViewInstructions"><cf_tl id="View Instructions"></label>	
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>	
										
							
				   </TD>
			   </tr>
			   
			   <tr>
					<td colspan="2" id="InstructionsDetail" style="display:none;">
						<cfdiv id="divInstructionsDetail">
					</td>
			   </tr>
	   
	   
	</cfoutput>  
	
	<tr><td colspan="2" style="padding:6px">

		<table width="100%" align="right" border="0">
				
		<cfset row = 0>
		
		<cfoutput>

		<script>			
			try { document.getElementById('labelmemo').innerHTML = 'zzzzzzzzzzzz' } catch(e) {}		
		</script>
	
		</cfoutput>	
		
		<cfset vTotal = 0>
									
		<cfoutput query="itm">
		
			<cfquery name="Mode" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      ItemMasterObject
				WHERE     ItemMaster  = '#Code#'
				AND       ObjectCode  = '#url.objectcode#' 
			</cfquery>
		
			<cfset lbr = 0>
			<cfloop index="lb" list="#BudgetLabels#" delimiters="|">
			   <cfset lbr = lbr+1>
		    	  <cfset lbl[lbr] = lb>	 
			</cfloop>
		
			<cfparam name="lbl[1]" default="Item">
			<cfparam name="lbl[2]" default="Quantity">
			<cfparam name="lbl[3]" default="Memo">
			<cfparam name="lbl[4]" default="Days">
			<cfparam name="lbl[5]" default="Memo">
		
			<cf_tl id="#lbl[1]#" var="label_itm">
			<cf_tl id="#lbl[2]#" var="label_qty">
			<cf_tl id="#lbl[3]#" var="label_mem">
			<cf_tl id="#lbl[4]#" var="label_day">
			<cf_tl id="#lbl[5]#" var="label_mne">
	
			<script>			
				try { document.getElementById('labelmemo').innerHTML = '#label_mne#:' } catch(e) {}		
			</script>
			
			<tr class="line labelit">
				<td></td>
				<td></td>				
				<td><font color="808080">#lbl[1]#</td>
				<td style="padding-right:3px" align="right"><font color="808080">#lbl[2]#</td>
				<td align="right" style="padding-right:3px"><font color="808080"><cfif BudgetEntryQuantity2 eq "1">#lbl[4]#</cfif></td>
				<td align="right"><font color="808080"><cf_tl id="Sum"></td>
				<td align="right"><font color="808080"><cf_tl id="Cost"></td>
				<td align="right"><font color="808080"><cf_tl id="Total"> #Parameter.budgetCurrency#</td>	
			</tr>		
									
			<cfloop index="s" from="1" to="#BudgetEntryLines#">
						
				<cfset row = row+1>
				
				<!--- retrieve the existing values for based on parentid, itemmaster and the the serialno --->
				
				<cfquery name="entry" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      ProgramAllotmentRequest
					WHERE     RequirementIdParent = '#parentid#'
					AND       ItemMaster          = '#code#'
					AND       RequirementSerialNo = '#s#'	
				</cfquery>				
						
				<cfif entry.recordcount eq "1">
				        <cfset load = "Yes">
					    <!--- <cfset id = entry.RequirementId> --->
					    <cfset cl =  "regular">
					    <input type="hidden" name="itm_#code#_#row#"    id="itm_#code#_#s#" style="width:20" value="1">
				<cfelse>
				    <cfset load = "No">
					<!--- <cfset id = "00000000-0000-0000-0000-000000000000"> --->
					<cfif s eq "1">			
					   <input type="hidden" name="itm_#code#_#row#" id="itm_#code#_#s#" style="width:20" value="1">	
					   <cfset cl = "regular">
					<cfelse>
					 	<cfset cl = "hide">
						<input type="hidden" name="itm_#code#_#row#" id="itm_#code#_#s#" style="width:20" value="0">
					</cfif>				
				</cfif>
						
				<cfset ser = s>
														
				<tr id="line_#code#_#s#" class="#cl# clsBudgetRow_#code# clsBudgetRow_#code#_#s# line">				
								
					<td valign="top" style="padding-left:10px;">
																		
					    <input type="hidden" name="itemmaster_#row#" id="itemmaster_#row#" value="#Code#">	
					   		
							<cfif s eq "1">		
							
							<table>
							<tr>		
								
								<td>
									<table>
										<tr>
											<td width="14px;" style="padding-top:2px">
												<cfif BudgetEntryLines gt 1>
													<cf_tl id="add line" var="1">
													<img src="#session.root#/images/btn_add.gif" 
														 id="twistieBudgetRow_#code#" 
														 align="absmiddle"
														 height="14" 
														 style="cursor:pointer;" 														 
														 onclick="addBudgetEntryLine('#code#',#BudgetEntryLines#);syncAmounts()">
												</cfif>
											</td>
											<td width="14px;" style="padding-left:2px;padding-top:3px">
												<cf_tl id="Instructions" var="1">
												<table>
													<tr>
														<td>
															<img id="imgViewInstructions_#code#"
																name="imgViewInstructions_#code#"
																src="#session.root#/images/arrowright.gif" 
																style="height:12px; width:12px; cursor:pointer;" 
																title="#lt_text#" 
																onclick="getItemObjectInstructions('#url.objectcode#', '#code#', '#url.programcode#','#url.period#','#url.editionid#','InstructionsDetail_#code#', this, 'arrowdown3.gif', 'arrowright.gif');">
														</td>
														<td style="padding-left:3px; font-size:9px;" class="labelit">
															<!--- <label for="imgViewInstructions_#code#"><cf_tl id="View Instructions"></label>	 --->
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>	 
								
								<td style="padding-left:4px;padding-top:0px;max-width:120px;min-width:220px" class="labelmedium">#Description#:</td>
								
								</tr>
							</table>
								
							</cfif>
												
						    <cf_space spaces="40">
						
					</td>
					
					<td style="padding-right:5px">
					
						<cfif s gt 1 and s lte BudgetEntryLines>
						
						  	<img src="#session.root#/images/btn_delete.gif" 
								 align="absmiddle"
								 height="14" 
								 style="cursor:pointer;" 
								 title="#lt_text#" 
								 onclick="removeBudgetEntryLine('#code#',#s#,#BudgetEntryLines#,'#row#'); ItemTotalCalculate(0, 0)">
		
						</cfif>
						
					</td>
							 
						<cfif URL.Mode neq "edit" and url.mode neq "add">	
						   
						   	 <td style="height:25px;padding-right:1px;min-width:160" id="description" class="labelmedium">	  
						     	#entry.requestDescription#
							 </td>
							 	   
					    <cfelse>		
					   				     		 
							  <td style="height:25px;width:100%;padding-right:4px">	
							  
							  <cfif entry.requirementid eq "">							  
							  		<cfset vid = "">
							  <cfelse>							  
							  		<cfset vid = entry.requirementid>
							  </cfif>
																			
							  <!--- 2/7/2014 removed as this gave ajax errors 	--->				  
							  <cf_securediv id="description_#row#" 
							     bindOnLoad="Yes" 
								 bind="url:getRequestDescription.cfm?setlabel=0&line=#row#&id=#vid#&itemmaster=#Code#&mission=#program.mission#&location={requestlocationcode}">  
								 
								 <!---
								  <cfset url.setlabel   = "0">
								  <cfset url.line       = row>
								  <cfset url.id         = vid>
								  <cfset url.itemmaster = code>
								  <cfset url.mission    = program.mission>
								  <cfset url.location   = selected>
							  					  
							  	  <cfinclude template="getRequestDescription.cfm">						 
								 
							  </cfdiv>
							  
							  --->	 					  	 
							  
							  </td>
							  
					    </cfif>
						  							 					 							
							<cfif URL.Mode neq "edit" and url.mode neq "add">
					   
					   	     <td style="padding-right:0px;width:60" align="right" class="labelmedium">						   
					   	      #entry.ResourceQuantity# 
							 </td> 
							 
							 <td style="padding-right:0px;width:50" align="right" class="labelmedium">		
							  <cfif BudgetEntryQuantity2 eq "1">			   
					   	      #entry.ResourceDays#				
							  </cfif>	   
						     </td>
							 
							 <td style="padding-right:0px;width:50" align="right" class="labelmedium">						   
					   	      #entry.requestQuantity#					   
						     </td>
					   
					   	   <cfelse>
					   
					        <td style="padding-right:2px">	
							
							    <cfinput type = "Text"
							       name       = "resourcequantity_#row#"
								   id         = "resourcequantity_#row#"
							       value      = "#entry.resourceQuantity#"					       	
								   class      = "enterastab regularxl"		  
								   style      = "text-align:right;height:25;width:50;border:0px;border-right:1px solid silver"
								   message    = "Please enter a quantity"
								   onblur     = "javascript:syncAmounts()"
							       required   = "no">
		
						    </td>
						  				  					   
						    <td style="padding-right:2px">
							
							    <cfif BudgetEntryQuantity2 eq "1">
								
									<cfset vTempResourceDays = 1>
									<cfif entry.resourcedays neq "">
										<cfset vTempResourceDays = entry.resourcedays>
									</cfif>
															  						  
								    <cfinput type  = "Text"
								       name        = "resourcedays_#row#"
									   id          = "resourcedays_#row#"
								       value       = "#vTempResourceDays#"					       
									   class       = "enterastab regularxl"			  
									   style       = "text-align:right;height:25;width:50;border:0px;border-right:1px solid silver"
									   message     = "Please enter a quantity"
								       required    = "no">
								   
								 <cfelse>
								 
									 <input type="hidden"
								       name="resourcedays_#row#"
									   id="resourcedays_#row#"
								       value="1">
								 
								 </cfif>  
								   
						    </td>
						 				 					   
						    <td style="padding-left:1px;text-align:right;padding-right:1px;">
													   			 									 
							  <cf_securediv id="quantity_#row#" class="labelmedium" style="background-color:f4f4f4;width:50;border-right:1px solid silver;height:25;padding-right:3px;" bindonload="Yes"
							    bind="url:RequestQuantityMode1.cfm?modality=test&mode=quantity&start=#row#&lines=#row#&resource_#row#={resourcequantity_#row#}&day_#row#={resourcedays_#row#}">
								
								<!---
								<div id="quantity_display_#row#" style="padding-top:3px;font-size:14">#numberformat(entry.requestQuantity,",__")#</div>														
								<input type="hidden" name="requestquantity_#row#" id="requestquantity_#row#" value="#entry.requestQuantity#">																	
							  </cfdiv>	
							  --->
																							   
						     </td>
											 
						 </cfif>	
											 	 			  		   
						 <cfif URL.Mode neq "edit" and url.mode neq "add">
							   
						   	     <td style="padding-right:3px" align="right" class="labelmedium">#numberformat(entry.requestPrice,",.__")# </td>
							   
						 <cfelse>
							   
								 <td style="padding-left:1px;padding-right:3px;">
																																
									   <cfif entry.requestprice lte "0.05">
									     <cfset val = "#numberformat(CostPrice,",.__")#">
									     <!--- <cfset val = "0.00">	--->
									   <cfelse>	 			
									      <cfset val = "#numberformat(entry.requestPrice,",.__")#">
									   </cfif>
						
									   <cf_tl id="Please enter an amount" var="1">
									   
									   <cfif mode.BudgetForceStandardCost eq "1">
									   
									    <input type="Text" 
										   name     = "requestprice_#row#"
										   id       = "requestprice_#row#"
									       value    = "#val#"							       				   
										   style    = "text-align:right;width:70;height:25;border:0px;border-right:1px solid silver"
										   message  = "#lt_text#" readonly
										   class    = "regularxl enterastab" 
									       required = "no">		
									   
									   <cfelse>
																										   								   
									   <cfinput type="Text" 
										   name     = "requestprice_#row#"
										   id       = "requestprice_#row#"
									       value    = "#val#"							       				   
										   style    = "text-align:right;width:70;height:25;border:0px;border-right:1px solid silver"
										   message  = "#lt_text#"
										   class    = "regularxl enterastab" 
									       required = "no">			   
										   
										</cfif>   
						 	   			
						 	   			<input type="hidden" name="requestpriceold_#row#" id="requestpriceold_#row#" value="#val#">
		 
								 </td>
							   
						 </cfif>		
				 	   			   
						 <td align="right" class="labelmedium"
						    style="width:85px;text-align:right;border-bottom:1px solid silver;border-right:1px solid silver">
					   
					   	<cfif URL.Mode neq "edit" and url.mode neq "add">
		
						   		#numberformat(entry.requestAmountBase,",.__")#
							
						<cfelse>		
								
																				
								<cf_securediv id="total_#row#" class="labelmedium" style="background-color:A4FFA4;width:80;border:0px solid silver;height:25;padding-top:3px;padding-right:3px;" bindonload="Yes"
								bind="url:RequestQuantityMode1.cfm?modality=test&mode=total&start=#row#&lines=#row#&price={requestprice_#row#}&resource_#row#={resourcequantity_#row#}&day_#row#={resourcedays_#row#}">							
								
								<!--- 
								#numberformat(entry.requestAmountBase,",.__")#																
								</cfdiv>
								--->
																	
						</cfif>						
														
						<input type="hidden" name="requestamountbase_#row#" id="requestamountbase_#row#" value="#entry.requestAmountBase#">				
												
						</td>
										
					</tr>
					
					<tr>
						<td colspan="9" id="InstructionsDetail_#code#" style="display:none;">
							<cfdiv id="divInstructionsDetail_#code#">
						</td>
		   			</tr>
					
			</cfloop>
						
		</cfoutput>
		
		<cfquery name="Total" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    SUM(requestAmountBase) as Amount
				FROM      ProgramAllotmentRequest
				WHERE     RequirementIdParent = '#parentid#'				
		</cfquery>		
		
		<tr><td colspan="3" style="height:30" align="right" class="labelmedium"><cf_tl id="Total">:</td>
		    <td colspan="6" align="right">	
			    <cfdiv id="overall" class="labelmedium" style="background-color:77E7EC;width:100;height:25;padding-right:3px;;border:1px solid silver"><cfoutput>#numberFormat(Total.Amount,"___,___.__")#</cfoutput>
				</cfdiv>		
			</td>
		</tr>	
			
		</table>
	
	</td></tr>