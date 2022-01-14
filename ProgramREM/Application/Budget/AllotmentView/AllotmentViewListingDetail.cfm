<cfoutput>

<cfset lev = 0>
<cfset fd = 0>

<cfloop index="i" from="1" to="2" step="1">
    <cfset fd = Find(".", "#ProgramHierarchy#" , "#fd+1#")>
	<cfif fd neq "0">
    	<cfset lev = lev + 1>
	</cfif>
</cfloop>


<cfif Lev eq "0">
  
  	   <cfset color = "EBF7FE">
       <cfif EntryMethod neq "">			
			<cfset Class = "regular">
	   <cfelse>
		   <cfif ProgramScope eq "Unit">
   			<cfset Class = "Regular">
		   <cfelse>
		    <cfset Class = "Regular">	
			<cfset color = "F5FBFE">
		   </cfif>	
	   </cfif>
	  
	    				
		<tr class="navigation_row line fixlengthlist" bgcolor="#color#">		
				
			<td class="#Class#" align="right">			
			
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr><td class="labelmedium" style="padding-left:20px"><b>.</b>
				</td>
				
				<td align="right" style="padding-right:25px;PADDING-TOP:3PX">
															  
			    <cfif BudgetAccess EQ "Manager"> 
				  	    <cfset menu = "FULL">
				<cfelse>
				  		<cfset menu = "LIMITED">
				</cfif>
				<cfset icon = "option4.gif">		
				  
			  <cfif menu eq "NONE">
				  
				  <cfset sc = "">				  
				  <img src="#SESSION.root#/Images/arrowright.gif" alt="Global Program" alt="" border="0" align="absmiddle">
							  
			  <cfelse>
			  			  		  							
					<cfif EntryMethod neq "">						
																								  
						  <cfif menu EQ "FULL"> 
										 
							  <img src="#SESSION.root#/Images/due.png?id=1" name="imgx_#currentrow#" 
							  onMouseOver="document.imgx_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
							  onMouseOut="document.imgx_#currentrow#.src='#SESSION.root#/Images/due.png?id=1'"								 
							  style="cursor: pointer;" alt="Pending Clearance" border="0" align="absmiddle" height="14" width="14" 
							  onClick="AllotmentInquiry('#ProgramCode#','','#URL.Period#','#url.mode#','#URL.Version#','#url.systemfunctionid#')"> 
						  
						  	  <cfset sc = "AllotmentInquiry('#ProgramCode#','','#URL.Period#','budget','#URL.Version#','#url.systemfunctionid#')">
														
						  <cfelse>
						  
							  <cf_img icon="open" onclick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')">								
						      <cfset sc = "ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')">
															 
						 </cfif>
										 
					<cfelse>
											
						 <cfif ProgramScope eq "Unit">						
												  					  	  
							  <cfif BudgetAccess neq "NONE"> 
							  
							     <cfif lockentry eq "1">								 
									<cf_img icon="open" navigation="Yes" onClick="Allotment('#ProgramCode#','#URL.Fund#','#URL.Period#','budget','#URL.Version#','_blank','#url.systemfunctionid#')">								 					 
								 <cfelse>
								    <cf_img icon="select" navigation="Yes" onClick="Allotment('#ProgramCode#','#URL.Fund#','#URL.Period#','budget','#URL.Version#','_blank','#url.systemfunctionid#')">
								
								 </cfif>	
								 
								  <cfset sc = "Allotment('#ProgramCode#','#URL.Fund#','#URL.Period#','budget','#URL.Version#','_blank','#url.systemfunctionid#')">
								
								 
								 <!---																						 	
								 <img src="#SESSION.root#/Images/#icn#" alt="" name="img5_#ProgramCode#_#currentrow#" 
								  onMouseOver="document.img5_#ProgramCode#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img5_#ProgramCode#_#currentrow#.src='#SESSION.root#/Images/#icn#'"
								  style="cursor: pointer;" alt="" width="12" height="12" border="0" align="absmiddle" 
								  onClick="Allotment('#ProgramCode#','','#URL.Period#','budget','#URL.Version#','_blank','#url.systemfunctionid#')"> 
								 
								 --->
							 				  	
							  <cfelse>
							  
							  	 <cfif lockentry eq "1">
								    <cfset icn = "key.gif">							 
								 <cfelse>
								    <cfset icn = "document.gif">	
								 </cfif>
								 							  
							  	 <img src="#SESSION.root#/Images/#icn#" alt="" name="img9_#ProgramCode#_#currentrow#" 
								  onMouseOver="document.img9_#ProgramCode#_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img9_#ProgramCode#_#currentrow#.src='#SESSION.root#/Images/#icn#'"
								  style="cursor: pointer;" alt="" width="17" height="15" border="0" align="absmiddle" 
								  onClick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')"> 
								  
								 <cfset sc = "ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')">
							  										 
							  </cfif>	
							  
						  <cfelse>
						 												  
						  	 <cfset sc = "">
						  
						  </cfif>
			  
					</cfif>			  
						
				</cfif>	
				
				 <cfif currentrow eq "1">				
					<cf_space spaces="30">
				</cfif>		
				
				</tr></table>		
																
				</td>
						
    			<TD class="#class#">	
															
				<cfif sc neq "">
					<a class="navigation_action" href="javascript:#sc#">
				</cfif>	
								
				<cfif ProgramScope eq "Unit">
					
					<cfif Reference neq "">															
						#Reference# 
								     
					<cfelseif ReferenceBudget1 neq "">									
					
					  <table cellspacing="0" cellpadding="0">
					  <tr class="labelit">
					  <td style="width:35px">#ReferenceBudget1#</td>
						<cfif ReferenceBudget2 neq "">
						<td style="width:35px;padding-left:3px">#ReferenceBudget2#</td>						
						</cfif>
						<cfif ReferenceBudget3 neq "">
						<td style="width:35px;padding-left:3px">#ReferenceBudget3#</td>
						</cfif>
						<cfif ReferenceBudget4 neq "">
						<td style="width:35px;padding-left:3px">#ReferenceBudget4#</td>						
						</cfif>
						<cfif ReferenceBudget5 neq "">
						<td style="width:35px;padding-left:3px">#ReferenceBudget5#</td>
						</cfif>
						<cfif ReferenceBudget6 neq "">
						<td style="width:35px;padding-left:3px">#ReferenceBudget6#</td>				
						</cfif>		
					   </tr>
					   </table>
					
					
					<cfelse>
					    #ProgramCode#
					</cfif>
					
				<cfelse>		
				
					<table cellspacing="0" cellpadding="0" class="formpadding">
					<tr><td>				
					
						<cfif isProjectParent eq "1">
				 						  
					  	 <img src="#SESSION.root#/Images/project.png" name="img10_#searchresult.orgunit#_#currentrow#" 
						  onMouseOver="document.img10_#searchresult.orgunit#_#currentrow#.src='#SESSION.root#/Images/project_faded.png'" 
						  onMouseOut="document.img10_#searchresult.orgunit#_#currentrow#.src='#SESSION.root#/Images/project.png'"
						  style="cursor: pointer;" alt="Add a project" border="0" align="absmiddle" 
						  onClick="AddProject('#url.mission#','#url.Period#','#ProgramCode#','#searchresult.orgunit#','','0','add','budget')"> 
						  
						</cfif>  
						  
						</td>						  
						<td>
						  
					    <cfif isServiceParent eq "1">
						  
						 <img src="#SESSION.root#/Images/service.png" name="img11_#searchresult.orgunit#_#currentrow#" 
						  onMouseOver="document.img11_#searchresult.orgunit#_#currentrow#.src='#SESSION.root#/Images/service_faded.png'" 
						  onMouseOut="document.img11_#searchresult.orgunit#_#currentrow#.src='#SESSION.root#/Images/service.png'"
						  style="cursor: pointer;" alt="Add a activity/service" border="0" align="absmiddle" 
						  onClick="AddComponent('#url.mission#','#url.Period#','#ProgramCode#','#searchresult.orgunit#','','0','add','budget')"> 	  	
						  
						</cfif>  
						  
						</td></tr>
					</table>		  		
									
				</cfif>
				</a>
				</TD>				
				
				<cfif ProgramScope eq "Global">
				
					<td colspan="3" width="30%" class="#class# cellcontent" style="cursor:pointer;border-right:1px solid silver;">									
					<cf_UItooltip sourcefortooltip="#SESSION.root#/programrem/application/budget/allotmentview/AllotmentViewTooltip.cfm?programcode=#programcode#'">#ProgramName#</cf_UItooltip>
					</td>
					
				<cfelse>
				
					<td colspan="3" width="30%" class="#class# cellcontent" style="border-right:1px solid silver;">#ProgramName#</td>			
				
				</cfif>
												
				<cfloop index="item" from="1" to="#Resource.RecordCount#" step="1">
				
					<cfset cei = Evaluate("Ceiling_" & Item)>
					<cfset amt = Evaluate("Resource_" & Item)>
											
					<cfif cei gt "0" and cei lt amt and amt neq "">
					     <td align="right" class="highlight5 cellcontent" style="padding-right:2px;border-right:1px solid silver;">
					<cfelse>
						 <td align="right" class="#class# cellcontent" style="padding-right:2px;border-right:1px solid silver;">
					</cfif>	
					
					<cfif Parameter.BudgetAmountMode eq "0">
						<cf_numbertoformat amount="#amt#" present="1" format="number0">
					<cfelse>
						<cf_numbertoformat amount="#amt#" present="1000" format="number1">
					</cfif> 	
					#val#
					
					</td>
		    						
				</cfloop>
											
				<td align="right" bgcolor="eaeaea" class="#class# cellcontent" style="padding-right:2px;border-right:1px solid Silver;">
				
				<cfif Parameter.BudgetAmountMode eq "0">
					<cf_numbertoformat amount="#total#" present="1" format="number0">
				<cfelse>
					<cf_numbertoformat amount="#total#" present="1000" format="number1">
				</cfif> 	
				#val#
								
			  </td>
		
		</TR>
		
