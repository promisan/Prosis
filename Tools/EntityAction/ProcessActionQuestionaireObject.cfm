<!--
    Copyright © 2025 Promisan B.V.

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

