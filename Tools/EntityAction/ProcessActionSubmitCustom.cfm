<!--- save the custom fields as listed on the screen --->

	<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM OrganizationObjectAction 		
	 WHERE  ActionId = '#URL.ID#' 
	</cfquery>
					
	<!--- save custom fields --->
	
	<cfquery name="Fields" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	   
	     SELECT   R.*
		 FROM     Ref_EntityDocument R INNER JOIN
                  Ref_EntityActionDocument A ON R.DocumentId = A.DocumentId
		 WHERE    A.ActionCode = '#Action.ActionCode#' 
		 AND      R.DocumentType = 'field' 
		 AND      R.Operational = 1
	</cfquery>
	
	<cfloop query="Fields">
	
	<!--- check if field exist --->
	
	<cfset des = documentdescription>
	
	<cfquery name="Check" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">	   
	     SELECT   *
		 FROM     OrganizationObjectInformation
		 WHERE    ObjectId   = '#Action.ObjectId#'
		 AND      DocumentId = '#DocumentId#'
	</cfquery>
	
	<cfif fieldtype eq "checkbox">
	   <cfparam name="Form.f_#DocumentCode#" default="No">
	<cfelse>
	   <cfparam name="Form.f_#DocumentCode#" default="">
	</cfif>
	
		
	<cfif IsDefined("Form.f_#DocumentCode#")>
		
		<cfset val = evaluate("Form.f_#DocumentCode#")>		
		
		<cfif fieldSelectMultiple eq "1">
		
			<cfset valset = "">
		
			<cfloop index="itm" list="#val#">
			
				<cfif valset eq "">
					<cfset valset = "'#itm#'">
				<cfelse>
				    <cfset valset = "#valset#,'#itm#'">
				</cfif>  
				
			</cfloop>
			
			<cfset val = valset>
		
		</cfif>		
					
		<cfif fieldtype eq "list" and val neq "">
			
				 <cfquery name="List" 
				 datasource="AppsOrganization"
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">	   
				 SELECT *
				 FROM   Ref_EntityDocumentItem
				 WHERE  DocumentId = '#documentid#'
				 AND    DocumentItem IN (#preserveSingleQuotes(val)#)			 
			     </cfquery>
									   
			   <cfset cde = val>
			   <cfset val = list.DocumentItemName>
			   
		<cfelse>
			
			   <cfset cde = fieldtype>
			   <cfset val = val>   
						
		</cfif>
		
		<cfif fieldtype eq "list"  and val neq "">
		
			<cfquery name="Clear" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">	   
			     DELETE   FROM    OrganizationObjectInformation
				 WHERE    ObjectId   = '#Action.ObjectId#'
				 AND      DocumentId = '#DocumentId#'
			</cfquery>
			
			<cfloop query="List">
			
						 <cfquery name="getinfo" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">	   
						 SELECT * 
						 FROM     OrganizationObjectInformation
						 WHERE    ObjectId          = '#Action.ObjectId#'
					 	 AND      DocumentId        = '#DocumentId#'
						 AND      DocumentItemValue = '#DocumentItemName#'
					 </cfquery>
					 
					 <cfif getinfo.recordcount eq "0">						
			
						 <cfquery name="InsertMe" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">	   
						 INSERT INTO OrganizationObjectInformation
						   (ObjectId, 
						    DocumentId, 
							DocumentSerialNo,
							DocumentDescription, 
							DocumentItem,
							DocumentItemValue, 
							OfficerUserId, 
							OfficerLastName, 
							OfficerFirstName)
						 VALUES
						 ('#Action.ObjectId#',
						   '#DocumentId#',
						   '#currentrow#',
						   '#des#',
						   '#DocumentItem#',
						   '#DocumentItemName#',
						   '#SESSION.acc#',
						   '#SESSION.last#',
						   '#SESSION.first#')		
					      </cfquery>		
				   
				   </cfif>
			
			</cfloop>	
		
		<cfelse>

			<cfif check.recordcount eq "0">
						
				   <cfquery name="InsertMe" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">	   
					 INSERT INTO OrganizationObjectInformation
					   (ObjectId, 
					    DocumentId, 
						DocumentDescription, 
						DocumentItem,
						DocumentItemValue, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName)
					 VALUES
					 ('#Action.ObjectId#',
					   '#DocumentId#',
					   '#DocumentDescription#',
					   '#cde#',
					   '#val#',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')		
				   </cfquery>
				
			<cfelse>	
			
					<cfquery name="Update" 
					 datasource="AppsOrganization"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">	   
					 UPDATE OrganizationObjectInformation
					 SET    DocumentDescription = '#DocumentDescription#', 
					        DocumentItem = '#cde#',
						    DocumentItemValue = '#val#'
					 WHERE    ObjectId = '#Action.ObjectId#'
					 AND      DocumentId = '#DocumentId#'		
					 		
					</cfquery>
				
			</cfif>
		
		</cfif>
		
	<cfelse>
	
		<cfif fieldrequired eq "1">		
			
			<cfoutput>
			
			<script>			    
			    alert("Please submit value for field #DocumentDescription#")			
			</script>	
			</cfoutput>
			
			<cfabort>
			
		</cfif>	
	</cfif>
		
	</cfloop>
	
<cfparam name="url.closemode" default="1">	

<cfif url.closemode eq "1">
		
	<cfif url.wfmode eq "8">
	
		<!--- only process if the submit button is selected --->
			
		<cfoutput>
			
			<script>
			   ptoken.navigate('ProcessActionSubmit.cfm?windowmode=#url.windowmode#&submitaction=saveaction&wfmode=#url.wfmode#&process=#URL.Process#&ID=#URL.ID#&ajaxId=#url.ajaxid#','actionprocessbox','','','POST','processaction')				 
			</script>
			
		</cfoutput>
	
	</cfif>	

</cfif>
