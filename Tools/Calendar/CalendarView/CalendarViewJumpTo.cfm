<cf_tl id="Jump To Date" var="vTitle">

<cfoutput>

<table width="100%" height="100%" cellspacing="0" cellpadding="0">

<tr><td bgcolor="white">

	<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		<!--- <tr><td height="20" colspan="2" class="labellarge">#vTitle#</td></tr> --->
	  
		<tr>
			
			<td colspan="2" align="center" style="padding-top:8px;height:165;width:200;border:0px solid silver">
			    				
				<cfform name="calendarJump">				
				
					<cf_intelliCalendarDate9
					    class="regularxl"
						FieldName="calendarJumpToDate"
						Inline="true"
						Default="#dateformat(now(), '#CLIENT.DateFormatShow#')#"
						AllowBlank="False">
												
				</cfform>				
				
			</td>
		</tr>
				
		<tr>
			<td colspan="2" align="center" style="height:50">
				
					<input type="button" style="width:150px;height:24" name="btnCalendarJumpTo" id="btnCalendarJumpTo" value="Go to date" class="button10g" onclick="calendarDoJumpTo(document.getElementById('calendarJumpToDate').value);">
				
			</td>
		</tr>
	</table>

</td></tr>

</table>

<cfset AjaxOnLoad("doCalendar")>

</cfoutput>