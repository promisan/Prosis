
<!---
<cfif url.id2 eq "">
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Entity" option="Add Entity" user="no">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" html="Yes" layout="webapp" label="Entity" banner="yellow" option="Maintain Entity" user="no">
</cfif>
--->

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	* 
	FROM 	Ref_TaskTypeMission
	WHERE 	Code = '#URL.ID1#'
	AND		Mission  = '#URL.ID2#'
</cfquery>

<table class="hide">
	<tr><td><iframe name="processTaskTypeMission" id="processTaskTypeMission" frameborder="0"></iframe></td></tr>
</table>
	
<cfform action="MissionSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="TaskTypeMission" target="processTaskTypeMission">

<table width="100%" cellspacing="0" class="formpadding">

<tr><td valign="top">

<!--- Entry form --->

<table width="99%" align="center" class="formpadding">

	
	<cfoutput>
   <!--- Field: Id --->
    <TR>
    <td width="80" class="labelmedium2">Entity:</td>
    <TD>
		<cfif url.id2 eq "">
		<cfquery name="getLookup" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission
				
				AND   Mission NOT IN (SELECT Mission 
				                     FROM   Ref_ShipToModeMission
									 WHERE Code = '#url.id1#')
				
				WHERE   Mission IN (SELECT Mission 
	                    FROM   Organization.dbo.Ref_MissionModule 
						WHERE  SystemModule = 'Warehouse')
		</cfquery>
		<select name="Mission" id="Mission" class="regularxxl">
			<cfloop query="getLookup">
				<option value="#getLookup.Mission#" <cfif getLookup.Mission eq Get.Mission>selected</cfif>>#getLookup.Mission#</option>
			</cfloop>
		</select>
		
		<cfelse>
			<b>#url.id2#</b>
			<input type="hidden" name="Mission" id="Mission" value="<cfoutput>#url.id2#</cfoutput>">
		</cfif>
		
		<input type="hidden" name="MissionOld" id="MissionOld" value="<cfoutput>#Get.Mission#</cfoutput>">
		<input type="hidden" name="Code" id="Code" value="<cfoutput>#url.id1#</cfoutput>">
	</TD>
	</TR>
	
	   <!--- Field: Operational --->
    <TR>
    <TD class="labelmedium2">Template:</TD>
    <TD>
		<table>
			<tr>
				<td class="labelmedium">
					<cfset vPath = "#SESSION.root#">
					#vPath#
					<cfinput type="Text" 
						name="TaskOrderTemplate" 
						value="#get.TaskOrderTemplate#" 
						message="Please enter a description" 
						required="No" 
						size="40" 
						maxlength="80"
						onblur= "ptoken.navigate('FileValidation.cfm?template='+this.value+'&container=pathValidationDiv&resultField=validatePath','pathValidationDiv')" 
						class="regularxxl">	
				</td>
				<td valign="middle" align="left">
				 	<cfdiv id="pathValidationDiv" bind="url:FileValidation.cfm?template=#get.TaskOrderTemplate#&container=pathValidationDiv&resultField=validatePath">				
				</td>
			</tr>
		</table>
	</TD>
	</TR>	
	</cfoutput>
</table>	

</td>

</tr>
	
<tr><td colspan="2" align="center" height="2">
<tr><td colspan="2" class="line"></td></tr>
<tr><td colspan="2" align="center" height="2">
	
<tr><td colspan="2" height="25" align="center">
	
	<cfif url.id2 eq "">
		<input type="submit" class="button10g" style="width:100" name="Save" ID="Save" value=" Save " onclick="return validateFields()">
	<cfelse>
		<!--- <input type="submit" class="button10s" style="width:100" name="Delete" id="Delete" value=" Delete " onclick="return ask()"> --->
		<input type="submit" class="button10g" style="width:100" name="Update" id="Update" value=" Update " onclick="return validateFields()">
	</cfif>
	
</td></tr>
	
</TABLE>
	
</CFFORM>

