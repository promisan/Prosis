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
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission IN (SELECT Mission 
	                  FROM   Organization.dbo.Ref_MissionModule 
					  WHERE  SystemModule IN ('Budget','Program'))
					  
	AND Mission IN (SELECT Mission
					FROM Ref_AllotmentEdition 
				    WHERE EditionId IN (SELECT DISTINCT EditionId FROM ProgramAllotmentRequest)		
					)									 
				  
</cfquery>

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp"  
			  label="Snapshot"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST">

<table width="96%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td></td></tr>
	<cfoutput>
    <TR>
    <TD class="labelmedium">Date:</TD>
    <TD class="labelmedium">
  	   #dateformat(now(),CLIENT.DateFormatShow)#
    </TD>
	</TR>
	</cfoutput>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Entity">:</TD>
    <TD>
		<cfoutput>
			<select name="mission" class="regularxl">
	        	<cfloop query="Mission">
	        	<option value="#Mission#">#Mission#</option>
	         	</cfloop>
		    </select>
		</cfoutput>		
	</TD>
	</TR>
	
	<TR>
    <TD class="Labelmedium"><cf_tl id="Period">:</TD>
	<TD>
	    <cfdiv bind="url:SelectPeriod.cfm?mission={mission}" id="boxperiod">
	</TD>
	</TR>
	
	<TR>
    <TD class="Labelmedium"><cf_tl id="Edition">:</TD>
    <TD>
		<cfdiv bind="url:SelectEdition.cfm?mission={mission}" id="boxedition">
    </TD>
	</TR>	
	
	<TR>
    <TD class="Labelmedium"><cf_tl id="Memo">:</TD>
    <TD>
		   <cfinput type="text" name="Memo" value="" message="please enter a description" size="30" maxlenght= "90" class= "regularxl">
    </TD>
	</TR>	
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>	
			
	<tr>	
	<td colspan="2" align="center" height="40">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Take Snapshot">
	
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>

