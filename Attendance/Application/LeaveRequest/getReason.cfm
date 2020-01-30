
<cfquery name="get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Ref_LeaveTypeClass
		WHERE LeaveType = '#url.leavetype#'			
		AND   Code      = '#url.leaveclass#'
</cfquery>

<!--- hide selection --->

<script>     		 
	 se = document.getElementsByName('portion')
	 i = 0
	 while (se[i]) {	 
	  <cfif get.PointerLeave lt "100">
	  	se[i].className = "hide"		
	  <cfelse>
	  	se[i].className = "regular"
	  </cfif>
	  i++
	 } 
</script>

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
		
		<select name="grouplistcode" id="grouplistcode" class="regularxl enterastab" style="width:100%;border:0px" onchange="getinformation('<cfoutput>#url.id#</cfoutput>');">	
			<cfoutput query="getlist">
				<option value="#grouplistcode#">#Description#</option>
			</cfoutput>
		</select>
		
		<cfoutput>
			
			<script> 			
			 ptoken.navigate('#session.root#/Attendance/Application/LeaveRequest/setBalance.cfm?id=#url.id#','result')	
			</script>	
				
		</cfoutput>

	</cfif>
	
</cfif>	

