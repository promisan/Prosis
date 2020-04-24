
<cfoutput>

<cfquery name="Scale"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     SalaryScale
	WHERE    ScaleNo    = '#URL.ScaleNo#'	  					
</cfquery>

<cfquery name="getLocation"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	* 
	FROM    Ref_PayrollLocation R
	WHERE   LocationCode IN (SELECT LocationCode
	                         FROM   Ref_PayrollLocationMission 
							 WHERE  Mission = '#scale.mission#')	  					
</cfquery>

<table width="100%" height="100%" bgcolor="white">

<tr><td height="14"></td></tr>

<tr><td valign="top">
	
	<cfform action="RateEditSubmit.cfm" method="POST" name="newrate" id="newrate">
	
		<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
									
			<tr><td class="labelmedium" style="height:30px"><cf_tl id="Entity">:</td>
				<td class="labellarge" style="height:30px">#Scale.mission#</td>
			</tr>
			<tr><td class="labelmedium" style="height:30px" height="25"><cf_tl id="Location">:</td>
			    <td class="labellarge" style="height:30px">
				
				<select name="servicelocation" class="regularxl">
					<cfloop query="getlocation">
					<option value="#LocationCode#" <cfif scale.servicelocation eq locationcode>selected</cfif>>#description#</option>
					</cfloop>
				</select>
								
				</td>
			</tr>
			<tr><td class="labelmedium"><cf_tl id="Scale effective">:</td>
			    <td>			
					<cf_intelliCalendarDate9
						FieldName="SalaryEffective" 
						Default="#Dateformat(Scale.SalaryEffective, CLIENT.DateFormatShow)#"
						AllowBlank="False"
						class="regularxl">						
				</td>
			</tr>
			<tr><td height="10"></td></tr>
			
			<tr><td class="line" colspan="2"></td></tr>
			
			<tr><td height="10"></td></tr>			
			
			<tr><td colspan="2" align="center" height="24" id="addrate">
				<input name="Add" onclick="ptoken.navigate('RateAddSubmit.cfm?scaleno=#URL.ScaleNo#','addrate','','','POST','newrate')" 
				  value="Create" type="button" style="width:140px;height:30px;font-size:17px" class="button10g"/>
			</td>
		</tr>	
		
		</table>

	</cfform>
	
</td></tr>

</table>

<cfset ajaxOnLoad("doCalendar")>


</cfoutput>