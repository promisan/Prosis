<cfset vSalaryScheduleList = ListQualify(url.SalarySchedule, "'")>
<cfset vPayrollItemList = ListQualify(url.PayrollItem, "'")>
<cfset vPostGradeList = ListQualify(url.PostGrade, "'")>
<cfset vLocationList = ListQualify(url.Location, "'")>
<cfset vMonthsList = ListQualify(url.months, "'")>

<cfset vLowerLimit = 1>
<cfset vUpperLimit = 100>
<cfset vInitialVariationValue = 5>
<cfset vAnimationTime = 350>

<cf_tl id="Show person profile" var="lblShowPerson">
<cf_tl id="Salary Details" var="lblShowSalaryDetails">
<cf_tl id="Payroll Item Details" var="lblShowPayrollItemDetails">
<cf_tl id="All Payroll Item Details" var="lblShowAllPayrollItemDetails">

<cfif url.type eq "0">

	<cf_tl id="Settlement" var="vTypeDescription">	
	
	<cfquery name="getBaseData" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		
		 	SELECT  Base.*,
		 			P.FirstName,
		 			P.LastName,
		 			P.IndexNo
					
			FROM  (SELECT  	ESL.PersonNo,
						 	ESL.PaymentYear,
						 	ESL.PaymentMonth,														
						 	ESL.PaymentDate,
						 	ESL.SalarySchedule,
						 	SS.Description as SalaryScheduleDescription,
							<!--- Hanno tweaking 23/8 to change this to the payment date --->
							(convert(varchar(4), year(PaymentDate)) + convert(varchar(2), month(PaymentDate))) as stMonth,							
						 	ESL.Currency,
						 	ESL.PayrollItem,
						 	PI.PrintOrder      as PayrollItemOrder,
						 	PI.PayrollItemName as PayrollItemDescription,
							
						 	ISNULL(ESL.PaymentAmount, 0) as Total
							
				   FROM	 	EmployeeSettlementLine ESL
				   			INNER JOIN SalarySchedule SS
			 					ON ESL.SalarySchedule = SS.SalarySchedule
			 				INNER JOIN Ref_PayrollItem PI
			 					ON ESL.PayrollItem = PI.PayrollItem		
								
				   WHERE	ESL.Mission     = '#url.mission#'
				   AND 		PI.Settlement   = '1'
				   AND 		PI.PrintGroup  != 'Contributions'
				   <cfif url.SalarySchedule neq "">
				   AND      ESL.SalarySchedule IN (#preserveSingleQuotes(vSalaryScheduleList)#)
				   </cfif>
				   <cfif url.FilterMode eq "0">
				   AND      ESL.PaymentDate = ESL.PayrollEnd
				   </cfif>
				   <cfif url.PayrollItem neq "">
				   AND      ESL.PayrollItem IN (#preserveSingleQuotes(vPayrollItemList)#)
				   </cfif>
				   				   
				   <cfif url.PostGrade neq "">
				   AND     EXISTS (SELECT 'X'
				                   FROM  EmployeeSalary Sx
								   WHERE Sx.PersonNo       = ESL.PersonNo
								   AND   Sx.Mission        = ESL.Mission
								   AND   Sx.SalarySchedule = ESL.SalarySchedule
								   AND   Sx.ContractLevel IN (#preserveSingleQuotes(vPostGradeList)#)
								   AND   Sx.PayrollStart    = ESL.PayrollStart)								   	
				   </cfif>			   
				 
				   <cfif url.location neq "">
					AND    EXISTS (SELECT 'X'
								   FROM  EmployeeSalary Sx
								   WHERE Sx.SalarySchedule = ESL.SalarySchedule
								   AND 	 Sx.PayrollStart   = ESL.PayrollStart
								   AND 	 Sx.PersonNo       = ESL.PersonNo
								   AND 	 Sx.ServiceLocation IN (#preserveSingleQuotes(vLocationList)#))
					</cfif>
					
			    ) AS Base
			   	INNER JOIN Employee.dbo.Person P ON Base.PersonNo = P.PersonNo
				
			WHERE	1=1			
			<cfif url.months neq "">
			AND      stMonth IN (#preserveSingleQuotes(vMonthsList)#)
			</cfif>
			
			<cfif url.FilterPerson neq "">			
			AND (P.FullName LIKE '%#url.filterperson#%' or P.IndexNo LIKE '%#url.filterperson#%')
			</cfif>
			
			<cfif url.order eq "0">
			ORDER BY PaymentDate DESC, IndexNo ASC, LastName ASC, PersonNo ASC, PayrollItemOrder, PayrollItemDescription
			</cfif>
			
			<cfif url.order eq "1">
			ORDER BY PaymentDate DESC, LastName ASC, IndexNo ASC, PersonNo ASC, PayrollItemOrder, PayrollItemDescription
			</cfif>

	</cfquery>

<cfelse>

	<cf_tl id="Entitlement" var="vTypeDescription">
	
	<cfquery name="getBaseData" 
		 datasource="AppsPayroll" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		
		 	SELECT  Base.*,
		 			P.FirstName,
		 			P.LastName,
		 			P.IndexNo
			FROM
			    (
				   SELECT  	ESL.PersonNo,
						 	ESL.EntitlementYear as PaymentYear,
						 	ESL.EntitlementMonth as PaymentMonth,
						 	ES.PayrollEnd as PaymentDate,
						 	ESL.SalarySchedule,
						 	SS.Description as SalaryScheduleDescription,
						 	(convert(varchar(4), ESL.EntitlementYear) + convert(varchar(2), ESL.EntitlementMonth)) as stMonth,
						 	ESL.PaymentCurrency as Currency,
						 	ESL.PayrollItem,
						 	PI.PrintOrder as PayrollItemOrder,
						 	PI.PayrollItemName as PayrollItemDescription,
						 	ISNULL(ESL.PaymentAmount, 0) as Total
							
				   FROM   	EmployeeSalary ES
							INNER JOIN EmployeeSalaryLine ESL
								ON ES.SalarySchedule  = ESL.SalarySchedule
								AND ES.PayrollStart   = ESL.PayrollStart
								AND ES.PersonNo       = ESL.PersonNo
								AND ES.PayrollCalcNo  = ESL.PayrollCalcNo
				   			INNER JOIN SalarySchedule SS
			 					ON ESL.SalarySchedule = SS.SalarySchedule
			 				INNER JOIN Ref_PayrollItem PI
			 					ON ESL.PayrollItem    = PI.PayrollItem
			 				INNER JOIN Employee.dbo.PositionParent P 
			 					ON ES.PositionParentId     = P.PositionParentId
								
				   WHERE	ES.Mission     = '#url.mission#'
				   AND 		PI.Settlement  = '1'
				   AND 		PI.PrintGroup != 'Contributions'
				   
				   <cfif url.FilterMode eq "1">
				   AND   	ES.ContractLevel <> ES.ServiceLevel 
				   </cfif>
				   <cfif url.SalarySchedule neq "">
				   AND      ESL.SalarySchedule IN (#preserveSingleQuotes(vSalaryScheduleList)#)				   
				   </cfif>
				   <cfif url.PayrollItem neq "">
				   AND      ESL.PayrollItem IN (#preserveSingleQuotes(vPayrollItemList)#)
				   </cfif>
				   <cfif url.PostGrade neq "">
				   AND     ES.ContractLevel IN (#preserveSingleQuotes(vPostGradeList)#)				  				   	
				   </cfif>
				  
				   <cfif url.location neq "">
				   AND      ES.ServiceLocation IN (#preserveSingleQuotes(vLocationList)#)
					</cfif>
			    ) AS Base
			   	INNER JOIN Employee.dbo.Person P ON Base.PersonNo = P.PersonNo
				
			WHERE	1=1
			
			<cfif url.months neq "">			
				AND stMonth IN (#preserveSingleQuotes(vMonthsList)#) 
			</cfif>
			
			<cfif url.FilterPerson neq "">			
			AND (P.FullName LIKE '%#url.filterperson#%' or P.IndexNo LIKE '%#url.filterperson#%')
			</cfif>
			
			<cfif url.order eq "0">
				ORDER BY PaymentDate DESC, IndexNo ASC, LastName ASC, PersonNo, PayrollItemOrder, PayrollItemDescription
			<cfelse>
				ORDER BY PaymentDate DESC, LastName ASC, IndexNo ASC, PersonNo, PayrollItemOrder, PayrollItemDescription
			</cfif>
			
	</cfquery>	

</cfif>

<cfquery name="getMonthGrades" 
	 datasource="AppsPayroll" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 	SELECT DISTINCT	*
		FROM 
			(
			 	SELECT 	ES.PersonNo, 
						YEAR(ES.PayrollEnd) as PaymentYear,
						MONTH(ES.PayrollEnd) as PaymentMonth,
						(convert(varchar(4), YEAR(ES.PayrollEnd)) + convert(varchar(2), MONTH(ES.PayrollEnd))) as stMonth,
						(ES.ServiceLevel + '/' + ES.ServiceStep) as [Level],
						L.LocationCode,
						L.Description as LocationDescription
				FROM 	EmployeeSalary ES
						LEFT OUTER JOIN Ref_PayrollLocation L 
							ON ES.ServiceLocation = L.LocationCode
				WHERE 	1=1
				<cfif url.SalarySchedule neq "">
					AND ES.SalarySchedule IN (#preserveSingleQuotes(vSalaryScheduleList)#)
			   </cfif>
	   		) AS Data
		WHERE 	stMonth IN (#preserveSingleQuotes(vMonthsList)#)
</cfquery>

<cfif getBaseData.recordCount eq 0>

	<table width="98%" align="center">
		<tr><td height="30"></td></tr>
		<tr>
			<td class="labellarge" align="center">[ <cf_tl id="No data found for the selected criteria"> ]</td>
		</tr>
	</table>
	
<cfelse>

	<cfquery name="getMonths" dbtype="query">
		SELECT   DISTINCT 
				 PaymentDate,
				 PaymentMonth,
				 PaymentYear
		FROM 	 getBaseData
		ORDER BY PaymentDate ASC
	</cfquery>

	<cfquery name="getPersons" dbtype="query">
		SELECT DISTINCT 
				PersonNo,
				FirstName,
				LastName,
				IndexNo,
				SalarySchedule,
				SalaryScheduleDescription,
				Currency,
				PayrollItem,
				PayrollItemDescription
		FROM 	getBaseData
		
		<cfif url.order eq "0">
			ORDER BY Currency ASC, SalarySchedule ASC, IndexNo ASC, LastName ASC, PersonNo ASC, PayrollItemOrder, PayrollItemDescription ASC
		</cfif>
		
		<cfif url.order eq "1">
			ORDER BY Currency ASC, SalarySchedule ASC, LastName ASC, PersonNo ASC, PayrollItemOrder,PayrollItemDescription ASC
		</cfif>
	</cfquery>

	<cfoutput>
	
	<table width="100%" height="100%">
	
		<tr><td>
	
		<table width="98%" align="center" class="clsNoPrint">
			<tr class="line">
			<td height="10">
						
				<table width="100%">
					<tr class="line">
						<td style="padding-top:4px;font-weight:200;font-size:24px">#ucase(getPersons.SalaryScheduleDescription)# - #ucase(getPersons.Currency)#</td>
						<td style="padding-left:10px;">
							<img id="twistiePIAll" src="#session.root#/images/minusBlue.png" style="height:15px; cursor:pointer;" onclick='showAllPayrollItemDetail();' title="#lblShowAllPayrollItemDetails#">
						</td>
						
						<td align="right" style="padding-right:5px;">
						<table>
							<tr>
								<td align="center" style="padding-top:12px">
									<span id="printTitle" style="display:none;">#url.mission# <cf_tl id="Payroll Variation"> - #vTypeDescription#</span>
									<cf_tl id="Print" var="1">
									<cf_button2 
										mode		= "icon"
										type		= "Print"
										title       = "#lt_text#" 
										id          = "Print"
										height		= "30px"
										width		= "35px"
										imageHeight = "28px"
										printTitle	= "##printTitle"
										printContent = "##divContent"
										printCallback="$('.clsCFDIVSCROLL_MainContainer').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','width:100%;'); $('.clsCFDIVSCROLL_MainContainer').parent('div').attr('style','height:100%;');">
									
								</td>
								<cf_tl id="Export to Excel" var="1">
								<td style="padding-left:2px;">
									<img src="#session.root#/images/Excel.png" style="cursor:pointer; margin-top:12px; height:28px;" onclick="Prosis.exportToExcel('mainQualityViewTable');" title="#lt_text#">
								</td>
							</tr>
							
							<tr>
							
						   </tr>
						   
						</table>
					</td>													
				</tr>
				
				<tr>					
				
				<td colspan="2" valign="bottom" style="padding-bottom:1px">
				<cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   filtermode       = "fly"
				   label            = "Quick Search"
				   name             = "filtersearch"
				   style            = "font:14px;height:25;width:100"
				   rowclass         = "clsFilterRow"
				   rowfields        = "ccontent">
			   </td>
			   
			   <td align="right" style="padding-right:5px;">
					<table width="100%">
							<tr>
				
							<td class="labelmedium" style="font-weight:250"><cf_tl id="Variation"> (<cf_tl id="percentage from the previous calculation">):</td>
							<td class="labellarge" align="right">
								&plusmn;
								<input 
									type="text" 
									id="sliderOutput" 
									class="regularxl" 
									style="width:40px; text-align:right; padding-right:5px;" 
									value="#vInitialVariationValue#" 
									onchange="setSliderValue(this.value);">
								%
							</td>
							</tr>
						
							<tr>
								<td colspan="2" style="padding-left:3px">
									<input 
										type="range" 
										max="#vUpperLimit#" 
										min="#vLowerLimit#" 
										class="clsSlider" 
										value="#vInitialVariationValue#" 
										id="variationSlider" 
										oninput="doChangeVariation();" 
										onchange="doChangeVariation();">
								</td>
							</tr>							
								
					</table>
					
				</TD>
				</TR>
				</TABLE>	
				</td>					
		</tr>	
		
	</table>
	</cfoutput>
	
	</td></tr>
	
	<tr><td style="height:100%">
	
	<cf_divscroll overflowy="scroll">

	<table width="97%" align="center" id="mainQualityViewTable" class="navigation_table">

		<tr>			
			<td colspan="2" style="padding-left:0px"></td>			
			<cfoutput query="getMonths">				
				<td colspan="2" align="right" class="labellarge" style="padding-right:4px;font-size:90%;">
					<cfset vThisMonth = dateFormat(PaymentDate, "MMMM")>
					<cf_tl id="#vThisMonth#" var="1">
					#lt_text# #dateFormat(PaymentDate, "YYYY")#
				</td>
			</cfoutput>
		</tr>
		<cfoutput>
			<tr class="clsNoExportToExcel"><td class="line" colspan="#getMonths.recordCount*2 + 3#"></td></tr>
		</cfoutput>

		<cfset vCountPersons = 0>
		<cfoutput query="getPersons" group="Currency">
			<cfoutput group="SalarySchedule">								
				<cfoutput group="personNo">
					<cfset vCountPersons = vCountPersons + 1>
					<tr class="navigation_row line labelmedium clsFilterRow" style="height:20px">
						<td align="center">
							<table class="clsNoExportToExcel clsNoPrint">
								<tr>									
									<td style="padding-left:5px;">
										<img id="twistiePI_#personNo#" class="clsTwistiePI" src="#session.root#/images/minusBlue.png" style="height:13px;" onclick='showPayrollItemDetail("#personNo#");' title="#lblShowPayrollItemDetails#">
									</td>
									<td style="padding-left:7px;">
										<img id="twistie_#personNo#" src="#session.root#/images/expand.png" style="height:11px;" onclick='showEmployeeSalary("#url.SalarySchedule#", "#personNo#", "#url.months#");' title="#lblShowSalaryDetails#">
									</td>
								</tr>
							</table>
						</td>
						<td width="1%">#vCountPersons#.</td>
						<td class="navigation_action ccontent">
						    <a href="javascript:showPerson('#personNo#');">
								<cfif url.order eq "0">
									#indexNo# - #ucase(LastName)#, #FirstName#
								</cfif>
								
								<cfif url.order eq "1">
									#ucase(LastName)#, #FirstName# (#indexNo#)
								</cfif>
							</a>
						</td>

						<cfset vPreviousTotalPerson = 0>
						<cfset vMonthCountPerson = 0>

						<cfset prior = "">
								
						<cfloop query="getMonths">						
							
							<cfquery name="getPersonMonth" dbtype="query">
								SELECT 	SUM(Total) as Total
								FROM 	getBaseData
								WHERE	PersonNo     = '#getPersons.personNo#'
								AND		PaymentYear  = #PaymentYear#
								AND		PaymentMonth = #PaymentMonth#
							</cfquery>		
														
							<cfquery name="getPersonMonthGrades" dbtype="query">
							 	SELECT 	[Level], LocationCode, LocationDescription
								FROM 	getMonthGrades
								WHERE 	PersonNo     = '#getPersons.personNo#'
								AND 	PaymentYear  = #PaymentYear#
								AND 	PaymentMonth = #PaymentMonth#
							</cfquery>												

							<cfset vCurrentTotalPerson = 0>
							<cfif getPersonMonth.recordCount gt 0>
								<cfset vCurrentTotalPerson = getPersonMonth.Total>
							</cfif>
							
							<cfset vDifferencePerson = vCurrentTotalPerson - vPreviousTotalPerson>
							<cfset vMonthCountPerson = vMonthCountPerson + 1>

							<cfset vDifferencePercentagePerson = 0>
							
							<cfif vCurrentTotalPerson neq 0>
								<cfset vDifferencePercentagePerson = ROUND(100*vDifferencePerson/vCurrentTotalPerson)>
							</cfif>
							
							<td align="center" style="width:100;background-color:d8ebeb;border-left:1px solid silver">					
							
								<cfset vCountMonthGrades = 0>											 
								<cfloop query="getPersonMonthGrades">
									<cfif vCountMonthGrades gt 0>,</cfif>#Level# / #LocationCode#
									<cfset vCountMonthGrades = vCountMonthGrades + 1>
								</cfloop>											 
							</td>

							<td align="right" class="clsData clsAnimate" style="border-left:1px solid silver" data-value="<cfif vMonthCountPerson neq 1>#abs(vDifferencePercentagePerson)#<cfelse>-1</cfif>">
								<table style="width:100%">
									<tr class="labelmedium" style="height:20px;">										
										<td align="center" style="min-width:35px;padding-left:2px;border-right:1px solid silver"><cfif vMonthCountPerson neq 1 and vDifferencePercentagePerson neq 0>
												<div class="clsDataPercentage" style="font-size:85%; font-weight:bold; display:none;">#vDifferencePercentagePerson#%</div></cfif> 
										</td>
										<td align="right" style="width:100%;padding-left:8px;padding-right:5px" id="data_#PaymentYear#_#PaymentMonth#_#getPersons.personNo#">#numberFormat(vCurrentTotalPerson, ",.__")#</td>
									</tr>
								</table>
							</td>

							<cfset vPreviousTotalPerson = vCurrentTotalPerson>
							
						</cfloop>

					</tr>

					<cfoutput>
					
						<tr class="navigation_row clsPayrollItemDetail_#PersonNo# clsPayrollItemDetail line labelmedium clsFilterRow">
							<td class="ccontent" style="display:none;">
								<cfif url.order eq "0">#indexNo# - #ucase(LastName)#, #FirstName#</cfif><cfif url.order eq "1">#ucase(LastName)#, #FirstName# (#indexNo#)</cfif>
							</td>
							<td colspan="3" align="right" style="width:100%;padding-right:10px; color:##808080;">#PayrollItemDescription# (#PayrollItem#):</td>

							<cfset vPreviousTotal = 0>
							<cfset vMonthCount = 0>
							
							<cfloop query="getMonths">

								<cfquery name="getPersonPayrollMonth" dbtype="query">
									SELECT 	SUM(Total) as Total
									FROM 	getBaseData
									WHERE	PersonNo     = '#getPersons.personNo#'
									AND		PaymentYear  = #PaymentYear#
									AND		PaymentMonth = #PaymentMonth#
									AND  	PayrollItem  = '#getPersons.PayrollItem#'
								</cfquery>

								<cfset vCurrentTotal = 0>
								<cfif getPersonPayrollMonth.recordCount gt 0>
									<cfset vCurrentTotal = getPersonPayrollMonth.Total>
								</cfif>
								
								<cfset vDifference = vCurrentTotal - vPreviousTotal>
								<cfset vMonthCount = vMonthCount + 1>

								<cfset vDifferencePercentage = 0>
								<cfif vCurrentTotal neq 0>
									<cfset vDifferencePercentage = ROUND(100*vDifference/vCurrentTotal)>
								<cfelseif abs(vDifference) gt "0.05">
								   	<cfset vDifferencePercentage = 100> 
								</cfif>
								
								<td align="center" style="min-width:100px;border-left:1px solid silver;background-color:f4f4f4"></td>

								<td align="right" class="clsData clsAnimate" style="min-width:80px;border-left:1px solid silver" data-value="<cfif vMonthCount neq 1>#abs(vDifferencePercentage)#<cfelse>-1</cfif>">
									<table style="width:100%">
										<tr class="labelmedium" style="height:20px">
											<td align="center" style="min-width:35px;padding-left:2px;border-right:1px solid silver;color:##6B6B6B;">																							
												<cfif vMonthCount neq 1 and vDifferencePercentage neq 0><div class="clsDataPercentage" style="font-size:85%; font-weight:bold; display:none;">#vDifferencePercentage#%</div></cfif> 
											</td>
											<td align="right" style="width:100%;padding-right:5px;padding-left:8px; color:##6B6B6B;" class="labelmedium" id="data_#PaymentYear#_#PaymentMonth#_#getPersons.personNo#">
												#numberFormat(vCurrentTotal, ",.__")#
											</td>
										</tr>
									</table>
								</td>								
								<cfset vPreviousTotal = vCurrentTotal>

							</cfloop>
						</tr>
					</cfoutput>

					<tr id="trDetail_#personNo#" style="display:none" class="clsFilterRow">
						<td colspan="2"></td>
						<td class="ccontent" style="display:none;">
							<cfif url.order eq "0">#indexNo# - #ucase(LastName)#, #FirstName#</cfif><cfif url.order eq "1">#ucase(LastName)#, #FirstName# (#indexNo#)</cfif>
						</td>
						<td colspan="#getMonths.recordCount*2 + 1#" style="padding-left:5px;" id="divDetail_#personNo#"></td>
					</tr>

				</cfoutput>
				
				<tr class="clsNoExportToExcel"><td height="10"></td></tr>
				
			</cfoutput>
			
			
		</cfoutput>

		<cfoutput>
			
			<tr>
				<td colspan="3"></td>

				<cfloop query="getMonths">

					<cfquery name="getTotalMonth" dbtype="query">
						SELECT 	SUM(Total) AS Total
						FROM 	getBaseData
						WHERE	PaymentYear = #PaymentYear#
						AND		PaymentMonth = #PaymentMonth#
					</cfquery>

					<cfset vTotalMonth = 0>
					<cfif getTotalMonth.recordCount gt 0>
						<cfset vTotalMonth = getTotalMonth.Total>
					</cfif>

					<cfset vFormula = "">

					<cfloop query="getPersons">
						<cfset vFormula = "#vFormula#data_#getMonths.PaymentYear#_#getMonths.PaymentMonth#_#personNo#+">
					</cfloop>

					<cfif vFormula neq "">
						<cfset vFormula = mid(vFormula, 1, len(vFormula)-1)>
					</cfif>

					<td></td>
					<td align="right">
						<table>
							<tr>
								<td></td>
								<td class="labelmedium" style="font-weight:bold;padding-right:3px"> <!---formula="#vFormula#"--->
									#numberFormat(vTotalMonth, ",.__")#	
								</td>
							</tr>
						</table>
					</td>

				</cfloop>

			</tr>
			
			<tr class="clsNoExportToExcel"><td class="line" colspan="#getMonths.recordCount*2 + 3#"></td></tr>
		</cfoutput>
	</table>
	
	</cf_divscroll>

	</td></tr>
		
	
	</table>
</cfif>

<cfset ajaxOnLoad("function() { doChangeVariation(); doHighlight(); }")>