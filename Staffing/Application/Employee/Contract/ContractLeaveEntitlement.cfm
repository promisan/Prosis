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

<cfparam name="url.id"            default="">
<cfparam name="url.mission"       default="Promisan">
<cfparam name="url.dateeffective" default="01/01/2010">
<cfparam name="url.leavetype"     default="">

<CF_DateConvert Value="#url.DateEffective#">
<cfset STR = dateValue>

<!---- show entitlement for this entity which is already granted for valid contracts --->

<cfquery name="LeaveList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     PersonLeaveEntitlement E
	WHERE    PersonNo  = '#URL.ID#'
	AND      LeaveType = '#url.leavetype#'	
	AND      ContractId IN ( 
	                        SELECT  ContractId
                            FROM    PersonContract
                            WHERE   Mission        = '#url.mission#' 
							AND     PersonNo       = '#URL.ID#'
							AND     PersonNo       = E.PersonNo 					
							AND     ActionStatus  != '9' 
							AND     DateEffective <= #str# 							
							)					
	ORDER BY DateEffective	DESC											  
</cfquery>

<cfoutput query="LeaveList">

<table width="200" bgcolor="ffffcf" ccellspacing="0" ccellpadding="0">
<tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>" style="height:15px">
	<td style="padding-left:6px;padding-right:4px">#Dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
	<td style="padding-right:8px" align="right">#daysentitlement#</td>
</tr>
</table>

</cfoutput>	 