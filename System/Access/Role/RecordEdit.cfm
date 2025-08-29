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
<cfquery name="Get"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_AuthorizationRole
	WHERE  Role = '#URL.drillid#'
</cfquery>

<cfquery name="Modules"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  SystemModule,Description
	FROM    Ref_SystemModule
</cfquery>

<cfquery name="Owner"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT  Code,Description
	FROM    Ref_AuthorizationRoleOwner
</cfquery>

<cf_screentop height="100%" label="Edit Authorization Role" html="Yes" layout="webapp">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog" target="process">

	<table width="93%" class="formpadding formspacing" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td height="8"></td></tr>
		
		<tr class="hide"><td><iframe name="process" id="process"></iframe></td></tr>
	    <cfoutput>
	    <TR>
	    <TD class="labelmedium2">Code:</TD>
	    <TD class="labelmedium2" height="25"><cfif get.RoleClass eq "Manual">
	  	   <input type="text"   name="Role" id="Role"    value="#get.Role#" size="20" maxlength="20" class="regularh">	  
		   <cfelse>
		   #get.Role#
		   </cfif>
		    <input type="hidden" name="RoleOld" id="RoleOld" value="#get.Role#" size="20" maxlength="20" readonly>
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium2">Area:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Area" value="#get.Area#" message="Please enter an area" required="Yes" size="20" maxlength="20"class="regularxxl">
	    </TD>
		</TR>
		<TR>
	    <TD class="labelmedium2">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="#get.Description#" message="Please enter a Description" required="Yes" size="50" maxlength="50"class="regularxxl">
	    </TD>
		</TR>	
		<TR>
	    <TD class="labelmedium2">Module:</TD>
	    <TD height="25" class="labelmedium2"><cfif get.RoleClass eq "Manual">
			<select name="SystemModule" ID="SystemModule" size="1" class="regularxxl">
			<cfloop query="Modules">
			     <OPTION value="#Modules.SystemModule#" <cfif Get.SystemModule eq Modules.SystemModule>selected</cfif>>#Modules.Description#
			</cfloop>
			</SELECT> 
			<cfelse>
			#Get.SystemModule#
			</cfif>		
	    </TD>
		</TR>	
		<TR>
	    <TD class="labelmedium2">Function:</TD>
	    <TD><cfinput type="Text" name="SystemFunction" value="#get.SystemFunction#" message="Please enter a Function" required="Yes" size="30" maxlength="30"class="regularxxl">
	    </TD>
		</TR>	
		<TR>
		    <TD class="labelmedium2">Task:</TD>
		    <TD><cfinput type="Text" name="RoleTask" value="#get.RoleTask#" message="Please enter a Task" required="False" size="50" maxlength="80" class="regularxxl"></TD>
		</TR>	
		<TR>
	    <TD class="labelmedium2">Owner:</TD>
	    <TD>
			<select name="RoleOwner" id="RoleOwner" size="1" class="regularxxl">
			<OPTION value="" <cfif Get.RoleOwner eq "">selected</cfif>>All
			<cfloop query="Owner">
			     <OPTION value="#Owner.Code#" <cfif Get.RoleOwner eq Owner.Code>selected</cfif>>#Owner.Code#
			</cfloop>
			</SELECT> 
	    </TD>
		</TR>	
		
		<TR>
	    <td class="labelmedium2">Access Levels:</b></td>
	    <TD height="25" class="labelmedium2">  
		  <cfif get.RoleClass eq "Manual">
		  <input type="radio" name="AccessLevels" id="AccessLevels" <cfif Get.AccessLevels eq "3">checked</cfif> value="3">3
	      <input type="radio" name="AccessLevels" id="AccessLevels" <cfif Get.AccessLevels eq "4">checked</cfif> value="4">4
		  <input type="radio" name="AccessLevels" id="AccessLevels" <cfif Get.AccessLevels eq "5">checked</cfif> value="5">5	 
		  <cfelse>
		  #Get.AccessLevels#
		  </cfif>
	    </td>
	    </tr>
		
		<TR>
	    <td class="labelmedium2">Level Label List:</b></td>
	    <TD>  
		  <input type="text" name="AccessLevelLabelList" id="AccessLevelLabelList" class="regularxxl" value="#Get.AccessLevelLabelList#" size="50" maxlength="80">
	    </td>
	    </tr>	
	
		<TR>
	    <td class="labelmedium2">Authorization Scope:</b></td>
	    <TD>  
		  <table cellspacing="0" cellpadding="0"><tr><td class="labelmedium2">
		  
		  <select name="OrgUnitLevel" id="OrgUnitLevel" class="regularxxl"
		          onchange="ColdFusion.navigate('ScopeCheck.cfm?role=#url.drillid#&orgunitlevel='+this.value,'check')">
	
			  <option value="Global" <cfif Get.OrgUnitLevel eq "Global">selected</cfif>>Global</option>
			  <option value="Tree" <cfif Get.OrgUnitLevel eq "Tree">selected</cfif>>Tree/Entity</option>
			  <option value="Parent" <cfif Get.OrgUnitLevel eq "Parent">selected</cfif>>Parent Unit</option>
			  <option value="All" <cfif Get.OrgUnitLevel eq "All">selected</cfif>>Unit</option>	  
		  
		  </select>
		 
		  </td>
		  <td id="check"></td>
		  </tr></table>
		</td>
		
	    </tr>	
		
		<tr>
		<td class="labelmedium2"><cf_UIToolTip  tooltip="Additional parameter value to be defined when granting access to this user.">Parameter:</cf_UIToolTip></td>
		<td>
		
		<table cellspacing="0" cellpadding="0">
		
				<script language="JavaScript">
				
					function other(val) {
					 se = document.getElementsByName("others")
					 count = 0
					 while (se[count]) {
					 
					 	if (val == "") {
					      se[count].className = "regular"
						 } else {
						  se[count].className = "hide"
						  document.getElementById("parametertable").value = ""
						  ColdFusion.navigate('RecordField.cfm?id=#get.role#&ID2=&ds=','lookup')
						 }
						 count++
					 }		  	   
					}
					
				</script>
		
				<TR>
			   
			    <TD height="20" class="labelmedium2">  
				  <cfif get.RoleClass eq "Manual">	
					  <input type="radio" class="radiol" name="Parameter" id="Parameter" onclick="other('x')" <cfif Get.Parameter eq "" and Get.ParameterTable eq "">checked</cfif> value="">N/A
					  <input type="radio" class="radiol" name="Parameter" id="Parameter" onclick="other('')"  <cfif Get.ParameterTable neq "">checked</cfif> value="">Custom
				      <input type="radio" class="radiol" name="Parameter" id="Parameter" <cfif Get.Parameter eq "OrderClass">checked</cfif> value="Owner">Owner
					  <input type="radio" class="radiol" name="Parameter" id="Parameter" <cfif Get.Parameter eq "PostType">checked</cfif> value="PostType">PostType
					  <input type="radio" class="radiol" name="Parameter" id="Parameter" <cfif Get.Parameter eq "Journal">checked</cfif> value="Journal">Journal
					  <input type="radio" class="radiol" name="Parameter" id="Parameter" <cfif Get.Parameter eq "OrderClass">checked</cfif> value="OrderClass">Order Class
				  <cfelse>
					  <cfif get.Parameter eq "">N/A<cfelse>#Get.Parameter#</cfif>				  
				  </cfif>
			    </td>
			    </tr>
				
				<cfif Get.Parameter eq "" and Get.ParameterTable neq "">
				  <cfset cl = "regular">
				<cfelse>
				   <cfset cl = "hide">
				</cfif>
		
				<TR name="others" class="#cl#">
				
			    <td class="labelmedium2" height="28">DSN:&nbsp;</td>
			    <TD> 
										
					<cfset ds = "#Get.ParameterDataSource#">
					
					<!--- Get "factory" --->
					<CFOBJECT ACTION="CREATE"
					TYPE="JAVA"
					CLASS="coldfusion.server.ServiceFactory"
					NAME="factory">
					<!--- Get datasource service --->
					<CFSET dsService=factory.getDataSourceService()>
					<!--- Get datasources --->
					
					
					<!--- Extract names into an array 
					<CFSET dsNames=StructKeyArray(dsFull)>
					--->
					<cfset dsNames = dsService.getNames()>
					<cfset ArraySort(dsnames, "textnocase")> 
							
					<select name="parameterdatasource" id="parameterdatasource" class="regularxxl">
						<option value="" selected >--- select ---</option>
						<CFLOOP INDEX="i"
						FROM="1"
						TO="#ArrayLen(dsNames)#">					
						
						<cfoutput>
							<option value="#dsNames[i]#" <cfif ds eq "#dsNames[i]#">selected</cfif>>#dsNames[i]#</option>
						</cfoutput>
						
						</cfloop>
					</select>
					
				
				</TD>
			    </TR>
						
				<TR name="others" class="#cl#">
				
					<td class="labelmedium2">Table:&nbsp;</td>		    	
					<td>
						    <cfinput type="Text"
						       name="parametertable"
						       value="#Get.ParameterTable#"
						       autosuggest="cfc:service.reporting.presentation.gettable({parameterdatasource},{cfautosuggestvalue})"
						       maxresultsdisplayed="7"
							   showautosuggestloadingicon="No"
						       typeahead="Yes"
						       required="No"
						       visible="Yes"
						       enabled="Yes"      
						       size="40"
						       maxlength="50"
						       class="regularxxl">
											   
					</TD>
					
				</TR>
			
				<TR class="labelmedium2 #cl#" name="others">
		
					<td></td>
					<td>
					   <cfdiv id="lookup" 
					       bind="url:RecordField.cfm?id=#get.role#&ID2={parametertable}&ds={parameterdatasource}">		
					</td>
			
				</TR>
		</table>
		</td>
		</tr>		
				
		<TR>
	    <TD class="labelmedium2">Class:</TD>
	    <TD height="25" class="labelmedium2">#get.RoleClass# (#get.OfficerLastName# added on: #dateformat(get.created,CLIENT.DateFormatShow)#)
			   <input type="hidden" name="RoleClass" id="RoleClass" value="Manual" >
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium2">Order:</TD>
	    <TD>
	  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter an Order" required="Yes" size="2" maxlength="2"class="regularxxl">
	    </TD>
		</TR>		
		
		
		<TR>
	    <TD valign="top" style="padding-top:5px" class="labelmedium2">Memo:</TD>
	    <TD>
		   <cf_textarea name="RoleMemo" class="regular" style="padding:3px;font-size:12px;width:95%;height:50">#Get.RoleMemo#</cf_textarea> 
	    </TD>
		</TR>		
			
		<cf_dialogBottom option="edit" delete="Document type">
		
		</cfoutput>
				
	</TABLE>

</CFFORM>

<cf_screenBottom layout="Innerbox">
