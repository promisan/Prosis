<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Load Trigger" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<script>

	function toggleDate(control) {
		if (control.value == 'Month') 
		{
			document.getElementById('tMonth').className = 'regular';
			document.getElementById('tPeriod').className = 'hide';
		}
		
		if (control.value == 'Period') 
		{
			document.getElementById('tMonth').className = 'hide';
			document.getElementById('tPeriod').className = 'regular';
		}
		
	}
	
</script>

<cfform action="RecordSubmit.cfm" method="POST" name="frmLoadTrigger">

<table width="95%" cellspacing="4" cellpadding="4" align="center" class="formpadding formspacing">
		

	<tr><td height="6"></td></tr>
    <TR class="labelmedium">
    <TD width="20%">Service Item:</TD>
    <TD>
		<cfquery name="Lookup" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT	I.*,
					C.Description as ServiceClassDescription,
					(I.Code + ' - ' + I.Description) as ServiceItemDisplay
			FROM	ServiceItem I
					INNER JOIN ServiceItemClass C
						ON I.ServiceClass = C.Code
			WHERE	SelfService = 1
		</cfquery>

  	   	<cfselect name="ServiceItem" class="regularxl" query="Lookup" display="ServiceItemDisplay" group="ServiceClassDescription" value="Code"></cfselect>
		
    </TD>
	</TR>
	
	<TR>
    <TD>Scope:</TD>
    <TD>
  	   <select name="LoadScope" class="regularxl" id="LoadScope">
	   		<option value="all">All
			<option value="missing">Missing
	   </select>
    </TD>
	</TR>
	
	<TR>
    <TD>Load Mode:</TD>
    <TD>
  	   <select name="LoadMode" class="regularxl" id="LoadMode" onchange="javascript: toggleDate(this);">
	   		<option value="Month">Month
			<option value="Period">Period
	   </select>
    </TD>
	</TR>
	
	<TR>
    	<TD colspan="2">
		
			<table width="100%" align="center" id="tMonth">
				<tr class="labelmedium">
				<td width="20%">Month:</td>
				<td>
					<table>
						<tr>
							<td>
								<select name="month" id="month" class="regularxl">
									<option value="1" <cfif datePart('m',now()) eq 1>selected</cfif>>January
									<option value="2" <cfif datePart('m',now()) eq 2>selected</cfif>>February
									<option value="3" <cfif datePart('m',now()) eq 3>selected</cfif>>March
									<option value="4" <cfif datePart('m',now()) eq 4>selected</cfif>>April
									<option value="5" <cfif datePart('m',now()) eq 5>selected</cfif>>May
									<option value="6" <cfif datePart('m',now()) eq 6>selected</cfif>>June
									<option value="7" <cfif datePart('m',now()) eq 7>selected</cfif>>July
									<option value="8" <cfif datePart('m',now()) eq 8>selected</cfif>>August
									<option value="9" <cfif datePart('m',now()) eq 9>selected</cfif>>September
									<option value="10" <cfif datePart('m',now()) eq 10>selected</cfif>>October
									<option value="11" <cfif datePart('m',now()) eq 11>selected</cfif>>November
									<option value="12" <cfif datePart('m',now()) eq 12>selected</cfif>>December
								</select>
							</td>
							<td>&nbsp;-&nbsp;</td>
							<td>
								<cfoutput>
								<select name="year" id="year" class="regularxl">
									<cfloop index="itemyear" from="#datePart("yyyy",now()) - 2#" to="#datePart("yyyy",now()) + 2#">
										<option value="#itemyear#" <cfif datePart('yyyy',now()) eq itemyear>selected</cfif>>#itemyear#
									</cfloop>
								</select>
								</cfoutput>
							</td>
						</tr>
					</table>
				</td>
				</tr>
			</table>
			
			<cf_calendarscript>
			
			<table width="100%" align="center" id="tPeriod" class="hide">
				<tr class="labelmedium">
				<td width="20%">Period:</td>
				<td>
					<table>
						<tr>
							<td>
								<cf_intelliCalendarDate9
									FieldName="SelectionDateStart"
									Tooltip="Start"
									class="regularxl"
									Message="Select a valid start date"
									Default="#dateformat(now(), CLIENT.DateFormatShow)#"
									AllowBlank="False">
							</td>
							<td>&nbsp;-&nbsp;</td>
							<td>
								<cf_intelliCalendarDate9
									FieldName="SelectionDateEnd"
									Tooltip="End"
									class="regularxl"
									Message="Select a valid end date"
									Default="#dateformat(now(), CLIENT.DateFormatShow)#"
									AllowBlank="False">
							</td>
						</tr>
					</table>
				</td>
				</tr>
			</table>
  	  
	    </TD>
	</TR>
	<tr class="labelmedium">
	    <TD>Memo:</TD>
	    <TD style="padding-left:3px">
			<cfinput type="Text" name="Memo" class="regularxl" required="No" size="55" maxlength="200">			
	  	</TD>	
	
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Save" id="Save" value="Save">
	</td>	
	
	</tr>
		
	
</table>

</CFFORM>
	
<cf_screenbottom layout="innerbox">
