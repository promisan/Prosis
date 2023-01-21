
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

<cftry>
	<cfset fill = (l*20)/sze>
	<cfcatch>
		<cfset fill = 100>
	</cfcatch>
</cftry>

<table>
	
	<tr><td style="padding-right:13px">
	
	<table width="10" align="center" style="border:1px solid silver">
	
	<tr style="height:15px">
	
	    <td class="labelit" align="center" style="min-width:60px;border-right:1px solid silver;padding:4px">
			
			<cfif l gt url.size>
				<font color="FF0000">
			</cfif>
			<cfoutput>#l#<font size="1">chars</font></cfoutput>
		
		</td>
	
		<cfloop index="itm" from="1" to="20">
						
		    <cfif fill lt 14>
			     <cfset cl ="00FF00">			
			<cfelseif fill lt 18>
			    <cfset cl ="FFFF00">
			<cfelse>			
				<cfset cl ="FF0000">
			</cfif>
					
			<cfif fill lt itm>
			<td height="10" width="10" style="border-top:1px solid silver;min-width:4px" bgcolor="white"></td>
			<cfelse>
			<td width="10" height="10" style="border-top:1px solid silver;min-width:4px;<cfoutput>background-color:#cl#</cfoutput>"></td>	
			</cfif>
		</cfloop>
	
	</tr>
	
	</table>

</td></tr>

</table>
