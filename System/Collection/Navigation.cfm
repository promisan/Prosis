
<cfoutput>

<cfset pages   = Ceiling(counted/#CLIENT.PageRecords#)>
<cfif  pages lt "1">
	   <cfset pages = '1'>
</cfif>

<table width="100%" align="right">

<tr>
	<td>
	<!---  &nbsp;<b>#Counted#</b> results in #info.time# milliseconds--->

	</td>
	<td align="right">
	<cfif pages gt "1">
		 <cf_pagenavigation cpage="#url.page#" pages="#pages#">
	</cfif>	 
	</td>
</tr>
							
</table>	
</cfoutput>						