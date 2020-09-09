
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
    FROM   Applicant
    WHERE  PersonNo = '#url.personno#'
</cfquery>

<cfif Get.Recordcount eq "0">
	
	<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
	    FROM   Person
	    WHERE  PersonNo = '#url.personno#'
	</cfquery>

</cfif>

<cfif get.Recordcount eq "1">

<cfoutput>
	<input type="text" name="name" id="name" value="#Get.FirstName# #Get.LastName#" size="40" maxlength="40" class="regularxl" readonly style="padding-left:3px">				
	<input type="hidden" name="personno" id="personno" value="#Get.PersonNo#">
</cfoutput>

</cfif>
			