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


<cfparam name="URL.Action" default="">
<cfparam name="URL.LDAPServer" default="">

<cfif url.action eq "delete">
	
	<cfquery name="setLDAP" 	
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		DELETE 
		FROM   ParameterLDAP 
		WHERE LDAPServer = '#URL.LDAPServer#'
	
	</cfquery>


</cfif>

<cfquery name="GetLDAP" 	
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT *
	FROM   ParameterLDAP 

</cfquery>


<!-- <FORM> -->

<table style="width:100%" align="center">

	<tr class="line">
		<td width="100%" class="labelmedium2">LDAP Server</td>
	</tr>

	<tr>
		<td style="padding-top:5px;padding-bottom:5px;">
		
			<table width="98%" align="center" class="formpadding">
				<tr class="labelmedium2 line fixlengthlist">
					<td>Server</td>
					<td>Port</td>
					<td>Domain</td>
					<td>Root</td>
					<td>Filter</td>
					<td>Enabled</td>
					<td><a href="javascript:addLDAP()">[Add]</a></td>
				</tr>
				
				<cfoutput query="GetLDAP">
				
					<cfif URL.LDAPServer eq LDAPServer>

					<tr class="labelmedium2 fixlengthlist" style="height:30px">
						
						<td><input class="regularxl" type="text" name="LDAPServer" style="width:90px" value="#LDAPServer#"></td>
						<td><input class="regularxl" type="text" name="LDAPServerRoot" style="width:50px" value="#LDAPServerPort#"></td>
					  	<td><input class="regularxl" type="text" name="LDAPServerDomain" style="width:98%" value="#LDAPServerDomain#"></td>							  	
				      	<td><input class="regularxl" type="text" name="LDAPRoot"  style="width:98%" value="#LDAPRoot#"></td>
					  	<td><input class="regularxl" type="text" name="LDAPFilter" style="width:98%" value="#LDAPFilter#"></td>
					    <td><cfif Operational eq 1>Yes<cfelse>No</cfif></td>
					    <td><input type="button" name="Save" value="Save" class="button10g"></td>	
						
					</tr>
					
					<cfelse>
					
						<tr class="labelmedium2 line fixlengthlist">
							<td>#LDAPServer#</td>
							<td>#LDAPServerPort#</td>
						  	<td>#LDAPServerDomain#</td>
						  	<td>#LDAPRoot#</td>
						  	<td>#LDAPFilter#</td>
						    <td style="padding-left:4px"><cfif Operational eq 1>Yes<cfelse>No</cfif></td>
						    <td>
						   		<table>
									<tr>
										<td> <cf_img icon="open" onclick="editLDAP('#LDAPServer#')"> </td>
										<td style="padding-left:10px;"> <cf_img icon="delete" onclick="deleteLDAP('#LDAPServer#')"> </td>
									</tr>
								</table>
						    </td>
						</tr>
					</cfif>
					
				</cfoutput>
				
			</table>
		</td>
	</tr>		

</table>

<!-- </FORM> -->