<cf_compression>

<cfparam name="URL.ID1" default="">

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT Mission
	FROM ItemMaster
	WHERE Code = '#URL.ID#'
	UNION
	SELECT Mission
	FROM ItemMasterMission
	WHERE ItemMaster = '#URL.ID#'
</cfquery>

<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
		   
<tr>
    <td width="100%">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="navigation_table">
			   
	<cfset p = 0>
	
	<tr class="labelmedium line">
		<td></td>
		<td><cf_tl id="Code"></td>
	    <td><cf_tl id="Name"></td>
		<td><cf_tl id="Prefer"></td>
		<td align="center"><cf_tl id="Operational"></td>
		<td><cf_tl id="Source"></td>
		<td align="center"><cf_tl id="Action"></td>
	
	</tr>
	
	<tr><td height="5"></td></tr>
						
	<cfloop query="get">
	
			<cfoutput>
			
			<tr class="line"><td colspan="7" class="labelmedium"><b>#get.Mission#</td></tr>
						
			</cfoutput>
	
			<cfquery name="Parameters" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_ParameterMission
				WHERE Mission = '#mission#'
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
			    FROM   	ItemMasterVendor E
						INNER JOIN Organization.dbo.Organization O
							ON E.OrgUnitVendor = O.OrgUnit
				WHERE  	E.Code = '#URL.ID#'
				AND     E.Mission = '#mission#'
				AND    	E.OrgUnitVendor IN (SELECT OrgUnit 
				                            FROM   Organization.dbo.Organization 
										    WHERE  Mission= '#parameters.treevendor#')
				ORDER BY UPPER(O.Mission), O.HierarchyCode
			</cfquery>
			
			<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT OrgUnit 
				FROM   Organization.dbo.Organization 
				WHERE  Mission= '#parameters.treevendor#'
			</cfquery>
			
			<cfoutput>
			
				<cfif parameters.treevendor eq "" or check.recordcount eq "0">
				<table width="100%"><tr><td align="center" class="labeL">
				<font color="0080C0"><b><cf_tl id="Attention">:</b> <cf_tl id="No vendor tree or vendor nodes defined for" class="message"> #mission#</font>
				</td></tr></table>
				</cfif>
				
			</cfoutput>
			
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
				WHERE   Mission = '#parameters.treevendor#' 
				AND     OrgUnit NOT IN (SELECT OrgUnitVendor 
				                        FROM   Purchase.dbo.ItemMasterVendor 
									    WHERE  Code = '#URL.ID#')
			    ORDER BY gMission, HierarchyCode
			</cfquery>
						
			<cfoutput query="Vendors" group="Mission">		
				
			<cfoutput>
			
			<TR class="navigation_row labelmedium line">
				<td width="10"></td>
				<td height="18">#OrgUnitCode#</td>			
				<td width="60%">#OrgUnitName#</td>
				<td width="20"><cfif Preferred eq "1">
				<b>Yes</b><cfelse>				
				 <a href="javascript:ptoken.navigate('Vendors/setPreferred.cfm?action=delete&mission=#mission#&ID=#URL.ID#&ID1=#OrgUnitVendor#','contentbox1');"><font color="gray">
				 <img src="#client.root#/images/favorite.png" alt="" border="0"></a>
				
				</cfif></td>
				<td align="center">
					<cfif operational eq 1>
						<cf_tl id="Yes">
					<cfelse>
						<b><cf_tl id="No"></b>
					</cfif>
				</td>
				<td>#Source#</td>				
				<td align="center" style="padding-top:3px;padding-right:10px">
				  <cf_img icon="delete" onclick="ptoken.navigate('Vendors/VendorEntryPurge.cfm?action=delete&mission=#mission#&ID=#URL.ID#&ID1=#OrgUnitVendor#','contentbox1');">
				</td>			
			</TR>
			
			</cfoutput>
				  
		    </cfoutput>	   
		  	 
			<cfif url.id1 eq "">
			  		
			  		<TR style="height:30px;padding-top:3px">	
					   <td colspan="7" height="30" style="padding-left:30px">
					   					   
					   <cfform name="frmItemVendorEntry">
					   
					   	<table><tr><td style="padding-top:2px">
				   
					  		<cf_UIselect name="VendorCode_#mission#" filter="contains" style="width:300px" class="regularxl" id="VendorCode_#Mission#" query="#VendorList#" group="gMission" display="display" value="OrgUnit"></cf_UIselect> 
							
							</td>
						   				   
						   <cfoutput>
						   
						    <td style="padding-left:3px;padding-top:2px">
						   		<cf_tl id="Save" var="vSave">						
							   <input type="button" value="#vSave#" style="height:30;width:100" class="button10s" 
							   onclick="ptoken.navigate('Vendors/VendorEntrySubmit.cfm?mission=#mission#&id=#url.id#&vendorcode='+document.getElementById('VendorCode_#mission#').value,'contentbox1')">
							</td>  
						   </cfoutput>
					       </tr>
						   
						  </table> 
					   </cfform>
						   
				    </TR>
			
			</cfif>
	
	</cfloop>	
		
	</TABLE>
		
	</TD>
	</TR>
	
		
</TABLE>

<cfset AjaxOnLoad("doHighlight")>
