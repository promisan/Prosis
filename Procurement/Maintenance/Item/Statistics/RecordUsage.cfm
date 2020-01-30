
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM ItemMaster
	WHERE Code = '#URL.ID#'
</cfquery>

<cfset url.mission = get.mission>

<cfquery name="Purchase" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT Mission, COUNT(*) as Lines
	FROM RequisitionLine
	WHERE ItemMaster = '#URL.ID#'
	GROUP BY Mission	
</cfquery>

<cfoutput>

<table width="96%" border="0" bordercolor="e4e4e4" cellspacing="0" cellpadding="0" align="center" class="formpadding">
				
		<tr><td colspan="2" class="labelit"><cf_tl id="Procurement"></b></td></tr>	
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td height="3" valign="top"><cf_tl id="Usage">:</td>
			<td>
				<table width="100%" align="center" border="0" celpadding="0" cellspacing="0">
					<cfloop query="Purchase">
						<tr>
							<td class="labelit" width="90">#Mission#</td><td>#Lines#</td>
						</tr>
					</cfloop>
				</table>
			</td>
		</tr>	
		
			
		<cf_verifyOperational 
         datasource= "appsSystem"
         module    = "WorkOrder" 
		 Warning   = "No">
		 
		<cfif operational eq "1">
				
			<cfquery name="Service" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT Mission, COUNT(*) as Lines
				FROM   Workorder
				WHERE  ServiceItem = '#URL.ID#'
				GROUP BY Mission		
			</cfquery>		
			
			<tr><td height="7"></td></tr>
			<tr><td colspan="2" class="labelit"><cf_tl id="Service">/<cf_tl id="WorkOrder"></b></td></tr>	
			<tr><td colspan="2" class="linedotted"></td></tr>
			<tr><td height="3" valign="top" class="labelit"><cf_tl id="Usage">:</td>
			    <cfif Service.recordcount eq "0">
				<td class="labelit"><font color="808080"><cf_tl id="Not used"></font></td>
				<cfelse>	
				<td>
					<table width="100%" align="center" border="0" celpadding="0" cellspacing="0">
						<cfloop query="Service">
							<tr>
								<td class="labelit" width="90">#Mission#</td><td class="labelit">#Lines#</td>
							</tr>
						</cfloop>
					</table>
				</td>
				</cfif>
			</tr>	
			
		</cfif>	
					
		<cfquery name="Budget" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT P.Mission, COUNT(*) as Lines
			FROM  ProgramAllotmentRequest PA, program P
			WHERE P.ProgramCode = PA.ProgramCode
			AND   PA.ItemMaster = '#URL.ID#'
			GROUP BY P.Mission		
		</cfquery>
			
		<tr><td height="7"></td></tr>
		<tr><td colspan="2" class="labelit"><cf_tl id="Budget Preparation"> (<cf_tl id="requirements">)</b></td></tr>	
			<tr><td colspan="2" class="linedotted"></td></tr>
			<tr><td height="3" valign="top" class="labelit"><cf_tl id="Usage">:</td>
			    <cfif Budget.recordcount eq "0">
				<td class="labelit"><font color="808080"><cf_tl id="Not used"></font></td>
				<cfelse>				
				<td>
					<table width=100% align="center" border="0" celpadding="0" cellspacing="0">
						<cfloop query="Budget">
							<tr>
								<td width="90" class="labelit">#Mission#</td><td class="labelit">#Lines#</td>
							</tr>
						</cfloop>
					</table>
		     	</td>
				</cfif>
		</tr>	
				
									
</table>	
	
</cfoutput>	