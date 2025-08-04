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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="url.child"       default="">
<cfparam name="url.childtype"   default="">
<cfparam name="url.childleg"    default="">
<cfparam name="url.parent"      default="">
<cfparam name="url.type"        default="action">
<cfparam name="url.leg"         default="">
<cfparam name="url.oldchild"    default="">
<cfparam name="url.parentinit"  default="No">
<cfparam name="URL.Concurrent"  default="No">
<cfparam name="URL.Connector"   default="INIT">
<cfparam name="url.link"        default="'#URL.Connector#'">

<cfoutput>

<cfif URL.PublishNo eq "">
	<cfset tbl = "Ref_EntityClassAction">
<cfelse>
	<cfset tbl = "Ref_EntityActionPublish">
</cfif>




<cfif parentinit eq "Yes">

	<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE #tbl#
		SET ActionParent  = 'INIT'
		<cfif url.ChildType neq "Action">, 
			<cfif url.childleg eq "Yes">
				ActionGoToYes
			<cfelse>
				ActionGoToNo
			</cfif>  = '#URL.parent#'
		</cfif>	
		WHERE ActionCode  = '#URL.child#'
		<cfif #tbl# eq "Ref_EntityActionPublish">
		       AND ActionPublishNo = '#URL.PublishNo#'
		<cfelse>
			   AND EntityCode  = '#URL.EntityCode#' 
			   AND EntityClass = '#URL.EntityClass#'  
		</cfif>
	</cfquery>

	<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE #tbl#
		SET ActionParent = <cfif url.ChildType neq "Action">
								''
							<cfelse>
								'#URL.child#'
							</cfif>
		WHERE ActionCode  = '#URL.parent#'
		<cfif #tbl# eq "Ref_EntityActionPublish">
		       AND ActionPublishNo = '#URL.PublishNo#'
		<cfelse>
			   AND EntityCode  = '#URL.EntityCode#' 
			   AND EntityClass = '#URL.EntityClass#'  
		</cfif>
	</cfquery>

