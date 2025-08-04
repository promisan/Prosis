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
			  label="Add" 
			  scroll="No" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
<!--- Entry form --->

	<table width="95%" align="center" class="formpadding formspacing">
	
	    <TR>
	    <TD class="labelmedium2">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="3" maxlength="3" class="regularxl">
	    </TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium2">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30"class="regularxl">
	    </TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium2">Color:</TD>
	    <TD>
	  	   <cfinput type="Text" name="InterfaceColor" value="transparent" message="Please enter a description" required="Yes" size="20" maxlength="20"class="regularxl">
	    </TD>
		</TR>
						
		<TR>
	    <TD class="labelmedium2">Hide in Roster:</TD>
	    <TD>
		    <INPUT class="radiol" type="radio" name="RosterHide" value="0" checked> No
			<INPUT class="radiol"  type="radio" name="RosterHide" value="1"> Yes
		</TD>
		</TR>
		
		<tr><td height="3"></td></tr>
		<tr><td height="1" class="line" colspan="2"></td></tr>
		
		<tr>
		<td colspan="2" align="center">
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		    <input class="button10g" type="submit" name="Insert" value=" Submit ">
		</td>	
		</tr>
		
	</TABLE>

</CFFORM>

