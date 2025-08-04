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

<cf_screentop height="100%" title="Request" jquery="Yes" scroll="yes" html="No">

<!--- check if current child is a decision or action --->	
	
<cfoutput>

<cfif URL.PublishNo eq "">
	<cfset tbl = "Ref_EntityClassAction">
<cfelse>
	<cfset tbl = "Ref_EntityActionPublish">
</cfif>

<cfquery name="Step" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select ActionType
	FROM   #tbl#
	WHERE  ActionCode = '#url.child#' 
	<cfif tbl eq "Ref_EntityActionPublish">
	       AND ActionPublishNo = '#URL.PublishNo#'
	<cfelse>
		   AND EntityCode  = '#URL.EntityCode#' 
		   AND EntityClass = '#URL.EntityClass#'  
	</cfif>
</cfquery>

<cfset OldChild = "">

<!--- check if parent already has a child --->
<cfif url.type eq "action">

	<cfquery name="ActionChild" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select ActionCode, ActionParent
	FROM #tbl#
	Where ActionParent = '#url.Parent#' 
	<cfif tbl eq "Ref_EntityActionPublish">
	       AND ActionPublishNo = '#URL.PublishNo#'
	<cfelse>
		   AND EntityCode  = '#URL.EntityCode#' 
		   AND EntityClass = '#URL.EntityClass#'  
	</cfif>
	</cfquery>

	<cfset OldChild = ActionChild.ActionCode>

<cfelse>

<!--- check if branch already has a child --->
	<cfquery name="BranchChild" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	Select 	<cfif url.leg eq "Pos">
				ActionGoToYes
			<cfelse>
				ActionGoToNo
			</cfif> as ActionCode, ActionParent
	FROM #tbl#
	Where ActionCode = '#url.Parent#' 
	<cfif tbl eq "Ref_EntityActionPublish">
	       AND ActionPublishNo = '#URL.PublishNo#'
	<cfelse>
		   AND EntityCode  = '#URL.EntityCode#' 
		   AND EntityClass = '#URL.EntityClass#'  
	</cfif>
	</cfquery> 	

	<cfset OldChild = BranchChild.ActionCode>

</cfif>

<!--- check if parent is INIT --->
<cfquery name="ActionParent" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  ActionParent
	FROM    #tbl#
	WHERE   ActionCode = '#url.Parent#' 
	<cfif tbl eq "Ref_EntityActionPublish">
    AND     ActionPublishNo = '#URL.PublishNo#'
	<cfelse>
    AND EntityCode  = '#URL.EntityCode#' 
	AND EntityClass = '#URL.EntityClass#'  
	</cfif>
	ORDER BY ActionOrder DESC
</cfquery>	

<cfset IsInit = ActionParent.ActionParent>

<cfif isInit eq "INIT" and url.concurrent eq "No">

    <cfset url.scope   = "init">
    <cfset url.message = "Make action initial step?">
	<cfset url.initial = "no">
	<cfinclude template="ActionStepDecisionQuery.cfm"> 	
	

<cfelseif Step.ActionType eq "Decision" or oldChild neq "">


	<cfset url.scope = "leg">
    <cfset url.message = "Move subtree under branch decision?">	
	<cfinclude template="ActionStepDecisionQuery.cfm"> 	


<cfelse>
		
	<script language="JavaScript">
		
		window.location = "ActionStepConnect.cfm?"+
                  "&entitycode=#URL.entityCode#"+
				  "&entityclass=#URL.entityClass#"+
				  "&publishno=#URL.publishNo#"+
                  "&child=#URL.child#"+
				  "&childType=#Step.ActionType#"+
				  "&childLeg="+
				  "&parent=#URL.parent#"+
				  "&type=#URL.type#"+
				  "&leg=#URL.leg#"+
                  "&oldchild=#oldchild#"+
				  "&parentinit="+
				  "&parentparent=#IsInit#"+
				  "&connector=#URL.connector#"+
				  "&concurrent=#URL.concurrent#"
						  
	</script>

</cfif>

<script language="JavaScript1.1">

	childLeg = ''
	init	 = ''
						
	function connect(scope,val) {
	
	    Prosis.busy('yes')
	
		if (scope == "init") {
	
		window.location = "ActionStepConnect.cfm?"+
	                  "&entitycode=#URL.entityCode#"+
					  "&entityclass=#URL.entityClass#"+
					  "&publishno=#URL.publishNo#"+
	                  "&child=#URL.child#"+
					  "&childType=#Step.ActionType#"+
					  "&childLeg="+
					  "&parent=#URL.parent#"+
					  "&type=#URL.type#"+
					  "&leg=#URL.leg#"+
	                  "&oldchild=#oldchild#"+
					  "&parentinit="+val+
					  "&parentparent=#IsInit#"+
					  "&connector=#URL.connector#"+
					  "&concurrent=#URL.concurrent#"
					  
		} else {
		
		window.location = "ActionStepConnect.cfm?"+
	                  "&entitycode=#URL.entityCode#"+
					  "&entityclass=#URL.entityClass#"+
					  "&publishno=#URL.publishNo#"+
	                  "&child=#URL.child#"+
					  "&childType=#Step.ActionType#"+
					  "&childLeg="+val+
					  "&parent=#URL.parent#"+
					  "&type=#URL.type#"+
					  "&leg=#URL.leg#"+
	                  "&oldchild=#oldchild#"+
					  "&parentinit="
					  "&parentparent=#IsInit#"+
					  "&connector=#URL.connector#"+
					  "&concurrent=#URL.concurrent#"
		
		}			  
	
	}						
	
					 
</script>

</cfoutput>	
