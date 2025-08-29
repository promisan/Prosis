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
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AssignmentType
	WHERE AssignmentType = '#URL.ID1#'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">


<!--- edit form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

   <tr><td height="8"></td></tr>

    <cfoutput>
    <TR class="labelmedium">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="AssignmentType" value="#get.assignmentType#" size="10" maxlength="10"class="regularxxl">
	   <input type="hidden" name="AssignmentTypeOld" value="#get.assignmentType#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40"class="regularxxl">
    </TD>
	</TR>
	
	</cfoutput>
	
</TABLE>

<cf_dialogBottom option="edit" delete="Assignment type">

</CFFORM>

