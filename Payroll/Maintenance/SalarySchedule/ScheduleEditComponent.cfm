		
	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
		
		<tr><td height="3"></td></tr>
		<tr class="labelmedium line">
		    <td height="17" align="center"></td>
			<td></td>
			<td><cf_tl id="Component"></td>
			<td><cf_tl id="Pay"></td>
			<td><cf_tl id="Ptr"></td>
			<td><cf_tl id="Spe"></td>
			<td><cf_tl id="Group"></td>
			<td><cf_tl id="Rate UoM"></td>
			<td><cf_UItooltip tooltip="If selected settlement includes entitlements accumumated until the prior month">
				<cf_tl id="Prior">
				</cf_UItooltip>
			</td>							
		</tr>	
				
		<cfquery name="Component"
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT R.*, 
			       C.ComponentId, 
				   C.ComponentName, 
				   C.SalaryDays,
				   T.TriggerGroup, 
				   C.EntitlementRecurrent,
				   R.EntitlementPointer,
				   C.SettleUntilPeriod
			FROM   Ref_PayrollTrigger T INNER JOIN
	               Ref_PayrollComponent R ON T.SalaryTrigger = R.SalaryTrigger LEFT OUTER JOIN
	               SalaryScheduleComponent C ON R.Code = C.ComponentName	   
			 AND   SalarySchedule = '#URL.ID1#'	   
	   		
			ORDER BY T.TriggerGroup, R.Description, R.ListingOrder 
		</cfquery>
				
		<cfoutput query="component" group="TriggerGroup">
				
		<tr class="line"><td height="30" colspan="9" width="10%" style="height:40px;padding-left:10px;font-size:20px;" class="labellarge line">#TriggerGroup#</td></tr>
						
			<cfoutput>
			
			<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('eaeaea'))#" style="height:15px" class="line navigation_row labelmedium">
			
			<cfset com = "#replace(Code,' ','','ALL')#">
			<cfset com = "#replace(com,'-','','ALL')#">
			
			    <td width="10%" align="center">
				
					<cfquery name="Check"
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT SalarySchedule
						FROM   SalaryScaleLine
						WHERE  SalarySchedule = '#URL.ID1#'
						AND    ComponentName = '#ComponentName#'
						AND    Amount > 0
						UNION
						SELECT SalarySchedule
						FROM   SalaryScalePercentage P, SalaryScale S
						WHERE  P.ScaleNo = S.ScaleNo
						AND    SalarySchedule = '#URL.ID1#'
						AND    ComponentName = '#ComponentName#'
					</cfquery>
					
					<cfif Check.recordcount eq "0">
						<input type="hidden" name="value_#Com#"    value="#Code#">
						<input type="checkbox" name="select_#Com#" value="#Code#" <cfif ComponentName neq "">checked</cfif> onclick="toggleme('#com#',this.checked)">
					<cfelse>
					    <!--- is in use, better to preventing editing it in the past no longer needed in new structure --->
						<input type="hidden" name="value_#Com#"    value="#Code#">
						<input type="checkbox" name="select_#Com#" value="#Code#" <cfif ComponentName neq "">checked</cfif> onclick="toggleme('#com#',this.checked)">				
					</cfif>
				
				</td>
				
				<td style="padding-right:5px">
					
					<cfif check.recordcount eq "1">
						<cfset cl = "regular">			
					<cfelse>
						<cfset cl =" hide">	
					</cfif>
				
					<img src = "#session.root#/images/arrowright.gif" 
						 title   = "#lt_text#" 
						 class   = "#cl#" 
						 id      = "twistie_#com#" 
						 onclick = "showLocation('#url.id1#','#com#','#componentname#')">
				
				</td>
				
				<td>#Description#</td>			
				<td>#SalaryMultiplier#</td>
				<td>#EntitlementPointer#</td>
				<td><cfif EntitlementRecurrent eq "0">Y</cfif></td>
				<td>#EntitlementGroup#</td>
				<td>#Period#</td>
				<td style="cursor:pointer">
				
				<cfif Check.recordcount eq "0">
	
					<cfif Period eq "PERCENT">			
						<input type="checkbox" name="SettleUntilPeriod_#Com#" value="prior" <cfif SettleUntilPeriod eq "Prior">checked</cfif>>						 		
					</cfif>
					
				<cfelse>
				
				 <cfif Period eq "PERCENT">	
				 #SettleUntilPeriod#
				 </cfif>
				
				</cfif>	
				</td>
								
			</tr>
			<tr>
				<td></td>
				<td colspan="11" style="padding-left:30px" id="detailLocation_#com#"></td>
			</tr>
			
			<tr><td colspan="8"></td></tr>
					
			<cfif period eq "DAY" and componentid neq "">
			
			<tr id="r#ComponentId#">
			  		     
			   <td colspan="8" id="i#componentid#">		
				<cfset url.componentid = ComponentId>
				<cfinclude template="ScheduleEditDates.cfm">		
			</td></tr>
				
			</cfif>
					
			</cfoutput>
		
		</cfoutput>
		
								
</table>

<cfset ajaxonload("doHighlight")>
		