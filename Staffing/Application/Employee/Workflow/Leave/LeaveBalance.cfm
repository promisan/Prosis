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

<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT       *
	FROM     PersonLeave
	WHERE    Leaveid = '#Object.ObjectKeyValue4#'	
</cfquery>

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(get.DateEffective,CLIENT.DateFormatShow)#">
<cfset STR = dateValue>

<cfset dateValue = "">
<CF_DateConvert Value="#dateformat(get.DateExpiration,CLIENT.DateFormatShow)#">
<cfset END = dateValue>
	 
<cfquery name="Balance" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        TOP 5 L.*,
	              R.Description as ContractDescription 
	    FROM      PersonLeaveBalance L,
   				  Ref_ContractType R
		WHERE     L.PersonNo        = '#get.PersonNo#' 
		  AND     L.LeaveType       = '#get.LeaveType#'
		  AND     L.BalanceStatus   = '0'
		  AND     L.ContractType    = R.ContractType
		  AND     L.DateExpiration >= #str-60#
		  AND     L.DateExpiration <= #end+30#
		ORDER BY  DateEffective DESC
	</cfquery>
		
	<cfset last = '1'>
		
	<cfset prior = Balance.ContractType>
	
   <table width="100%">
   <tr>
   <td style="padding:10px">
	
	   <table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	   <tr class="line"><td colspan="8" style="padding-top:10px" class="labellarge">Leave Balance Inquiry</td></tr>
				
	   <TR class="labelmedium line">
		    <td width="30%" style="padding-left:4px"><cf_tl id="Contract"></td>
		    <td width="100"><cf_tl id="Start"></TD>
			<td width="100"><cf_tl id="End"></TD>		
			<td align="right" width="60"><cf_tl id="Crd"></td>
			<td align="right" width="60"><cf_tl id="Adj."></TD>
			<td width="30%" style="padding-left:5px"><cf_tl id="Reason"></TD>
			<td align="right" width="60"><cf_tl id="Taken"></TD>
			<td align="right" width="60" style="padding-right:4px"><cf_tl id="Balance"></TD>
		</TR>
					
		<cfoutput query="Balance">
		
			<cfif ContractType neq prior>
			    <tr><td height="1" colspan="8"></td></tr>
			</cfif>
			<TR class="labelit" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6f6f6'))#">		
			<TD height="18" style="padding-left:4px">
			<cfif ContractType neq "#prior#" or currentrow eq 1>#ContractDescription#<cfelse>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;..</cfif></TD>
			<td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
			<td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>		
			<TD align="right">#NumberFormat(Credit,"__.__")#</TD>
			<TD align="right"><cfif Adjustment eq "0">..<cfelse>#NumberFormat(Adjustment,"__.__")#</cfif></TD>
			<td style="padding-left:5px">#Memo#</td>
			<TD align="right"><cfif Taken eq "0">..<cfelse>#NumberFormat(Taken,"__.__")#</cfif></TD>
			<TD align="right" style="padding-right:10px">#NumberFormat(Balance,"__.__")#</TD>		
			</tr>				
			<cfset prior = Balance.ContractType>
		
		</cfoutput>
		
		</table>
	
	</td>
	</tr>
	
 </table>