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
<cf_compression>

<cfparam name="url.lo"  default="0">
<cfparam name="url.lan"  default="0">
<cfparam name="url.fil" default="">
<cfparam name="url.frc" default="0">
<cfparam name="url.frc" default="0">
<cfparam name="url.prm" default="">

<cfif url.op eq "true">
	<cfparam name="operational" default="1">
<cfelse>
    <cfparam name="operational" default="0">
</cfif>

<cfif url.frc eq "true">
	<cfparam name="force" default="1">
<cfelse>
    <cfparam name="force" default="0">
</cfif>

<cfif url.publishNo eq "">

	<cfquery name="Check" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * FROM Ref_EntityClassActionDocument
		  WHERE   EntityCode     = '#URL.EntityCode#'
		  AND     EntityClass    = '#URL.EntityClass#'
		  AND     ActionCode     = '#URL.ActionCode#'
	   	  AND     DocumentId     = '#URL.ID2#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO Ref_EntityClassActionDocument
				  (EntityCode, 
				   EntityClass, 
				   ActionCode, 
				   DocumentId, 
				   DocumentLanguageCode,
				   ObjectFilter, 
				   ForceDocument,
				   UsageParameter,
				   ListingOrder, 
				   Operational)
			  VALUES
				  ('#URL.EntityCode#',
				   '#URL.EntityClass#',
				   '#URL.ActionCode#',
				   '#URL.ID2#',
				   '#url.lan#',
				   '#url.fil#',
				   '#url.frc#',
				   '#url.prm#',
				   '#url.lo#',
				   '#Operational#')		
		</cfquery>
	
	<cfelse>
		
		<cftry>
						
			<cfquery name="Update" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE Ref_EntityClassActionDocument
				  SET    ListingOrder         = '#url.lo#',
				         Objectfilter         = '#url.fil#', 
						 DocumentLanguageCode = '#url.lan#',
						 ForceDocument        = '#force#',
						 UsageParameter       = '#url.prm#',
				         Operational          = '#Operational#' 
				  WHERE  ActionCode           = '#URL.ActionCode#'
				  AND    EntityCode           = '#URL.EntityCode#'
				  AND    EntityClass          = '#URL.EntityClass#'
			   	  AND    DocumentId           = '#URL.ID2#'
			</cfquery>
			
												
			<cfcatch>
			
				<script>alert("Please enter a valid order.")</script>		
								
			</cfcatch>
		
		</cftry>
	
	</cfif>
	
<cfelse>
	
	<cfquery name="Check" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * FROM Ref_EntityActionPublishDocument
		  WHERE  ActionCode     = '#URL.ActionCode#'
		  AND    ActionPublishNo = '#URL.PublishNo#'
	   	  AND    DocumentId  = '#URL.ID2#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO Ref_EntityActionPublishDocument
			  (ActionPublishNo, ActionCode,DocumentLanguageCode, DocumentId, UsageParameter, ListingOrder, Operational)
			  VALUES
			  ('#URL.PublishNo#','#URL.ActionCode#','#url.lan#','#URL.ID2#','#url.prm#','#url.lo#','#Operational#')		
		</cfquery>
	
	<cfelse>
		
		<cftry>
		
			<cfquery name="Update" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE  Ref_EntityActionPublishDocument
				  SET     ListingOrder         = '#url.lo#',
				          Operational          = '#Operational#',
						  DocumentLanguageCode = '#url.lan#',
						  ForceDocument        = '#force#',
						  UsageParameter       = '#url.prm#',
  						  Objectfilter         = '#url.fil#'
				  WHERE   ActionCode           = '#URL.ActionCode#'
				  AND     ActionPublishNo      = '#URL.PublishNo#'
			   	  AND     DocumentId           = '#URL.ID2#'
			</cfquery>
			
			<cfcatch>
			
				<script>alert("Please enter a valid order")</script>
				
			</cfcatch>
		
		</cftry>
	
	</cfif>

</cfif>	



  
