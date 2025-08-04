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
  
<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_AuthorizationRoleOwner
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this owner ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  label="Owner" 
			  html="Yes" 
			  line="No"			 
			  layout="webapp" 
			  banner="gray">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
	<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
		 <tr><td height="5"></td></tr>
		 
	    <cfoutput>
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD class="labelmedium">#get.Code#
	  	   <input type="hidden" name="Code" id="Code" value="#get.Code#" size="10" maxlength="10"class="regularxl">
		 </TD>
		</TR>
		
		<tr><td height="3"></td></tr>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD class="labelmedium">
	  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="40"class="regularxl">
	    </TD>
		</TR>
		
		<tr><td height="3"></td></tr>
		
		<TR>
	    <TD class="labelmedium">eMail : </TD>
	    <TD class="regular">
	  	   <cfinput type="Text" name="emailaddress" value="#get.emailaddress#" message="Please enter a valid email address"  required="Yes" size="30" maxlength="40" class="regularxl">
	    </TD>
		</TR>
			
		</cfoutput>
		
		<cf_dialogBottom option="edit">
			
	</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">


	

