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
<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Position
	WHERE PositionNo = '#URL.ID#' 
</cfquery>

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mission
	WHERE  Mission IN (SELECT Mission 
	                   FROM   Organization 
					   WHERE  OrgUnit = '#Position.OrgUnitOperational#')
</cfquery>


<cfinvoke component="Service.Access"  
  method         = "position" 
  orgunit        = "#Position.OrgUnitOperational#" 
  role           = "'HRPosition'"
  posttype       = "#Position.PostType#"
  returnvariable = "accessPosition">
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="C0C0C0">

<tr class="hide"><td id="wfresult"></td></tr>
<tr><td>
	
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		
		<cfquery name="Master" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT DISTINCT Area
		  FROM Ref_OrganizationCategory
		  WHERE    Owner = '#Mission.MissionOwner#'
		  ORDER BY Area
		</cfquery>
		
		<cfloop query="Master">
		
		        <cfset ar = Master.Area>
				
				<cfquery name="GroupAll" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
					SELECT F.*, S.PositionNo as Selected
					FROM   PositionCategory S RIGHT OUTER JOIN Organization.dbo.Ref_OrganizationCategory F ON S.OrganizationCategory = F.Code
					   AND S.PositionNo = '#URL.ID#'
					WHERE  F.Area = '#Ar#'
					AND    F.Owner = '#Mission.MissionOwner#'
				</cfquery>
											
	  <tr><td>
						
		   <table width="100%">
					
				<cfoutput>
				
				<TR><td align="left" class="labelmedium" style="height:23;padding-left:4px">
				
		    		<cfquery name="Check" 
				    datasource="AppsEmployee" 
		   		    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
		    		SELECT S.PositionNo
				    FROM   PositionCategory S, 
				           Organization.dbo.Ref_OrganizationCategory F
				    WHERE  S.PositionNo = '#URL.ID#'
				    AND    S.OrganizationCategory = F.Code
				    AND    F.Area = '#Ar#'
				    </cfquery>
						   
				   <img src="#SESSION.root#/Images/zoomin.jpg" alt="Expand" 
				   id="#Ar#Exp" border="0" class="<cfif Check.recordCount gt "0">hide<cfelse>regular</cfif>" 
				   align="absmiddle" style="cursor: pointer;" onClick="expand('#Ar#')">
				   
				   <img src="#SESSION.root#/Images/zoomout.jpg" 
				    id="#Ar#Min"
				    alt="Hide" border="0" align="absmiddle" class="<cfif Check.recordCount gt "0">regular<cfelse>hide</cfif>" style="cursor: pointer;" 
				   onClick="expand('#Ar#')">
						    		   
					<a href="javascript:expand('#Ar#')">#Ar#</a></td></TR>
					
					</cfoutput>
					
					<tr><td class="linedotted"></td></tr>
									
		    		<TR><td width="100%">
										
				    <cfoutput>
								
					<cfif Check.recordCount gt "0" or Master.recordcount lte "2">
					
		    			<table width="100%" border="0" align="right" id="#Ar#">
					
					<cfelse>
					
			    		<table width="100%" border="0" align="right" class="hide" id="#Ar#">
								
					</cfif>
					
					</cfoutput>
		
					<tr>
		    			<td width="30" valign="top" style="padding-left:6px"><img src="<cfoutput>#SESSION.root#</cfoutput>/Images/join.gif" alt=""></td>
						<td width="100%">
						<table width="100%" cellspacing="0" cellpadding="0" align="left">
											
							<cfoutput query="GroupAll">
												
								<cfif CurrentRow MOD 2><TR></cfif>
								
									<td width="50%" style="padding:1px">
									<table width="100%" cellspacing="0" cellpadding="0">
										<cfif Selected eq "">
										          <TR class="regular">
										<cfelse>  <TR class="highlight2">
										</cfif>
									   	<TD width="15%" class="labelit" style="padding-left:4px">#Code#</TD>
									    <TD width="75%" class="labelit" style="padding-left:8px">#Description#</TD>
										<td width="10%" align="right" style="height:20px;padding-right:3px">
										
											<cfif accessPosition eq "All">
											
													<input type="checkbox" 
													   name="category" class="radiol"
													   value="#Code#" <cfif Selected neq "">checked</cfif>
													   onClick="hl(this,this.checked,'#url.id#','#code#')">								   
																				   
											</cfif>   
										   
										</td>
										
									</table>
									</td>
									<cfif GroupAll.recordCount eq "1">								
			    						<td width="50%"></td>									
									</cfif>
									
								<cfif CurrentRow MOD 2><cfelse></TR>
								
								<tr><td colspan="2" class="linedotted"></td></tr>
								
								</cfif> 	
							
							</CFOUTPUT>
														
					    </table>						
						</td></tr>						
						</table>
											
					</td></tr>
									
				</table>
				
			</td></tr>
				
		</cfloop>		
				
		</table>
		
	</td></tr>
		
</table>

</td></tr>

</table>
