<cfif DateEffective lte session.timesheet["DateStart"]>
  	<cfset start = session.timesheet["DateStart"]>
  <cfelse>	
  	<cfset start = dateEffective>			
  </cfif>
  
  <cfif DateExpiration lt session.timesheet["DateEnd"]>
      <cfset enddate = DateExpiration>		
  <cfelse>
      <cfset enddate = session.timesheet["DateEnd"]>	
  </cfif> 	  

  <cfquery name="leave" 
				datasource="AppsEmployee" 
					username="#SESSION.login#" 
                   password="#SESSION.dbpw#">
		SELECT 	 L.*, R.Description, C.Description as ClassName
		FROM 	 PersonLeave L, Ref_LeaveType R, Ref_LeaveTypeClass C
		WHERE    L.PersonNo = '#PersonNo#'
		AND      L.DateEffective  <= '#dateFormat(enddate,client.dateSQL)#'
		AND      L.DateExpiration >= '#dateFormat(start,client.dateSQL)#'
		AND      R.LeaveType       = L.LeaveType
		AND      C.LeaveType       = L.LeaveType
		AND      C.Code            = L.LeaveTypeClass
		AND      L.Status IN ('0','1','2') 
		ORDER BY DateEffective
   </cfquery>							   
   							   
   <cfif leave.recordcount gt "0">
   
	   <tr class="clsTimesheetPersonRow">
	   <td class="ccontent" style="display:none;"><cfoutput>#LastName# #FirstName# #PostGrade#</cfoutput></td>
	   <td width="100%" bgcolor="f5f5f5" colspan="35" bgcolor="white">
	   
	   <table border="0" align="center">
	   
		   <cfoutput query = "leave">
			   <tr class="labelmedium <cfif currentrow neq recordcount>line</cfif>">
						    <td style="padding-left:10px;min-width:340;padding-right:4px">	
				<cfif leave.transactiontype eq "External">
				#leave.Description# (#leave.className#)
				<cfelse>									
				<a href="javascript:leaveopen('#Personno#','#LeaveId#','attendance','workflow')">#leave.Description# (#leave.className#)</a>
				</cfif>
				</td>
                    	    <td style="min-width:80px">#DateFormat(Leave.DateEffective, CLIENT.DateFormatShow)#</td>
				<td style="min-width:80px;padding-left:7px"><cfif Leave.DateExpiration neq Leave.DateEffective>#DateFormat(Leave.DateExpiration, CLIENT.DateFormatShow)#</cfif></td>
                    	    <td style="min-width:40px;padding-left:7px" width="30" align="right">#numberFormat(Leave.DaysLeave,"__._")#</td>
                     	<td style="min-width:40px;padding-left:7px;padding-right:5px" width="30" align="right">#numberFormat(Leave.DaysDeduct,"__._")#</td>
             		   </tr>
		   </cfoutput>
	   
	   </table>
	   
	   </td>
	   </tr>
   </cfif>	