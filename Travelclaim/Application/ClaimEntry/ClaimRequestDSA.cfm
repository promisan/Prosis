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

		<cfquery name="Detail" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT D.*, 
		       R.Description as ClaimCategoryDescription, 
			   R.ClaimAmount,
			   R.DefaultIndicatorCode,
			   L.Remarks,			   
			   Loc.LocationCountry as Country, 
			   Loc.Description as LocationDescription,
			   P.PersonNo, P.IndexNo, P.LastName, P.FirstName
		FROM     ClaimRequestLine L,
		         ClaimRequestDSA D,
		         Ref_ClaimCategory R,
			     Ref_PayrollLocation Loc,
			     stPerson P
		WHERE    L.ClaimCategory      = R.Code
		AND      L.PersonNo           = P.PersonNo
		AND      R.Code               = '#Code#'
		AND      L.PersonNo           = '#PersonNo#'
		AND      L.ClaimRequestId     = D.ClaimRequestId
		AND      L.ClaimRequestLineNo = D.ClaimRequestLineNo
		AND      L.ClaimRequestId     = '#ClaimTitle.ClaimRequestId#'
		AND      Loc.LocationCode     =* D.ServiceLocation
		ORDER BY R.ListingOrder, R.Code 
	   </cfquery>
				
		<cfif Detail.DateEffective neq "">
		
			<tr id="#ClaimRequest.ClaimCategoryDescription#" class="hide"  bgcolor="white">
					
				<td width="100"></td>						
				<td colspan="4">
						
				<table width="100%" border="0" bgcolor="white" cellspacing="0" cellpadding="0" align="left" rules="rows">
				
				<tr>
							
				<td>
						
				<table width="560"
			       border="0"
			       cellspacing="0"
			       cellpadding="0"
			       align="left"
			       bordercolor="C0C0C0"
			       bgcolor="FFFFCF"
			       frame="hsides"
			       rules="rows">
				   
				   <cfloop query="detail">
										
						<cfif #PersonNo# neq "#ClaimTitle.PersonNo#">
						<tr>
						<td>
						<img src="#SESSION.root#/Images/line.gif" alt="" border="0" align="absmiddle">
						</td>
						<td>Traveller:</td><td>#FirstName# #LastName#</td>
						</tr>
						</cfif>
						<tr>
						<td>
						<cfif currentrow eq recordcount>
						<img src="#SESSION.root#/Images/join.gif" alt="" border="0" align="absmiddle">
						<cfelse>
						<img src="#SESSION.root#/Images/joinbottom.gif" alt="" border="0" align="absmiddle">
						</cfif>
						&nbsp;#currentrow#.&nbsp;
						</td>
						<td>#ServiceLocation# - #LocationDescription#</td>
						<td><cfif #RequestDays# neq "0"><b>#RequestDays# day<cfif requestdays gt "1">s</cfif></b></td>
						<td>&nbsp;</cfif>#DateFormat(DateEffective,CLIENT.DateFormatShow)# - #DateFormat(DateExpiration,CLIENT.DateFormatShow)#</td>
						<td>#Remarks#</td>
						</tr>
						
						<cfquery name="Indicator" 
							datasource="appsTravelClaim" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM   ClaimRequestLineIndicator I,
							       Ref_Indicator R
							WHERE  I.ClaimRequestId        = '#ClaimTitle.ClaimRequestId#'
							AND    I.ClaimRequestLineNo    = '#ClaimRequestLineNo#'
							AND    I.DetailLineNo          = '#DSALineNo#' 
							AND    I.IndicatorCode = R.Code 
						</cfquery>
						
						<cfif Indicator.recordcount gte "1">
						
							<tr bgcolor="f4f4f4">						
							<td>
							<img src="#SESSION.root#/Images/line.gif" alt="" border="0" align="absmiddle">
							</td>
							<td colspan="2">
														 
									<cfloop query="Indicator">
										<font color="008080"><cfif currentrow neq "1">& </cfif>#Indicator.Description#
									</cfloop>						
													
							</td>
							</tr>				
												
						</cfif>		
						
						</cfloop>	
						
					</table>
					</td></tr>
								
			</table>
					
				</td>
			</tr>
			
		
		</cfif>
</cfoutput>		