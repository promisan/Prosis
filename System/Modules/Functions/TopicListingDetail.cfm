
<cfquery name="Get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ModuleControl
		WHERE 	SystemModule = 'Portal'
		AND		FunctionClass = 'Portal'
		AND		MenuClass = 'Topic'
		AND		MainMenuItem = 0
		ORDER BY MenuOrder ASC
</cfquery>

<cfset colNumber = 5>

<table width="100%">
	<tr><td height="10"></td></tr>
	<tr><td height="1" bgcolor="C0C0C0" colspan="<cfoutput>#colNumber#</cfoutput>"></td></tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td width="10%" align="center"><b>Ord.</b></td>
		<td><b>Name</b></td>
		<td><b>Path</b></td>
		<td><b>Memo</b></td>
		<td align="center">
			<a href="javascript: addtopicline('');" title="Click to add a new topic">
				<font color="0080FF">
					[Add new]
				</font>
			</a>
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td height="1" bgcolor="C0C0C0" colspan="<cfoutput>#colNumber#</cfoutput>"></td></tr>
	<tr><td height="5"></td></tr>
	<cfoutput query="Get">
		<tr onMouseOver="this.bgColor='FFFFCF'" onMouseOut="this.bgColor='FFFFFF'" bgcolor="FFFFFF">
			<td align="center">#MenuOrder#</td>
			<td>#FunctionName#</td>
			<td>#FunctionPath#</td>
			<td>#FunctionMemo#</td>
			<td align="center" width="10%">
				<img src="#SESSION.root#/Images/edit.gif" 
				style="cursor: pointer;" title="edit" width="12" height="12" border="0" align="absmiddle" 
				onClick="javascript: addtopicline('#SystemFunctionId#');">
				&nbsp;
				<img src="#SESSION.root#/Images/delete5.gif" 
					  title="delete"				  
					  style="cursor: pointer;" alt="" width="13" height="13" border="0" align="absmiddle" 
					  onClick="if (confirm('Do you want to remove this record ?')) { purgetopicline('#SystemFunctionId#'); }">
			</td>
		</tr>
	</cfoutput>
</table>