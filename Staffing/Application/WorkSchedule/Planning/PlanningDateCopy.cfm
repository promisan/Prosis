
<cfquery name  = "getMandate" 
   	datasource= "AppsEmployee" 
    username  = "#SESSION.login#" 
	password  = "#SESSION.dbpw#">    
		SELECT	*
		FROM	Organization.dbo.Ref_Mandate
		WHERE	Mission = '#url.mission#'
		AND		MandateNo = '#url.mandate#'
</cfquery>

<table width="100%">
	<tr>
		<td style="background-color:red; color:white; padding:10px; height:50px;" valign="middle" class="labellarge"><cf_tl id="Save and Inherit"></td>
	</tr>
</table>
			  
<table width="93%" align="center">
	<tr><td height="25"></td></tr>
	<tr id="tr_CopyDetail">
		<td>
			<cfform name="frmInheritPlanning">
			<table width="100%" align="center">
				<tr>
					<td class="labelmedium" width="25%"><cf_tl id="Inherit every">:&nbsp;&nbsp;</td>
					<td width="10%">
						<cfoutput>
						<select name="everyNDays" id="everyNDays" class="regularxl">
							<cfloop index="i" from="1" to="365">
								<option value="#i#">#i#
							</cfloop>
						</select>
						</cfoutput>
					</td>
					<td width="70%" class="labelmedium"><cf_tl id="days"></td>
				</tr>
				<tr><td colspan="3" height="15"></td></tr>
				<tr>
					<td class="labelmedium"><cf_tl id="Up to date">:</td>
					<td colspan="2">
					
						<cfset date = CreateDate(Year(now()),12,31)> 
					   					
					    <cfif getMandate.DateExpiration gt date>						
							<cfset dte = date>
						<cfelse>
							<cfset dte = getMandate.DateExpiration>
						</cfif>
						
						<cf_intelliCalendarDate9
							FieldName="upToDate" 
							class="regularxl"
							Default="#dateformat(dte, CLIENT.DateFormatShow)#"
							AllowBlank="False">
					</td>
				</tr>
				<tr><td colspan="3" height="15"></td></tr>
				<tr>
					<td colspan="3" class="labelmedium"><cf_tl id="Include only the days">:</td>
				</tr>
				<tr><td colspan="3" height="15"></td></tr>
				<tr>
					<td colspan="3">
						<table width="100%" align="center">
							<tr>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Sun"></td>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Mon"></td>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Tue"></td>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Wed"></td>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Thu"></td>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Fri"></td>
								<td class="labelmedium" style="border:1px dotted #C0C0C0; padding:3px;" align="center"><cf_tl id="Sat"></td>
							</tr>
							<tr>
								<td style="height:30px;border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_1" name="day_1" checked></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_2" name="day_2" checked></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_3" name="day_3" checked></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_4" name="day_4" checked></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_5" name="day_5" checked></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_6" name="day_6" checked></td>
								<td style="border:1px dotted #C0C0C0;" align="center"><input class="radiol" type="Checkbox" id="day_7" name="day_7" checked></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			</cfform>
		</td>
	</tr>
	
	<tr><td height="10"></td></tr>
	<tr><td class="linedotted"></td></tr>
	<tr><td height="10"></td></tr>
			
	<tr><td align="center" style="padding-top:1px">
		
		<table cellspacing="0" class="formpadding">
		<tr>
			<td id="tdSaveAndInherit">
				<cf_tl id="This action will inherit this definition to the coming days. Do you want to continue ?" var="vMes">
				<cf_tl id="Save and Inherit" var="vVal3">
				<cfoutput>
				
				<input type="button" 
			         style="width:160;height:29" 
				     value="#vVal3#" 
				     name="inherit" 
					 id="inherit" 
					 class="button10g"
				     onclick="if (confirm('#vMes#')) { saveinheritedschedule('#url.workschedule#','#urlencodedformat(url.selecteddate)#','inherit', '#url.mission#', '#url.mandate#', document.getElementById('everyNDays').value, document.getElementById('day_1').checked, document.getElementById('day_2').checked, document.getElementById('day_3').checked, document.getElementById('day_4').checked, document.getElementById('day_5').checked, document.getElementById('day_6').checked, document.getElementById('day_7').checked, document.getElementById('upToDate').value); }">							 
					 
				</cfoutput>
			</td>
		</tr>
		</table>
	
	</td></tr>
</table>

<cfset ajaxOnLoad("doCalendar")>