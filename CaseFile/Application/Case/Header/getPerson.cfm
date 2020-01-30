
<cfparam name="url.personNo"   default="">
<cfparam name="url.dependentid"   default="">

<cfquery name="Person" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Person
		WHERE  PersonNo = '#url.personNo#'	
</cfquery>

<table cellspacing="0" cellpadding="0">

<tr class="labelmedium">
	
	<cfoutput query="Person">
		<input type="hidden" name="PersonNo"  value="#Person.personNo#">
		<input type="hidden" name="Name"      value="#Person.FirstName# #Person.LastName#">						
	</cfoutput>
	
	<td width="306" style="border-radius:4px;padding-left:3px;padding-top:1px;padding-bottom:1px;height:25px;border: 1px solid Silver;">
	<cfoutput>#Person.FirstName#&nbsp;#Person.LastName#</cfoutput>
	</td>
	
	<cfif person.recordcount eq "1">
		<td style="padding-left:4px;padding-right:4px;padding-top:1px;padding-bottom:0px;height:19px;border-right: 1px solid Silver;border-top: 1px solid Silver;border-bottom: 1px solid Silver;">
		<cfoutput>
		<cf_img icon="open" onclick="EditPerson('#Person.PersonNo#')">
		</cfoutput>
		</td>
	</cfif>
	
</tr>

</table>

<cfif url.mode eq "Dependent">

	<cfoutput>
		<script>
			 ColdFusion.navigate('getDependent.cfm?personno=#url.personno#&dependentid=#url.dependentid#','dependent')
		</script>
	</cfoutput>

</cfif>


