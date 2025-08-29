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
<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET tbl = "CAT">

<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">

  <cfquery name="Result" 
   datasource="AppsProgram" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT ProgramId
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#Select
       FROM  ProgramCategory PC, ProgramPeriod P
	   WHERE PC.ProgramCode = P.ProgramCode
	     AND PC.ProgramCategory IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Category')
   </cfquery>
   
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#All">
   
  <cfquery name = "All" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT ProgramId, ProgramCategory
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#All
       FROM  ProgramCategory PC, ProgramPeriod P
	   WHERE PC.ProgramCode = P.ProgramCode
	   AND   PC.ProgramCategory IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Category')
  
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   ProgramSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = 'Category'
    </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>		
      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	 
          SELECT Distinct ProgramId
		  INTO   #q#
	      FROM   tmp#SESSION.acc##tbl#All
          WHERE  tmp#SESSION.acc##tbl#All.ProgramCategory = '#Select.SelectId#'
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif #From# is "">  
    	  <cfset From  = #q#> 
		  <cfset Whs   = #q#>
	 <cfelse>
    	  <cfset From  = #From#&","&#q#>
          <cfif #Where# is "">
             <cfset Where = "Where "&#whs#&".ProgramId = "&#q#&".ProgramId">
          <cfelse>
             <cfset Where = #Where#&" AND "&#whs#&".ProgramId = "&#q#&".ProgramId">
          </cfif>		  
	 </cfif>
     </cfoutput>
     </cfloop>
  
     <cfoutput>	 
	 
	 <!--- combine subsets --->
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#All">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#SelectA">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT Distinct #q#.ProgramId
		 INTO   tmp#SESSION.acc##tbl#Select
         FROM    #From# 
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>

<!--- IMPORTANT Since program categories are defined on the program parent level 
we DO NEED to include the program components here as well : inherit --->

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Cpt">

<!--- disabled hanno 22/04/05 
<!--- component level 1 --->

<cfquery name = "Component" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO userQuery.dbo.tmp#SESSION.acc##tbl#SelectA
   (ProgramId)
   SELECT DISTINCT Pce.ProgramId
       FROM  userQuery.dbo.tmp#SESSION.acc##tbl#SelectA S, ProgramPeriod Pe, Program P, ProgramPeriod Pce
	   WHERE S.ProgramId = Pe.ProgramId
	   AND  Pe.ProgramCode = P.ParentCode 
	   AND  P.ProgramCode = Pce.ProgramCode
  </cfquery>  
  
  <!--- include component level 2 --->
  
  <cfquery name = "Component" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   INSERT INTO userQuery.dbo.tmp#SESSION.acc##tbl#SelectA
   (ProgramId)
   SELECT DISTINCT Pce.ProgramId
       FROM  userQuery.dbo.tmp#SESSION.acc##tbl#SelectA S, ProgramPeriod Pe, Program P, ProgramPeriod Pce
	   WHERE S.ProgramId = Pe.ProgramId
	   AND  Pe.ProgramCode = P.ParentCode 
	   AND  P.ProgramCode = Pce.ProgramCode
  </cfquery>  
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">
   
  <!--- only unique entries level 2 --->
  
  <cfquery name = "Final" 
   datasource="AppsProgram" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT ProgramId
   INTO userQuery.dbo.tmp#SESSION.acc##tbl#Select
   FROM userQuery.dbo.tmp#SESSION.acc##tbl#SelectA
   </cfquery>
   
   <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#SelectA">
   
   --->
  
