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

<cfquery name="Get" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AuthorizationRole 
	WHERE  Role = '#URL.ID#'	
</cfquery>

<cftry>
		
	<cfquery name="FieldNames" 
	datasource="#url.ds#">
    SELECT  TOP 1 * FROM    #URL.ID2# </cfquery>	
			
	<cfset lk = "1">
		
	<cfcatch>  <cfset lk = "0">  </cfcatch>
		
</cftry>

    <table width="100%" frame="hsides" border="0" cellspacing="0" cellpadding="0" align="left">
		
	<cfif url.id2 eq "">
		
	<cfelseif lk eq "0">
	
		<tr><td height="6"></td></tr>
		<tr><td valign="middle" class="regular">			
			<font color="red"><b>Alert:</b></font> Lookup table/view does not exist
			</td>
		</td>	
			
	<cfelse>
	
		<tr><td>
		
		<table width="100%" border="0" rules="rows">
				
		<tr>
		
		   <td width="120"><cf_UIToolTip tooltip="Field that will be passed to the role definition screen">
		   Key&nbsp;Value:&nbsp;</cf_UIToolTip></td>
		   <td height="24" width="80%">
		
		   <cfset v = "">		   	
		   <select name="parameterfieldvalue" id="parameterfieldvalue" style="width:70%">
			  <cfoutput>
			  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
			      <cfif v eq "">
				      <cfset v = #col#>
				  </cfif>
				  <option value="#col#" <cfif col eq get.ParameterFieldValue>selected</cfif>>#col#</option> 
			  </cfloop>
			  </cfoutput>
		   </select>
		   
		   </td>	   
		
		</tr>						   
		
		<tr>
			   <td width="120" height="24">Display:</td>
			   <td>
				   <cfset v = "">
				   <select name="parameterfielddisplay" id="parameterfielddisplay" style="width:70%">
					  <cfoutput>
					  <cfloop index="col" list="#FieldNames.columnList#" delimiters=",">
					      <cfif v eq "">
						      <cfset #v# = #col#>
						  </cfif>
						  <option value="#col#" <cfif col eq get.ParameterFieldDisplay>selected</cfif>>#col#</option> 
					  </cfloop>
					  </cfoutput>
				    </select>													
				</td>			
		</tr>	
						
												
		<tr><td height="1"></td></tr>		
				
		</table>
		</td></tr>
		
	</cfif>
	
	</table>	