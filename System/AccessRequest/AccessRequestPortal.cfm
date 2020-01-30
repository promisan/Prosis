<cfparam name="url.mode" default="new">

<cfquery name="Portals" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	M.*, RM.SystemFunctionId RequestFunction
	    FROM 	#client.lanPrefix#Ref_ModuleControl M
		<cfif   url.mode neq "view">
			LEFT    JOIN  UserRequestModule RM
		<cfelse>
			INNER   JOIN  UserRequestModule RM
		</cfif>
		ON		M.SystemFunctionId = RM.SystemFunctionId AND RM.RequestId = '#URL.RequestId#'
	    WHERE 	M.SystemModule = 'selfservice'
		AND 	M.FunctionClass = 'selfservice'
		AND		M.MenuClass in ('Mission','Main')
		AND		M.Operational = 1
		ORDER BY M.MenuClass
</cfquery>

<input type="hidden" name="Portal" id="Portal" value=""> <!--- So the field exists even if no portal is selected --->

<table width="100%">

	<cfset i=0>
	<cfoutput query="Portals">
		
		<cfif i mod 2 is 0><tr></cfif>
		
		<cfset i = i + 1>
		
			<cfif url.mode neq "view">
				<td width="15" align="center" style="padding-left:20px"> 
				   <table cellspacing="0" cellpadding="0">
				    <tr><td>
					<input type="checkbox" 
						   id="Portal" 
						   name="Portal" 
						   value="#SystemFunctionId#" 
						   onclick="updateAccountDetails();"
						   <cfif RequestFunction neq "" and url.mode neq "new">checked</cfif> >
					</td>
					<!---
					<td>Grant</td>
					<td>
					<input type="radio" id="Portal_#i#" name="Portal_#i#" value="No" <cfif RequestFunction eq "" and url.mode neq "new"> checked </cfif> ></td>
					<td>Deny</td>		
					--->		
					</tr>
					</table>
				</td>
			</cfif>
		
			<td width="48%" align="left" height="20px" class="labelit" style="padding-left:5px"> 
			
				<cfif url.mode eq "view">
					-&nbsp;
				</cfif>
				
				#FunctionMemo# (#FunctionName#)
				
			</td>
		
	</cfoutput>
	<input type="hidden" id ="Portal_Total" name="Portal_Total" value="<cfoutput>#i#</cfoutput>">
	
</table>