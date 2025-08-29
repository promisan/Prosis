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
			  label="Posttype" 
			  menuAccess="Yes" 
			  line="No"
			  banner="gray"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_PostType
	WHERE  PostType = '#URL.ID1#'
</cfquery>


<cfquery name="Check" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT TOP 1 *
	FROM   PositionParent
	WHERE  PostType = '#URL.ID1#'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="6" colspan="2"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
	   <cfif check.recordcount eq "0">
  	   <input type="text" name="PostType" value="#get.PostType#" size="15" maxlength="20" class="regularxxl">
	   <cfelse>
	   #get.PostType#
	   <input type="hidden" name="PostType" value="#get.PostType#" size="10" maxlength="10" class="regularxxl">
	   </cfif>
	   <input type="hidden" name="PostTypeOld" value="#get.postType#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="40" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Enable PAS:</TD>
    <TD class="labelmedium">
	
  	   <input type="radio" class="radiol" name="EnablePAS" value="0" <cfif get.enablePAS eq "0">checked</cfif>>No
       <input type="radio" class="radiol" name="EnablePAS" value="1" <cfif get.enablePAS eq "1">checked</cfif>>Yes
    </TD>
	</TR>	
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Enable Requisition:</TD>
    <TD class="labelmedium">
	
  	   <input type="radio" class="radiol" name="EnableProcurement" value="0" <cfif get.Procurement eq "0">checked</cfif>>No
       <input type="radio" class="radiol" name="EnableProcurement" value="1" <cfif get.Procurement eq "1">checked</cfif>>Yes
    </TD>
	</TR>	
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Assignment Review:</TD>
    <TD class="labelmedium">	
  	   <input type="radio" class="radiol" name="EnableAssignmentReview" value="0" <cfif get.EnableAssignmentReview eq "0">checked</cfif>>Disabled<br>
       <input type="radio" class="radiol" name="EnableAssignmentReview" value="1" <cfif get.EnableAssignmentReview eq "1">checked</cfif>>Allow trigger review workflow
    </TD>
	</TR>
	
	<TR>
    <TD valign="top" style="padding-top:4px" class="labelmedium">Assignment Entry and -Amendment Workflow:</TD>
    <TD class="labelmedium">	
  	   <input type="radio" class="radiol" name="EnableWorkflow" value="0" <cfif get.EnableWorkflow eq "0">checked</cfif>>Always disabled<br>
       <input type="radio" class="radiol" name="EnableWorkflow" value="1" <cfif get.EnableWorkflow eq "1">checked</cfif>>Dependent on entity settings
    </TD>
	</TR>
	
	</cfoutput>

</TABLE>

<cf_dialogBottom option="Edit" 
                 delete="Post type">
	
</CFFORM>

