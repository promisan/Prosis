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

<!--- this is a custom template which is linked --->
<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Collection
	WHERE    CollectionId = '#url.collectionid#' 
</cfquery>

<!--- get the time as the process starts --->
<cfset timestamp = now()>

<!--- retrieve the info for the collection from the server --->
<cfcollection action="LIST" name="serverCollection" engine="#collection.searchengine#">

<cfquery name="Exist" dbtype="query">
   	   SELECT   *
	   FROM     serverCollection
	   WHERE    Name = '#lcase(collection.collectionname)#'		   
</cfquery>			

<!--- full clean collection 
  <cfindex action="PURGE" collection="#collection.collectionname#"> 
--->

<!--- Get documents already indexed ---->
<cfsearch 
    collection = "#Collection.CollectionName#" 
	name       = "CollectionQuery" 
	category   = "Document" 
	criteria   = "">

<cfset FileNo 	 = round(Rand()*1000)>
<cfset Answer1   = "tCollection_#SESSION.acc#_#FileNo#">
<cf_dropTable 	 dbName="AppsQuery" tblName="#Answer1#">
<cfquery name="CreateAnswer" datasource="AppsQuery">
	CREATE TABLE userQuery.dbo.#Answer1# ( Id uniqueidentifier not null)
</cfquery>
<!---

<!--- Temporary store all the AttachmentId already indexed --->
<cfloop query="CollectionQuery">
	<cfif Title eq 'Documents'>
		<cfquery name="Insert" datasource="AppsQuery">
			INSERT INTO userQuery.dbo.#Answer1# (Id) values ('#Custom1#')
		</cfquery>
	</cfif>
</cfloop>


<!--- reload attached documents --->

<cfquery name="Folder" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     CollectionFolder
WHERE    CollectionId = '#url.collectionid#' 
</cfquery>

<cfloop query="Folder">  	

	<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Path: #documentPathName#: init">			
	
	<cfquery name="Document" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
		SELECT   
		<cfif Collection.IndexAttachmentLimit neq "">
		TOP #Collection.IndexAttachmentLimit# 
		</cfif>
		A.*
		FROM     Attachment A
		WHERE    DocumentPathName = '#documentPathName#' 	
		AND		 
		(
			AttachmentId NOT IN
					(
						SELECT AttachmentId
						FROM   UserQuery.dbo.#Answer1#
					)				  	
			
					
		    <cfif collection.indextimestamp neq "">
	
			OR      AttachmentId IN (SELECT  AttachmentId 
		                          FROM    AttachmentLog 
								  WHERE   AttachmentId = A.AttachmentId
								  AND     Created > '#collection.indextimestamp#'
								  AND     FileAction != 'Open')
        	</cfif>	
		)
		AND      FileStatus != '9'
		ORDER BY Created
		
	</cfquery>	

	
	<!--- insert new or updated documents --->	
		
	<cfloop query="Document">
		   		
		<cfif server eq "document">
		    <cfset svr = SESSION.rootdocumentpath>
		<cfelse>
			<cfset svr = server>
		</cfif>
		
		<cfindex action = "UPDATE"
		    collection  = "#collection.collectionname#" 
			key         = "#svr#\#serverpath#\#filename#" 
			type        = "FILE"
			title       = "Documents" 
			extensions  = "'#collection.extensions#'" 			
			category    = "Document"
			custom1     = "#attachmentid#"	
			custom2     = "#dateformat(now(),'YYYYMMDD')#"		
			language    = "English"> 
		
	</cfloop>	
			
	<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "Path: #documentPathName#: #document.recordcount#">		
			
	<!--- purging old documents with status = 9 --->		
	
	<cfinclude template="CleanCollectionFiles.cfm">
		
</cfloop>	

--->

<!--- --------------- --->
<!--- reload elements --->
<!--- --------------- --->

<cfquery name="Element" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   DISTINCT TabElementClass
	FROM     Ref_ClaimTypeTab
	WHERE    1 = 1
	<cfif collection.mission neq "">
	AND      Mission = '#Collection.mission#' 
	</cfif>
	AND      TabElementClass IS NOT NULL 	
</cfquery>		 
	
