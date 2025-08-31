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
<cfparam name="url.id" default="">

<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   OrganizationObject
	 WHERE  ObjectKeyValue4   = '#URL.id#' or ObjectId = '#URL.id#' 
</cfquery>	

<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Observation
		WHERE   ObservationId = '#URL.id#'
</cfquery>

<table width="100%" height="100%"><tr><td bgcolor="FFFFFF"  class="formpadding" valign="top">

<cfform name="formamend" style="width:100%" action="DocumentEditSubmit.cfm?observationid=#url.id#" method="POST">
	
	<table width="92%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td height="10px"></td></tr>
	<tr><td colspan="2" style="height:35px" class="labellarge"><b>Convert ticket to amendment request</td></tr>
	
	<cfoutput query="Observation">
	
	<tr><td class="xxhide" id="amendresult" align="center" colspan="2"></td></tr>
			
	<tr>
	
		<td style="padding-left:10px" width="160" class="labelmedium">
			<cfif url.ObservationClass eq "Inquiry">
				<cf_tl id="Server">:
			<cfelse>
				<cf_tl id="Owner">:
			</cfif>
		</td>
		
	    <td class="labelmedium">
				
			<cfif url.ObservationClass eq "Inquiry">
			
				<cfquery name="Site" 
				datasource="AppsControl" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
		    		SELECT  *
					FROM    ParameterSite
					WHERE   Operational = 1
					ORDER   BY ListingOrder
				</cfquery>
			
				<select name="amendApplicationServer" id="amendApplicationServer" class="regularxl">
				    <cfloop query="Site">
						<option value="#ApplicationServer#" <cfif ApplicationServer eq Observation.ApplicationServer>selected</cfif>>#ServerDomain#</option>
					</cfloop>
		    	</select>	
										
			<cfelse>
			
					<cfquery name="getOwner" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT   *
						FROM     Ref_AuthorizationRoleOwner				
					</cfquery>
					
					<select name="amendOwner" id="amendOwner" class="regularxl">
					
						<cfloop query="getOwner">
					
							<cfinvoke component = "Service.Access"  
								method           = "ShowEntity" 
								entityCode       = "SysChange"				
								Owner            = "#getOwner.code#"
								returnvariable   = "access">
							
							<cfif Access eq "EDIT" or Access eq "ALL">	
								<option value="#Code#" <cfif Code eq Observation.Owner>selected</cfif> >#Code#</option>
							</cfif>
							
						</cfloop>		
					
					</select>
			
			</cfif>
				
		</td>
		</tr>		
				
		<tr>
		
			<td style="padding-left:10px" class="labelmedium">
				<cfif url.ObservationClass eq "Inquiry">
					<cf_tl id="Application">:
				<cfelse>
					<cf_tl id="Module">:
				</cfif>
			</td>
		
				<td>
			
					<table cellspacing="0" cellpadding="0">
					
					<tr>
					
					<cfif url.ObservationClass eq "Inquiry">
					
						<td class="labelmedium">
						
							<cfquery name="QApplication" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
								FROM    Ref_Application
								WHERE   Usage != 'System'
								AND     Operational = 1
							</cfquery>
					
							<cfif QApplication.recordcount eq "0">
					
								<cfquery name="QApplication" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT  *
										FROM    Ref_Application
										WHERE   Operational = 1
								</cfquery>
						
							</cfif>
																							
								<select name="amendWorkgroup" id="amendWorkgroup" class="regularxl">
								    <cfloop query="QApplication">
										<option value="#Code#" <cfif Code eq Object.EntityGroup>selected</cfif>>#Description#</option>
									</cfloop>
							    </select>
															
						</td>
						
						<td>&nbsp;&nbsp;</td>
						<td style="padding-left:10px" class="labelmedium"><cf_tl id="Module">:</td>
						<td>&nbsp;</td>
						<td style="padding-left:15px;" class="labelmedium">
													
							<cfdiv bind="url:getDocumentEntryModule.cfm?scope=amend&selected=#Observation.SystemModule#&application={amendWorkgroup}" id="module_div">
							
						</td>
						
					<cfelse>
					
						<td class="labelmedium">		
						<cfquery name="Module" 
							datasource="AppsSystem" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT  *
								FROM    Ref_SystemModule
								WHERE   Operational = 1
								AND     MenuOrder < '90'
						</cfquery>					
						
							<select name="amendSystemModule" id="amendSystemModule" class="regularxl">
						    <cfloop query="Module">
							<option value="#SystemModule#" <cfif systemmodule eq Observation.systemmodule>selected</cfif>>#SystemModule#</option>
							</cfloop>
						    </select>
						
						</td>
						
					</cfif>		
						
					</tr>
					</table>	
				
			</td>
		
			<td align="right" valign="top">	
	
		</td>	
	</tr>
		
	<cfif url.ObservationClass neq "Inquiry">
		
		<tr><td style="padding-left:10px" class="labelmedium"><cf_tl id="Work group">:</td>
		    <td class="labelmedium">			
				<cfdiv class="labelmedium" bind="url:getDocumentEntryGroup.cfm?scope=amend&selected=#Object.entitygroup#&entitycode=SysChange&owner={amendOwner}" id="workgrp"/>				
			</td>
		</tr>
	
	</cfif>
	
	
	<tr><td style="padding-left:10px" class="labelmedium"><cf_tl id="Routing">:</td>
	    <td class="labelmedium">	
		<cfif url.observationclass eq "Inquiry">
		    <cfset entitycode = "SysTicket">	
			<cfdiv bind="url:getDocumentEntityClass.cfm?scope=amend&entitycode=#entitycode#&application={rapplication}"/>						
		<cfelse>
		    <cfset entitycode = "SysChange">	
			<cfdiv bind="url:getDocumentEntityClass.cfm?scope=amend&entitycode=#entitycode#&owner={amendOwner}"/>	
		</cfif>
		</td>
	</tr>	
	
	<tr><td style="height:15px"></td></tr>
	
	<tr><td colspan="2" align="center"><input onclick="saveamend('#url.id#','#url.observationclass#')" class="button10g" style="height:27px;width:160px" type="button" name="Apply" value="Apply"></td></tr>
								 
	</cfoutput>	 	
	
	</table>
	
	</cfform>
	
	</td></tr>
	
	</table>
	
