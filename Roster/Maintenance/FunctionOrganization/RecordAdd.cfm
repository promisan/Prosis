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
			  title="Organization" 
			  scroll="Yes" 
			  layout="webapp" 
			  Label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
	<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	    <tr><td height="6"></td></tr>
	    <TR class="labelmedium2">
	    <TD>Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Organizationcode" id="Organizationcode" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD>Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="OrganizationDescription" id="OrganizationDescription" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
	    </TD>
		</TR>
	
		<tr><td colspan="2" class="line"></td></tr>
			
		<tr>	
		<td align="center" colspan="2"  valign="bottom">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value=" Submit ">	
		</td>		
		</tr>
		
	</TABLE>

</CFFORM>

