

<!--- Identify pending records --->

<cfquery name="SearchResult" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT L.*
FROM  OrganizationAuthorization O, 
      Ref_AuthorizationRole R, 
	  Employee.dbo.PersonLeave L, 
	  Employee.dbo.PersonLeaveAction A
WHERE O.UserAccount = '#SESSION.acc#'
AND   O.AccessLevel IN ('1','2')
AND   R.Area = 'Leave'
AND   R.Role = O.Role
AND   L.OrgUnit = O.OrgUnit
AND   L.LeaveId = A.LeaveId
AND   O.Role    = A.Role
AND   A.Status = '0'
AND   L.Status = '0'
</cfquery>

<script language="JavaScript">

function reload(id,act)
 
 {
 window.location = "ClearanceListingZoom.cfm?id=" + id + "&act=" + act
 }
 
function leave(id)
 
 {
   window.location = "Leave/Decision.cfm?id=" + id;
 } 

</script>

<!--- select leave actions that are pending (status = 0) and link the org unit to valid records in Authorization = orgunit, current
users, access 1,2 with a role that matches Leave --->

<cfif #SearchResult.recordCount# gt '0'>


<cfif #find("Leave", CLIENT.Review)#>

   <form action="SubListingSubmit.cfm" method="post">
   
   <cf_tableTop size="100%">
      
    <table width="100%">
  
    <tr>
      <td colspan="7" class="regular">
       <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/timesheet.JPG" alt="" width="44" height="36" border="0">
	   </b>Leave requests</b>
      </td>
	  <td width="30" align="right" valign="bottom">
	  <!---
	  <cfoutput>
	  <img src="#SESSION.root#/Images/portal_min.JPG" alt="" border="0" style="cursor: pointer;" onClick="reload('Leave','del')">&nbsp;
	  </cfoutput>
	  --->
	  </td>
		  
    </tr>
  
    <tr>
       <td class="top"></td>
       <td class="top">Employee</td>
       <td class="top">Type</td>
   	   <td class="top">Start</td>
       <td class="top">End</td>
	   <td class="top" align="right">Days</td>
	   <td class="top" align="right">Deduct</td>
	  
	   <td class="top"></td>
    </tr>
  
    <cfoutput query="Searchresult">
    <tr>
      <td class="regular" align="center">
	     <a href="javascript:leave('#LeaveId#')"
		  onMouseOver="document.img0_#leaveid#.src='#SESSION.root#/Images/button.jpg'" 
		  onMouseOut="document.img0_#leaveid#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#leaveid#" width="14" height="14" border="0" align="middle">
          </a>
       </td>	
	   
	 <cfquery name="Person" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT *
      FROM  Person
      WHERE PersonNo = '#PersonNo#' 
    </cfquery>
	 
	 <td class="regular">#Person.FirstName# #Person.LastName#</td>
	 <td class="regular">#LeaveType#</td>
	 <td class="regular">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</td>
	 <td class="regular">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</td>
	 <td align="right" class="regular">#numberFormat(DaysLeave,"__._")#</td>
	 <td align="right" class="regular">#numberFormat(DaysDeduct,"__._")#</td>
	 <td align="center" class="regular">&nbsp;<input type="checkbox" value="#LeaveId#"></td>
	
    </tr>
    </cfoutput>  
  
   </table>
   
   <cf_tableBottom size="100%">
  
  </form>
  
<cfelse>

  <cf_tableTop size="100%">

  <table width="100%" border="0">
    <tr>
    <td colspan="7" class="regular">
	  <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/timesheet.JPG" alt="" width="24" height="21" border="0">
	  </b>&nbsp;Leave requests</b>
    </td>
	<td width="30" align="right"><cfoutput>
	   <img src="#SESSION.root#/Images/portal_max.JPG" alt="" border="0" style="cursor: pointer;" onClick="reload('Leave','add')">
	   &nbsp;
	   </cfoutput>
	</td> 
	</tr>
   </table>
   
   <cf_tableBottom size="100%">
  
</cfif>

 
</cfif>

<cfflush>

