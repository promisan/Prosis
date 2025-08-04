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

<cfparam name="url.orgunit" default="">

<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   RequisitionLine	  
		WHERE  RequisitionNo = '#url.id#'
</cfquery>

<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Organization  
		<cfif url.orgunit eq "">
		WHERE  OrgUnit= '#line.orgunitimplement#'	
		<cfelse>
		WHERE  OrgUnit= '#url.orgunit#'	
		</cfif>	
</cfquery>

<cfif url.orgunit neq "" and line.orgunit neq url.orgunit>

	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Organization  
		WHERE  OrgUnit = '#url.orgunit#'	
	</cfquery>
	
	<cfif Check.recordcount eq "1">

		<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    UPDATE RequisitionLine	  
			SET    OrgUnit = '#url.orgunit#' 
			WHERE  RequisitionNo = '#url.id#'
		</cfquery>
	
	</cfif>

</cfif>

<cfif Org.recordcount eq "0">
	
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
		<tr>
		<td height="30" align="center" height="40"><b><font color="FF0000">We encountered a problem with locating the unit of this request.</font></b></td>
		</tr>
		
	</table>	
	
<cfelse>
	
	<cfoutput>
	
	<table width="100%" height="100%" cellspacing="0" class="formpadding">
		
		<tr><td height="30">
			<table class="formspacing">
			<tr>
				<td style="padding-left:8px">
				<input type="radio" 
				    id="selectunit" 
				    name="selectunit" 
				    value="st" 
					class="radiol"
					checked
				    onclick="document.getElementById('unitst').style.fontWeight='bold';maintainquick('#line.mission#','#org.mandateno#','#org.orgunitcode#')">
				</td>
				<td style="padding-left:5px" class="labelmedium" id="unitst">Staffing Table</font></td>				
				<td style="padding-left:8px">
				<input type="radio" class="radiol" id="selectunit" name="selectunit" value="ex" onclick="" disabled>
				</td>
				<td class="labelmedium" style="padding-left:5px" id="unitex">Budget Execution and Project [pending]</font></td>		
				
			</tr>
			</table>
		</tr>
		
		<tr><td class="linedotted"></td></tr>
			
		<tr><td height="99%" style="cursor:wait">
		
			<cfparam name="url.mid" default="">
			
			<iframe src="#SESSION.root#/Staffing/Application/Position/MandateView/MandateViewGeneral.cfm?header=no&ID=ORG&ID1=#org.orgunitcode#&ID2=#line.mission#&ID3=#org.mandateno#&mid=#url.mid#" 
				name="unitinfoframe" 
				id="unitinfoframe" 
				width="100%" 
				height="100%" 
				scrolling="no" 
				frameborder="0">
			
			</iframe>
			
		</td></tr>
		
	</table>
	
	</cfoutput>
		
</cfif>


