
<!--- Entry for 

Show calendar, current date
Move only until the boundaries of the position.
show schedules for that day, allow to click and then show details of that schedule and drill down to the schedule

--->

<cfquery name="Position" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Position
		WHERE  PositionNo = '#URL.ID#'
</cfquery>

<cfinvoke component="Service.Access"  
	  method="position" 
	  orgunit  = "#Position.OrgUnitOperational#" 
	  role     = "'HRPosition'"
	  posttype = "#Position.PostType#"
	  returnvariable="accessPosition">

<cfquery name="Title" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   FunctionTitle
		WHERE  FunctionNo = '#Position.FunctionNo#'
</cfquery>

<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Organization
		WHERE  OrgUnit = '#Position.OrgUnitOperational#'
</cfquery>

<cfif accessPosition eq "NONE">

	<table width="100%" align="center">
	  <tr><td align="center" class="labelmedium"><font color="FF0000">You have not been granted access to view this information</font></td></tr>
	</table>

<cfelse>
	
	<cfoutput>
	
	<cf_divscroll>
	
	<table width="100%" height="100%"><tr><td style="padding:15px">
	
	<table width="100%" height="100%">
	
		<tr>
			<td style="padding-left:4px" height="30" class="labelmedium">Effective:</td>
			<td>
			<table>
				<tr>
				<td class="labelmedium"><b>#dateformat(Position.DateEffective,client.dateformatshow)#</td>
				<td>-</td>
				<td class="labelmedium"><b>#dateformat(Position.DateExpiration,client.dateformatshow)#</td>
				</tr>
			</table>
			</td>
			<td class="labelmedium" style="padding-left:10px">Unit:</td>
			<td class="labelmedium"><b>#Org.OrgUnitName#</td>
			<td class="labelmedium" style="padding-left:10px">Location:</td>
			<td class="labelmedium"><b>#Position.LocationCode#</td>
			<td class="labelmedium" style="padding-left:10px">Grade:</td>
			<td class="labelmedium"><b>#Position.PostGrade#</td>
			<td class="labelmedium" style="padding-left:10px">Title:</td>
			<td class="labelmedium" align="right"><b>#Title.FunctionDescription#</td>
		</tr>
	
		<tr><td colspan="10" valign="top">
		
			<cfparam name="url.selecteddate"  default="#now()#">
		
				<cf_tl id="Position workschedule" var="1">
				
				<cfset vValidDates = "">
				
				<cfset url.positionno = url.id>			
												
				<cf_calendarView 
				   title          = "#lt_text#"	
				   selecteddate   = "#url.selecteddate#"
				   relativepath   =	"../../.."
				   content        = "Staffing/Application/WorkSchedule/Position/WorkScheduleViewDate.cfm"
				   target         = "Staffing/Application/WorkSchedule/Position/WorkScheduleViewDetail.cfm"
				   condition      = "PositionNo=#url.id#&access=#AccessPosition#"
				   cellwidth      = "fit"
				   cellheight     = "50"
				   isDisabled	  = "0"				   
				   showJump	 	  = "No">
		
		
		    </td>
		</tr>
			
		<tr><td colspan="10" class+"linedotted"></td></tr>	
					
		
		<tr><td height="100%" colspan="10" id="positiontarget"></td></tr>
		
	</table>
	
	</td></tr></table>
	
	</cf_divscroll>
	
	</cfoutput>
	
</cfif>	
