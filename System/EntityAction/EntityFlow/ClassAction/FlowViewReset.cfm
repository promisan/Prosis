
<cfparam name="URL.ID" default="All">
<cfparam name="URL.tpe" default="Action">
<cfparam name="URL.steptpe" default="Action">
<cfparam name="URL.saveBranch" default="Yes">

<cfif URL.tpe eq "Remove"> 

	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_EntityClassPublish
	WHERE ActionPublishNo = '#URL.ID#' 
	</cfquery>

<cfelseif URL.tpe eq "RemoveAction"> 

	<cfquery name="Delete" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE FROM Ref_EntityClassAction
	WHERE ActionCode = '#URL.ID#'
	AND EntityCode = '#URL.EntityCode#' 
	AND EntityClass = '#URL.EntityClass#'
	</cfquery>

<cfelseif URL.ID eq "All">

	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_EntityClassAction
	SET ActionParent = '9999', 
	    ActionGoToYes = NULL, 
		ActionGoToNo = NULL,
		OfficerUserId = NULL,
		OfficerLastName = NULL,
		OfficerFirstName = NULL,
		Created = NULL
	WHERE EntityCode = '#URL.EntityCode#' 
	AND EntityClass = '#URL.EntityClass#'
	</cfquery>

<cfelseif URL.tpe eq "Action">

<!--- KRW: Modified 24/01/08 to deal with concurrent actions --->

	<!--- get step data --->
	<cfquery name="Get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityClassAction
			WHERE ActionCode = '#URL.ID#'
			AND EntityCode = '#URL.EntityCode#' 
			AND EntityClass = '#URL.EntityClass#'  
	</cfquery>
	
	<cfif URL.steptpe neq "Decision">

		<!--- get children id if exists --->
		<cfquery name="GetChild" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT ActionCode as Child
				FROM Ref_EntityClassAction
				WHERE ActionParent = '#URL.ID#'
				AND EntityCode = '#URL.EntityCode#' 
				AND EntityClass = '#URL.EntityClass#' 
		</cfquery>
		
		<cfif GetChild.RecordCount neq 0>
		
			<!--- determine if deleted step is concurrent --->	
			<cfquery name="GetSiblings" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT ActionCode
					FROM Ref_EntityClassAction
					WHERE ActionParent = '#Get.ActionParent#'
					AND ActionCode != '#URL.ID#'
					AND EntityCode = '#URL.EntityCode#' 
					AND EntityClass = '#URL.EntityClass#'
			</cfquery>
			
			<cfif GetSiblings.RecordCount neq 0>
				<!--- assign the first sibling record to adopt the children --->
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Ref_EntityClassAction
					SET    ActionParent = '#GetSiblings.ActionCode#'
					WHERE  ActionParent =  '#URL.ID#' 
					AND    EntityCode   = '#URL.EntityCode#' 
					AND    EntityClass  = '#URL.EntityClass#'
					</cfquery>
			
			<cfelse>	
						
				<cfquery name="Update" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE Ref_EntityClassAction
					SET    ActionParent = '#Get.ActionParent#'
					WHERE  ActionParent =  '#URL.ID#' 
					AND    EntityCode   = '#URL.EntityCode#' 
					AND    EntityClass  = '#URL.EntityClass#'
					</cfquery>				
			</cfif>	
		
		</cfif>	
	<cfelse>				<!--- action is a decision --->
		
		<cfquery name="GetBranch" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT
			<cfif URL.savebranch eq "Yes">
				ActionGoToYes
			<cfelse>
				ActionGoToNo
			</cfif> as Child
			FROM Ref_EntityClassAction			
			WHERE ActionCode = '#URL.ID#' 
			AND    EntityCode   = '#URL.EntityCode#' 
			AND    EntityClass  = '#URL.EntityClass#' 
			</cfquery>				
					
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
			SET    ActionParent = '#Get.ActionParent#'
			WHERE  ActionCode =  '#GetBranch.Child#' 
			AND    EntityCode   = '#URL.EntityCode#' 
			AND    EntityClass  = '#URL.EntityClass#'
			</cfquery>
			
	</cfif>
		
	<cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE Ref_EntityClassAction
	SET ActionParent     = '9999', 
	    ActionGoToYes    = NULL, 
		ActionGoToNo     = NULL,
		OfficerUserId    = NULL,
		OfficerLastName  = NULL,
		OfficerFirstName = NULL,
		Created          = NULL
	WHERE EntityCode   = '#URL.EntityCode#' 
	  AND EntityClass  = '#URL.EntityClass#'
	  AND ActionCode   = '#URL.ID#' 
	</cfquery>
	
