
<cfoutput>
	
	<cfif Action.ActionViewMemo eq "Prior">
	
		<!--- original --->
			
		<cfquery name="Min" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT   MIN(ActionFlowOrder) as ActionFlowOrder
		   FROM     OrganizationObjectAction
		   WHERE    ActionCode = '#Action.ActionCode#'
		   AND      ObjectId  = '#Action.ObjectId#' 
		</cfquery>
		
		<cfquery name="Act" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT   *
		   FROM     OrganizationObjectAction
		   WHERE    ActionFlowOrder = '#Min.ActionFlowOrder-1#' 
		   AND      ObjectId  = '#Action.ObjectId#' 
		</cfquery>
		
		<cfset act = Act.ActionCode>
		
	<cfelse>
	
		<cfset act = Action.ActionViewMemo>	
	
	</cfif>

	<cfquery name="Prior" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		   SELECT     TOP 1 OA.*, A.ActionDescription
		   FROM       OrganizationObjectAction OA, Ref_EntityAction A
		   WHERE      OA.ActionCode      = '#act#' 
		   AND        OA.ActionCode    ! = '#Action.ActionCode#'
		   AND        OA.ObjectId        = '#Action.ObjectId#'
		   AND        A.ActionCode       = OA.ActionCode
		   AND        OA.ActionStatus   >= '2'
		   ORDER BY   OA.CREATED DESC 
	</cfquery>
   	   	   	    	  	
   <cfif Action.ActionViewMemo neq "">
  	  	   
 		<cfif prior.actionId neq "">
	
			<cfquery name="Check" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     OrganizationObjectActionReport
				 WHERE    ActionId = '#Prior.actionId#'
			</cfquery>	
			
			<cfif check.recordcount neq "0">
			
				<cf_tl id="Reference" var="1">			
				<cfset boxno = boxno+1>
			
				<cfif menumode eq "menu">
   
	    			<cf_menutab item = "#boxno#" 
			    	   iconsrc       = "Logos/System/Log.png" 
					   iconwidth     = "#wd#" 		  					
					   iconheight    = "#ht#" 
					   source        = "ProcessActionPriorView.cfm?textmode=prior&memoactionid=#Prior.Actionid#"
					   name          = "#lt_text#">	
			   
				<cfelse>
			 
				  <cf_menucontainer item="#boxno#"/>					 
			 
				</cfif>  	
					
		</cfif>	
	
	</cfif>				
			   
</cfif>
         
<!--- questionaire input from a workflow perspective --->
<cfquery name="Questionaire" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT     D.DocumentId, 
	           D.DocumentCode, 
			   D.DocumentDescription,
			   A.ActionCode
    FROM       Ref_EntityActionDocument A INNER JOIN
               Ref_EntityDocument D ON A.DocumentId = D.DocumentId
    WHERE      A.ActionCode   = '#act#' 
	AND        D.DocumentType = 'Question'
	<!--- enabled for this workflow --->
	AND        D.DocumentId IN (SELECT DocumentId
	                           FROM   Ref_EntityActionPublishDocument 
							   WHERE  ActionPublishNo = '#Object.ActionPublishNo#' 
							   AND    ActionCode = '#act#' 
							   AND    Operational = 1)
    ORDER BY   D.DocumentOrder 
</cfquery>	

<cfif Questionaire.recordcount neq "0">
	
	<cfset entrymode = "view">	
	
	<cfset boxno = boxno+1>
	
	<cfif menumode eq "menu">
   
    		<cf_menutab item       = "#boxno#" 
	    	   iconsrc    = "Logos/System/Log.png" 
			   iconwidth  = "#wd#" 		  					
			   iconheight = "#ht#" 
			   name       = "Logged Questionaire">	
			   
	<cfelse>
	
		 <cf_menucontainer item="#boxno#">
		 
		  <cfinclude template="ProcessActionQuestionaireContent.cfm">		
	
		</cf_menucontainer>
	
	</cfif>		   	
	
</cfif>
   
</cfoutput>	   