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
<!--- open as a dialog

show a list of days controlled by the leave and allow to edit the deduction

1
0.75
0.5
0.25
0 

+ comments

save and update the value of Personleave.Deduction if different --->

<cfquery name="Deduction" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonLeaveDeduct
	WHERE  LeaveId = '#URL.LeaveId#' 	
</cfquery>

<form  method="post" name="formdeduction" id="formdeduction">

<table width="95%" border="0" align="center" class="navigation_table">

	<tr class="labelmedium line">
	   <td colspan="2" style="padding-left:3px"><cf_tl id="Calendar Date"></td>
	   <td><cf_tl id="Deduct"></td>
	   <td><cf_tl id="Reason"></td>
   </tr>
	
	<cfoutput query="Deduction">
	
	    <cfif dayofweek(calendardate) eq "1" or dayofweek(calendardate) eq "7">
			<cfset cl = "ffffcf">
		<cfelse>
			<cfset cl = "ffffff">	
		</cfif>
		
		<tr class="labelmedium line navigation_row" style="height:10px">
			<td bgcolor="#cl#" style="padding-left:6px;">#dateformat(CalendarDate,"#client.dateformatshow#")#</td>
			<td bgcolor="#cl#" style="padding-left:6px;padding-right:8px">#ucase(dateformat(CalendarDate,"DDD"))#</td>
			<td style="padding-left:4px;border-left:1px solid silver;padding-right:3px">
			
			<select name="Deduction_#currentrow#" style="font-size:12px;height:16px;background-color:transparent;border:0px;padding-top:0px" class="regularh enterastab">
				<option value="0"    <cfif deduction eq "0">selected</cfif>>0</option>		
				<option value="0.25" <cfif deduction eq "0.25">selected</cfif>>0.25</option>		
				<option value="0.50" <cfif deduction eq "0.5">selected</cfif>>0.50</option>		
				<option value="0.75" <cfif deduction eq "0.75">selected</cfif>>0.75</option>	
				<option value="1"    <cfif deduction eq "1">selected</cfif>>1.00</option>
				<option value="1.5"  <cfif deduction eq "1.5">selected</cfif>>1.50</option>
				<option value="2.0"  <cfif deduction eq "2">selected</cfif>>2.00</option>
			</select>
			
			</td>
			<td style="background-color:white;width:100%;padding-left:5px;border-left:1px solid silver">
			<input type="text" class="regularh enterastab" name="Memo_#currentrow#" value="#Memo#" style="font-size:12px;height:14px;border:0px;width:99%">		
			</td>
		</tr>
		
	</cfoutput>
		
	<tr><td colspan="4" align="center" class="line" style="height:40px">
		<input type="button" name="Apply" value="Apply" class="button10g" onclick="deductionsave('<cfoutput>#url.leaveid#</cfoutput>')">
	
	</td></tr>

</table>

</form>

<cfset ajaxonload("doHighlight")>

