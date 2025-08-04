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

<cf_screenTop height="100%" html="No" title="Entity Settings and Modules" jquery="Yes" scroll="Yes" bannerheight="1">

<cfquery name="Mission" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Mission
	WHERE Mission = '#URL.ID2#'
</cfquery>

<cfinvoke component="Service.Access"  
	  method="org" 	
	  mission="#URL.ID2#"
	  returnvariable="access">   
	  
<CFIF Access NEQ "ALL"> 	  

	<table width="100%">
	<tr class="labelmedium2">
	<td align="center" height="100"><cf_tl id="You are not authorised to update this function" class="message"></td>
	</tr>
	</table>
    <cfabort>
	
</cfif>


<cfquery name="Access" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 1 Mission
	FROM     OrganizationAuthorization
	WHERE    Mission = '#url.id2#'
</cfquery>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
    FROM     Ref_Nation
</cfquery>

<cf_calendarscript>

<cf_divscroll>

<cfform action="MissionEditSubmit.cfm?id2=#url.id2#" method="POST" name="missionedit">

<table width="96%" align="center">

 <tr><td height="5"></td></tr>	
 <tr class="line">
    <td colspan="2" style="height:40px;font-size:25px;font-weight:200"><cf_tl id="Definition"></td>
 </tr>
  
  <tr>
  
    <!---
    <td height="34" align="left">
		<table cellspacing="0" cellpadding="0">
		<tr><td>
		   <!---
		    <cfoutput>
			<img src="#SESSION.root#/Images/tree_large.gif" alt="" width="45" height="45" border="0">
			</cfoutput>
			--->
			</td>
			<td class="labellarge" style="font-size:30px"><!--- &nbsp;<cf_tl id="Tree">/<cf_tl id="Entity">: ---> <cfoutput>#Mission.Mission#</cfoutput></b>
			</td>
		</tr>
		</table>
    </td>
	
	--->
	
	<td colspan="2" align="right" id="clear">
	  <cfoutput>
	  
		<cfif mission.operational eq "0" and access.recordcount gte "1">
		
			<cf_tl id="Clear Authorization" var="vClear">
			
		    <input class="button10g" 
			    style="width:150;height:23" 
				type="button" 
				name="Clear" 
				id="Clear"
				value="#vClear#" 
				onclick="ptoken.navigate('MissionAccessClear.cfm?mission=#mission.mission#','clear')">
				
		</cfif>
		
	  </cfoutput>	
	</td>
  </tr> 
         
  <tr>
    <td colspan="2">
	
	<table width="100%" class="formpadding">
				
			<TR>
		    <td height="15" class="labelmedium"><cf_tl id="Acronym">:<cf_space spaces="50"></td>
			<td width="100%">
			
				<table class="formspacing">
				<tr class="labelmedium2">				
					<td ><cfoutput>#Mission.Mission# - (#Mission.MissionPrefix#)</cfoutput></td>   
					
					<td style="padding-left:20px"><cf_tl id="Organization code">: </td>
								  		     
					<td>
			
					<input type="text"
				       name="MissionParentOrgUnit" id="MissionParentOrgUnit" class="regularxl enterastab"
				       value="<cfoutput>#Mission.MissionParentOrgUnit#</cfoutput>"
				       size="5"
				       maxlength="10">
						     		
					</td>				
					
				    <td style="padding-left:20px" align="right"><cf_tl id="Operational">:</td>
					<td><input type="checkbox" class="radiol enterastab" name="Operational" id="Operational" value="1" <cfif #Mission.Operational# eq "1">checked</cfif>></td>
				</tr>	
				</table>
				
			</td>
			</TR>	
					
			<TR class="labelmedium2">
		    <td style="min-width:200px"><cf_tl id="Name">:</td>
			<td style="width:100%"><cfinput type="Text" name="MissionName" value="#Mission.MissionName#" message="Please enter a mission name" required="Yes" size="80" maxlength="180" class="regularxl enterastab">
				 <input type="hidden" 
				        name="Mission" 
						id="Mission"
						value="<cfoutput>#Mission.Mission#</cfoutput>">
			</td>
			</TR>	
				
			<td>Owner:</td>
			 
			  <cfquery name="Owners" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		       SELECT *
		       FROM  Ref_AuthorizationRoleOwner
			  </cfquery>
		     
			<td>
			   <select name="MissionOwner" id="MissionOwner" class="regularxl enterastab">
			   <cfoutput query="Owners">
			   <option value="#Code#" <cfif Mission.MissionOwner eq Code>selected</cfif>>#Code#</option>
			  </cfoutput>
			  </select>
			     		
			</td>
			</TR>
					
			<TR class="labelmedium2">
		    <TD><cf_tl id="Country">:</TD>
		    <TD>
			   	<select name="country" id="country" required="No" class="regularxl enterastab">
				    <cfoutput query="Nation">
						<option value="#Code#" <cfif Code eq Mission.CountryCode>selected</cfif>>#Name#</option>
					</cfoutput>
			   	</select>		
			</TD>
			</TR>					
				
		   			
			<tr class="labelmedium2"> 		
				<TD> <cf_tl id="Effective from">:</td>		    
			<td>		
			
			<table><tr><td>
			
			<cfset end = DateAdd("m",  2,  now())> 

		   	   	<cf_intelliCalendarDate9
					FieldName="DateEffective" 
					class="regularxl enterastab"
			    	Default="#Dateformat(Mission.DateEffective, CLIENT.DateFormatShow)#"
					AllowBlank="False">	
				
			</td>	
			
			<td style="padding-left:14px;padding-right:6px" class="labelmedium"><cf_tl id="Until">:</td>
		    
			<td>
						
			<cfset end = DateAdd("m",  2,  now())> 
			
		   	   	<cf_intelliCalendarDate9
					FieldName="DateExpiration" 
					Default="#Dateformat(Mission.DateExpiration, CLIENT.DateFormatShow)#"
					class="regularxl enterastab"
					AllowBlank="True">
					
			</td></tr>
			</table>			
							
			</td>
			</TR>
			
			<TR class="labelmedium2">
		    <TD valign="top" style="padding-top:3px"><cf_tl id="Time Zone">:</TD>
		    <TD>
				
				<table cellspacing="0" cellpadding="0">
				
				   <tr class="labelmedium2 linedotted">
				   <td><cf_tl id="Effective"></td>
				   <td align="right" style="padding-left:10px">GMT +/-</td>
				   </tr>
				  										   
					<cfquery name="Zone" 
					datasource="appsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   * 
						FROM     Ref_MissionTimeZone 
						WHERE    Mission = '#URL.ID2#'
						ORDER BY DateEffective
					</cfquery>
					
				  <cfset dt = dateformat(now(),CLIENT.DateFormatShow)>
				  <cfset zn = "0">	
		   
		   		   <cfoutput query="Zone">
				   
					   <cfif currentrow neq recordcount>
						   <tr class="labelmedium2">
						   <td align="center" style="height:30px;">#dateformat(DateEffective,CLIENT.DateFormatShow)#</td>
						   <td style="padding-left:9px" align="center">#TimeZone#</td>		   
						   </tr>
					   <cfelse>
					     	<cfset dt = dateformat(DateEffective,CLIENT.DateFormatShow)>
						    <cfset zn = TimeZone>			   	   
					   </cfif>	
				   	  
				   </cfoutput>
				   
				   <tr><td colspan="2" class="line"></td></tr>
				   
				   <tr>
				   <td height="40">
				   <cfif zone.recordcount gte "1">
				   		<cf_intelliCalendarDate9
								FieldName="TimeZoneDateEffective" 
								Manual="True"		
								DateValidStart="#Dateformat(dt, 'YYYYMMDD')#"											
								Default="#dt#"
								class="regularxl enterastab"
								AllowBlank="False">	
					<cfelse>
						<cf_intelliCalendarDate9
								FieldName="TimeZoneDateEffective" 
								Manual="True"																	
								Default="#dt#"
								class="regularxl enterastab"
								AllowBlank="False">	
					</cfif>			
				   </td>
				   <td align="right">
				   		<cfinput class="regularxl enterastab" 
						    type="Text" name="TimeZone" 
							range="-12,12" 
							value="#zn#" 
							validate="range" 
							required="Yes" 
							style="text-align:center;width:40">
				   </td>
				  </tr>	
			   	
				</table>
			</TD>
			</TR>	
			
			<tr class="labelmedium2">
			<td><cf_tl id="Classification">:</td>
			<td>
			
			  <cfquery name="Type" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			       SELECT *
			       FROM  Ref_MissionType
			  </cfquery>
		     		
			  <select name="MissionType" id="MissionType" class="regularxl enterastab">
			   <cfoutput query="Type">
			   	  <option value="#MissionType#" <cfif Mission.MissionType eq MissionType>selected</cfif>>#MissionType#</option>
			   </cfoutput>
			  </select>
						
			</td>		
			</tr>
								
			<TR class="labelmedium2">		    
		    <td><cf_tl id="Home page URL">:  </td>
			<td><cfinput type="Text" name="MissionURL" value="#Mission.MissionURL#" required="No" size="80" maxlength="80" class="regularxl enterastab">				
			</td>
			</TR>	
			
			<TR class="labelmedium2">		    
		    <td><cf_tl id="Mail Signature logo">:  </td>
			<td><cfinput type="Text" name="MissionPathLogo" value="#Mission.MissionPathLogo#" required="No" size="80" maxlength="80" class="regularxl enterastab">				
			</td>
			</TR>	
						
			<tr class="labelmedium2">				
			<td><cf_tl id="Tree administrative">:</td>
			
			<td>
			<table>
			<tr class="labelmedium2">
			 
			  <cfquery name="Tree" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		       SELECT *
		       FROM  Ref_Mission
			   WHERE Mission != '#Mission.Mission#'
			   AND   MissionStatus = 1
			  </cfquery>
		     
			<td width="40%">
			   <select name="TreeAdministrative" id="TreeAdministrative" class="regularxl enterastab">
			   <option value=""><cf_tl id="N/A"></option>
			   <cfoutput query="Tree">
			   <option value="#Mission#" <cfif Mission eq "#Mission.TreeAdministrative#">selected</cfif>>#Mission#</option>
			  </cfoutput>
			  </select>
			     		
			</td>
							
			<td style="padding-left:10px;padding-right:10px;min-width:100px" width="20%"><cf_tl id="Functional">:</td>
			 
			  <cfquery name="Tree" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		       SELECT *
		       FROM  Ref_Mission
			   WHERE Mission != '#Mission.Mission#'
			   AND MissionStatus = 1
			  </cfquery>
		     
			<td>
			   <select name="TreeFunctional" id="TreeFunctional" class="regularxl enterastab">
			   <option value=""><cf_tl id="N/A"></option>
			   <cfoutput query="Tree">
			   <option value="#Mission#" <cfif Mission eq "#Mission.TreeFunctional#">selected</cfif>>#Mission#</option>
			  </cfoutput>
			  </select>
			     		
			</td>
			</TR>	
			
			</table>
			</td>
			</tr>	
			
			 <tr class="line"><td colspan="2" style="height:40px;font-size:25px;font-weight:200"><cf_tl id="Settings and Modules"></td></tr>				
			
			<cf_verifyOperational Module="Staffing">
			
			<cfif Operational eq "1">
			
			<tr class="labelmedium2">
				
			<td>
				<cf_tl id="Limited mode will not assume a recruitment process, resulting in a faster refresh of the screen" var="vStaffingMode" class="message">
				<cfoutput>
			    <a href="##" title="#vStaffingMode#">
				</cfoutput>
					<cf_tl id="Staffing mode">:
				</a>
			</td>
			 			  		     
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="40%" class="labelmedium">
						 <input type="radio" class="radiol enterastab" name="StaffingMode" id="StaffingMode" value="1" <cfif Mission.StaffingMode eq "1">checked</cfif>><cf_tl id="Recruitment enabled">
						 <input type="radio" class="radiol enterastab" name="StaffingMode" id="StaffingMode" value="0" <cfif Mission.StaffingMode eq "0">checked</cfif>><cf_tl id="Limited">
						</td>
					
					</tr>
				</table>
			</td>
						
			</TR>	
						
			<tr class="labelmedium2">
				
			<td><a href="##" title="Advanced mode will create employee record upon arrival"><cf_tl id="Recruitment mode">:</a></td>
			 			  		     
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr class="labelmedium2">
						<td width="40%" class="labelmedium">
						 <input type="radio" class="radiol enterastab" name="StaffingCreatePerson" id="StaffingCreatePerson" value="1" <cfif #Mission.StaffingCreatePerson# eq "1">checked</cfif>><cf_tl id="Advanced"> (<cf_tl id="Creates Employee">)
						 <input type="radio" class="radiol enterastab" name="StaffingCreatePerson" id="StaffingCreatePerson" value="0" <cfif #Mission.StaffingCreatePerson# eq "0">checked</cfif>><cf_tl id="Limited">
						</td>
					
					</tr>
				</table>
			</td>
						
			</TR>	
			<cfelse>
				<input type="hidden" name="StaffingMode" id="StaffingMode" value="0">	
			
			</cfif>
			
			<!---
			
			<cf_verifyOperational module = "Roster" Warning = "No">
			
			<cfif operational eq "1">
												
				<cfquery name="FunctionClass" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM Ref_FunctionClass
				</cfquery>

				<tr>	
				<td class="labelmedium" ><cf_tl id="Functional title class">: </td>
									  		     
				<td>
				<select name="FunctionClass" id="FunctionClass" class="regularxl enterastab"> 
				<cfoutput query="FunctionClass">		
				<option value="#FunctionClass#" <cfif Mission.FunctionClass eq "#FunctionClass#">selected</cfif>>#FunctionClass#</option>
				</cfoutput>
				</select>
				     		
				</td>
				</TR>	
			
			</cfif>
			
			<cfelse>
			
				<input type="hidden" name="StaffingMode" id="StaffingMode" value="0">
				<input type="hidden" name="FunctionClass" id="FunctionClass" value="regular">
			
			</cfif>
			
			--->
									
			<tr class="labelmedium2">
			
				<cf_tl id="Limited mode will not assume usage of the Procurement module for recording obligation" var="vProcMessage" class="message">
				<td>
					<cfoutput>
					<a href="##" title="#vProcMessage#">
					</cfoutput>
						<cf_tl id="Procurement Mode">:
					</a>
				</td>
				 			  		     
				<td>
					<table width="100%">
						<tr>
							<td width="40%" class="labelmedium">
							 <input type="radio" class="radiol enterastab" name="ProcurementMode" id="ProcurementMode" value="1" <cfif Mission.ProcurementMode eq "1">checked</cfif>> <cf_tl id="Procurement">
							 <input type="radio" class="radiol enterastab" name="ProcurementMode" id="ProcurementMode" value="0" <cfif Mission.ProcurementMode eq "0">checked</cfif>> <cf_tl id="Solely through financials">
							</td>					
						</tr>
					</table>
				</td>
						
			</TR>		

			<tr class="labelmedium2"> 		
				<TD><cf_tl id="Document Server Mode">:</td>		    
				<td>
						
				<select name="DocumentServerMode" id="DocumentServerMode" class="regularxl enterastab"> 
					<option value="No" <cfif Mission.DocumentServerMode eq "No">selected</cfif>> <cf_tl id="No"></option>
					<option value="Anonymous" <cfif Mission.DocumentServerMode eq "Anonymous">selected</cfif>><cf_tl id="Anonymous"></option>
					<option value="Individual" <cfif Mission.DocumentServerMode eq "Individual">selected</cfif>><cf_tl id="Individual"></option>								
				</select>
							
				</td>
			</TR>
			
			<tr>
												
			<td colspan="2">
				<cf_securediv bind="url:getMissionType.cfm?mission=#url.id2#&missiontype={MissionType}">			
			</td>
			</tr>		
	
	<script>

	ie = document.all?1:0
	ns4 = document.layers?1:0

	function sel(itm,fld){
	 	 		 	
	 if (fld != false){
	     		
		 document.getElementById(itm+'2').className  = "highLight1";
		 document.getElementById(itm+'2b').className = "highLight1";		 
		 document.getElementById(itm+'3').className  = "highLight1";
		 
	 }else{
	 
		 document.getElementById(itm+'2').className  = "labelmedium";
		 document.getElementById(itm+'2b').className = "labelmedium";		 
		 document.getElementById(itm+'3').className  = "labelmedium";
		 }
	}

	</script>
			
	<cfquery name="ModuleAll" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT    A.Description AS SystemArea, A.ListingOrder AS AreaOrder, F.SystemModule, F.Description AS SystemModuleName, F.LicenseId AS LicenseForAll, 
	              M.LicenseId AS LicenseForModule, M.Mission AS SelectedMission
		FROM      Ref_ApplicationModule AM INNER JOIN
	              Ref_SystemModule F ON AM.SystemModule = F.SystemModule INNER JOIN
	              Ref_Application A ON AM.Code = A.Code LEFT OUTER JOIN
	              Organization.dbo.Ref_MissionModule M ON F.SystemModule = M.SystemModule AND M.Mission = '#URL.ID2#'
		WHERE     F.Operational = '1' 
		AND       F.SystemModule NOT IN ('System', 'Reporting', 'Portal', 'Selfservice', 'Custom') 
		AND       A.[Usage] = 'System'
		ORDER BY A.ListingOrder, F.MenuOrder
		
	</cfquery>
		
	<!---
	<tr><td class="labelmedium"><cf_tl id="Enabled Modules"></font></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	--->
	<tr colspan="2">
	
		<table width="100%">
						
			<tr>	
				<td valign="top" colspan="1">
				  <table width="100%" align="center">
				  				
				  <tr><td>
				  <table width="98%" style="border:1px solid silver;background-color:ffffef">
				 
				    <cfoutput query="ModuleAll" group="AreaOrder"> 
					
						<cfset cnt = 0>
						 
						<tr class="labelmedium2" style="height:10px">
						<td class="line" style="height:10px;padding-left:4px" colspan="9"><font color="C46200">#SystemArea#</td></tr>
					
						<cfoutput>					
					
					    <cfset cnt = cnt+1>
						
						<cfif cnt eq "1">
				        <TR class="labelmedium2" style="height:10px">			   
						</cfif>
		
					    <cfif SelectedMission eq "">
				              <cfset cl = "regular">
					    <cfelse> <cfset cl = "regular">
					    </cfif>
				     							
						<TD  style="padding-left:5px;padding-right:5px;min-width:20px" id="#systemmodule#3" class="#cl#" align="right">
						<cfif SelectedMission eq "">
				            <input type="checkbox" name="SystemModule" class="radiol" id="SystemModule" value="#SystemModule#" onClick="sel('#SystemModule#',this.checked)">							
				        <cfelse>
					        <input type="checkbox" name="SystemModule" class="radiol" id="SystemModule" value="#SystemModule#" checked onClick="sel('#SystemModule#',this.checked)">						
				        </cfif>
						</td>
						
						<TD id="#systemmodule#2b" style="min-width:40px;padding-left:5px" class="#cl#">						
							<cf_securediv bind = "url:../../Parameter/ParameterSystemCheck.cfm?mission='#Mission.Mission#'&module=#systemmodule#&licenseid=#LicenseForModule#&licenseidall=#LicenseForAll#&mode=short" 
							   id   = "box#systemmodule#">	
						</TD>
						
				    	<TD class="#cl#" id="#systemmodule#2" style="width:33%;padding-right:4px">#SystemModuleName#</TD>
																			 
						<cfif cnt eq "3">
				         </TR>			   
						 <cfset cnt = 0>
						</cfif>	 	
						
						</cfoutput>	 
						
				    </CFOUTPUT> 
			   	 </table>
				</table>
			</td>
			</tr>		
			</table>
	</td>
	</tr>
	
	<tr><td height="5"></td></tr>
			
	<tr><td colspan="2" align="center" style="padding-top:5px">
	  <table>
	   <tr>
	    <cfoutput>
	  	<cf_tl id="Close" var="vClose">
		<cf_tl id="Save"  var="vSave">
		<td>
	  	<input class="button10g" style="width:140;height:25" type="button" name="cancel" id="cancel" value="#vClose#" onClick="parent.window.close()">	 
		</td>
		<td style="padding-left:2px">
	    <input class="button10g" style="width:140;height:25" type="submit" name="Submit" id="Submit" value="#vSave#" onclick="Prosis.busy('yes')">
		</td>
	    </cfoutput>
	  </tr>
	 </table>
	</td></tr>
	
	<tr><td height="5"></td></tr>
		
	</TABLE>
		
	</CFFORM>
	
</cf_divscroll>	
	
<cf_screenBottom html="No">
