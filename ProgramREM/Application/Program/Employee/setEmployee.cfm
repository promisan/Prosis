
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Employee.dbo.Person E
    WHERE  E.PersonNo = '#url.personno#'
</cfquery>

<cfoutput>
<input type="text" name="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:3px">				
<input type="hidden" name="personno" id="personno" value="#Get.PersonNo#" size="10" maxlength="10" readonly style="text-align: center;">
</cfoutput>
			