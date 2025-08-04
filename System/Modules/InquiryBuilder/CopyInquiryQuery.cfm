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

<cf_screentop layout="webapp" user="No" height="100%" html="No" label="Copy Inquiry" jquery="yes">

<cfquery name="qCheck" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT LanguageCode,FunctionName 
	 FROM   Ref_ModuleControl_Language
	 WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>	

<cfoutput>

<script language="JavaScript">
		
	function copylisting(id) {
		var allfine = 1
		<cfloop query="qCheck">
			if ($('##FunctionName_#LanguageCode#').val()=='#FunctionName#')	{
				alert('Error! you must change in #LanguageCode# the name of the function to copy it')
				allfine=0
			}		
		</cfloop>
		
		if (allfine) {
			ptoken.navigate('CopyInquirySubmit.cfm','result','','','POST','fcopy')
		}	
	
	}

</script>

</cfoutput>

<cfquery name="qFunction" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ModuleControl
	WHERE  SystemFunctionId = '#URL.ID#'
</cfquery>	

<cfquery name="qModules" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   * 
	FROM     Ref_SystemModule
	WHERE    Operational='1'
	ORDER BY SystemModule
</cfquery>	

<cfoutput>

<!--- edit form --->
<cfform id="fcopy" name="fcopy">

<table>
<tr>
<td style="padding:5px">
<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr class="labelmedium"><td style="font-size:15px" colspan="2">This option allows you to copy and overwrite an inquiry.</td></tr>	
	<tr class="labelmedium"><td style="font-size:15px" colspan="2">You may copy an inquiry to another server.</td></tr>	
	<tr><td height="10"></td></tr>
	<tr class="labelmedium"><td style="font-size:15px" colspan="2">Use with care as this action can not be undone.</td></tr>
	<tr><td height="10"></td></tr>
	
	<TR>
    <TD COLSPAN="2" align="left">
	
    	<cfoutput>
    	<TABLE align="center" class="formpadding">
			<TR class="labelmedium">
		    	<TD width="5%"></TD>	
		    	<TD style="min-width:100px" width="40%"><cf_tl id="Module"></TD>
				
				<TD width="40%">
					<input type="hidden" id="id" name="id" value="#URL.ID#">
					<select name="module" id="module" class="regularxl" >
					<cfloop query="qModules">
						<option value="#qModules.SystemModule#" <cfif qModules.SystemModule eq qFunction.SystemModule>selected</cfif>>#qModules.Description#</option> 		
					</cfloop>
					</select>
				</TD>
			</TR>
			
			<TR class="labelmedium">
						
			
				<TD></TD>
				<TD><cf_tl id="Inquiry name"></TD>
				
				<TD>
				<table cellspacing="0" cellpadding="0">	
					 <cf_LanguageInput
						TableCode       = "Ref_ModuleControl" 
						Mode            = "Edit"
						Name            = "FunctionName"
						Key1Value       = "#URL.ID#"
						Type            = "Input"
						Required        = "No"
						Message         = ""
						MaxLength       = "50"
						Size            = "40"
						Class           = "regularxl"
						Operational     = "1"
						Label           = "Yes">
					</table>					 					
				</TD>			
				
			</TR>	
		
		</TABLE>
		</cfoutput>
    	
    </TD>
	</TR>
	
	<tr><td height="40"></td></tr>	
	<tr><td colspan="2" height="1" class="line"></td></tr>				
	<tr><td height="5"></td></tr>

	<td align="center" colspan="2">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="parent.ProsisUI.closeWindow('copy')">
    <input class="button10g" type="button" name="Copy" id="Copy" value=" Copy " onClick="copylisting('<cfoutput>#URL.ID#</cfoutput>')">
	</td>	
	
</TABLE>
</td>
<td width="3%" id="result"></td>
</tr>
</table>

</cfform>

<table id='options' name='options'  width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding" style="display:none;">
	
	<tr height="250px" valign="center">
		<td width="5%"></td>
		<td style="font-size:20px" align="center">
			<img src="#SESSION.ROOT#/images/checkmark.png">	
			To see the listing you just 'cloned' <br><br> <div style="font-size:22px" id="lname" name="lname"></div> <br> click <a href="##" id="link" name="link" target="_blank">here</div>
		</td>	 
		<td width="5%"></td>
	</tr>
</table>

</cfoutput>
