<cfparam name="url.rule" default="">

<cfquery name="Rule"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Rule 
	WHERE  Code = '#url.rule#'
</cfquery>

<cfif Rule.RecordCount gt 0>

	<cfoutput query="Rule">
		<table width="80%" align="center">
			<tr> <td height="20px" colspan="2"></td> </tr>
			<tr class="labelit" valign="top">
				<td class="labelit">Message:</td>
				<td> #MessagePerson#</td>
			</tr>
			
			<tr class="labelit">
				<td class="labelit">Template:</td>
				<td>
					<a href="javascript:template('#ValidationPath##ValidationTemplate#')" style="color:##0080FF">#ValidationPath##ValidationTemplate#</a>
				</td>
			</tr>
			
			<tr class="labelit">
				<td class="labelit">Color</td>
				<td style="background-color:#color#">#Color#</td>
			</tr>
			<tr>
				<td colspan="2" height="20px"></td>
			</tr>
			<tr>
				<td class="linedotted" colspan="2"></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input class="button10g" type="button" name="Select" value=" Select " onClick="submitRule('#url.owner#','#url.rule#','#url.level#','#url.from#','#url.to#');">
					<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="ColdFusion.Window.hide('RuleWindow');">
				</td>
			</tr>
		</table>
	</cfoutput>

<cfelse>
	
	<table width="80%" align="center">
			<tr> <td height="40px"></td> </tr>
			<tr>
			<td class="labelmedium"><i>You have not selected a rule for this transition of status.</i></td>
			</tr>
			<tr>
				<td colspan="2" height="40px"></td>
			</tr>
			<tr>
				<td class="linedotted" colspan="2"></td>
			</tr>
			<tr>
				<td align="center">
					<cfoutput>
					<input class="button10g" type="button" name="Select" value=" Select " onClick="submitRule('#url.owner#','#url.rule#','#url.level#','#url.from#','#url.to#');">
					<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="ColdFusion.Window.hide('RuleWindow');">
					</cfoutput>
				</td>
			</tr>
	</table>
	
</cfif>