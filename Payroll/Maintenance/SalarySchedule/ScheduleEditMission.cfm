<!--
    Copyright © 2025 Promisan

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

<!--- mission --->

<cf_calendarscript>

<cfquery name="MissionSelect" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT Mission
		FROM Ref_MissionModule
		WHERE SystemModule = 'Payroll' 
</cfquery>	

<table width="93%" align="center">
	
	<tr>	
		<td height="10" colspan="3" class="header">
		
				<table width="98%" align="center" class="formpadding">
				
				<tr><td height="8" colspan="5"></td></tr>		
				
				<tr class="labelmedium2 line fixlengthlist">
					<td><cf_tl id="Op"></td>		
					<td><cf_tl id="Entity"></td>							
					<td><cf_tl id="Effective"></td>
					<td><cf_tl id="Posting Level"></td>	
					<td><cf_tl id="Posting Journal"></td>			
					<td align="center"><cf_tl id="Post unit"></td>
					<td align="center"><cf_tl id="Settlement handling"></td>																				
					<td><cf_tl id="Person Liability<"></td>							
				</tr>				
									
				<cfset ln="0">	
								
				<cfoutput query="MissionSelect">
								
				<!--- check if this period is already used in program in that case
				you are not allowed to change anymore --->
				
				<cfquery name="Get" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   SalaryScheduleMission 
				   	WHERE  SalarySchedule = '#URL.ID1#'
					AND    Mission = '#mission#'				
				</cfquery>
								
				<cfquery name="Used" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   SalarySchedulePeriod 
				   	WHERE  SalarySchedule = '#URL.ID1#'
					AND    Mission = '#mission#'
					AND   CalculationStatus > '0'
				</cfquery>
												
				<cfset ln = ln + 1>
													
				<tr class="labelmedium2 line fixlengthlist">
				
					 <cfif used.recordcount gte "1">		  
				   
					   <input type="hidden" name="mission_#ln#" value="1">
					   <td></td>
				   
				   <cfelse>
				   
				   	<td align="center">					 					   
					   <input type="checkbox" name="mission_#ln#" value="1" <cfif get.recordcount eq "1">checked</cfif>>				  		
					</td>
				   
				   </cfif>
				   
				   <td>#Mission#</td>			  				   
				  
				   				   
				   <td>				   
					  				   
					   <cfif used.recordcount gte "1">
					   
						   #dateformat(get.DateEffective,CLIENT.DateFormatShow)#
						   <input type="hidden" name="dateeffective_#ln#" value="#dateformat(get.DateEffective,CLIENT.DateFormatShow)#">
										   
					   <cfelse>
					   
					   	  <cfif get.dateeffective eq "">
						      <cfset dt = "01/#month(now())#/#year(now())#">						   
						  <cfelse>
						  	  <cfset dt = "#dateformat(get.DateEffective,CLIENT.DateFormatShow)#">
						  </cfif>
						  
						  <cf_space spaces="49">
											   
						  <cf_intelliCalendarDate9
							FieldName="dateeffective_#ln#" 
							Manual="True"										
							Default="#dt#"
							class="regularxl"
							AllowBlank="False">					   
					   
					   </cfif>				   
				   
				   </td>
				   
				    <td>
				   
				   <select name="PostingMode_#ln#" style="width:150px;" class="regularxl" onchange="togglePostingMode(this.value, '.clsPostingMode_#mission#');">					
					   <option value="Schedule"   <cfif get.PostingMode eq "Schedule">selected</cfif>><cf_tl id="Schedule"></option>					
					   <option value="Individual" <cfif get.PostingMode eq "Individual">selected</cfif>><cf_tl id="Individual"></option>				
					</select>
					
					<cfset vPostingModeToggle = "">
					<cfif trim(lcase(get.PostingMode)) eq "schedule" or trim(lcase(get.PostingMode)) eq "">
						<cfset vPostingModeToggle = "display:none;">
					</cfif>
				   
				   </td>
				   
				   <td style="width:200px;">
				   
				   		<cfset vMissionId = replace(mission," ", "", "ALL")>
					
						<cfquery name="Journal" 
						datasource="AppsLedger" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT  *
						    FROM    Journal 
						   	WHERE   Mission  =  '#mission#'				
							AND     TransactionCategory IN ('Payables','DirectPayment','Memorial')
							AND 	Currency = (SELECT Paymentcurrency FROM Payroll.dbo.SalarySchedule WHERE SalarySchedule = '#URL.ID1#')
							AND     SystemJournal = 'Payroll'
						</cfquery>
						
						<select name="journal_#ln#" style="width:280px;" class="regularxl">
						<option value="">--- select ---</option>
						<cfloop query="Journal">
							<option value="#Journal#" <cfif get.Journal eq Journal>selected</cfif>>#Journal# #Description#</option>					
						</cfloop>					
						</select>
					
				   </td>
				   
				   <td align="center">
				  
				   <input type="checkbox" class="radiol" name="orgunit_#ln#" value="1" <cfif get.OrgUnit eq "1">checked</cfif>>
									   
				   </td>

				   <td align="center">
				  
					   <table>
					   <tr class="labelmedium2">
					   <td>AP</td>
					   <td><input type="radio" class="radiol" name="disableDistribution_#ln#" value="0" <cfif get.DisableDistribution eq "0">checked</cfif>></td>				   
					   <td>Check only:</td>
					   <td><input type="checkbox" class="radiol" name="DistributionMode_#ln#" value="1" <cfif get.DistributionMode eq "1">checked</cfif>></td>				  
					   <td style="padding-left:10px">
					   <input type="radio" class="radiol" name="disableDistribution_#ln#" value="1" <cfif get.DisableDistribution eq "1">checked</cfif>>
					   </td>
					   <td>Disabled</td>
					   </tr>
					   </table>
				   
				   </td>	
				   				 
				   <td style="width:200px;">
				   
				   <cfquery name="Account" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
				    FROM   Ref_Account 
				   	WHERE  AccountType = 'Credit' and AccountClass = 'Balance'
					AND    GLAccount IN (SELECT GLAccount
					                     FROM   Ref_AccountMission 
										 WHERE  Mission = '#mission#')				
					</cfquery>
					
					<cfif Account.recordcount eq "0">
					
						  <cfquery name="Account" 
							datasource="AppsLedger" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT *
							    FROM   Ref_Account 
							   	WHERE  AccountType = 'Credit' and AccountClass = 'Balance'					
							</cfquery>
										
					</cfif>
					
					<select name="glaccount_#ln#" style="width:180px; #vPostingModeToggle#" class="regularxl clsPostingMode_#vMissionId#">
						<option value="">-- <cf_tl id="Select an account"> --</option>
					<cfloop query="Account">
						<option value="#GLAccount#" <cfif get.GLAccount eq GLAccount>selected</cfif>>#GLAccount# #Description#</option>					
					</cfloop>					
					</select>				   	   
				   
				   </td>
									
				</tr>
																						
				</cfoutput>				
				
			</table>
			
	</td></tr>	
			
</table>			