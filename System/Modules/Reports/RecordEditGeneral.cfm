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
			
		<table width="96%" border="0" align="center" class="formpadding formpsacing">
		
		<tr><td height="2" colspan="2"></td></tr>
			
		<cfif SESSION.isAdministrator eq "No">  
	 
			<cfquery name="Module" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT S.SystemModule, S.Description, S.MenuOrder
				FROM  Ref_SystemModule S, 
					  Organization.dbo.OrganizationAuthorization A				 
				WHERE A.ClassParameter = S.RoleOwner
				AND   A.UserAccount = '#SESSION.acc#'
				AND   A.Role = 'AdminSystem'
				AND S.SystemModule IN (SELECT SystemModule FROM Ref_ModuleControl)		
				AND S.SystemModule IN (SELECT SystemModule FROM Ref_ReportMenuClass )			
				AND   S.Operational = '1'			
				ORDER BY S.Menuorder	
			</cfquery>
	
		<cfelse>
	
			<cfquery name="Module" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT DISTINCT S.SystemModule, S.Description, S.MenuOrder
				FROM   Ref_SystemModule S
				WHERE  S.Operational = '1'	
				AND    S.SystemModule IN (SELECT SystemModule FROM Ref_ModuleControl)		
				AND    S.SystemModule IN (SELECT SystemModule FROM Ref_ReportMenuClass )	
				ORDER BY S.Menuorder	
			</cfquery>
		
		</cfif>
			
			<cfif Line.SystemModule eq "">
			
			<tr class="labelmedium2">		
			<td style="height:28px;min-width:240px" width="25%">Module:<cf_space spaces="50"></td>
			<TD>
			
				<table cellspacing="0" cellpadding="0">
							
				<tr class="labelmedium2">
					<td>
					
					<select name="systemmodule" id="systemmodule" class="regularxxl">					
					<cfloop query="Module">
						<option value="#SystemModule#">#Description#</option>
					</cfloop>
					</select>
					
					</td>
				
					<td><cfdiv bind="url:RecordEditFieldsFunctionClass.cfm?systemmodule={systemmodule}"></td>
							
				</tr>			
				
				</table>
				
			</td>	
							
		   <cfelse>
				
			   <cfif Line.Operational eq "1">
			    			
					<td style="height:28;min-width:240px" width="25%">Module :</td>
					<TD>#Line.SystemModule#</TD>
			     
			   <cfelse>
			   						   
				   	<cfquery name="Class" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT DISTINCT R.FunctionName
						FROM  Ref_ModuleControl R
						WHERE R.SystemModule = 'Portal' 
						AND   R.FunctionClass = '#Line.SystemModule#'					
					</cfquery>					
						
					<td style="height:28;min-width:240px" width="15%">#Line.SystemModule# :</td>
					<TD>
				   		   
					  <select name="FunctionClass" id="FunctionClass" class="regularxxl">
					  <cfloop query="Class">
					     <option value="#FunctionName#" <cfif Line.FunctionClass eq FunctionName> SELECTED</cfif>>#FunctionName#</option>
					  </cfloop>
				      </select>
					  </TD>
					
				</cfif>	
				
				<input type="hidden" name="SystemModule" id="SystemModule" value="#Line.SystemModule#">
	 
		    </cfif>
		   	
		
		</TR>	
		
		<TR class="labelmedium2">
	    <TD style="height:28" style="cursor:pointer" title="Associates a report to an application function">Application function :</TD>
		<TD>
		
			<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium2"><td>	
								
				<cfif Line.Operational eq "xxxx">				
				
						<b>#Line.SystemFunctionName#						
				
				<cfelse>
				
					<cfif Line.SystemModule eq "">
					
						<cfdiv bind="url:RecordEditFieldsSystemFunction.cfm?systemmodule={systemmodule}">
					
					<cfelse>
					
						<cfquery name="Module" 
							 datasource="AppsSystem"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 SELECT *
							 FROM   Ref_ModuleControl
							 WHERE  SystemModule = '#Line.SystemModule#'
							 AND    FunctionClass = 'Application'			
							  AND    MenuClass != 'Builder'				
						</cfquery> 		
									
						<select name="SystemFunctionName" id="SystemFunctionName" class="regularxxl">
						  <option value="">n/a</option>
						  <cfloop query="Module">
						  <option value="#FunctionName#" 
						      <cfif FunctionName eq "#Line.SystemFunctionName#">selected</cfif>>#FunctionName#</option>
						  </cfloop>
						</select>
									
					</cfif>
														
				</cfif>
				 
				</TD>				
				</TR>	
			</table>
		</td>
		</tr>			
		
		<cfquery name="Owner" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT  *
			  FROM    Ref_AuthorizationRoleOwner  
			  <cfif SESSION.isAdministrator eq "No">
			  WHERE Code IN (SELECT ClassParameter 
			                 FROM   OrganizationAuthorization
							 WHERE  Role IN ('AdminSystem','ReportManager'))
			  
			  </cfif>
		</cfquery>
		
		<cfif Owner.recordcount eq "0">
		
			<cfquery name="Owner" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  *
				  FROM    Ref_AuthorizationRoleOwner  			 
			</cfquery>	
				
		</cfif>
		
		<TR class="labelmedium2">		
	 		<TD style="height:28;cursor:pointer" title="The owner of the report" width="70"><cf_tl id="Owner">:</TD>
		    <TD>
				<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium2"><td>								
				
						<cfif Line.Operational eq "0">	
						
							<cfselect name="Owner"					          
					          visible="Yes"
					          enabled="Yes"
							  class="regularxxl">
							  
							  <cfloop query="Owner">
							  <option value="#Code#" 
							      <cfif Code eq Line.Owner>selected</cfif>>#Code#</option>
							  </cfloop>
							  
							</cfselect>
							
						<cfelse>
						
						   #Line.Owner#
						   
						</cfif>
				
				</td>	
				
				</tr>
				</table>
			</td>
		</tr>		
				
		<tr class="labelmedium2">
			
				<cfquery name="Language" 
					 datasource="AppsSystem"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT *
					 FROM   Ref_SystemLanguage
					 WHERE  Operational IN ('1','2')
				</cfquery> 		
				
		 		<TD style="height:28;padding-right:4px" width="70"><cf_tl id="Language">:</TD>
			    <TD class="labelmedium">
				<cfif Line.Operational eq "0">	
				<select name="LanguageCode" id="LanguageCode" class="regularxxl">
				  <cfloop query="Language">
				  <option value="#Code#" 
				      <cfif Code eq "#Line.LanguageCode#">selected</cfif>>#LanguageName#</option>
				  </cfloop>
				</select>
				<cfelse>
				  #Line.LanguageCode#</b>
				</cfif>
				
			
			
		</td></tr>
		   
	    <cfif Line.Operational neq "1">
		
		   <tr class="labelmedium2">
		   <td style="height:28">
		   
		   <table cellspacing="0" cellpadding="0">
			<tr class="labelmedium2">
			<td><cf_tl id="Name">:</td>
			<td style="padding-left:3px">
			<button class="button10g" type="button" style="width:50;height:23" name="aboutreport" id="aboutreport" onclick="about()">More</button>
			</td></tr>
			</table>
		   			
			
		   </td>
		   <td>
			 <cfoutput>
				 <input type="text" name="FunctionName" id="FunctionName" value="#Line.FunctionName#" size="40" maxlength="40" class="regularxxl">
	    	 </cfoutput>
		    </td>
		    </tr>	
			
		<cfelse>
		
			<tr class="labelmedium2">
			<td style="height:28" width="15%">
			<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium2">
				<td><cf_tl id="Name">:</td>
				<td style="padding-left:3px">
				<button class="button10g" type="button" style="width:50;height:23" name="aboutreport" id="aboutreport" onclick="about()">More</button>
				</td>
				</tr>
			</table>
			</td>
			<TD>#Line.FunctionName#
			<input type="hidden" name="FunctionName" id="FunctionName" value="#Line.FunctionName#">		
			</TD>		
			</tr>
	 
	 	</cfif>
		
		<tr class="labelmedium2">
			<td style="height:28"><cf_tl id="Menu Icon">:</td>
			<td>
				<table width="100%" align="center">
					<tr>
						<td width="10%">
							<cfoutput>
								<select name="FunctionIcon" id="FunctionIcon" class="regularxxl"
								   onChange="ptoken.navigate('#SESSION.root#/tools/SubmenuImages.cfm?isreport=1&functionicon='+this.value,'showicon')">
								   		 
									<option value="PDF"  <cfif Line.FunctionIcon eq "PDF">selected</cfif>>Report</option>
									<option value="Listing"  <cfif Line.FunctionIcon eq "Listing">selected</cfif>>Listing</option>
									<option value="Dataset"  <cfif Line.FunctionIcon eq "Dataset">selected</cfif>>Dataset</option>
									
							      </select>
							</cfoutput>
						</td>
						<td style="padding-left:3px">						
							<cf_securediv bind="url:#SESSION.root#/tools/SubmenuImages.cfm?isreport=1&functionicon=#Line.Functionicon#" id="showicon">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<TR class="labelmedium2">
	    <TD style="height:28" class="labelmedium" style="cursor:pointer" title="Defines a variable ReportLabel which can be used for the header of the report">
		<cf_tl id="Menu Title">:
		</TD>
		<TD class="labelmedium">		
			<input type="text" name="ReportLabel" id="ReportLabel" value="#Line.ReportLabel#" size="60" maxlength="60" class="regularxxl">				
		</td>
		</tr>		
				   
		<TR class="labelmedium2">
	        <td style="height:28;padding-top:4px;cursor:pointer" valign="top" title="Text presented to the end user when hoovering over the report menu">
			<cf_tl id="Menu Subtitle">:</td>
	        <TD class="labelmedium">
			
			<cfif Line.Operational eq "xxxx">
			       <cfif Line.FunctionMemo eq "">Not defined<cfelse>#Line.FunctionMemo#</cfif>
			<cfelse>
			
				<cfoutput>
				
					<textarea name="FunctionMemo"
					          class="regular"
					          style="height:50;width:98%; font-size:14px;padding:3px;border-radius:3px">#Line.FunctionMemo#</textarea> 
				  </TD>
							  
				</cfoutput>
			
			</cfif>
		</TR>	
		
					
		<cfquery name="MenuClassList" 
			 datasource="AppsSystem"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT *
			 FROM Ref_ReportMenuClass
			 WHERE SystemModule = '#Line.SystemModule#'
		</cfquery> 							
				
		<TR class="labelmedium2">
	    <TD style="height:28" style="cursor:pointer" title="Defines the grouping of the report in the menu">Show under class :</TD>
		<TD>
		
			<table cellspacing="0" cellpadding="0">
				<tr class="labelmedium2"><td>	
				
				<cfif Line.Operational eq "xxxx">				
				
						<b>#Line.MenuClass#						
				
				<cfelse>
				
					<cfif Line.SystemModule eq "">
					
						<cf_securediv bind="url:RecordEditFieldsMenuClass.cfm?systemmodule={systemmodule}">
					
					<cfelse>
									
						<select name="MenuClass" id="MenuClass" class="regularxxl">
						  <cfloop query="MenuClassList">
						  <option value="#MenuClass#" 
						      <cfif MenuClass eq "#Line.MenuClass#">selected</cfif>>#Description#</option>
						  </cfloop>
						</select>
									
					</cfif>
														
				</cfif>
				 
				</TD>
				
				<TD style="padding-left:10px;padding-right:4px" height="20" align="right"><cf_tl id="Sort Order">:</TD>
				<TD>
				
				<cfif Line.Operational eq "xxxx">						
					<b>#Line.MenuOrder#								
				<cfelse>
				   <input type="Text" name="MenuOrder" id="MenuOrder" style="text-align: center;" value="#Line.MenuOrder#" message="Please enter a valid integer" size="1" maxlength="2" class="regularxl">
				</cfif>   
				
		    	</TD>
				
				<TD height="20" style="padding-left:10px" align="right"><cf_tl id="Host">:</TD>
				
				<TD>
				
				<cfif Line.Operational eq "xxxx">		
						
					<b>#Line.ReportHostName#						
					
				<cfelse>
				
					<cfquery name="Hosts" 
					 datasource="AppsInit"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT DISTINCT ApplicationServer
					 FROM Parameter
					</cfquery> 		
													
					<select name="ReportHostName" id="ReportHostName" class="regularxxl">
				          <option value="">All Hosts</option>
						  <cfloop query="Hosts">		
						  <option value="#ApplicationServer#" 
						      <cfif ApplicationServer eq Line.ReportHostName>selected</cfif>>#ApplicationServer#
						  </option>
						  </cfloop>
					</select>				
				   
				</cfif>   
				
		    	</TD>
				<cfset vHelpMsgPortal = "This option will display this report in the portals report section, only if the report has at least one operational layout with user scope enabled.">
				<td style="padding-left:10px" height="20" align="right" title="#vHelpMsgPortal#">
				Portal:&nbsp;
				</td>
				<td title="#vHelpMsgPortal#">
				<input type="checkbox" class="radiol" name="EnablePortal" id="EnablePortal" value=1 <cfif Line.EnablePortal eq 1> checked </cfif> >
				</td>
				
				<td height="20" style="padding-left:10px;padding-right:5px" align="right" title="#vHelpMsgPortal#">
				Disable language filter:
				</td>
				<td title="#vHelpMsgPortal#">
				<input type="checkbox" class="radiol" name="EnableLanguageAll" id="EnableLanguageAll" value="0" <cfif Line.EnableLanguageAll eq 0> checked </cfif> >
				</td>
				
				</TR>	
			</table>
		</td>
		</tr>	
			
		<tr class="hide"><td>
		   <input class="buttonFlat" type="submit" name="save" id="save" style="width: 110px;" value ="Save report">	 
		</td></tr>					
					
		<tr class="labelmedium2">
		<td style="height:28" style="cursor:pointer" class="labelmedium" title="Send an Error Notification email to this address in case report fails for the end user, in addition to the default mail notification to the owner">
		   Error eMail Alert:
		</td>
		
		<td>	
			
				<cfif Line.Operational eq "1">
				
						<cfif Line.NotificationEMail eq "">Not defined<cfelse>#Line.NotificationEMail#</cfif>
						
				<cfelse>
				
						<cfinput type="Text"
					       name="NotificationEMail"
					       value="#Line.NotificationEMail#"
					       message="Please enter a valid eMail address"
					       validate="email"
					       required="No"
					       visible="Yes"
					       enabled="Yes"
					       size="40"
					       maxlength="50"
					       class="regularxxl">
					
				</cfif>
			
		</td>
		</tr>					
				
		<TR class="labelmedium2">
	    <TD style="height:28px" style="cursor:pointer" title="The path/directory in which the CFMX templates for this report (SQL.cfm, xxxx.CFR etc) are stored">
		 File Library:
        </TD>
		<TD>
		
		<cfif Line.Operational eq "1">	
		
				<table cellspacing="0" cellpadding="0">
					<tr class="labelmedium2">					
						<td>
						#rootpath##Line.ReportPath#
						</td>
						<td class="labelmedium2">
		
						<cf_securediv id="library" 
						   bind="url:ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=#line.reportRoot#&reportpath=#line.reportpath#&templatesql=#line.templatesql#">

						</td>		
					</tr>
				</table>		
		       	<input type="Hidden" name="reportPath" id="reportPath" value="#Line.ReportPath#">
						
		<cfelse>
		
				<cfoutput>
				
				<table>
					<tr>					
						<td>
							<table>
								<tr>
								 <td style="padding-right:15px" class="labelmedium"><u>Application&nbsp;root:</td>
								 <td>	
								 							
									<input type = "radio" 
								      onclick   = "ptoken.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=application&reportpath='+reportpath.value+'&templatesql='+templatesql.value,'contentbox4');document.getElementById('rptroot').value='application'" 
									  name      = "reportRoot"
									  class     = "radiol"
									  id        = "reportRoot" 
									  value     = "Application" <cfif line.reportRoot neq "Report">checked</cfif>>
									
									<input type = "hidden" 
										name    = "rptroot" 
										id      = "rptroot"
										value   = "<cfif line.reportRoot eq 'Report'>Report<cfelse>Application</cfif>">						
								
								 </td>
								 <td style="padding-left:10px" class="labelmedium">#SESSION.rootpath# </td>							    
								</tr>
								
								<tr>
								    <td style="padding-right:15px" class="labelmedium"><u>Central root:</td>
									<td>								
										<input type = "radio" 
									      onclick   = "ptoken.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=report&reportpath='+reportpath.value+'&templatesql='+templatesql.value,'contentbox4');document.getElementById('rptroot').value='report'" 
										  name      = "reportRoot" 
										  class     = "radiol"
										  id        = "reportRoot"
										  value     = "Report" <cfif line.reportRoot eq "Report">checked</cfif>>									  
								    </td>									  
									<td style="padding-left:10px" class="labelmedium">#SESSION.rootreportpath# </td>								
								</tr>
							</table>
						</td>
						<td>&nbsp;&nbsp;</td>
						<td>
									
							<cfinput type = "Text" 
							name          = "reportpath" 
							value         = "#Line.ReportPath#" 
							onblur        = "ptoken.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot='+rptroot.value+'&reportpath='+this.value+'&templatesql='+templatesql.value,'library')"
							message       = "Please enter the path to the report directory" 
							size          = "30" 
							maxlength     = "50" 
							class         = "regularxxl">				
					
						</td>	
						<td class="labelmedium">
						
						<cf_securediv id="library" 
						   bind="url:ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=#line.reportRoot#&reportpath=#line.reportpath#&templatesql=#line.templatesql#">
						   
						</td>					
					</tr>
				</table>
				
				</cfoutput>
		
		</cfif>
				    
		</TD>
		</TR>	
				
		<tr class="labelmedium2">
		<td style="height:28">Developer memo:</td>
		<td>		
			<cfif Line.Operational eq "1">
					<cfif Line.Remarks eq "">n/a<cfelse>#Line.Remarks#</cfif>					
			<cfelse>
				<textarea class="regular" style="font-size:15px;border-radius:3px;height:45px;width:98%" name="Remarks">#Line.Remarks#</textarea>
			</cfif>
		</td>
		</tr>
		
		<tr><td></td></tr>
		
		<tr><td height="1" colspan="4" class="line"></td></tr>	
		
		<tr><td align="center" colspan="4">
	 			  
	    <cfif Line.Operational eq "0">
				
		    <input type="submit" name="delete" id="delete" value="Purge" class="button10g" onClick="javascript:return purge()">
		    <input class="button10g" type="submit" name="update" id="update"  value ="Save report" onclick="Prosis.busy('yes')">
	        <input class="button10g" type="submit" name="update2" id="update2" value ="Save & close" onclick="Prosis.busy('yes')">
				
		<cfelse>	
				
			<cfquery name="Owner" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM Ref_SystemModule
				WHERE SystemModule = '#Line.SystemModule#'
			</cfquery>
	
			  <cfinvoke component="Service.Access"
				Method="system"
				Owner="#Owner.RoleOwner#"
				ReturnVariable="Access">					
								
				<cfif Access eq "ALL">
				    <input type="submit" name="delete" id="delete" value="Purge" class="button10g" style="width:130;height:25" onClick="javascript:return purge()">
				</cfif>				
				<input class="button10g" style="width:130;height:25" type="submit" name="update3" id="update3" value ="Update" onclick="Prosis.busy('yes')">
							  
		</cfif>	
			
		</td></tr>
		<tr><td height="4"></td></tr>
		<tr><td colspan="8" class="linedotted"></td></tr>	
		
		</table>
		
</cfoutput>		