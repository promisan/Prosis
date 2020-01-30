
<cfquery name="qMission" datasource="appsOrganization">
	SELECT * 
	FROM   Ref_Mission 
	WHERE  Operational = '1'
</cfquery>

<table width="100%" border="0" class="navigation_table" align="right">
<tr><td style="padding-left:10px">

<table width="100%" border="0" class="navigation_table formpadding" align="right">		

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
							
		<TR class="line">
		    <td width="3%"></td>
			<td width="80"  class="labelit"><cf_tl id="Sort"></td>	
		    <td width="25%" class="labelit">Menu description</td>					
			<td width="42%" class="labelit">Module LicenseId <font face="Calibri" size="1">(Promisan provided)</font></td>			
			<td width="30"  class="hide" class="labelit" align="left"><cf_UIToolTip  tooltip="Enabled for reporting framework">RDF</cf_UIToolTip></td>
			<td width="30"  class="labelit" style="padding-left:5px" align="left">Enabled</td>
		</tr>			
		
		<cfoutput query="Module" group="ListingOrder">
		
		<tr style="height:50" class="line">
		  <td class="labelit" style="padding-left:4px;padding-top:10px;font-size:24px" colspan="6">#Description#</td></tr>
		
		<cfoutput>
		
		  <tr class="navigation_row">
						
		  <td colspan="1"  valign="top">		
		  <table><tr>
		        <td style="padding-left:3px"> <cf_img icon="open" toggle="yes" id="s_#SystemModule#" onClick="detail('div_#SystemModule#','#SystemModule#')"></td>
		
			  <td class="labelit" style="padding-top:3px;padding-left:10px;font-size:17px">#ModuleDescription#</td>
			  	</tr>
		  </table>
		  <cf_space spaces="100">
		  </td>
		  			
			<td valign="top" style="padding-top:6px;padding-right:10px">
				<cfinput type="Text" 
				   name="MenuOrder_#SystemModule#" 
				   class="regularh" 
				   value="#MenuOrder#" 
				   validate="integer" 
				   visible="Yes" 
				   enabled="Yes" 
				   size="1" 
				   maxlength="2" 
				   style="width:26px;text-align: center;">
		    </td>

			<td height="18"  style="padding-top:3px">
			
				<table cellspacing="0" cellpadding="0">
					<tr><td>
					
					   <cf_LanguageInput
						TableCode       		= "Ref_SystemModule" 
						Mode            		= "Edit"
						Name            		= "Description"
						NameSuffix			    = "_#SystemModule#"
						Key1Value       		= "#SystemModule#"
						Type            		= "Input"
						Required        		= "Yes"
						Message         		= "Please, enter a valid description."
						MaxLength       		= "50"
						Size            		= "30"
						Class           		= "regularh"
						Operational     		= "1"
						Label           		= "Yes">
						
					</td>
					</tr>
				</table>
				
			</td>						
				   
			<td width="140" style="padding-left:3px;padding-top:0px" valign="top">
			
				<table cellspacing="0" cellpadding="0">
				<tr><td style="padding-left:3px;padding-top:6px">
					<cfset role = "#RoleOwner#">
					<select style="width:100;height:20px" class="regularh" name="RoleOwner_#SystemModule#" id="RoleOwner_#SystemModule#">
					<cfloop query="owner">
					  <option value="#Code#" <cfif Role eq Code>selected</cfif>>#Description#</option>
					</cfloop>
					</select>		
				</td>
				</tr>
				<tr>
				
				<td width="250" style="padding-left:3px;padding-top:4px">
				
				    <input type="text"
				        name="LicenseId_#SystemModule#"
						id="LicenseId_#SystemModule#"
				        value="#LicenseId#"					
						class="regularh"
						style="width:265;padding-left:3px;height:19px;background-color:ffffcf"				        
				        maxlength="40">		
							
				</td>
				
				<td style="padding-left:4px;padding-top:3px">		
				
					<cf_space spaces="40">
				
					<cfdiv bind = "url:ParameterSystemCheck.cfm?module=#systemmodule#&licenseid={LicenseId_#SystemModule#}" 
					   id   = "box#systemmodule#">				
				
				</td>
				
				</tr>
				</table>
				
			</td>			
						
			<td class="hide" align="left"><input type="checkbox" class="radiol" name="EnableReportDefault_#SystemModule#" id="EnableReportDefault_#SystemModule#" value="1" <cfif EnableReportDefault eq "1">checked</cfif>></td>
			
			<td align="left"><input type="checkbox" class="radiol" name="Operational_#SystemModule#" id="Operational_#SystemModule#" value="1" <cfif Operational eq "1">checked</cfif>></td>
		</tr>
		
		<tr class="navigation_row_child line">
		    <td colspan="3"></td>
			<td colspan="3">
				<cfdiv id = "div_#SystemModule#" class="hide">	
			</td>
		</tr>
						
		</cfoutput>
				
		</cfoutput>			
		
		<tr><td height="1" colspan="8" class="line"></td></tr>
		
		<tr>
			<td colspan="8" align="center" style="padding-top:4px" height="30">				
			<input type="submit"  name="Update" id="Update" value=" Apply " class="button10g" style="width:200px;height:24>		
			</td>
		</tr>
						
</table>

</td></tr>
</table>