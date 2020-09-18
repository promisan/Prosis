	
<cfset unt = "#URL.Unit#">
<cfif unt eq "cum">
   <cfset unt = "">
</cfif>

<tr><td id="process"></td></tr>

<!---
<table width="100%" 
       border="0"
	   align="center" 
	   class="<cfif Max.Total gt "0">regular<cfelse>Hide</cfif>" 
       id="<cfoutput>#OrgUnit#</cfoutput>" 
	   bgcolor="transparent">
	 
 	<tr><td height="4"></td></tr>
	
    <tr><td valign="top" colspan="14">
	
    <table width="100%">
	
	--->
			
	<cfset Org = OrgUnit>
							
	<cfquery name="SearchResult"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	
	    SELECT   TOP #Resource.recordcount*strows# OrgUnit, 
		         OrgUnitName, 
				 HierarchyCode, 
				 OrgUnitCode,
				 SelectionDate,
				 OrgExpiration,
				 Class, 
				 PostGradeBudget, 
				 PostOrderBudget, 
				 ViewOrder, 
				 ListOrder,
				 OperationalMission,
				 OperationalMandateNo,
				 Code,
				 Total as Total,
				 TotalCum
		FROM     #SESSION.acc#Grade2_#FileNo# F   
		WHERE	 HierarchyCode >= '#HStart#' 
		AND 	 HierarchyCode < '#HEnd#' 
		
		AND 	 (
			         PostGradeBudget != 'Subtotal' 
			         OR
					 PostGradeBudget = 'Subtotal' AND
					 Listorder IN	(SELECT ListOrder
									 FROM   #SESSION.acc#Grade2_#FileNo#
								 	 WHERE  Code = F.Code
									 AND    PostGradeBudget!='SubTotal')					
					 )				
		
		ORDER BY HierarchyCode, OrgUnit, OrgUnitName, ListOrder, ViewOrder, PostOrderBudget, PostGradeBudget 
	
    </cfquery>
						
	<cfoutput query="SearchResult" group="HierarchyCode">
							
		<cfset Spaces = "#Len(HierarchyCode)-1#">
		
		<cfif Spaces lte lvl>
			<cfset cls = "regular">
		<cfelse>		
			<cfset cls = "hide">
		</cfif>		
		
		<cfparam name="level#spaces#" default="ffffff">		
		
		<cfset co = evaluate("level#Spaces#")>
		
		<cfif co eq "ffffff">
		  <cfset co = "transparent">
		</cfif>
	
    	<TR bgcolor="#co#" id="#HierarchyCode#" class="#cls#">
		
		<!---				
		<cfset grp = HierarchyCode>
		<cfif len(grp) gte "8">
		    <cfset bx = left(grp,5)>
			<td colspan="2" class="regular" id="T#bx#">			
		<cfelse>
			<td colspan="2" class="regular">			
		</cfif>	
			
		<table width="100%">			 	
		--->
					
		<cfset co = evaluate("level"&#Spaces#)>
						
		<cfquery name="Check"
		datasource="AppsQuery"
		username="#SESSION.login#"
		password="#SESSION.dbpw#">
			SELECT	TOP 2 *
			FROM  	#SESSION.acc#Grade2_#FileNo#
			WHERE	HierarchyCode LIKE '#HierarchyCode#.%' 
		</cfquery>
		
		<cfif  OrgExpiration lt date and OrgExpiration neq "">
		  <cfset color = "FF8080">
		<cfelse>
		  <cfset color = "white">  
		</cfif>
		
		<!---
		<tr bgcolor="white">
		--->
		
			<!--- cell with the unit name --->
			
			<cfif Param.StaffingViewMode eq "Extended">				
				<cfset span="7">							
			<cfelse>
				<cfset span="4">										
			</cfif> 
											
			<td rowspan="#span#" id="cell#HierarchyCode#" valign="top" align="left" style="padding-left:2px;padding-top:1px;">
										    
					<table height="90" width="96%" class="formpadding">
										
					<tr>
					
					<td width="100%" valign="top" 
					   style="background-color:##e1e1e180;min-width:50px;width:50px;padding-top:5px;padding-right:2px;padding-left:2px;border:1px solid gray;border-right:0px">
									
														
						<cfif Check.recordcount gt "1">		
										
							
							<img src="#client.VirtualDir#/Images/expand_panel.png" 
							  alt="Click to access units under #OrgUnitName#" 
							  id="#OrgUnit#Expand" border="0" class="regular" 
							  align="absmiddle" style="cursor: pointer; border : 0px solid silver;" 
							  onClick="showorg('#OrgUnit#','#HStart#','#HEnd#','#cellspace#')">
							
							<img src="#client.VirtualDir#/Images/collapse_panel.png" 
							  id="#OrgUnit#Min" alt="Click to hide units" border="0" 
							  align="absmiddle" class="hide" style="cursor: pointer; border : 0px solid silver;" 
							  onClick="hideorg('#orgunit#')">
																	
						</cfif>		
										
						<cfset Check.total = "1">
				
				    </td>		
				
					<cfset indent = 0>
					<cfloop index="sp" from="1" to="#Spaces#" step="3">
					     <cfset indent = indent+1>
					</cfloop>
										
					<td height="100%" valign="top" style="border:1px solid gray;silver;border-left:0px">
																								
						<table style="width:100%">
												
						<tr>
						
						<td valign="top" style="line-break: strict;font-size:16px;padding-right:20px" class="labelmedium">
						
						    <cfif url.tree eq "Operational">
														
								<cfinvoke component="Service.Access"  
							       method="staffing" 
								   mission="#OperationalMission#"
								   orgunit="#orgunit#" 
								   posttype=""
								   returnvariable="accessStaffing">
									  
								<cfinvoke component="Service.Access"  
							       method="position" 
								   mission="#OperationalMission#"
							       orgunit="#orgunit#" 
								   posttype=""
							       returnvariable="accessPosition">
								
								<cfif AccessStaffing eq "NONE" and AccessPosition eq "NONE">#OrgUnitName#
								<cfelse>
									<a href="javascript:maintainQuick('#OrgUnitCode#')" title="#OrgUnitName#">#OrgUnitName#</a>
								</cfif>
							
							<cfelse>							
							
							    #OrgUnitName#							
								
							</cfif>
							
						</td>			
											
						<td rowspan="2" valign="top" align="right" style="min-width:30px;padding-top:2px;padding-right:4px">
														
							<cfif Class neq "" and orgUnitCode neq "Tree">
							
								<img src="#client.VirtualDir#/Images/menu.png"
								   	  alt="Staffing only for #OrgUnitName#"
								      name="d#OrgUnit#Exp"
								      id="d#OrgUnit#Exp"
								      border="0"
									  height="20"
								      align="right"
								      class="regular"
								      style="cursor: pointer;background-color:transparent"
								      onClick="detaillisting('#OrgUnit#','show','only','','','','','',snapshot.value,'#OperationalMission#','#OperationalMandateNo#')">
									 
								<img src="#client.VirtualDir#/Images/menu_close.png" 
									 id="d#OrgUnit#Min" 
									 alt="Hide" 
									 border="0" 
									 height="20"
									 align="right" 
									 class="hide" 
									 style="cursor: pointer;" 
									 onClick="detaillisting('#OrgUnit#','hide','only','','','','','',snapshot.value,'#OperationalMission#','#OperationalMandateNo#')">
									
							</cfif>		
														
						</td>	
								
						</tr>
						
						<tr>
						<td colspan="1" valign="top">
						
							<table>
								<tr>
								<td class="labelmedium" style="font-size:16px;min-width:250px">
								    <cfif OrgUnitCode neq "Tree">
										<cfloop index="i" from="1" to="#indent#"><cfif i neq "1">&nbsp;&nbsp;</cfif>.</cfloop>
										#OrgUnitCode#
									</cfif>										
								</td>
								</tr>
							</table>
									
						</td>						
						</tr>
						
						<cfif OrgExpiration lt date and OrgExpiration neq "">
						<tr><td class="labelmedium"  style="padding-left:0px">						
							<cf_tl id="Expiry">: <font color="FF0000">#dateformat(OrgExpiration,CLIENT.DateFormatShow)#</font>
							</td>
						</tr>
						</cfif>
						
					</table>								
										
					</tr>
					
				</table>
							
			</td>						
		
	  <cfoutput group="ListOrder">
	  
	  <cfif Total eq "0" and Listorder gt "4">
	  
		  <script language="JavaScript">	  	  		
		 		 document.getElementById("cell#HierarchyCode#").rowSpan = document.getElementById("cell#HierarchyCode#").rowSpan-1  
		  </script>
	  	  
	  <!--- skip --->
	  
	  <cfelse>
	  			  		  
		  <cfif Class neq "">
		  				    
		  <cfif ListOrder LE 4>
		  	<cfset fgc = "000000">
		  	<cfset bgc = "FFFFFF">
		  <cfelse>
		  	<cfset fgc = "FF5555">
		  	<cfset bgc = "FFF4F4">
		  </cfif>
		 			 			  		     		  
		  <td style="height:26px;font-size:12px;padding-left:2px;cursor:pointer;min-width:40;border-bottom:1px solid gray">
			  
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
			            <cf_UIToolTip  tooltip="Budgeted Positions">EST</cf_UITooltip>								
				   </cfcase> 
				   <cfcase value="N"> 
				        <cf_UIToolTip  tooltip="Non-staff Positions">NON</cf_UITooltip>	 							
				   </cfcase> 
				   <cfcase value="I"> 
				   		<cf_UIToolTip  tooltip="Incumbents">INC</cf_UITooltip>								
				   </cfcase> 
				   <cfcase value="V"> 
				         <cf_UIToolTip  tooltip="Vacant Positions">VAC</cf_UITooltip>								
				   </cfcase> 
				   <cfcase value="G"> 
				   		<cf_UIToolTip  tooltip="Extra budgetairy positions">XBP</cf_UITooltip>										
				   </cfcase> 
				</cfswitch>
				
				</cfif>
			  
		  </td>
		      
		  <cfoutput>
			  
		  		<cfsilent>
			  
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
				    <cfset clt = "EEFDF1">
				  <cfelse>
				    <cfset clt = "FFFFFF">	
				  </cfif>						  					
			  
			  </cfsilent>
			  						  					  
			  <cfif TotalCum eq "0" and PostGradeBudget eq "Total" and Class eq "Aut">
			            
				  	    <script language="JavaScript">
						se = document.getElementById("d#OrgUnit#Exp")
						if (se)
						{ se.className = "hide" }
						</script>
			  </cfif>
			  
			  <cfset sl = "font-size:14px;border:1px solid ##6688aa;min-width:#cellspace#px">
			  
			  <cfif Total eq "0" or Total eq "">
			  			  			  					  
			      <td class="cellR" style="#sl#;background-color:fafafa"></td>
				  
			  <cfelse>			
			  
			      <cfif PostGradeBudget eq "Total">
					  <td onmouseover="this.style.backgroundColor='##0B8EDD50'" onmouseout="this.style.backgroundColor='white'" style="#sl#;background-color:white" class="cellR" onClick="<cfif orgUnitCode neq 'Tree'>detaillisting('#OrgUnit#','show','all','','total','#class#',this,'grade',snapshot.value,'#OperationalMission#','#OperationalMandateNo#','#cellspace#')</cfif>">								 
					  <font color="#fgc#">#Total#</font></td>
			 	  <cfelseif PostGradeBudget eq "Subtotal">
					  <td onmouseover="this.style.backgroundColor='##0B8EDD50'" onmouseout="this.style.backgroundColor='#clt#'" bgcolor="#clt#" style="#sl#" class="cellR" onClick="<cfif orgUnitCode neq 'Tree'>detaillisting('#OrgUnit#','show','all','#Code#','subtotal','#class#',this,'grade',snapshot.value,'#OperationalMission#','#OperationalMandateNo#','#cellspace#')</cfif>">
					  <font color="#fgc#">#Total#</font></td>
				  <cfelse>
					  <td class="cellR" style="#sl#" onmouseover="this.style.backgroundColor='##0B8EDD50'" onmouseout="this.style.backgroundColor='#cl#'" bgcolor="#cl#" onClick="<cfif orgUnitCode neq 'Tree'>detaillisting('#OrgUnit#','show','all','#PostGradeBudget#','grade','#class#',this,'grade',snapshot.value,'#OperationalMission#','#OperationalMandateNo#','#cellspace#')</cfif>">								
					  <font color="#fgc#">#Total#</font></td>
				  </cfif>
			  </cfif>
			  </cfoutput>	
			  <td style="width:1px"></td>	  
		  </tr>
		 		 		  		 		  
		  </cfif>
	  
	  </cfif>
	  
	  </cfoutput>
					
	<tr class="hide" id="d#OrgUnit#"><td colspan="#Resource.RecordCount+3#" id="i#OrgUnit#"></td></tr>		
	<tr><td height="2"></td></tr>		
	<tr><td colspan="#Resource.RecordCount+3#" id="detail_#OrgUnit#" style="padding-right:1px"></td></tr>	
	<tr><td style="height:15px"></td></tr>
						
	</CFOUTPUT>	
	
