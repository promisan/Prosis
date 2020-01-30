
<cfquery name="get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_EntityActionPublish R
	WHERE    ActionPublishNo =
                  (
				   SELECT  MAX(ActionPublishNo)
                   FROM    Ref_EntityClassPublish
                   WHERE   EntityCode = '#url.entitycode#' 
			       AND     EntityClass = '#url.entityclass#'
				  )
				   
    AND      (ActionParent = 'INIT')
</cfquery>

<cfset actionPublishNo    = "#get.actionpublishno#">
<cfset actioncode         = "#get.actioncode#">
<cfset Object.ObjectId    = "00000000-0000-0000-0000-000000000000">
<cfset entrymode          = "sourceobject">

<!--- questionaire input --->

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
    WHERE      A.ActionCode = '#actioncode#' 
	AND        D.DocumentType = 'Question'
	<!--- enabled for this workflow --->
	AND        D.DocumentId IN (SELECT DocumentId
	                           FROM   Ref_EntityActionPublishDocument 
							   WHERE  ActionPublishNo = '#ActionPublishNo#' 
							   AND    ActionCode      = '#actionCode#' 
							   AND    Operational     = 1)
    ORDER BY   D.DocumentOrder 
</cfquery>	

<cfif Questionaire.recordcount neq "0">		 

	 <cfinclude template="ProcessActionQuestionaireContent.cfm">	
	 
<cfelse>

	<table align="center"><tr><td class="labelit"><font color="0080C0">No questions have been defined</font></td></tr></table>
	 	 
</cfif>

