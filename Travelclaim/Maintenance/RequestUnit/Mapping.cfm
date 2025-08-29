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
<cfif url.action eq "save">
	
	<cfif url.orgunit neq "new">
	
		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM  Organization
			WHERE  OrgUnit = '#URL.OrgUnit#'
		</cfquery>
	
	</cfif>
	
	<cfquery name="Class" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT TOP 1 * FROM Ref_OrgUnitClass
		ORDER BY ListingOrder
	</cfquery>
	
	<cfif URL.mapsrc eq "">
	
	<table width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center"><font color="FF0000"><b>You must enter a User Group</font></td>
	</tr>
	</table>
	
	<cfelse>
		
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Organization
			WHERE  Mission     = '#URL.Mission#'
			AND    SourceCode  = '#URL.MapOrg#'
			AND    SourceGroup = '#URL.MapSrc#'
		</cfquery>
		
		<cfif check.recordcount gte "1">
		
			<table width="100%" cellspacing="0" cellpadding="0">
			<tr>
			<cfoutput>
			<td align="center"><font color="FF0000">Problem: combination #url.maporg# #url.mapsrc# has been recorded already</font></td>
			</cfoutput>
			</tr>
			</table>
				
		<cfelse>	
		
						
			<cfquery name="Prior" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
				FROM   Organization
				WHERE  Mission        = '#URL.Mission#'
				AND    ParentOrgUnit  =  '#url.orgunitcode#' 
				ORDER BY CREATED DESC
			</cfquery>	
								
			<cfset ln  = Len(Prior.OrgUnitCode)>		
			<cfset pos = Find("_", Prior.OrgUnitCode)>
			<cfif pos gte "1">
				<cfset no = right(Prior.OrgUnitCode,ln-pos)>
				<cfset no = no+1>
			<cfelse>
				<cfset no = 1>
			</cfif>
									
			<cfquery name="InsertOrganization" 
				     datasource="AppsOrganization" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO Organization
				         (Mission,
						  MandateNo, 
						  OrgUnitCode,
						  TreeOrder,
						  OrgUnitName,
						  OrgUnitClass,
						  ParentOrgUnit,
						  Source,
						  SourceGroup,
						  SourceCode,
						  OfficerUserId,
						  OfficerLastName,
						  OfficerFirstName)
				      VALUES ('#URL.Mission#',
				          'P001',
						  '#url.orgunitcode#_#no#',
						  '1',
						  '#URL.mapnme#',
						  '#class.OrgUnitClass#',
						  '#url.orgunitcode#',
						  'MAPPING',
						  '#url.mapsrc#',
						  '#URL.maporg#',
						  '#SESSION.acc#',
				    	  '#SESSION.last#',		  
					  	  '#SESSION.first#')
			 </cfquery>
			 
			 </cfif>
						
	   </cfif>	

</cfif>

<cfif url.action eq "delete">
	
	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM  Organization
		WHERE  OrgUnit = '#URL.OrgUnit#'
	</cfquery>

</cfif>

<cfquery name="Mapping" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  Organization
	WHERE Mission       = '#URL.Mission#'
	AND   ParentOrgUnit = '#URL.OrgUnitCode#'
</cfquery>
	
<table width="60%" cellspacing="0" cellpadding="2" align="center">
		   	
	    <tr style="height:20px;">
		   <td width="12%" class="label"><b>User Group</b></td>
		   <td width="30%" class="label"><b>Unit Code (blank=all)</b></td>
		   <td width="44%" class="label"><b>Name</b></td>
		   <td align="right">
		   <cfoutput>
			     <A href="javascript:edit('#url.orgunitcode#','#url.box#','new','new')"><b>[add]</b></a>
			</cfoutput>
		   </td>		  
	    </TR>	
			
		<cfoutput>
		<cfloop query="Mapping">
		
		<tr><td class="linedotted" colspan="4"></td></tr>
																		
		<cfif URL.orgunit eq orgunit>
											
			<TR>
			   <td>
		      	   <input type="Text" value="#sourcegroup#" name="sourcegroup_#url.orgunitcode#" id="sourcegroup_#url.orgunitcode#" size="12" maxlength="12" class="regular">
		       </td>
			   <td class="regular">
			   	   <input type="Text" value="#sourcecode#" name="sourcecode_#url.orgunitcode#" id="sourcecode_#url.orgunitcode#" size="6" maxlength="6" class="regular">
	           </td>
			      <td class="regular">
			   	   <input type="Text" value="#orgunitname#" name="orgunitname_#url.orgunitcode#" id="orgunitname_#url.orgunitcode#" size="60" maxlength="80" class="regular">
	           </td>
			   
			   <td colspan="2" align="right">
				   <input type="button" value="Save" class="button10s" onclick="javascript:edit('#url.orgunitcode#','#url.box#','#orgunit#','save')">&nbsp;
			   </td>
		    </TR>	
					
		<cfelse>
	
			<TR>
			   <td height="20">#sourcegroup#</td>
			   <td><cfif sourcecode eq "">All units</b><cfelse>#sourcecode#</cfif></td>
			   <td>#orgunitname#</td>
			   <td align="center">

			   	<table>
					<tr>
						<td>
							<cf_img icon="edit" onclick="edit('#url.orgunitcode#','#url.box#','#orgunit#','edit')">
						</td>
						<td>
							<cf_img icon="delete" onclick="edit('#url.orgunitcode#','#url.box#','#orgunit#','delete')">
						</td>
					</tr>
				</table>
				 
			    </td>
			 </TR>	
		
		</cfif>
						
		</cfloop>
		
									
		<cfif URL.orgunit eq "new" or mapping.recordcount eq "0">
				
			<TR bgcolor="ffffdf">
			   <td></td>
			   <td height="26"><input type="Text" name="sourcegroup_#url.orgunitcode#" id="sourcegroup_#url.orgunitcode#" size="12" maxlength="12" class="regular"></td>
			   <td><input type="Text" name="sourcecode_#url.orgunitcode#"  id="sourcecode_#url.orgunitcode#"size="6" maxlength="6" class="regular"></td>
			   <td><input type="Text" name="orgunitname_#url.orgunitcode#" id="orgunitname_#url.orgunitcode#" size="60" maxlength="80" class="regular"></td>
			   <td align="center">
				<input type="button" value="Add" class="button10s" style="width:50" onclick="javascript:edit('#url.orgunitcode#','#url.box#','new','save')">
				</td>
		    </TR>	
	    
			</TR>	
											
		</cfif>	
		
		</cfoutput>
					
	</table>
		
		