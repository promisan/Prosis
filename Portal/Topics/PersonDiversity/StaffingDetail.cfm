<cfparam name="url.type" 	default="nationality">

<cfinclude template="StaffingPreparation.cfm">

<cfquery name="getStaffByCriteria" dbtype="query">
		SELECT  DISTINCT IndexNo, 
		        FullName, 
				Gender, 
				OrgUnitName, 
				PersonNo, 
				PostClass,
				NationalityName, 
				SalarySchedule,
				ContractLevel, 
				ContractLevelBudget,
				ContractLevelParent, 
				AppointmentType,
				PostGrade,
				ContractLevelOrder <cfif url.type eq "location">, locationName, locationCode</cfif>
		FROM	getStaff
		WHERE 	1=1
		<cfif url.type eq "nationality">
			AND 	ISOCODE2 = '#url.nationality#'
		</cfif>
		<cfif url.type eq "gender">
			<cfif url.id1 neq "">
				AND  ContractLevelParent = '#url.id1#'
			</cfif>
			<cfif url.id2 neq "">
				AND  Gender          = '#url.id2#' 
			</cfif>
		</cfif>
		<cfif url.type eq "location">
			<cfif url.id1 neq "">
				AND  ContractLevelParent = '#url.id1#'
			</cfif>
			<cfif url.id2 neq "">
				AND  LocationCode    = '#url.id2#' 
			</cfif>
		</cfif>

		ORDER BY ContractLevelParent,
		         ContractViewOrder,
				 ContractLevelBudgetOrder,
				 FullName ASC
</cfquery>

<cfset vColspan = 2>
<cfif url.type eq "nationality">
	<cfset vColspan = 1>
</cfif>

