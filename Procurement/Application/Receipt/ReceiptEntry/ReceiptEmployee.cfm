
<cfparam name="URL.selected" default="">
<cfquery name="Person" 
	  datasource="AppsEmployee" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT     *
		FROM       Person 
		WHERE      PersonNo = '#URL.selected#'
</cfquery>

<cfoutput>
<table style="border:1px solid silver" width="387" height="25" cellspacing="0" cellpadding="0">
<tr><td>
<table cellspacing="0" cellpadding="0">
<tr>
<td style="padding-left:4px" class="labelmedium">#Person.IndexNo#</td>
<td style="padding-left:4px" class="labelmedium">#Person.FirstName# #Person.LastName#</td>
<td style="padding-left:4px" class="labelmedium"><cfif Person.gender neq "">(#Person.Gender#)</cfif></td>
</tr>
</table>
</td>
<td>

<input type="hidden" name="name" id="name" size="60" maxlength="60" value="#Person.LastName#" readonly>

<input type="hidden" name="personno" id="personno" value="#URL.selected#" 
   class="regular" 
   size="10" 
   maxlength="10" 
   readonly 
   style="text-align: center;">

</td>
</tr>
</table>
</cfoutput>


   


	