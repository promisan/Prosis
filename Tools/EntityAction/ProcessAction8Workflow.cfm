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
<cfquery name="Object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObject
	   WHERE   ObjectId IN (SELECT ObjectId 
	                        FROM OrganizationObjectAction 
							WHERE ActionId = '#URL.AjaxId#')	
</cfquery>

<cfquery name="Class" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     R.EmbeddedClass
     FROM       OrganizationObjectAction OA INNER JOIN
                Ref_EntityActionPublish R ON OA.ActionPublishNo = R.ActionPublishNo AND OA.ActionCode = R.ActionCode
	 WHERE      ActionId = '#URL.AjaxId#' 				
</cfquery>

<cfset link = "#Object.ObjectURL#">
									
<cf_ActionListing 
	EntityCode       = "#Object.EntityCode#"
	EntityClass      = "#Class.EmbeddedClass#"
	EntityGroup      = "#Object.EntityGroup#"
	EntityStatus     = "#Object.EntityStatus#"
	Mission          = "#Object.mission#"
	OrgUnit          = "#Object.orgunit#"
	PersonNo         = "#Object.PersonNo#" 
	PersonEMail      = "#Object.PersonEMail#"
	ObjectReference  = "#Object.ObjectReference#"
	ObjectReference2 = "Embedded workflow"
	ObjectKey4       = "#URL.AjaxId#"
	ObjectURL        = "#link#"
	Show             = "Yes"
	AjaxId           = "Embed"
	Toolbar          = "Yes"
	Framecolor       = "ECF5FF"
	CompleteFirst    = "No">