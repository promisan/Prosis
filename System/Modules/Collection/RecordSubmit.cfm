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

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Collection
		WHERE  CollectionName     = '#Form.CollectionName#'
		AND    ApplicationServer = '#Form.ApplicationServer#'	
	</cfquery>

    <cfif Verify.recordCount is 1>
   
	   <script language="JavaScript">
	   
	     alert("A collection with this name has been registered already for this server!")
	     
	   </script>  
  
   <cfelse>
  
   		<cf_AssignId>
					     		
		<cfquery name="Insert" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO Collection
			         (CollectionId,
					 CollectionName,
					 SearchEngine,
					 SystemModule,
					 ApplicationServer,
					 Mission,
					 Extensions,
					 CollectionPath,
					 IndexDataTemplate,
					 <cfif Form.IndexAttachmentLimit neq "">
					 IndexAttachmentLimit,
					 </cfif>
					 CollectionTemplate,
					 LanguageCode,
					 CollectionCategories, 
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#rowguid#',
			  		  '#Form.CollectionName#', 
			  		  '#Form.SearchEngine#',
			  		  '#Form.SystemModule#',
					  '#Form.ApplicationServer#', 
					  <cfif Form.Mission neq 'ALL'>
			  		  	'#Form.Mission#', 
					  <cfelse>
					  	NULL,
					  </cfif>
			  		  '#Form.Extensions#',
			          '#Form.CollectionPath#',					 	  
			  		  '#Form.IndexDataTemplate#',
					  <cfif Form.IndexAttachmentLimit neq "">
					  '#Form.IndexAttachmentLimit#',
					  </cfif>
			  		  '#Form.CollectionTemplate#',
  	  				  '#Form.LngCode#',
					  '#Form.CollectionCategories#',
			   	      '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				      '#SESSION.first#')
		 </cfquery>
		  
		 <!--- Creates the CollecitonFolder records associated to the colleciton --->
		 
		 <cfif Form.DocumentPathName neq ''>
		 
			  <cfloop index="itm" list="#Form.DocumentPathName#">
			  	 	   		
					<cfquery name="CollectionFolderInsert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">							
						INSERT INTO CollectionFolder 
							(CollectionId,DocumentPathName)
						VALUES
							('#rowguid#','#itm#')							
					</cfquery>
			   </cfloop>
			   
		 </cfif>
		  			  
		 <cfquery name="Param" 
			  datasource="AppsInit">
				SELECT * 
				FROM Parameter
				WHERE HostName = '#CGI.HTTP_HOST#' 
		 </cfquery>
		  
		 <cfif param.applicationserver eq form.applicationserver>
		 
		     <cfif form.collectioncategories eq "1">
				  <cfset cat = "yes">
			 <cfelse>
				  <cfset cat = "no"> 
			 </cfif>
		  
			 <!--- Creates the collection in ColdFusion if the application server is the requested server --->
			 <cfcollection action="create" 
		       engine     =  "#Form.SearchEngine#"
			   path       =  "#Form.CollectionPath#"
			   categories =  "#cat#"
		       collection =  "#Form.CollectionName#">
		   
		 </cfif>
			  
		  
	</cfif>	  

</cfif>

<cfif ParameterExists(Form.Update)> 
	    
	<cfif Form.IndexTimeStamp neq ''>
	    <CF_DateConvert Value="#Form.IndexTimeStamp#">
		<cfset TS = dateValue>
	<cfelse>
	    <cfset TS = 'NULL'>
	</cfif>	
	
	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Collection
		SET 									
			<cfif Form.Mission neq 'ALL'>
			Mission		  		 =   '#Form.Mission#', 
 		    </cfif>
			Extensions 		  	 = '#Form.Extensions#',					  
			IndexDataTemplate 	 = '#Form.IndexDataTemplate#',
			<cfif Form.IndexAttachmentLimit neq "">
			IndexAttachmentLimit = '#Form.IndexAttachmentLimit#',
			</cfif>
			CollectionTemplate	 = '#Form.CollectionTemplate#',
  	  		LanguageCode 	  	 = '#Form.LngCode#',
			CollectionCategories =  '#Form.Categories#',
			IndexTimeStamp	  	 =  #ts#, 
 		    OfficerUserId 	  	 = '#SESSION.acc#',
			OfficerLastName   	 = '#SESSION.last#',		  
			OfficerFirstName  	 = '#SESSION.first#',
			Created			  	 = getDate()
		WHERE CollectionId 		 = '#url.CollectionId#'
	</cfquery>
	
	 <!--- Creates the CollecitonFolder records associated to the colleciton --->
	  <cfif Form.DocumentPathName neq ''>
	  
	  	  <cfquery name="CollectionFolderInsert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				
				DELETE from CollectionFolder
				WHERE CollectionId = '#url.CollectionId#'
				
		  </cfquery>
	  
		  <cfloop index="itm" list="#Form.DocumentPathName#">
		  	 	   		
				<cfquery name="CollectionFolderInsert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					INSERT INTO CollectionFolder 
						(CollectionId,
						 DocumentPathName,
						 Created)
					VALUES
						('#url.CollectionId#',
						 '#itm#',
						 getDate())
					
				</cfquery>
		   </cfloop>
	  </cfif>
	
	<!--- sync the associated schedule --->
	
	<cfquery name="UpdateSchedule" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Schedule
		SET   ScheduleTemplate  =  '#Form.IndexDataTemplate#'			
		WHERE CollectionId = '#url.CollectionId#'
	</cfquery>
	
</cfif>

<cfif ParameterExists(Form.Delete)> 


	<!--- remove the schedule associated to the collection --->
	<cfquery name="DeleteSchedule" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			DELETE FROM Schedule
			WHERE CollectionId = '#url.collectionid#'
	</cfquery>		
	
	
    <!--- remove the collection --->
	
	<cfquery name="Delete" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Collection
			WHERE CollectionId = '#url.collectionid#'
	</cfquery>		
	
	<!--- remove the collection from the server itself --->
	
	<cftry>	
	<cfcollection action="delete" 	      
	       collection="#Form.CollectionName#" >
		   <cfcatch></cfcatch>
	</cftry>	   
		   
	<!--- remove the menu --->	   
		   
	<cfquery name="DeleteMenu" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_ModuleControl
			WHERE FunctionName = 'Collection #form.collectionname#'
			AND MenuClass = 'Collection'
	</cfquery>			   
	
</cfif>	
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  