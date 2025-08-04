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

<!--- save association and refresh screen underlying --->

<cfparam name="url.scope" default="regular">
<cfparam name="url.sourceId" default="">

<cfif url.sourceId eq "">

  <cfif form.sourceId eq "">
	  <cfset sourceId = 'NULL'> 
  <cfelse>
  	  <cfset sourceId = "'#form.sourceId#'">
  </cfif>
<cfelse>  
  <cfset sourceid = "'#url.sourceId#'">
</cfif>
		
<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    *
	     FROM      ElementRelation
		 WHERE     Elementid      = '#url.elementidFROM#'
		 AND       ElementidChild = '#url.elementidTO#'		
</cfquery>

<cfif Check.recordcount eq "0">
	
	<cfquery name="Check2" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    *
	     FROM      ElementRelation
		 WHERE     
	 	 Elementid      = '#url.elementidTO#' AND       
		 ElementidChild = '#url.elementidFROM#'	
	</cfquery>
	
	<cfif Check2.recordcount neq 0>
	
		<cfquery name="Logging" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 INSERT INTO ElementRelationLog
    			 (Elementid,
	    		  ElementidChild,
				  RelationCode,
				  RelationMemo,
				  DateExpiration,
				  OfficerUserid,
				  OfficerLastName,
				  OfficerFirstName)
			 VALUES
				 ('#Check2.ElementId#',
				  '#Check2.ElementIdChild#',
				  '#Check2.RelationCode#',
				  '#Form.Memo#',
				  getdate(),
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')		 
		</cfquery>
	
		<cfquery name="Check2" 
			datasource="AppsCaseFile" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 DELETE ElementRelation
				 WHERE     
				 Elementid      = '#url.elementidTO#' AND       
				 ElementidChild = '#url.elementidFROM#'	
		</cfquery>	
		
	</cfif>
	
	<cfquery name="Insert" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 INSERT INTO ElementRelation
			 (RelationId,Elementid,ElementidChild,RelationCode,RelationElementId, RelationMemo,OfficerUserid,OfficerLastName,OfficerFirstName)
			 VALUES
			 ('#url.relationid#','#url.elementidFROM#','#url.elementidTo#','#form.RelationCode#',#preservesinglequotes(sourceId)#,'#form.Memo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')		 
	</cfquery>
	
<cfelse>
	
<cfquery name="Update" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 UPDATE  ElementRelation
	 SET     RelationCode      = '#form.RelationCode#',
	 		 RelationElementId = #preservesinglequotes(sourceId)#,
	         RelationMemo      = '#form.Memo#',
			 OfficerUserid     = '#SESSION.acc#',
			 OfficerLastName   = '#SESSION.last#',
			 OfficerFirstName  = '#SESSION.first#' 
	 WHERE   Elementid         = '#url.elementidFROM#'
	 AND     ElementidChild    = '#url.elementidTo#'		
</cfquery>
	
</cfif>

<cfif url.scope eq "embed">

   <cfoutput>
   
    <cfif url.mode eq "Children">

		<script>
		ColdFusion.navigate('../Association/AssociationListingDetail.cfm?show=#mode#&mission=#url.mission#&elementid=#url.elementidFROM#&elementclass=#url.elementclass#','#mode#_#url.elementclass#_ass')	
		</script>
	
	<cfelse>
	
		<script>
		ColdFusion.navigate('../Association/AssociationListingDetail.cfm?show=#mode#&mission=#url.mission#&elementid=#url.elementidTo#&elementclass=#url.elementclass#','#mode#_#url.elementclass#_ass')	
		</script>
	
	</cfif>
	
   </cfoutput>	

<cfelse>

	<cfoutput>
			
	<script>	
	 alert("Added") 
	 parent.parent.associaterefresh('#url.mission#','#url.elementidFROM#','#url.elementclass#','#url.mode#')		 
	</script>
	
	</cfoutput>
	
</cfif>	

