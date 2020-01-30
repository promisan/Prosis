
<cfparam name="CLIENT.DateFormatShow" default="DD/MM/YY">

<cfoutput>

<table width="200" height="67" bgcolor="white">
	
	 <tr><td class="labelmedium" style="padding-left:7px">Last Action performed by:</td></tr>
	 <tr><td class="line"></td></tr>
	
	 <cfquery name="Action" 
	  datasource="AppsOrganization">
	  SELECT   * 
	  FROM     OrganizationObjectAction
	  WHERE    ObjectId = '#url.objectid#'
	  AND      ActionStatus IN ('2','2Y','2N')
	  ORDER BY Created DESC
	 </cfquery> 
	 
	 <tr><td class="labelit" align="center">#Action.OfficerFirstName# #Action.OfficerLastName#</td></tr>
	 <tr><td class="labelit" align="center"><b><cfif Action.ActionStatus eq "2N"><font color="FF0000">Denied</font><cfelse><font color="green">Confirmed</font></cfif></td></tr>
	 <tr><td class="labelit" align="center">#dateformat(Action.OfficerDate,CLIENT.DateFormatShow)# #timeformat(action.OfficerDate,"HH:MM")#</td></tr>

</table>

</cfoutput>