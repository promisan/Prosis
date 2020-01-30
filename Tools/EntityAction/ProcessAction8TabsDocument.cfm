
<cfparam name="url.action" default="">	

<cfquery name="Document" 
		datasource="appsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT TOP 15 * 
			FROM   OrganizationObjectActionReport A,
			       Ref_EntityDocument D 
			WHERE  A.ActionId   = '#url.id#' 
			AND    A.DocumentId = D.DocumentId			
			<!--- Added by Jorge Armin Mazariegos as an enhancement 
			September 2010
			to shown only operational reports for that entity ---->
			AND    D.Operational = '1'
			ORDER BY D.DocumentOrder, A.Created
</cfquery>
	   
<cfparam name="url.docid" default="#Document.Documentid#">
<cfparam name="sel" default="1">	
		
 <table width="100%" height="100%">
 
	   <cfif document.recordcount eq "0">	
	   
	    <script>	       
			   try {
					 document.getElementById('menudocument').disabled = true 
					 document.getElementById('menudocument').className = "hide"
					 
					 } catch(e) { }	
					 
	
		</script>			
  		
	   <cfelseif document.recordcount gte "2">			  
	   	 	   
		   <tr><td valign="top">  
				
			   	<table width="100%" border="0"  cellspacing="0" cellpadding="0">
		  	   
			     <tr class="line">
				
				 <cfset ht = "32">
				 <cfset wd = "32">	
				
				 <cfloop query="document"> 	
				 
				 	<cfif url.docid eq documentid>
						<cfset sel = currentrow>					
						<cfset class = "highlight3">
					<cfelse>
						<cfset	class = "regular">
					</cfif>		
												 
					<cf_menutab base       = "docsel"
					            item       = "#currentrow#" 
								target     = "doc"
					            targetitem = "1"
								padding    = "0"
					            iconsrc    = "Documents.png" 
								iconwidth  = "32" 
								class      = "#class#"
								iconheight = "32" 
								name       = "#DocumentDescription#"
								source     = "ProcessActionDocumentTextContent.cfm?no=#currentrow#&textmode=EDIT&memoactionid=#url.id#&documentid=#documentid#">	
				 		 
				 </cfloop>
				 
				 <td width="10%"></td>
				 
				</tr>
				 
				</table>
			 
			 </td>
			 
			</tr>
					
		</cfif>
		
		<cfif document.recordcount gte "1">		

			<script>	    
			   
				   try {
						 document.getElementById('menudocument').disabled = false 						 
					} catch(e) { }					 
		
			</script>	
			
		</cfif>	
					
		<tr>
		
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
		