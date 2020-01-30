<cfquery name="GetOwners" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	O.*,
				(SELECT Owner FROM Ref_ApplicantSectionOwner WHERE Code = '#url.id1#' AND Owner = O.Owner) as Selected,
				(SELECT AccessLevelRead FROM Ref_ApplicantSectionOwner WHERE Code = '#url.id1#' AND Owner = O.Owner) as SelectedAccessLevelRead,
				(SELECT AccessLevelEdit FROM Ref_ApplicantSectionOwner WHERE Code = '#url.id1#' AND Owner = O.Owner) as SelectedAccessLevelEdit
		FROM 	Ref_ParameterOwner O
		WHERE	O.Operational = 1
</cfquery>

<table width="100%" align="center" class="formpadding navigation_table">
	<tr>
		<td class="labelit" width="1%"></td>
		<td class="labelit"><cf_tl id="Owner"></td>
		<td class="labelit" align="center"><cf_tl id="Access Level Read"></td>
		<td class="labelit" align="center"><cf_tl id="Access Level Edit"></td>
	</tr>
	<tr><td colspan="4" class="linedotted"></td></tr>
	<cfoutput query="GetOwners">
		<cfset ownerId = replace(owner," ","","ALL")>
		<cfset ownerId = replace(ownerId,"-","","ALL")>
		<tr class="navigation_row">
			<td width="1%">
				<input type="Checkbox" name="cb_#ownerId#" id="cb_#ownerId#" <cfif Owner eq Selected>checked</cfif>>
			</td>
			<td style="padding-left:5px;" class="labelit">
				#owner#
			</td>
			<td align="center">
				<select name="alr_#ownerId#" id="alr_#ownerId#" class="regularxl">
					<option value="0" <cfif SelectedAccessLevelRead eq 0>selected</cfif>> 0
					<option value="1" <cfif SelectedAccessLevelRead eq 1>selected</cfif>> 1
					<option value="2" <cfif SelectedAccessLevelRead eq 2>selected</cfif>> 2
					<option value="3" <cfif SelectedAccessLevelRead eq 3>selected</cfif>> 3
				</select>
			</td>
			<td align="center">
				<select name="ale_#ownerId#" id="ale_#ownerId#" class="regularxl">
					<option value="0" <cfif SelectedAccessLevelEdit eq 0>selected</cfif>> 0
					<option value="1" <cfif SelectedAccessLevelEdit eq 1>selected</cfif>> 1
					<option value="2" <cfif SelectedAccessLevelEdit eq 2>selected</cfif>> 2
					<option value="3" <cfif SelectedAccessLevelEdit eq 3>selected</cfif>> 3
				</select>
			</td>
		</tr>
	</cfoutput>
</table>