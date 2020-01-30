
<!--- set account type --->

<table><tr><td class="labellarge" style="font-size:30px">

<cfparam name="url.type" default="">
<cfparam name="url.class" default="">

<cfif url.type eq "debit">

<cfif url.class eq "balance">
	Asset account
<cfelse>
	Cost account
</cfif>

<cfelse>
	
<cfif url.class eq "balance">
	Liability account
<cfelse>
	Income account
</cfif>

</cfif>

</td></tr>
<tr><td height="5"></td></tr>
</table>