
<cf_screentop html="No" jquery="Yes" scroll="Yes">
	
<table width="100%" align="right">
   
<tr>  
<td width="100%" colspan="2" style="padding:14px">

	<table width="100%" align="center" class="formpadding">
	
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
	
	<table width="98%" class="navigation_table">
	
	
	<TR class="line labelmedium fixrow">
	    <td width="30" height="20"></td>
	    <TD>Code</TD>
		<TD>Description</TD>
		<TD>Effective</TD>
		<TD>Expiration</TD>
	</TR>
		
	<cfoutput query="Level01">
	
	<TR class="line labelmedium2 navigation_row fixlengthlist">
		<td align="center">			
		 <cf_img icon="select" navigation="Yes" onclick="parent.selectloc('#LocationCode#','#LocationName#')">	
		</td>
		<TD>#LocationCode#</TD>
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
