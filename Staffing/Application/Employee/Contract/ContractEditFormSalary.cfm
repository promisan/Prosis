
<cfoutput>
  											
	<tr id="editfield" name="editfield">		
	
	  	<TD style="padding-left:5px" class="labelmedium bcell">
		<cfif mode eq "edit" or last eq "1">
			<a href="javascript:selectscale('#url.id#','#contractsel.contractType#','#url.id1#')"><u><cf_tl id="Grade"> / <cf_tl id="Step"></font></a>:		
		<cfelse>
			<cf_tl id="Grade"> / <cf_tl id="Step">
		</cfif>
		</TD>
		    
			<cfif mode eq "view">
				<td class="labelmedium ccell" style="height:28px" bgcolor="#pclr#">#ContractSel.ContractLevel# / #ContractSel.ContractStep#</td>						
			</cfif>
			
			<cfif mode eq "edit" or last eq "1"> 
			
			   <td class="ccell" height="28" bgcolor="#color#" id="editfield" name="editfield" style="border-right:1px solid silver">	
			   
			   	  <table>
				  <tr><td>
			
			   		<input type="text" 
					    id="contractlevel"
						name="contractlevel"  
						value="#ContractSel.ContractLevel#" 
						size="10" 						
						class="regularxl"
						maxlength="20" 
						style="padding-left:6px;text-align:left;width:50;background-color:ffffff;border:0px;border-right:1px solid silver"
						readonly>
						
					</td>
					
					<td style="padding-left:3px" id="boxcontractstep">	
										
						<input type="text" 		
						    id="contractstep"				
							name="contractstep" 
							class="regularxl"
							value="#ContractSel.ContractStep#" 
							style="width:30;text-align:left;background-color:fffffff;border:0px;border-right:1px solid silver" 
							maxlength="4" 
							readonly>
						
					</td></tr></table>	
					
				</td>	
					
			  </cfif>		
				
		</tr>
							
		<tr id="editfield" name="editfield"><TD style="padding-left:15px" class="labelmedium bcell"><cf_tl id="Payroll Location">:</TD>
		   
			<cfif mode eq "view">
				<td class="labelmedium ccell" style="height:28px" bgcolor="#pclr#">
				
				#ContractSel.ServiceLocation#
				
				<cfquery name="loc" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT   *
				    FROM     Ref_PayrollLocation
					WHERE    LocationCode = '#ContractSel.ServiceLocation#'
				</cfquery>		
				
				#loc.description#
								
				</td>
			</cfif>
			<cfif mode eq "edit" or last eq "1"> 	
			
			   <td bgcolor="#color#" id="editfield" name="editfield" class="ccell"><table>
			   <tr>
			   <td height="28" style="padding-left:2px">
			   		   
				<input type="text" 
				    id="servicelocation" 
				   	name="servicelocation"
					class="regularxl"
					value="#ContractSel.ServiceLocation#" 
					size="3" 
					style="background-color:ffffff;border:0px"
					maxlength="4" 
					readonly>
					
					</td>
					
					<cfquery name="loc" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
					    FROM     Ref_PayrollLocation
						WHERE    LocationCode = '#ContractSel.ServiceLocation#'
					</cfquery>		
				
					<td style="padding-left:2px">
					
					<input type="text" 
					    id="servicelocationname" 
					   	name="servicelocationname"
						class="regularxl"
						value="#loc.description#" 
						size="40" 
						style="background-color:ffffff;border:0px"
						maxlength="4" 
						readonly>
					
					</td>
					</tr>
					</table>								
					
			  </td>	
			</cfif>						
		</tr>
		
		<tr id="editfield" name="editfield"><TD style="padding-left:15px;height:28px" class="labelmedium bcell"><cf_tl id="Schedule">:</TD>
		    
			<cfif mode eq "view">
				<td class="labelmedium ccell" bgcolor="#pclr#">
				
				<cfquery name="schedule" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
					    FROM     SalarySchedule
						WHERE    SalarySchedule = '#ContractSel.SalarySchedule#'
					</cfquery>		
				
					#Schedule.Description#
				
				</td>
			</cfif>
			<cfif mode eq "edit" or last eq "1"> 
				<td class="ccell" style="padding-left:7px" height="28" bgcolor="#color#" id="editfield" name="editfield">
				
					<cfquery name="schedule" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
					    FROM     SalarySchedule
						WHERE    SalarySchedule = '#ContractSel.SalarySchedule#'
					</cfquery>	
					
					<input type   = "text" 
					    id        = "salaryschedulename"					    
						name      = "salaryschedulename" 
						class     = "regularxl"
						style     = "border:0px"
						value     = "#Schedule.Description#" 
						size      = "40" 
						maxlength = "40"
						readonly>	
				
					<input type   = "hidden" 
					    id        = "salaryschedule"					    
						name      = "salaryschedule" 
						class     = "regularxl"
						style     = "border:0px"
						value     = "#ContractSel.SalarySchedule#" 
						size      = "20" 
						maxlength = "20"
						readonly>
						
				</td>
			</cfif>	
			
		</tr>
		
		
		<tr id="nextincrement" name="editfield">	
			<TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Step Increase">:</TD>
		    					
			<cfif mode eq "view">
			
				<td class="labelmedium ccell" bgcolor="#pclr#">
				<cfif ContractSel.StepIncreaseDate eq "">
			 		--
				<cfelse>
					#Dateformat(ContractSel.StepIncreaseDate, CLIENT.DateFormatShow)#					
				</cfif>
				</td>
			 
			 </cfif>
			
			 <cfif mode eq "edit" or last eq "1"> 
	
				  <td height="28" style="height:28px;padding-left:5px" class="labelmedium ccell" bgcolor="#color#" id="editfield" name="editfield">					  
							
				  <cfdiv id="increment">	
				  
				  		 <cfset url.eff = dateformat(ContractSel.StepIncreaseDate,client.dateformatshow)>			
						 <cfset url.lastcontractid = ContractSel.ContractId>				  
						 <cfinclude template="ContractEditFormIncrement.cfm">
							 
				  </cfdiv>
				 
				  </td>	
					
			</cfif>	
			
		</tr>
			
		<cfquery name="Schedule" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
	    	FROM   SalarySchedule
			WHERE  SalarySchedule = '#ContractSel.SalarySchedule#' 
		</cfquery>		
		
		<cfif mode eq "view">
														
			<cfif ContractSel.ContractSalaryAmount neq "0" and last eq "1">
						
				<!--- manual salary : ajax ensure the currency is based on the Payroll schedule --->
				<tr id="editfield" name="editfield">
				   <td style="padding-left:5px" class="labelmedium bcell"><cf_tl id="Negotiated Salary">:</TD>	    		
				   <td class="labelmedium ccell" bgcolor="#pclr#">#Schedule.PaymentCurrency# #ContractSel.ContractSalaryAmount#</td>		
				   
				   <cfif last eq "1">  
			  
				    <td class="ccell" height="28" bgcolor="#color#" id="editfield" name="editfield">
					<table><tr><td style="padding-right:4px;border-right:1px solid silver;padding-left:1px">	
				   	<input type="text" class="regularxlbl" size="2" maxlength="4" value="#Schedule.PaymentCurrency#" id="currency" name="currency"> 		   
					</td>
					<td style="padding-left:4px;padding-right:4px;border-right:1px solid silver">
					<cfinput type="Text" class="regularxlbl" style="text-align:right" id="ContractSalaryAmount" name="ContractSalaryAmount" value="#ContractSel.ContractSalaryAmount#" message="Please enter a valid number" validate="float" required="No" size="10" maxlength="10">
					</td></tr></table>
					</td>				
				
			 	   </cfif>
				   			   		 
				</tr> 
			
			</cfif>
		
		<cfelseif mode eq "edit">	
		
			<cfif ContractSel.ContractSalaryAmount neq "0" and last eq "1">
						
			<!--- manual salary : ajax ensure the currency is based on the Payroll schedule --->
			<tr id="editfield" name="editfield">
			<td style="padding-left:5px" class="labelmedium bcell"><cf_tl id="Negotiated Salary">:</TD>
		   					  
			    <td class="ccell" height="28" bgcolor="#color#" id="editfield" name="editfield">
				<table><tr><td style="padding-right:4px;border-right:1px solid silver;padding-left:1px">	
			   	<input type="text" class="regularxlbl" size="2" maxlength="4" value="#Schedule.PaymentCurrency#" id="currency" name="currency"> 		   
				</td>
				<td style="padding-left:4px;padding-right:4px;border-right:1px solid silver">
				<cfinput type="Text" class="regularxlbl" style="text-align:right" id="ContractSalaryAmount" name="ContractSalaryAmount" value="#ContractSel.ContractSalaryAmount#" message="Please enter a valid number" validate="float" required="No" size="10" maxlength="10">
				</td></tr></table>
				</td>
							 	 		
			</tr>
			
			</cfif>
		
		</cfif>
			
</cfoutput>	