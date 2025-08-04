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

<table width="97%" cellspacing="1" cellpadding="1" align="center">
		
		<tr><td height="7"></td></tr>
		
		<tr><td colspan="2" height="3" class="labelit"><b>Application code</b> (only change when you are absolutely certain)</b></td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		
		 <TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Portal URL:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regular" type="Text" name="PortalURL" value="#PortalURL#" required="Yes" size="60" maxlength="60">
			</cfoutput>
	    </TD>
		</TR>	
			
	    <TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Application Root:</td>
	    <TD><cfoutput>#SESSION.root#</cfoutput>/
	  	    <cfoutput query="get">
			<cfinput class="regular" type="Text" name="TemplateRoot" value="#TemplateRoot#" required="Yes" size="60" maxlength="60">
			</cfoutput>
	    </TD>
		</TR>	
			
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Main view:</td>
	    <TD><cfoutput>#session.root#</cfoutput>/
	  	    <cfoutput query="get">
			<cfinput class="regular" type="Text" name="TemplateHome" value="#TemplateHome#" required="Yes" size="60" maxlength="60">
			</cfoutput>
	    </TD>
		</TR>	
			
	    <TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Exchange Library Local Path:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regular" type="Text" name="DocumentLibrary" value="#DocumentLibrary#" required="Yes" size="60" maxlength="60">
			</cfoutput>
	    </TD>
		</TR>
			
	    <TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Exchange Library URL:</td>
	    <TD>
	  	    <cfoutput query="get">
			<cfinput class="regular" type="Text" name="DocumentURL" value="#DocumentURL#" required="Yes" size="60" maxlength="60">
			</cfoutput>
	    </TD>
		</TR>
		
		<tr><td height="7"></td></tr>
			
		<tr><td height="3" colspan="2" class="labelit"><b>Other Settings</b> (only change when you are absolutely certain)</td></tr>
		<tr><td colspan="2" class="line"></td></tr>
		
					
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;CFMX Alias Source Data:</td>
	    <TD>
	  	    <cfoutput query="get">
			   <cfinput class="regular" type="Text" name="AliasSourceData" value="#AliasSourceData#" required="Yes" size="20" maxlength="20">
			</cfoutput>
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Source Server Name:</td>
	    <TD>
	  	    <cfoutput query="get">
			   <cfinput class="regular" type="Text" name="SourceServer" value="#SourceServer#" required="Yes" size="20" maxlength="20">
			</cfoutput>
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Source Database:</td>
	    <TD>
	  	    <cfoutput query="get">
			   <cfinput class="regular" type="Text" name="SourceDatabase" value="#SourceDataBase#" required="Yes" size="20" maxlength="20">
			</cfoutput>
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Source Schema:</td>
	    <TD>
	  	    <cfoutput query="get">
			   <cfinput class="regular" type="Text" name="SourceSchema" value="#SourceSchema#" required="Yes" size="10" maxlength="10">
			</cfoutput>
	    </TD>
		</TR>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Portal Default eMail Account:</td>
	    <TD colspan="3">
		<cfinput type="Text"
				      name="PortalMailAddress"
				      value="#get.PortalMailAddress#"
				      message="Please enter a valid mail address"
				      validate="email"
				      required="No"
				      visible="Yes"
					  enabled="Yes"				      
				      size="30"
				      class="regular">						  
		
		</tr>	
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Source Cut-off:</td>
	    <TD>
		<cfinput type="Text"
				      name="SourceDateCutOff"
				      value="#dateformat(get.SourceDateCutOff,CLIENT.DateFormatShow)#"
				      message="Please enter a valid date"
				      validate="eurodate"
				      required="Yes"
				      visible="Yes"
					  enabled="Yes"
				      style="text-align: center"
				      size="12"
				      class="regular">	
					  
		<tr>
		<td width="160" class="labelit">&nbsp;&nbsp;&nbsp;<a href="##" title="Claims may not be submitted through Portal after a predefined number of days have passed since Travel request was issued. ">Travel request expiration:</a></b></td>
	    <td>
		
		<cfoutput query="get">
				<cfinput type="Text"
			       name="DaysExpiration"
			       value="#DaysExpiration#"
			       validate="integer"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="3"
			       maxlength="3"
				   class="amount">
		</cfoutput> days
			
		</td>
		</tr>	
		<cfquery name="Class" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    EntityClass
		FROM      Ref_EntityClass
		WHERE     EntityCode = 'EntClaim'
		</cfquery>
				
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Default Workflow (unless overruled by validations):</td>
	    <TD><select name="WorkflowClass">
	  	    <cfoutput query="class">
			<option value="#EntityClass#" <cfif class.entityClass eq "#get.workflowclass#">selected</cfif>>#entityclass#</option>
			</cfoutput>
			</select>
		
	    </TD>
		</TR>
		
		<cfquery name="Mission" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_Mission
			WHERE MissionStatus = '1'
		</cfquery>
		
		<TR>
	    <td class="labelit">&nbsp;&nbsp;&nbsp;Travel Request Office Tree:</td>
	    <TD><select name="TreeUnit">
	  	    <cfoutput query="mission">
			<option value="#Mission#" <cfif mission.mission eq "#get.treeunit#">selected</cfif>>#Mission#</option>
			</cfoutput>
			</select>
	    </TD>
		</TR>			  
		
		<tr><td height="7"></td></tr>
		
		<tr><td colspan="2" height="3" class="labelit"><b>Claim Document and Export Serial No</b></td></tr> 
		<tr><td colspan="2" class="line"></td></tr>
			
		<TR>
	    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;Travel Request Document:</b></td>
	    <TD>
	    	<cfoutput query="get">
				<cfinput class="regular" type="Text" name="ClaimRequestPrefix" value="#ClaimRequestPrefix#" message="Please enter a code" required="Yes" size="10" maxlength="10">
			</cfoutput>
		</TD>
		</TR>
		
		<TR>
	    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;Claim Prefix:</b></td>
	    <TD>
	    	<cfoutput query="get">
				<cfinput class="regular" type="Text" name="ClaimPrefix" value="#ClaimPrefix#" message="Please enter a code" required="Yes" size="4" maxlength="4">
			</cfoutput>
		</TD>
		</TR>
		
		<TR>
	    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;Last Portal ClaimNo:</b></td>
	    <TD>
	    	<cfoutput query="get">
				<cfinput type="Text"
			       name="ClaimNo"
			       value="#ClaimNo#"
			       validate="integer"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="4"
			       maxlength="4"
			       class="regular">
			</cfoutput>
		</TD>
		</TR>
			
		<TR>
	    <td width="160" class="labelit">&nbsp;&nbsp;&nbsp;Last Export File SerialNo:</b></td>
	    <TD>
	    	<cfoutput query="get">
				<cfinput type="Text"
			       name="ExportNo"
			       value="#ExportNo#"
			       validate="integer"
			       required="Yes"
			       visible="Yes"
			       enabled="Yes"
			       size="5"
			       maxlength="5"
			       class="regular">
			</cfoutput>
		</TD>
		</TR>
		
		<TR>
	    <td width="160" class="labelit">&nbsp;&nbsp;Export Field No Consolidate </b></td>
	    <TD>
			<cfoutput query="get">
	    	  <input type="radio" name="Consolidation" value="1" <cfif #Get.Consolidation# eq "1">checked</cfif>>1
			  <input type="radio" name="Consolidation" value="0" <cfif #Get.Consolidation# eq "0">checked</cfif>>0
	  	   	</cfoutput>
		</TD>
		</TR>
		
	</table>
	

		
