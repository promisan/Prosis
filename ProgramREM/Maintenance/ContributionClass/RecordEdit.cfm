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
	<cfset vOpt = "Create Contribution Class">
</cfif>

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Contribution Class" 
			  option="#vOpt#" 
			  banner="yellow"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ContributionClass
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function askDelete() {
		if (confirm("Do you want to remove this contribution class?")) {	
		return true 	
		}	
		return false	
	}

</script>


<!--- edit form --->

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
	
	<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#" method="POST" name="dialog">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelmedium" width="25%"><cf_tl id="Class">:</TD>
    <TD class="labelmedium">
  	   <cfif url.id1 eq "">
	   
	   		<cfinput type="text" 
		       name="Code" 
			   value="#get.Code#" 
			   message="Please enter a class" 
			   required="yes" 
			   size="5" 
		       maxlength="10" 
			   class="regularxl">
	   	
	   <cfelse>
	   
	   		<b>#get.Code#</b>
	   		<input type="Hidden" name="Code" id="Code" value="#get.Code#">
			
	   </cfif>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Description">:</TD>
    <TD class="labelmedium">
  	   
	    <cfinput type="text" 
	       name="Description" 
		   value="#get.Description#" 
		   message="Please enter a description"
		   required="yes" 
		   size="30" 
	       maxlength="50" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Entity">:</TD>
    <TD class="labelmedium">
  	   <cfquery name="GetMission" 
			datasource="appsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	PM.*,
						M.MissionName,
						(M.MissionName + ' [' + M.Mission + ']') as MissionDisplay
				FROM 	Ref_ParameterMission PM
						INNER JOIN Organization.dbo.Ref_Mission M
							ON PM.Mission = M.Mission
		</cfquery>
		
		<cfselect style="width:300px" name="Mission" query="GetMission" display="MissionDisplay" class="regularxl" value="Mission" selected="#get.Mission#" required="Yes" message="Please select an entity">
		</cfselect>
	    
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Execution">:</TD>
    <TD class="labelmedium">
	
		<table><tr class="labelmedium">
		
		<td>			
			<input type="radio" name="Execution" value="0" <cfif get.Execution eq "0">checked</cfif>>				
		</td>
		<td style="padding-left:5px" class="labelit">
			<cf_tl id="Income">
		</td>
		
		<td style="padding-left:10px">			
			<input type="radio" name="Execution" value="1" <cfif get.Execution eq "1">checked</cfif>>				
		</td>
		<td style="padding-left:5px" class="labelit">
			<cf_tl id="Execution">
		</td>
		
		<td style="padding-left:10px">			
			<input type="radio" name="Execution" value="2" <cfif get.Execution eq "2">checked</cfif>>				
		</td>
		<td style="padding-left:5px" class="labelit">
			<cf_tl id="Income and Execution">
		</td>
				
		</tr></table>
  	 
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
