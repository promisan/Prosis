
<cfquery name="qMission" datasource="appsOrganization">
	SELECT * 
	FROM   Ref_Mission 
	WHERE  Operational = '1'
</cfquery>

<table style="width:100%" border="0" class="navigation_table formpadding" align="right">		

		<cfquery name="Module" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT    A.Description, A.ListingOrder, M.Operational, M.RoleOwner, M.LicenseId, M.EnableReportDefault, M.SystemModule, M.Description AS ModuleDescription, M.MenuOrder
				FROM      Ref_Application A INNER JOIN
				          Ref_ApplicationModule AM ON A.Code = AM.Code INNER JOIN
				          Ref_SystemModule M ON AM.SystemModule = M.SystemModule
				WHERE     A.[Usage] = 'System'
				ORDER BY  A.ListingOrder, M.MenuOrder
			
		</cfquery>
		
		<!---					
		<TR class="line labelmedium2">
		    <td width="3%"></td>
			<td width="80"><cf_tl id="Sort"></td>			   				
			<td width="42%">Module LicenseId: Promisan provided</td>			
			<td width="30" class="hide" align="left"><cf_UIToolTip  tooltip="Enabled for reporting framework">RDF</cf_UIToolTip></td>
			<td width="30" style="padding-left:5px" align="left">Enabled</td>
		</tr>
		--->			
		
		<cfoutput query="Module" group="ListingOrder">
		
		<tr style="height:50px">
		
		  <td class="labelmedium2" style="padding-left:4px;font-size:28px" colspan="6">#Description#</td>
		  
		</tr>
		
			<cfoutput>
			
			  <tr class="navigation_row">
							
			  <td style="min-width:300px">		
				  <table>
				        <tr class="labelmedium2">
						<!---
				          <td style="padding-left:3px"> <cf_img icon="open" toggle="yes" id="s_#SystemModule#" onClick="detail('div_#SystemModule#','#SystemModule#')"></td>		
						  --->
					      <td style="font-size:17px">#ModuleDescription#</td>
					  	</tr>					
				  </table>
			 
			  </td>	  
			  
			  <cfset val = systemmodule>
			 			  		
				<td style="padding-left:30px;padding-right:10px">
								
					<cfinput type="Text" 
					   name="MenuOrder_#val#" 
					   class="regularxl" 
					   value="#MenuOrder#" 
					   validate="integer" 
					   visible="Yes" 
					   enabled="Yes" 
					   size="1" 
					   maxlength="2" 
					   style="width:26px;text-align: center;">

			    </td>
					
								   
				<td width="140" style="padding-left:3px">		
													
						<cfset role = RoleOwner>
						<select style="width:200px;" class="regularxl" name="RoleOwner_#val#">
						<cfloop query="owner">
						  <option value="#Code#" <cfif Role eq Code>selected</cfif>>#Description#</option>
						</cfloop>
						</select>		
													
				</td>	
						
										
				<td class="hide" align="left">
				
				<input type="checkbox" class="radiol" name="EnableReportDefault_#val#" value="1" <cfif EnableReportDefault eq "1">checked</cfif>>
				
				</td>				
				<td align="left">
				
				<input type="checkbox" class="radiol" name="Operational_#val#" value="1" <cfif Operational eq "1">checked</cfif>>
				
				</td>
			</tr>
							
			<tr>
			<td colspan="2" style="padding-left:34px">
			
																									
				   <cf_LanguageInput
					TableCode       		= "Ref_SystemModule" 
					Mode            		= "Edit"
					Name            		= "Description"
					NameSuffix			    = "_#val#"
					Key1Value       		= "#SystemModule#"
					Type            		= "Input"
					Required        		= "Yes"
					Message         		= "Please, enter a valid description #systemmodule#."
					MaxLength       		= "50"
					Size            		= "40"
					Class           		= "regularxxl"					
					Operational     		= "1"
					Label           		= "No">
																			
			
			</td>
			
			<td style="padding-left:3px;padding-top:4px" colspan="2">
			 					
				    <input type="text"
				        name="LicenseId_#val#"						
				        value="#LicenseId#"					
						class="regularxxl"
						style="border:1px solid c1c1c1;width:600px;text-align:center;padding-left:3px;height:40px;font-size:25px!important;font-weight:200;background-color:e6e6e6"				        
				        maxlength="40">		
								
			</td>
											
			<td style="padding-left:4px;padding-top:3px;min-width:80px">	
					
				<cf_securediv bind= "url:ParameterSystemCheck.cfm?module=#systemmodule#&licenseid={LicenseId_#val#}" id= "box#val#">									
							
			</td>
						
			</tr>
							
					
			<tr class="navigation_row_child line">
			    <td colspan="3"></td>
				<td colspan="3">
					<cfdiv id="div_#SystemModule#" class="hide">	
				</td>
			</tr>
										
			</cfoutput>
				
		</cfoutput>		
				
		<tr><td height="1" colspan="6" class="line"></td></tr>
		
		<tr>
			<td colspan="6" align="center" style="padding-top:4px;height:35px">				
			<input type="submit" name="Update" id="Update" value="Apply" class="button10g" style="width:300px;height:30px">		
			</td>
		</tr>
						
</table>

