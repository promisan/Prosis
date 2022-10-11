
<cfparam name="URL.positionno" default="0">
<cfparam name="URL.selected"   default="">

<cfquery name="Position" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Position 
		WHERE      PositionNo = '#URL.positionNo#'
</cfquery>

<cfquery name="Person" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Person 
		WHERE      PersonNo = '#URL.selected#'
</cfquery>

<cfoutput>

	<Table cellspacing="0" cellpadding="0" height="18">
		<tr>
		<td>
		<input type="text" name="PersonDescription" id="PersonDescription" class="regularxxl" size="30" maxlength="80" value="#Person.IndexNo# #Person.FirstName# #Person.LastName# <cfif Person.gender neq "">(#Person.Gender#)</cfif>" readonly>
		<input type="hidden" name="name" id="name" size="40" maxlength="60" value="#Person.LastName#" readonly>
		<input type="hidden" name="personno" id="personno" value="#URL.selected#" class="regular" size="10" maxlength="10" readonly style="text-align: center;">		
		</td>
		</tr>		
	</Table>
	
</cfoutput>
