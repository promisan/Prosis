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
		      label="Add" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->


<table width="92%" class="formpadding" cellspacing="0" cellpadding="0" align="center">

    <tr><td></td></tr>
    <TR>
    <TD class="labelmedium"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD title="Please enter the name of a graphic icon" style="cursor:pointer" class="labelmedium"><cf_tl id="Icon">:</TD>
    <TD>
  	   <cfinput type="text" name="ListingIcon" value="" required="No" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>


</BODY></HTML>