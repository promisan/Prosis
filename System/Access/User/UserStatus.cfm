
<cfquery name="User" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE UserNames
	SET    Disabled = '#url.status#'
    WHERE  Account  = '#URL.Account#'
</cfquery>

<cfoutput>

<cfif url.status eq "0">
	<a title="Press to disable" href="javascript:ColdFusion.navigate('UserStatus.cfm?account=#url.account#&status=1','userstatus')">
	<font size="2" color="green"><u>Active
	</a>
<cfelse>
	<a title="Press to activate" href="javascript:ColdFusion.navigate('UserStatus.cfm?account=#url.account#&status=0','userstatus')">
	<font size="2" color="FF0000"><u>Disabled</b></font>
	</a>&nbsp;&nbsp;&nbsp;<font color="gray"><cf_UIToolTip tooltip="This applies for Backoffice only. User might still access a Portal.">( Backoffice only )</cf_UIToolTip></font>
</cfif>

</cfoutput>


