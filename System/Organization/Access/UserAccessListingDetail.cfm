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
<cfparam name="url.mod"    default="">
<cfparam name="url.mis"    default="">
<cfparam name="url.man"    default="">
<cfparam name="url.org"    default="">
<cfparam name="url.search" default="">

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Mandate
	WHERE  Mission = '#URL.mis#' 
	AND    MandateNo = '#URL.man#'
</cfquery>

<cfquery name="Access" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *, 
	        'Access' as Type
	FROM    OrganizationAuthorization A,
			<cfif mandate.recordcount eq "1" or url.org neq "">	
				 Organization Org,
			</cfif>	 
            Ref_AuthorizationRole R
	WHERE   A.Role = R.Role
	  
	  <cfif mandate.recordcount eq "1" or url.org neq "">	  
	  	AND    A.OrgUnit = Org.OrgUnit
		<cfif url.org eq "">
		AND    A.OrgUnitInherit = 0
	    </cfif>		
	  </cfif>
	  	  	  
	  AND    AccessLevel    < '8'
	  AND    A.UserAccount  = '#URL.ID#' 
	  
	  <cfif url.role neq "">
	   AND    A.Role         = '#URL.role#'
	  <cfelse>
	   AND    R.SystemModule = '#URL.Mod#'
	  </cfif>
	 	  
	  <cfif URL.Search neq "">
		AND      (R.Role LIKE '%#URL.Search#%' or R.Description LIKE '%#URL.Search#%')
	  </cfif>
	  	  
	  <cfif url.id1 eq "Global">
	  
	    AND    A.Mission is NULL
	    AND    (A.OrgUnit is NULL or A.OrgUnit = '') 
	  
	  <cfelse>
	  
		  <cfif URL.Mis neq "">
			  AND    A.Mission = '#URL.Mis#'
		  </cfif>
		  
		  <cfif mandate.recordcount eq "1">
		  
			  AND    A.OrgUnit IN (SELECT OrgUnit 
			                       FROM   Organization 
								   WHERE  Mission = '#URL.Mis#' 
								   AND    MandateNo = '#URL.Man#') 								   								   
		  
		  <cfelse>
		  
		      AND    (A.OrgUnit is NULL OR A.OrgUnit = ''
					 <cfif url.org neq "">
					 OR A.OrgUnit = '#url.org#'
					 </cfif>
					  )
		  </cfif>
		  
          <!---	KRW 17/07/07: Temporarily disabled for legacy purposes.  Investigate reason for this line	  
		  
		  AND A.AccessId IN (SELECT AccessId FROM UserAuthorizationActionLog WHERE UserAccount = '#URL.ID#')  --->
		  
	  </cfif>	  
		  	  
	UNION ALL
	
	SELECT   *, 'Denied' as Type
	FROM     OrganizationAuthorizationDeny A, 
		<cfif mandate.recordcount eq "1" or url.org neq "">
			 Organization Org,
		</cfif>	 
	         Ref_AuthorizationRole R 
	WHERE    A.Role = R.Role
	
	 <cfif mandate.recordcount eq "1" or url.org neq "">
	  
	  AND    A.OrgUnit	= Org.OrgUnit
	  <cfif url.org eq "">
		  AND    A.OrgUnitInherit = 0
	  </cfif>
	  </cfif>
	  
	  AND    AccessLevel < '8'
	  AND    A.UserAccount = '#URL.ID#' 
	  
	  <cfif url.role neq "">
	   AND    A.Role         = '#URL.role#'
	  <cfelse>
	   AND    R.SystemModule = '#URL.Mod#'
	  </cfif> 
	 
	  <cfif URL.id1 eq "Global">
	  AND    A.Mission is NULL
	  AND    (A.OrgUnit is NULL or A.OrgUnit = '')
	  <cfelse>
		  <cfif URL.Mis neq "">
			  AND    A.Mission = '#URL.Mis#'
		  </cfif>
		  
		  <cfif mandate.recordcount eq "1">
			  AND    A.OrgUnit IN (SELECT OrgUnit 
			                     FROM Organization 
								 WHERE Mission = '#URL.Mis#' 
								 AND MandateNo = '#URL.Man#')
								 
		  <cfelse>
		      AND    (A.OrgUnit is NULL or A.OrgUnit = '' 								 
					 <cfif url.org neq "">
					 OR A.OrgUnit = '#url.org#'
					 </cfif>)
		  </cfif>
	  </cfif>
	 
	ORDER BY A.Source, 
	         R.ListingOrder,
	         Type, 
			 A.Role, 
			 A.AccessLevel, 
			 A.GroupParameter,
			 A.ClassParameter  
             <cfif mandate.recordcount eq "1" or url.org neq "">, Org.HierarchyCode</cfif> 
			 
