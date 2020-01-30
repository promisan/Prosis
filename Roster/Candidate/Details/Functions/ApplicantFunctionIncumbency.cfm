
<cfquery name="Last" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
	    FROM   PersonAssignment E, Position P
		WHERE  E.PersonNo = '#EmployeeNo#'
		AND    E.PositionNo = P.PositionNo
		AND    E.AssignmentStatus IN ('0','1')
		AND    E.DateEffective < getDate()
		AND    E.DateExpiration > getDate() 
</cfquery>

<cfparam name="col" default="12">
	
<cfoutput query="Last">		
	
 <tr>
	<td></td>    
	<td height="18" colspan="#col-2#" align="left" bgcolor="D9FDFC" style="border: 1px solid d1d1d1;">
	
		<table cellspacing="0" cellpadding="0">
		<tr class="labelit">
		<td width="90">#MissionOperational#</td>
		<td width="80">#PostGrade#</td>
		<td width="180">#functionDescription#</td>
		<td width="40">from:</td>
		<td width="90">#dateformat(dateeffective,CLIENT.DateFormatShow)#</td>
		<td width="40">to:</td>
		<td width="90">#dateformat(dateexpiration,CLIENT.DateFormatShow)#</td>
		<td></td>
		</tr>
		</table>
			 
	</td>
	</tr>
				 
</cfoutput>			 