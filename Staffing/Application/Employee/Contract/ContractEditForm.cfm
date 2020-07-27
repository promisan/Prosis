
<!--- 
The are 3 scenario's
1. url.action = 1 : show only as view and no button allowed
2. if url.action = 0 and actionstatus = 0 : allow for edit and/or delete
3. if url.action = 0 AND actionstatus = 1 AND it is the last record THEN allow for delete or allow for new record
otherwise no action
--->

<cf_calendarScript>
<cf_dialogPosition>

<cfoutput>

<cf_tl id="Do you want to completely remove this contract leg" var="1">

<script>
	
	function verify(myvalue) { 
	
		try {
		
			if (myvalue == "") { 
		
				alert("You did not define a salary scale")
				document.getElementById('salaryselect').click()				
				return false
				}		
				
		} catch(e) {}
		
		}
		
	function applyscale(scaleno,grd,lvl,cur,contractid) {	   
	    ptoken.navigate('#session.root#/Staffing/Application/Employee/Contract/setScale.cfm?scaleno='+scaleno+'&grade='+grd+'&step='+lvl+'&currency='+cur+'&personno=#url.id#&contractid='+contractid+'&contracttype=','process')	  
	}	
	
	function ask() {
		if (confirm("#lt_text# ?")) {	
		Prosis.busy('yes')
		return true 	
		}	
		return false	
	}	 
		
</script>

<cfparam name="url.wf"     default="0">  <!--- variable to achive the creation in the workflow, is passed by vactrack/application/workflow/contract/document.cfm --->
<cfparam name="url.action" default="0">  <!--- opened from the PA module --->
<cfparam name="url.mycl"   default="0">  <!--- if the screen is opened from the workflow my cleanrances inbox --->

<cfif url.wf eq "1" or url.action eq "1">
 	<table width="98%" ccellspacing="0" ccellpadding="0" align="center">	
	<tr class="hide"><td id="process"></td></tr>
</cfif>

<cfquery name="ContractSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonContract
	WHERE  PersonNo   = '#URL.ID#'
	AND    ContractId = '#URL.ID1#' 
</cfquery>

<cfset client.contractreason = ContractSel.GroupListCode>

<input type="hidden" name="PersonNo"        value="#URL.ID#">
<input type="hidden" name="ContractCurrent" value="#URL.ID1#">	

<cfif ContractSel.actionStatus eq "1">
  
      <!--- if prior action is locked make sure you assign a new contract id --->		  
      <cf_assignId>	 
      <input type="hidden" id="contractid" name="ContractId" value="#rowguid#">	 
		  
<cfelse>
		  
      <cfset rowguid = url.id1>	 	  
  	  <input type="hidden" id="contractid" name="ContractId" value="#URL.ID1#">	  	   
  
