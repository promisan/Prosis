
<cfquery name="Relatives" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
    FROM ApplicantRelative A
    WHERE PersonNo = '#URL.ID#'
	ORDER BY Relationship
</cfquery>

<table border="0" 
      bordercolor="silver" 
	  cellpadding="0" 
	  cellspacing="0" 
	  width="100%" 
	  align="center">

<cfif Relatives.recordcount eq "0">

    <!---
	<tr>
	<td colspan="8" align="left">&nbsp;&nbsp;<cf_tl id="No relative information recorded"></b></td>
	</TR>
	--->

</cfif>

<cfoutput query="Relatives">

<tr>
	<td valign="top">&nbsp;#RelativeFirstName# #RelativeLastName#</td>
	<td colspan="2" valign="top" >#Organization#</td>
	<td valign="top">#Relationship#</td>
</tr>

<tr><td colspan="4" class="linedotted"></td></tr>

</cfoutput>
</table>

