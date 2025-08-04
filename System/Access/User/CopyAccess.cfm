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

<cf_ScreenTop html="no" height="100%" close="parent.ColdFusion.Window.destroy('mydialog',true)" label="Utility: Create Usergroup account for other entities" layout="webapp" scroll="yes">

<cfparam name="URL.Group" default="">

<script language="JavaScript">

	function ChangeAccount(mission,vdefault) {
		 e  = document.getElementById("iAccount")		 
		 e.value = mission + vdefault;
	}
			
</script>


<cfquery name="Owner" 
datasource="appsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AuthorizationRoleOwner
	<cfif SESSION.isAdministrator eq "No">
	WHERE Code IN (SELECT ClassParameter 
	               FROM   Organization.dbo.OrganizationAuthorization
               	   WHERE  Role        = 'AdminUser' 
				   AND    UserAccount = '#SESSION.acc#')
	</cfif>			   
</cfquery>

<cfif Owner.recordcount eq "0">

	<cf_message message = "Your are not authorised to define user group for any owner. Operation not allowed."
	  return = "">
	<cfabort>

</cfif>

<cfinvoke component   = "Service.Access"  
	   method         = "useradmin" 
	   accesslevel    = "'0','1','2'"
	   returnvariable = "accessUserAdmin">

<cfquery name="GetMission" 
datasource="appsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * FROM userNames
	WHERE Account='#URL.Group#'
	AND   AccountType='Group'
</cfquery>	   
	   
<cfif GetMission.AccountMission neq "">	   

<cfset vDefault=ReplaceNoCase(URL.Group,GetMission.AccountMission,"")>

<cfif accessUserAdmin eq "EDIT" or accessUserAdmin eq "ALL">

	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_Mission M 
		WHERE Operational = 1
		AND NOT EXISTS (
			SELECT 'x'
			FROM   System.dbo.UserNames
			WHERE  Account=M.Mission+'#vDefault#'		
		)
		
	</cfquery>
	

<cfelse>

	<cfquery name="Mission" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_Mission M
		WHERE Mission IN (SELECT Mission 
		                  FROM OrganizationAuthorization 
						  WHERE UserAccount = '#SESSION.acc#'
						  AND Role = 'OrgUnitManager')
		AND Operational = 1			 
		AND NOT EXISTS (
			SELECT 'x'
			FROM   System.dbo.UserNames
			WHERE  Account = M.Mission+'#vDefault#'
		
		)
	</cfquery>

</cfif>

<cfelse>
	<cf_message message = "The current Account is not associated to a mission" return = "no">
	<cfabort>
</cfif>
   
<cfform action="CopyAccessSubmit.cfm?Group=#URL.Group#" target="result" method="POST"  name="cloning">

<table width="90%"      
       align="center"
       class="formpadding">
	
<tr><td height="20" colspan="3"></td></tr>

<tr>
	
	<td width="20%" colspan="2" class="labelmedium2"><cf_tl id="Entity">:</td>
	<td width="70%" class="labelmedium2">
		<cfoutput>
		#GetMission.AccountMission# #URL.Group#
		</cfoutput>
	</td>
</tr>		

<tr><td height="1" colspan="4"></td></tr>

<tr><td colspan="3" class="labelmedium2">Generate for entity:</td></tr>

<tr>
	<td width="5%"></td>
	
	<td width="70%" colspan="3">
		<table>
				
		<tr>
			<td>			
			<table border="0">
								
				<cfset row = 0>
			  
				<cfoutput query="Mission">
				
					<cfset row = row+1>
					
					<cfif row eq "1">
					<tr>
					</cfif>
								
					<td style="border-left: 1px solid Silver;">&nbsp;</td>				
					<td width="100" class="labelmedium">&nbsp;#Mission#:</td>									
					<td align="center" width="35"> 
					
						 <table width="100%">
						    <tr>
							<td align="center">						 
							 <input type="checkbox" name="Missions" id="Missions" value="#Mission#" onClick="savedet(this,this.checked)">
							</td>
							</tr>
						 </table>
					 
					 </TD>
								 
					 <cfif row eq "4">
					 	</tr>
						<cfset row = 0>
					 </cfif>
				
				</cfoutput>
			
			</table>		
			</td>	
			
		</tr>
		</table>
		
	</td>	

</tr>	

<tr><td height="4" colspan="4"></td></tr>
<tr><td height="1" class="line" colspan="4"></td></tr>
<tr><td height="4" colspan="4"></td></tr>

<tr>
	<td colspan="3" align="center">
	<cfoutput>
		<input type="hidden" name="oAccount" ID="oAccount" value="#URL.Group#">
		<input type="hidden" name="iAccount" id="iAccount" value="#vDefault#">
	</cfoutput>
	<input class="button10g" type="button" value="Close" onClick="parent.ProsisUI.closeWindow('mydialog')">
	<input class="button10g" type="submit" value="Save">
	</td>	
</tr>

<tr class="hide" height="200">
<td colspan="3">
	<iframe name="result" id="result" scrolling="no" frameborder="0"></iframe>
</td>
</tr>

</table>

</cfform>
