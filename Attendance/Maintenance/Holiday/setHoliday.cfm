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
<cfform onsubmit="return false" method="POST" name="holidayform">
  	  				
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">

  <tr class="labelmedium">
 	  <td width="60"></td>
       	  <td width="15%" style="padding-left:4px"><cf_tl id="Date"></td>
       	  <td width="12%"><cf_tl id="Hours"></td>
       	  <td width="43%"><cf_tl id="Name of Holiday"></td>
		  <td width="20%"></td>
		  <td width="13%"></td>		  
      </tr>
  
  <cfquery name="new" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
             password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Holiday
		WHERE   Mission      = '#url.mission#'
		AND  	CalendarDate = '#dateformat(url.selecteddate,client.dateSQL)#'
  </cfquery>
    
														
		<cfoutput>
		
		<tr><td colspan="6" class="line"></td></tr>
				    
          	<tr><td height="35"></td>
						
			<td style="padding-left:3px"><font size="2" color="gray">#DateFormat(url.selecteddate,CLIENT.DateFormatShow)#</font></b></td>
			<cfif new.recordcount eq "0">
            	        <td style="padding-left:2px"><cfinput class="regularxl" type="Text" name="HoursHoliday" id="HoursHoliday" value="8" validate="integer" style="text-align: center;" required="Yes" size="2" maxlength="2"></td>
         		        <td style="padding-left:2px"><cfinput class="regularxl" type="Text" name="description" id="description" message="Please enter a description/holiday name" required="No" size="30" maxlength="50">
			<cfelse>
            	        <td style="padding-left:2px"><cfinput class="regularxl" type="text" name="HoursHoliday" id="HoursHoliday" value="#new.hoursholiday#" size="2" maxlength="2" style="text-align: center;" validate="integer"></td>
         		        <td style="padding-left:2px"><cfinput class="regularxl" type="Text" name="description" id="description" value="#new.description#" message="Please enter a description/holiday name" required="No" size="30" maxlength="50">
			</cfif>
			</td>
			
			<td colspan="2">
			<input type="button" name="Submit" id="Submit" style="height:25" class="button10g" value="Save" onclick="validate('#url.mission#','#urlencodedformat(url.selecteddate)#')">
			</td>
						
			</td>
		</tr>				
						
		</cfoutput>					  		          		  
 		  
</table>
	  
</cfform>

<cfset ajaxOnLoad("function() { ColdFusion.navigate('#SESSION.root#/Attendance/Maintenance/Holiday/HolidayList.cfm?mission=#url.mission#&startyear=#year(url.selecteddate)#','holidaylistcontent'); }")>
  
		