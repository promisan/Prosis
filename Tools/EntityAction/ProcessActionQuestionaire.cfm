
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
    WHERE      A.ActionCode = '#action.actioncode#' AND D.DocumentType = 'Question'
	<!--- enabled for this workflow --->
	AND        D.DocumentId IN (SELECT DocumentId
	                           FROM   Ref_EntityActionPublishDocument 
							   WHERE  ActionPublishNo = '#Object.ActionPublishNo#' 
							   AND    ActionCode = '#action.actionCode#' 
							   AND    Operational = 1)
    ORDER BY   D.DocumentOrder 
</cfquery>	


<cfif Questionaire.recordcount neq "0">
	
	<cfset entrymode = "workflow">
	
	<cfset boxno = boxno+1>
	
	<cfif menumode eq "menu">
   
    	<cf_menutab item       = "#boxno#" 
	       iconsrc    = "Logos/System/Questionaire.png" 
		   iconwidth  = "#wd#" 
		   class      = "regular"						
		   iconheight = "#ht#" 
		   name       = "Questionaire">		
		   
	<cfelse>
	
		 <cf_menucontainer item="#boxno#">		
			  <form name="formquestionaire" id="formquestionaire">					 
				 <cfinclude template="ProcessActionQuestionaireContent.cfm">	
			 </form>
		 </cf_menucontainer>	
		
	</cfif>	   
	
	<!---
	<cflayoutarea 
	    name   = "questionaire"
	    title  = "Questionaire">	
			 
		 <form name="formquestionaire" id="formquestionaire">					 
			 <cfinclude template="ProcessActionQuestionaireContent.cfm">	
		 </form>
	
	</cflayoutarea>
	
	--->

</cfif>

