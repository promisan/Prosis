

<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObjectAction OA, 
	           Ref_EntityActionPublish P,
			   Ref_EntityAction A				
	   WHERE   ActionId = '#URL.ID#' 
	   AND     OA.ActionPublishNo = P.ActionPublishNo
	   AND     OA.ActionCode = P.ActionCode 
	   AND     A.ActionCode = P.ActionCode
	</cfquery>
	
 <cfquery name="Embed" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT D.*
	   FROM   Ref_EntityDocument D		
	   WHERE  D.DocumentCode   = '#Action.ActionDialog#'
	   AND    D.EntityCode     = '#Object.EntityCode#'
	   AND    D.DocumentType   = 'dialog'
	   AND    D.DocumentMode IN ('Embed','Ajax')  
</cfquery>		  

<cfset boxno = 0>
<cfset ht = "64">
<cfset wd = "64">

 <!--- tab for instructions --->			
<cfinclude template="ProcessActionInstructions.cfm">	

 <!--- tab for embedded document --->           	  
<cfif Embed.DocumentTemplate neq "">
   	   	  
	   <!--- preload code for dialog embedded workflow --->
	  	   
	   <cfif Embed.DocumentMode eq "Ajax">		
	   	   	   	   
		   <!--- disabled as embedding now within a iframe to prevent outbreak of long pages 
		   
		   <cfinclude template="../Input/TextAjax/InputRichTextScript.cfm">
		   
		   <cfset l = len(Embed.DocumentTemplate)>		
	       <cfset path = left(Embed.DocumentTemplate,l-4)>	
		   
		   <!--- prepload acript for ajax form, script must be defined with samename, ending with XXXXScript.cfm --->
		 		 
		   <cfif FileExists("#SESSION.rootPath#\#path#Script.cfm")>			   		  
			   <cfinclude template="../../#path#Script.cfm"> 
		   </cfif>	
		      
		   --->		
		 		   
		   <cfset boxno = boxno+1>		
		   
		   <cfif boxno eq "1">
			   <cfset cl = "highlight">
		   <cfelse>
	   		   <cfset cl = "regular">	   
		   </cfif>   
		 		   
		   <cfif menumode eq "menu">
			
			   <cf_menutab item       = "#boxno#" 
				            iconsrc    = "Contract.png" 
							iconwidth  = "#wd#" 
							class      = "#cl#"						
							iconheight = "#ht#" 
							name       = "#Embed.DocumentDescription#"
							loadalways = "No"
							source     = "ProcessAction8Embed.cfm?process=#url.process#&wfmode=8&ID=#URL.ID#&ajaxId=#url.ajaxid#">				 		  
						
		   <cfelse>
		  	   		   
			    <cf_menucontainer item="#boxno#" class="regular">									
				      <cfinclude template="ProcessAction8Embed.cfm">
			    </cf_menucontainer>										
							
		   </cfif>			
		 							
		<cfelse>
		
		   <cfset boxno = boxno+1>
		   
		    <cfif boxno eq "1">
			   <cfset cl = "highlight">
		   <cfelse>
	   		   <cfset cl = "regular">	   
		   </cfif>  
		  
		   <cfif menumode eq "menu">
			
		   <cf_menutab item       = "#boxno#" 
			            iconsrc    = "Contract.png" 
						iconwidth  = "#wd#" 
						class      = "#cl#"						
						iconheight = "#ht#" 
						loadalways = "No"
						name       = "#Embed.DocumentDescription#">		
			
		   <cfelse>		   	   

		   	  <cf_menucontainer item="#boxno#" class="regular">					  
				      <cfinclude template="ProcessAction8Embed.cfm">
			  </cf_menucontainer>		
		   		   
		   </cfif>	
		  							
		</cfif>		
				   		   		  	   
</cfif> 	

<!--- tab for questionaire --->	   


<cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObjectAction OA, 
	           Ref_EntityActionPublish P,
			   Ref_EntityAction A				
	   WHERE   ActionId = '#URL.ID#' 
	   AND     OA.ActionPublishNo = P.ActionPublishNo
	   AND     OA.ActionCode = P.ActionCode 
	   AND     A.ActionCode = P.ActionCode
	</cfquery>

<cfinclude template="ProcessActionQuestionaire.cfm">		 	

<cfset boxno = boxno+1>
      
