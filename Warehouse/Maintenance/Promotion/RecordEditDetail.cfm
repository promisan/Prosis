

<cfquery name="Get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Promotion
		<cfif url.id1 eq "">
			WHERE 	1=0
		<cfelse>
			WHERE 	PromotionId = '#URL.ID1#'
		</cfif>

</cfquery>

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&fmission=#url.fmission#" method="POST" name="frmPromotion">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
	
	<TR class="labelmedium">
    <TD height="28"><cf_tl id="Entity">:</TD>
    <TD>
		<cfif url.id1 neq "">
			<b>#get.Mission#</b>
			<input name="Mission" id="Mission" type="Hidden" value="#get.Mission#">
		<cfelse>
			<cfquery name="Mis" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission
				WHERE 	Mission IN (SELECT Mission 
	                  				FROM Organization.dbo.Ref_MissionModule 
					  				WHERE SystemModule = 'Warehouse')
			</cfquery>
	  	   
		    <cfselect name="Mission" class="regularxl" query="Mis" value="Mission" display="Mission" selected="#get.Mission#" required="Yes" message="Please, select a valid entity.">
			</cfselect>
		</cfif>
    </TD>
	</TR>
	
	<cfif url.id1 neq "">
		<TR class="labelmedium">
	    <TD height="28"><cf_tl id="Code">:</TD>
	    <TD><b>#get.promotionNo#</b>
	    </TD>
		</TR>
	</cfif>
	
	<TR class="labelmedium">
	    <TD><cf_tl id="Description">:</TD>
	    <TD>
	  	   
		    <cfinput type="text" 
		       name="Description" 
			   value="#get.Description#" 
			   message="Please enter a description." 
			   required="yes" 
			   size="50" 
		       maxlength="60" 
			   class="regularxl">
	    </TD>
	</TR>
	
	<TR class="labelmedium">
	    <TD><cf_tl id="Customer Label">:</TD>
	    <TD>
	  	   
		    <cfinput type="text" 
		       name="CustomerLabel" 
			   value="#get.CustomerLabel#" 
			   message="Please enter a customer label." 
			   required="no" 
			   size="50" 
		       maxlength="100" 
			   class="regularxl">
	    </TD>
	</TR>
	
	<TR class="labelmedium">
	    <TD><cf_tl id="Priority">:</TD>
	    <TD>
	  	   <table cellspacing="0" cellpadding="0" class="formspacing">
		   <tr class="labelmedium">
		   <td><input class="radiol" type="radio" name="Priority" <cfif get.Priority eq "1" or get.Priority eq "">checked</cfif> value="1"></td><td>1</td>
		   <td><input class="radiol" type="radio" name="Priority" <cfif get.Priority eq "2">checked</cfif> value="2"></td><td>2</td>
		   <td><input class="radiol" type="radio" name="Priority" <cfif get.Priority eq "3">checked</cfif> value="3"></td><td>3</td>
		   <td><input class="radiol" type="radio" name="Priority" <cfif get.Priority eq "4">checked</cfif> value="4"></td><td>4</td>
		   <td><input class="radiol" type="radio" name="Priority" <cfif get.Priority eq "5">checked</cfif> value="5"></td><td>5</td>
		   </tr>
		   </table>
	    </TD>
	</TR>
	
	<cfquery name="Schedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*, 
			    <cfif url.id1 neq "">
		        (SELECT count(*) 
				 FROM   PromotionSchedule 
				 WHERE  PromotionId = '#URL.ID1#' AND PriceSchedule = P.Code) as hasSchedule				
				<cfelse>
				0 as hasSchedule
				</cfif>
		FROM 	Ref_PriceSchedule P		
	</cfquery>
	
	<TR class="labelmedium">
	    <TD><cf_tl id="Schedule">:</TD>
	    <TD>
	  	   <table cellspacing="0" cellpadding="0" class="formspacing">
		   <tr class="labelmedium">
		   
		   <cfloop query="Schedule">
		   <td><input class="radiol" type="checkbox" name="PriceSchedule" <cfif hasSchedule eq "1">checked</cfif> value="#Code#"></td><td>#Description#</td>		   
		   </cfloop>
		 
		   </tr>
		   </table>
	    </TD>
	</TR>
	
	<tr class="labelmedium">
		<td><cf_tl id="Effective">:</td>
		<td>
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td style="position:relative; z-index:1;">
						<cfset vDateEffective = get.DateEffective>
						<cfif vDateEffective eq "">
							<cfset vDateEffective = now()>
						</cfif>
						<cf_intelliCalendarDate9
							FieldName="DateEffective"
							Message="Select a valid Effective Date"
							class="regularxl"
							Default="#dateformat(vDateEffective, CLIENT.DateFormatShow)#"
							AllowBlank="False">
					</td>
					<td width="3"></td>
					<td>
						<cfset vHour = "#timeFormat(get.DateEffective,'HH')#">
						<select name="TimeEffective_Hour" id="TimeEffective_Hour" class="regularxl">
							<cfloop from="0" to="23" index="cHour">
								<cfset sHour = cHour>
								<cfif cHour lt 10>
									<cfset sHour = "0" & sHour>
								</cfif>
								<option value="#sHour#" <cfif vHour eq sHour>selected</cfif>>#sHour#
							</cfloop>
						</select>
					</td>
					<td width="3">:</td>
					<td>
						<cfset vMinute = "#timeFormat(get.DateEffective,'mm')#">
						<select name="TimeEffective_Minute" id="TimeEffective_Minute" class="regularxl">
							<cfloop from="0" to="59" index="cMinute">
								<cfset sMinute = cMinute>
								<cfif cMinute lt 10>
									<cfset sMinute = "0" & sMinute>
								</cfif>
								<option value="#sMinute#" <cfif vMinute eq sMinute>selected</cfif>>#sMinute#
							</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td><cf_tl id="Expiration">:</td>
		<td>
			<table cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<cf_intelliCalendarDate9
							FieldName="DateExpiration"
							Message="Select a valid Expiration Date"
							class="regularxl"
							Default="#dateformat(get.DateExpiration, CLIENT.DateFormatShow)#"
							AllowBlank="True">
					</td>
					<td width="3"></td>
					<td>
						<cfset vHour = "#timeFormat(get.DateExpiration,'HH')#">
						<select name="TimeExpiration_Hour" id="TimeExpiration_Hour" class="regularxl">
							<cfloop from="0" to="23" index="cHour">
								<cfset sHour = cHour>
								<cfif cHour lt 10>
									<cfset sHour = "0" & sHour>
								</cfif>
								<option value="#sHour#" <cfif vHour eq sHour or (sHour eq "23" and url.id1 eq "") or (sHour eq "23" and get.DateExpiration eq "")>selected</cfif>>#sHour#
							</cfloop>
						</select>
					</td>
					<td width="3">:</td>
					<td>
						<cfset vMinute = "#timeFormat(get.DateExpiration,'mm')#">
						<select name="TimeExpiration_Minute" id="TimeExpiration_Minute" class="regularxl">
							<cfloop from="0" to="59" index="cMinute">
								<cfset sMinute = cMinute>
								<cfif cMinute lt 10>
									<cfset sMinute = "0" & sMinute>
								</cfif>
								<option value="#sMinute#" <cfif vMinute eq sMinute or (sMinute eq "59" and url.id1 eq "") or (sMinute eq "59" and get.DateExpiration eq "")>selected</cfif>>#sMinute#
							</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr class="labelmedium">
		<td><cf_tl id="Operational">:</td>
		<td>
		<table cellspacing="0" cellpadding="0" class="formspacing">
		   <tr class="labelmedium">
		   <td><input class="radiol" name="operational" id="operational" type="Radio" value="1" <cfif get.operational eq 1 or url.id1 eq "">checked</cfif>></td>
		   <td style="padding-left:4px">Yes</td>
		   <td style="padding-left:7px"><input class="radiol" name="operational" id="operational" type="Radio" value="0" <cfif get.operational eq 0>checked</cfif>></td>
		   <td style="padding-left:4px">No</td>
		   </tr>
		   </table>
		</td>
	</tr>
	
	<cfif url.id1 neq "">
	<tr class="labelmedium">
		<td height="23"><cf_tl id="Created">:</td>
		<td>#get.OfficerFirstName# #get.OfficerLastName# @ #Dateformat(get.Created, "#CLIENT.DateFormatShow#")#</td>
	</tr>
	</cfif>
		
	</cfoutput>
	
	<tr><td height="3"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="3"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">
		<cf_tl id="Save" var="vSave">
		<cfoutput>
	    	<input class="button10g" style="height:25" type="submit" name="Save" id="Save" value="#vSave#" onclick="return validateFields();">
		</cfoutput>
	</td>	
	</tr>
	
</TABLE>

</cfform>
	
<cf_screenbottom layout="innerbox">

<cfset ajaxonload("doCalendar")>
