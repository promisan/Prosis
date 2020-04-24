
<table width="100%"       
	  style="padding-right:4px"
	  align="center">	
	  
	 <cfquery name="check" 
		datasource="AppsProgram"			
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Program
			WHERE ProgramAllotment = '9'						
   	 </cfquery>	

	 <cfquery name="qGetSupcode" 
		datasource="AppsProgram"			
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM   ProgramAllotment
		WHERE  ProgramCode = '#url.ProgramCode#' 
		AND    Period      = '#PlanPeriod#'					
	 </cfquery>
	 <cfset suppCostCode = qGetSupcode.supportObjectCode>
	 
	 <cfif check.recordcount eq "1">
	 
	 <tr><td class="labelmedium" align="center" style="font-weight:400;padding-left:5px;font-size:20px"><font color="FF0000">Budget preparation is not enabled for this program/component</td></tr>
	 
	 <cfelse>
	 	  
		  <cfoutput>	  
			
			  <tr>
			 
			  <td class="hide" id="moveresult"></td> 
			  <td></td>
			  
			  <cfloop index="Edition" list="#EditionList#" delimiters=",">	  
			  
			  	 <!--- 12/11/2017 ensure we have the editions populated with positions --->
				
				  	<cfinvoke component = "Service.Process.Program.Position"  
					   method           = "CreatePosition" 
					   EditionId        = "#edition#">	  
			  				   
				   <cfquery name="Edit" 
				   datasource="AppsProgram" 
				   username="#SESSION.login#" 
				   password="#SESSION.dbpw#">
					   SELECT     *
					   FROM       Ref_AllotmentEdition
					   WHERE      EditionId = '#Edition#'	   
				    </cfquery>
			  	  	
				    <cfset planperiod = evaluate("e#edition#planperiod")>	    
						  
			  		<!--- ----------------------------------------- --->
			    	<!--- determine the edition allotment mode---- --->
				    <!--- ---------------------------------------- --->
			  
				 	<!--- 20/1/2013 check if allotment is logically possible for example
						  a future period is only recorded its requirements to get a full picutre
						  but not used for actually allotting funds, but for example a PKO (related period(
						  period, has an execution period and the plan period of the selected
					--->   	
						  
				   <cfquery name="qAllotmentEnable" 
						datasource="AppsOrganization" 			
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   Ref_MissionPeriod
							WHERE  Mission           = '#edit.Mission#' 
							<cfif edit.Period neq "">				
							<!--- the period of the edition selected => execution period --->				
							AND    Period = '#edit.Period#'
							<cfelse>
							<!--- all execution periods to be covered by this edition, running budget, which is the CMP model --->
							AND    Period = '#url.Period#'
							</cfif>				
							AND    PlanningPeriod    = '#planperiod#'		
										
				  </cfquery>	
				 			  
				  <cfif qAllotmentEnable.recordcount eq "0">
				 			   	
						 <!--- disable allotment issuance --->	    
					   	 <cfparam name="e#edition#allotment" default="0">
					   
				  <cfelse>
				  			    
						 <!--- enable allotment issuance --->	
					     <cfparam name="e#edition#allotment" default="1">
					   
				  </cfif>			
				  			 			  	  
			      <!--- -------------------------------- --->
			  	  <!--- determine the access for editing --->
				  <!--- -------------------------------- --->		  
				  		 						  	
				  <cfif Edit.BudgetEntryMode eq "0">
				  		  		  		  	 	  	  
					   <!--- Hanno 2/1/2009 -------------------------------------------- --->
				       <!--- direct entry mode, check for all enditions if access exists --->
					   <!--- ----------------------------------------------------------- --->
					   
					   <!--- check by edition and define if allotment for this program is locked --->   	
					  
					   <cfquery name="qLock" 
						datasource="AppsProgram"			
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT TOP 1 *
							FROM   ProgramAllotment
							WHERE  ProgramCode = '#url.ProgramCode#' 
							AND    Period      = '#PlanPeriod#'
							AND    EditionId   = '#edition#'					
				   	   </cfquery>
					  		   				   
					   <cfif Edit.Status eq "3" or Edit.Status eq "9">			  
					  	 <cfset role = "'BudgetManager'">				 
					   <cfelse>			  
					  	 <cfset role = "'BudgetManager','BudgetOfficer'">	  				 
					   </cfif>	 
					   
					   <cfparam name="e#edition#support"    default="#qLock.supportObjectCode#">	
					   <cfparam name="e#edition#percentage" default="#qLock.supportPercentage#">		  
					 
					    <cfinvoke component="Service.Access"  
						  Method         = "budget"
						  ProgramCode    = "#URL.Program#"
						  Period         = "#PlanPeriod#"					
						  Role           = "#role#"
						  ReturnVariable = "BudgetAccess">				
										
						<cfif (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL") and qLock.LockEntry neq "1">										
			
						    <!--- enforce direct entry here --->
							<cfif Program.EnforceAllotmentRequest eq "1">					
							    <cfparam name="e#edition#mode" default="2">		
							<cfelse>					
				 		        <cfparam name="e#edition#mode" default="1">	
							</cfif>
									
						<cfelseif (BudgetAccess eq "READ" or BudgetAccess eq "EDIT" or BudgetAccess eq "ALL")>									    
						
						    <cfparam name="e#edition#mode" default="1">		
														
						<cfelse>			
						
						    <cfparam name="e#edition#mode" default="0">					
							
						</cfif>								
					  	  
				  <cfelse>	
				  
				  		  		  		  		  	   
					   <!--- check by edition and define if allotment is locked --->  	
						 			  
					   <cfquery name="qLock" 
							datasource="AppsProgram" 			
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT TOP 1 *
							FROM   ProgramAllotment
							WHERE  ProgramCode = '#url.ProgramCode#' 
							AND    Period      = '#PlanPeriod#'
							AND    EditionId   = '#edition#'					
					   </cfquery>
						  
					   <cfparam name="e#edition#support" default="#qLock.supportObjectCode#">
					   <cfparam name="e#edition#percentage" default="#qLock.supportPercentage#">		
					   	    					  
					   <cfif Edit.Status eq "3" or Edit.Status eq "9">
					   		  
					     <!--- ONLY BUDGET MANAGER HAS ACCESS IF EDITION = LOCKED --->
					  
					  	 <cfset role = "'BudgetManager'">
						 
					   <cfelse>
					   			  
					  	 <cfset role = "'BudgetManager','BudgetOfficer'">	  
						 
					   </cfif>	 
					   
					    <cfinvoke component="Service.Process.Program.ProgramAllotment"  <!--- get access levels based on top Program--->
						Method         = "RequirementStatus"
						ProgramCode    = "#URL.Program#"
						Period         = "#PlanPeriod#"	
						EditionId      = "#Edition#" 
						ReturnVariable = "RequirementLock">			
								 
					   <cfinvoke component="Service.Access"  
							Method         = "budget"
							ProgramCode    = "#URL.Program#"
							Period         = "#PlanPeriod#"	
							EditionId      = "#Edition#"  
							Role           = "#role#"
							ReturnVariable = "BudgetAccess">						
																	
					   <cfif (BudgetAccess eq "EDIT" or BudgetAccess eq "ALL") and RequirementLock eq "0">
						    <cfparam name="e#edition#mode" default="2">					  	
					   <cfelseif (BudgetAccess eq "READ" or BudgetAccess eq "EDIT" or BudgetAccess eq "ALL")>									    			   
						    <cfparam name="e#edition#mode" default="1">																			
					   <cfelse>
						    <cfparam name="e#edition#mode" default="0">					
					   </cfif>				 
							  
				  </cfif>	  
				   	  		 
				  <td></td>
				 		  
				  <td>
				  
				  <table cellpadding="0" width="100%" cellspacing="0" border="0">
				  	<tr>
					<td style="padding-left:3px;">
				  
				  <table width="100%" cellspacing="0" cellpadding="0">
				  
				    <tr>		
					  	  	
					<td height="25" width="100%" class="labelmedium" style="padding-left:3px">
				  		  	  
					  	<cf_tl id="Mode" var="1">
						<cfset vMode=lt_text>
				
					  	<cf_tl id="Requirement Entry" var="1">
						<cfset vRequirement=lt_text>
						
						<cf_tl id="Direct Entry" var="1">
						<cfset vDirect=lt_text>
						
						<cf_space spaces="40">
						
					    <cfif Edit.BudgetEntryMode eq '1'>
					    	<cfset md = "<b>#vMode#:</b> #Edit.Version# - #Edit.EntryMethod# | #vRequirement#">
						<cfelse>
							<cfset md = "<b>#vMode#:</b> #Edit.Version# - #Edit.EntryMethod# | #vDirect#">
						</cfif>
			
						<cf_UItooltip tooltip="#md#">
						   	<cfoutput><cfif Edit.Period eq "">#Edit.Description#<cfelse><font face="Verdana" size="2">#Edit.Description#</font></cfif></cfoutput>
						</cf_UItooltip>
					
					</td>		
									
					</tr>		
					
					<cfinvoke component="Service.Access"  
							Method         = "budget"
							ProgramCode    = "#URL.Program#"
							Period         = "#PlanPeriod#"					
							Role           = "'BudgetManager'"
						    ReturnVariable = "BudgetManagerAccess">							
						
					<cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">			
					
						<tr>	
						   
							<td class="clsNoPrint">
							
								<table cellspacing="0" cellpadding="0" class="formspacing">
								
									<tr>
									
									<td id="setting#edition#" width="20" align="center" style="padding-top:2px">
									
										 <button type="button" 				 
									 	  class="button10g" 
										  style="width:30px;height:20;border-radius:3px" 
										  onClick="allotdetailopen('#url.program#','#PlanPeriod#','#edition#','#url.mode#')"> 					
											 <img src="#SESSION.root#/images/setting.png" height="12" width="12" alt="Allotment Settings" border="0">												 		   
										</button>	   
									  		 
									</td>
								
									<td id="validate#edition#" width="20" align="center" style="padding-top:2px">
														
										 <button type="button" 				 
									 	  class="button10g" 
										  id="verify#edition#"
										  style="width:30px;height:20;border-radius:3px" 
										  onClick="ColdFusion.navigate('AllotmentVerify.cfm?mode=full&programcode=#url.programcode#&period=#PlanPeriod#&edition=#edition#','validate#edition#')"> 					
										   	  <img src="#SESSION.root#/images/validate.gif" align="absmiddle" style="cursor:pointer"
												   height="12" width="12" alt="Validate amounts" border="0">					
										</button>	   
									  		 
									</td>
									
									 <cfif evaluate("e#edition#allotment") eq "0">
									 					 
									 	<input type="hidden" id="exec_#edition#" value="hide">  
									 					 
									 <cfelse>
									 
									    <cfif url.execution eq "hide">
									 
										<td style="padding-top:2px">								
																								
										 <button type="button" 				 
									 	  class="button10g" 
										  style="width:30px;height:20;cursor:pointer" 
										  onClick="Prosis.busy('yes');ptoken.location('AllotmentInquiry.cfm?mode=#url.mode#&execution=show&program=#url.programcode#&period=#PlanPeriod#&editionid=#edition#')"> 					
										   	  <img src="#SESSION.root#/images/calculate.gif" height="12" width="12" alt="Show execution amounts" border="0">					
										</button>	 
										
										 <input type="hidden" id="exec_#edition#" value="hide">  
										
										</td>
										
										<cfelse>
										
										<td style="padding-top:2px">
																
										 <button type="button" 				 
									 	  class="button10g" 
										  style="width:30px;height:20;border-radius:3px" 
										  onClick="Prosis.busy('yes');ptoken.location('AllotmentInquiry.cfm?mode=#url.mode#&execution=hide&program=#url.programcode#&period=#PlanPeriod#&editionid=#edition#')"> 					
										   	  <img src="#SESSION.root#/images/condition.gif" align="absmiddle" style="cursor:pointer"
												   height="12" width="12" alt="Show execution amounts" border="0">					
										</button>	   
										
										<input type="hidden" id="exec_#edition#" value="show">  
										
										</td>
										
										
										</cfif>
									 
									 </cfif>
																						  
								    <td id="movebutton#edition#" class="hide" width="20" style="padding-top:2px">
													
									 <button type="button" 				 
									 	  class="button10g" 
										  style="width:30px;height:20" 
										  onClick="movedetailopen('#url.program#','#PlanPeriod#','#edition#')"> 
										  	  <img src="#SESSION.root#/images/move.gif" height="12" width="12" alt="Move selected requirements" border="0">					
									 </button>
										
								    </td>						
								  
								   <cfif Parameter.EnableDonor eq "0">
								   			   
								   <td style="padding-top:2px">
									
										 <!--- transfer only if clearance/allotment makes logically sense for this edition, as future
										 period will only be alloted for the basis of execution Ref_MissionPeriod --->
									
											<cfif evaluate("e#edition#allotment") eq "1">
															
											  <!--- transfer only enabled if there are ANY cleared amounts for the editions --->
											
											  <cfquery name="Check" 
											   datasource="AppsProgram" 
											   username="#SESSION.login#" 
											   password="#SESSION.dbpw#">
											   SELECT     TOP 1 *
											   FROM       ProgramAllotmentDetail
											   WHERE      EditionId = '#Edition#'	   
											   AND        Status = '1'
											  </cfquery>
											  
											  <cfif check.recordcount eq "0">
											  	
												  <cfset BudgetManagerAccess = "NONE">
												
											  <cfelse>  						
																				
												  <cfif (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL")>														          
												
													 <button type="button" 				 
													 	  class="button10g" 
														  style="width:22px;height:20" 
														  onClick="budgettransfer('#Edit.Mission#','#PlanPeriod#','#edition#','#url.program#')"> 
														  <img src="#SESSION.root#/images/transfer2.gif" height="13" width="13" alt="Transfer or Amendment alloted amounts" border="0">
													  </button>
													  
												  </cfif>	
												  			  
											  </cfif>  
											  
											 </cfif> 
																				  
									   </td>
									   
									    </cfif>				   
									   
									   </tr>
								   
								   </table>
							   
							   </td>
							
						</tr>	
					
					</cfif>
					
				  </table>
				  
				  </td>
					  
				  </tr>
				  </table>
			  </td>	  
			      
			  </cfloop>
			   
			  <cfif no gte "2">
			  <td class="labelmedium" align="center" valign="top" style="padding-top:6px;border-top:0px solid silver;border-right:0px solid silver;border-left: 1px solid Silver;">
			    	 <cf_tl id="Total">
			  </td>
			  </cfif>
			  
			</tr> 
			
			<tr>
			  <td rowspan="3" >  
			    	   
			  <cfif url.print eq "0">
			  
			     <table cellspacing="0" cellpadding="0" class="formspacing clsNoPrint">
				 
				 <tr>
				 	
					<td valign="top" style="padding:3px;">
				  		<div style="display:none;" id="printTitle"><cf_tl id="Budget Requirements and Costing"></div>
						
				  		<cf_tl id="Print" var="1">				
						<cf_button2
							type="print"
							mode="icon"
							title="#lt_text#"
							height="25px"
							width="35px"
							printTitle="##printTitle"
							printContent=".clsPrintContent, ##mainDivCostContent">
		
				  	</td> 
				 
				 	<td style="padding-left:3px">
					
					<cfinvoke component="Service.Access"  
							Method         = "budget"
							ProgramCode    = "#URL.Program#"
							Period         = "#PlanPeriod#"					
							Role           = "'BudgetManager'"
						    ReturnVariable = "BudgetManagerAccess">		
							      
			     <!--- show only if any of the editions have snapshot enabled --->
				 		   
					  <cfif (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL" or getAdministrator('*') eq 1)>	
					  	  
				 		<cf_tl id="Manage" var="1">
														
						<!--- enforces entry mode for the OEs --->
														
						 <input type    = "button"	
							value       = "#lt_text#" 			
							onClick     = "javascript:Allotment('#ProgramCode#','#URL.Fund#','#url.period#','entry','#URL.version#','_self','','#url.mode#')"					
							id          = "print"					
							class       =" button10g"
							style       = "width:100px;height:25;font-size:12px">    		  			
					  				   
					  </cfif>
				  	
				  
				  </td>
				
				  <td>	
				 
				   <cfif Parameter.EnableDonor eq "0">
				  			  	  
					  <cfif (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL")>		
					  
					     <input type="button"			 				
							value       = "Transfer" 			
							onClick     = "budgettransfer('#Edit.Mission#','#url.period#','#Edit.editionid#','#url.program#')"					
							id          = "transfer"	
							class       =" button10g"
							style       = "width:100px;height:25;font-size:12px">          		 
					  
					  </cfif>
					  
				  </cfif>	  
				  
				  </td>
				  		     	   
				  </tr>
				  
				  </table>		
				
			  </cfif>
			  	  
			  </td> 
			  
				 <cfloop index="Edition" list="#EditionList#" delimiters=",">
				  
				    <cfquery name="Edit" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT     *
						FROM       Ref_AllotmentEdition
						WHERE      EditionId = '#Edition#'	   
					</cfquery>
					
					<td style="border-left: 1px solid Silver;"></td>			
				    <td align="left" colspan="1" style="padding:1px;"></td>
				      
				</cfloop>
				
				<cfif no gte "2">  
				  <td align="center" valign="top" style="border-left: 1px solid Silver;"></td>
				</cfif>  
			</tr>  
			
			<tr>
			
			<!--- --------------------------------------------- --->
			<!--- ----------------- FUND header --------------- --->
			<!--- --------------------------------------------- --->
			   
			<cfloop index="Edition" list="#EditionList#" delimiters=",">
			  	
				<td style="border-left: 0px solid Silver;"></td>
				<td align="right" style="border-left: 0px dotted Silver;">
			
				   <table cellspacing="0" cellpadding="0" width="100%">
					   <tr>
					   
					   	  <cfparam name="list_#Edition#" default="">					  				 
					   		      
					   	  <cfset fundlist   = evaluate("list_#Edition#")>	
						  <cfset planPeriod = evaluate("e#edition#planperiod")>
						  				  				  		
						  <cfif find(",", fundlist)>			  
						    <cfset fundlist = "#fundlist#,Total">
						  </cfif>  
					   		   	 		   
						  <cfloop index="Fund" list="#fundlist#" delimiters=",">
						   	   
							   <cfif fund eq "total">
							     <cfset cl = "DBF0FB">					 
							   <cfelse>
							     <cfset cl = "ffffcf">
							   </cfif>
							   <td>
							   <cf_space spaces="1">
							   </td>
							   
							   <cfif find(Edition,exec)>
							   
							   	   <td align="center"
								       style="cursor: pointer;" 
									   class="labelit"
									   bgcolor="#cl#" 						  
									   onClick="execution('#fund#','#edition#')">
							     
								   <cfif Parameter.BudgetAmountMode eq "0">
								  	   <cf_space spaces="20">
								   <cfelse>
							           <cf_space spaces="16">
								   </cfif>	   
								  
								   <img src="#SESSION.root#/Images/icon_expand.gif" alt="" 
										id="d#edition##fund#Exp" id="d#fund#Exp" 
										border="0" 
										align="absmiddle"
										class="regular">
										 
								   <img src="#SESSION.root#/Images/icon_collapse.gif" 
										id="d#edition##fund#Min" alt="" border="0" 
										align="absmiddle"
										class="hide">			
										#fund#
																
									</td>
								  
							   <cfelse>
							   
							        <td align="center" class="labelit" bgcolor="#cl#" style="border: 0px dotted b1b1b1">
							         <cfif Parameter.BudgetAmountMode eq "0">
								  	   <cf_space spaces="20">
								  	 <cfelse>
							           <cf_space spaces="16">
									  </cfif>	   									
									#Fund#
									</td>
									
							   </cfif>
							   
							   <cfif find(Edition,exec)>
							  				  
								   <cfset client["execution#edition#_#fund#"] = "hide">				 				
								   <td name="Exec#edition##fund#" bgcolor="f4f4f4" style="border: 1px dotted b1b1b1" align="center" class="hide"><cf_space spaces="#spac#">Unliq.</td>
								   <td name="Exec#edition##fund#" bgcolor="f4f4f4" style="border: 1px dotted b1b1b1" align="center" class="hide"><cf_space spaces="#spac#">Disburs.</td>				  				  
							   
							   </cfif>
							   
						   </cfloop>	
					   </tr>
				   </table>	  
				 </td>
			   </cfloop>    
			   
			 <cfif no gte "2">
			    <td align="center" style="border-right:0px solid silver;border-left: 1px solid Silver;"></td>
			 </cfif>
			      
			</tr>  
			
			<tr>
		
				<td height="1" bgcolor="ffffff" colspan="2"></td>
				<cfloop index="Edition" list="#EditionList#" delimiters=",">
					<td height="1" bgcolor="ffffff" colspan="2"></td>
				</cfloop>
			
				<cfif no gte "2">
			   	<td align="center" style="border-right:0px solid silver;border-left: 1px solid Silver;"></td>
				</cfif>
			
			</tr>
			
			<tr>    
					
				<cfset submit = "0">
				
				<td class="noprint">
				
				<cfif BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL">	
					
					<cfif url.mode neq "fullview">
					
					    <table cellspacing="0" cellpadding="0" class="formpadding">
							<tr><td style="padding-left:20px">
							<input onclick="Prosis.busy('yes');viewallot('regular')" type="radio" class="radiol" name="filter" value="regular" <cfif url.view eq "regular">checked</cfif>>
							</td><td class="cellcontent" style="padding-left:3px"><cf_tl id="Full"></td>
							<td style="padding-left:10px">
							<input onclick="Prosis.busy('yes');viewallot('parent')" type="radio" class="radiol" name="filter" value="parent" <cfif url.view eq "parent">checked</cfif>>
							</td><td class="cellcontent" style="padding-left:3px"><cf_tl id="Only Parent"></td>
							<td style="padding-left:10px">
							<input onclick="Prosis.busy('yes');viewallot('hidenull')" type="radio" class="radiol" name="filter" value="hidenull" <cfif url.view eq "hidenull">checked</cfif>>
							</td><td class="cellcontent" style="padding-left:3px"><cf_tl id="Hide Zero"></td>
							</tr>		
						</table>
							
					</cfif>
					
				</cfif>	
				
				</td>	
						
				<cfloop index="Edition" list="#EditionList#" delimiters=",">
				
					<td style="border-left: 0px solid Silver;"></td>
					<td align="center" height="26" style="cursor:pointer;border-left: 0px solid Silver;" class="label clsNoPrint">	
					
					 <cfset planPeriod = evaluate("e#edition#planperiod")>
					
					 <cfif evaluate("e#edition#allotment") eq "0">
					 
					 	<!--- a clearance processing does not make sense in this case and is thus disabled --->
						
						<cf_UItooltip tooltip="Execution of this edition is set for a different plan period<br>and and will need to be carried over first to the designated plan period.">
						<font color="gray"><cf_tl id="Requirement only"></font>
						</cf_UItooltip>
					 
					 <cfelse>
					
						 <cfdiv id="box#edition#"
						        bind="url:#SESSION.root#/programrem/application/budget/allotment/AllotmentClear.cfm?programcode=#url.programcode#&period=#PlanPeriod#&editionid=#edition#"/>	
								
					 </cfif>		
				
					</td>
							
				</cfloop>
				
				<cfif no gte "2">
				<td height="28" colspan="1" align="center" style="border-right:0px solid silver;border-left: 1px solid Silver;"></td>
				</cfif>
				
			</tr>
			
			<tr><td height="1" colspan="#No*2+2#"></td></tr>	
			
			<cfquery name="SearchResult" 
			datasource="AppsQuery" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     #SESSION.acc#Allotment_#FileNo#
				ORDER BY CategoryOrder, HierarchyCode, Code 		   
			</cfquery>
			
			<!--- ------------------------ --->
			<!--- ----over-all totals----- --->
			<!--- ------------------------ --->
			 
			<tr class="line" bgcolor="e4e4e4" height="30">
			 
			  <td width="50%">
				  <table cellpadding="0" cellspacing="0" border="0"><tr><td>&nbsp;&nbsp;</td>
				  
				  <td width="335" class="labelmedium" height="27" style="font-weight:200;font-size:21px;padding-left:10px"><b>
				  
				  <cfif Program.ReferenceBudget1 neq "">
				  
				  				#Program.ReferenceBudget1#
				  				<cfif Program.ReferenceBudget2 neq "">
								-#Program.ReferenceBudget2#
								</cfif>
								<cfif Program.ReferenceBudget3 neq "">
								-#Program.ReferenceBudget3#
								</cfif>
								<cfif Program.ReferenceBudget4 neq "">
								-#Program.ReferenceBudget4#
								</cfif>
								<cfif Program.ReferenceBudget5 neq "">
								-#Program.ReferenceBudget5#
								</cfif>
								<cfif Program.ReferenceBudget6 neq "">
								-#Program.ReferenceBudget6#				
								</cfif>		
				  <cfelse>
				  <cfif Program.Reference neq "">
				  #Program.Reference#
				  <cfelse>
				  #Program.ProgramCode#
				  </cfif>
				  </cfif>
				  </td>
				  </tr>
				  </table>
			  </td>
			  
			  <cfloop index="Edition" list="#EditionList#" delimiters=",">
			    
				<td width="20" height="16"></td>     
				
					 <td>
					 			
						 <table border="0" cellspacing="0" cellpadding="0" width="100%"><tr>
					     <td align="right" style="padding-right:2px;border-left: 1px solid Silver;" id="#Edition#_cell">				 
						      <cfset par = 1>
							  <cfset scp = "">
							  <cfif find(Edition,exec)>
							     <cfset exe = 1> 
							  <cfelse>
							     <cfset exe = 0>
							  </cfif>
							  <cfinclude template="AllotmentInquiryCellSubTotal.cfm">					  
						 </td></tr>
						 </table>
					 </td>	     
							 
				</td>
				
			  </cfloop>
			   
			  <cfif no gte "2">
			   
			    <td align="right" class="labelit" style="padding-right:1px;border-left: 1px solid Silver;" bgcolor="#cltotal#" id="totalcell">	
					
					  <cfset par = 1>
									
					  <cfquery name="Subtotal" dbtype="query">
					      SELECT  sum(Total) as total
					      FROM    Searchresult							 	
					  </cfquery>
								  
					  <cfinclude template="AllotmentInquiryCellTotal.cfm">		
						 
				</td>
				
			  </cfif>	
			 
			</tr> 	
				
		</cfoutput>
			
	<cfoutput query="SearchResult" group="Category">
	 
	<!--- --------------------------------------- --->
	<!--- ----------------LINE FOR RESOURCE------ --->
	<!--- --------------------------------------- --->
	
	<cfset rcl = "dadada">
	
	<tr><td height="2"></td></tr>
	
	<tr>
	
	    <td rowspan="2" style="border-bottom: 1px dotted b0b0b0;">
			<table cellspacing="0" cellpadding="0">
			<tr>
				<td width="4"></td>
				<!--- background-image:url('#SESSION.root#/Images/gradient.jpg') --->
				<td height="25" width="350" style="font-size:20px;padding-left:12px;font-weight:210" class="labelmedium">#Category#</td>	
			</td>
			</tr>
			</table>
		</td>
		
	  	<cf_tl id="Ceiling" var="1">
		<cfset vCeiling=lt_text>
		
		<cf_tl id="Ceiling disabled" var="1">
		<cfset vDisabled=lt_text>	
			
		<cfloop index="Edition" list="#EditionList#" delimiters="',">
		
		    <cfset planPeriod = evaluate("e#edition#planperiod")>
				
			<cfinvoke component="Service.Access"  <!--- get access levels based on top Program--->
			  Method         = "budget"
	   		  ProgramCode    = "#URL.Program#"
			  Period         = "#planPeriod#"	
			  EditionId      = "#edition#"  
			  Role           = "'BudgetManager'"
			  ReturnVariable = "CeilingAccess">				
					
			<cfquery name="Check" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   Ref_ParameterMissionResource
				  WHERE  Mission      = '#URL.Mission#'						 
				  AND    Resource     = '#Resource#'  
			</cfquery>
			
			<cfif check.ceiling eq "0">
			
			<td colspan="2" align="right" style="padding-right:1px;"></td>
									
					<cfset ceilingamount = 0>
			
			<cfelse>
			   
			<td colspan="2" align="right" style="height:35;padding:2px;">
				
				 <table width="100%" cellspacing="0" cellpadding="0" bgcolor="e4e4e4" style="border:1px solid silver">
				 		    					
					 <tr class="labelit">
									 
						 <td  valign="top" style="padding-left:4px;cursor:pointer;font-size:12px;padding-top:2px;padding-right:2px">
						 <cf_UItooltip  tooltip="Cap the ability to define requirements for this resource to a certain amount only">#vCeiling#</cf_UItooltip>:</font>
						 </td>
							
						 <td align="right" height="18" class="labelit">
						 				 				 				 
								<cfquery name="Ceiling" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									  SELECT Amount 
									  FROM   ProgramAllotmentCeiling
									  WHERE  ProgramCode  = '#URL.ProgramCode#'
									  AND    Period       = '#PlanPeriod#'
									  AND    EditionId    = '#Edition#'
									  AND    Resource     = '#Resource#'  
								</cfquery>
								
								<cfset ceilingamount = ceiling.amount>
								
								<cfif fund eq "total"></cfif>
																									
							    <cfif Parameter.BudgetAmountMode eq "0">
									<cf_numbertoformat amount="#ceiling.amount#" present="1" format="number">
							    <cfelse>
									<cf_numbertoformat amount="#ceiling.amount#" present="1000" format="number1">
							    </cfif> 
										 
								 <cfif ceilingAccess eq "EDIT" or ceilingAccess eq "ALL">
								
									 <input type="text"
									    name="#edition#_ceiling" 								
										class="regularh"
										size="5" 
										value="#val#"
										onchange="ptoken.navigate('AllotmentEntryCeiling.cfm?programcode=#url.programcode#&period=#PlanPeriod#&editionid=#edition#&resource=#resource#&amount='+this.value,'moveresult')"
										style="border:0px solid silver;border-left:1px solid silver;text-align:right;background-color: white">
										
								 <cfelse>				 
								 		#val#				 		
								 </cfif>
								 
						  </td>
						  
						  <!--- no longer needed as we control it differently now
						  
						  <cf_tl id="Allot" var="1">
						  
						  <td class="labelsmall" valign="top" style="padding-left:4px;padding-top:2px;padding-right:2px">Allot:</font></td>
							
						  <td align="right" height="18" style="padding:2px" class="labelit">
						 				 				 				 
								<cfquery name="Ceiling" 
								datasource="AppsProgram" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									  SELECT Allotment
									  FROM   ProgramAllotmentCeiling
									  WHERE  ProgramCode  = '#URL.ProgramCode#'
									  AND    Period       = '#PlanPeriod#'
									  AND    EditionId    = '#Edition#'
									  AND    Resource     = '#Resource#'  
								</cfquery>
																																	
							    <cfif Parameter.BudgetAmountMode eq "0">
									<cf_numbertoformat amount="#ceiling.Allotment#" present="1" format="number">
							    <cfelse>
									<cf_numbertoformat amount="#ceiling.Allotment#" present="1000" format="number1">
							    </cfif> 
										 
								 <cfif ceilingAccess eq "EDIT" or ceilingAccess eq "ALL">
								
									 <input type="text"
									    name="#edition#_ceiling" 								
										class="regularh"
										size="5" 
										disabled
										value="#val#"
										onchange="ColdFusion.navigate('AllotmentEntryCeiling.cfm?programcode=#url.programcode#&period=#PlanPeriod#&editionid=#edition#&resource=#resource#&amount='+this.value,'moveresult')"
										style="text-align:right;background-color: F5F5DC">
										
								 <cfelse>				 
								 		#val#				 		
								 </cfif>
								 
						  </td>
						  
						  --->
						  
								 
					 </tr> 
					 
					 </table>
				 
				</td>	
									 
			</cfif>	 
				 
			<cfquery name="Total" dbtype="query">
				SELECT  sum(Edition_#Edition#_total) as amount
				FROM    Searchresult
				WHERE   Category = '#Category#'
			</cfquery>
			
			<!--- -------- --->
			<!--- coloring --->
			<!--- -------- --->
										
			<cfif CeilingAmount eq "">
			   <cfparam name="cl#resource#_#edition#" default="regular">				 				  
			<cfelseif Total.Amount gt CeilingAmount and CeilingAmount gt 0>	
			   <cfparam name="cl#resource#_#edition#" default="highlight5">							  
			<cfelse>
			   <cfparam name="cl#resource#_#edition#" default="regular">					
			</cfif>	
			
		</cfloop> 
		
		<cfif no gte "2"> 
		<td align="right" class="labelit" style="padding-right:1px;border-top: 0px solid d0d0d0;border-bottom: 0px solid b0b0b0;"></td>
		</cfif>
			
	</tr>	
	
	<!--- --------------------------------------- --->
	<!--- ------------2nd LINE FOR RESOURCE------ --->
	<!--- --------------------------------------- --->
								 
	<tr bgcolor="#rcl#">
	
			 <cfloop index="Edition" list="#EditionList#" delimiters="',">
			 
			 	<cfset planPeriod = evaluate("e#edition#planperiod")>
			 
			 	<td width="20"  bgcolor="white"></td>
							
				<td align="center" style="padding-right:1px;border-left: 1px dotted Silver;border-top: 1px dotted silver;border-bottom: 1px dotted Silver;" 
				    bgcolor="B0D3EE" class="#evaluate('cl#resource#_#edition#')#" id="b#edition#_#resource#"> 
					 
					 <table width="100%" cellspacing="0" cellpadding="0">
						 <tr>
					     <td align="right" id="#Edition#_#resource#_cell" style="padding-right:1px;" class="labelit">	
						 			 				 
						      <cfset par = 1>
							  <cfset scp = "Category">
							  <cfif find(Edition,exec)>
							     <cfset exe = 1> 
							  <cfelse>
							     <cfset exe = 0>
							  </cfif>							 			  
							  <cfinclude template="AllotmentInquiryCellSubTotal.cfm">	
							  					  
						 </td>
						 </tr>
					 </table>
				</td>	     
							
			</cfloop>
		     
			<cfif no gte "2"> 
			
			    <td align="right" 			 
				  style="padding-right:1px;border-right:1px solid silver;border-left: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;" 
				  bgcolor="#cltotals#" id="#Resource#_tot" class="labelit">
				  
			   		  <cfset par = 1>
						
					  <cfquery name="Subtotal" dbtype="query">
					      SELECT  sum(Total) as total
					      FROM    Searchresult	
						  WHERE   Category = '#Category#'	
					  </cfquery>
					  
					  <cfinclude template="AllotmentInquiryCellTotal.cfm">	
					
				</td>
			
			</cfif>
	  
	</tr> 
	 
	<cfoutput group="HierarchyCode">
	
		<cfoutput group="Code">
		
		    <!--- ----------------------------- --->
			<!--- CHECK IF THE CODE IS A PARENT --->
		    <!--- ----------------------------- --->
			
			<cfif isParent eq "0">
		
			   <cfif ParentCode eq "">
			   
				   <cfset c = "ffffff">
			   	
				   <!--- ------------------------------------------------ --->
				   <!--- 1. LINE FOR REGULAR CODE NO PARENT AND NO CHILD- --->
				   <!--- ------------------------------------------------ --->
				   <cfif code eq suppCostCode OR RequirementEnable eq "1" OR (RequirementEnable eq "2" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL"))>
			
						<TR class="line" bgcolor="#IIf(CurrentRow Mod 2, DE('#c#'), DE('#c#'))#" id="line#resource#">
								
							<td width="94%" style="border-bottom: 1px solid e5e5e5;" id="box#Code#" class="regular" style="cursor:pointer" onclick="objectinfo('#code#')">
								<table cellspacing="0" cellpadding="0">
									<tr>
									<td style="padding-left:23px"><cf_space spaces="10" class="cellcontent" padding="0" label="#CodeDisplay#"></td>
									<td><cf_space spaces="60" class="cellcontent" padding="0" label="#Description#"></td>
									</tr>					
								</table>
							</td>
							
							<cf_tl id="hidden" var="1">			 
							<cfset vNoRights = lt_text>
							
							<!--- ----------- ---> 
							<!--- cell totals --->
							<!--- ----------- ---> 
										
							<cfloop index="Edition" list="#EditionList#" delimiters="' ,">
							
								<td align="center" class="labelit" width="20" style="padding-top:2px;padding-left:3px;padding-right:3px;border-left: 1px dotted Silver;">	
									<cfset col = "ffffff">
									
									<cfset supp       = evaluate("e#edition#support")>
									<cfset perc       = evaluate("e#edition#percentage")>
									<cfset planPeriod = evaluate("e#edition#planperiod")>
									
									<cfif supp eq code and perc gt "0">
														
										<cf_UItooltip tooltip="Support account"><font color="808080">SA</font></cf_UItooltip>
										<cfset col = "ffffaf">
									
									<cfelse>
																								
										<cfif RequirementEnable eq "1" or (RequirementEnable eq "2" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL"))>
																							
											<cfif evaluate("e#edition#mode") eq "2">
											
												<div class="clsNoPrint">
													<cf_img icon="open" onclick="alldetinsert('#edition#_#code#','#edition#','#code#','','view','','#url.programcode#','#PlanPeriod#')"> 
												</div>
												<cfset col = "ffffff">
																	
											</cfif>		
										
										</cfif>
														
									</cfif>
																		
								</td>	
			
								<cfparam name="cl#resource#_#edition#" default="regular">					
								
								<td bgcolor="#col#" align="center" class="#evaluate('cl#resource#_#edition#')#" id="b#edition#_#resource#" style="padding-right:1px;border-left: 1px dotted Silver;border-bottom: 1px solid e5e5e5;">
									<table width="100%" cellspacing="0" cellpadding="0"><tr>
									<td align="right" id="#Edition#_#Code#_cell" class="labelit">				 
										<cfset par = 0>
										<cfif find(Edition,exec)>
											<cfset exe = 1> 
										<cfelse>
											<cfset exe = 0>
										</cfif>			
												
										<cfinclude template="AllotmentInquiryCellObject.cfm">							  
									</td></tr>
									</table>
								</td>
							
							</cfloop> 
							
							<!--- overall total --->
							
							<cfif no gte "2"> 
								<td class="labelit" align="right" style="padding-right:1px;border-right:1px solid silver;border-left: 1px solid Silver;border-bottom: 1px solid e5e5e5;" bgcolor="#cltotal#" id="#Code#_tot">			 
									<cfset par = 0>						 
									<cfinclude template="AllotmentInquiryCellTotal.cfm">			    	
								</td>
							</cfif>
							
						</tr>

					</cfif> 				 
			
			   <cfelse>
				   
			   	   <cfif url.view neq "Parent">
			     	   
			   	   <!--- -------------------------------------------- --->
				   <!--- -2.----------LINE FOR CHILD CODE ----------- --->
				   <!--- -------------------------------------------- --->	
			
				   <TR class="line" bgcolor="ffffff" id="line#resource#">
			   	   
				     <td id="box#Code#" class="regular" style="cursor:pointer" onclick="objectinfo('#code#')">
						 <table cellspacing="0" cellpadding="0">
							 <tr>
								 <td style="padding-left:40px"><cf_space spaces="10" class="cellcontent" padding="0" label="#CodeDisplay#"></td>
								 <td><cf_space spaces="60" class="cellcontent" padding="0" label="#Description#"></td>
							 </tr>					
						 </table>
					 </td>
					
					 <cfloop index="Edition" list="#EditionList#" delimiters="' ,">
					 
			   		    <cfset col = "ffffff">
						
					 	<td align="center" width="20" style="padding-top:2px;padding-left:3px;padding-right:3px;border-left: 1px solid Silver;">	
						
							<cfset supp       = evaluate("e#edition#support")>
							<cfset perc       = evaluate("e#edition#percentage")>
							<cfset planPeriod = evaluate("e#edition#planperiod")>
																	
							<cfif supp eq code and perc gt "0">
							
							     <cf_UItooltip tooltip="Support account"><font color="808080"> <cf_tl id="SA"></font></cf_UItooltip>
								 <cfset col = "ffffaf">
							   
							<cfelse>						
													
								  <cfif RequirementEnable eq "1" or (RequirementEnable eq "2" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL"))>							  
								 																
									<cfif evaluate("e#edition#mode") eq "2">
									<div class="clsNoPrint">
										<cf_img icon="open" onclick="alldetinsert('#edition#_#code#','#edition#','#code#','','view','','#url.programcode#','#PlanPeriod#')"> 
									</div>
									<cfset col = "ffffff">
															
									</cfif>		
								
								</cfif>
							
							</cfif>
											
						</td>	
					 			 	
						 <td  bgcolor="#col#" align="center" class="#evaluate('cl#resource#_#edition#')#" id="b#edition#_#resource#" style="padding-right:1px;border-left: 1px solid Silver;">
							 <table cellspacing="0" width="100%" cellpadding="0"><tr>
						     <td align="right" id="#Edition#_#Code#_cell">	
										
							     <cfset par = 0>
								 <cfif find(Edition,exec)>
								     <cfset exe = 1> 
								 <cfelse>
								     <cfset exe = 0>
								 </cfif>							  
								 <cfinclude template="AllotmentInquiryCellObject.cfm">							  
								 
							 </td></tr>
							 </table>
						 </td>
										 
					 </cfloop>	
					 
					  <cfif no gte "2"> 
					 
						  <td align="right" class="labelit" style="padding-right:1px;border-right:1px solid silver;border-left: 1px solid Silver;" bgcolor="ffffff" id="#Code#_tot">			  
						  	 <cfset par = 0>					 
							 <cfinclude template="AllotmentInquiryCellTotal.cfm">				     				
						  </td>
					  </cfif> 
				   </tr> 
				   
				    <tr id="box#Code#" class="hide">
						   <td></td>
						   <td></td>
					       <td colspan="1" id="box#Code#_detail"></td>
				     </tr>
				  		   
				   </cfif>
			
			   </cfif>   
		
		<cfelse>
		
			<!--- ------------------------------------- --->
			<!--- -3. ---LINE FOR PARENT CODE --------- --->
			<!--- ------------------------------------- --->	
			
			<cfif url.view eq "Parent">
				<cfset c = "ffffff">
			<cfelse>
				<cfset c = "f0f0f0">
			</cfif>
			
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('#c#'), DE('#c#'))#"  id="line#resource#" style="height:30px;border-bottom: 1px solid silver;">
			 	 	 
			   <td width="97%" id="box#Code#"  class="regular" style="cursor:pointer" onclick="objectinfo('#code#')">
						<table cellspacing="0" cellpadding="0" class="formpadding">
							 <tr>						
							 <td style="padding-left:20px"><cf_space spaces="10" class="cellcontent" padding="0" label="#CodeDisplay#"></td>
							 <td><cf_space spaces="65" class="cellcontent" padding="0" label="#Description#"></td>
							 </tr>					
						 </table>
				</td>	
			  	   
			    <cfloop index="Edition" list="#EditionList#" delimiters="' ,">
				
					  <cfset planPeriod = evaluate("e#edition#planperiod")> 	
				
					  <td align="center" width="20" style="padding-top:2px;padding-left:3px;padding-right:3px;border-left: 1px solid Silver;">	
					   
					        <cfif RequirementEnable eq "1" or (RequirementEnable eq "2" and (BudgetManagerAccess eq "EDIT" or BudgetManagerAccess eq "ALL"))>
													
							<cfif evaluate("e#edition#mode") eq "2">
							
								<div class="clsNoPrint">
									<cf_img icon="open" onclick="alldetinsert('#edition#_#code#','#edition#','#code#','','view','','#url.programcode#','#PlanPeriod#')"> 
								</div>
													
							</cfif>
							
							</cfif>
											
					 </td>	
			  	  		
					 <td align="center" class="#evaluate('cl#resource#_#edition#')#" id="b#edition#_#resource#" style="padding-right:1px;border-left: 1px solid Silver;border-bottom: 1px solid e5e5e5;">
						 <table cellspacing="0" cellpadding="0" width="100%"><tr>
						     <td align="right" id="#Edition#_#Code#_cell">				 
							     <cfset par = 1>
								 <cfif find(Edition,exec)>
								     <cfset exe = 1> 
								  <cfelse>
								     <cfset exe = 0>
								  </cfif>						 
								 <cfinclude template="AllotmentInquiryCellObject.cfm">							  
							 </td></tr>
						 </table>
					 </td>	   
					
			    </cfloop>
			   
			   <cfif no gte "2">
			   
				    <td align="right" class="labelit" style="padding-right:1px;border-right:1px solid silver;border-left: 1px solid Silver;border-bottom: 1px solid e5e5e5;" bgcolor="#cltotal#" id="#Code#_tot">
					
						 <cfset par = 1>
						 <cfinclude template="AllotmentInquiryCellTotal.cfm">				
						
				    </td>
					
			  </cfif> 
			  
			</tr> 
			
		</cfif>
		
		<!--- -------------------------------------- --->
		<!--- container for show transaction details --->
		<!--- -------------------------------------- --->
		
		<cfloop index="itm" list="#EditionList#" delimiters="' ,">
				
				<tr id="box_#Code#_#itm#" class="hide">	    
				  
					<td colspan="#itm+no+1#">			
					 <table width="95%" cellspacing="0" cellpadding="0" align="center">
					 	<tr><td id="detail_#Code#_#itm#"></td></tr>
					 </table>
					</td>	
				</tr>
						
				<tr id="add#Code#_#itm#" class="hide">	    
				  
					<td colspan="#itm+no+1#">
					 <table width="95%" cellspacing="0" cellpadding="0" align="center">
						<tr><td id="iadd#Code#_#itm#"></td></tr>
					 </table>
					</td>	
				</tr>
				
				<tr id="inv#Code#_#itm#" class="hide">	    
				    
					<td colspan="#itm+no+1#">
					 <table width="95%" cellspacing="0" cellpadding="0" align="center">
					 	<tr><td id="iinv#Code#_#itm#"></td></tr>
					 </table>
					</td>	
				</tr>
				
		</cfloop>
		
		</cfoutput>
	
	</cfoutput>
	
	</cfoutput>

</cfif>

	<cfparam name="itm" default="0">

</table>


