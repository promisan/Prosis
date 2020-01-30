
<cfparam name="URL.status" default="1">

<cfoutput>	

<cfif url.status eq "9">
	
	<img src="#SESSION.root#/Images/exclamation.gif" alt="Problem with report" border="0">
	
<cfelse>
	
	<img src="#SESSION.root#/Images/check_mark.gif" alt="EMail was sent" border="0">
		
</cfif>	

</cfoutput>