<cfoutput query = "Element">

	<cf_ScheduleLogInsert
	   	ScheduleRunId  = "#schedulelogid#"
		Description    = "#tabelementclass#: init">	
		
	<cfquery name="TopicList" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 SELECT   R.*
		     FROM     Ref_Topic R INNER JOIN Ref_TopicElementClass S ON R.Code = S.Code
			 WHERE    ElementClass = '#tabelementclass#'	
			 AND      Operational = 1
			 <cfif collection.mission neq "">
			 	AND      (Mission = '#Collection.Mission#' or Mission is NULL)		
			 </cfif>
			 ORDER BY S.ListingOrder,R.ListingOrder 
	</cfquery>
	
	<cfset body = "">	
	
	<cfquery name="get_element" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT  CE.CaseElementId,
		        E.ElementId,
		        E.Reference,  
				E.ElementMemo,  
				
				<cfif tabelementclass eq "Person">
				
				    A.PersonNo,
					A.IndexNo,
					A.LastName,
					A.LastName2,
					A.FirstName,
					A.MiddleName,
					A.DOB,
					A.Gender,		
				
				</cfif>
								
				<cfloop query="TopicList">			
					<cfset fld = replace(description," ","","ALL")>
					<cfset fld = replace(fld,".","","ALL")>
					<cfset fld = replace(fld,",","","ALL")>
					
						(SELECT TopicValue 
						 FROM   ElementTopic 
						 WHERE  ElementId = E.ElementId 
						 AND    Topic = '#code#') as #fld#,						
				</cfloop>		
				
			    CE.Created					
				
		FROM    Element E 
		        INNER JOIN ClaimElement CE ON E.ElementId = CE.ElementId
				<cfif tabelementclass eq "Person">
				LEFT OUTER JOIN Applicant.dbo.Applicant A ON E.PersonNo = A.PersonNo
				</cfif>
	    WHERE   E.ElementClass = '#tabelementclass#'	
		
		<cfif collection.indextimestamp neq "">
		
		<!--- only changed or created elements --->
	
		AND     (
		
		         E.ElementId IN (
				               SELECT TOP 1 ElementId 
		                       FROM         ElementTopicLog 
							   WHERE        ElementId = E.ElementId
							   AND          Created > '#collection.indextimestamp#'
							   ORDER BY     Created DESC
							   )
								  
				OR 
				
				E.Created > '#collection.indextimestamp#'
				
				)
								  
	    </cfif>			
				
	</cfquery>			
			
			
	<cfloop query="TopicList">			
		<cfset fld = replace(description," ","","ALL")>
		<cfset fld = replace(fld,".","","ALL")>
		<cfset fld = replace(fld,",","","ALL")>
		<cfif body eq "">
		  <cfset body = "#fld#">	
		<cfelse>
		  <cfset body = "#body#,#fld#">	
		</cfif>			
	</cfloop>	
	
	<cfif tabelementclass eq "Person">		
	    <!--- add additional fields --->
		<cfset body = "Reference,ElementMemo,#body#,IndexNo,LastName,LastName2,FirstName,MiddleName,DOB,Gender">			
	<cfelse>
		<cfset body = "Reference,ElementMemo,#body#">	
	</cfif>	
				
	<cfif get_element.recordcount gt "0">			
			
		 <!---   <cftry> --->
			
			<cfif Collection.Collectioncategories eq "1">
			
				<cfindex action="UPDATE" 
				   collection = "#Collection.CollectionName#" 
				   key        = "ElementId" 
				   type       = "CUSTOM" 
				   title      = "reference" 
				   query      = "get_element" 
				   body       = "#body#" 
				   category   = "#tabelementclass#"
				   custom1    = "#tabelementclass#" 
				   custom2    = "#dateformat(now(),'YYYYMMDD')#"> 
				   
		   <cfelse>
			   
				<cfindex action="UPDATE" 
				   collection = "#Collection.CollectionName#" 
				   key        = "ElementId" 
				   type       = "CUSTOM" 
				   title      = "reference" 
				   query      = "get_element" 
				   body       = "#body#" 		  
				   custom1    = "#tabelementclass#" 
				   custom2    = "#dateformat(now(),'YYYYMMDD')#"> 		   
			   
		   </cfif>
			   
			   <!---
			   <cfcatch>
			   failed(#tabelementclass#)
			   </cfcatch>
			   
			 </cftry>  --->
		   
	</cfif>  
			
	<cf_ScheduleLogInsert
		   	ScheduleRunId  = "#schedulelogid#"
			Description    = "#tabelementclass#: #get_element.recordcount#">	
			
</cfoutput> 	   
	
<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE     Collection
	SET        IndexTimestamp = #timestamp#
	WHERE      CollectionId = '#url.collectionid#' 
</cfquery>
	