<cfelse>

	<cfif url.type eq "init">
	
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE #tbl#
			SET ActionParent  = 'INIT'
			WHERE ActionCode  = '#URL.child#'
			<cfif #tbl# eq "Ref_EntityActionPublish">
			       AND ActionPublishNo = '#URL.PublishNo#'
			<cfelse>
				   AND EntityCode  = '#URL.EntityCode#' 
				   AND EntityClass = '#URL.EntityClass#'  
			</cfif>
		</cfquery>
		
	<cfelseif url.type eq "action">
	
		<cfif url.concurrent eq "No">
	
			<!--- insert new child --->
			<cfquery name="Update" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE #tbl#
				SET ActionParent  = '#url.Parent#'
				WHERE ActionCode  = '#URL.child#'
				<cfif #tbl# eq "Ref_EntityActionPublish">
				       AND ActionPublishNo = '#URL.PublishNo#'
				<cfelse>
					   AND EntityCode  = '#URL.EntityCode#' 
					   AND EntityClass = '#URL.EntityClass#'  
				</cfif>
				</cfquery>
		
		<cfelse>
		
			<!--- insert concurrent action --->
			<cfquery name="Update" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE #tbl#
				SET ActionParent  = '#url.ParentParent#'
				WHERE ActionCode  = '#URL.child#'
				<cfif #tbl# eq "Ref_EntityActionPublish">
				       AND ActionPublishNo = '#URL.PublishNo#'
				<cfelse>
					   AND EntityCode  = '#URL.EntityCode#' 
					   AND EntityClass = '#URL.EntityClass#'  
				</cfif>
				</cfquery>
		
		</cfif>
		
	<cfif url.OldChild neq "" and url.concurrent eq "No">
		
	<!--- action so just insert grandchild below child --->	
			<cfif url.ChildType eq "Action">
	
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE #tbl#
					SET ActionParent  = '#url.Child#'
					WHERE ActionCode  = '#url.OldChild#'
					<cfif #tbl# eq "Ref_EntityActionPublish">
					       AND ActionPublishNo = '#URL.PublishNo#'
					<cfelse>
						   AND EntityCode  = '#URL.EntityCode#' 
						   AND EntityClass = '#URL.EntityClass#'  
					</cfif>
				</cfquery>
				
			<cfelse>
	
	<!--- decision so insert grandchild as decision option --->	
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE #tbl#
					SET ActionParent  = ''
					WHERE ActionCode  = '#URL.OldChild#'
					<cfif #tbl# eq "Ref_EntityActionPublish">
					       AND ActionPublishNo = '#URL.PublishNo#'
					<cfelse>
						   AND EntityCode  = '#URL.EntityCode#' 
						   AND EntityClass = '#URL.EntityClass#'  
					</cfif>
				</cfquery>
				
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE #tbl#
					SET 
					<cfif url.childleg eq "Yes">
						ActionGoToYes
					<cfelse>
						ActionGoToNo
					</cfif>  = '#URL.OldChild#'
					WHERE ActionCode  = '#url.Child#'
					<cfif #tbl# eq "Ref_EntityActionPublish">
					       AND ActionPublishNo = '#URL.PublishNo#'
					<cfelse>
						   AND EntityCode  = '#URL.EntityCode#' 
						   AND EntityClass = '#URL.EntityClass#'  
					</cfif>
				</cfquery>
		
			</cfif>
			
		</cfif>
	
	<cfelse>
	
		<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE #tbl# 
			<cfif url.leg eq "Pos">
				SET ActionGoToYes = '#url.Child#' 
			<cfelse>
				SET ActionGoToNo  = '#url.Child#'
			</cfif>
			WHERE ActionCode = '#URL.Parent#' 
			<cfif #tbl# eq "Ref_EntityActionPublish">
			       AND ActionPublishNo = '#URL.PublishNo#'
			<cfelse>
				   AND EntityCode  = '#URL.EntityCode#' 
				   AND EntityClass = '#URL.EntityClass#'  
			</cfif>
		</cfquery>
		
		<cfif URL.oldChild neq "">
	
	<!--- action so just insert grandchild below child --->	
			<cfif url.ChildType eq "Action">
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE #tbl#
					SET ActionParent  = '#url.Child#'
					WHERE ActionCode  = '#URL.OldChild#'
					<cfif #tbl# eq "Ref_EntityActionPublish">
					       AND ActionPublishNo = '#URL.PublishNo#'
					<cfelse>
						   AND EntityCode  = '#URL.EntityCode#' 
						   AND EntityClass = '#URL.EntityClass#'  
					</cfif>
				</cfquery>
				
			<cfelse>
			
	<!--- decision so insert grandchild as decision option --->	
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE #tbl#
					SET ActionParent  = ''
					WHERE ActionCode  = '#URL.OldChild#'
					<cfif #tbl# eq "Ref_EntityActionPublish">
					       AND ActionPublishNo = '#URL.PublishNo#'
					<cfelse>
						   AND EntityCode  = '#URL.EntityCode#' 
						   AND EntityClass = '#URL.EntityClass#'  
					</cfif>
				</cfquery>
				
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE #tbl#
					SET 
					<cfif url.childleg eq "Yes">
						ActionGoToYes
					<cfelse>
						ActionGoToNo
					</cfif> = '#URL.OldChild#'
					WHERE ActionCode  = '#url.Child#'
					<cfif tbl eq "Ref_EntityActionPublish">
					       AND ActionPublishNo = '#URL.PublishNo#'
					<cfelse>
						   AND EntityCode  = '#URL.EntityCode#' 
						   AND EntityClass = '#URL.EntityClass#'  
					</cfif>
				</cfquery>
		
			</cfif>
			
		</cfif>
	
		
	</cfif>	
	
</cfif>	

<cfinclude template="FlowView.cfm">

</cfoutput>						  