</cfif>
 
<!--- ---- show components ---- ---> 
<!--- ---- Components --------- --->
<!--- ------------------------- --->

<cfif URL.Lay neq "Program" AND (lev eq "1" or lev eq "2")>
  
<cfif url.lay eq "HideNull" and total eq "">

  			<!--- hide --->

<cfelse>
  	 
			<cfif EntryMethod neq "">
			
			<tr bgcolor="CCFFCC" class="navigation_row line fixlengthlist" style="height:15px">
				
				<cfset ComClass = "regular">
			
			<cfelse>
			
			   <cfif ProgramScope eq "Unit">			   
    				<cfset ComClass = "Regular">					
			   <cfelse>			   
			    	<cfset ComClass = "Regular">						
			   </cfif>			
			   	   
			<tr bgcolor="FFFFFF" class="navigation_row line fixlengthlist" style="height:15px">
			   
			</cfif>			
						
			<td class="#ComClass#  fixlengthlist" 
				align="left" style="height:16;padding-left:20px;">
				
				<table width="100%" cellspacing="0" cellpadding="0">
				
				<tr><td style="height:16px;min-width:80">			
				<cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">&nbsp;<b>.&nbsp;</b></cfloop>			
				</td>
							
			    <td align="center" style="padding-top:4px;padding-left:6px;padding-right:7px;padding-right:14px">
								
				<cfif ProgramScope eq "Unit">
				  
			           <cfif BudgetAccess EQ "MANAGER"> 
						    <cfset menu = "FULL">
					   <cfelse>
							<cfset menu = "LIMITED">
					   </cfif>
							
				  <cfelse>					
				  
				       <cfset menu = "NONE">
						   		
				  </cfif>
				  
				  <cfif menu eq "NONE">
				  
				 	  <cfif BudgetAccess NEQ "NONE">						 
					 	 <cf_img icon="select" navigation="Yes" onClick="Allotment('#ProgramCode#','','#URL.Period#','budget','#URL.Version#','_blank','#url.systemfunctionid#')">																		 
					 <cfelse>						  
					     <cf_img icon="select" navigation="Yes" onClick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')"> 						   										  
					 </cfif>
				  
				  <!--- no menu --->
				  
				  <cfelse>					  
							  					  								  			
					<cfif EntryMethod eq "">   <!--- allotment NOT awaiting approval --->
																				  
						 <cfif BudgetAccess NEQ "NONE">						 
						 	 <cf_img icon="select" navigation="Yes" onClick="Allotment('#ProgramCode#','','#URL.Period#','budget','#URL.Version#','_blank','#url.systemfunctionid#')">																		 
						 <cfelse>						  
						     <cf_img icon="select" navigation="Yes" onClick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')"> 						   										  
						 </cfif>
						  
					 <cfelse>  <!--- allotment awaiting approval --->	
					 					 																	  
						  <CFIF BudgetAccess EQ "MANAGER"> 		 
						  
						  	<!---				  	
						    <cf_img icon="open" navigation="Yes" onClick="AllotmentInquiry('#ProgramCode#','','#URL.Period#','budget','#URL.Version#','#url.systemfunctionid#')">
							--->
							
						   <img src="#SESSION.root#/Images/due.png?id=1" name="img0_#currentrow#" 
							  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
							  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/due.png?id=1'"
							  style="cursor: pointer;" alt="Clearance" border="0" align="absmiddle" height="14" width="14"
							  onClick="AllotmentInquiry('#ProgramCode#','','#URL.Period#','budget','#URL.Version#','#url.systemfunctionid#')"> 
																	
						  	<cfelse>
							
							  <cf_img icon="select" navigation="Yes" onClick="ViewProgram('#ProgramCode#','#Period#','#ProgramClass#')">							 					 
								 
							</cfif>
									 
						  </cfif>
						  
					 </cfif>	
					 
					</td>
					</tr>
				</table> 
					
			</td>
			<td class="#ComClass# cellcontent">
			
			    <cfif Reference neq "">
				
					  <table cellspacing="0" cellpadding="0">
					  <tr class="labelmedium" style="height:20px">
					  <td style="padding-right:5px">#Reference#					  
					  <cfif currentrow lte "8"><cf_space spaces="25"></cfif></td>
					  <!---
					  <td style="padding-right:5px">#ReferenceBudget#</td>
					  --->
					  </tr>
					  </table>				 
				 			
				<cfelseif ReferenceBudget1 neq "">	
				
				  <table>
					  <tr class="labelit"  style="height:20px">
					  <td style="width:35px">#ReferenceBudget1#</td>
						<cfif ReferenceBudget2 neq "">
						<td style="width:35px;padding-left:1px">#ReferenceBudget2#</td>						
						</cfif>
						<cfif ReferenceBudget3 neq "">
						<td style="width:35px;padding-left:1px">#ReferenceBudget3#</td>
						</cfif>
						<cfif ReferenceBudget4 neq "">
						<td style="width:35px;padding-left:1px">#ReferenceBudget4#</td>						
						</cfif>
						<cfif ReferenceBudget5 neq "">
						<td style="width:35px;padding-left:1px">#ReferenceBudget5#</td>
						</cfif>
						<cfif ReferenceBudget6 neq "">
						<td style="width:35px;padding-left:1px">#ReferenceBudget6#</td>				
						</cfif>		
					   </tr>
				   </table>					  						
					  
				<cfelse>
				  #ProgramCode#				  
				</cfif>
			
			</td>
			
			<cfset pd = -24>
			<cfloop index="itm" list="#ProgramHierarchy#" delimiters=".">
			<cfset pd = pd+12>			
			</cfloop>	
									
			<td colspan="3" class="#ComClass# cellcontent" style="border-right:1px solid d4d4d4;padding-left:#pd#">#ProgramName#</td>		
									
			<cfloop index="item" from="1" to="#Resource.RecordCount#" step="1">
			    <td align="right" class="#ComClass# cellcontent" style="padding-right:2px;border:1px solid silver;">
							
					<cfset cei = Evaluate("Ceiling_" & Item)>
					<cfset amt = Evaluate("Resource_" & Item)>
				
					<cfif Parameter.BudgetAmountMode eq "0">
						<cf_numbertoformat amount="#amt#" present="1" format="number0">
					<cfelse>
						<cf_numbertoformat amount="#amt#" present="1000" format="number1">
					</cfif> 	
					#val#
									
			</td>
    		</cfloop>
			
			<td align="right" bgcolor="eaeaea"
			    class="#ComClass# cellcontent"
			    style="border:1px solid silver; padding-right:2px;">	
			
				<cfif Parameter.BudgetAmountMode eq "0">
					<cf_numbertoformat amount="#total#" present="1" format="number0">
				<cfelse>
					<cf_numbertoformat amount="#total#" present="1000" format="number1">
				</cfif> 	
				#val#
			     		
			</td>
			
		</tr>
			
 </cfif>			
					
 </cfif>
	
</cfoutput>   