</cfif>	
   
	<!--- check if this is last --->
	
	<cfquery name="ContractFirst" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
	    FROM     PersonContract
		WHERE    PersonNo      = '#URL.ID#'
		AND      Mission       = '#ContractSel.mission#' 
		AND      ActionStatus IN ('0','1')
		AND      ContractId   != '#rowguid#'	
		AND      HistoricContract = 0
		ORDER BY DateEffective 
	</cfquery>		
	
	<cfquery name="ContractLast" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
	    FROM     PersonContract
		WHERE    PersonNo      = '#URL.ID#'
		AND      Mission       = '#ContractSel.mission#' 
		AND      ActionStatus IN ('0','1')
		AND      ContractId   != '#rowguid#'	
		ORDER BY DateEffective DESC, Created DESC
	</cfquery>		
		
    <!--- check for active workflow --->  
    <cf_wfActive entitycode="PersonContract" objectkeyvalue4="#url.id1#">	

	<!--- this is no longer relevant has been reworked
	
	<cfif wfstatus eq "open">
		<!--- Checking if there is an open workflow for an entityCode different than PersonContract --->
	    <cf_wfActive entitycode="VacCandidate" objectkeyId="#url.id1#">	
	</cfif>	
	
	--->
		
	<!--- determine of the amendment column will be shown but only for the last contract --->
	
	<cfif ContractLast.contractid eq ContractSel.contractid <!--- last contract only to be amended --->
	    and ContractSel.actionStatus eq "1" <!--- contract is cleared --->
	    and url.action neq "1"     <!--- show only amendment if not opened from PA --->
		and url.mycl eq "0"        <!--- show only if amendment if NOT opened from the my clearances --->
		and wfstatus eq "closed">  <!--- show only if the workflow for the last action is completed --->
				
	    <cfset last = "1">
				
	<cfelse>
	
	    <cfset last = "0"> 
			 
	</cfif>		
		
	<cfset mdte = "edit">	   
		   
		   		  		
	<cfif ContractSel.actionStatus eq "1" <!--- contract is cleared, can not change anymore --->
	      or url.action eq "1" <!--- if opened from PA module, do not allow editing --->
		  or url.mycl eq "1"> <!--- if opened from Myclearances, do not allow editing --->
		 						
		  <cfset mode = "view">	
		  
		  <!--- only in the backoffice we allow to edit mode in some cases --->
		  
		   <cfinvoke component  = "Service.Access"  
		   method            = "RoleAccess" 		  
		   function          = "HRAdmin"	   
		   anyunit           = "Yes"	   
		   returnvariable    = "accessscope">	
		 
		  <cfif (getAdministrator("#contractSel.mission#") or accessscope eq "GRANTED")
		       and ContractSel.historicContract eq "0" 
			   and last eq "0" 
			   and url.action neq "1" 
			   and url.mycl neq "1">		  
			   
		  	  <cfset mode = "edit">		
			  <!--- islodated scope --->			  
			  <cfset mdte = "view">
			  
		  </cfif>
		   
	<cfelse>
	
		<cfset mode = "edit">	
		<!---	
		<cfif (getAdministrator("#contractSel.mission#") or accessscope eq "GRANTED")
		       and ContractSel.historicContract eq "0">		  			   
			   
			   
				<cfif ContractLast.contractid neq ContractSel.contractid>
				  			  			   
				  	  <cfset mode = "edit">		
					  <!--- islodated scope --->			  
					  <cfset mdte = "view">
				  
			    <cfelse>			 	 
				--->
							 		 
				     <cfset mode = "edit">	
				 
				<!--- 		  
			    </cfif>
				
		  
		 </cfif>
		 --->
			  
	</cfif>  
			
	<!--- added to support a simple edit option --->
	<input type="hidden" id="Scoped" name="Scoped" value="#mdte#">	
	
	<input type="hidden" id="last" name="last" value="#last#">
	<input type="hidden" id="mode" name="mode" value="#mode#">	  
		      
    <tr>
    <td style="<cfif url.action neq "1">padding-left:50px</cfif>">
		
	<cfset color = "ffffff">
	<cfset pclr  = "f1f1f1">
	
	<cfif mode eq "view">
	
	<table style="width:98%" border="0" cellspacing="0" cellpadding="0">	
	
	<cfelse>
	
    <table style="width:800px" border="0" cellspacing="0" cellpadding="0">	
	
	</cfif>
	
	<cfif url.action eq "0">
			
		<tr><td colspan="3" class="labelmedium" style="font-weight:200;border-bottom:1px solid silver;padding-left:4px;height:40;font-size:23px"><cf_tl id="Amend Contract/Appointment"></td></tr>
	
	</cfif>
		
	<cfif mdte eq "view">
	
		<tr><td colspan="3" align="center" bgcolor="ffffcf" class="labelmedium" style="font-weight:200;font-size:16px;height:30px;border:1px solid silver"><cf_tl id="Retroactive edit mode"></td></tr>
	
	</cfif>
			
	<cfif ContractSel.recordcount eq "0" and url.wf eq "0">
		
		<tr><td colspan="3"  align="center" class="labelmedium"><font color="FF8000">Problem, record does no longer exist in the database</td></tr>
		
		<cfquery name="Reset" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE    OrganizationObject
			SET       Operational = 0
			WHERE     ObjectKeyValue4 = '#URL.ID1#'
		</cfquery>		
		
		<cfabort>
		
	</cfif>
		
	<cfif ContractSel.actionStatus eq "9" or ContractSel.actionStatus eq "8">
		
		<tr bgcolor="FFFF00"><td style="border:1px solid silver" class="labelmedium" colspan="3" align="center">Attention, the effective period of this record has been superseded by a later entry.</font></td></tr>
			
	</cfif>	
	
	<!--- we support a complete removal : purge of the action and the record  --->
					
	<cfif ContractSel.actionStatus eq "0" and url.action eq "1" and getAdministrator("#contractSel.mission#") eq "1">
	
		<tr>
		
			<td colspan="3" align="left">
						
				<cf_tl id="Purge" var="1">
				<cfoutput>
					<input class="button10g"  style="width:110" type="submit" name="Delete" onClick="return ask()" value="<cfoutput>#lt_text#</cfoutput>">
				</cfoutput>
						
			</td>
		
		</tr>
		
	</cfif>	
	
	<cfquery name="EmployeeAction" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      EmployeeAction
			WHERE     ActionSourceId = '#ContractSel.ContractId#'		
	</cfquery>
	 	  		
	   <TR>
			
	    <TD style="padding-left:5px;min-width:330" class="labelmedium bcell"><cf_tl id="ContractNo">:</TD>
	    
			<cfif mode eq "view">
				  <TD class="labelmedium ccell" style="padding-left:5px;height:28px" width="40%" bgcolor="#pclr#">
				  <cfif ContractSel.PersonnelActionNo eq "">
				  	<cfif EmployeeAction.recordcount eq "1">#EmployeeAction.ActionDocumentNo#</cfif>
				  <cfelse>
				  #ContractSel.PersonnelActionNo# <cfif EmployeeAction.recordcount eq "1">/ #EmployeeAction.ActionDocumentNo#</cfif>
				  </cfif>
				  </td>
			</cfif>	 
			
			<cfif mode eq "edit" or last eq "1"> 
				
				<td class="labelmedium ccell" style="height:28px;padding-left:11px" bgcolor="#color#">
						
				<cfquery name="Parameter" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      Ref_ParameterMission
						WHERE     Mission = '#ContractSel.Mission#'		
					</cfquery>
					
										
				<cfif Parameter.PersonActionEnable eq "0" or 
				      Parameter.PersonActionNo     eq "" or 
					  Parameter.PersonActionPrefix eq "">
					 
					 	
					  <input type="text" 
					       name="PersonnelActionNo" 
						   value="#ContractSel.PersonnelActionNo#" 
						   class="regularxlbl" 
						   size="10"
						   style="border-right:1px solid silver" 
						   maxlength="20">
		
				<cfelse>
				
					<cfquery name="EmployeeAction" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      EmployeeAction
							WHERE     ActionSourceId = '#ContractSel.ContractId#'		
					</cfquery>
					
				      #ContractSel.PersonnelActionNo# <cfif EmployeeAction.recordcount eq "1">/ #EmployeeAction.ActionDocumentNo#</cfif>
				      <input type="hidden" name="PersonnelActionNo" value="#ContractSel.PersonnelActionNo#">
				
				</cfif>	
				
				</td>
				  
			</cfif>  
					
		</TR>
						
		<tr>
		<TD style="min-width:240px;padding-left:5px;border-right:1px solid silver;height:28px;" class="labelmedium bcell"><cf_tl id="Personnel Action">:</TD>
					
			<cfquery name="pAction" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_Action
				WHERE  ActionCode    = '#ContractSel.ActionCode#' 								
			</cfquery>
								
			<cfif mode eq "view">
			
				<cfquery name="getAction" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   EmployeeAction
						WHERE  ActionPersonNo   = '#ContractSel.PersonNo#'
						AND    ActionSourceId   = '#ContractSel.ContractId#' 								
					</cfquery>
						
				  <TD class="labelmedium ccell" style="height:28px;min-width:220px;border-bottom:1px solid silver" bgcolor="#pclr#">#pAction.Description#	 
				  <cfif getAction.ActionDate neq "">
				  <font size="1">#dateformat(getAction.ActionDate,CLIENT.DateFormatShow)#</font>
				  </cfif>
				  
				  <cfset selact =  pAction.actionCode>
				  
				  </td>
				  
			</cfif>	 
			
			<cfset fst = Dateformat(ContractFirst.DateEffective, "YYYYMMDD")>
			<cfset lst = Dateformat(ContractLast.DateEffective, "YYYYMMDD")>
									
			<script>
			
			 function actionprocess(val,id) {			
    
			 	 se = document.getElementsByName('editfield')
			     cnt = 0
			     if (val == '3002')  {
			   		while (se[cnt]) { se[cnt].className = 'hide'; cnt++ }					
				 } else {
				 
				 	if (val == '3006')  {
			   		while (se[cnt]) { se[cnt].className = 'hide'; cnt++ }	
					document.getElementById('finalpayfield').className   = 'ccell'		
					document.getElementById('effectivefield').className  = 'ccell'	
					document.getElementById('expirationfield').className = 'ccell'	
								
				    } else {
				    while (se[cnt]) { se[cnt].className = 'ccell'; cnt++  }
				 	}	
				 }	
								 
				 _cf_loadingtexthtml='';				 	
				 ptoken.navigate('ProcessAction.cfm?contractid='+id+'&actioncode='+val+'&first=#fst#&last=#lst#','DateExpiration_trigger')		 		  
			  			 
			 }
			 
			</script>		
						
				
			<cfif mode eq "edit" or last eq "1"> 										
																					
				    <cfif url.wf eq "1">
															
						<td style="height:28px;padding-left:7px" class="labelmedium ccell" bgcolor="#color#">
									
						<cfquery name="ActionSel" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM  Ref_Action
							WHERE ActionSource = 'Contract'	
							AND   CustomForm = 'Insert'
							AND   (Operational = 1 OR ActionCode = '#ContractSel.ActionCode#')
						</cfquery>
																						
						<select name="ActionCode" class="regularxlbl">					    
							<cfloop query="ActionSel">
								<option value="#ActionCode#" <cfif ContractSel.ActionCode eq ActionCode>selected</cfif>>#Description#</option>
							</cfloop>		
						</select>										
				
					<cfelseif mode eq "edit">
															
					    <td style="padding-left:6px" class="labelmedium ccell" bgcolor="#color#">
										
						<cfif ContractSel.ActionCode neq "">
											
							<cfquery name="pAction" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM  Ref_Action
								WHERE ActionSource = 'Contract'	
								 AND  ActionCode  = '#ContractSel.ActionCode#'		
								 ORDER BY ListingOrder				 
							</cfquery>							
							
						<cfelse>
												
							<cfquery name="pAction" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM  Ref_Action
								WHERE ActionSource = 'Contract'	
								 AND  ActionCode  = '3000'						 
							</cfquery>
						
						</cfif>	
																													  						  						  
						 <cfset selact = pAction.actionCode>
						 
						 <cfquery name="pAction" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Ref_Action
							WHERE  ActionSource = 'Contract'		
							AND    EntityClass  = '#pAction.EntityClass#'
							AND    Operational = 1 
							AND    (CustomForm != 'Insert' OR CustomForm is NULL OR ActionCode = '#ContractSel.ActionCode#') 
							
							<cfif getAdministrator(ContractSel.Mission) eq "1">							
								<!--- no filtering --->
						    <cfelse>									
								AND    ActionCode != '3002'
							</cfif>
							
							   <!--- OR ActionCode  = '#ContractSel.ActionCode#'  --->
							ORDER BY ListingOrder		
						</cfquery>	
						
						<cfif mdte eq "view">
						
							#pAction.Description#				
							<input type="hidden" name="actioncode" value="#pAction.actionCode#">
						
						<cfelse>
											  
							<select name="actioncode" class="regularxlbl" style="width:99%"							
							onchange="actionprocess(this.value,'#contractsel.contractid#')">
							    <!--- <option value="">-- select action --</option> --->
								<cfloop query="pAction">
									<option value="#ActionCode#" <cfif ContractSel.ActionCode eq ActionCode>selected</cfif>>#Description#</option>
								</cfloop>		
							</select>	
							
						</cfif>		
											
					<cfelse>
										
						<td style="height:28px;padding-left:7px" class="labelmedium ccell" bgcolor="#color#">
																					
						<cfquery name="pAction" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Ref_Action
							WHERE  ActionSource = 'Contract'		
							
							AND    (Operational = 1 AND (CustomForm != 'Insert' or CustomForm is NULL or ActionCode = '#ContractSel.ActionCode#')) 
							
							<cfif getAdministrator(ContractSel.Mission) eq "1">							
								<!--- no filtering --->
						    <cfelse>									
								AND    ActionCode != '3002'
							</cfif>
							   <!--- OR ActionCode  = '#ContractSel.ActionCode#'  --->
							ORDER BY ListingOrder		
						</cfquery>	
												
						<cfif last eq "0">		
												
							<cfset selact = ContractSel.ActionCode>
							<select name="actioncode" class="regularxlbl" style="width:99%"							
							onchange="actionprocess(this.value,'#contractsel.contractid#')">
							    <!--- <option value="">-- select action --</option> --->
								<cfloop query="pAction">
									<option value="#ActionCode#" <cfif ContractSel.ActionCode eq ActionCode>selected</cfif>>#Description#</option>
								</cfloop>		
							</select>		
						
						<cfelse>
												
							<cfset selact = pAction.ActionCode>
							<select name="actioncode" class="regularxlbl" style="width:99%"	onchange="actionprocess(this.value,'#contractsel.contractid#')">
							   <!--- <option value="">-- select action --</option> --->
								<cfloop query="pAction">
									<option value="#ActionCode#">#Description#</option>
								</cfloop>		
							</select>		
						
						</cfif>
										
					</cfif>
				
				</td>	
								  
			</cfif>  
				
		</tr>		
							 
	    <tr>
		 
		    <td style="min-width:240px;height:28px;padding-left:5px;border-right:1px solid silver" class="labelmedium bcell"><cf_tl id="Reason">:</TD>
		   
		   	<cfif mode eq "view">
			
			    <td bgcolor="#pclr#" class="labelmedium ccell"> 	
																
					<cfquery name="GroupList" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Ref_PersonGroupList
						WHERE  GroupCode     = '#ContractSel.GroupCode#'
						AND    GroupListCode = '#ContractSel.GroupListCode#' 
					</cfquery>				
					
					<cfif GroupList.description neq "">
						<cf_tl id="#GroupList.Description#">
					<cfelse>
						<cf_tl id="not applicable">
					</cfif>				
							
				</td>	
								
			</cfif>			
						
			<cfif mode eq "edit" or last eq "1">
						
				<td bgcolor="#color#" id="groupfield" name="groupfield" 
				 style="padding-left:6px;border-right:1px solid silver;border-bottom:1px solid silver"
				 class="labelmedium ccell">				 
				 
				 </td>
				
			</cfif>	
				
		</tr>			
												  	
		<cfif ContractSel.enforcefinalPay eq "1">		
		    <cfset cl = "regular">			 
		<cfelse>		
			<cfset cl = "hide">			
		</cfif>		 
			 
	    <tr id="finalpay" class="#cl#">
		 
		    <td style="padding-left:5px" class="labelmedium bcell"><cf_tl id="Final Payment"> 	<cf_tl id="at expiration"></TD>
		   
		   	<cfif mode eq "view">
			    <td bgcolor="#pclr#" class="labelmedium ccell"> 					
					<cfif ContractSel.EnforceFinalPay eq "1"><cf_tl id="Enforce"><cfelse><cf_tl id="No"></cfif>					
				</td>					
			</cfif>	
			
			<cfif mode eq "edit" or last eq "1">
			
				<td bgcolor="#color#" id="finalpayfield" name="editfield" class="labelmedium ccell">	
				   <table>
				   <tr class="labelmedium">
				   <td style="padding-left:2px"><INPUT type="radio" id="finalpayno" name="EnforceFinalPay" value="0" <cfif ContractSel.EnforceFinalPay eq "0" or ContractSel.EnforceFinalPay eq "">checked</cfif>></td>
				   <td style="padding-left:4px"><cf_tl id="No"></td>
				   <td style="padding-left:8px"><INPUT type="radio" id="finalpayyes" name="EnforceFinalPay" value="1" <cfif ContractSel.EnforceFinalPay eq "1">checked</cfif>></td>
				   <td style="padding-left:4px"><cf_tl id="Yes"></td>
				   </tr>
				   </table>				
				</td>
				
			</cfif>	
				
		</tr>	
		
		<cfif ContractSel.actionCode eq "3001">
		
		    <cfset cl = "regular">
			 
		<cfelse>
		
			<cfset cl = "hide">
			
		</cfif>		 		
		
		<TR ID="recorddate" class="#cl#" style="display:none">
		
		    <TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Amendment Effective">:<cf_space spaces="60"></TD>
										
				<cfif mode eq "view">
					<cfif mode eq "edit" or last eq "1">
						<td class="labelmedium ccell" bgcolor="#pclr#"><cf_space spaces="60">
					<cfelse>
					    <td class="labelmedium ccell" bgcolor="#pclr#"><cf_space spaces="60">
					</cfif>
					#Dateformat(ContractSel.RecordEffective, CLIENT.DateFormatShow)#<cf_space spaces="60"></td> 
				</cfif>	 
				
				<cfif mode eq "edit" or last eq "1"> 
				
					<td class="labelmedium ccell" style="padding-left:7px" width="100%" bgcolor="#color#">
					
					 <cf_intelliCalendarDate9
						FieldName="RecordEffective"
						ToolTip="Record Effective Date" 	
						Manual="True"		
						Class="regularxlbl"												
						Default="#Dateformat(ContractSel.RecordEffective, CLIENT.DateFormatShow)#"													
						AllowBlank="True">	
					
					<cf_space spaces="80">
					
					</td>				
					
				</cfif>						
						
		</tr>	
		
	
		<TR>
		    <TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Entity">:<cf_space spaces="60"></TD>
			
			<cfif contractsel.mission neq "">
							
				<cfif mode eq "view">
					<cfif mode eq "edit" or last eq "1">
						<td class="labelmedium ccell" bgcolor="#pclr#"><cf_space spaces="60">
					<cfelse>
					    <td class="labelmedium ccell" bgcolor="#pclr#"><cf_space spaces="60">
					</cfif>
					#ContractSel.Mission#<cf_space spaces="60"></td> 
				</cfif>	 
				
				<cfif mode eq "edit" or last eq "1"> 
				
					<td class="labelmedium ccell" style="padding-left:7px" width="100%" bgcolor="#color#">&nbsp;#ContractSel.Mission#<cf_space spaces="80"></td>				
					<input type="hidden" id="mission" name="mission" value="#ContractSel.Mission#">
					
				</cfif>			
			
			<cfelse>
			
			 <cfif url.wf eq "1">
			 
				 <td class="labelmedium ccell" bgcolor="#color#">&nbsp;#Object.Mission#</td>				
										
			 <cfelse>
										
			  	<td class="labelmedium ccell"><font color="FF0000">No organization recorded</font></td>		
			  
			 </cfif>
			
			</cfif>
			
		</tr>			
		
		
		<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "Payroll" 
		 Warning   = "No">
		 
	    <cfif operational eq "0"> 
		
		<TR>
		    <TD style="padding-left:5px" class="labelmedium bcell" height="<cfif mode eq 'edit' or last eq '1'>25</cfif>"><cf_tl id="Service Location">:</TD>
		    			
				<cfif mode eq "view">
				
					<TD bgcolor="#pclr#" class="labelmedium ccell">
					
					 <cfquery name="Location" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    *
							FROM      Ref_PayrollLocation
							WHERE     LocationCode = '#ContractSel.ServiceLocation#'							     
					 </cfquery>	
					
					#Location.Description#
					
					</td>
						
				</cfif>	 
							
				<cfif mode eq "edit" or last eq "1"> 
				
					<td bgcolor="#color#" width="80%" id="editfield" name="editfield">
								   		
					<table cellspacing="0" cellpadding="0" class="formpadding">
						<tr><td class="labelmedium ccell">	
						
						<cfif url.wf eq "1">
							<cfset mis = Object.Mission>
						<cfelse>
							<cfset mis = ContractSel.Mission>
						</cfif>		
														
					    <cfset loc = ContractSel.ServiceLocation>
						
						<cfif loc eq "">
						
							<cfquery name="Default" 
							datasource="AppsPayroll" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   *
								FROM     Ref_PayrollLocationMission							
								WHERE    Mission = '#mis#'				
								AND      LocationDefault = 1
							</cfquery>	
							
							<cfset loc = Default.LocationCode>						
						
						</cfif>
						
						<cfquery name="Location" 
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     Ref_PayrollLocation							
							WHERE    LocationCode IN (SELECT LocationCode 
							                          FROM   Ref_PayrollLocationMission 													 
													  WHERE  Mission = '#mis#'
													
													  )									
						</cfquery>	
					
						 <select name="ServiceLocation" 
						   class="regularxlbl" 
						   style="border-top:0px;border-bottom:0px;border-right:1px solid silver;width:99%">
						
						    <option value="">-- select --</option>
							<cfloop query="Location">
							 <option value="#LocationCode#" <cfif LocationCode eq loc>selected</cfif>>#LocationCode# #Description#
							</cfloop>		
							
						</select>
					
						</td></tr>
					</table>
					
					</td>
					
				</cfif>
				
		</TR>
		
		</cfif>
						
	    <TR id="editfield" name="editfield">
		    <TD style="height:28px;padding-left:5px" class="labelmedium bcell"><cf_tl id="Contract type">:</TD>
		    			
				<cfif mode eq "view">
				
					<TD bgcolor="#pclr#" class="labelmedium ccell">
							
					<cfquery name="Type" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM Ref_ContractType
							WHERE ContractType = '#ContractSel.ContractType#'
					</cfquery>
					
					#Type.Description#
					
					</td>
						
				</cfif>	 
			
				<cfif mode eq "edit" or last eq "1"> 
				
					<td bgcolor="#color#" id="editfield" name="editfield" class="ccell">
									   		
					<table style="width:100%">
					
						<tr><td class="labelmedium">	
						
						<cfif url.wf eq "1">
							<cfset mis = Object.Mission>
						<cfelse>
							<cfset mis = ContractSel.Mission>
						</cfif>			
									
					    <cfset ctr = ContractSel.ContractType>
												
						<cfquery name="Scope" 
							datasource="AppsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
							    FROM   Ref_ContractTypeMission
								WHERE  Mission = '#mis#' 
						</cfquery>
																		
						<cfif scope.recordcount eq "0">
									
							<cfquery name="Type" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
								    FROM   Ref_ContractType
									WHERE  (Operational = 1 OR ContractType = '#ContractSel.ContractType#')
							</cfquery>
						
						<cfelse>
							
							<cfquery name="Type" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
								    FROM   Ref_ContractType
									WHERE ( 
											Operational = 1 AND  ContractType IN (SELECT ContractType
															                      FROM   Ref_ContractTypeMission
													                              WHERE  Mission = '#mis#')
										  ) 
										  
										  OR 
										  
										  ContractType = '#ContractSel.ContractType#'				
							</cfquery>
						
						</cfif>
						
					  	<select name="ContractType" id="contracttype"						     
						    size="1" style="width:99%"
							class="regularxlbl" 
							onchange="_cf_loadingtexthtml='';ptoken.navigate('ContractEditFormPayroll.cfm?mode=#mode#&last=#last#&id=#url.id#&id1=#url.id1#&contracttype='+this.value+'&salaryschedule='+document.getElementById('salaryschedule').value,'boxeditentitlement')">
							<cfloop query="Type">
								<option value="#Type.ContractType#" <cfif ContractType eq ContractSel.ContractType>selected</cfif>>#Description#</option>
							</cfloop>
					    </select>
						
						</td></tr>
					</table>
					
					</td>
					
				</cfif>
				
		</TR>
		
		
		
							
		<cfquery name="AppStatus" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_AppointmentStatus
		</cfquery>
						
		<TR id="editfield" name="editfield">
	    <TD style="padding-left:5px;height:28px;" class="labelmedium bcell"><cf_tl id="Appointment Status">:</TD>
	   			
			<cfif mode eq "view">
			
				<td bgcolor="#pclr#" class="labelmedium ccell">
			
				<cfquery name="Type" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM Ref_AppointmentStatus
						WHERE Code = '#ContractSel.AppointmentStatus#'
				</cfquery>
				
				#Type.Description# <cfif ContractSel.AppointmentStatusMemo neq ""><br>#ContractSel.AppointmentStatusMemo#</cfif>
				
				</td>
				
			</cfif>	
			
			<cfif mode eq "edit" or last eq "1"> 
			
				<td bgcolor="#color#" id="editfield" name="editfield" class="ccell">
				
					<table style="width:100%">
					
						<tr>
						<td class="labelmedium" colspan="2" style="width:100%" id="boxappointment">	
							<cfdiv bind="url:setAppointmentStatus.cfm?mission=#mis#&contractid=#ContractSel.Contractid#&appointment=#ContractSel.AppointmentStatus#&contractType={ContractType}">														
						</td>					
						</tr>					
						
					</table>
					
				</td>	
			
			</cfif>
			
		</TD>
		
		</TR>	
		
		<TR id="editfield" name="editfield">
	    <TD  style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Appointment Title">:</TD>  
		
			<cfif mode eq "view">
				
					<td bgcolor="#pclr#" class="labelmedium ccell">
				
					#ContractSel.ContractFunctionDescription#
					
					</td>
					
			</cfif>	
			
			<cfif mode eq "edit" or last eq "1"> 
			
				<td bgcolor="#color#" id="editfield" name="editfield" class="ccell">
				 	
		   		<table>
				<tr><td class="hide"><input type="text" id="ContractFunctionNo" name="ContractFunctionNo" value="#ContractSel.ContractFunctionNo#" style="background-color: f4f4f4;" class="regularxl" size="20" maxlength="20" readonly></td>
				<td><input type="text" id="ContractFunctionDescription" style="border:0px" name="ContractFunctionDescription" value="#ContractSel.ContractFunctionDescription#" style="background-color: f4f4f4;" class="regularxl" size="50" maxlength="100"></td>
				<td style="padding-left:1px;padding-right:3px">
				<cfset link = "#SESSION.root#/Staffing/Application/Employee/Contract/getFunction.cfm?contract=1">
							
					  		<cf_selectlookup
							    box          = "functioncontent"
								title        = "Function Search"
								icon         = "search.png"
								link		 = "#link#"
								des1		 = "FunctionNo"
								filter1      = "Mission"
								filter1Value = "{mission}"
								button       = "No"
								style        = "width:28;height:25"
								close        = "Yes"			
								datasource	 = "AppsEmployee"		
								class        = "Function">	
			</td>
			
			<td class="hide" id="functioncontent"></td>
		
			</tr>
			</table>
		
			</TD>	
			
			</cfif>
			
		</TR>
		
		<cfoutput>
		
		     <script>
			 
			 	function effective_selectdate() {					 	
				  // trigger a function to set the cf9 calendar by running in the ajax td						 
				  _cf_loadingtexthtml="";
				  ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditEffectiveScript.cfm?lastcontractid=#ContractSel.Contractid#&contractid=#rowguid#&personno=#url.id#&mission=#ContractSel.Mission#','DateExpiration_trigger')					  						
				} 
				
				function expiration_selectdate() {					 	
				  _cf_loadingtexthtml="";	
				  // if document.getElementById('DateExpiration_trigger') {
				  // trigger a function to set the cf9 calendar by running in the ajax td							 	 
				  ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditExpirationScript.cfm?lastcontractid=#ContractSel.Contractid#&contractid=#rowguid#&personno=#url.id#&mission=#ContractSel.Mission#','DateExpiration_trigger')					  										  
				  // }
				} 
			</script>	
			
		</cfoutput>	
		
					
		<TR>
	    <TD style="padding-left:5px" class="labelmedium bcell"><cf_tl id="Effective">:</TD>
	  			
			<cfif mode eq "view">
			
				 <td class="labelmedium ccell" style="padding-left:5px;width:140px;height:28px" bgcolor="#pclr#">#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#</td>			
			</cfif>
												
			<cfif (mode eq "edit") or last eq "1"> 
												
				<td bgcolor="#color#" id="effectivefield" name="editfield" class="ccell">		
											
				<table ccellspacing="0" ccellpadding="0">
				<tr>
				<td style="height:28" class="labelmedium" id="boxdateeffective">	
				
				<cfif mdte eq "view">
				
				 <input type="hidden" id="DateEffective" name="DateEffective" value="#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#">
				 
				 &nbsp;&nbsp;#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#
								
				<cfelse>
							
						<cfif last eq "0">
						
							&nbsp;&nbsp;#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#
						<input type="hidden" id="DateEffective" name="DateEffective" value="#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#">
				
						<!---
														
							  <cf_intelliCalendarDate9
								FieldName="DateEffective"
								ToolTip="Date Effective" 	
								Manual="True"		
								Class="regularxlbl"												
								Default="#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#"
								DateValidStart="#Dateformat(ContractLast.DateEffective, 'YYYYMMDD')#"		
								scriptdate="effective_selectdate"		
								AllowBlank="False">	
								
								--->
								
						
						<cfelse>				
														
							<cfif ContractLast.DateEffective neq "">																			
							
								<cfquery name="Action" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
									    FROM   Ref_Action
										WHERE  ActionCode = '#selact#'
									</cfquery>								
													
								  <cfif Action.ModeEffective eq "1">	
								 								  
								  	<cfif now() lte ContractLast.DateExpiration>
									
										 <cf_intelliCalendarDate9
										FieldName="DateEffective"	
										Manual="True"		
										Class="regularxlbl"																					
										ToolTip="Effective Date" 				
										Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(ContractFirst.DateEffective, 'YYYYMMDD')#"	
										scriptdate="effective_selectdate"
										AllowBlank="False">		
									
									<cfelse>						       
								  					 						  						  							  
								  	  <cf_intelliCalendarDate9
										FieldName="DateEffective"	
										Manual="True"		
										Class="regularxlbl"																					
										ToolTip="Effective Date" 				
										Default="#Dateformat(ContractLast.DateEffective, CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(ContractFirst.DateEffective, 'YYYYMMDD')#"	
										scriptdate="effective_selectdate"
										AllowBlank="False">		
										
									</cfif>		
									
								  <cfelse>
								  
								  						 						 								
									  <cf_intelliCalendarDate9
										FieldName="DateEffective"
										Manual="True"	
										Class="regularxlbl"																
										ToolTip="Effective Date" 				
										Default="#Dateformat(ContractLast.DateEffective, CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(ContractLast.DateEffective, 'YYYYMMDD')#"	
										scriptdate="effective_selectdate"					
										AllowBlank="False">	
									
									</cfif>
							
							<cfelse>
							
								<cfif ContractLast.DateEffective neq "">	
								
								<cfquery name="Action" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT *
									    FROM   Ref_Action
										WHERE  ActionCode = '#selact#'
									</cfquery>
																
								  <cfif Action.ModeEffective eq "1">	
								  													  
								  	  <cf_intelliCalendarDate9
										FieldName="DateEffective"	
										Manual="True"		
										Class="regularxlbl"															
										ToolTip="Effective Date" 				
										Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(ContractFirst.DateEffective, 'YYYYMMDD')#"	
										scriptdate="effective_selectdate"
										AllowBlank="False">			
									
								  <cfelse>
								  
								  	  <cf_intelliCalendarDate9
										FieldName="DateEffective"	
										Manual="True"		
										Class="regularxlbl"											
										ToolTip="Effective Date" 				
										Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
										DateValidStart="#Dateformat(ContractLast.DateEffective, 'YYYYMMDD')#"	
										scriptdate="effective_selectdate"
										AllowBlank="False">										
									
								  </cfif>			
									
								<cfelse>							
								
								  <cf_intelliCalendarDate9
									FieldName="DateEffective"	
									Manual="True"		
									Class="regularxlbl"													
									ToolTip="Effective Date" 				
									Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
									scriptdate="effective_selectdate"
									AllowBlank="False">								
								
								</cfif>			
							
							</cfif>
						
						</cfif>
						
				 </cfif>	
				
				</td></tr></table>
				
				</td>
			
			</cfif>
				
		</td>	
		</tr>
		
								
		<tr>

			<TD style="padding-left:5px" class="labelmedium bcell"><cf_tl id="Expiration">:</TD>
			    				
			<cfif mode eq "view">
				 <td class="labelmedium ccell" style="width:120px;height:28px" bgcolor="#pclr#">		
				 <cfif ContractSel.dateexpiration eq "">
				 end of mandate
				 <cfelse>	
				 #Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#
				 </cfif>
				 </td>
			
			</cfif>
			
			<cfif mode eq "edit" or last eq "1"> 
				
				<td bgcolor="#color#" id="expirationfield" name="editfield" class="labelmedium ccell">
				
				<table width="100%" cellspacing="0" ccellpadding="0">
				
				<tr><td style="height:28;min-width:330px;" class="labelmedium">
				
				<cfif mdte eq "view">
				
				 <input type="hidden" name="DateExpiration" value="#Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#">
				 
				 &nbsp;&nbsp;#Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#
				 
				<cfelse> 
														
					<cfif last eq "0">	
										
					  <cf_intelliCalendarDate9
						FieldName="DateExpiration" 
						ToolTip="Expiration Date"
						Class="regularxlbl"					
						Manual="True"										
						Default="#Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#"
						scriptdate="expiration_selectdate"
						AllowBlank="True">	
											
						<cfoutput>
			
						     <script>
								 ColdFusion.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditExpirationAssignment.cfm?contractid=#rowguid#&personno=#url.id#&mission=#ContractSel.Mission#&effective=#Dateformat(ContractSel.DateEffective, CLIENT.DateFormatShow)#&expiration=#Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#','DateExpiration_trigger')					  						
							 </script>	
					
						</cfoutput>						
					
					<cfelse>
					
						<cfif ContractLast.DateExpiration neq "">					
					
						  <cf_intelliCalendarDate9
							FieldName="DateExpiration" 
							ToolTip="Expiration Date"
							Class="regularxlbl"
							DateValidStart="#Dateformat(ContractLast.DateEffective, 'YYYYMMDD')#"
							Default="#Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#"
							Manual="True"	
							scriptdate="expiration_selectdate"
							AllowBlank="True">		
							
						
						<cfelse>
						
						  <cf_intelliCalendarDate9
							FieldName="DateExpiration" 
							ToolTip="Expiration Date"
							Class="regularxlbl"
							Default="#Dateformat(ContractSel.DateExpiration, CLIENT.DateFormatShow)#"
							Manual="True"	
							scriptdate="expiration_selectdate"
							AllowBlank="True">												
						
						</cfif>				
					
					</cfif>
					
				  </cfif>	
												
				</td>
				
				<!---								
				<td align="right" style="padding-right:7px">
				
					<img src="#SESSION.root#/images/delete5.gif" 
					    alt="Clear" style:"cursor:pointer" align="absmiddle" height="16" width="15"  border="0" onclick="document.getElementById('DateExpiration').value=''">
								
				</td>
				--->
				
				</tr>
				</table>
											
			</cfif>		
						
		</tr>	
		
		<TR id="editfield" name="editfield">
	    <TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Regularised">:</TD>
	   		
			<cfif mode eq "view">
			  
			    <td class="labelmedium ccell" bgcolor="#pclr#"><cfif ContractSel.ContractStatus eq "1"><cf_tl id="Yes"><cfelse><cf_tl id="Yes"></cfif></td>
				
			</cfif>
			
			<cfif mode eq "edit" or last eq "1"> 
			
				<td style="padding-left:14px;" class="labelmedium ccell" bgcolor="#color#" id="editfield" name="editfield">	
				
				
				<table>
				   <tr class="labelmedium">
				   <td style="padding-left:2px"><INPUT type="radio" name="ContractStatus" value="1" <cfif ContractSel.ContractStatus eq "1">checked</cfif>></td>
				   <td style="padding-left:4px"><cf_tl id="Yes"></td>
				   <td style="padding-left:8px"><INPUT type="radio" name="ContractStatus" value="0" <cfif ContractSel.ContractStatus neq "1">checked</cfif>></td>
				   <td style="padding-left:4px"><cf_tl id="No"></td>	
				</tr>
				</table>	
			
				</td>
			
			</cfif>
		
		</TR>
						
		<TR id="editfield" name="editfield">
	    <TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Review Panel">:</TD>
	   		
			<cfif mode eq "view">
			
				<td class="labelmedium ccell" bgcolor="#pclr#"><cfif ContractSel.ReviewPanel eq "1">Yes<cfelse>No</cfif></td>
				
			</cfif>
			
			<cfif mode eq "edit" or last eq "1"> 
				
				 <td style="padding-left:14px;" class="labelmedium ccell" bgcolor="#color#" id="editfield" name="editfield">		
				<table>
				   <tr class="labelmedium">
				   <td style="padding-left:2px">
					<INPUT type="radio" name="ReviewPanel" value="1" <cfif ContractSel.ReviewPanel eq "1">checked</cfif>><td>
					<td style="padding-left:4px"><cf_tl id="Yes"></td>
					<td style="padding-left:8px"><INPUT type="radio" name="ReviewPanel" value="0" <cfif ContractSel.ReviewPanel neq "1">checked</cfif>></td>
					<td style="padding-left:4px"><cf_tl id="No"></td>	
				</tr>
				</table>			
				</td>	
			
			</cfif>
									
		</TD>
		</TR>
		
		<cfif mode eq "view" and last eq "0" and ContractSel.ContractTime eq "100">
		
			<!--- hide --->
		
		<cfelse>
				
			<TR id="editfield" name="editfield">
			    <TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Part-time">:</TD>
			   		
					<cfif mode eq "view">
		
						<td class="labelmedium ccell" bgcolor="#pclr#">#ContractSel.ContractTime# %</td>				
						
					</cfif>
					
					<cfif mode eq "edit" or last eq "1"> 
					
						<td style="padding-left:14px;" class="labelmedium ccell" bgcolor="#color#" id="editfield" name="editfield">
						<table>
						   <tr class="labelmedium">
						   <td style="padding-left:2px">
								<INPUT type="radio" name="ContractTime" value="100" <cfif ContractSel.ContractTime eq "100" or ContractSel.ContractTime eq "">checked</cfif>>
								</td><td style="padding-left:2px">No&nbsp;-100%</td>
							 <td style="padding-left:8px">	
								<INPUT type="radio" name="ContractTime" value="90" <cfif ContractSel.ContractTime eq "90">checked</cfif>>
								</td><td style="padding-left:2px">90%</td>		
							 <td style="padding-left:8px">	
								<INPUT type="radio" name="ContractTime" value="80" <cfif ContractSel.ContractTime eq "80">checked</cfif>>
								</td><td style="padding-left:2px">80%</td>	
							 <td style="padding-left:8px">	
								<INPUT type="radio" name="ContractTime" value="70" <cfif ContractSel.ContractTime eq "70">checked</cfif>>
								</td><td style="padding-left:2px">70%</td>	
							 <td style="padding-left:8px">	
								<INPUT type="radio" name="ContractTime" value="60" <cfif ContractSel.ContractTime eq "60">checked</cfif>>
								</td><td style="padding-left:2px">60%</td>			
							<td style="padding-left:8px;padding-right:5px">							
								<INPUT type="radio" name="ContractTime" value="50" <cfif ContractSel.ContractTime eq "50">checked</cfif>>
								</td><td style="padding-left:2px">50%</td>
							<td style="padding-left:8px;padding-right:5px">							
								<INPUT type="radio" name="ContractTime" value="40" <cfif ContractSel.ContractTime eq "40">checked</cfif>>
								</td><td style="padding-left:2px">40%</td>
							<td style="padding-left:8px;padding-right:5px">							
								<INPUT type="radio" name="ContractTime" value="20" <cfif ContractSel.ContractTime eq "20">checked</cfif>>
								</td><td style="padding-left:2px">20%</td>		
							</tr>
						</table>
						</td>	
				
					</cfif>		
				
			</TR>	
		
		</cfif>
		
		<cfif mode eq "view" and last eq "0" and ContractSel.SalaryBasePeriod eq "0" or ContractSel.SalaryBasePeriod eq "">
		
		<!--- hide --->
		
		<cfelse>
						
		<TR id="editfield" name="editfield">
		    <TD style="padding-left:5px;height:28px" class="labelmedium bcell"><cf_tl id="Work hours">:</TD>
		    
			<cfif mode eq "view">
				<td class="labelmedium ccell" bgcolor="#pclr#">#ContractSel.SalaryBasePeriod#</td>
			</cfif>
			<cfif mode eq "edit" or last eq "1"> 
				<td class="labelmedium ccell" bgcolor="#color#" id="editfield" name="editfield">	
				
					<table>
					<tr>
					<td>	
							
					<cfinput type = "Text" 
					    class     = "regularxlbl" 
						style     = "text-align: center; border-right:1px solid silver" 
						value     = "#ContractSel.SalaryBasePeriod#"
						name      = "SalaryBasePeriod" 
						message   = "Please enter a valid number" 
						validate="float" 
						required  = "No" 
						size      = "3" 
						maxlength = "3">
						
					</td>
					<td style="padding-left:9px;">		
					
								<cfquery name="checkschedule" 
							    datasource="AppsEmployee" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
								SELECT * FROM PersonWorkSchedule
								WHERE PersonNo   = '#url.id#'
								AND   Contractid = '#rowguid#'	
							</cfquery>

							<input type="checkbox" 
							  id="weekselect" 
							  name="weekselect" 
							  value="1" <cfif checkschedule.recordcount gte "1">checked</cfif>
							  onclick="if (this.checked) {document.getElementById('weekbutton').className='regular';document.getElementById('weeklabel').className='hide';document.getElementById('week').click()} else {document.getElementById('weekbutton').className='hide';document.getElementById('weeklabel').className='labelmedium'}">
					</td>
					
					<cfif checkschedule.recordcount gte "1">
					
					<td style="padding-left:6px" id="weeklabel" class="hide"><cf_tl id="workschedule"></td>
					<td id="weekbutton" style="padding-left:7px" class="regular">
						<input class="button10g" 
								onclick="weekschedule('#rowguid#',document.getElementById('mission').value,document.getElementById('DateEffective').value)"
								style="height:22px;width:180px" 
								type="button" 
								id="week" 
								value="Set week schedule">
								
								
					</td>
					
					<cfelse>
					
					<td style="padding-left:6px" id="weeklabel" class="labelmedium"><cf_tl id="workschedule"></td>
					<td id="weekbutton" style="padding-left:7px" class="hide">
						<input class="button10g" 
								onclick="weekschedule('#rowguid#',document.getElementById('mission').value,document.getElementById('DateEffective').value)"
								style="height:22px;width:180px" 
								type="button" 
								id="week" 
								value="Set week schedule">
								
								
					</td>
					
					</cfif>
					
					<input type="hidden" name="dayhour" id="dayhour">					
					
					</tr>
					</table>						
					
				</td>
			</cfif>	
			
		</TR>	
		
		</cfif>
	
	<!--- check for payroll --->
	
	<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "Payroll" 
		 Warning   = "No">
		 
		<cfif Operational eq "0"> 
		
			<cfif url.wf eq "1">
				<cfset mis = Object.Mission>
			<cfelse>
				<cfset mis = ContractSel.Mission>
			</cfif>		
				
			<cfquery name="Scope" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_ContractTypeMission
				WHERE  Mission = '#mis#'
			</cfquery>
		
			<cfif scope.recordcount eq "0">
					
				<cfquery name="PostGrade" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
				    FROM Ref_PostGrade
					WHERE PostGradeContract = 1 
					      OR PostGrade = '#mis#'
					ORDER BY PostOrder	
				</cfquery>
			
			<cfelse>
				
				<cfquery name="PostGrade" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					     SELECT *
				    FROM Ref_PostGrade
					WHERE (
							PostGradeContract = 1 AND PostGradeParent IN (SELECT PostGradeParent
					                        FROM   Ref_PostGradeParentMission
				                            WHERE  Mission = '#mis#'
											AND Mode = 'Edit'
											)
						  ) OR
						  PostGrade = '#ContractSel.ContractLevel#'								  			
					ORDER BY PostOrder
					 
				</cfquery>
			
			
			</cfif>
				
			<tr id="editfield" name="editfield">		
			  	<TD style="padding-left:5px" class="labelmedium bcell"><cf_tl id="Grade"> / <cf_tl id="Step">:</TD>
				
				<cfif mode eq "view">
					<td class="labelmedium ccell" bgcolor="#pclr#">#ContractSel.ContractLevel# / #ContractSel.ContractStep#</td>
				</cfif>

				<cfif mode eq "edit" or last eq "1"> 
				
					<td class="labelmedium ccell" bgcolor="#color#" id="editfield" name="editfield">	
					
					<table ccellspacing="0" ccellpadding="0">
					
						<tr><td>
					
					    <cfif url.wf eq "1">
						
							<cfquery name="SalRec" 
							datasource="AppsVacancy" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT   S.RecommendLevel, S.RecommendStep
								FROM     stSalaryRecommendation AS S INNER JOIN
					                      Organization.dbo.OrganizationObject AS O ON S.DocumentNo = O.ObjectKeyValue1 AND S.PersonNo = O.ObjectKeyValue2
								WHERE    (O.EntityCode = 'VacCandidate') 
								AND      (O.ObjectId = '#Object.ObjectId#')
							</cfquery>
						
							<!--- determine via object the salary record table --->
						
							<select name="contractlevel" id="contractlevel" size="1" style="width:100px" class="regularxlbl">
								<cfloop query="PostGrade">
								<option value="#PostGrade#" <cfif PostGrade eq SalRec.recommendLevel>selected</cfif>>
						    		#PostGrade#  
								</option>
								</cfloop>
						    </select>	
						
						<cfelse>
									
							<select name="contractlevel" id="contractlevel" size="1" style="width:100px" class="regularxlbl">
								<cfloop query="PostGrade">
								<option value="#PostGrade#" <cfif PostGrade eq ContractSel.ContractLevel>selected</cfif>>
						    		#PostGrade#  
								</option>
								</cfloop>
						    </select>	
						
						</cfif>
						
						</td>
						
						<td>
																		
						  <cfif url.wf eq "1">
						  
						  	  <!--- take from Salary recommendation 		--->
						  
						  	<cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractEditFormStep.cfm?grade={contractlevel}&step=#SalRec.recommendstep#" 
							    id="gradestep">						  
						      								 
							 <cfelse>
							 
							 <cfdiv bind="url:#SESSION.root#/staffing/Application/Employee/Contract/ContractEditFormStep.cfm?grade={contractlevel}&step=#ContractSel.ContractStep#" 
							    id="gradestep">
						  							 						 
							 </cfif>
							 
						 </td>
						 
						 </tr>
					</table>
						
					</td>
							
				</cfif>	
				
			</tr>
									
			<tr id="nextincrement" name="editfield"><td style="padding-left:5px;padding-right:5px;height:35px" class="labelmedium bcell"><cf_tl id="Next Increment">:</TD>
									
					<cfif mode eq "view">
						<td bgcolor="#pclr#" class="labelmedium ccell">
						<cfif ContractSel.StepIncreaseDate eq "">
					 		--
						<cfelse>
							#Dateformat(ContractSel.StepIncreaseDate, CLIENT.DateFormatShow)#					
						</cfif>
						</td>
					
					</cfif>

					<cfif mode eq "edit" or last eq "1"> 
			
					  <td bgcolor="#color#" id="editfield" name="editfield" style="height:28px;" class="labelmedium ccell">
												
					  <cfdiv id="increment">	
					 					 
						 <cfset url.eff = dateformat(ContractSel.StepIncreaseDate,client.dateformatshow)>
						 
						 <cfset url.lastcontractid = ContractSel.ContractId>                                      
						 <cfinclude template="ContractEditFormIncrement.cfm">
					
					  </cfdiv>
					  				  					
					  </td>
						
					</cfif>		
					
			</tr>
			
		<cfelse>
		
			<cfinclude template="ContractEditFormSalary.cfm">				   
			
	</cfif>	
	
	<!--- ------------------ --->
	<!--- leave entitlements --->
	<!--- ------------------ --->
		
	<cfquery name="Leave" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Ref_LeaveType
			WHERE    LeaveAccrual = '3'
			ORDER BY ListingOrder
	</cfquery>		
	
	<cfif Leave.recordcount gte "1">	
		<cfinclude template="ContractEditFormLeave.cfm">			
	</cfif>
	
	<!--- -------------------- --->
	<!--- payroll entitlements --->
	<!--- -------------------- --->
		
	<cf_tl id="YesShort" var="1">
	<cfset tYes = "#Lt_text#">
	
	<cfquery name="Param" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT   *
		    FROM     Parameter	
	</cfquery>		 
				 
	<cfif Operational eq "1"  or Param.DependentEntitlement eq "1"> 	
	
		<tr id="editfield" name="editfield">
		  <td height="19" colspan="3" class="labelmedium" style="font-weight:200;border-bottom:1px solid silver;height:45px;font-size:21px;padding-left:4px"><cf_tl id="Payroll"><cf_tl id="Entitlements"></td>
	    </tr>

		<cfif mode eq "view">
		
			<cfset url.contracttype = ContractSel.contractType>
		    <cfset url.salaryschedule = ContractSel.SalarySchedule>
			<tr><td colspan="3" id="boxeditentitlement">  
		    <cfinclude template="ContractEditFormPayroll.cfm">	
			</td>
			</tr>
		
		<cfelse>
		
			<tr><td colspan="3" id="boxeditentitlement">			
			<cfset url.contracttype = ContractSel.contractType>
			<cfset url.salaryschedule = ContractSel.SalarySchedule>
			<cfinclude template="ContractEditFormPayroll.cfm">					
			</td>
			</tr>
		
		</cfif>
					
	</cfif>
		
	<TR>
        <td class="labelmedium bcell" valign="top" style="padding-left:5px;padding-top:4px"><cf_tl id="Remarks">:</td>
       
			<cfif mode eq "view">
				<TD bgcolor="#pclr#" class="labelmedium ccell" width="20%" valign="top" style="padding:4px">
			    <cfif ContractSel.remarks eq "">
				 ---
				<cfelse>
				#ContractSel.Remarks#
				</cfif>
				</td>
			 </cfif>
					
			 <cfif mode eq "edit" or last eq "1">  
				 <td bgcolor="#color#" valign="top" class="labelmedium ccell" style="height:120px;border-right:1px solid silver;padding-right:5px">
				
				<textarea class="regular"
				    name="Remarks" 
					id="Remarks" 
					style="width:99%;font-size:13px;padding:3px;height:98%;border:0px" 
					totlength="800" 
					onkeyup="return ismaxlength(this)" >#ContractSel.Remarks#</textarea> 
				</TD>
			</cfif>	
				
	</TR>
	
	<!---
	<cfif ContractSel.actionStatus eq "9" or ContractSel.actionStatus eq "8">
	--->
	
	<cfset del = "0">
	
			
		<cfif url.action eq "0" and ContractSel.actionStatus lte "1">
					
			<!--- the contract status is set by the workflow, and will lock the option to make changes --->
					
			<tr class="labelmedium">
									
						<td>		
						<table>
							<tr class="labelmedium">
							
							<td style="height:34">				
								
								    <cfif url.mycl eq "0" and url.wf eq "0">
												 				
							   			<cf_tl id="Back" var="1">
							
										<input type="button" 
									    name="cancel" 
										value="<cfoutput>#lt_text#</cfoutput>" 
										class="button10g" 
										style="width:110"
										onClick="history.back()">
										
									</cfif>	
									
								</td>
								
								<cfif getAdministrator(ContractSel.mission) eq "1" or wfstarted eq "no">		
								
									<cfset del = "1">								
																	
									<td style="padding-left:2px">				
									<!--- only for the administrator --->											   
									   <cf_tl id="Remove" var="1">
									   <input class="button10g"  style="width:110" onmouseover="this.focus()" type="submit" onClick="return ask()" name="Delete" value="<cfoutput>#lt_text#</cfoutput>">													    
									</td>								
								
								</cfif>
							</tr>
						</table>
						</td>													
				
				<cfif last eq "0" and mode eq "edit">				
	
						<td style="padding-left:2px">
						<cfif url.wf eq "0">
												
						<cf_tl id="Update" var="1">
					    <input class="button10g"  style="width:110" onmouseover="this.focus()" type="submit" name="Update" value="<cfoutput>#lt_text#</cfoutput>">   
						</cfif>
						</td>
							
				<cfelseif last eq "1">
										
						<td align="right" style="padding-left:2px">
						<table>
							<tr class="labelmedium">
								<td>												
								<!--- only for the administrator --->
								<cfif getAdministrator(ContractSel.mission) eq "1" and del eq "0">					   
								   <cf_tl id="Delete" var="1">
								   <input class="button10g"  style="width:150" onmouseover="this.focus()" type="submit" onClick="return ask()" name="Delete" value="<cfoutput>#lt_text#</cfoutput> (Admin only)">						
								</td>								
							    </cfif>
								<td style="padding-left:2px">					
								<cf_tl id="Submit Amendment" var="1">
							    <input class="button10g"  style="width:160" onmouseover="this.focus()" type="submit" name="Update" value="<cfoutput>#lt_text#</cfoutput>">   
								</td>						
							</tr>
						</table>
						</td>	
						
				</cfif>	
							
			</tr>	
					
		</cfif>
		
	</table>
	</tr>
			
	<cfif url.wf eq "1" or url.action eq "1">		
		</table>		
	</cfif>	
		
</cfoutput>

