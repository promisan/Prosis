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
 <proUsr>administrator</proUsr>
�<proOwn>Hanno van Pelt</proOwn>
 <proDes>Function Menu Role Access</proDes>
 <!--- specific comments for the current change, may be overwritten --->
�<proCom>Added provision for role level verification</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.Operational"     default="0">
<cfparam name="Form.AccessLevelList" default="">

<cftransaction action="BEGIN">

	<cfif Form.Role neq "">
	
		<cfif URL.ID1 eq "">
		
			<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_ModuleControlRole 
			         (SystemFunctionId,
					 Role,
					 Operational,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName,	
					 Created)
			      VALUES ('#URL.ID#',
			      	  '#Form.Role#',
					  '#Form.Operational#',
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#',
					  getDate())
			</cfquery>
			
			<cfloop index="lvl" list="#form.accessLevelList#" delimiters=",">
			
				<cfquery name="Insert" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			   	 INSERT INTO Ref_ModuleControlRoleLevel
		               (SystemFunctionId, Role, AccessLevel)  
				 VALUES ('#URL.ID#',
			      	  '#Form.Role#','#lvl#') 				
		       </cfquery> 
			
			</cfloop>
			
		<cfelse>
			
			   <cfquery name="Update" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     UPDATE Ref_ModuleControlRole
				  SET Operational = '#Form.Operational#' 
				 WHERE SystemFunctionId = '#URL.ID#'
				 AND Role = '#URL.ID1#'
		    	</cfquery>
				
				<!--- level access --->
				
				<cfquery name="Clean" 
			     datasource="AppsSystem" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			   	 DELETE FROM Ref_ModuleControlRoleLevel 
		         WHERE SystemFunctionId = '#URL.ID#'
				 AND Role = '#URL.ID1#'
		       </cfquery> 
					
				<cfloop index="lvl" list="#form.accessLevelList#" delimiters=",">
			
					<cfquery name="Insert" 
				     datasource="AppsSystem" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				   	 INSERT INTO Ref_ModuleControlRoleLevel
			               (SystemFunctionId, Role, AccessLevel)
				     VALUES ('#URL.ID#','#URL.ID1#','#lvl#')
			       </cfquery> 
			
			    </cfloop>
			
		</cfif>
		
	</cfif>

</cftransaction>


<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/> 
  	
<script>
	 <cfoutput>
	 #ajaxLink('#SESSION.root#/System/Modules/Functions/Role.cfm?ID=#URL.ID#&mid=#mid#')#
	 try { opener.functionrefresh('#URL.ID#') } catch(e) {}
	 </cfoutput> 
</script>	
   
