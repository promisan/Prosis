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

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog" target="process">

<!--- Entry form --->

<table width="96%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

	 <tr class="hide"><td><iframe name="process" id="process"></iframe></td></tr>
	
	 <tr><td height="6"></td></tr>
	 
	 <cfquery name="Module" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT DISTINCT S.SystemModule, S.Description, S.MenuOrder
			FROM   Ref_SystemModule S
			WHERE  S.Operational = '1'				
			ORDER BY S.Menuorder	
			</cfquery>
			
	<tr><td class="labelit">Module:</td><td>
			
			<select name="systemmodule" id="systemmodule" class="regularxl">
			
			<cfoutput query="Module">
				<option value="#SystemModule#">#Description#</option>
			</cfoutput>
			</select>
			
			</td>
			 
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="text" name="MenuClass" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	  <TR>
    <TD class="labelit">Name:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a name" required="Yes" size="20" maxlength="50" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Listing Order:</TD>
    <TD>
  	   <cfinput type="Text"
       name="ListingOrder"
       message="Please enter a valid order"
       validate="integer"
       required="Yes"
       visible="Yes"
       enabled="Yes"
       size="1"
       maxlength="2" class="regularxl">
	  
    </TD>
	</TR>
	
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr>		
	<td colspan="2" height="35" align="center">
		
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">