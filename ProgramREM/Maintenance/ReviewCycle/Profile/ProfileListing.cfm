<cfquery name="ProfileListing" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  A.*,
				(SELECT TextAreaCode FROM Ref_ReviewCycleProfile WHERE CycleId = '#url.id1#' AND TextAreaCode = A.Code) as Selected
		FROM	Ref_TextArea A
		WHERE   TextAreaDomain = 'Review'
		ORDER BY A.ListingOrder ASC
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<!---
<tr class="linedotted">
    <TD align="center" class="labelit" width="30"></TD>
	<TD class="labelmedium" align="left" wifth="94%"><cf_tl id="Description"></TD>
	
</TR>
--->

<cfset vCols = 3>

<tr><td height="5"></td></tr>

<cfif ProfileListing.recordCount eq 0>
	<tr><td height="25" colspan="<cfoutput>#vCols#</cfoutput>" align="center" class="labelit"><cf_tl id="No text areas recorded"></td></tr>
	<tr><td colspan="<cfoutput>#vCols#</cfoutput>" class="line"></td></tr>
</cfif>

<cfoutput query="ProfileListing">
    
    <tr class="navigation_row linedotted labelmedium">
		<td style="height:20px;padding-right:10px"><input type="Checkbox" class="radiol" name="profileCode_#code#" id="code_#code#" <cfif Code eq Selected>checked</cfif>></td>
		<td>#Description# : <font size="2" color="808080">#Explanation#</td>
    </tr>
	
</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>