</cfquery>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffdf" class="navigation_table">
	
<cfif Access.recordcount eq "0">

	<tr><td align="center" class="labelmedium"><cf_tl id="Access revoked"></td></tr>
	
<cfelse>	
	
	<cfoutput query="Access" group="Source">
		
	<cfif url.role neq "">
	
		 <tr><td colspan="8" class="labelmedium" gcolor="ffffaf">&nbsp;Source: <b>#source#</td></tr>
				
	<cfelse>
	
		<cfif Source neq "Manual">
		<tr><td colspan="8">
			<table cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
			<td style="padding-left:3px" class="labelit">Inherited from user group: <b><a href="javascript:ShowUser('#source#')" title="Open account"><font color="0080FF">#source#</a>
			</b>
			</td>			
			<td style="padding-left:5px" class="labelit"><a href="javascript:sync('#source#','#url.id#','#url.id1#','#url.mis#','#url.man#','#url.mod#','#url.box#','#url.search#')" title="Synchronize Access"><font color="808080">[Press here to Synchronize]</font></a></td>
			<tr>
			</table>
		<cfelse>
		<tr><td height="24" colspan="8" align="center" class="labelmedium" bgcolor="B0D3EE" style="border-top:1px solid silver">Granted through Direct Entry</font></tr>
		</cfif>
	
	</cfif>
	
	<cfoutput group="Role">
		
	<cfoutput group="GroupParameter">
	
			
	<cfif url.role neq "">
	
		<!--- hide the description --->
		
		<cfif groupparameter neq "">
		
				<tr>
				<td colspan="8" height="24" class="labelit" style="padding-left:10px"><b>#Description#</b>:&nbsp;#GroupParameter#</td>
				</tr>
				
		</cfif>		
		
	<cfelse>
	
		
		<cfif groupparameter neq "">
			
			<cfif ParameterGroup eq "OccGroup">
			
			<cfquery name="Occ" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM   OccGroup
				WHERE  OccupationalGroup = '#GroupParameter#'
			</cfquery>
			
			<tr class="line">
				<td colspan="8" height="24" class="labelmedium" style="padding-left:10px;padding-left:2px">#Description#:&nbsp;#GroupParameter# #Occ.Description#</td>
			</tr>	
		
			<cfelse>
						
				<tr class="line">
				<td colspan="8" height="24" class="labelmedium" style="padding-left:2px">#Description#:&nbsp;#GroupParameter#</td>
				</tr>
				
			</cfif>
			
		<cfelse>
					
			<tr class="line">
				<td colspan="8" height="24" bgcolor="white" class="labelmedium" style="height:35px;font-size:20px;padding-left:2px">#Description#</td>
			</tr>
		
		</cfif>
	
	</cfif>
	
	<cfquery name="GroupAsOwner" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   * 
	    FROM     Ref_AuthorizationRoleOwner
		WHERE    Code = '#GroupParameter#'
	</cfquery> 
	<cfset des = "">
	
	<cfoutput>
	
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   AccessId 
	    FROM     UserAuthorizationActionLog 
		WHERE    AccessId = '#AccessId#'
		</cfquery> 
	   
		<tr class="navigation_row line fixlengthlist" bgcolor="<cfif type eq 'Denied'>FAD5CB<cfelse>ffffff</cfif>">
			
			<td width="6%" align="center" style="padding-right:5px" class="cellcontent">			  
			
				 <cfif url.role neq "">
				 
				 	<!--- no need to show edit functions --->
					
				 <cfelse>
			
					 <cfif Parameter eq "Owner">
					 
					 <!--- check if edit/delete can be shown to the office 
					 if the parameter listed for the role is an owner --->
					 
					 <cfinvoke component = "Service.Access"  
					   method            = "useradmin" 
					   accesslevel       = "'1','2'"
					   owner             = "#ClassParameter#"	   
					   treeaccess        = "Yes"		 
					   systemmodule      = "#SystemModule#"
					   returnvariable    = "access">
					   
					 <cfelseif groupasOwner.recordcount eq "1">
					   
					   <cfinvoke component = "Service.Access"  
					   method            = "useradmin" 
					   accesslevel       = "'1','2'"
					   owner             = "#groupParameter#"	   
					   treeaccess        = "Yes"		 
					   systemmodule      = "#SystemModule#"
					   returnvariable    = "access">
					   
					 <cfelse>
					 
					 	<!--- if other parameter we have to show it for now --->
					 
						 <cfset access = "EDIT">
						 
					 </cfif>  
					 
					 <table cellspacing="0" cellpadding="0">
					 <tr>
				 
						 <cfif access eq "EDIT" or access eq "ALL">
						 		<td style="padding-top:3px">								
								<cf_img icon="select" navigation="Yes" onclick="process('#mis#','#orgunit#','#role#','#id1#','#url.box#','#url.man#','#url.mod#','#url.search#')">
							    </td>
							 <cfif type neq "Denied" and Source eq "Manual">
							    <td style="padding-left:4px;padding-top:3px">
							 	<cf_img icon="delete" onclick="del('#accessid#','#url.id#','#url.id1#','#url.mis#','#url.man#','#url.mod#','#url.box#','#url.search#')">
								</td>
							  </cfif>					    
						 </cfif>
					  
					 </tr>					  
					 </table>
					  
				</cfif>	  
					  
			</td>
			<TD style="width:300px" colspan="2" class="cellcontent">
			
			<cfif ClassIsAction eq "1">
			
				<cfquery name="Action" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM Ref_EntityAction
				WHERE ActionCode = '#ClassParameter#'
				</cfquery>
				
				#Action.EntityCode#&nbsp;:&nbsp;#Action.ActionDescription#
				
			<cfelse>
			
				<cfif isValid("guid",ClassParameter)>
					
				<cfquery name="System" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM Ref_ModuleControl
				WHERE SystemFunctionId = '#ClassParameter#'
				</cfquery>
				
				#System.FunctionName#				
				
				<cfelse>
				
				#ClassParameter#
				
				</cfif>
				
			</cfif>
							
			</TD>
			<td colspan="2" class="cellcontent">
			
			<cfif OrgUnit neq "">					
							
				 <cfquery name="Check" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT TOP 1 *
					FROM   OrganizationAuthorization
					WHERE  UserAccount = '#UserAccount#'
					AND    OrgUnitInherit = '#OrgUnit#'
					AND    Role           = '#Role#'
					AND    ClassParameter = '#ClassParameter#'
				</cfquery>
			
			    <table width="100%" cellspacing="0" cellpadding="0">
				<tr><td width="30"><cfif check.recordcount gte 1><b><img src="#SESSION.root#/Images/tree2.gif"
					                                      alt="Children"				                                     												  
					                                      border="0"></b></cfif></td>
					<td width="80" class="cellcontent">#HierarchyCode#</td>
				    <td class="cellcontent">#OrgUnitName#</td>									  
				 </tr>
				 </table>
								 			
				<cfelse>
				
				<cf_tl id="All units">
				
			</cfif>
			</td>
			<td width="20" align="center" style="padding-left:4px"><cfif recordstatus eq "5">;
			<img src="#SESSION.root#/Images/locked.jpg" alt="" align="absmiddle" border="0">
			</cfif></td>
			<td height="20" class="cellcontent">
			
			   	<cf_space spaces="30">
			      <cfif Parameter eq "Entity">
				  <cfif AccessLevel eq "0">Coll.
				  <cfelse>Actor
				  </cfif>				  
				  <cfelse>
					<cfif AccessLevel eq "0">Read
			        <cfelseif AccessLevel eq "1">Edit
					<cfelse>All
					</cfif>
			      </cfif>
				  						
								
			</td>
			
			<cfif url.role eq "">
			
				<cfif type neq "Denied">
					<td class="cellcontent"><cf_space spaces="60">#OfficerLastName#:#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
				<cfelse>
					<td width="15%" class="cellcontent">
					<a href="javascript:restore('#accessid#','#url.id#','#url.id1#','#url.search#','#url.mod#','#url.mis#','#url.man#','#url.box#')">Reinstate</a>&nbsp;
					</td>
				</cfif>
			
			</cfif>
			
		</TR>
				
		<cfset des = Description>
		
	</CFOUTPUT>			
	</CFOUTPUT>	
	</CFOUTPUT>	
	</CFOUTPUT>	

</cfif>

</TABLE>

<cfset ajaxonload("doHighlight")>