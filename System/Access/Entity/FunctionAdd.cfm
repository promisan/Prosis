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
<cfquery name="Mission"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Mission
	WHERE  Operational = 1 
</cfquery>

<cf_screentop height="100%" label="Add user profile" html="Yes" layout="webapp" jquery="Yes" banner="blue">

<!--- Entry form --->

<cf_assignId>

<cfform action="FunctionSubmit.cfm?id1=#rowguid#" method="POST" name="dialog">

<cfoutput>
<table width="93%" class="formpadding formspacing" align="center">

  <TR class="labelmedium2">
	    <TD>Entity:</TD>
	    <TD class="labelmedium">
		   <select name="Mission"  class="regularxxl">
		   <cfloop query="Mission">
		   <option value="#mission#">#mission#</option>
		   </cfloop>		   
		   </select>		     	   
		 </TD>
	</TR>

	<TR class="labelmedium2">
	    <TD style="min-width:100px">Function:</TD>
	    <TD class="labelmedium">
						
		<cf_LanguageInput
			TableCode       = "MissionProfile" 
			Mode            = "Edit"
			Name            = "FunctionName"
			Value           = ""
			Key1Value       = "#rowguid#"
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "40"
			Size            = "40"
			Class           = "regularxxl">	
			
		 	   
		 </TD>
	</TR>

		
	<TR>
    <TD class="labelmedium">Memo:</TD>
    <TD class="labelmedium">
	   <cfinput type="Text" name="FunctionMemo" required="Yes" size="60" maxlength="80" class="regularxxl">	
    </TD>
	</TR>		
				
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ListingOrder" style="text-align:center" value="" message="Please enter an Order" required="Yes" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>	
		
	<tr><td colspan="2">
	<cf_dialogBottom option="add">	
	</td></tr>
		
</TABLE>
</cfoutput>

</CFFORM>

