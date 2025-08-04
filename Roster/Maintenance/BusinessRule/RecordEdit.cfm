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

<cfparam name="url.idmenu" default="">

<cfinclude template="Script.cfm">

<cf_screentop height="100%"			 
			  scroll="Yes" 
			  banner="Gray"
			  line="no"			  
			  layout="webapp" 
			  label="Edit Business Rule" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cfquery name="Rule" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	SELECT *
			FROM   Ref_Rule
			WHERE  Code = '#URL.ID1#'
</cfquery>

<cfoutput>


	<cfform action="RecordSubmit.cfm" method="POST">
	
	<table width="94%" cellspacing="0" cellpadding="0" align="center" id="myTable" class="formpadding formspacing">
		
		
		<tr><td></td></tr>
		
	    <tr>
	    <td class="labelmedium" style="">Owner:</td>
	    <td>
		
			<cfquery name="GetOwners" 
					 datasource="AppsSelection" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 
					 	SELECT DISTINCT Owner
						FROM   Ref_StatusCode
					 
			</cfquery>
			
			<cfselect name="Owner" id="Owner" class="regularxl">
				<cfloop query="GetOwners">
					<option value="#Owner#" <cfif Rule.Owner eq Owner>selected</cfif> >#Owner#</option>
				</cfloop>
			</cfselect>
			
	    </td>
		</tr>
	
	
	    <tr>
	    <td class="labelmedium" style="" width="20%">Trigger Group:</td>
	    <td>
	  	   <cfselect id="TriggerGroup" name="TriggerGroup" onclick="showFields()" class="regularxl">
			   	<option value="Bucket" <cfif Rule.TriggerGroup eq "Bucket">selected</cfif> >Bucket</option>
				<option value="Process" <cfif Rule.TriggerGroup eq "Process">selected</cfif> >Process</option>
		   </cfselect>
	    </td>
		</tr>
		
	    <tr>
	    <td class="labelmedium" style="">Code:</td>
	    <td class="labelmedium">
	  	   <cfinput type="hidden" name="Code" id="Code" value="#Rule.Code#" class="regularxl">
		   #Rule.Code#
	    </td>
		</tr>
		
	    <tr>
	    <td class="labelmedium" style="">Description:</td>
	    <td>
	  	   <cfinput type="Text" name="Description" id="Description" value="#Rule.Description#" style="width:100%" maxlength="100" class="regularxl">
	    </td>
		</tr>
		
	    <tr valign="top" class="r_Process">
	    <td class="labelmedium" style="">Message:</td>
	    <td>
			 <textarea maxlength="300" rows="4" style="width:100%;font-size:14px;padding:3px" class="regular" name="MessagePerson" id="MessagePerson" onkeyup="return ismaxlength(this)" >#Rule.MessagePerson#</textarea>
	    </td>
		</tr>
	
		<tr class="r_Process">
			<td class="labelmedium" style="">Color:</td>
			<td>
				 <cfinput type="Text" name="Color" id="Color" value="#Rule.Color#" size="20" maxlength="20" class="regularxl">
			</td>
		</tr>

	    <tr class="r_Process">
		   	<td colspan="2" width="100%">
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
					<tr>
						<td class="labelmedium" width="20%"> Validation Path:</td>
						<td align="left"><cfinput type="Text" class="regularxl" name="ValidationPath" id="ValidationPath" value="#Rule.ValidationPath#" size="38" maxlength="120" onBlur="validateTemplate()"></td>
					</tr>
					<tr>
						<td class="labelmedium" align="left">Template:</td>
						<td><cfinput type="Text" class="regularxl" name="ValidationTemplate" id="ValidationTemplate" value="#Rule.ValidationTemplate#" size="30" maxlength="50" onBlur="validateTemplate()"></td>
						<td id="templateValidation"></td>
					</tr>
				</table>
			</td>
		</tr>
		
		<tr class="r_Bucket">
			<td class="labelmedium" style="">Status To:</td>
			<td>
				 <cf_securediv bind="url:getStatus.cfm?owner={Owner}" bindOnLoad="yes">
			</td>
		</tr>
		
		<tr>
			<td class="labelmedium" style="">Source:</td>
			<td class="labelmedium"> #Rule.Source#
				<input type="hidden" value="#Rule.Source#" id="Source" name="Source">
			</td>
		</tr>

	
		<tr>
			<td class="labelmedium" style="">Operational:</td>
			<td>
				 <cfinput type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked>
			</td>
		</tr>
		
		<tr>
			<td colspan="2" height="10px"></td>
		</tr>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<tr>	
		<td align="center" colspan="2"  valign="bottom">			
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
			<input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
		</tr>
			
	</TABLE>
	
		
	</CFFORM>

</cfoutput>

<cfset AjaxOnLoad("showFields")> 