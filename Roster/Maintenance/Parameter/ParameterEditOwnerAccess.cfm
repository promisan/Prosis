
<cfparam name="url.selectedStatus" default="">
<cfparam name="url.isReadonly"     default="9">

<cfquery name="StatusesTo" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_StatusCode
		WHERE 	Owner = '#URL.Owner#'
		AND    	Id = 'Fun'
</cfquery>

<cfquery name="StatusesFrom" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_StatusCode
		WHERE 	Owner = '#URL.Owner#'
		AND    	Id = 'Fun'
		<cfif url.selectedStatus neq "">
		AND		Status = '#url.selectedStatus#'
		</cfif>
</cfquery>

<cfquery name="AccessLevels" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT 	*
		 FROM 		Ref_AuthorizationRole 		
		 WHERE 		Role = 'RosterClear' 
</cfquery>

<cfquery name="getLevelStatus" 
	 datasource="AppsSelection"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT 	*
		 FROM 		Ref_StatusCodeProcess
		 WHERE		Owner       = '#URL.Owner#'  		
		 AND   		Id          = 'Fun'
		 AND 		Role        = 'RosterClear'
		 AND		Process     = 'Process'
</cfquery>

<cfajaximport tags="cfwindow">

<script>

	function highlightCells(control, level, from, to) {
		control.bgColor='FFFFCF';
		document.getElementById('Level_'+level).bgColor='E0FEE6';
		document.getElementById('To_'+level+'_'+to).bgColor='FFFFCF';
		document.getElementById('From_'+level+'_'+from).bgColor='FFFFCF';
	}
	
	function resetHighlightCells(control, level, from, to) {
		control.bgColor='';
		document.getElementById('Level_'+level).bgColor='';
		document.getElementById('To_'+level+'_'+to).bgColor='';
		document.getElementById('From_'+level+'_'+from).bgColor='';
	}
	
	function highlightChecked(control, level, from, to) {
		
		var controlToChange = document.getElementById('cell_'+level+'_'+from+'_'+to);
		
		controlToChange.style.borderWidth='1px';
		controlToChange.style.borderStyle = 'solid';
		controlToChange.style.borderColor = 'C0C0C0';
		controlToChange.style.backgroundColor = '';
		controlToChange.bgColor = '';
		
		if (from == to) {
			controlToChange.style.backgroundColor = 'D8E0FE';
		}
		
		if (control.checked) {
			controlToChange.style.borderWidth ='2px';
			controlToChange.style.borderStyle = 'solid';
			controlToChange.style.borderColor = '6B6B6B';
			controlToChange.style.backgroundColor = 'DADADA';
		}
	}
	
	function clearMessage(level){
		ptoken.navigate('ParameterEditOwnerAccessSubmit.cfm?checked=','divLevel'+level);
	}
	
	function submitChange(control, level, from, to, owner){
		ptoken.navigate('ParameterEditOwnerAccessSubmit.cfm?level='+level+'&from='+from+'&to='+to+'&checked='+control.checked+'&owner='+owner,'divLevel'+level);
		setTimeout("clearMessage('"+level+"')", 3000);
	}
	
	function showRuleIcon(control, level, from, to, owner){
		if (control.checked)
			ptoken.navigate('Rule.cfm?level='+level+'&from='+from+'&to='+to+'&owner='+owner,'rule_'+level+'_'+from+'_'+to);
		else{
			c = document.getElementById('rule_'+level+'_'+from+'_'+to);
			c.innerHTML = '';
		}
	}
	

	function template(file) {  
 		ptoken.open("RuleTemplateDialog.cfm?path="+file, "Template", "left=40, top=40, width=860, height= 732, toolbar=no, status=yes, scrollbars=yes, resizable=yes");
	}

	function submitRule(owner, rule, level, from, to){
		
		val = document.getElementById('rule');
		if (val.selectedIndex == 0 || !val){
			rule = "NULL";
		}else{
			rule = val.options[val.selectedIndex].value;
		}
		_cf_loadingtexthtml='';
		ptoken.navigate('RuleSubmit.cfm?level='+level+'&from='+from+'&to='+to+'&rule='+rule+'&owner='+owner,'divLevel'+level);
		setTimeout("clearMessage('"+level+"')", 3000);
		
		ProsisUI.closeWindow('RuleWindow'); 	
	}

	
	function selectRule(owner, rule, level, from, to){
		
		ProsisUI.createWindow('RuleWindow', 'Select rule', '',{x:100,y:100,height:270,width:500,modal:true,center:true});    						
		ptoken.navigate('RuleSelection.cfm?level='+level+'&from='+from+'&to='+to+'&rule='+rule+'&owner='+owner,"RuleWindow")

	}
	
</script>

<cfif url.isReadonly eq 9>
	<cf_screentop height="100%" label="Bucket Process Authorization Matrix #url.owner#" html="No" scroll="Yes" line="no" layout="webapp" banner="gray" jquery="Yes">
<cfelse>
	<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('mydialog',true)" label="Bucket Process Authorization Matrix" html="no" option="Readonly" line="no" scroll="Yes" layout="webapp" banner="gray" bannerheight="55" jQuery="Yes">
</cfif>

<cfoutput>

<cf_divscroll>

