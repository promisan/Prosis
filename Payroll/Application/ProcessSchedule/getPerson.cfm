
<cfparam name="url.personno" default="">

<cfif url.personNo neq "">
		
	<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#url.personNo#'	
	</cfquery>
		
</cfif>

<table width="100%" cellspacing="0" cellpadding="0">

<tr class="labelmedium"><td>
	
	<cfoutput>
		<input type="hidden" id="personno" name="personno" value="#Person.personNo#">						
	</cfoutput>
	
	</td>

	<td width="100%" style="padding-left:3px;padding-top:1px;padding-bottom:1px;height:17px;border-left:1px solid silver;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
	
	  <cfoutput>#Person.FirstName#&nbsp;#Person.LastName#</cfoutput>
	  
	</td>
	
	<cfif person.recordcount eq "1">
		<td style="width:30px;padding-left:2px;padding-right:2px;padding-top:1px;padding-bottom:0px;height:25px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
			<cfoutput>
			<cf_img icon="open" onclick="EditPerson('#Person.PersonNo#')">
			</cfoutput>
		</td>
	</cfif>
	
</tr>

</table>
