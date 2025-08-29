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
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td></td></tr> 
	
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
    <TR class="labelmedium">
    <TD>Name:</TD>
    <TD>
  	   <cfinput type="text" name="name" value="" message="Please enter a name" required="Yes" size="15" maxlength="15" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="regular">
	<cf_LanguageInput
			TableCode       = "Ref_Resource" 
			Mode            = "Edit"
			Name            = "Description"
			Value           = ""
			Key1Value       = ""
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "40"
			Size            = "30"
			Class           = "regularxl">
	  </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Listing Order:</TD>
    <TD>
  	   <cfinput type="Text"
       name="ListingOrder"
       message="Please enter a valid order"
       validate="integer"
       required="Yes"
       visible="Yes"
       enabled="Yes"
       size="1"
       maxlength="2"
       me=""
         class="regularxl">
	  
    </TD>
	</TR>
	 <tr><td height="6"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>		
	<td colspan="2" height="35" align="center">
		
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
</TABLE>

</CFFORM>

