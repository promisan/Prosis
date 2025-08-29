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
<cfparam name="mode" default="">

<cfquery name="qLines" datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT CL.*, 
	       (SELECT Reference
		    FROM   ContributionLine
			WHERE  ContributionLineId = CL.ParentContributionLineId) as ParentReference,
	       C.ContributionClass,
		   C.ActionStatus as HeaderStatus <cfif mode eq "log">, -1 ActionStatus</cfif>
	FROM   
		<cfif mode eq "log">
			ContributionLineLog CL, 			
		<cfelse>
			ContributionLine CL, 
		</cfif>			
		Contribution C
	WHERE  CL.ContributionId = C.ContributionId
	AND    <cfif URL.ContributionId neq "">
	    	CL.ContributionId = '#URL.ContributionId#'
           <cfelseif mode eq "log">
     		CL.ContributionLineId = '#URL.LineId#'
           <cfelse>	
			1=0	
		</cfif>	
	<cfif mode eq "log">
	ORDER BY CL.Created DESC
	<cfelse>
	ORDER BY DateReceived ASC, DateEffective ASC
	</cfif>
</cfquery>

<cfquery name="qClass" datasource="AppsProgram"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ContributionClass
	WHERE  Code = '#qLines.ContributionClass#'
</cfquery>	

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

<cfoutput>

	<cfif mode neq "log">
	
		<tr class="line labelit">
			<td style="padding-left:0px;padding-top:3px" colspan="3">
				<table cellspacing="0" cellpadding="0">
				<tr onclick="addrow('#URL.SystemFunctionId#','#URL.ContributionId#')" style="cursor:pointer">
				<td>
				<cf_img icon="add">
				</td>
				<td style="padding-left:3px" class="labelit"><font color="0080C0"><cf_tl id="Add"></td></tr>
				</table>
			</td>						
			<td width="170"><cf_tl id="Received"></td>
			<td width="170"><cf_tl id="Effective"></td>		
			<td width="170"><cf_tl id="Expiration"></td>		
			<td width="15%"><cf_tl id="Reference"></td>		
			
			<cfif qClass.Execution eq "0">
				<td width="15%"><cf_tl id="Parent"></td>				
			</cfif>
			<td width="100"><cf_tl id="Fund"></td>		
			<td width="60"><cf_tl id="Curr"></td>		
			<td align="right"><cf_tl id="Amount"></td>		
			<td width="1%"></td>	
			<td width="1%"></td>		
			<td width="1%"></td>										
		</tr>
	
	</cfif>
		
	<cfset vTotal = 0>
	
	<cfloop query="qLines">

		<cfif mode eq "log">
		
			<tr class="navigation_row">		    
				<td colspan="13" align="left" class="labelit" style="padding-left:3px">
					#qLines.OfficerFirstName#	#qLines.OfficerLastName# on #DateFormat(qLines.Created,CLIENT.DateFormatShow)#	#TimeFormat(qLines.Created,"HH:mm:ss")#			
				</td>
			</tr>
			
			<tr id="l_#ContributionLineId#" class="line navigation_row_child">
				<cfinclude template="ContributionSingleLine.cfm">
			</tr>
		
		<cfelse>
				
			<tr id="l_#ContributionLineId#" class="line navigation_row">
				<cfinclude template="ContributionSingleLine.cfm">
			</tr>
		
		</cfif>
						
		<cfif mode neq "log">
			<tr>
				<td colspan="13" id="r_#ContributionLineId#" class="clsDetails"></td>
			</tr>
			<tr>
				<td colspan="13" id="e_#ContributionLineId#" class="clsEdit"></td>
			</tr>
		</cfif>
		
		<cfset vTotal = vTotal + Amount>
	</cfloop>
	
	<cfif mode neq "log">
		<tr>
			<td colspan="13" id="r_addrow" class="clsAdd"></td>
		</tr>
	</cfif>
	
	<tr>
		<td class="labelmedium" colspan="9" align="right" style="padding-right:10px"><cf_tl id="Total">:</td>
		<td class="labelmedium" align="right">
			<font color="0080C0">#Numberformat(vTotal,",.__")#
		</td>
		<td colspan="3"></td>
	</tr>
	
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>	

