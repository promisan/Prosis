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
<!--- Retrieve pending workflow by action

<cf_wfPending EntityCode="aaaa" Table="#answer1#">

0   requires EntityCode to be passed 
1.  Define first pending step with status 0 or 1 (hold) for a document, 
2.	Passes the actioncode and parentcode for the last action 
3.  Result will be answer
--->	

<cfparam name="Attributes.EntityCode" default="VacCandidate">
<cfparam name="Attributes.Table" default="tmp">
<cfparam name="Attributes.ActionTable" default="OrganizationObjectAction">


<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf1">	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf2">
<cf_droptable dbname="AppsQuery" tblname="#Attributes.Table#">

	<cfquery name="step1"
	datasource="AppsOrganization"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT  O.ObjectId, 
	        O.EntityCode, 
			O.ObjectKeyValue1, 
			O.ObjectKeyValue2, 
			O.ObjectKeyValue3, 
			O.ObjectKeyValue4, 
			O.ActionPublishNo,
			MAX(A.ActionFlowOrder) AS ActionFlowOrder,
	        R1.EntityClassName
	INTO    userQuery.dbo.#SESSION.acc#wf
	FROM    OrganizationObject O INNER JOIN
	        #Attributes.ActionTable# A ON O.ObjectId = A.ObjectId INNER JOIN
	        Ref_EntityClassPublish R ON A.ActionPublishNo = R.ActionPublishNo INNER JOIN
	        Ref_EntityClass R1 ON R.EntityCode = R1.EntityCode AND R.EntityClass = R1.EntityClass
	WHERE   O.EntityCode IN ('#Attributes.EntityCode#') 
	AND     A.ActionStatus IN ('2','2Y','2N')
	AND     O.Operational  = 1	
	GROUP BY O.ObjectId, 
	         O.EntityCode, 
			 O.ObjectKeyValue1, 
			 O.ObjectKeyValue2, 
			 O.ObjectKeyValue3, 
			 O.ObjectKeyValue4, 
			 O.ActionPublishNo,
			 R1.EntityClassName
			 
			 
	</cfquery>
	
	<cfquery name="step2"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  DISTINCT T.*, 
		        Max(O.ActionCode) AS ActionCode, 
				Max(R.ParentCode) AS ParentCode
		INTO    userQuery.dbo.#SESSION.acc#wf1
		FROM    userQuery.dbo.#SESSION.acc#wf T, 
		        Organization.dbo.#Attributes.ActionTable# O,
				Organization.dbo.Ref_EntityAction R
		WHERE   T.ObjectId = O.ObjectId 
		AND     T.ActionFlowOrder = O.ActionFlowOrder 
		AND     O.ActionCode = R.ActionCode
		GROUP BY  T.ObjectId, 
	              T.EntityCode, 
			      T.ObjectKeyValue1, 
			      T.ObjectKeyValue2, 
			      T.ObjectKeyValue3, 
			      T.ObjectKeyValue4, 		
			      T.ActionFlowOrder,
				  T.ActionPublishNo,	
	              T.EntityClassName
	</cfquery>	
	
	<cfquery name="step3"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
		SELECT  T.*, O.OrgUnit, O.ActionId, O.OfficerUserId, O.OfficerLastName, O.OfficerFirstName, O.OfficerDate
		INTO    userQuery.dbo.#SESSION.acc#wf2
		FROM    userQuery.dbo.#SESSION.acc#wf1 T, 
		        Organization.dbo.#Attributes.ActionTable# O
		WHERE   T.ObjectId = O.ObjectId 
		AND     T.ActionFlowOrder = O.ActionFlowOrder 
		AND     T.ActionCode = O.ActionCode		
	</cfquery>	
	
	<cfquery name="CurrentStatus"
	datasource="AppsQuery"
	username="#SESSION.login#"
	password="#SESSION.dbpw#">
	SELECT     T.*, 
	           A.ActionDescription AS ActionDescriptionDue, 
			   AP.ActionOrder,
			   P.ListingOrder AS ParentOrder, 
			   P.Description AS ParentDescription
	<cfif attributes.table neq "">
	INTO       dbo.#Attributes.Table#
	</cfif>	
	FROM       userQuery.dbo.#SESSION.acc#wf2 T INNER JOIN
               Organization.dbo.Ref_EntityAction A ON T.ActionCode = A.ActionCode INNER JOIN
               Organization.dbo.Ref_EntityActionPublish AP ON T.ActionPublishNo = AP.ActionPublishNo AND T.ActionCode = AP.ActionCode LEFT OUTER JOIN
               Organization.dbo.Ref_EntityActionParent P ON T.EntityCode = P.EntityCode AND T.ParentCode = P.Code	    
	</cfquery>		
	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf1">	
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#wf2">	
	
	