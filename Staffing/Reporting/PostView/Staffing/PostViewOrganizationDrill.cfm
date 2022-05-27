
	<cfparam name="level4"   default="f8f8f8">
	<cfparam name="level7"   default="EFEB9A">
	<cfparam name="level10"  default="YELLOW">
	<cfparam name="level13"  default="D5EC9D">
	<cfparam name="level16"  default="C2E7E2">
	<cfparam name="level19"  default="D5B5BD">
							
	<cfquery name="SearchResult"
	datasource="AppsTransaction">
	    SELECT   DISTINCT SelectionDate,
				 Mission,
		         OrgUnit,
		         OrgUnitName, 
				 HierarchyCode, 
				 OrgUnitCode,
				 OrgExpiration,				 
				 Class, 
				 PostGradeBudget, 
				 PostOrderBudget, 
				 ViewOrder, 
				 ListOrder,
				 Code,
				 (SELECT SUM(Total)
				  FROM   stCacheStaffingView
				  WHERE  DocumentId    = '#URL.FilterId#' 
				  AND    HierarchyCode LIKE F.HierarchyCode+'%'
				  ) as ControlTotal,
				 Total as Total,  
				 TotalCum
		FROM     stCacheStaffingView F
		WHERE    DocumentId    = '#URL.FilterId#' 
		AND 	 HierarchyCode > '#URL.HStart#' 
		AND 	 HierarchyCode < '#URL.HEnd#'
		AND 	 (
		           PostGradeBudget != 'Subtotal' 
		         OR
				   PostGradeBudget = 'Subtotal' AND
				   Listorder IN	(SELECT ListOrder
								 FROM   stCacheStaffingView
							 	 WHERE  DocumentId = '#URL.FilterId#'
								 AND    Code=F.Code
								 AND    PostGradeBudget!='SubTotal')					
				 )
				
		ORDER BY HierarchyCode, 
		         OrgUnit, 
				 OrgUnitName, 
				 ListOrder, 
				 ViewOrder, 
				 PostOrderBudget, 
				 PostGradeBudget  			
				 
	</cfquery>
	
	<cfquery name="Param" 
		datasource="AppsEmployee">
	    SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#SearchResult.Mission#' 
	</cfquery>
	
	<!--- select resource --->
	<cfquery name="Resource" dbtype="query">
		SELECT   distinct ViewOrder, PostGradeBudget
		FROM     SearchResult
	</cfquery>
	
	<cfset list = "">
	<cfset cellspace = round(1000/Resource.recordcount)>	
	
	<cfif Resource.recordcount gte "1">
	<cfif cellspace lt "39">
	   <cfset cellspace = 39>	
	</cfif>
	</cfif>
		
	<table width="100%" border="0">
				
	<cfoutput query="SearchResult" group="HierarchyCode"> 	
	
		<cfif controltotal gt "0">
				
			<cfset row = 0>
									
			<cfset Spaces = Len(HierarchyCode)-1>
			<cfif Spaces lte "4">
				<cfset cls = "regular">		
			<cfelse>
				<cfset cls = "hide">			
			</cfif>
							
			<cfset co = evaluate("level"&#Spaces#)>	
						
				<TR class="#HierarchyCode# #cls#"> 
																						
					<cfset co = evaluate("level"&#Spaces#)>				
												
						<cfquery name="Check"
						datasource="AppsTransaction">
							SELECT count(*) as Total
							FROM   stCacheStaffingView
							WHERE  DocumentId   = '#URL.FilterId#' 
							AND    HierarchyCode LIKE '#HierarchyCode#.%' 
						</cfquery>
						
						<cfif OrgExpiration lt SelectionDate and OrgExpiration neq "">
						    <cfset co = "FEBBAF">
						</cfif>	
												
						<cfset indent = 0>
						<cfloop index="sp" from="1" to="#Spaces#" step="3">
						  <cfset indent = indent+1>
						</cfloop>
						
						<!--- cell with the unit name --->
			
						<cfif Param.StaffingViewMode eq "Extended">				
							<cfset span="7">							
						<cfelse>
							<cfset span="4">										
						</cfif> 
									
																						
						<td rowspan="#span#" id="cell#HierarchyCode#" valign="top" style="padding-left:2px;width:100%;">		
							 																																																				
							<table height="90" width="96%" style="border:1px solid gray;">
														
								<tr>			
								
								<td valign="top"  style="height:99%;background-color:##FED7CF80;min-width:30px;padding-top:7px; padding-right:6px;padding-left:12px;">
																		
									<cfif Check.Total gt "1">
									
									    <cfif Spaces lt "2">
													  				
											<img src="../../../../Images/folder.gif" alt="Click to access units under #OrgUnitName#" 
											id="#HierarchyCode#Exp" border="0" class="hide" height="17" width="16"
											align="middle" style="cursor: pointer; border : 0px solid silver;" 
											onClick="shownode('#HierarchyCode#')">
											
											<img src="../../../../Images/folder_check.gif" 
											id="#HierarchyCode#Min" alt="Click to hide units" border="0" height="17" width="16"
											align="middle" class="regular" style="cursor: pointer; border : 0px solid silver;" 
											onClick="hidenode('#HierarchyCode#','#Spaces#')">
														
										<cfelse>
										
											<img src="../../../../Images/expand_panel.png" alt="Click to access units under #OrgUnitName#" 
											id="#HierarchyCode#Exp" border="0" class="regular" 
											align="middle" style="cursor: pointer; border : 0px solid silver;" 
											onClick="shownode('#HierarchyCode#')">
											
											<img src="../../../../Images/collapse_panel.png" 
											id="#HierarchyCode#Min" alt="Click to hide units" border="0" 
											align="middle" class="hide" style="cursor: pointer; border : 0px solid silver;" 
											onClick="hidenode('#HierarchyCode#','#Spaces#')">				
										
										</cfif>
																					
									</cfif>		
													
									<cfset Check.total = "1">
								
								</td>	
																
								<td valign="top" style="min-width:276px;max-width:273px;cursor:pointer;border-left:0px" onclick="hidenode('#HierarchyCode#','#Spaces#')">
																								
								    <table style="width:100%">
									
									<tr class="labelmedium">
																		
									<td style="font-size:14px;padding-left:5px;padding-top:4px;line-break: strict;">
									
									<cfif url.tree eq "Operational">
																													
										<cfinvoke component="Service.Access"  
									     method="staffing" 
										 mission="#Mission#"
										 orgunit="#orgunit#" 
										 posttype=""
										 returnvariable="accessStaffing">
											  
										<cfinvoke component="Service.Access"  
									     method="position" 
										 mission="#Mission#"
									     orgunit="#orgunit#" 
										 posttype=""
									     returnvariable="accessPosition">										 
										 								
										<cfif AccessStaffing eq "NONE" and AccessPosition eq "NONE">
											#OrgUnitName#
										<cfelse>
											<a href="javascript:maintainQuick('#OrgUnitCode#')" title="#OrgUnitName# Show all positions and incumbents">
											<font color="000000">#OrgUnitName#</font>
											</a>
										</cfif>
															
									<cfelse>
									
										#OrgUnitName# 
									
									</cfif>	
									
									</td>
																						
									<cfquery name="Mandate"
										datasource="AppsOrganization">
										SELECT *
										FROM   Ref_Mandate
										WHERE  Mission = '#Mission#'
										AND    DateExpiration > '#orgExpiration#'
									</cfquery>
																
									</tr>
									
									<tr><td colspan="2" style="padding-left:10px">
					
									<table>
										<tr>
										<td class="labelmedium" style="font-size:14px;min-width:250px">
										    <cfif OrgUnitCode neq "Tree">
												<cfloop index="i" from="1" to="#indent#"><cfif i neq "1">&nbsp;&nbsp;</cfif>.</cfloop>
												&nbsp;#OrgUnitCode#
											</cfif>
											
										</td>
										</tr>
									</table>
								
									</td>
									</tr>
									
									<!---
									<cfif Mandate.recordcount gte "1">	
									<tr class="labelmedium">
									<td><cf_tl id="Expiry">:</td>
									<td style="padding-left:3px"><font color="FF0000">#dateformat(orgExpiration,client.dateformatshow)#</td>							
									</tr>
									</cfif>
									--->
									
									</table>							
												
								</td>
								
								<td align="right" valign="top" style="min-width:23px;padding-top:3px;padding-right:0px;cursor:pointer" onclick="hidenode('#HierarchyCode#','#Spaces#')">
								
									<cfif Class neq "">
																		
										<img src = "#client.VirtualDir#/Images/Expand-Down.png"
										     alt     = "Staffing only for #OrgUnitName#"
										     name    = "d#OrgUnit#Exp"
										     id      = "d#OrgUnit#Exp"
										     border  = "0"
											 height  = "20"
										     align   = "right"
										     class   = "regular"
										     style   = "cursor: pointer;"
										     onClick = "detaillisting('#OrgUnit#','show','only','','','','','',snapshot.value)">
											 
										<img src   = "#client.VirtualDir#/Images/menu_close.png" 
											id     = "d#OrgUnit#Min" alt="Hide" border="0" height  = "20"
											align  = "right" class="hide" style="cursor: pointer;" 
											onClick= "detaillisting('#OrgUnit#','hide','only','','','','','',snapshot.value)">
											
									</cfif>		
									
								</td>																			
									
								</tr>
														
								<cfif OrgExpiration lt selectiondate and OrgExpiration neq "">
								<tr><td class="labelmedium"  colspan="3">						
								<cf_tl id="Expiry">: <font color="FF0000">#dateformat(OrgExpiration,CLIENT.DateFormatShow)#</font>
								</td>
								</tr>
								</cfif>
									
							</table>
								
						</td>
								
						<cfoutput group="ListOrder">
											
							  <cfset row = row+1>
							  						  
							  <cfif Total eq "0" and Listorder gt "4">
							  																							 	
								  <cfif list eq "">		
								  	  <cfset list = "cell#HierarchyCode#">			 	  
								  <cfelse>
									  <cfset list = "#list#|cell#HierarchyCode#">
								  </cfif>
							  							  
							  <cfelse>
							  						  
								<cfif Class neq "">
									  		    
									  <cfif ListOrder LE 4>
									  	<cfset fgc = "000000">
									  	<cfset bgc = "FFFFFF">
									  <cfelse>
									  	<cfset fgc = "FF5555">
									  	<cfset bgc = "FFF4F4">
									  </cfif>
										  		  
						          <td style="font-size:12px;padding-left:2px;cursor:pointer;min-width:42;border-bottom:1px solid gray">
								  								  								 								   					  							  
									   <cfif Client.LanguageId eq "ESP">
									   
										  		<cfswitch expression="#Left(class, 1)#">
													   <cfcase value="A"> 
																A		
													   </cfcase> 
													   <cfcase value="N"> 
																N		
													   </cfcase> 
													   <cfcase value="I"> 
																O		
													   </cfcase> 
													   <cfcase value="V"> 
																V		
													   </cfcase> 
												</cfswitch>
												
										<cfelse>
																				
										<cfswitch expression="#Left(class, 1)#">
											   <cfcase value="A"> 
														<a style="padding-left:2px" title="Budgeted Positions">EST.</a>	
											   </cfcase> 
											   <cfcase value="N"> 
														<a style="padding-left:2px" title="Non-staff Positions">NON</font></a>		
											   </cfcase> 
											   <cfcase value="I"> 
														<a style="padding-left:2px" title="Incumbents">INC</a>		
											   </cfcase> 
											   <cfcase value="V"> 
														<a style="padding-left:2px" title="Vacant Positions">VAC</a>		
											   </cfcase> 
											   <cfcase value="G"> 
														<a title="Extra budgetairy positions">XBU</a>		
											   </cfcase> 
										</cfswitch>
										
										</cfif>
										
						          </td>		 		     		  
															      
								 	<cfoutput>
									
									<!---cell --->
										  
									 <!--- quasi dynamic approach --->
									  
									  <cfif ListOrder eq "1">
										      <cfset cl = "F1F1F1">
									  <cfelseif ListOrder eq "2">
										      <cfset cl = "F6F6F6">	  
									  <cfelseif ListOrder eq "3">	
										     <cfset cl = "EEF3E2">	 
									  <cfelseif ListOrder eq "4">	
										     <cfset cl = "FFFFCF">	  
									  <cfelseif ListOrder eq "5">	
										     <cfset cl = "FFF4F4">	  
									  <cfelseif ListOrder eq "6">	
										     <cfset cl = "FFF3E2">	  
									  <cfelse>
										     <cfset cl = "FFE0E0">	 
									  </cfif>	
									  
									  <cfif PostGradeBudget eq "Total" or PostGradeBudget eq "Subtotal">
									    <cfset clt = "D5DAD1">
									  <cfelse>
									    <cfset clt = "FFFFFF">	
									  </cfif>
									  
									  <cfif TotalCum eq "0" and PostGradeBudget eq "Total" and Class eq "Aut">
									            
										    <script language="JavaScript">
												se = document.getElementById("d#OrgUnit#Exp")
												if (se)	{ se.className = "hide" }
											</script>
											
									  </cfif>
											  
									  <cfset sl = "font-size:14px;border:1px solid ##6688aa;min-width:#cellspace#px">
									  														 
									  <cfif Total eq "0" or Total eq "">
															  
									      <td class="cellr" style="#sl#;background-color:f1f1f1"></td>
																			
									  <cfelse>
									 
									      <cfif PostGradeBudget eq "Total">
											  <td class="cellR" style="#sl#" onClick="detaillisting('#OrgUnit#','show','all','','total','#class#',this,'grade',snapshot.value)">								
											   <font color="#fgc#">#Total#</font></td>
									 	  <cfelseif PostGradeBudget eq "Subtotal">
											  <td class="cellR" style="#sl#" onClick="detaillisting('#OrgUnit#','show','all','#Code#','subtotal','#class#',this,'grade',snapshot.value)">								
											    <font color="#fgc#">#Total#</font></td>
										  <cfelse>
											  <td class="cellR" style="#sl#" bgcolor="#cl#" onClick="detaillisting('#OrgUnit#','show','all','#PostGradeBudget#','grade','#class#',this,'grade',snapshot.value)">						  								
											  <font color="#fgc#">#Total#</font></td>
										  </cfif>
									  </cfif>
										  						  
						      		</cfoutput>
								  
								</cfif>
												  
						  </cfif>
				
					  </tr>
					  
					  <tr class="#hierarchycode# #cls#">
					 					 				
				</cfoutput>				
															
			<!--- content box for details --->
			<tr class="hide" id="d#OrgUnit#"><td colspan="#Resource.RecordCount+3#" style="padding-left:15px;padding-bottom:1px" id="i#OrgUnit#"></td></tr>	
						
		</cfif>
													
	</CFOUTPUT>
		
</table>	

<cfoutput>

<script>
	Prosis.busy('no')	
	// not needed for proper interface handling
	// ptoken.navigate('PostViewOrganizationDrillSet.cfm?list=#list#','process')	
</script>
</cfoutput>