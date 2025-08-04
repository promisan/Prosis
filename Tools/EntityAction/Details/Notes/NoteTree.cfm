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


<cfquery name="Current" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   ActionCode 
    FROM     OrganizationObjectAction 
    WHERE    ObjectId = '#URL.ObjectId#'
	AND      ActionStatus = '0'
	ORDER BY ActionFlowOrder 
</cfquery>	

<cfquery name="Step" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT O.EntityCode, R.ActionDescription, R.ActionCode, R.ActionOrder
	FROM       Ref_EntityActionPublish R INNER JOIN
               OrganizationObject O ON R.ActionPublishNo = O.ActionPublishNo
	WHERE      O.ObjectId = '#URL.ObjectId#'
	AND        (R.ActionCode IN (SELECT ActionCode 
	                        FROM   OrganizationObjectAction 
							WHERE  ObjectId = '#URL.ObjectId#'
							AND    ActionStatus >= '2') or R.ActionCode = '#current.actionCode#')
	ORDER BY R.ActionOrder
</cfquery>	 

<cfquery name="Group" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    L.DocumentItem, L.DocumentItemName, L.DocumentId, L.DocumentItemClass
	FROM      Ref_EntityDocument R INNER JOIN
              Ref_EntityDocumentItem L ON R.DocumentId = L.DocumentId
	WHERE     R.DocumentMode = 'Notes'
	AND       R.EntityCode = '#Step.EntityCode#'
	ORDER BY L.ListingOrder
</cfquery>	 

<cfquery name="Actor" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT OfficerUserId, OfficerLastName, OfficerFirstName
	FROM      OrganizationObjectActionMail
	WHERE     ObjectId = '#URL.ObjectId#'
</cfquery>	 


<cfquery name="Date" 
	datasource="AppsOrganization"
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT YEAR(MailDate) as Year, MONTH(MailDate) AS Month
	FROM         OrganizationObjectActionMail	
	WHERE     ObjectId = '#URL.ObjectId#'
	ORDER BY YEAR(MailDate), MONTH(MailDate)
</cfquery>	 

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td>

<cfform>

	<cftree name="root"
		        font="Verdana"
		        fontsize="11"		
		        bold="No"   
				format="html"    
		        required="No">
				
			 <cf_tl id="Step" var="1">
			 <cfset tStep = "#Lt_text#">					
				
			<cftreeitem value="Action"
		            display="<span style='padding-top:3px;padding-bottom:3px;' class='labellarge'>#tStep#</span>"					
		           	expand="Yes">	
					
			<cfoutput query="Step">	
					
				<cfset l = len(actionDescription)>
				<cfif l gt 30>
				  <cfset nm= "#left(actionDescription,30)#..">
				<cfelse>  
				  <cfset nm= "#actionDescription#">
				</cfif>
					
					<cftreeitem value="#actioncode#"
			            display="#nm#"
			            parent="Action"
						img="#SESSION.root#/Images/select.png"
			            href="javascript:listshow('actioncode','#actioncode#')"
			            queryasroot="No"
			            expand="No">						
				
			 </cfoutput>
			 
			 <cfif group.recordcount gte "1">
			 
				 <cf_tl id="Classification" var="1">
				 <cfset tClassification = "#Lt_text#">				 
				 
				 <cftreeitem value="Group"
			            display="<span style='padding-top:3px;padding-bottom:3px;' class='labellarge'>#tClassification#</span>"						
			           	expand="Yes">	
						
				<cfoutput query="Group" group="DocumentItemClass">	
	
						<cfif DocumentItemClass neq "">
						
							<cftreeitem value="#DocumentItemClass#"
				            display="#DocumentItemClass#"
							img="#SESSION.root#/Images/select.png"
							href="javascript:listshow('documentitem','#documentitem#')"		          			
							parent="Group"				
				            expand="No">
							
							<cfset vParent="#DocumentItemClass#">
						<cfelse>
							<cfif Group.recordcount eq 1>
								<cfset vParent="Group">											
							<cfelse>
							
								<cftreeitem value="Standard"
						            display="Standard"
									img="#SESSION.root#/Images/select.png"
									href="javascript:listshow('documentitem','#documentitem#')"		          			
									parent="Group"				
							        expand="No">
			
									<cfset vParent="Standard">											
							</cfif>
							
						</cfif>
	
						<cfoutput>					
							<cftreeitem value="#DocumentItem#"
				            display="#DocumentItemName#"
							img="#SESSION.root#/Images/select.png"
							href="javascript:listshow('documentitem','#documentitem#')"		          			
							parent="#vParent#"				
				            expand="No">						
						</cfoutput>				
				 </cfoutput>	
				 
				 </cfif>		
				 
				 <cfif actor.recordcount gte "1">
				 
				 <cf_tl id="Person" var="1">
				 <cfset tPerson = "#Lt_text#">		
			 
			 <cftreeitem value="Actor"
		            display="<span style='padding-top:3px;padding-bottom:3px;' class='labellarge'>#tPerson#</span>"
					parent="root"						
		           	expand="Yes">	
					
			<cfoutput query="Actor" >	
					
					<cftreeitem value="#currentrow#"
		            display="#OfficerFirstName# #OfficerLastName#"
					img="#SESSION.root#/Images/select.png"
					href="javascript:listshow('officeruserid','#officeruserid#');"		          						
					parent="Actor"				
		            expand="No">						
				
			 </cfoutput>	
			 
			 </cfif>		 
	
	</cftree>
			
</td></tr>
</cfform>
</table>



