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

		<tr><td height="6"></td></tr>
		<tr><td colspan="9">
			<cf_summaryheader name="Subsistence Details">
		</td>
		</tr>
		
		<tr><td colspan="9">
		<table width="97%" cellspacing="0" cellpadding="0" align="right">
		<tr><td>		
		
		  <cf_ClaimEventEntryIndicatorPointer
		 ClaimSection  = "Subsistence"
		 width    = "100%"
		 line     = "1"
		 status   = "3"
		 tripid   = "#Trip.ClaimTripId#">
		</td></tr>
		</table> 
		 
		</td></tr> 		
		
		<cfquery name="Period" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT DISTINCT 
                P.LastName, P.FirstName, DSA.CountryCityId, Ref_CountryCity.LocationCity, Ref_CountryCity.LocationCountry, DSA.Currency, DSA.Amount, 
                DSA.PersonNo, 
				DSA.CalendarDate, 
				DSA.LocationCode,
				Ref_PayrollLocation.LocationCountry AS DSACountry, 
				Ref_PayrollLocation.LocationCity AS DSACity, 
                Ref_PayrollLocation.Description AS DSACityName
		FROM    Ref_PayrollLocation INNER JOIN
                stPerson P INNER JOIN
                Ref_CountryCity INNER JOIN
                ClaimLineDSA DSA ON Ref_CountryCity.CountryCityId = DSA.CountryCityId ON P.PersonNo = DSA.PersonNo ON 
                Ref_PayrollLocation.LocationCode = DSA.LocationCode LEFT OUTER JOIN
                ClaimLineDateIndicator Dte INNER JOIN
                Ref_Indicator R ON Dte.IndicatorCode = R.Code ON DSA.ClaimId = Dte.ClaimId AND DSA.PersonNo = Dte.PersonNo AND 
                DSA.CalendarDate = Dte.CalendarDate
		WHERE    DSA.ClaimId = '#Claim.ClaimId#'
		ORDER BY DSA.PersonNo, DSA.CalendarDate		
		</cfquery>
		
		<cfif Period.recordcount neq "0">
					
			<tr><td colspan="9">
			
			<table width="100%" border="0" cellspacing="1" cellpadding="1" align="center">
			<tr>
			  <td><!--- <b>Traveller ---></td>
			  <td><b>Date</td>
			  <td><b>DSA Location</td>
			  <td><b>Country</td>
			  <td><b>Indicator</td>
			  <td><b>Currency</b></td>
			  <td ALIGN="right"><b>Amount</b></td>
			  
			</tr>
			<tr><td colspan="7" bgcolor="e4e4e4"></td></tr>
			<cfloop query="Period">
			<tr>
			  
			  <td><cfif PersonNo neq Claim.PersonNo>#FirstName# #LastName#</cfif></td>
			  <td>#dateformat(CalendarDate, CLIENT.DateFormatShow)#</td>
			  <td>#LocationCode# #DSACityName#</td>
			  <td>#DSACountry#</td>
			  <td>
			    <cfquery name="Item" 
				 datasource="appsTravelClaim" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 SELECT DISTINCT R.Description, Dte.IndicatorValue
				 FROM         ClaimLineDateIndicator Dte INNER JOIN
		                      Ref_Indicator R ON Dte.IndicatorCode = R.Code INNER JOIN
		                      stPerson P ON Dte.PersonNo = P.PersonNo
				 WHERE ClaimId = '#Claim.ClaimId#'			  
				 AND   Dte.PersonNo = '#PersonNo#'
				 AND   Dte.CalendarDate = '#CalendarDate#'				 
				</cfquery>
				
				<cfloop query="Item">#Description# 
					<cfif IndicatorValue neq "1">:#IndicatorValue# </cfif>
					<cfif currentRow neq Recordcount>&&nbsp;</cfif>
				</cfloop>
			  </td>
			  <td>#Currency#</td>
			  <td align="right">#numberformat(Amount,"__,__.__")#</td>
			</tr>
			<tr><td colspan="7" bgcolor="e4e4e4"></td></tr>
			
			</cfloop>
			</table>
			</td></tr>
			
		</cfif>
		 
</cfoutput>		 

