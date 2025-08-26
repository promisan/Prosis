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
<!--- Prosis template framework --->
<cfsilent>
 <proUsr>dev</proUsr>
�<proOwn>dev dev</proOwn>
 <proDes>Roles identification</proDes>
 <!--- specific comments for the current change, may be overwritten --->
�<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.ID" default="">
<cfparam name="URL.Edit" default="No">
<cfparam name="URL.Save" default="No">
<cfparam name="URL.Role" default="">
<cfparam name="URL.Type" default="">

<cfquery name="AREA" 
	datasource="AppsOrganization" 
	Username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT Distinct Area as name
		FROM         Ref_AuthorizationRole
		where systemModule='System'
</cfquery>


<cfif #URL.Save# eq "Yes" >

<cfquery name="Check" 
datasource="AppsControl" 
Username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM         ClassFunctionRole
	where ClassFunctionId='#Url.ID#'
	and Role='#URL.Role#'
</cfquery>


<cfif #URL.Type# eq "Edit" and #Check.recordcount# eq "0" and #URL.role# neq "">
	<cfquery name="Get" 
	datasource="AppsControl" 
	Username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE ClassFunctionRole
	set Role='#URL.Role#'
	where ClassFunctionId='#Url.ID#' and
	Role='#URL.Old#'
	</cfquery>
</cfif>

<cfif #URL.Type# eq "new" and #Check.recordcount# eq "0" and #URL.role# neq "" >
	<cfquery name="Get" 
	datasource="AppsControl" 
	Username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT into ClassFunctionRole(ClassFunctionId,Role)
	Values ('#Url.ID#','#URL.Role#')
	</cfquery>
	
</cfif>

</cfif>


<cfquery name="Get" 
datasource="AppsControl" 
Username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     CR.*,R.Description
	FROM         ClassFunctionRole CR, Organization.dbo.Ref_AuthorizationRole R
	where ClassFunctionId='#Url.ID#'
	and CR.Role=R.Role
	
</cfquery>
<cfoutput>
<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">

<tr>
	<td colspan="2" align="center">
	<input type="button" value="Add" class="button10g" onclick="saveRole('r','Roles','new','#URL.Id#','','')">
	</td>
</tr>
	
<tr><td colspan="2" bgcolor="silver"></td></tr>

<cfif #URL.Edit# eq "Yes">

	<cfloop query="Get">
		<cfif #Get.Role# eq "#URL.Role#">
		<tr>
			<td width="10%"></td>
			<td>
			<table>
			<tr>
			<td>
			<select name="vRole" id="vRole">
			<cfloop query="AREA">
				<optgroup label="#AREA.name#">
				<cfloop query="AREA">
						<cfquery name="RAR" 
						datasource="AppsOrganization" 
						Username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM         Ref_AuthorizationRole
						where Area='#AREA.Name#'
						order by area,Role
						</cfquery>
				
						<cfloop query="RAR">
							<cfif #RAR.Role# eq #Get.Role#>
								<option value="#RAR.Role#" selected>#RAR.Role#</option>
							<cfelse>
								<option value="#RAR.Role#">#RAR.Role#</option>
							</cfif>
						</cfloop>
				</cfloop>
				</optgroup>
			</cfloop>
			</select>
			</td>
			
			<td><button onclick="javascript:saveRole('r','Roles','edit','#URL.Id#','#URL.Role#',vRole.value)">Save</button></td>
			
			</tr>
			</table>
			</td>
		</tr>
		<cfelse>
			<tr>
			<td width="10%"></td>
			<td>
			<a href="javascript:editRole('r','Roles','#URL.Id#','#Get.Role#')">#Get.Role#</a>
			</td>
			</tr>
		</cfif>
	</cfloop>
<cfelse>
	<cfloop query="Get">
		<tr>
		<td width="10%"></td>
		<td>
		<a href="javascript:editRole('r','Roles','#URL.Id#','#Get.Role#')">#Get.Role#</a>&nbsp;&nbsp;-&nbsp;&nbsp;&nbsp;#Get.Description#
		</td>
		</tr>
	</cfloop>
</cfif>	

<cfif #URL.Type# eq "new">
	<tr>	
			<td width="10%"></td>
			<td>
				<table>
				<tr>
				<td>
				<select name="vRole" id="vRole">
				<cfloop query="AREA">
					<optgroup label="#AREA.name#">
					<cfloop query="AREA">
							<cfquery name="RAR" 
							datasource="AppsOrganization" 
							Username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							SELECT *
							FROM         Ref_AuthorizationRole
							where Area='#AREA.Name#'
							order by area,Role
							</cfquery>
					
							<cfloop query="RAR">
								<option value="#RAR.Role#">#RAR.Role#</option>
							</cfloop>
					</cfloop>
					</optgroup>
				</cfloop>
				</select>
			</td>
			<td><button onclick="javascript:saveRole('r','Roles','new','#URL.Id#','',vRole.value)">Save</button></td>
			</tr>
			</table>
			</td>		
	</tr>

</cfif>	

<tr><td colspan="2" bgcolor="silver"></td></tr>	

</table>

</cfoutput>	
