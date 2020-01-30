
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
			
			<tr>		
			<td style="height:28" width="25%" class="labelmedium">Module:<cf_space spaces="50"></td>
			<TD>
			
				<table cellspacing="0" cellpadding="0">
							
				<tr>
					<td>
					
					<select name="systemmodule" id="systemmodule" class="regularxl">					
					<cfloop query="Module">
						<option value="#SystemModule#">#Description#</option>
					</cfloop>
					</select>
					
					</td>
				
					<td class="labelmedium"><cfdiv bind="url:RecordEditFieldsFunctionClass.cfm?systemmodule={systemmodule}"></td>
							
				</tr>			
				
				</table>
				
			</td>	
							
		   <cfelse>
				
			   <cfif Line.Operational eq "1">
			    			
					<td class="labelmedium" style="height:28" width="25%"><cf_space spaces="50">Module :</td>
					<TD class="labelmedium">#Line.SystemModule#</b></TD>
			     
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
						
					<td class="labelmedium"style="height:28"  width="15%"><cf_space spaces="50">#Line.SystemModule# :</td>
					<TD>
				   		   
					  <select name="FunctionClass" id="FunctionClass" class="regularxl">
					  <cfloop query="Class">
					     <option value="#FunctionName#" <cfif Line.FunctionClass eq FunctionName> SELECTED</cfif>>#FunctionName#</option>
					  </cfloop>
				      </select>
					  </TD>
					
				</cfif>	
				
				<input type="hidden" name="SystemModule" id="SystemModule" value="#Line.SystemModule#">
	 
		    </cfif>
		   	
		
		</TR>	
		
		<TR>
	    <TD style="height:28" class="labelmedium" style="cursor:pointer"><cf_UIToolTip tooltip="Associates a report to an application function">Application function :</cf_UIToolTip></TD>
		<TD>
		
			<table cellspacing="0" cellpadding="0">
				<tr><td class="labelmedium">	
								
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
									
						<select name="SystemFunctionName" id="SystemFunctionName" class="regularxl">
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
		
		<TR>		
	 		<TD style="height:28" class="labelmedium" width="70">Owner :</TD>
		    <TD>
				<table cellspacing="0" cellpadding="0">
				<tr><td class="labelmedium">								
				
						<cfif Line.Operational eq "0">	
						
							<cfselect name="Owner"
					          tooltip="The owner of the report"
					          visible="Yes"
					          enabled="Yes"
							  class="regularxl">
							  
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
				
		<tr>
			
					<cfquery name="Language" 
						 datasource="AppsSystem"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT *
						 FROM   Ref_SystemLanguage
						 WHERE  Operational IN ('1','2')
					</cfquery> 		
				
		 		<TD style="height:28;padding-right:4px" class="labelmedium" width="70">Language:</TD>
			    <TD class="labelmedium">
				<cfif Line.Operational eq "0">	
				<select name="LanguageCode" id="LanguageCode" class="regularxl">
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
		
		   <tr>
		   <td style="height:28" class="labelmedium">
		   
		   <table cellspacing="0" cellpadding="0">
			<tr><td class="labelmedium">Name:</td>
			<td style="padding-left:3px">
			<button class="button10g" type="button" style="width:50;height:23" name="aboutreport" id="aboutreport" onclick="about()">
				More
			</button>
			</td></tr>
			</table>
		   			
			
		   </td>
		   <td>
			 <cfoutput>
				 <input type="text" name="FunctionName" id="FunctionName" value="#Line.FunctionName#" size="40" maxlength="40" class="regularxl">
	    	 </cfoutput>
		    </td>
		    </tr>	
			
		<cfelse>
		
			<tr>
			<td class="labelmedium" style="height:28" width="15%">
			<table cellspacing="0" cellpadding="0">
			<tr><td class="labelmedium">Name:</td>
			<td style="padding-left:3px">
			<button class="button10g" type="button" style="width:50;height:23" name="aboutreport" id="aboutreport" onclick="about()">
				More
			</button>
			</td></tr>
			</table>
			</td>
			<TD class="labelmedium">#Line.FunctionName#
			<input type="hidden" name="FunctionName" id="FunctionName" value="#Line.FunctionName#">		
			</TD>		
			</tr>
	 
	 	</cfif>
		
		<tr>
			<td class="labelmedium" style="height:28">Menu Icon :</td>
			<td class="labelmedium">
				<table width="100%" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td width="10%">
							<cfoutput>
								<select name="FunctionIcon" id="FunctionIcon" class="regularxl"
								   onChange="ColdFusion.navigate('#SESSION.root#/tools/SubmenuImages.cfm?isreport=1&functionicon='+this.value,'showicon')">
								   		 
									<option value="PDF"  <cfif Line.FunctionIcon eq "PDF">selected</cfif>>Report</option>
									<option value="Listing"  <cfif Line.FunctionIcon eq "Listing">selected</cfif>>Listing</option>
									<option value="Dataset"  <cfif Line.FunctionIcon eq "Dataset">selected</cfif>>Dataset</option>
									
							      </select>
							</cfoutput>
						</td>
						<td style="padding-left:3px">
						
							<cfdiv bind="url:#SESSION.root#/tools/SubmenuImages.cfm?isreport=1&functionicon=#Line.Functionicon#" id="showicon">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		
		<TR>
	    <TD style="height:28" class="labelmedium" style="cursor:pointer"><cf_UIToolTip tooltip="Defines a variable ReportLabel which can be used for the header of the report">Menu Title :</cf_UIToolTip></TD>
		<TD class="labelmedium">		
			<input type="text" name="ReportLabel" id="ReportLabel" value="#Line.ReportLabel#" size="60" maxlength="60" class="regularxl">				
		</td>
		</tr>		
				   
		<TR>
	        <td style="height:28;padding-top:4px;cursor:pointer" valign="top" class="labelmedium">
			<cf_tooltip  tooltip="Text presented to the end user when hoovering over the report menu"
			content="Menu subtitle">:</td>
	        <TD class="labelmedium">
			
			<cfif Line.Operational eq "xxxx">
			       <cfif Line.FunctionMemo eq "">Not defined<cfelse>#Line.FunctionMemo#</cfif>
			<cfelse>
			
				<cfoutput>
				
					<textarea name="FunctionMemo"
					          class="regular"
					          style="height:50;width:98%; font-size:13px;padding:3px;border-radius:3px">#Line.FunctionMemo#</textarea> 
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
				
		<TR>
	    <TD class="labelmedium" style="height:28" style="cursor:pointer"><cf_UIToolTip tooltip="Defines the grouping of the report in the menu">Show under class :</cf_UIToolTip></TD>
		<TD class="labelmedium">
		
			<table cellspacing="0" cellpadding="0">
				<tr><td class="labelmedium">	
				
				<cfif Line.Operational eq "xxxx">				
				
						<b>#Line.MenuClass#						
				
				<cfelse>
				
					<cfif Line.SystemModule eq "">
					
						<cfdiv bind="url:RecordEditFieldsMenuClass.cfm?systemmodule={systemmodule}">
					
					<cfelse>
									
						<select name="MenuClass" id="MenuClass" class="regularxl">
						  <cfloop query="MenuClassList">
						  <option value="#MenuClass#" 
						      <cfif MenuClass eq "#Line.MenuClass#">selected</cfif>>#Description#</option>
						  </cfloop>
						</select>
									
					</cfif>
														
				</cfif>
				 
				</TD>
				
				<TD class="labelmedium" style="padding-left:10px;padding-right:4px" height="20" align="right">Sort Order:</TD>
				<TD class="labelmedium">
				
				<cfif Line.Operational eq "xxxx">		
						
					<b>#Line.MenuOrder#						
					
				<cfelse>
				   <input type="Text" name="MenuOrder" id="MenuOrder" style="text-align: center;" value="#Line.MenuOrder#" message="Please enter a valid integer" size="1" maxlength="2" class="regularxl">
				</cfif>   
				
		    	</TD>
				
				<TD class="labelmedium" height="20" style="padding-left:10px" align="right">Host:</TD>
				
				<TD class="labelmedium">
				
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
												
				<select name="ReportHostName" id="ReportHostName" class="regularxl">
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
				<td class="labelmedium" style="padding-left:10px" height="20" align="right" title="#vHelpMsgPortal#">
				Portal:&nbsp;
				</td>
				<td title="#vHelpMsgPortal#">
				<input type="checkbox" class="radiol" name="EnablePortal" id="EnablePortal" value=1 <cfif Line.EnablePortal eq 1> checked </cfif> >
				</td>
				
				<td class="labelmedium" height="20" style="padding-left:10px;padding-right:5px" align="right" title="#vHelpMsgPortal#">
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
					
		<tr>
		<td style="height:28" style="cursor:pointer" class="labelmedium">
		    <cf_tooltip tooltip="Send an Error Notification email to this address in case report fails for the end user, in addition to the default mail notification to the owner"
			content="Error eMail Alert">:
		</td>
		
		<td class="labelmedium">	
			
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
					       class="regularxl">
					
				</cfif>
			
		</td>
		</tr>					
				
		<TR>
	    <TD style="height:28" style="cursor:pointer" class="labelmedium">
		<cf_tooltip tooltip="The path/directory in which the CFMX templates for this report (SQL.cfm, xxxx.CFR etc) are stored"
					content="File Library:">
        </TD>
		<TD>
		
		<cfif Line.Operational eq "1">	
		
				<table cellspacing="0" cellpadding="0">
					<tr>					
						<td class="labelmedium">
						#rootpath##Line.ReportPath#
						</td>
						<td class="labelmedium">
		
						<cfdiv id="library" 
						   bind="url:ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=#line.reportRoot#&reportpath=#line.reportpath#&templatesql=#line.templatesql#">

						</td>		
					</tr>
				</table>		
		       	<input type="Hidden" name="reportPath" id="reportPath" value="#Line.ReportPath#">
						
		<cfelse>
		
				<cfoutput>
				
				<table cellspacing="0" cellpadding="0">
					<tr>					
						<td>
							<table cellspacing="0" cellpadding="0">
								<tr>
								 <td style="padding-right:15px" class="labelmedium"><u>Application&nbsp;root:</td>
								 <td>	
								 							
									<input type = "radio" 
								      onclick   = "ColdFusion.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=application&reportpath='+reportpath.value+'&templatesql='+templatesql.value,'contentbox4');document.getElementById('rptroot').value='application'" 
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
									      onclick   = "ColdFusion.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=report&reportpath='+reportpath.value+'&templatesql='+templatesql.value,'contentbox4');document.getElementById('rptroot').value='report'" 
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
							onblur        = "ColdFusion.navigate('ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot='+rptroot.value+'&reportpath='+this.value+'&templatesql='+templatesql.value,'library')"
							message       = "Please enter the path to the report directory" 
							size          = "30" 
							maxlength     = "50" 
							class         = "regularxl">				
					
						</td>	
						<td class="labelmedium">
						
						<cfdiv id="library" 
						   bind="url:ReportInit/ReportDirectory.cfm?id=#url.id#&reportroot=#line.reportRoot#&reportpath=#line.reportpath#&templatesql=#line.templatesql#">

						   
						</td>					
					</tr>
				</table>
				
				</cfoutput>
		
		</cfif>
				    
		</TD>
		</TR>	
				
		<tr><td style="height:28" class="labelmedium">Developer memo:</td>
		<td class="labelmedium">		
			<cfif Line.Operational eq "1">
					<cfif Line.Remarks eq "">n/a<cfelse>#Line.Remarks#</cfif>					
			<cfelse>
				<textarea class="regular" style="font-size:13px;border-radius:3px;height:40;width:98%" rows="2" name="Remarks">#Line.Remarks#</textarea>
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