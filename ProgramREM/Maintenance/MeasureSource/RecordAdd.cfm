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
<cf_screentop height="100%" title="Reference Add Form" layout="innerbox">


<cf_dialogTop text="Add">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

    <TR>
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regular">
    </TD>
	</TR>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
	<td colspan="2" align="center" height="30">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Submit">
	
	</td>	
	</tr>
	
	</CFFORM>
	
</TABLE>

<cf_screenbottom layout="innerbox">
