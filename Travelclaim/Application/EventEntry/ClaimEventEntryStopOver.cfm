<!--
    Copyright © 2025 Promisan B.V.

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

<cfquery name="TripArrival" 
	datasource="appsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 *
    FROM ClaimEventTrip T,  System.dbo.Ref_Nation R 
    WHERE ClaimEventId = '#URL.ID1#'
	AND   T.LocationCountry = R.Code
	<cfif #TripId# neq "">
	AND ClaimTripId != '#tripid#'
	</cfif>
	ORDER BY LocationDate DESC
</cfquery>	

<table width="100%" border="0" cellspacing="0" cellpadding="1">
			<tr>
				<td colspan="2" align="center" bgcolor="f4f4f4">Arrival</td>
			</tr>
			<tr><td colspan="2" bgcolor="silver"></td></tr>
			<tr><td colspan="2"></td></tr>
			<tr>
				<td width="70" height="25"><b>&nbsp;Date:</td>
				<td>
				
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td>
				
				    <cfif TripDeparture.recordcount eq "0">
					
						<cfif TripRequest.DateDeparture eq "">
																						
						 <cf_intelliCalendarDate
						FieldName="ArrivalDate" 
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">	
						
						<cfelse>
						
						<cfif dd eq "">
						
							 <cf_intelliCalendarDate
						FieldName="ArrivalDate" 
						Default="#Dateformat(TripRequest.DateDeparture, CLIENT.DateFormatShow)#"
						AllowBlank="False">	
						
						<cfelse>
						
							 <cf_intelliCalendarDate
						FieldName="ArrivalDate" 
						Default="#dd#"
						AllowBlank="False">	
						
						</cfif>
						
						</cfif>
					
					<cfelse>
					
						 <cf_intelliCalendarDate
						FieldName="ArrivalDate" 
						Default="#Dateformat(TripArrival.LocationDate, CLIENT.DateFormatShow)#"
						AllowBlank="False">	
					
					</cfif>
					
					<cfset thr  = #Timeformat(TripArrival.LocationDate, "HH")#>
					<cfset tmin = #Timeformat(TripArrival.LocationDate, "MM")#>
					
					</td>
					<td height="25"><b>&nbsp;Hour:</td>
				    <td>
					<select name="ArrivalHour">
					<cfloop index="hr" list="#hour#" delimiters=",">
					<option value="#hr#" <cfif #hr# eq "#thr#"> selected</cfif>>#hr#</option>
					</cfloop>
					</select>
				    </td>
				    <td height="25"><b>&nbsp;Min:</td>
				    <td>
					<select name="ArrivalMinute">
					<cfloop index="min" list="00,15,30,45" delimiters=",">
					<option value="#hr#" <cfif #min# eq "#tmin#"> selected</cfif>>#min#</option>
					</cfloop>
					</select>
				    </td>
								
				</tr>
					
				</table>
					
				</td>
			</tr>
						
			<tr><td colspan="2" bgcolor="E5E5E5"></td></tr>
			
			<tr>
				<td height="25"><b>&nbsp;Country:</td>
				<td>
				
				<input type="text"   name="arrcountryname"  value="#TripArrival.Name#" size="30" maxlength="30" disabled class="regular">
				<INPUT type="hidden" name="arrcountry"      value="#TripArrival.LocationCountry#">
			    
				<img src="#SESSION.root#/Images/locate.jpg" 
				  alt    = "Search for city" 
				  name   = "img2" 
				  onMouseOver= "document.img2.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut = "document.img2.src='#SESSION.root#/Images/locate.jpg'"
				  style  = "cursor: hand;" 
				  width  = "16" 
				  height = "18" 
				  border = "0" 
				  align  = "absmiddle" 
				  onClick="selectcity('entry','arrcityid','arrcountry','arrcountryname','arrcity','arrcode','1')">
					
			</tr>
			<tr><td colspan="2" bgcolor="E5E5E5"></td></tr>
			
			<tr>
				<td height="25"><b>&nbsp;City:</td>
				<td>
				
				<input type="text"   name="arrcity"   value="#TripArrival.LocationCity#" size="50" maxlength="80" readonly class="regular">
				<INPUT type="hidden" name="arrcityid" value="#TripArrival.CountryCityId#">
				<INPUT type="hidden" name="arrcode"   value="#TripArrival.LocationCode#">
		
								
			</tr>
								
</table>

</cfoutput>		
			