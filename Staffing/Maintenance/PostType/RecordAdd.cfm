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
			  label="Posttype" 
			  option="Record a new Posttype" 
			  menuAccess="Yes" 
			  banner="gray"
			  line="No"
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

	<tr><td height="9" colspan="2"></td></tr>
	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="PostType" value="" message="Please enter a code" required="Yes" size="15" maxlength="20"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Enable PAS:</TD>
    <TD class="labelmedium">	
  	   <input type="radio" class="radiol"  name="EnablePAS" value="0" checked>No
       <input type="radio" class="radiol" name="EnablePAS" value="1">Yes
    </TD>
	</TR>	
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Enable Requisition:</TD>
    <TD class="labelmedium">
	
  	   <input type="radio" class="radiol" name="EnableProcurement" value="0" checked>No
       <input type="radio" class="radiol" name="EnableProcurement" value="1">Yes
    </TD>
	</TR>	
	
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Assignment Review:</TD>
    <TD class="labelmedium">	
  	   <input type="radio" class="radiol" name="EnableAssignmentReview" checked value="0">Disabled<br>
       <input type="radio" class="radiol" name="EnableAssignmentReview" value="1">Allow trigger review workflow
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Assignment Entry and -Amendment Workflow:</TD>
    <TD class="labelmedium">
  	   <input type="radio" class="radiol" name="EnableWorkflow" value="0">No<br>
       <input type="radio" class="radiol" name="EnableWorkFlow" value="1" checked>Yes
    </TD>
	</TR>
	
</table>

<cf_dialogBottom option="Add">

</CFFORM>

