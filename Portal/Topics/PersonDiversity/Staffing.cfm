
<!--- filter by owner of the position --->

<cfparam name="url.orgunit"     default="">
<cfparam name="url.cstf"        default="">
<cfparam name="url.postclass"   default="">
<cfparam name="url.category"    default="100">
<cfparam name="url.authorised"  default="">
<cfparam name="url.period"      default="">

<cf_tl id="View Person" var="lblViewPerson">

<cfinclude template="StaffingPreparation.cfm">

<cfif getStaff.recordcount eq "0">

<table align="center"><tr  style="height:30px"><td style="font-weight:200" class="labelmedium" align="center"><font color="800040"><cf_tl id="There are no records found to show in this view"></td></tr></table>

<cfelse>
		
	<table width="98%" border="0" class="navigation_table" align="center">
	
	<tr class="line">
	
		<td align="right" style="width:50%;border:0px solid silver;">		    
			<cfinclude template="StaffingGender.cfm">				
		</td>
		
		<td align="center" valign="top" style="padding-left:4px;border:0px solid silver">
		    <cfinclude template="StaffingDutyStation.cfm">
		</td>
	
	</tr>

	<tr>
		<td colspan="2" id="detailArea"></td>
	</tr>
	
	<tr style="border-top:1px solid silver">
	
	<td colspan="2" align="center" style="border:0px solid silver;height:70px;">
							
		<cfif url.mission eq "STL" and (url.cstf eq "All" or url.cstf eq "") and url.orgunit eq "">			
			<cfinclude template="StaffingNationalitySTL.cfm">
		<cfelse>				
			<cfinclude template="StaffingNationality.cfm">
		</cfif>			
		
	</td>
	</tr>	
	
	<cfif url.orgunit eq "">
		
		<cfquery name="getAppointment" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">	
		  SELECT    PC.PersonNo, 
		  		    P.IndexNo,
					P.FullName,
		            P.LastName, 
					P.FirstName, 
					PC.SalarySchedule,
					PC.ContractLevel, 
					PC.ContractStep, 
					PC.ContractFunctionNo, 
					PC.ContractFunctionDescription, 
					PC.DateEffective, 
                    PC.DateExpiration, PC.ActionStatus
		  FROM      PersonContract AS PC INNER JOIN
                    Person AS P ON PC.PersonNo = P.PersonNo
		  WHERE     PC.Mission      = '#mission#' 
		  AND       PC.ActionStatus IN ('0','1') 
		  AND       PC.DateEffective > #prior# 
		  AND       PC.DateEffective <= #dt# 
		  <cfif url.cstf neq "">
			<cfif find("TPE_",url.cstf)>			    
				AND          PC.ContractLevel IN (SELECT PostGrade 
				                                  FROM Ref_PostGrade G
												       INNER JOIN Ref_PostGradeParent R ON G.PostGradeParent = R.Code 
											      WHERE PostType = '#right(url.cstf,len(url.cstf)-4)#')			
			<cfelse>
				AND          PC.ContractLevel IN (SELECT PostGrade FROM Ref_PostGrade WHERE PostGradeParent = '#url.cstf#')
			</cfif>
		</cfif>	
		
		  AND       PC.ActionCode IN ('3000','3022')  <!--- initial and reappointments --->
		</cfquery>  
	
		<!--- we do a global view --->
		
		<tr><td colspan="2" class="line" style="height:20px;font-size:24px" align="left"><cf_tl id="Person contract"></td></tr>
		
		<tr><td colspan="2"><table width="100%">
			
			<tr style="border-top:1px solid silver">
					
				<td align="center" style="width:33%;border-right:1px solid silver;height:140px">
				
					<table width="100%" height="100%">
						<tr class="line fixlenthlist" style="height:20px">
						    <td colspan="2" class="labelmedium" style="height:22px" align="center"><cf_tl id="Newly appointed staff"><cfoutput>#url.mission#</cfoutput></td>
						</tr>
						<tr>
							<td colspan="2" valign="top" align="center" style="height:160px">
							    <cf_divscroll>
								<table width="98%" align="center" class="formpadding navigation_table">
									<tr><td height="6"></td></tr>
									
									<cfoutput query="getAppointment">
										<tr class="navigation_row labelmedium line" style="height:15px">
										     <td>#currentrow#</td>
											<td style="padding-left:4px;min-width:70"><a href="javascript:EditPerson(#PersonNo#,'','');" style="color:##0695C4;" title="#lblViewPerson#">#IndexNo#</a>&nbsp;#FullName#<font size="1">&nbsp;#ContractFunctionDescription#</font><cfif SalarySchedule eq "NoPay"><font color="red"><cf_tl id="Unfunded"><cfelse>#ContractLevel#</cfif></td>
											<td>#dateFormat(DateEffective, client.dateFormatShow)#</td>
											<td style="padding-left:4px"><cfif actionStatus eq "0"><font color="FF0000"><cf_tl id="P"></cfif></td>
										</tr>
									</cfoutput>
									
								</table>
								</cf_divscroll>
							</td>
						</tr>
					</table>	
				
				</td>
													
				<td align="center" style="width:33%;border-right:1px solid silver;height:140px;;padding-left:5px;padding-right:5px">
				
				<cfquery name="getSeparation" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">	
				  SELECT    PC.PersonNo, 
				  		    P.IndexNo,
							P.FullName,
				            P.LastName, 
							P.FirstName, 
							PC.SalarySchedule,
							PC.ContractLevel, 
							PC.ContractStep, 
							PC.ContractFunctionNo, 
							PC.ContractFunctionDescription, 
							PC.DateEffective, 
		                    PC.DateExpiration, PC.ActionStatus
				  FROM      PersonContract AS PC INNER JOIN
		                    Person AS P ON PC.PersonNo = P.PersonNo
				  WHERE     PC.Mission = '#mission#' 
				  AND       PC.ActionStatus IN ('0', '1') 
				  AND       PC.DateEffective > #prior# 				  
				  AND       PC.DateEffective <= #dt# 
				<cfif url.cstf neq "">
					<cfif find("TPE_",url.cstf)>			    
						AND          PC.ContractLevel IN (SELECT PostGrade 
				                                  FROM Ref_PostGrade G
												       INNER JOIN Ref_PostGradeParent R ON G.PostGradeParent = R.Code 
											      WHERE PostType = '#right(url.cstf,len(url.cstf)-4)#')			
					<cfelse>
						AND          PC.ContractLevel IN (SELECT PostGrade FROM Ref_PostGrade WHERE PostGradeParent = '#url.cstf#')
					</cfif>
				</cfif>	
				  AND       PC.ActionCode IN ('3006')  <!--- separation action --->
				</cfquery>  
				
				<table width="100%" height="100%">
					<tr class="line" style="height:20px">
					    <td colspan="2" class="labelmedium" align="center"><cf_tl id="Staff with Separation action"><cfoutput>#url.mission#</cfoutput></td>
					</tr>
					<tr>
						<td colspan="2" valign="top" align="center" style="height:170px">
						    <cf_divscroll>
							<table width="98%" align="center" class="formpadding navigation_table">
								<tr><td height="6"></td></tr>
								
								<cfoutput query="getSeparation">
									<tr class="navigation_row labelmedium line fixlengthlist" style="height:15px">
									     <td>#currentrow#</td>
										<td title="#fullname#" style="padding-left:4px;min-width:70"><a href="javascript:EditPerson(#PersonNo#,'','');" style="color:##0695C4;" title="#lblViewPerson#">#IndexNo#</a>&nbsp;#FullName#&nbsp;<font size="1">#ContractFunctionDescription#</font><cfif SalarySchedule eq "NoPay"><font color="red"><cf_tl id="Unfunded"><cfelse>#ContractLevel#</cfif></td>										
										<td>#dateFormat(DateEffective, client.dateFormatShow)#</td>
										<td style="padding-left:4px"><cfif actionStatus eq "0"><font color="FF0000"><cf_tl id="P"></cfif></td>
									</tr>
								</cfoutput>
								
							</table>
							</cf_divscroll>
						</td>
					</tr>
				</table>	
				
				</td>
				
				<cfset vCurrentPersons = ListQualify(valueList(getStaff.PersonNo), "'")>				
				<cfset vSeparation     = ListQualify(valueList(getSeparation.PersonNo), "'")>
				
				<cfquery name="getOutgoing" dbtype="query">
					SELECT 	DISTINCT PersonNo,
							IndexNo,
							FullName,
							OrgUnitName,
							ParentOrgUnitName,
							PostGrade,
							SalarySchedule,
							ContractLevel,
							DateEffective,
							DateExpiration
					FROM 	[getPriorMonth]
					WHERE 	PersonNo NOT IN (#preserveSingleQuotes(vCurrentPersons)#)
					<cfif vSeparation neq "">
					AND     PersonNo NOT IN (#preserveSingleQuotes(vSeparation)#)
					</cfif>
				</cfquery>				
				
				<td align="center" style="width:33%;border:0px solid silver;height:140px;padding-left:5px;padding-right:5px">
				
					<table width="98%" height="100%">
						<tr class="line" style="height:20px">
						    <td colspan="2" class="labelmedium" align="center"><cf_tl id="Other Staff Expiring"><cfoutput>#url.mission#</cfoutput></td>
						</tr>
						<tr>
							<td colspan="2" valign="top" align="center" style="height:170px">
							    <cf_divscroll>
								<table width="98%" align="center" class="formpadding navigation_table">
									<tr><td height="6"></td></tr>
									
									<cfoutput query="getOutgoing">
										<tr class="navigation_row labelmedium line fixlengthlist" style="height:15px">
										     <td>#currentrow#</td>
											<td title="#fullname#" style="padding-left:4px;min-width:70"><a href="javascript:EditPerson('#PersonNo#','','');" style="color:##0695C4;" title="#lblViewPerson#">#IndexNo#</a>&nbsp;#FullName#</td>											
											<td style="min-width:50;padding-right:4px"><cfif SalarySchedule eq "NoPay"><font color="red"><cf_tl id="Unfunded"><cfelse>#ContractLevel#</cfif></td>										
											<td>#dateFormat(DateEffective, client.dateFormatShow)#</td>											
										</tr>
									</cfoutput>
									
								</table>
								</cf_divscroll>
							</td>
						</tr>
					</table>	
				
				</td>
					
			</tr>		
			
			</table>
			
		</td></tr>	
		
	 </cfif>
	 
	 <cfif url.orgunit neq "">
	 
	 <tr><td colspan="2" class="line" style="font-weight:300;font-size:24px;height:40px" align="left"><cf_tl id="Staff movements"><cfoutput>#get.OrgUnitName#</cfoutput></td></tr>
	
		<cfif getPriorMonth.recordcount neq "0" and getStaff.recordcount neq "">
			
			<cfset vCurrentPersons = ListQualify(valueList(getStaff.PersonNo), "'")>
			<cfset vPriorPersons   = ListQualify(valueList(getPriorMonth.PersonNo), "'")>
			
			<cfquery name="getIncoming" dbtype="query">
				SELECT 	PersonNo,
						IndexNo,
						FullName,
						OrgUnitName,
						ParentOrgUnitName,
						PostGrade,
						SalarySchedule,
						ContractLevel,
						DateEffective,
						DateExpiration
				FROM 	[getStaff]
				WHERE 	PersonNo NOT IN (#preserveSingleQuotes(vPriorPersons)#)
			</cfquery>
			
			<tr style="border-top:1px solid silver">
						
			<td align="center" style="width:50%;border-right:1px solid silver;height:140px;padding:2px">
			
			<table width="100%" height="100%">
				<tr class="line" style="height:20px">
				    <td colspan="2" class="labelmedium" align="center"><cf_tl id="Incoming"></td>
				</tr>
				<tr>
					<td colspan="2" valign="top" align="center" style="height:170px">
					    <cf_divscroll>
						<table width="98%" align="center" class="formpadding navigation_table">
							<tr><td height="2"></td></tr>
							<!---
							<tr class="line labelit">
								<td><cf_tl id="Index No."></td>
								<td><cf_tl id="Name"></td>
								<td><cf_tl id="Office"></td>
								<td><cf_tl id="Grade"></td>
								<td><cf_tl id="Arrival"></td>
							</tr>
							--->
							<cfoutput query="getIncoming">
							
								<cfquery name="getFrom" dbtype="query">
									SELECT 	OrgUnitName,
											ParentOrgUnitName										
									FROM 	getPriorMonthAll
									WHERE 	PersonNo = '#PersonNo#'								
								</cfquery>
							
							
								<tr class="navigation_row labelmedium line fixlengthlist" style="height:15px">
								    <td style="min-width:30">#currentrow#</td>
									<td title="#fullname#" style="min-width:70"><a href="javascript:EditPerson('#PersonNo#','','');" style="color:##0695C4;" title="#lblViewPerson#">#IndexNo#</a>#FullName#</td>									
									<td><cfif getFrom.recordcount eq "0"><i><font color="808080"><cf_tl id="external"><cfelse>#getFrom.ParentOrgUnitName#</cfif></td>
									<td style="min-width:50" style="padding-right:4px"><cfif SalarySchedule eq "NoPay"><font color="red"><cf_tl id="Unfunded"><cfelse>#ContractLevel#</cfif></td>
									<td style="padding-left:4px">#dateFormat(DateEffective, client.dateFormatShow)#</td>
								</tr>
							</cfoutput>
						</table>
						</cf_divscroll>
					</td>
				</tr>
			</table>	
			
			</td>
			
			<cfquery name="getOutgoing" dbtype="query">
				SELECT 	PersonNo,
						IndexNo,
						FullName,
						OrgUnitName,
						ParentOrgUnitName,
						PostGrade,
						ContractLevel,
						SalarySchedule,
						DateEffective,
						DateExpiration
				FROM 	[getPriorMonth]
				WHERE 	PersonNo NOT IN (#preserveSingleQuotes(vCurrentPersons)#)
			</cfquery>
			
			<td align="center" style="width:50%;border:0px solid silver;height:140px;padding:2px">
			
			<table width="100%" height="100%">
				<tr class="line" style="height:20px">
				    <td colspan="2" class="labelmedium" align="center"><cf_tl id="Outgoing"></td>
				</tr>
				<tr>
					<td colspan="2" valign="top" align="center" style="height:170px">
					    <cf_divscroll>
						<table width="98%" align="center" class="formpadding navigation_table">
							<tr><td height="2"></td></tr>
							<!---
							<tr class="line labelit">
								<td><cf_tl id="Index No."></td>
								<td><cf_tl id="Name"></td>
								<td><cf_tl id="Office"></td>
								<td><cf_tl id="Grade"></td>
								<td><cf_tl id="Departure"></td>
							</tr>
							--->
							<cfoutput query="getOutgoing">
							
								<tr class="navigation_row labelmedium line" style="height:15px">
									 <td>#currentrow#</td>
									<td><a href="javascript:EditPerson('#PersonNo#','','');" style="color:##0695C4;" title="#lblViewPerson#">#IndexNo#</a></td>
									<td>#FullName# / #ParentOrgUnitName#</td>
									<td></td>
									<td style="min-width:50" style="padding-right:4px"><cfif SalarySchedule eq "NoPay"><font color="red"><cf_tl id="Unfunded"><cfelse>#ContractLevel#</cfif></td>
									<td>#dateFormat(DateExpiration, client.dateFormatShow)#</td>
								</tr>
							</cfoutput>
						</table>
						</cf_divscroll>
					</td>
				</tr>
			</table>	
			
			</td>
			
			</tr>
		
		</cfif>
		
			
	</cfif>
	
	
	</table>
	
</cfif>

<cfset vDataList = "">
<cfquery name="getMapData" dbtype="query">
		SELECT   ISOCODE2,
			   	 COUNT(DISTINCT PersonNo) AS CountPersons
		FROM	 getStaff
		GROUP BY ISOCODE2
</cfquery>

<cfoutput query="getMapData">
	<cfset vDataList = vDataList & "{id:'#ISOCODE2#', value:#CountPersons#}">
	<cfif currentrow neq recordCount>
		<cfset vDataList = vDataList & ", ">
	</cfif>
</cfoutput>

<cfquery name="getMax" dbtype="query">
	SELECT 	MAX(CountPersons) as MaxValue
	FROM 	getMapData
</cfquery>

<cfquery name="getTotal" dbtype="query">
	SELECT 	SUM(CountPersons) as Total
	FROM 	getMapData
</cfquery>

<cf_tl id="Employees" var="vLblEmployee">
<cf_tl id="out of" var="vLblOutOf">	

<cfset ajaxOnLoad("function(){  resetMap_1('0', '#getMax.maxValue#', '<span style=\'font-size:14px;\'><b>[[title]]</b>: [[value]]/#getTotal.Total# #vLblEmployee#</span>', [#vDataList#]); }")>

<cfset ajaxOnLoad("doHighlight")>