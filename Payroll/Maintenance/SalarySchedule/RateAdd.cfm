<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

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

<table width="100%" bgcolor="white">

<tr><td valign="top">
	
	<cfform action="RateEditSubmit.cfm" method="POST" name="newrate" id="newrate">
	
		<table width="90%" align="center" class="formpadding formspacing">
									
			<tr><td class="labelmedium2" style="height:30px"><cf_tl id="Entity">:</td>
				<td class="labellarge" style="height:30px">#Scale.mission#</td>
			</tr>
			<tr><td class="labelmedium2" style="height:30px" height="25"><cf_tl id="Location">:</td>
			    <td class="labellarge" style="height:30px">
				
				<select name="servicelocation" class="regularxxl">
					<cfloop query="getlocation">
					<option value="#LocationCode#" <cfif scale.servicelocation eq locationcode>selected</cfif>>#description#</option>
					</cfloop>
				</select>
								
				</td>
			</tr>
			<tr><td class="labelmedium2"><cf_tl id="Scale effective">:</td>
			    <td>			
					<cf_intelliCalendarDate9
						FieldName="SalaryEffective" 
						Default="#Dateformat(Scale.SalaryEffective, CLIENT.DateFormatShow)#"
						AllowBlank="False"
						class="regularxxl">						
				</td>
			</tr>
			
			<tr class="line"><td style="padding-top:5px" colspan="2"></td></tr>
			
			<tr><td colspan="2" height="44" id="addrate">
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