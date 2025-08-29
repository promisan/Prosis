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
<cfparam name="attributes.option" default="Add">
<cfparam name="attributes.allowdelete" default="1">
<cfparam name="attributes.delete" default="Record">

<cfoutput>
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this #attributes.delete# ?")) {	
	return true 	
	}	
	return false	
}	

</script>
</cfoutput>


<cfif attributes.option eq "Add">

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">	
   <tr><td height="1" class="line"></td></tr>		
    <tr>
		<td align="center" height="35">
		<input class="button10g" style="width:130" type="button" name="Cancel" id="Cancel" value="Close" onClick="window.close()">
	    <input class="button10g" style="width:130" type="submit" name="Insert" id="Insert" value="Save">	
		</td>		
	</tr>
</TABLE>

<cfelse>

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">	
    <tr><td height="1" class="line"></td></tr>		
    <tr>
	<td align="center" height="35">
	    <!---
		<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" style="width:90" onClick="window.close()">
		--->
		<cfif attributes.allowdelete eq "1">
	    	<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" style="width:130" onclick="return ask()">
		</cfif>
	    <input class="button10g" type="submit" name="Update" id="Update" style="width:130" value="Save">
	</td>	
	
</TABLE>

</cfif>
