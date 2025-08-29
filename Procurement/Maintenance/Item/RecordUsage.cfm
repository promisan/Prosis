<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
				
		<tr><td colspan="2"><font face="Verdana" size="2">Procurement</b></td></tr>	
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="3" valign="top">Usage:</td>
			<td>
				<table width=100% align="center" border="0" celpadding="0" cellspacing="0">
					<cfloop query="Purchase">
						<tr>
							<td width="90">#Mission#</td><td>#Lines#</td>
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
				SELECT   Mission, COUNT(*) as Lines
				FROM     Workorder
				WHERE    ServiceItem = '#URL.ID#'
				GROUP BY Mission		
			</cfquery>		
			
			<tr><td height="7"></td></tr>
			<tr><td colspan="2"><font face="Verdana" size="2">Service/WorkOrder</b></td></tr>	
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="3" valign="top">Usage:</td>
			    <cfif Service.recordcount eq "0">
				<td><font color="808080">Not used</font></td>
				<cfelse>	
				<td>
					<table width=100% align="center" border="0" celpadding="0" cellspacing="0">
						<cfloop query="Service">
							<tr>
								<td width="90">#Mission#</td><td>#Lines#</td>
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
			SELECT   P.Mission, COUNT(*) as Lines
			FROM     ProgramAllotmentRequest PA, program P
			WHERE    P.ProgramCode = PA.ProgramCode
			AND      PA.ItemMaster = '#URL.ID#'
			GROUP BY P.Mission		
		</cfquery>
			
		<tr><td height="7"></td></tr>
		<tr><td colspan="2"><font face="Verdana" size="2">Budget Preparation (requirements)</b></td></tr>	
			<tr><td colspan="2" class="line"></td></tr>
			<tr><td height="3" valign="top">Usage:</td>
			    <cfif Budget.recordcount eq "0">
				<td><font color="808080">Not used</font></td>
				<cfelse>				
				<td>
					<table width=100% align="center" border="0" celpadding="0" cellspacing="0">
						<cfloop query="Budget">
							<tr>
								<td width="90">#Mission#</td><td>#Lines#</td>
							</tr>
						</cfloop>
					</table>
		     	</td>
				</cfif>
		</tr>	
				
									
</table>	
	
</cfoutput>	