<table align="center" width="100%" height="100%">
	<tr>
		<td style="padding-left:15px;">
			<table width="100%" height="100%" class="formpadding navigation_table">
				<tr>
					<td colspan="<cfoutput>#vColspan#</cfoutput>" class="labellarge" style="font-size:155%;">
						<cfoutput>
							<cfif url.type eq "nationality">
								#ucase(getStaffByCriteria.NationalityName)#  <span style="font-size:60%;">[#ucase(url.nationality)#] [#numberformat(getStaffByCriteria.recordCount,",")#]</span>
							</cfif>
							<cfif url.type eq "gender">
								<cfset vGenderLabel = "">
								<cfif getStaffByCriteria.gender eq "M">
									<cf_tl id="Male" var="1">
									<cfset vGenderLabel = lt_text>
								</cfif>
								<cfif getStaffByCriteria.gender eq "F">
									<cf_tl id="Female" var="1">
									<cfset vGenderLabel = lt_text>
								</cfif>
								<cfif url.id2 eq "">
									<cf_tl id="All Genders" var="1">
									<cfset vGenderLabel = lt_text>
								</cfif>
								#ucase(vGenderLabel)#  <span style="font-size:60%;"> [#numberformat(getStaffByCriteria.recordCount,",")#]</span>
							</cfif>
							<cfif url.type eq "location">
								<cfset vLocationLabel = getStaffByCriteria.LocationName>
								<cfif getStaffByCriteria.LocationName eq "">
									<cfset vLocationLabel = getStaffByCriteria.LocationCode>
								</cfif>
								<cfif url.id2 eq "">
									<cf_tl id="All Locations" var="1">
									<cfset vLocationLabel = lt_text>
								</cfif>
								#ucase(vLocationLabel)#  <span style="font-size:60%;"><cfif url.id2 neq "">[#ucase(getStaffByCriteria.locationCode)#] </cfif>[#numberformat(getStaffByCriteria.recordCount,",")#]</span>
							</cfif>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<cfoutput>
						<td colspan="#vColspan-1#" class="labellarge">
							<cfinvoke component = "Service.Presentation.TableFilter"  
							   method           = "tablefilterfield" 
							   filtermode       = "direct"
							   name             = "filtersearch"
							   style            = "font:14px;height:25;width:160px;"
							   rowclass         = "clsFilterRow"
							   rowfields        = "ccontent">
						</td>
						<cfif url.type neq "nationality">
							<td align="right" style="padding-right:5px;" class="labelit">
								<a onclick="$('##detailArea').html('');" style="cursor:pointer;">[ <cf_tl id="Close"> ]</a>
							</td>
						</cfif>
					</cfoutput>
				</tr>
				<tr><td height="1" colspan="<cfoutput>#vColspan#</cfoutput>" style="border-top:1px solid #C0C0C0;"></td></tr>
				<tr><td height="3"></td></tr>
				<tr><td height="100%" colspan="<cfoutput>#vColspan#</cfoutput>">

					<cfif url.type eq "nationality">
					
						<cf_divscroll>
				
						<table width="100%" style="padding-right:10px">
							
							<cfoutput query="getStaffByCriteria" group="ContractLevelParent">
								<cfquery name="getStaffByCriteriaCount" dbtype="query">
									SELECT COUNT(*) AS Total
									FROM 	getStaffByCriteria
									WHERE 	ContractLevelParent = '#ContractLevelParent#'
								</cfquery>
								<cfset vParentCount = 0>
								<tr class="line">
									<td colspan="3" class="labelmedium" style="font-size:20px;font-weight:200">
										#ContractLevelParent# <span style="font-size:70%;">[#getStaffByCriteriaCount.Total#]</span>
									</td>
								</tr>
									<cfoutput>
										<cfset vParentCount = vParentCount + 1>
										<tr class="navigation_row line labelmedium clsFilterRow" style="height:20px">
											<td width="5%" valign="top" style="padding-top:1px;padding-right:4px">#vParentCount#.</td>
											<td class="ccontent navigation_action" valign="top" style="padding-top:1px;padding-right:4px" width="6%"> 
											   <a href="javascript:EditPerson('#personno#')">#IndexNo#</a>	
											</td>
											<td class="ccontent" style="padding-left:5px;">#FullName# #ContractLevel# <font color="gray">(#OrgUnitName#)</font></td>																									
										</tr>
									</cfoutput>	
								<tr><td height="8"></td></tr>
							</cfoutput>
												
						</table>
											
						</cf_divscroll>
						
					</cfif>
					
					<cfif url.type eq "gender" OR url.type eq "location">
						<table width="100%" style="padding-right:10px">
							<cfoutput query="getStaffByCriteria" group="ContractLevelParent">
								<tr class="line"><td colspan="8" class="labelmedium" style="font-size:20px;font-weight:200">
								    #ContractLevelParent#</td></tr>
									<cfoutput>
										<tr class="navigation_row line labelmedium clsFilterRow" style="height:20px">
											<td width="5%" valign="top" style="padding-top:1px;padding-right:4px">#currentrow#.</td>
											<td class="ccontent" style="min-width:50px;padding-left:5px;"><cfif SalarySchedule eq "NoPay"><font color="red"><cf_tl id="Unfunded"></font><cfelse>#ContractLevelBudget#</cfif></td>
											<td class="ccontent navigation_action" valign="top" style="padding-top:1px;padding-right:4px;width:100">
												<a href="javascript:EditPerson('#personno#')">#IndexNo#</a>	
											</td>												
											<td class="ccontent" style="padding-left:5px;">#FullName#</td>	
											<td class="ccontent" style="padding-left:5px;">#PostClass#</td>	
											<td class="ccontent" style="padding-left:5px;">#AppointmentType#</td>											
											<td class="ccontent" style="padding-left:5px;">#OrgUnitName#</td>	
											<td class="ccontent" style="min-width:50px;padding-left:5px;">#PostGrade#</td>														
										</tr>
									</cfoutput>	
								<tr><td height="8"></td></tr>
							</cfoutput>
												
						</table>
					</cfif>
				
				</td></tr>
				
				
			</table>
		</td>
	</tr>
</table>

<cfset ajaxOnLoad("doHighlight")>