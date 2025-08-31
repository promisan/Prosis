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
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ParameterMission
WHERE Mission = '#URL.Mission#' 
</cfquery>

<cfoutput query="get">

<cfform method="POST"
    name="formcontract">
	
<table width="95%" align="center" class="formpadding">
	
	<tr><td height="5"></td></tr>	
	
	<TR>
	    <td class="labelmedium2" width="170"><cf_UIToolTip tooltip="Enable Contract workflow">PA Contract Workflow:</b></cf_UIToolTip></td>
								 
	    <TD width="75%">
		
		    <cfdiv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=PersonContract" 
			  id="wfPersonContract">
		
			</td>
    </tr>
	
	
	<TR>
    <td class="labelmedium2">Personnel Action No:</b></td>
    <TD class="labelmedium2">	
	<table><tr>
	<td><input type="radio" class="radiol" onclick="document.getElementById('pano').className='hide'" name="PersonActionEnable" <cfif PersonActionEnable eq "0">checked</cfif> value="0"></td><td class="labelmedium2">Edit</td>
	<td><input type="radio" class="radiol" onclick="document.getElementById('pano').className='regular'" name="PersonActionEnable" <cfif PersonActionEnable eq "1">checked</cfif> value="1"></td><td class="labelmedium2">Automatic</td>	
	</td></tr></table>
    </td>
    </tr>
	
	<cfif PersonActionEnable eq "1">
	  <cfset cl = "regular">
	<cfelse>
	  <cfset cl = "hide">
	</cfif>
	    				
    <TR id="pano" class="#cl#">
    <td class="labelmedium2" width="180">&nbsp;&nbsp;Mask:</b></td>
    <TD class="labelmedium2">
  		<input type="text" class="regularxxl" name="PersonActionPrefix" value="#PersonActionPrefix#" size="4" maxlength="4" style="text-align: right;">
  		<input type="text" class="regularxxl" name="PersonActionNo" value="#PersonActionNo#" size="6" maxlength="6" style="text-align: right;">
	</TD>
	</TR>
	
	
	<TR>
	<cf_UIToolTip tooltip="Disable registration of SPA records">
    <td class="labelmedium2">SPA action:</b></td>
	</cf_UIToolTip>
    <TD class="labelmedium2">	
	<table>
	<tr>
		<td><input class="radiol" type="radio" name="DisableSPA" <cfif DisableSPA eq "1">checked</cfif> value="1"></td><td class="labelmedium2">Disabled</td>	
		<td><input class="radiol" type="radio" name="DisableSPA" <cfif DisableSPA eq "0">checked</cfif> value="0"></td><td class="labelmedium2">Enabled</td>
	</tr>
	</table>	
    </tr>		
	
		
	<TR>
	    <td width="170" class="labelmedium2"><cf_UIToolTip tooltip="Enable SPA workflow">PA SPA Workflow:</b></cf_UIToolTip></td>
								 
	    <TD width="75%">
		
		    <cf_securediv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=PersonSPA" 
			  id="wfPersonSPA">
		
			</td>
    </tr>
	
	<TR>
	    <td width="170" class="labelmedium2"><cf_UIToolTip tooltip="Enable Dependennts workflow">PA Dependents Workflow:</b></cf_UIToolTip></td>
								 
	    <TD width="75%">
		
		    <cf_securediv bind="url:#SESSION.root#/system/entityAction/EntityFlow/EntityAction/EntityStatus.cfm?mission=#url.mission#&entitycode=Dependent" 
			  id="wfDependent">
		
			</td>
    </tr>
		
	<TR>
	<cf_UIToolTip tooltip="Generate Contract step increase record and personnel action workflow upon reachning the Next step increase date set.">
    <td class="labelmedium2">Step Increment Batch:</b></td>
	</cf_UIToolTip>
    <TD class="labelmedium2">	
	<table><tr>
		<td><input class="radiol" type="radio" name="BatchStepIncrement" <cfif BatchStepIncrement eq "1">checked</cfif> value="1"></td><td class="labelmedium2">Enabled</td>
		<td><input class="radiol" type="radio" name="BatchStepIncrement" <cfif BatchStepIncrement eq "0">checked</cfif> value="0"></td><td class="labelmedium2">Disabled</td>
	</tr>
	</table>	
    </td>
    </tr>		

	<TR>
	<cf_UIToolTip tooltip="This field represents the path and filename of the template that is responsible of producing an e-document to support personnel actions">
    <td class="labelmedium2">Person Action Template:</b></td>
	</cf_UIToolTip>
    <TD>	
 		<input type="text" class="regularxxl" name="PersonActionTemplate" value="#PersonActionTemplate#" size="100" maxlength="100" style="text-align: left;">
    </td>
    </tr>			
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td height="5"></td></tr>
	
	<tr><td colspan="2" align="center">
	<input type="button" 
	       class="button10g"
		   value="Update"
	       name="Update" 
		   onclick="ptoken.navigate('ParameterEditContractSubmit.cfm?mission=#url.mission#','contentbox1','','','POST','formcontract')">
	</td></tr>
	
	<tr><td height="5"></td></tr>
	
	</table>

</CFFORM>		
</cfoutput>	