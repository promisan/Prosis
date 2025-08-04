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

<form name="reqform" id="reqform" onsubmit="return false">

<table width="100%" cellspacing="2" cellpadding="2">
	
	<tr>
	  <td>Request type</td>
	  <td>Operational</td>
	   <td>Class</td>
	  <td>Require Reference</td>	 
	  <td>Custom Dialog</td>
	</tr>
	  
	<td colspan="5" class="line"></td></td> 
	
	<cfquery name="Tpe" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Request	
		WHERE Operational = 1	
	</cfquery>
	
	<cfoutput query="Tpe">
		
	 <cfquery name="get" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_RequestServiceItem
		WHERE  ServiceItem = '#url.id1#'		
		AND    Code = '#code#'
	</cfquery>
		
	<tr>	   
     	<td>#Description#</td>	
	    <td>
    	<input type="radio" name="#code#_Operational" id="#code#_Operational" value="0" <cfif Get.recordcount eq "0">checked</cfif>>No
		<input type="radio" name="#code#_Operational" id="#code#_Operational" value="1" <cfif Get.recordcount eq "1">checked</cfif>>Yes	
		</td>
		<td>
		<input type="radio" 
			name="#code#_isAmendment" 
            id="#code#_isAmendment"
			value="0" 
			onclick="document.getElementById('#code#_CustomForm').value=''; document.getElementById('#code#_divCustomForm').style.display = 'none';" 
			<cfif Get.isAmendment neq "1">checked</cfif>
		>New
		<input type="radio" 
			name="#code#_isAmendment" 
            id="#code#_isAmendment"
			value="1" 
			onclick="document.getElementById('#code#_CustomForm')<cfif trim(get.customForm) eq ''>.selectedIndex=0<cfelse>.value='#get.customForm#'</cfif>; document.getElementById('#code#_divCustomForm').style.display = 'inline';" 
			<cfif Get.isAmendment eq "1">checked</cfif>
		>Amendment	
		</td>
		<td>
		<input type="radio" name="#code#_pointerReference" id="#code#_pointerReference" value="0" <cfif Get.pointerReference neq "1">checked</cfif>>No
		<input type="radio" name="#code#_pointerReference" id="#code#_pointerReference" value="1" <cfif Get.pointerReference eq "1">checked</cfif>>Yes	
		</td>	
        <TD>
			<div id="#code#_divCustomForm" <cfif #Get.isAmendment# neq "1">style="display:none"</cfif>>
			<select name="#code#_CustomForm" id="#code#_CustomForm" class="regularH">
				<option value="RequestService.cfm" <cfif trim(get.customForm) eq "RequestService.cfm">selected</cfif>>RequestService.cfm</option>
				<option value="RequestDevice.cfm" <cfif trim(get.customForm) eq "RequestDevice.cfm">selected</cfif>>RequestDevice.cfm</option>
				<option value="RequestPorting.cfm" <cfif trim(get.customForm) eq "RequestPorting.cfm">selected</cfif>>RequestPorting.cfm</option>
				<option value="RequestTransfer.cfm" <cfif trim(get.customForm) eq "RequestTransfer.cfm">selected</cfif>>RequestTransfer.cfm</option>
				<option value="Termination.cfm" <cfif trim(get.customForm) eq "Termination.cfm">selected</cfif>>Termination.cfm</option>
			</select>
			</div>
    	</TD>
	   </TR>
					
	</tr>
		
	</cfoutput>
	
	<tr><td height="5"></td></tr>		
	<tr><td height="1" colspan="5" bgcolor="C0C0C0"></td></tr>
	<tr><td colspan="5" align="center" height="36">		
		<input class="button10g" type="button" name="Update" id="Update" value=" Save " onclick="validatereq()">	
	</td></tr>
	
</form>	