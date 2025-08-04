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
<cftransaction>		
	
	<cfif isDefined("Form.ActionCategory")>
	
		<cfset vActionList = "">
		
		<cfloop index="iAction" list="#Form.ActionCategory#" delimiters=",">
		
			<cfset vAction = trim('#iAction#')>
			<cfset vActionList = vActionList & "'" & vAction & "',">
		
			<cfquery name="ValidateAction" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_AssetActionCategory 
					WHERE 	Category = '#url.Category#'
					AND		ActionCategory = '#vAction#'
			</cfquery>
		
			<cfset vEnableTransaction = evaluate("EnableTransaction_" & vAction)>
			<cfset vDetailMode = evaluate("DetailMode_" & vAction)>
			
			<cfif ValidateAction.recordCount eq 0>
			
				<cfquery name="InsertActions" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_AssetActionCategory 
							(ActionCategory,
							Category,
							EnableTransaction,
							DetailMode,
							OfficerUserId,
					 		OfficerLastName,
					 		OfficerFirstName)
						VALUES
							('#vAction#',
							'#url.Category#',
							#vEnableTransaction#,
							'#vDetailMode#',
							'#SESSION.acc#',
			    	  		'#SESSION.last#',		  
				  	  		'#SESSION.first#')
				</cfquery>
			
				<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         		 action = "Insert" 
									 datasource="AppsMaterials"
							 		 contenttype = "Scalar"
									 content = "ActionCategory:#vAction#, Category:#url.Category#, EnableTransaction:#vEnableTransaction#"> 
			
			<cfelse>
			
				<cfquery name="UpdateActions" 
					datasource="appsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						UPDATE 	Ref_AssetActionCategory 
						SET		EnableTransaction = #vEnableTransaction#,
								DetailMode = '#vDetailMode#'
						WHERE 	Category = '#url.Category#'
						AND		ActionCategory = '#vAction#'
				</cfquery>
			
				<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         		 action = "Update" 
									 datasource="AppsMaterials"
							 		 contenttype = "Scalar"
									 content = "EnableTransaction:#vEnableTransaction# WHERE Category: #url.Category# AND ActionCategory:#vAction#"> 
			
			</cfif>
			
		</cfloop>
		
		<cfset vActionList = mid(vActionList, 1, len(vActionList) - 1)>
		
		<cfquery name="DeleteActions" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM 	Ref_AssetActionCategory 
				WHERE 	Category = '#url.Category#'
				AND		ActionCategory NOT IN (#PreserveSingleQuotes(vActionList)#)
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                         		 action = "Delete" 
									 datasource="AppsMaterials"
							 		 contenttype = "Scalar"
									 content = "Category:#url.Category#"> 
		
	<cfelse>
	
		<cfquery name="DeleteActions" 
			datasource="appsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE
				FROM 	Ref_AssetActionCategory 
				WHERE 	Category = '#url.Category#'
		</cfquery>
	
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
                       		 action = "Delete" 
							 datasource="AppsMaterials"
					 		 contenttype = "Scalar"
							 content = "Category:#url.Category#"> 
	
	</cfif>	

</cftransaction>

<cfoutput>
	<script>
		ColdFusion.navigate('Logging/CategoryLogging.cfm?idmenu=#url.idmenu#&category=#url.category#','contentbox1');
	</script>
</cfoutput>