<cfelse>
	<!--- under a decision branch --->
	
	<cfquery name="Get" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_EntityClassAction
			WHERE ActionCode = '#URL.ID#'
			AND EntityCode = '#URL.EntityCode#' 
			AND EntityClass = '#URL.EntityClass#'
	</cfquery>
		

	<cfif steptpe neq "Decision">
	
		<cfquery name="GetChild" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT ActionCode
				FROM Ref_EntityClassAction
				WHERE ActionParent = '#URL.ID#'
				AND EntityCode = '#URL.EntityCode#' 
				AND EntityClass = '#URL.EntityClass#'
		</cfquery>
	
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
			SET ActionGoToYES = <cfif GetChild.RecordCount neq 0>
									'#GetChild.ActionCode#'
								<cfelse>
									NULL
								</cfif>
			WHERE EntityCode  = '#URL.EntityCode#' 
			AND EntityClass   = '#URL.EntityClass#'
			AND ActionGoToYes = '#URL.ID#' 
			</cfquery>
			
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
			SET ActionGoToNo  = <cfif GetChild.RecordCount neq 0>
									'#GetChild.ActionCode#'
								<cfelse>
									NULL
								</cfif>
			WHERE EntityCode  = '#URL.EntityCode#' 
			 AND EntityClass  = '#URL.EntityClass#'
			 AND ActionGoToNo = '#URL.ID#' 
			</cfquery>
			
		<cfif GetChild.RecordCount neq 0>
		
			<cfquery name="Update" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				UPDATE Ref_EntityClassAction
				SET ActionParent = NULL
				WHERE EntityCode  = '#URL.EntityCode#' 
				AND EntityClass   = '#URL.EntityClass#'
				AND ActionCode = '#GetChild.ActionCode#' 
				</cfquery>
				
		</cfif>		
		
	<cfelse>				<!--- action is a decision --->
		
		<cfquery name="GetBranch" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT
			<cfif URL.savebranch eq "Yes">
				ActionGoToYes
			<cfelse>
				ActionGoToNo
			</cfif> as Child
			FROM Ref_EntityClassAction			
			WHERE ActionCode = '#URL.ID#' 
			AND    EntityCode   = '#URL.EntityCode#' 
			AND    EntityClass  = '#URL.EntityClass#' 
			</cfquery>				
					
		<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
			SET ActionGoToYES = <cfif GetBranch.RecordCount neq 0>
									'#GetBranch.Child#'
								<cfelse>
									NULL
								</cfif>
			WHERE EntityCode  = '#URL.EntityCode#' 
			AND EntityClass   = '#URL.EntityClass#'
			AND ActionGoToYes = '#URL.ID#' 
			</cfquery>
			
			<cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE Ref_EntityClassAction
			SET ActionGoToNo  = <cfif GetBranch.RecordCount neq 0>
									'#GetBranch.Child#'
								<cfelse>
									NULL
								</cfif>
			WHERE EntityCode  = '#URL.EntityCode#' 
			 AND EntityClass  = '#URL.EntityClass#'
			 AND ActionGoToNo = '#URL.ID#' 
			</cfquery>
					
	</cfif>
	
	<cfquery name="Update" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE Ref_EntityClassAction
		SET ActionParent     = '9999', 
		    ActionGoToYes    = NULL, 
			ActionGoToNo     = NULL,
			OfficerUserId    = NULL,
			OfficerLastName  = NULL,
			OfficerFirstName = NULL,
			Created          = NULL
		WHERE EntityCode   = '#URL.EntityCode#' 
		  AND EntityClass  = '#URL.EntityClass#'
		  AND ActionCode   = '#URL.ID#' 
		</cfquery>

</cfif>

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

	<script language="JavaScript">
	   window.location = "FlowView.cfm?EntityCode=#URL.EntityCode#&EntityClass=#URL.EntityClass#&mid=#mid#"
	</script>

</cfoutput>
			