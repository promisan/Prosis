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

<cf_screentop height="100%" 
	  label="City" 	  
	  scroll="Yes" 
	  layout="webapp" 
	  banner="blue" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&mission=&city=" method="POST" name="dialog">

<table width="95%" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <tr class="labelmedium2">
    <td width="20%">Entity:</td>
    <td>
		<cfquery name="mis" 
			datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT 	*
				FROM  	Ref_ParameterMission
		</cfquery>
  	   	<cfselect name="mission" id="mission" class="regularxxl" required="Yes" message="Please, select a valid entity." query="mis" display="mission" value="mission">
	   	</cfselect>
    </td>
	</tr>
	
	<tr class="labelmedium2">
    <td>Region:</td>
    <td>
  	   <cfinput type="Text" name="city" id="city" value="" message="Please enter a city" required="Yes" size="30" maxlength="40" class="regularxxl">
    </td>
	</tr>
	
	<tr class="labelmedium2">
    <td>Order:</td>
    <td>
  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regularxxl" style="text-align:center;">
    </td>
	</tr>		
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
    	<cf_tl id = "Save" var ="1">
		<cf_button 
			type		= "submit"
			mode        = "silver"
			label       = "#lt_text#" 
			id          = "save"
			width       = "100px" 					
			color       = "636334"
			fontsize    = "11px">
	</td>	
	
	</tr>
	
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