<cfif menumode eq "menu">

   	   <cfquery name="Action" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT  *
		   FROM    OrganizationObjectAction OA INNER JOIN Ref_EntityActionPublish P	ON OA.ActionPublishNo = P.ActionPublishNo AND  OA.ActionCode = P.ActionCode 	
		   WHERE   ActionId = '#URL.ID#' 		   
		</cfquery>     	
   
	   <cfquery name="Embed" 
		 datasource="AppsOrganization"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		   SELECT D.*
		   FROM   Ref_EntityDocument D		
		   WHERE  D.DocumentCode   = '#Action.ActionDialog#'
		   AND    D.EntityCode     = '#Object.EntityCode#'
		   AND    D.DocumentType   = 'dialog'  
	   </cfquery>
		
	   <cfif embed.documentMode eq "Ajax">
	   
		    <!--- load script for embedded forms --->
	   					 			 
			<cfajaximport tags="cfform,cfinput-autosuggest,cfdiv">
			<cf_ActionListingScript>
			<cf_FileLibraryScript>
			<cf_DetailsScript>		
											 
			<cfinclude template="../Input/TextAjax/InputRichTextScript.cfm">
						   
			<cfset l = len(Embed.DocumentTemplate)>		
			<cfset path = left(Embed.DocumentTemplate,l-4)>	
				   
			<!--- prepload acript for ajax form, script must be defined with samename, ending with XXXXScript.cfm --->
					 		 
			<cfif FileExists("#SESSION.rootPath#\#path#Script.cfm")>			   		  
			   <cfinclude template="../../#path#Script.cfm"> 
			</cfif>	
				    
	   </cfif>  
	         
	   <cfif url.ajaxid eq "">
	   	   <cfset pr = url.id>
	   <cfelse>
	       <cfset pr = url.ajaxid> 		   
	   </cfif>
	   
	   <cf_tl id="Process Step" var="1">
	   
	   <cfif boxno eq "1">
		   <cfset cl = "highlight">
	   <cfelse>
	   	   <cfset cl = "regular">	   
	   </cfif>
	   
	   <!--- pointer to allow quick revert to process tab --->
	   <cfset client.processtab = "#boxno#">
	  	  	 			  	   	   
	   <cf_menutab item  = "#boxno#" 
	       iconsrc       = "Process-Submission.png" 
		   iconwidth     = "64" 
		   class         = "#cl#"						
		   iconheight    = "64" 
		   name          = "#lt_text#"
		   loadalways    = "No"
		   source        = "ProcessAction8Step.cfm?process=#URL.process#&id=#url.id#&ajaxid=#url.ajaxid#">				
	
<cfelse>

		<cfif boxno eq "1">
		   <cfset cl = "regular">
	   <cfelse>
	   	   <cfset cl = "hide">	   
	   </cfif>
	      
		<cf_menucontainer item="#boxno#" class="#cl#">		
		      <cfinclude template="ProcessAction8Step.cfm">
		</cf_menucontainer>	  
   
</cfif>

   <cfquery name="Action" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	   SELECT  *
	   FROM    OrganizationObjectAction OA INNER JOIN Ref_EntityActionPublish P	ON OA.ActionPublishNo = P.ActionPublishNo AND  OA.ActionCode = P.ActionCode 	
	   WHERE   ActionId = '#URL.ID#' 		   
   </cfquery>  	
     					
   <!--- tab for prior documents to be shown --->		
   <cfinclude template="ProcessActionPrior.cfm">
     
   <!--- ----------------------------------------------------- --->		   
   <!--- initiatilization of documents ahead of the processing --->
   <!--- ----------------------------------------------------- --->	     
    
	<cfquery name="Format" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   C.OfficerLastName as LastName,
		         C.OfficerFirstName as FirstName, 
			     C.ActionId as CurrentDocument, 
			     C.SignatureBlock,
				 C.DocumentFormat,
				 C.DocumentLanguageCode,
		         R.*
		FROM     Ref_EntityDocument R LEFT OUTER JOIN
	             OrganizationObjectActionReport C ON R.DocumentId = C.DocumentId AND C.ActionId = '#URL.Id#'   
	    WHERE    R.DocumentId IN (SELECT DocumentId 
		                        FROM   Ref_EntityActionPublishDocument 
								WHERE  ActionPublishNo = '#Action.ActionPublishNo#' 
								AND    ActionCode      = '#Action.actioncode#' 
								AND    Operational     = 1)
		AND      R.DocumentType  = 'Report'	
		ORDER BY DocumentOrder
	</cfquery>	
		   
   <cfif format.recordcount gte "1">   
      	   
	   	<cfquery name="Document" 
			datasource="appsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   OrganizationObjectActionReport A,
			       Ref_EntityDocument D 
			WHERE  A.ActionId   = '#url.Id#' 
			AND    A.DocumentId = D.DocumentId
	   </cfquery>
	   
	   <cfif document.recordcount eq "0">
	     <cfset in = "true">
	   <cfelse>
	     <cfset in ="false">
	   </cfif>	   
	   
	   <cfif Action.labelDocument neq "">
	   	<cf_tl id = "#Action.LabelDocument#" var="1">	   
	   <cfelse>
	   	<cf_tl id = "Embedded Documents" var="1">
	   </cfif>
	  	   
	   <cfset boxno = boxno+1>	   
	  	  	     
	   <cfif menumode eq "menu">	
	  	   	     	   
	   	    <cfinclude template="Report/DocumentInit.cfm">  
						   
		   <cf_menutab item   = "#boxno#" 
			   	   iconsrc    = "Documents.png" 
				   iconwidth  = "#wd#" 	
				   tabid      = "document"	  					
				   button     = "yes"			   
				   iconheight = "64"
				   source     = "ProcessAction8TabsDocument.cfm?id=#URL.ID#&action=open" 
				   name       = "#lt_text#">	
							   
	   <cfelse>
	   
	     <cfoutput> 
		 <input type="hidden" id="documentmenu"      value="menu#boxno#">
	     <input type="hidden" id="documentcontainer" value="contentbox#boxno#">
		 </cfoutput>		
	   
	     <cf_menucontainer item="#boxno#">						  		  
		 	   <cfinclude template="ProcessAction8TabsDocument.cfm">			
		 </cf_menucontainer>	  
	      
	   </cfif> 	
	        
   </cfif>   
   
   <cfif boxno eq "1">
   
	   <!--- we hide the menu, to make the screen look more simply --->
	   <script>
	   try { document.getElementById('menutabs').className = 'hide' }
	   catch(e) { }	
	    </script>
	   
     
   <cfelseif menumode eq "content" and boxno gte "2">
      	 	  
	   <script>  	   	          
		   try { document.getElementById('menu1').click() } 
		   catch(e) { }		  
	   </script>
   
   </cfif>