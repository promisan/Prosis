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
<cfparam name="url.idmenu" default="">

<cfinclude template="Script.cfm">
		
<cf_screentop height="100%"
              banner="Gray"			  
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Business Rule" 
			  menuAccess="Yes"
			  line="No" 
			  systemfunctionid="#url.idmenu#">
			  
<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" align="center" id="myTable" class="formpadding formspacing">
	
    <tr>
    <td class="labelmedium2">Owner:</td>
    <td>
	
		<cfquery name="GetOwners" 
				 datasource="AppsSelection" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">				 
				 	SELECT DISTINCT Owner
					FROM   Ref_StatusCode				 
		</cfquery>
		
		<cfselect name="Owner" id="Owner" class="regularxxl">
			<cfoutput query="GetOwners">
				<option value="#Owner#">#Owner#</option>
			</cfoutput>
		</cfselect>
		
    </td>
	</tr>
	
    <tr>
    <td class="labelmedium2" width="20%">Trigger Group:</td>
    <td>
  	   <cfselect class="regularxxl" id="TriggerGroup" name="TriggerGroup" onChange="showFields()">
		   	<option value="Bucket">Bucket</option>
			<option value="Process">Process</option>
	   </cfselect>
    </td>
	</tr>
	
    <tr>
    <td class="labelmedium2" style="">Code:</td>
    <td>
  	   <cfinput class="regularxxl" type="Text" name="Code" id="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
    </td>
	</tr>
	
    <tr>
    <td class="labelmedium2" style="">Description:</td>
    <td>
  	   <cfinput class="regularxxl" type="Text" name="Description" id="Description" value="" style="width:100%" maxlength="100">
    </td>
	</tr>
	
    <tr valign="top" class="r_Process">
    <td class="labelmedium" style="">Message:</td>
    <td>
		 <textarea style="width:100%;font-size:13px;padding:3px" maxlength="300" rows="4" class="regular" name="MessagePerson" id="MessagePerson" onkeyup="return ismaxlength(this)" ></textarea>
    </td>
	</tr>

	<tr class="r_Process">
		<td class="labelmedium" style="">Color:</td>
		<td>
			 <cfinput type="Text" class="regularxxl" name="Color" id="Color" value="" size="38" maxlength="20">
		</td>
	</tr>

    <tr class="r_Process">
	   	<td colspan="2" style="" width="100%">
			<table width="100%">
				<tr>
					<td class="labelmedium2" width="20%"> Validation Path:</td><td align="left"><cfinput type="Text" name="ValidationPath" id="ValidationPath" class="regularxxl" value="" size="38" maxlength="120" onBlur="validateTemplate()"></td>
					<td class="labelmedium2" style="padding-left:5px" align="left">Template:</td><td><cfinput type="Text" name="ValidationTemplate" id="ValidationTemplate" class="regularxxl" value="" size="20" maxlength="50" onBlur="validateTemplate()"></td>
					<td id="templateValidation"></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr class="r_Bucket">
		<td class="labelmedium2" style="">Status To:</td>
		<td><cf_securediv bind="url:getStatus.cfm?midprovision20=999999&owner={Owner}" bindOnLoad="yes"></td>
	</tr>

	<tr>
		<td class="labelmedium2" style="">Source:</td>
		<td class="labelmedium2"> Manual
			<input type="hidden" value="Manual" id="Source" name="Source">
		</td>
	</tr>

	<tr>
		<td class="labelmedium2" style="">Operational:</td>
		<td><cfinput type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked></td>
	</tr>
	
	<tr class="line">
		<td colspan="2" height="10px"></td>
	</tr>
	
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	</td>	
	</tr>
			
</TABLE>

</CFFORM>

<cfset AjaxOnLoad("showFields")> 