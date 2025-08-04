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
	  html="Yes" 			 
	  line="No"
	  layout="webapp">
	
<cfform action="RecordSubmit.cfm" method="POST"  name="dialog" menuAccess="Yes" systemfunctionid="#url.idmenu#">

	<!--- Entry form --->
	
	<table width="90%" align="center" class="formpadding formspacing">
	
		<tr><td height="5"></td></tr>
	
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regularxl">
	    </TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40"class="regularxl">
	    </TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium">eMail : </TD>
	    <TD>
	  	   <cfinput type="Text" validate="email" name="emailaddress" value="" message="Please enter a valid email address" required="Yes" size="30" maxlength="40" class="regularxl">
		   
	    </TD>
		</TR>
		
		<tr><td></td></tr>
			
		<cf_dialogBottom option="add">
			
	</table>

</cfform>

<cf_screenbottom layout="webapp">

