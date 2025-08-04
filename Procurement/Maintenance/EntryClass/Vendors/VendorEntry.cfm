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
<cf_compression>


<cfquery name="Parameters" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_ParameterMission
	WHERE 	Mission IN (SELECT Mission FROM Ref_ParameterMissionEntryClass WHERE EntryClass = '#url.entryclass#')
</cfquery>

<cfquery name="Vendors" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT 	E.*,
			O.OrgUnitCode,
			O.OrgUnitName,
			O.OrgUnit,
			UPPER(O.Mission) as Mission,
			O.parentOrgUnit
    FROM   	Ref_EntryClassVendor E
			INNER JOIN Organization.dbo.Organization O
				ON E.OrgUnitVendor = O.OrgUnit
	WHERE  	E.EntryClass = '#url.entryclass#'
	AND    	E.OrgUnitVendor IN (SELECT OrgUnit 
	                         FROM   Organization.dbo.Organization 
							 WHERE  Mission IN 
							 			(
											SELECT 	TreeVendor
											FROM 	Ref_ParameterMission
											WHERE 	Mission IN (SELECT Mission FROM Ref_ParameterMissionEntryClass WHERE EntryClass = '#url.entryclass#')
							 			)
							 )
	ORDER BY UPPER(O.Mission), O.HierarchyCode
</cfquery>

<cfquery name="Check" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	OrgUnit 
	FROM   	Organization.dbo.Organization 
	WHERE 	Mission IN 
	 			(
					SELECT 	TreeVendor
					FROM 	Purchase.dbo.Ref_ParameterMission
					WHERE 	Mission IN (SELECT Mission FROM Purchase.dbo.Ref_ParameterMissionEntryClass WHERE EntryClass = '#url.entryclass#')
	 			)
</cfquery>


<cfoutput>
<cfif parameters.treevendor eq "" or check.recordcount eq "0">
<table width="100%"><tr><td align="center" class="labelit">
<font color="0080C0"><b>Attention:</b> No vendor tree or vendor nodes defined for this entry class</font>
</td></tr></table>
<cfabort>
</cfif>
</cfoutput>

<cfquery name="getClass" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT 	*
	FROM 	Ref_EntryClass
	WHERE	Code = '#url.entryclass#'
	
</cfquery>

<cfquery name="VendorList" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *,
			UPPER(Mission) as gMission,
			CASE 
				WHEN (parentOrgUnit = '' or parentOrgUnit is null) THEN (OrgUnitCode + ' ' + OrgUnitName)
				ELSE (OrgUnitCode + ' ' + OrgUnitName)
			END AS Display
	FROM    Organization
	WHERE   Mission IN 
	 			(
					SELECT 	TreeVendor
					FROM 	Purchase.dbo.Ref_ParameterMission
					WHERE 	Mission IN (SELECT Mission FROM Purchase.dbo.Ref_ParameterMissionEntryClass WHERE EntryClass = '#url.entryclass#')
	 			)
	AND     OrgUnit NOT IN (SELECT OrgUnitVendor 
	                       FROM   Purchase.dbo.Ref_EntryClassVendor 
						   WHERE  EntryClass = '#url.entryclass#')
    ORDER BY gMission, HierarchyCode
</cfquery>

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">

  <tr><td height="5"></td></tr>
  <tr>
  	<td style="color:808080;" class="labelit">** All vendors added here, will be inherited to all item masters within the entry class <cfoutput><b>#getClass.description#</b></cfoutput>.</td>
  </tr>
  
  <tr><td height="10"></td></tr>
   
  <tr>
    <td width="100%">
    <table width="100%">
			   
	<cfset p = 0>
	
	<tr class="labelmedium line">
		<td></td>
		<td><cf_tl id="Code"></td>
	    <td><cf_tl id="Name"></td>
		<td><cf_tl id="Officer"></td>
		<td></td>
	</tr>
	
	<cfoutput query="Vendors" group="Mission">
		
		<tr><td colspan="5" class="labelmedium">#Mission#</td></tr>
		<tr><td colspan="5" class="line"></td></tr>
			
		<cfoutput>
		
			<TR class="labelmedium line">
			<td width="10"></td>
			<td style="min-width:100px" height="18">
				<cfif parentOrgUnit neq "">&nbsp;</cfif>#OrgUnitCode#
			</td>
			<td width="70%">#OrgUnitName#</td>
			<td>#OfficerLastName#</td>				
			<td align="right" style="padding-top:3px;padding-right:10px">
			  <cf_img icon="delete" onclick="ptoken.navigate('Vendors/VendorEntryPurge.cfm?entryclass=#url.entryclass#&vendor=#orgUnit#&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1');">
			</td>			
			</TR>
		
		</cfoutput>
		
		<tr><td height="5"></td></tr>
  
	</cfoutput>	   
  	 
  <cfif url.vendor eq "">
  
  		<tr><td height="5"></td></tr>
  		<TR>	
		   <td colspan="5">
		   
		   <cfform name="frmVendorEntry">
		   
		   <table>
               <tr>
                   <td>

                    <cf_UIselect style="width:500px;" name="VendorCode" id="VendorCode" filter = "contains" 
					 query="#VendorList#" class="regularxl" group="gMission" display="display" value="OrgUnit"/>
                    
                   </td>
               </tr>
               <tr>
                   <td style="padding:10px 0 0;text-align: right;">
                   <cfoutput>

                       <input type="button" value=" Save " style="height:25" class="button10g" 
                       onclick="ptoken.navigate('Vendors/VendorEntrySubmit.cfm?entryclass=#url.entryclass#&vendor='+document.getElementById('VendorCode').value+'&idmenu=#url.idmenu#&fmission=#url.fmission#','contentbox1')">

                   </cfoutput>

                   </td>
               </tr>
            </table>
		   
		   </cfform>
			   
	</TR>
</cfif>
	

</TABLE>
</TD>
</TR>
</TABLE>

