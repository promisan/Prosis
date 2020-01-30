
<!--- FunctionClass --->

<cfif SESSION.isAdministrator eq "No">  
	 
			<cfquery name="Class" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT R.FunctionName
				FROM  Ref_SystemModule S, 
					  Organization.dbo.OrganizationAuthorization A,
					  Ref_ModuleControl R
				WHERE A.ClassParameter = S.RoleOwner
				AND   A.UserAccount = '#SESSION.acc#'
				AND   A.Role = 'AdminSystem'
				AND   S.Operational = '1'
				AND   S.SystemModule = R.FunctionClass		
				AND   S.SystemModule = '#url.systemmodule#'				
			</cfquery>
	
<cfelse>
	
			<cfquery name="Class" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT R.FunctionName
				FROM  Ref_SystemModule S, 
					  Ref_ModuleControl R
				WHERE S.Operational = '1'
				AND   S.SystemModule = R.FunctionClass 
				AND   S.SystemModule = '#url.systemmodule#'		
				  		
			</cfquery>
		
</cfif>


<select name="functionclass" id="functionclass">
	<cfoutput query="Class">
		<option value="#FunctionName#">#FunctionName#</option>
	</cfoutput>
</select>