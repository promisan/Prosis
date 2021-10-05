<cfset vDateEffective = createDate(year(now()), month(now()), day(now()))>
<cfif url.dateEffective neq "">
	<cfset dateValue = "">
	<cf_DateConvert Value="#url.dateEffective#">
	<cfset vDateEffective = dateValue>
</cfif>

<cfset vDateEffectiveString = dateFormat(vDateEffective, client.dateFormatShow)>

<cfquery name="get" 
     datasource="AppsPayroll" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT 	*	
		FROM 	PersonDistribution
		WHERE 	PersonNo = '#url.id#'	
		AND 	Operational = 1
		AND 	DateEffective = #vDateEffective#
</cfquery>

<cfform name="frmDistribution">
	
	<table width="100%" align="center">
		<tr>
			<td style="padding-left:5px;padding-top:8px" colspan="2">
				<table class="formpadding">
					<tr>
						<td class="labelmedium"><cf_tl id="Effective">:</td>
						<td style="padding-left:10px;">
							<cfset defaultStart = createDate(year(now()),1,1)>
							<cfset defaultEffective = now()>
							<cfif url.dateEffective neq "">
								<cfset defaultEffective = vDateEffective>
							</cfif>
							
							<!---
							DateValidStart="#dateformat(defaultStart, 'YYYYMMDD')#"
							---->
							
							<cf_intelliCalendarDate9
								FieldName="DateEffective"
								Message="Select a valid Effective Date"
								class="regularxl"
								Default="#dateformat(defaultEffective, CLIENT.DateFormatShow)#"
								Manual="False"
								AllowBlank="False">
						</td>
					</tr>
					
					<!---
					<tr>
						<td class="labellarge"><cf_tl id="Mode">:</td>
						<td style="padding-left:10px;">
							<select name="paymentmode" id="paymentmode" class="regularxl" style="font-size:15px; height:35px;" onchange="_doFilter(1, '#vDateEffectiveString#');">
								<option value="Transfer" <cfif get.paymentmode eq "Transfer">selected</cfif>><cf_tl id="Transfer"></option>
								<option value="Check" <cfif get.paymentmode eq "Check">selected</cfif>><cf_tl id="Check"></option>
								<option value="Cash" <cfif get.paymentmode eq "Cash">selected</cfif>><cf_tl id="Cash"></option>
							</select>
						</td>
					</tr>
					--->
					<tr>
						<td class="labelmedium"><cf_tl id="Method">:</td>
						<td style="padding-left:10px;">
							<select name="distributionMethod" id="distributionMethod" class="regularxl" style="width:140px;padding-left:16px;font-size:14px; height:25px;" onchange="_doFilter(1, '#vDateEffectiveString#');">
								<option value="Amount" <cfif get.distributionMethod eq "Amount">selected</cfif>><cf_tl id="Amount"></option>
								<option value="Percentage" <cfif get.distributionMethod eq "Percentage">selected</cfif>><cf_tl id="Percentage"></option>
							</select>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="5"></td></tr>

		<tr class="labelmedium2">
			<td colspan="2" style="padding-left:45px">
				<cfdiv id="divDetail">
			</td>
		</tr>

		<tr>
			<td align="center" colspan="2">
				<table>
					<tr>
						<td>
							<cf_tl id="Cancel" var="1">
							<cfoutput>
								<input type="button" name="btnCancel" value="#lt_text#" style="height:27px" class="button10g" onclick="reloadDist('view', '#vDateEffectiveString#');">
							</cfoutput>
						</td>
						<td style="padding-left:3px;">
							<cf_tl id="Save" var="1">
							<cfoutput>
								<input type="button" name="btnSave" value="#lt_text#" style="height:27px" class="button10g" onclick="ptoken.navigate('#session.root#/payroll/application/paymentDistribution/EmployeeDistributionSubmit.cfm?id=#url.id#&lines=#url.lines#&bigAmount=#url.bigAmount#','distributionProcess',null,null,'POST','frmDistribution');">
							</cfoutput>
						</td>
					</tr>
				</table>
			</td>
		</tr>

		<tr><td height="10"></td></tr>
		<tr><td align="center" id="distributionProcess" class="labellarge" colspan="2" style="color:#ED8282;"></td></tr>

	</table>

</cfform>

<cfset ajaxOnLoad("doCalendar")>
<cfset ajaxOnLoad("function(){ _doFilter(0, '#vDateEffectiveString#'); }")>