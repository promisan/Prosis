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

    <cfquery name="Clear" 
	    datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
		 DELETE FROM  ProgramActivityParent
		 WHERE     (ActivityId = ActivityParent)	
	</cfquery>
		 
    <cfquery name="Period" 
	     datasource="AppsProgram" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_Period
		 WHERE  Period = '#URL.Period#'
	</cfquery>
	
	<cfset perS = Period.DateEffective>
	<cfset perE = Period.DateExpiration>
	
	<cfquery name="PeriodListing" 
		     datasource="AppsProgram" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
		     FROM Ref_Period
			 WHERE IncludeListing = '1'
			 AND Period <= (SELECT MAX(Period) FROM ProgramPeriod WHERE ProgramCode = '#URL.ProgramCode#')
			 AND Period IN (SELECT Period FROM Organization.dbo.Ref_MissionPeriod WHERE Mission = '#url.Mission#') 			
			 
	</cfquery>
	
<cfoutput>	

<script>

	function resetft(val) {							
	try { document.getElementById("ftpln").style.fontWeight  = "normal"; } catch(e) {}
	try { document.getElementById("ftrev").style.fontWeight  = "normal"; } catch(e) {}
	try { document.getElementById("ftana").style.fontWeight  = "normal"; } catch(e) {}
	try { document.getElementById(val).style.fontWeight  = "bold"; } catch(e) {}
	}
	
</script>	

    <table width="99%" height="100%" cellspacing="0" cellpadding="0" align="center">	
	
	<tr>
		
	<td height="35" align="left" style="border-top: 0px solid Silver;border-left: 0px solid Silver;">
	
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td style="cursor: pointer;" id="progressrefresh" onclick="menuoption('gantt','1','0');resetft('ftpln');vwView[0].checked=true;">
			   <table cellspacing="0" cellpadding="0">
			   		   
			    <tr><td><input type="radio" class="radiol"  id="vwpln" name="vwView" value="pln">
				</td><td style="padding-left:6px" class="labelmedium" id="ftpln"><font color="808080"><cf_tl id="Planned Dates"></td>
				</tr>
				</table>
			</td>
			<td>&nbsp;</td>
			<td style="padding-left:10px;cursor: pointer;" onclick="menuoption('gantt','0','0');resetft('ftrev');vwView[1].checked=true;">	
			   <table cellspacing="0" cellpadding="0">
			    <tr><td><input type="radio" class="radiol"  id="vwrev" name="vwView" value="rev" checked>
				</td><td style="padding-left:6px" class="labelmedium" id="ftrev" style="font-weight:bold"><font color="808080"><cf_tl id="Actual Dates"></td>
				</tr>
				</table>				
			</td>	
			<td>&nbsp;</td>		
			<td style="padding-left:10px;cursor: pointer;" onclick="menuoption('graph','0','0');resetft('ftana');vwView[2].checked=true;">	
				  <table cellspacing="0" cellpadding="0">
			    <tr><td>
				<input type="radio" class="radiol"  id="vwana" name="vwView" value="ana">
				</td><td style="padding-left:6px" class="labelmedium" id="ftana"><font color="808080"><cf_tl id="Progress Analysis"></td>
				</tr>
				</table>	
			</td>
		</tr>
	</table>	
	</td>
		
	<td align="right" class="labelmedium" style="padding-right:10px;border-top: 0px solid Silver;border-right: 0px solid Silver;">
			
	<cf_tl id="Valid during Planning Period">:&nbsp;
	
	<select id="period" class="regularxl" name="period" onChange="menuoption('gantt','0','0')">
	    <option value=""><cf_tl id="ANY"></option>
		<cfloop query="PeriodListing">
		<option value="#PeriodListing.Period#" <cfif PeriodListing.Period eq URL.Period>selected</cfif>>#Period#</option>
		</cfloop>
	</select>
	
	</td>
	</tr>
	
	<tr><td class="line" colspan="2"></td></tr>
		
	<tr><td width="100%" align="center" height="100%" colspan="2" valign="top">
	
		<table width="99%" height="100%" style="border: 0px solid d4d4d4;">
			<tr><td valign="top" width="100%" height="100%" bgcolor="ffffff" id="detail">	  				
		  		  <cfinclude template="ActivityProgress.cfm">								 
			</td></tr>
		</table>
			
		</td>
	</tr>	
	
	</table>
			
</cfoutput>	