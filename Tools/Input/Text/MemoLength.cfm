
<cfparam name="url.size"         default="2000">
<cfparam name="#url.field#"      default="memo">
<cfparam name="form.#url.field#" default="">

<cfif url.size eq "0">
    <cfset sze = 100>
<cfelse>
    <cfset sze = url.size>
</cfif>

<cfset str      = evaluate("form.#url.field#")>
<cfset textstr  = REReplace(str,'<p[^>]*>','','all')>
<cfset textstr  = REReplace(textstr,'</p>','','all')>
<cfset textstr  = trim(textstr)>

<cfset l = len(textstr)>

<cfset fill = (l*20)/sze>

<table>
	
	<tr><td style="padding-right:13px">
	
	<table width="10" align="center" style="border-left:1px solid silver">
	
	<tr class="labelmedium">
	
		<cfloop index="itm" from="1" to="20">
		
			<cfif fill lt itm>
			<td height="10" width="10" style="border-top:1px solid silver" bgcolor="ffffff"><cf_space spaces="2"></td>
			<cfelse>
			<td width="10" height="10" style="border-top:1px solid silver" bgcolor="B0D8FF"><cf_space spaces="2"></td>	
			</cfif>
		</cfloop>
		
		<td class="labelit" align="center" style="border-top:1px solid silver;border-left:1px solid silver;padding-left:6px;border-right:1px solid silver;">
			<cf_space spaces="20">	
			<cfif l gt url.size>
				<font color="FF0000">
			</cfif>
			<cfoutput>#l# chars</cfoutput>
		
		</td>
	
	</tr>
	
	</table>

</td></tr>

</table>
