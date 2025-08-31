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
<CFSET FileNo  = Attributes.FileNo>

   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfquery name="Level" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
  SELECT SelectId
  FROM   RosterSearchLine
  WHERE  SearchId = '#Value#'
   AND   SearchClass = 'LanguageLevel'
</cfquery>

<cfif Operator is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_LanSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT Fun.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_LanSelect
       FROM  ApplicantLanguage L, 
	         ApplicantSubmission S, 
	         userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun
	   WHERE Fun.PersonNo = S.PersonNo
       AND   L.Status IN ('0','1','2')
	   <!--- only enabled submission --->
	   AND   S.RecordStatus = '1'
	   AND   S.ApplicantNo = L.ApplicantNo  
	   <cfif Level.SelectId eq "1">
	  	 AND   L.Levelread       = '1'
		 AND   L.LevelWrite      = '1'
	   	 AND   L.LevelSpeak      = '1'
	     AND   L.LevelUnderstand = '1' 
	   </cfif>
	   AND   L.LanguageId IN 
			         (SELECT SelectId
        				FROM RosterSearchLine
		        		WHERE SearchId = '#Value#'
		        		  AND SearchClass = 'Language')
   </cfquery>
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_LanAll">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">		  		   
   SELECT DISTINCT S.PersonNo,
          L.ApplicantNo,
          L.LanguageId
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_LanAll	
   FROM   ApplicantLanguage L, ApplicantSubmission S,  
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun 
   WHERE  Fun.PersonNo = S.PersonNo
    AND   S.ApplicantNo = L.ApplicantNo  
	AND   L.LanguageId IN 
	           (SELECT SelectId
        		FROM RosterSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Language')
	AND   L.Status IN ('0','1','2')		
	<!--- only enabled submission --->
	AND   S.RecordStatus = '1'	  
	<cfif Level.SelectId eq "1">
  	AND   L.Levelread       = '1'
	AND   L.LevelWrite      = '1'
   	AND   L.LevelSpeak      = '1'
    AND   L.LevelUnderstand = '1'  
	</cfif>
	
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   RosterSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = 'Language'
    </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>		
	
      <cfset q = "tmp#SESSION.acc#_#fileNo#_#Select.SelectId#">
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	 
          SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#_#fileNo#_LanAll
          WHERE  tmp#SESSION.acc#_#fileNo#_LanAll.LanguageId = '#Select.SelectId#'
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif #From# is "">  
    	  <cfset From  = #q#> 
		  <cfset Whs   = #q#>
	 <cfelse>
    	  <cfset From  = #From#&","&#q#>
          <cfif #Where# is "">
             <cfset Where = "Where "&#whs#&".PersonNo = "&#q#&".PersonNo">
          <cfelse>
             <cfset Where = #Where#&" AND "&#whs#&".PersonNo = "&#q#&".PersonNo">
          </cfif>		  
	 </cfif>
     </cfoutput>
     </cfloop>
  
     <cfoutput>	 
	 
	 <!--- combine subsets --->
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_LanAll">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_LanSelect">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT Distinct #q#.PersonNo
		 INTO   tmp#SESSION.acc#_#fileNo#_LanSelect
         FROM    #From#
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>