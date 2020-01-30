
<cfparam name="URL.field"    default="personNo">
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

<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td style="padding-left:3px;border:1px solid silver;width:95">#Person.Reference#&nbsp;</td>
<td style="width:7;height:18"></td>
<td style="padding-left:3px;border:1px solid silver;width:125">#Person.FirstName#&nbsp;</td>
<td style="width:7;height:18"></td>
<td style="padding-left:3px;border:1px solid silver;width:125">#Person.LastName#&nbsp;</td>
</tr>

<input type="hidden" name="name" id="name" size="60" maxlength="60" value="#Person.LastName#" readonly>

<input type="hidden" name="#url.field#" id="#url.field#" value="#URL.selected#" 
   class="regular" 
   size="10" 
   maxlength="10" 
   readonly 
   style="text-align: center;">

</table>

</cfoutput>


   


	