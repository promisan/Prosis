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
			  label="Request Type" 
			  option="Add a request type" 
			  layout="webapp" 
			  user="No" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
<table width="93%" align="center" class="formpadding formspacing">
	
	<tr><td height="6"></td></tr>
    <TR>
    <TD class="labelmediun2">Code:</TD>
    <TD>
  	   <cfinput type="Text" 
		      name="Code" 
		      value="" 
			  message="Please enter a code" 
			  required="Yes" 
			  size="20" 
			  maxlength="20" 
			  class="regularxxl">
    </TD>
	</TR>
	
	 <TR>
    <TD class="labelmedium2">Descriptive:</TD>
    <TD>
  	   <cfinput type="Text" 
		       name="Description" 
			   value="" 
			   message="Please enter a descriptive" 
			   required="Yes" 
			   size="40" 
			   maxlength="50" 
			   class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Type:</TD>
    <TD>
	
		<select name="TemplateApply" id="TemplateApply" class="regularxxl">
				    
			<option value="RequestApplyService.cfm">New Service or change in service provisioning</option>
			<option value="RequestApplyAmendment.cfm">Amended Service Consumption (Unit,User)/Porting</option>
			<option value="RequestApplyTermination.cfm">Termination of Service</option>
			<option value="">Other, such as equipment changes</option>
		
		</select>
		
	  </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
		<td align="center" colspan="2" height="40">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" id="Insert" value="Insert">
		</td>	
	
	</tr>
			
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
