
<cfquery name="GroupListing" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT  A.*,
				(SELECT ProgramGroup FROM Ref_ReviewCycleGroup WHERE CycleId = '#url.id1#' AND ProgramGroup = A.Code) as Selected
		FROM	Ref_ProgramGroup A
		WHERE   (Mission = '#url.fmission#') OR
                      (Mission IS NULL)
		ORDER BY A.ListingOrder ASC
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">

<cfset cnt = 0>
<cfoutput query="GroupListing">
    
	<cfset cnt = cnt + 1>
	<cfif cnt eq "1">
    <tr class="linedotted labelmedium">
	</cfif>
		<td><input type="Checkbox" class="radiol" name="groupCode_#code#" id="groupcode_#code#" <cfif Code eq Selected>checked</cfif>></td>
		<td style="padding-left:5px;height:25px">#Description# [#Code#]</td>		
	<cfif cnt eq "3">
	</tr>
	<cfset cnt = "0">
	</cfif>	
	
</cfoutput>

</table>