<table width="95%" align="center" cellpadding="0">

	<tr><td height="5"></td></tr>
	
	<cfset accessLabel = ListToArray(AccessLevels.accesslevelLabelList)>
	
	<!--- exclude read access for processing, now starts in 1 not 0 --->
	<cfset cntLevels = 1>
	<cfloop index="level" from="1" to="#AccessLevels.accesslevels-1#">
		
		<cfset cntLevels = cntLevels + 1>
		<tr>
			<td id="Level_#level#" style="border:1px solid C0C0C0;" align="center">
				<table cellspacing="0" class="formpadding">
					<tr class="labelit">
						<td><b>#accessLabel[level+1]#</b>&nbsp;&nbsp;&nbsp;[ From / To ]</td>
						<td><cf_securediv id="divLevel#level#" bind="url:ParameterEditOwnerAccessSubmit.cfm?checked="></td>
					</tr>
				</table>	
			</td>
			<cfset width = 80/StatusesTo.RecordCount>
			<cfloop query="StatusesTo">
				<td class="labelit" align="center" style="border:1px solid C0C0C0; width:#width#%" id="To_#level#_#StatusesTo.Status#">#StatusesTo.Status#</td>
			</cfloop>
		</tr>	
		<cfloop query="StatusesFrom">
			<tr>
				<td width="200"  style="border:1px solid C0C0C0;" id="From_#level#_#StatusesFrom.Status#">
				<table width="100%" cellspacing="0" cellpadding="0">
				<tr class="labelit">
					<td width="20" style="padding-left:3px"><cfif status eq "9"><font color="CF806B"></cfif>#Status#</td>
					<td style="padding-left:3px"><cfif status eq "9"><font color="CF806B"></cfif>#meaning#</td>
				</tr>
				</table>
				</td>
				<cfloop query="StatusesTo">
				
					<cfquery name="validateLevelStatus" dbtype="query">
						SELECT 	*
						FROM	getLevelStatus
						WHERE	AccessLevel = '#level#'
						AND		Status = '#StatusesFrom.Status#'
						AND		StatusTo = '#StatusesTo.Status#'
					</cfquery>
					
					<cfset tdStyle = "">
					
					<cfif StatusesFrom.Status eq StatusesTo.Status>
						<cfset tdStyle = tdStyle & "background-color=D8E0FE; ">
					</cfif>
					
					<cfif validateLevelStatus.recordCount gt 0>
						<cfset tdStyle = tdStyle & "border-width:2px; border-style:solid; border-color:6B6B6B; background-color:DADADA; ">
					<cfelse>
						<cfset tdStyle = tdStyle & "border-width:1px; border-style:solid; border-color:C0C0C0; background-color:; ">
						<cfif StatusesFrom.Status eq StatusesTo.Status>
							<cfset tdStyle = tdStyle & "border-width:1px; border-style:solid; border-color:C0C0C0; background-color:D8E0FE; ">
						</cfif>
					</cfif>
					
					<td style="#tdStyle#" onMouseOver="javascript: highlightCells(this, '#level#', '#StatusesFrom.Status#', '#StatusesTo.Status#');" 
							onMouseOut="javascript: resetHighlightCells(this, '#level#', '#StatusesFrom.Status#', '#StatusesTo.Status#');"
							id="cell_#level#_#StatusesFrom.Status#_#StatusesTo.Status#" 
							title="Set [#StatusesFrom.meaning#] to [#StatusesTo.meaning#]">
					
						<table width="100%" cellspacing="0" cellpadding="0">
						    <tr>
							<td width="33%"></td>
							<td width="33%" align="center" >
								
								<input type="Checkbox" 
										name="Status__#level#_#StatusesFrom.Status#_#StatusesTo.Status#"
										onclick="javascript: submitChange(this, '#level#', '#StatusesFrom.Status#', '#StatusesTo.Status#', '#url.owner#'); highlightChecked(this, '#level#', '#StatusesFrom.Status#', '#StatusesTo.Status#'); showRuleIcon(this, '#level#', '#StatusesFrom.Status#', '#StatusesTo.Status#', '#url.owner#');"
										<cfif validateLevelStatus.recordCount gt 0>checked</cfif>
										<cfif url.isReadonly eq 1>disabled</cfif>> 
										
							</td>
							<td width="33%" id="rule_#level#_#StatusesFrom.Status#_#StatusesTo.Status#">
								<cfif validateLevelStatus.recordCount gt 0>
									<cf_securediv id="drule_#level#_#StatusesFrom.Status#_#StatusesTo.Status#" 
											bind="url:Rule.cfm?owner=#url.owner#&rule=#validateLevelStatus.RuleCode#&level=#level#&from=#StatusesFrom.Status#&to=#StatusesTo.Status#" bindOnLoad="Yes">
								</cfif>
							</td>
							</tr>
						</table>
					
					</td>
					
				</cfloop>
			</tr>
		</cfloop>
		
		<cfif cntLevels lt AccessLevels.accesslevels>
			<tr><td height="10" style="border-bottom:1px dotted C0C0C0;" colspan="#StatusesTo.recordCount+1#"></td></tr>
		</cfif>
	
		<tr><td height="10"></td></tr>
	
	</cfloop>

</table>

</cf_divscroll>

</cfoutput>

<cf_screenbottom layout="webdialog">

