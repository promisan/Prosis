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
<cfsilent>
 	<proOwn>Huda Seid</proOwn>
	<proDes>Changed the expression on line 13. Just made grammatical changes as per gloria's request </proDes>
	<proCom> As of 15/01/08</proCom>
</cfsilent>
<cfset bullet = "bullet.png">
	
<cfoutput>

	<table width="100%">
	
	<tr>
	<td>	
		&nbsp;The <b><font color="0080FF">Express Claim</font></b> option creates an expense claim based on your travel authorization. To use this option means that:
	</td>
	<td align="right"><img src="#SESSION.root#/Images/step1.gif" alt="" border="0"></td>
	</tr>
	<tr><td height="4"></td></tr>
	<tr>
	<td colspan="2">
	<table width="98%" align="center" border="1" frame="hsides" cellspacing="5" cellpadding="5" bordercolor="silver" rules="none">
				  
		<tr>
		<td width="30"> 
		<img align="absmiddle" src="#SESSION.root#/Images/#bullet#" order="0">
		</td>
		<td>
		You travelled (by air or train) as per the authorized itinerary in the Travel Request. 
		</td>
		<td></td>
		</tr> 
	
		<tr>
		<td> 
		<img align="absmiddle" src="#SESSION.root#/Images/#bullet#" order="0">
		</td>
		<td>
		Your claim is limited to <b>DSA and/or Terminal Expenses</b>.
		</td>
		<td></td>
		</tr>
		<!-----------------------------HS 15/10/2008: Removed the condition to display Hazard pay-------------------------------
		<cfquery name="MSA" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     TOP 1 *
		FROM         ClaimRequestItinerary Itin INNER JOIN
                      Ref_CountryCity City ON Itin.CountryCityId = City.CountryCityId INNER JOIN
                      Ref_CountryCityLocation CityLoc ON City.CountryCityId = CityLoc.CountryCityId INNER JOIN
                      Ref_ClaimRates MSA ON CityLoc.LocationCode = MSA.ServiceLocation
		WHERE     (MSA.ClaimCategory = 'MSA')
		AND ClaimRequestId = '#Claim.ClaimRequestId#' 
		</cfquery>
		
		<cfif MSA.recordcount eq "1">
		------------------------------------------------------------------------------------------------------->
		<tr>
	   				<td> 
						<img align="absmiddle" src="#SESSION.root#/Images/#bullet#" order="0">
						
						
					</td>
					<td colspan="2">
					<table><tr><td><B>Hazard Pay</B> is not applicable</td><td><cf_helpfile code    = "TravelClaim" class   = "Indicator" id      = "ERO1" display = "icon"></td></tr></table>
						
					</td>
					<td></td>
				
		</tr>
		<tr><td> 
		<img align="absmiddle" src="#SESSION.root#/Images/#bullet#" order="0">
		</td>
		<td>
		Leave <b>was not</b> taken within the authorized itinerary.  
		</td>
		<td></td>
		</tr>
		
		<tr><td> 
		<img align="absmiddle" src="#SESSION.root#/Images/#bullet#" order="0">
		</td>
		<td >
		An <b>ad-hoc DSA</b> rate has <b>not</b> been requested for this travel.  
		</td>
		<td></td>
		</tr>
		
		<!--- disabled 
		
		<tr><td> 
		<img align="absmiddle" src="#SESSION.root#/images/#bullet#" order="0">
		</td>
		<td>
		No other <b>travel advance</b> was received other than those displayed below:
		</td>
		</tr>
		
		<tr><td></td><td colspan="1" style="border:1pt solid DCDCDC;">
		<cfinclude template="../ClaimEntry/ClaimAdvance.cfm">
		</td></tr>
		
		--->
		
		<tr><td> 
		<img align="absmiddle" src="#SESSION.root#/Images/#bullet#" order="0">
		</td>
		<td>Any <b>meals or accommodation</b> provided are stipulated in the travel authorization.
		</td>
		<td></td>
		</tr>
		
	</table></td></tr>	
	
	<tr id="choice">
		<td colspan="2" align="center" bgcolor="FFFFFF">
		
		<tr><td colspan="3" align="center">
		
			<table cellspacing="2" cellpadding="2">
			<tr>
			
				<td>
					<input name="Agree" 
					class   = "ButtonNav1"
					value   = "Previous" 
					type    = "button"
					style   = "width:150"
					onclick = "step('regular','hide','hide','hide')"
					onMouseOver = "change(this,'ButtonNav11')"
					onMouseOut  = "change(this,'ButtonNav1')">
			
			    </td>
				
				<td>
			
				 <input name="No" 
					class   = "ButtonNav1"
					value   = "Do not agree" 
					type    = "button"
					style   = "width:150"
					onclick = "goback()"
					onMouseOver = "change(this,'ButtonNav11')"
					onMouseOut  = "change(this,'ButtonNav1')">
					
				</td>				
				<td>
				
					<input name="Agree" 
					class   = "ButtonNav1"
					value   = "Agree" 
					type    = "button"
					style   = "width:150"
					onclick = "step('hide','hide','regular','hide')"
					onMouseOver = "change(this,'ButtonNav11')"
					onMouseOut  = "change(this,'ButtonNav1')">
				
				</td>
								
			</tr>
			</table>
							
		</td></tr>					
			
		</td>
		</tr>
	
	</table>
	
</cfoutput>		