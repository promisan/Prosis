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
			  label="Edit Submission Source" 
			  menuAccess="Yes" 
			  banner="gray"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Source
	WHERE  Source = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Source?")) {	
	return true 	
	}	
	return false	
}	

</script>


<!--- edit form --->
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="7"></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium">Source:</TD>
    <TD>
		#get.Source#
	   <input type="hidden" name="Source" id="Source" value="#get.Source#" size="15" maxlength="15" readonly class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" id="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>	
			
	<TR>
    <TD class="labelmedium">Allow Edit in Backoffice:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol"  name="AllowEdit" id="AllowEdit" value="1" <cfif get.AllowEdit eq 1>checked</cfif>> 
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Allow Assessment:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol" name="AllowAssessment" id="AllowAssessment" value="1" <cfif  get.AllowAssessment eq 1>checked</cfif>> 
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">PHP Mode:</TD>
    <TD>
	
	<cfquery name="Mode" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_PHPMode
	</cfquery>
		
		<cfselect name="PHPMode" id="PHPMode" class="regularxl">
			<cfloop query="Mode">
				<option value="#Mode#" <cfif get.PHPMode eq Mode>selected</cfif>>#Mode#</option>
			</cfloop>
		</cfselect>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Enrollment flow:</TD>
    <TD>
	
	<cfquery name="Class" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_EntityClass
		WHERE  EntityCode = 'Candidate'
	</cfquery>
		
		<cfselect name="EntityClass" id="EntityClass" class="regularxl">
		    <option value=""></option>
			<cfloop query="Class">
				<option value="#EntityClass#" <cfif class.EntityClass eq EntityClass>selected</cfif>>#EntityClassName#</option>
			</cfloop>
		</cfselect>
	
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
	    <INPUT type="checkbox" class="radiol" name="Operational" id="Operational" value="1" <cfif get.Operational eq 1 >checked</cfif>> 
	</TD>
	</TR>
	
	
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	
	<cfquery name="CountRec" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  	  SELECT Source
		  FROM   Ref_Topic
		  WHERE  Source = '#url.id1#'
		  
		  UNION
		  
      	  SELECT TOP 1 Source
	      FROM   ApplicantSubmission
    	  WHERE  Source  = '#url.id1#' 
    </cfquery>
	
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	
	<cfif countRec.recordcount eq "0">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>


