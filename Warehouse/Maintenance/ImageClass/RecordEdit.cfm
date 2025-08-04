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
<cfparam name="url.code"   default="">


<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Image Class" 
			  option="Edit Image Class"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
		 datasource="AppsMaterials" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT *
		 FROM   Ref_ImageClass
		 WHERE  Code = '#URL.Code#'
		 
</cfquery>
			  

<!--- Edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
		<cfif Get.recordcount gt 0>
			<cfoutput>
				#Get.Code#
				<input type="hidden" name="Code" id="Code" value="#Get.Code#">
			</cfoutput>
	  	<cfelse>
	  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regular">
	   </cfif>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="#Get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Resolution Width:</TD>
    <TD>
  	   <cfinput type="text" 
	   		name="ResolutionWidth" 
	   		value="#Get.ResolutionWidth#" 
			message="Please enter a valid width" 
			required="Yes" 
			size="40" 
			maxlength="50" 
			validate="integer"
			class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Resolution Height:</TD>
    <TD>
  	   <cfinput type="text" 
	   			name="ResolutionHeight" 
				value="#Get.ResolutionHeight#" 
				message="Please enter a valid height" 
				required="Yes" 
				validate="integer"
				size="40" 
				maxlength="50" 
				class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Resolution Width Thumbnail:</TD>
    <TD>
  	   <cfinput type="text" 
	   			name="ResolutionWidthThumbnail" 
				value="#Get.ResolutionWidthThumbnail#" 
				message="Please enter a valid height" 
				required="Yes" 
				validate="integer"
				size="40" 
				maxlength="50" 
				class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Resolution Height Thumbnail:</TD>
    <TD>
  	   <cfinput type="text" 
	   			name="ResolutionHeightThumbnail" 
				value="#Get.ResolutionHeightThumbnail#" 
				message="Please enter a valid height" 
				required="Yes" 
				validate="integer"
				size="40" 
				maxlength="50" 
				class="regular">
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
	<cfif Get.recordcount eq 0>
	    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">	
	<cfelse>
		<input class="button10g" type="submit" name="Update" id="Update" value="Update">	
		<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete">	
	</cfif>
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>
