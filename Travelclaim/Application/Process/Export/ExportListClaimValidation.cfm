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
<cfparam name="ProcessWF" default="0">
	
	<cfquery name="Calc" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM   ClaimCalculation
		WHERE  ClaimId = '#ClaimId#'
		AND CalculationId IN (SELECT CalculationId FROM ClaimValidation)
		ORDER BY Created DESC 
	</cfquery>	
			
	<cfif Calc.CalculationId neq "">	
				
		<!--- check for messages --->
													
			<cfquery name="Message" 
			datasource="appsTravelClaim" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT     DISTINCT 
			           R.Code,
			           R.Description, 
					   R.MessagePerson,
					   R.MessageAuditor,
			           R.Color, 
					   LV.ValidationMemo,
					   LV.ClearanceActor
		    FROM       ClaimValidation LV INNER JOIN
		               Ref_Validation R ON LV.ValidationCode = R.Code
			WHERE      LV.ClaimId = '#ClaimId#'    
			AND        LV.CalculationId = '#Calc.CalculationId#'  
			ORDER BY   Code,ClearanceActor
			</cfquery>			
								
			<cfif Message.recordcount gt "0">
									
				<table width="98%" border="0" frame="hsides" bordercolor="d0d0d0" cellspacing="1" cellpadding="1" align="center">
						
				<tr><td colspan="2">
				
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="d4d4d4" rules="rows">					
					
					<!---
					<tr>
					<td colspan="1" height="25"><b>
					<img src="<cfoutput>#SESSION.root#</cfoutput>/images/alert.gif" alt="" border="0" align="absmiddle">
					<font face="Verdana">&nbsp;Claim validation and verification results</b></td>
					<td align="right"></td>
					</tr>
					--->
										
					<tr><td colspan="2">
					<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" rules="rows">
					
					<cfset cnt = 0>	
					
					<cfoutput query="message" group="Code">
						<cfset cnt = cnt + 1>
						<tr>
							<td height="20" align="center" width="30">
								<cfif color eq "red"><font color="FFFFFF"></cfif>#cnt#.
							</td>
							<td><cfif color eq "red"><font color="FFFFFF"></cfif>#code#</td>
							<td>
								<cfif color eq "red"><font color="FFFFFF"></cfif>#ValidationMemo# 
							</td>
						</tr>
						
						<!---
						<tr><td></td><td colspan="2">Enforce review by:
						<cfset cur = 0>
						<cfoutput><cfset cur = cur+1><cfif cur gt "1">,&nbsp;</cfif><b>#ClearanceActor#</cfoutput>
						</td></tr>
						--->
						
					</cfoutput>
					
					</table>
					</td></tr>
					<tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>					
					
					</table>
					
				</td></tr>	
				
				</table>
							
			</cfif>
						
   </cfif>	
   
  	