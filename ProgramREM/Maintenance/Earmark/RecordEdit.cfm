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

<cfset vOpt = "Maintain - #url.id1#">
<cfif url.id1 eq "">
	<cfset vOpt = "Create Pledge Earmark">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Pledge Earmark" 			   
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Earmark
		WHERE 	Earmark = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function askDelete() {
		if (confirm("Do you want to remove this time class?")) {	
		return true 	
		}	
		return false	
	}

</script>


<!--- edit form --->

<table width="95%" align="center" class="formpadding formspacing">
	
	<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#" method="POST" name="dialog">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium2" width="25%"><cf_tl id="Earmark">:</TD>
    <TD class="labelmedium2">
  	   <cfif url.id1 eq "">
	   
	   		<cfinput type="text" 
		       name="Earmark" 
			   value="#get.Earmark#" 
			   message="Please enter an integer earmark code" 
			   validate="integer"
			   required="yes" 
			   size="5" 
		       maxlength="5" 
			   class="labelmedium2" 
			   style="text-align:center;">
	   	
	   <cfelse>
	   
	   		<b>#get.Earmark#</b>
	   		<input type="Hidden" name="Earmark" id="Earmark" value="#get.Earmark#">
			
	   </cfif>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Description">:</TD>
    <TD class="labelmedium2">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="Please enter a description"
		   required="yes" 
		   size="20" 
	       maxlength="10" 
		   class="regularxxl">
    </TD>
	</TR>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>	
	<tr><td colspan="2" class="line"></td></tr>	
	<tr><td height="6"></td></tr>	
			
	<tr>
		
	<td align="center" colspan="2">	
    	<input class="button10g" type="submit" name="Update" id="Update" value=" Save ">
	</td>	
	</tr>
	
	</CFFORM>
	
</TABLE>
	
<cf_screenbottom layout="innerbox">
