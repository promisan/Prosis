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

<cfset dateValue = "">
<CF_DateConvert Value="#url.date#">
<cfset dte = dateValue>


<!--- only to be recalculated if a timesheet is set --->


<cf_summaryCalculation
	 personNo = "#URL.ID#"
	 date="#dte#">

<table border="0" cellspacing="0" cellpadding="0">

    <cfquery name="work" 
         datasource="AppsEmployee" 
		 username="#SESSION.login#" 
         password="#SESSION.dbpw#">
			SELECT 	*				
			FROM 	PersonWorkClass P INNER JOIN 
			        Ref_TimeClass R ON P.TimeClass = R.TimeClass
			WHERE	PersonNo        = '#URL.ID#'
			AND   	CalendarDate    = #dte#
			AND     TransactionType = '1'
			AND     R.TimeParent IN ('Work','Absent')								
	</cfquery>
				
	<tr>
	<td style="min-width:260px">
	
	<cf_space spaces="60">
	
	<table width="100%" cellspacing="0" padding="0"  class="formpadding">
	
	<tr><td height="5" colspan="3" align="center"></td></tr>
	<tr  class="line"><td width="120" colspan="2" class="labelit"><cf_tl id="Type"></td>
	    <td width="70" class="labelit" align="center">h:mm</td>
	</tr>
	
	<cfoutput query="work">
	
		<tr class="labelmedium line" style="height:18px"><td style="min-width:10px;border-right:1px solid silver" bgcolor="#viewcolor#"></td>
			<td width="140" style="padding-left:4px">#Description#:</td>
			<td align="center">
			<cfif work.TimeMinutes gt 0>
			<cfset h = int(TimeMinutes/60)>
			<cfif (TimeMinutes Mod 60) eq "0">
				#h#:00
			<cfelse>
				#h#:#right((TimeMinutes Mod 60) *101, 2)# <!--- 101 is used as a mask, just to make sure that the minutes always have 2 digits --->
			</cfif>
			</cfif>
			</td>
		</tr>
	
	</cfoutput>
							
	</table>
	
	</td>
	</tr>
		

</table>

