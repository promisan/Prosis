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

<cf_screentop title="Add" 
			  height="100%"  
			  layout="webapp" 
			  label="Add Tracking" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<table width="95%" align="center" class="formpadding formspacing">
	
		<tr><td style="height:10px"></td></tr>
	
	    <TR class="labelmedium2">
	    <TD>Code:</TD>
	    <TD>
	  	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="2" maxlength="2" class="regularxxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD>Description:</TD>
	    <TD>
	  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
	    </TD>
		</TR>
				
		<TR class="labelmedium2">
	    <TD>Order:</TD>
	    <TD>
	  	   <cfinput type="Text" name="ListingOrder" value="0" message="Please enter a valid number" validate="integer" required="Yes" size="1" maxlength="1" class="regularxxl">
	    </TD>
		</TR>
			
		<tr><td colspan="2" class="line"></td></tr>
			
		<tr><td colspan="2" align="center">
		
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		
		</td>	
		
		</tr>
		
	</table>

</cfform>	

