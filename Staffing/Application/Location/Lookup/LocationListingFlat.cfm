
<cf_screentop html="No" jquery="Yes" scroll="Yes">
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="right">
   
<tr>  
<td width="100%" colspan="2" style="padding:14px">

	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<cfset cond = "LocationName LIKE '%#URL.ID1#%'">          
	
	<cftry> 
	
	<!--- Query returning search results --->
	<cfquery name="Level01" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Location
		WHERE  Mission = '#URL.Mission#'
		<cfif cond neq "">
		AND #preserveSingleQuotes(cond)#
		</cfif>
		ORDER BY ListingOrder,LocationName
	</cfquery>
	
	<table border="0" cellpadding="0" cellspacing="0"  bordercolor="e4e4e4" width="98%" class="navigation_table">
	
	<!---
	<TR class="line labelmedium">
	    <td width="30" height="20"></td>
	    <TD>Code</TD>
		<TD>Description</TD>
		<TD>Effective</TD>
		<TD>Expiration</TD>
	</TR>
	--->
	
	<cfoutput query="Level01">
	
	<TR style="height:22px" class="line labelmedium navigation_row">
		<td align="center" style="padding-top:5px">			
		 <cf_img icon="select" navigation="Yes" onclick="parent.selectloc('#LocationCode#','#LocationName#')">	
		</td>
		<TD style="min-width:40px">#LocationCode#</TD>
		<TD>#LocationName#</TD>
		<TD>#DateFormat(DateEffective, CLIENT.DateFormatShow)# <cfif DateEffective neq "">-</cfif></TD>
		<TD>#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</TD>
	</TR>
	     
	</CFOUTPUT>
	
	</TABLE>
	   </td>
	   </tr>
	
		<cfcatch>No records</cfcatch>
	
	</cftry> 
	   
  </table>
  
</td>
</tr>
</table>
