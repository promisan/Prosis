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
<cf_tl id="Edit Fund Distribution" var="vPositionFund">
<cf_tl id="Split into different project/funds" var="vOptionFund">

<!---
<cf_screentop height="100%"
	   scroll="yes" 
	   bannerheight="60" 
	   html="Yes"
	   jQuery="Yes"
	   label="#vPositionFund#" 
	   option="#vOptionFund#" 
	   layout="webapp" 
	   banner="gray"
	   user="no">
	   
	   --->

<cfajaximport tags="cfform">
<cf_dialogLedger>

<cfquery name="getPosFund" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	PositionParentFunding
		WHERE	PositionParentId = '#url.PositionParentId#'
		AND		FundingId = '#url.FundingId#'
</cfquery>

<cfquery name="getPosFundLines" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	PositionParentFunding
		WHERE	PositionParentId = '#url.PositionParentId#'
		AND 	DateEffective    = '#getPosFund.DateEffective#'
		-- AND  	DateExpiration   = '#getPosFund.DateExpiration#'
		ORDER BY DateEffective, DateExpiration, Percentage DESC		
</cfquery>

<cfform name="frmFundingEdit" onsubmit="return false;">
	
	<table width="98%" align="center" class="formpadding">
		<tr><td height="10"></td></tr>
		<tr>
			<td class="labellarge" width="20%"><cf_tl id="Effective">:</td>
			<td class="labellarge">
				<cfoutput>
					#dateformat(getPosFund.DateEffective, client.dateformatShow)#
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="labellarge"><cf_tl id="Expiration">:</td>
			<td class="labellarge">
				<cfoutput>
				    <cfif getPosFund.DateExpiration neq "">
					#dateformat(getPosFund.DateExpiration, client.dateformatShow)#
					<cfelse>
					Until next effective record
					</cfif>
				</cfoutput>
			</td>
		</tr>

		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		<tr><td height="5"></td></tr>

		<tr>
			<td colspan="2">
				<table width="95%" align="center" class="formpadding">
					<tr class="labelmedium" >
						<td width="20px"></td>
						<td style="padding-left:13px;" width="10%"><cf_tl id="Fund"></td>
						<td style="padding-left:13px;" width="75%"><cf_tl id="Program / Project"></td>
					    <td style="padding-left:10px;" width="5%" align="right">%</td>
						<td style="padding-left:20px; width:100px;">
							<cfoutput>
								<cf_tl id="Distribute funding evenly" var="1">
								<img src="#session.root#/images/share.png" style="height:25px; cursor:pointer;" title="#lt_text#" onclick="distributeFunding();">
							</cfoutput>
						</td>
					</tr>
					<tr><td height="5"></td></tr>
					<tr><td colspan="5" class="linedotted"></td></tr>
					<tr><td height="5"></td></tr>
				</table>
			</td>
		</tr>

		<tr>
			<td colspan="2">
				<table id="fundingList" width="100%" class="navigation_table">
					<cfoutput query="getPosFundLines">
						<tr class="clsFundingLine navigation_row" id="fundingLine_#currentrow#">
							<td>							
								<cfdiv bind="url:#session.root#/staffing/application/position/funding/setFundPercentageLine.cfm?lineId=#currentrow#&PositionParentId=#PositionParentId#&FundingId=#FundingId#">
							</td>
						</tr>
					</cfoutput>
				</table>
			</td>
		</tr>

		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td height="5"></td></tr>

		<tr>
			<td colspan="2" align="center">
				<cf_tl id="Save" var="1">
				<cfoutput>
					<input type="button" id="btnFundSave" class="button10g" value="#lt_text#" 
						onclick="ptoken.navigate('#session.root#/staffing/application/position/funding/PositionFundingPercentageSubmit.cfm?positionparentid=#url.positionparentid#&FundingId=#url.FundingId#','process',null,null,'POST','frmFundingEdit');">
				</cfoutput>
			</td>
		</tr>

		<tr><td height="20"></td></tr>

	</table>

</cfform>

<cfset ajaxOnLoad("function(){ vFundPercentageLineId = #getPosFundLines.recordcount#; }")>