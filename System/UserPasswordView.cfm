

<cfoutput>

<table width="96%" align="center" cellspacing="0" cellpadding="0">

<tr><td colspan="2" class="line"></td></tr>

<cfset ts = now()>
<cfset ts = dateAdd("n",-15,ts)>

<cfquery name="System" 
	datasource="AppsSystem">
	SELECT  *	
	FROM    Parameter 
</cfquery>	

<cfquery name="get" 
	datasource="AppsSystem">
	SELECT   *
	FROM     UserNames
	WHERE    Account         = '#url.id#' 	
</cfquery>	

<cfquery name="getLogon" 
	datasource="AppsSystem">
	SELECT   count(*) as Fails
	FROM     UserActionLog
	WHERE    Account         = '#url.id#' 
	AND      ActionClass     IN ('Logon','LDAP') 
	AND      ActionMemo LIKE 'Denied%'
	AND      ActionTimeStamp > #ts#
</cfquery>	

<cfquery name="getLogonLast" 
	datasource="AppsSystem">
	SELECT   TOP 1 *
	FROM     UserActionLog
	WHERE    Account         = '#url.id#' 
	AND      ActionClass     IN ('Logon','LDAP') 	
	ORDER BY ActionTimeStamp DESC
</cfquery>	


<cfif getLogon.fails gte System.BruteForce and left(getLogonLast.ActionMemo,7) neq "Success">
	
	<tr><td style="height:60px" class="labelmedium" id="locked"><font color="red"><cf_tl id="Account is temporarily locked">: <font  size="5" color="0080C0"><u><a href="javascript:ColdFusion.navigate('#session.root#/System/UserPasswordUnlock.cfm?id=#url.id#','locked')"><font color="0080C0"><cf_tl id="Press to unlock account"></a></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>

</cfif>

<cfif get.EnforceLDAP eq "1">

	<tr><td style="height:60px" class="labelmedium"><cf_tl id="Reset not available">:<b><font size="5"><cf_tl id="User enforced to use LDAP"></td></tr>

<cfelse>

	<tr><td style="height:60px" class="labellarge"><a href="javascript:ColdFusion.navigate('#session.root#/System/UserpasswordReset.cfm?id=#url.id#','reset')"><font color="0080C0"><cf_tl id="Reset password"></a></td></tr>

</cfif>

<tr><td colspan="2" class="line"></td></tr>
<tr><td id="reset" style="padding:3px"></td></tr>

</table>

</cfoutput>

