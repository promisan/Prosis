
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
		
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
				<tr><td height="8" colspan="5" ></td></tr>		
				
				<tr class="labelit linedotted">
					<td class="labelit">Op</td>		
					<td>Entity</td>							
					<td class="labelit">Effective</td>
					<td class="labelit" align="center">Unit</td>
					<td class="labelit" align="center">Disable Distribution</td>
					<td class="labelit">Posting Level</td>	
					<td class="labelit">Posting Journal</td>					
					<td class="labelit">Person Liability</td>
					
							
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
													
				<tr class="labelmedium line" style="height:40px">
				
					 <cfif used.recordcount gte "1">
				  
				   
					   <input type="hidden" name="mission_#ln#" value="1">
					   <td></td>
				   
				   <cfelse>
				   
				   	<td align="center">
					 					   
					   <input type="checkbox" name="mission_#ln#" value="1" <cfif get.recordcount eq "1">checked</cfif>>
				  		
					</td>
				   
				   </cfif>
				   
				   <td>#Mission#
				   <cf_space spaces="45">
				   </td>
				  				   
				  
				   				   
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
				   
				   <td align="center">
				  
				   <input type="checkbox" class="radiol" name="orgunit_#ln#" value="1" <cfif get.OrgUnit eq "1">checked</cfif> class="labelit">
									   
				   </td>

				   <td align="center">
				  
				   <input type="checkbox" class="radiol" name="disableDistribution_#ln#" value="1" <cfif get.DisableDistribution eq "1">checked</cfif> class="labelit">
									   
				   </td>
				   
				    <td>
				   
				   <select name="PostingMode_#ln#" style="width:90px;" class="regularxl" onchange="togglePostingMode(this.value, '.clsPostingMode_#mission#');">					
					   <option value="Schedule" <cfif get.PostingMode eq "Schedule">selected</cfif>>Schedule</option>					
					   <option value="Individual" <cfif get.PostingMode eq "Individual">selected</cfif>>Individual</option>				
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
							AND     TransactionCategory IN ('Payables','DirectPayment')
							AND 	Currency = (SELECT Paymentcurrency FROM Payroll.dbo.SalarySchedule WHERE SalarySchedule = '#URL.ID1#')
						</cfquery>
						
						<select name="journal_#ln#" style="width:180px; #vPostingModeToggle#" class="regularxl clsPostingMode_#vMissionId#">
						<option value="">--- select ---</option>
						<cfloop query="Journal">
							<option value="#Journal#" <cfif get.Journal eq Journal>selected</cfif>>#Journal# #Description#</option>					
						</cfloop>					
						</select>
					
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