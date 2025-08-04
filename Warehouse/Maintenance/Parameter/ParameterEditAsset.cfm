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

<cfoutput>

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr><td height="8"></td></tr>
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM Organization
	WHERE OrgUnit = '#get.ReceiptOrgunit#' 
	</cfquery>
		
	<TR>
    <td width="100" class="labelmedium2">Default Receipt Unit:</b></td>
    <TD width="75%">
	    
	 	<cfoutput>
		   <table cellspacing="0" cellpadding="0">
		    <tr><td>
			<input type="button" class="button7" style="height:25;width:30px" name="search" id="save" value=" ... " onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass','#url.mission#', '')"> 
			</td>
			<td style="padding:2px">
			<input type="text" name="orgunitname" id="orgunitname" value="#Org.OrgUnitName#" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
			<input type="hidden" name="orgunitclass" id="orgunitclass" value="" class="disabled" size="15" maxlength="15" readonly style="text-align: left;"> 
			<input type="hidden" name="mandateno" id="mandateno" value="#Org.MandateNo#">
			<input type="hidden" name="orgunit" id="orgunit" value="#Org.OrgUnit#"> 
			<input type="hidden" name="mission" id="mission" value="#url.mission#">
			<input type="hidden" name="orgunitcode" id="orgunitcode" value="">
			</td></tr>
			</table>
		</cfoutput>
  	</TD>
	</TR>
	
	<cfquery name="Loc" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Location
			<cfif get.receiptlocation neq "">
			WHERE 	Location = '#get.ReceiptLocation#' 
			<cfelse>
			WHERE 	1=0
			</cfif>
	</cfquery>
	
	<TR>
    <td class="labelmedium2">Default Receipt Location:</b></td>
    <TD>
		 <table cellspacing="0" cellpadding="0">
		    <tr><td>
			
		    <input type="button" class="button7" style="height:25;width:30px" name="search" id="search" value=" ... " onClick="selectloc('movement','location','locationcode','locationname','','','','','#url.mission#')"> 
			</td><td style="padding:2px">
			<input type="text" name="locationname" id="locationname" value="#loc.LocationName#" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
			<input type="hidden" name="location" id="location" value="#loc.Location#"> 
			<input type="hidden" name="locationcode" id="locationcode" value="#loc.LocationCode#">
			</td></tr>
		</table>
	 </td>
    </tr>
	
	<tr>
		<td class="labelmedium2">Last Year of Depreciation</td>
		<td><select name="LastYearDepreciation" id="LastYearDepreciation" class="regularxl">
		<cfloop index="itm" list="2008,2009,2010,2011,2012,2013,2014,2015" delimiters=",">
		<option value="#itm#" <cfif get.lastyeardepreciation eq "#itm#">selected</cfif>>#itm#</option>
		#itm#
		</cfloop>
		</select>
	</td>
	
	</tr>
	
	<tr><td height="4"></td></tr>
		
	</table>
	
</cfoutput>	