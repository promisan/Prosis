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
<!------------------------------------------------------------------------ Modification  Details ----------------------------------
				Date: 		27/10/2008
				By: 		Huda Seid
				Detail:     Add a help icon indicator next to the validation message to display further details on the modications 
							if the validation starts with E,V or R.
------------------------------------------------------------------------------------------------------------------------------------>
<cfparam name="ProcessWF" default="0">

	<table width="98%" border="0" cellspacing="0" cellpadding="1" align="center">
	
	<cfsilent>
	
	<cfif ProcessWF eq "1" or calc.recordcount eq "0" and claim.actionStatus lte "2">

		<cfset reload = "No">
		<cfset progress = "0">
		<cfinclude template="../Process/Calculation/Calculate.cfm">		

	</cfif>	
	
	</cfsilent>	
	
	<cfquery name="ClaimRequest" 
	     datasource="appsTravelClaim" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		     SELECT * 
			 FROM   ClaimRequest 
			 WHERE  ClaimRequestId = '#Claim.ClaimRequestId#' 					
	</cfquery>
		
	<cfquery name="Calc" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     ClaimCalculation
		WHERE    ClaimId = '#ClaimId#' 
		AND      CalculationId IN (SELECT CalculationId 
		                          FROM   ClaimValidationLog)
		ORDER BY Created DESC 
	</cfquery>	
	
	<cfif calc.recordcount eq 1>
	   <cfset calcid = calc.calculationid>
	<cfelse>
	   <cfset calcid = "00000000-0000-0000-0000-000000000000"> 
	</cfif>
				
	<cfif Calc.CalculationId neq "">	
				
		<!--- check for messages --->
			
		<cfif (Claim.ActionStatus gte "2" and Claim.ActionStatus lte "5") or Parameter.ShowValidationUser eq "1" or SESSION.isAdministrator eq "Yes">
													
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
					   R.Enforce,
					   LV.ClearanceActor,
					   LV.ValidationMemo,					 
					   LV.IndicatorCode
		    FROM       ClaimValidation LV INNER JOIN
		               Ref_Validation R ON LV.ValidationCode = R.Code
			WHERE      LV.ClaimId       = '#ClaimId#'    
			AND        LV.CalculationId = '#Calc.CalculationId#'  
			ORDER BY   Code,IndicatorCode
			</cfquery>	
						
			<cfquery name="Verify" 
				datasource="appsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    ClaimValidation Val INNER JOIN
		              	Ref_DutyStationActor R ON Val.ClearanceActor = R.ClearanceActor
				WHERE   R.ClaimException  = '1'
				AND     R.Mission         = '#ClaimRequest.Mission#'
				AND     Val.ClaimId       = '#URL.ClaimId#'
				AND     Val.CalculationId = '#Calc.CalculationId#'
			</cfquery>
					
			<cfif Verify.recordcount eq "0">
								
				<cfquery name="ClaimException" 
			     datasource="appsTravelClaim" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     UPDATE Claim
					 SET    ClaimException = '0' 
					 WHERE  ClaimId = '#URL.ClaimID#' 
					 AND    ClaimExceptionActor is NULL <!--- not manually said --->
			    </cfquery>
						
			</cfif>
			
			<!--- enforce incomplete accross the board --->
			
			<cfif Parameter.EnforceIncomplete eq "1">
					
					<cfquery name="ClaimException" 
				     datasource="appsTravelClaim" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     UPDATE Claim
						 SET    ClaimException = '1' 
						 WHERE  ClaimId = '#URL.ClaimID#'
				    </cfquery>
				
			</cfif>
			
			<cfquery name="Claim" 
			     datasource="appsTravelClaim" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT * 
					 FROM   Claim 
					 WHERE  ClaimId = '#URL.ClaimID#' 					
			</cfquery>
						
											
			<cfif Message.recordcount eq "0">
			
					<tr>
					<td colspan="1" height="25" width="80%"><b>
					<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/check_mark2.gif" alt="" border="0" align="absmiddle">
					<font face="Verdana">&nbsp;No exceptions</b> <cfoutput>(last validation : #dateformat(calc.created,CLIENT.DateFormatShow)# #timeformat(calc.created,"HH:MM")#)</cfoutput></b></td>
					<td align="right" width="120">
					
					 <cfif Claim.ClaimException eq "1">
					  	
					    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/warning.gif" 
						  alt="Claim will be uploaded as unapproved" 
						  border="0" 
						  align="absmiddle" 
						  style="cursor: hand;">
						  &nbsp;
					  	<font color="red">
						  <b>INCOMPLETE !&nbsp;
						</font>
					  </cfif>
					
					</td>
					</tr>
			
			<cfelse>
							
					<tr>
					<td colspan="1" height="25" width="80%"><b>
					<font face="Verdana" color="FF8040">&nbsp;Claim validation and verification results</b> <cfoutput>(last validation : #dateformat(calc.created,CLIENT.DateFormatShow)# #timeformat(calc.created,"HH:MM")#)</cfoutput></b></td>
					<td align="right">
					
					 <cfif Claim.ClaimException eq "1">
					  	 <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/warning.gif" 
						  alt="Claim will be uploaded as unapproved" 
						  border="0" 
						  align="absmiddle" 
						  style="cursor: hand;">
						  &nbsp;
					  	<font color="red">
						 <b>INCOMPLETE !&nbsp;</font>
						 <cfif Claim.ClaimExceptionActor neq "">[Manual]</cfif>
					  </cfif>
					
					
					</td>
					</tr>				
										
					<tr><td colspan="2" bgcolor="e4e4e4"></td></tr>					
					
					<tr><td colspan="2">
						<table width="100%" border="0" cellspacing="0" cellpadding="3" align="center" rules="rows">
						
						<cfset cnt = 0>	
						
						<cfoutput query="message" group="Code">
						
						    <cfoutput group="IndicatorCode">
							
							<cfoutput group="ValidationMemo">
							
							<cfset cnt = cnt + 1>							
							<tr bgcolor="#color#">
								<!-------HS 27/10/2008: Added a new column and the help icon next to the validation------------>
								<td>
									<cfif Left(#code#,1) eq 'E' or Left(#code#,1) eq 'V' or Left(#code#,1) eq 'R'>
									<cf_helpfile 
									code    = "TravelClaim" 
									class   = "Indicator"
									id      = "VXX"
									display = "icon">
									</cfif>
								</td>
								<td height="18" align="center" width="30">
									<cfif color eq "red"><font color="FFFFFF"></cfif>#cnt#.
								</td>
								
								<td width="35"><cfif color eq "red"><font color="FFFFFF"></cfif>#code#</td>
								<td>
									<cfif color eq "red"><font color="FFFFFF"></cfif>#ValidationMemo# 
								</td>								
								<td>								
								<cfset cur = 0>
								<cfoutput><cfset cur = cur+1><cfif cur gt "1">,&nbsp;</cfif><b>#ClearanceActor#</cfoutput>						
								</td>
								<td width="30" align="center">
								    <cfif enforce eq "1">
									 <cftooltip tooltip="You must be resolve this validation before you may forward this claim.">
									 <img src="#SESSION.root#/Images/stop1.gif"									    
									     border="0"
										 align="absmiddle"
									     style="cursor: hand;">									
									 </cftooltip>
									</cfif> 
								</td>
							</tr>
							<tr><td height="1" colspan="5" bgcolor="d3d3d3"></td></tr>
						
							</cfoutput>	
							</cfoutput>	
						</cfoutput>						
					
						</table>					
						
					</td></tr>
					
				
																									
			</cfif>
			
		</cfif>	
			
   </cfif>	
      					
   <cfif Claim.ActionStatus lte "2" or (SESSION.isAdministrator eq "Yes" and claim.actionStatus neq "6")>
   <tr><td height="3"></td></tr>
	<tr>
		<td colspan="2" align="center">
		<cfoutput>
		<input type="button" class="button10g" value="Revalidate" onClick="calculate('#Claim.ClaimAsIs#','1')">
		</cfoutput>
		</td>
	</tr>
   </cfif>
				
  </table>
   
  	