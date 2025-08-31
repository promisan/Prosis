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
<cftransaction>

<cfparam name="Form.Workgroup"   default="">
<cfparam name="Form.Observation" default="">

<cfif form.workgroup eq "">

	<script>
		alert("A workgroup has not been configured and/or published.")
	</script>
	<CFABORT>

</cfif>


<cfquery name="getFlow" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Ref_AssetActionCategoryWorkflow C
	 WHERE   C.ActionCategory = '#form.actioncategory#'		
	 AND     C.Category       = '#url.Category#' 
	 AND     C.Code           = '#Form.Observation#'	
</cfquery>

<cfif getFlow.EntityClass eq "">

	<script>
		alert("A workflow has not been configured and/or published for this observation.")
	</script>
	<CFABORT>

</cfif>

<cfquery name="Last" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     AssetItemObservation
		ORDER BY ObservationNo DESC
</cfquery>

<cfif last.recordcount eq "0">
	<cfset la = 1>	
<cfelse>
	<cfset la = last.observationNo+1>
</CFIF>

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.ObservationDate,CLIENT.DateFormatShow)#">
<cfset STR = dateValue>

<cfquery name="Logging" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 INSERT INTO AssetItemObservation
			  (ObservationId,	
			   AssetId,		  	   			 
			   ObservationNo, 
			   ObservationClass,
			   ActionCategory,
			   Category,
			   ObservationDate,
			   Observation,		
			   ObservationMemo,	  
			   ObservationPriority,			 
			   ObservationOutline,
			   OfficerUserId, 
			   OfficerLastName, 
			   OfficerFirstName)
	 VALUES   ('#Form.ObservationId#',	 
	           '#url.assetid#',         
			   '#La#', 
			   '#url.observationclass#',
			   '#Form.ActionCategory#',			  
			   '#url.Category#',
			    #str#,
			   '#Form.Observation#',			  
			   '#Form.ObservationMemo#',
			   '#Form.ObservationPriority#',			
			   '#Form.ObservationOutline#',
			   '#SESSION.acc#', 
			   '#SESSION.last#', 
			   '#SESSION.first#'
			   )		
</cfquery>	

<!--- check if wf exists --->

</cftransaction>

<!--- establish the workflow object --->

<cfset link = "Warehouse/Application/Asset/Observation/DocumentEditWorkflow.cfm?id=#Form.ObservationId#">

	
<cf_ActionListing 
		EntityCode       = "AssObservation"
		EntityGroup      = "#Form.Workgroup#"
		EntityClass      = "#getFlow.EntityClass#"
		EntityStatus     = "0"				
		ObjectReference  = "Observation #getFlow.description# under No #la#"
		ObjectReference2 = "#SESSION.first# #SESSION.last#"
		ObjectKey4       = "#Form.ObservationId#"
		ObjectURL        = "#link#"
		Show             = "No"
		Toolbar          = "No"
		Framecolor       = "ECF5FF"
		CompleteFirst    = "No">	
		
<cfoutput>		
				 
	<script>		
		try {	
		parent.opener.applyfilter('','','content') } catch(e) {}
		parent.window.location = 'DocumentEdit.cfm?drillid=#form.observationid#'
		
	</script>

</cfoutput>


