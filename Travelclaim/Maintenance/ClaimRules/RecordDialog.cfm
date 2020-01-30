
<cfparam name="URL.Id" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Get" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_Validation R, Ref_ValidationClass C
	WHERE R.ValidationClass = C.Code
	AND   R.Code = '#URL.Id#'
</cfquery>

<cfquery name="Class" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  Ref_ValidationClass
</cfquery>

<cfif #Get.Recordcount# eq "0">
<cfset mode = "Insert">
<cfelse>
<cfset mode = "Modify">
</cfif>

<cfoutput>

<script language="JavaScript">

function toggle(ln) {
se = document.getElementById("selected_"+ln)
am = document.getElementById("amount_"+ln)

if (se.checked == true)	{
   am.className = "amount"
   } else {
   am.className = "hide" }

}
</script>

<cf_screentop height="100%" layout="webapp"  banner="yellow" scroll="Yes" label="Claim Validation #Mode#">

<input type="hidden" name="id" value="#URL.ID#">

<table width="98%" align="center">
	<tr>
		<td>	
			<cfinclude template="RecordDialogTab.cfm">
		</td>
	</tr>
</table>


</cfoutput>
