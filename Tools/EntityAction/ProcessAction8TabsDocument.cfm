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


<cfparam name="url.action" default="">	

<cfquery name="Document" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   TOP 15 * 
			FROM     OrganizationObjectActionReport A,
			         Ref_EntityDocument D 
			WHERE    A.ActionId   = '#url.id#' 
			AND      A.DocumentId = D.DocumentId			
			<!--- Added by Jorge Armin Mazariegos as an enhancement 
			September 2010 to shown only operational reports for that entity ---->
			AND      D.Operational = '1'
			ORDER BY D.DocumentOrder, A.Created			
</cfquery>

   
<cfparam name="url.docid" default="#Document.Documentid#">
<cfparam name="sel" default="1">	
	
 <table width="100%" height="100%">
 
 	   <tr>	
 
	   <cfif document.recordcount eq "0">	
	   
	    <script>	       
			   try {
					 document.getElementById('menudocument').disabled = true 
					 document.getElementById('menudocument').className = "hide"					 
				 } catch(e) { }						 
	
		</script>	
		 		
	   <cfelseif document.recordcount gte "2">		    
	   	 	   
		   <td valign="top" style="width:100px;border-right:1px solid gray">  
				
			   	<table style="width:100%">
		  	   				
				 <cfset ht = "32">
				 <cfset wd = "32">	
				
				 <cfloop query="document"> 	
				 
				 <tr class="line">
				 
				 	<cfif url.docid eq documentid>
						<cfset sel = currentrow>					
						<cfset class = "highlight3">
					<cfelse>
						<cfset class = "regular">
					</cfif>		
												 
					<cf_menutab base       = "docsel"
					            item       = "#currentrow#" 
								target     = "doc"
					            targetitem = "1"
								padding    = "8"
					            iconsrc    = "DocumentEdit.png" 
								iconwidth  = "53" 
								class      = "#class#"
								iconheight = "60" 
								name       = "#DocumentDescription#"
								source     = "ProcessActionDocumentTextContent.cfm?no=#currentrow#&textmode=EDIT&memoactionid=#url.id#&documentid=#documentid#">	
								
					</tr>			
				 		 
				 </cfloop>
								 
				</table>
			 
			 </td>
			 					
		</cfif>		
				
		<cfif document.recordcount gte "1">		

			<script>	    
			   
				   try {
						 document.getElementById('menudocument').disabled = false 						 
					} catch(e) { }					 
		
			</script>	
			
		</cfif>	
					
		<td valign="top" height="100%">
									
				<table width="100%" height="100%">				
																															 
					 <cf_menucontainer name="doc" item="1" class="regular">		
					 								
						 <cfif document.recordcount gte "1" and sel neq "" and url.action neq "delete">
												
							   <cfset url.no = sel>
							   <cfset url.textmode     = "EDIT">
							   <cfset url.memoactionid = url.id>
							   <cfset url.documentid   = url.docid>		
							  						   
							   <cfinclude template     = "ProcessActionDocumentTextContent.cfm">			   
							 						   					   				   
						 </cfif>
					 
					</cf_menucontainer>
										
			   </table>  
		   
		 </td>
		 
		 </tr>
		   
</table>

<cfset ajaxonload("initTextArea")>
		