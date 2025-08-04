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
			  label="Address Building" 
			  scroll="Yes" 
			  layout="webapp" 			 
			  menuAccess="Yes" 
			  jquery="Yes"
			  systemfunctionid="#url.idmenu#">
			  
			  
<cf_colorScript>			  

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td height="6"></td></tr>
    <TR>
    <TD class="labellarge"><cf_tl id="Code">:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" id="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labellarge"><cf_tl id="Name">:</TD>
    <TD>
  	   <cfinput type="Text" name="Name" id="Name" value="" message="Please enter a code" required="Yes" size="10" maxlength="40" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labellarge"><cf_tl id="Description">:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" id="Description" value="" message="Please enter a description" required="no" size="40" maxlength="100" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labellarge"><cf_tl id="Levels">:</TD>
    <TD>
  	   <cfinput type="Text" name="Levels" id="Levels" value="" message="Please enter the building levels" validate="integer" required="Yes" size="2" maxlength="3" class="regularxxl" style="text-align:center;">
    </TD>
	</TR>
	
</table>

<cf_dialogBottom option="add">

</CFFORM>


