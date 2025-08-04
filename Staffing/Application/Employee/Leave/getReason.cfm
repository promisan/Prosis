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

<cfparam name="url.selected" default="">

<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_LeaveTypeClass
		WHERE LeaveType = '#url.leavetype#'			
		AND   Code      = '#url.leaveclass#'
</cfquery>


<cfif get.GroupCode eq "">

	<input type="hidden" name="GroupCode"     value="">
	<input type="hidden" name="GroupListCode" id="grouplistcode" value="">
	
	<cfoutput>
			
			<script> 			
			   ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/setBalance.cfm?id=#url.id#','result')	
			</script>	
				
		</cfoutput>

<cfelse>
		
	<cfquery name="Reason" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Ref_PersonGroup
			WHERE Code = '#get.groupcode#'			
	</cfquery>
	
	<cfquery name="getList" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM     Ref_PersonGroupList
		WHERE    GroupCode = '#Reason.Code#'
		ORDER BY GroupListOrder						
	</cfquery>
	
	<cfif getList.recordcount eq "0">

		<input type="hidden" name="GroupCode"     value="">
		<input type="hidden" name="GroupListCode" id="grouplistcode" value="">
		
		

	<cfelse>
	
		<input type="hidden" name="GroupCode" value="<cfoutput>#getList.GroupCode#</cfoutput>">
		
		<select name="GroupListCode" id="grouplistcode" class="regularxl enterastab" style="width:99%;border:0px" onchange="getinformation('<cfoutput>#url.id#</cfoutput>');">	
			<cfoutput query="getlist">
				<option value="#grouplistcode#" <cfif grouplistcode eq url.selected>selected</cfif>>#Description#</option>
			</cfoutput>
		</select>
		
		<cfoutput>
			
			<script> 			
			   ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/setBalance.cfm?id=#url.id#','result')	
			</script>	
				
		</cfoutput>

	</cfif>
	
</cfif>	

