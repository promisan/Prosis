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

<!--- logging the content --->

<cfparam name="attributes.systemfunctionid"      default = "">
<cfparam name="attributes.action"                default = "Open">
<cfparam name="attributes.datasource"            default = "AppsSystem">
<!--- Content type can be a scalar (a single value) or a struct complex value, like a form or a list ---->
<cfparam name="attributes.contenttype"           default = "struct">
<cfparam name="attributes.content"               type    = "any">
<cfparam name="attributes.ActionObject"          default = "">
<cfparam name="attributes.ActionObjectKeyValue1" default = "">
<cfparam name="attributes.ActionObjectKeyValue2" default = "">
<cfparam name="attributes.ActionObjectKeyValue3" default = "">
<cfparam name="attributes.ActionObjectKeyValue4" default = "">

<cf_getHost host="#cgi.http_host#">

<cf_assignid>

<cfif attributes.systemfunctionid neq "">

	<cfset url.idmenu = attributes.systemfunctionid>
	
	<cfquery name="get" 
		datasource="#attributes.datasource#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * FROM System.dbo.Ref_ModuleControl
		WHERE SystemFunctionId = '#url.idmenu#'	
	</cfquery>
	
	<cfquery name="user" 
		datasource="#attributes.datasource#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
				SELECT * 
				FROM   System.dbo.UserNames
				WHERE  Account = '#session.acc#'				
		</cfquery>
		
	<cfif user.recordcount eq "1">
	
		<cfquery name="Logmenu" 
			datasource="#attributes.datasource#"
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO System.dbo.UserActionModule 
				(ModuleActionId,
				 Account, 
				 AccountMission,
				 HostName, 
				 HostSessionId,
				 NodeIP,
				 SystemFunctionId,
				 FunctionName,
				 ActionDescription)
			VALUES 
				('#rowguid#',
				 '#SESSION.acc#',
				 '#user.accountMission#',
				 '#host#',
				 '#Session.sessionId#',
				 '#CGI.Remote_Addr#',
				 '#attributes.systemFunctionId#',
				 '#get.FunctionName#',
				 '#attributes.Action#') 				 
		</cfquery>
	
			<cfif attributes.contenttype eq "Struct">
			
			    <!--- transfer to an array of the struct content --->
				
				<cfset ar = StructKeyArray(attributes.content)> 
				
				<cfloop array="#ar#" index="itm">
				
						<cfif itm neq "FieldNames" and FindNoCase("_CF",itm) eq 0>	<!--- _CF condition as to ignore variables like _CF_CACHE, _CF_CLIENTID --->
						
							<cftry>
						
								<cfquery name="LogmenuDetails" 
									datasource="#attributes.datasource#"
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										INSERT INTO System.dbo.UserActionModuleDetail 
											(ModuleActionId,
											 FieldName,
											 FieldValue,
											 OfficerUserId,
											 OfficerLastName,
											 OfficerFirstName)
										VALUES 
											('#rowguid#',
											 '#itm#',
											 '#evaluate('Form.#itm#')#',
											 '#SESSION.acc#',
											 '#SESSION.last#',
											 '#SESSION.first#') 
								</cfquery>
							
								<cfcatch></cfcatch>
							
							</cftry>	
						
						</cfif>
					
				</cfloop>
				
			<cfelse>
					<cftry>
				
						<cfquery name="LogmenuDetails" 
							datasource="#attributes.datasource#"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							INSERT INTO System.dbo.UserActionModuleDetail 
								(ModuleActionId,
								 FieldName,
								 FieldValue,
								 OfficerUserId,
								 OfficerLastName,
								 OfficerFirstName)
							VALUES 
								('#rowguid#',
								 '#attributes.content#',
								 '#attributes.content#',
								 '#SESSION.acc#',
								 '#SESSION.last#',
								 '#SESSION.first#') 
						</cfquery>
					
						<cfcatch></cfcatch>
					
					</cftry>	
			</cfif>
			
		</cfif>	

</cfif>