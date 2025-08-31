<!--
    Copyright © 2025 Promisan B.V.

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
<cf_screentop height="100%" 	  
	  scroll="Yes" 
	  layout="webapp" 
	  jquery="Yes"
	  html="No">

<cfquery name="Mission"
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_PersonEventMission
			WHERE  PersonEvent = '#url.code#'
			AND    Mission = '#url.mission#'
	</cfquery>
	
<cfoutput>	

<cf_textareascript>	 

<form name="instructionform" id="instructionform">

	<table width="98%" align="center">
	
	<tr class="labelmedium">
	
	<td style="font-size:16px"><cf_tl id="Menu boxcolor"></td>
	
	    <td>
	
		<cf_input 	name="MenuColor" 																
				  	type="colorPicker" 
				  	palette="basic" 				
					ajax="true"
				  	value="#Mission.MenuColor#">
			
		  
		</td>
			
		<td style="padding-left:10px;font-size:16px"><cf_tl id="Image Path"></td>
	
`		<td>
				<input type="text" class="regularxxl" name="MenuImagePath" value="#Mission.MenuImagePath#" size="80" maxlength="100">
		</td>
	
	</tr>
		
	<tr class="labelmedium" style="height:35px">
	
	<td colspan="3" valign="bottom" style="font-size:16px"><cf_tl id="User event reference and instructions"></td>
	
	<td colspan="1" align="right" valign="bottom">
	<select name="ReasonMode" class="regularxxl">
	   <option value="Dialog" <cfif Mission.ReasonMode eq "dialog">selected</cfif>>Show event reasons in dialog</option>
	   <option value="Menu" <cfif Mission.ReasonMode eq "menu">selected</cfif>>Present event reasons as submenu</option>
    </select>
	</td>
	
	</tr>
	
	<tr><td colspan="4" valign="top" style="padding-top:4px;padding-right:2px">
			
			<!--- toolbar        = "basic" --->
			
		   <cf_textarea name="Instruction" id="Instruction"                                            		   
			   resize         = "false"
			   init           = "Yes"
			   height         = "340"
			   color          = "ffffff">#Mission.Instruction#</cf_textarea>		
			
			</td>
	</tr>		
	
	<tr><td colspan="4" style="height:40px">
	<table align="center" class="formspacing">
	   <tr class="labelmedium">
	   	<td>Show event submission button</td>
		<td><input class="radiol" type="checkbox" name="SubmissionMode" value="1" <cfif Mission.SubmissionMode eq "1">checked</cfif>></td>
		<td style="padding-left:10px">Enforce orgunit from portal</td>
		<td><input class="radiol" type="checkbox" name="OrgUnitMode" value="1" <cfif Mission.OrgUnitMode eq "1">checked</cfif>></td>
		</tr>
	</table>
	
	</td></tr>
	
	<tr><td colspan="4" style="height:40px" id="process">
	<table align="center" class="formspacing">
	   <tr>
	   	<td><input class="button10g" type="button" name="Close" value="Close" onclick="parent.ProsisUI.closeWindow('instruction')"></td>
		<td><input class="button10g" type="button" name="Save"  value="Save"  onclick="updateTextArea();ptoken.navigate('InstructionSubmit.cfm?code=#url.code#&mission=#url.mission#','process','','','POST','instructionform')"></td>	   
	   </tr>
	</table>
	
	</td></tr>
	</table>

</form>

</cfoutput>

<cfset AjaxOnLoad("initTextArea")>
<cfset AjaxOnLoad("ProsisUI.doColor")>
