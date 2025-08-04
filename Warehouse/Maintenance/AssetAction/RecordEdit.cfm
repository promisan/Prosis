<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

	<cfoutput>
	<script language="JavaScript">
	
		function ask(){
			if (confirm('Do you want to remove this record ?')){
				ColdFusion.navigate('RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&action=delete','processAssetAction')
				return true;
			}
			return false;
		}			
		
		function validateFileFields(control) {			 								 
			
			if (control != null){
					
				if ($('##validateIcon').length > 0) {
					if ($('##validateIcon').val() == 0) {
						alert("Please, enter a valid tab icon path.");
						control.focus();
						return false;
					}
				}
				else
				{
					$('##tabIcon').focus(); 
					$('##tabIcon').blur();
					return false;
				}
			}
			else
			{
				$('##tabIcon').focus(); 
				$('##tabIcon').blur();
				return false;
			}
			return true;
		}
		
		parent.window.onload = function() {
			validateFileFields(null);
		}
	
	</script>	
	</cfoutput>
	
	<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_AssetAction		
		<cfif url.id1 eq "">
		WHERE  	1 = 0
		<cfelse>
		WHERE  	Code = '#URL.ID1#'
		</cfif>	
	</cfquery>	 
	
	<!--- <cfif url.id1 eq "">
		<cf_screentop height="100%" label="Asset Action" option="Add new asset action" scroll="Yes" layout="webapp">
	<cfelse>
		<cf_screentop height="100%" label="Asset Action" option="Maintain asset action [#get.code#] #get.description#" scroll="Yes" layout="webapp" banner="yellow">
	</cfif> --->
	
	<table class="hide">
		<tr><td><iframe name="processAssetAction" id="processAssetAction" frameborder="0"></iframe></td></tr>
	</table>
		 		
    <cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&action=" method="post" name="frmAssetAction" target="processAssetAction">
	
	<!--- edit form --->
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
		 <cfoutput>
		 
		 <cfinput type="Hidden" name="codeOld" value="#URL.ID1#">				 		 
		 		 
		 <TR>
			 <TD class="labelmedium">Code:<cfif url.id1 eq "">&nbsp;<font color="ff0000">*</font></cfif></TD>  
			 <TD>
			 	<cfif url.id1 eq "">
				 	<cfinput type="Text" name="code" value="#get.code#" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
				<cfelse>
					#get.code#
				</cfif>
			 </TD>
		 </TR>
		 
		 <TR>
			 <TD class="labelmedium">Description:&nbsp;<font color="ff0000">*</font></TD>  
			 <TD>
			 	<cfinput type="Text" name="description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
			 </TD>
		 </TR>
		 
		 <TR>
			 <TD class="labelmedium">Tab Icon:&nbsp;<font color="ff0000">*</font></TD>  
			 <TD class="labelmedium">
			    #SESSION.root#/Images/
			 	<cfset iconDirectory = "Images/">
				
			 	<cfinput type="Text" 
					name="tabIcon" 
					value="#get.tabIcon#" 
					message="Please enter a tab icon path" 
					onblur= "ColdFusion.navigate('CollectionTemplate.cfm?template=#iconDirectory#'+this.value+'&container=iconValidationDiv&resultField=validateIcon','iconValidationDiv')"
					required="Yes" 
					size="50" 
					maxlength="60" 
					class="regularxl">										
			 </TD>
			 <td valign="middle">
			 	<cfdiv id="iconValidationDiv" bind="url:CollectionTemplate.cfm?template=#iconDirectory##get.tabIcon#&container=iconValidationDiv&resultField=validateIcon">				
			 </td>
		 </TR>
		 
		 <tr>
		 	<TD class="labelmedium">Class:&nbsp;<font color="ff0000">*</font></TD>
			<td>
				<select name="actionClass" id="actionClass" class="regularxl">
			  		<option value="Manual" <cfif lcase(get.actionClass) eq "manual">selected</cfif>>Manual</option>
					<option value="System" <cfif lcase(get.actionClass) eq "system">selected</cfif>>System</option>
				</select>
			</td>
		 </tr>		 		 		 		 
		 
		 <TR>
			 <TD class="labelmedium">Enable workflow:&nbsp;<font color="ff0000">*</font></TD> 
			 <TD class="labelmedium">
			 	<input class="radiol" type="radio" name="enableWorkflow" id="enableWorkflow" value="0" <cfif get.enableWorkflow eq "0">checked</cfif>>&nbsp;No
				<input class="radiol" type="radio" name="enableWorkflow" id="enableWorkflow" value="1" <cfif get.enableWorkflow eq "1" or url.id1 eq "">checked</cfif>>&nbsp;Yes	
			 </TD>
		 </TR>
		 
		 <TR>
			 <TD class="labelmedium">Operational:&nbsp;<font color="ff0000">*</font></TD> 
			 <TD class="labelmedium">
			 	<input type="radio" class="radiol" name="operational" id="operational" value="0" <cfif get.operational eq "0">checked</cfif>>&nbsp;No
				<input type="radio" class="radiol" name="operational" id="operational" value="1" <cfif get.operational eq "1" or url.id1 eq "">checked</cfif>>&nbsp;Yes	
			 </TD>
		 </TR>
		 		
		<tr><td height="6"></td></tr>
		<tr><td colspan="4" class="line"></td></tr>
		<tr><td height="6"></td></tr>
		
		<tr><td colspan="4" align="center" height="30">
		
		<cfif url.id1 eq "">				
		
			<input class="button10g" type="submit" name="Save" id="Save" value="Save" onclick="return validateFileFields(document.frmAssetAction.tabIcon)">
			
		<cfelse>
			
			<input class="button10g" type="button" name="Delete" id="Delete" value="Delete" onclick="return ask()" tabindex="999">
			<input class="button10g" type="submit" name="Update" id="Update" value="Update" onclick="return validateFileFields(document.frmAssetAction.tabIcon)">
		
		</cfif>
		
		
		</td></tr>
		
	</cfoutput>

   
    	
</TABLE>

</cfform>