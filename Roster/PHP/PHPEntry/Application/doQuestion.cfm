<cfquery name="FunctionTopic" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM FunctionOrganizationTopic
	 WHERE FunctionId = '#URL.ID#'
	 ORDER BY Parent, TopicOrder
	</cfquery>
	
	<table width="100%" cellspacing="0" cellpadding="0" align="center" bordercolor="#D4D4D4" class="formpadding">
	
	<cfoutput query="FunctionTopic">
	
	<input type="hidden" name="Topic_#CurrentRow#" value="#TopicId#">
									
	<tr class="linedotted">	
		<td width="4%" align="right" class="labelmedium">#currentRow#.&nbsp;</td>
		<td width="80%" class="labelmedium">#TopicPhrase#</td>
		<td width="9%" align="center">
		<select name="TopicParameter_#CurrentRow#" class="regularx">
			<option value="1">Yes</option>
			<option value="0">No</option>
			<option value="9">N/A</option>
		</select>
		</td>
	</tr>
					
	</cfoutput>
																		
</table>
		
				