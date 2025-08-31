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

<!--- select the defined functions --->

<cfquery name="Select" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'Assessment'
</cfquery>

<!--- application dates --->

<cfquery name="From" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'ApplicationFrom'
</cfquery>

<cfif From.SelectId neq "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#From.SelectId#">
		<cfset AppFrom = dateValue>
</cfif>

<cfquery name="Until" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'ApplicationUntil'
</cfquery>


<cfif Until.SelectId neq "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#Until.SelectId#">
		<cfset AppUntil = dateValue>
</cfif>


<!--- rsoter assessement dates --->

<cfquery name="AFrom" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
        SELECT *
		FROM   RosterSearchLine
		WHERE  SearchId = '#URL.ID#'
		AND    SearchClass = 'AssessmentFrom'
</cfquery>

<cfif AFrom.SelectId neq "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#AFrom.SelectId#">
		<cfset AssFrom = dateValue>
</cfif>

<cfquery name="AUntil" 
       datasource="AppsSelection" 
       username="#SESSION.login#" 
       password="#SESSION.dbpw#">
        SELECT *
		FROM RosterSearchLine
		WHERE SearchId = '#URL.ID#'
		AND SearchClass = 'AssessmentUntil'
</cfquery>

<cfif AUntil.SelectId neq "">
		<cfset dateValue = "">
		<CF_DateConvert Value="#AUntil.SelectId#">
		<cfset AssUntil = dateValue>
</cfif>

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfquery name="Limit" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT   SelectId
   FROM     RosterSearchLine
   WHERE    SearchId    = '#Value#'
   AND      SearchClass = 'VA'
</cfquery>
 
<cfif Operator is "ANY">

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_FunSelect">
    
  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   
	   
       SELECT DISTINCT S.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect
       FROM  ApplicantFunction F, 
	         ApplicantSubmission S
       WHERE S.ApplicantNo = F.ApplicantNo 
	   
	   <cfif limit.selectid neq "">	   
			AND   F.FunctionId = '#limit.selectid#'			  	   
	   <cfelse>	   
	   		AND   F.FunctionId IN 
	            		(SELECT SelectId
		        		 FROM   RosterSearchLine
				         WHERE  SearchId = '#Value#'
        				  AND   SearchClass = 'Function')
				  
		</cfif>		
		
		<cfif From.SelectId neq "" and Until.SelectId neq "">
			AND (FunctionDate >= #AppFrom# and FunctionDate <= #AppUntil#) 
		</cfif>  
		
		<cfif AFrom.SelectId neq "" and AUntil.SelectId neq "">
			AND (StatusDate >= #AssFrom# and StatusDate <= #AssUntil#)  
		</cfif>  
		
		AND EXISTS
		(
			SELECT 'X'
			FROM   RosterSearchLine
			WHERE  SearchId    = '#URL.ID#'
			AND    SearchClass = 'Assessment' 
			AND    SelectId    = F.Status
			AND    (SelectDateEffective <= F.StatusDate  OR SelectDateEffective IS NULL)
			AND    (SelectDateExpiration >= F.StatusDate OR SelectDateExpiration IS NULL)
		)
				  
   </cfquery>
      
   
   <!--- functionId defines submission edition already 
   
   <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT S.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect
       FROM  ApplicantFunction F, ApplicantSubmission S
       WHERE  F.Status IN (#PreserveSingleQuotes(Select.SelectId)#)
	   AND   S.ApplicantNo = F.ApplicantNo
	   AND   S.SubmissionEdition IN (SELECT SelectId
                                	 FROM RosterSearchLine
                                	 WHERE SearchId = #URL.ID#
                                 	 AND SearchClass = 'Edition') 
	   AND   F.FunctionId IN 
	         (SELECT SelectId
        		FROM RosterSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Function')
   </cfquery>
    
   --->
  
<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_FunAll">
      
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		  		   
   SELECT DISTINCT S.PersonNo,
          F.ApplicantNo,F.FunctionId
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunAll	
   FROM   ApplicantFunction F, 
          ApplicantSubmission S 
   WHERE  S.ApplicantNo = F.ApplicantNo
	AND   S.SubmissionEdition IN (SELECT SelectId
                                	 FROM RosterSearchLine
                                	 WHERE SearchId = #URL.ID#
                                 	 AND SearchClass = 'Edition') 
									 
	  <cfif limit.selectid neq "">
	   
			AND   F.FunctionId = '#limit.selectid#'
			  	   
	   <cfelse>
	   
	   		AND   F.FunctionId IN 
		            	(SELECT SelectId
		        		 FROM   RosterSearchLine
				         WHERE  SearchId = '#Value#'
	        			 AND    SearchClass = 'Function')
				  
		</cfif>		
		
		<cfif From.SelectId neq "" and Until.SelectId neq "">
			AND (FunctionDate >= #AppFrom# and FunctionDate <= #AppUntil#) 
		</cfif>  
		
		<cfif AFrom.SelectId neq "" and AUntil.SelectId neq "">
			AND (StatusDate >= #AssFrom# and StatusDate <= #AssUntil#) 
		</cfif>  
		
		AND EXISTS
		(
			SELECT 'X'
			FROM   RosterSearchLine
			WHERE  SearchId = '#URL.ID#'
			AND    SearchClass = 'Assessment' 
			AND    SelectId = F.Status
			AND    (SelectDateEffective <= F.StatusDate OR SelectDateEffective IS NULL)
			AND    (SelectDateExpiration >= F.StatusDate OR SelectDateExpiration IS NULL)
		)		
		
  </cfquery>  
    
    <cfset From  = "">
    <cfset Where = "">
         
    <cfif limit.selectid neq "">
	   
		 <cfquery name = "Select" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT SelectId
		    FROM   RosterSearchLine
		    WHERE  SearchId    = '#Value#'
		      AND  SearchClass = 'VA'
		 </cfquery>      
			  	   
	<cfelse>
	   
   		 <cfquery name = "Select" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT SelectId
		    FROM   RosterSearchLine
		    WHERE  SearchId    = '#Value#'
		      AND  SearchClass = 'Function'
		 </cfquery>      
				  
	</cfif>		
	
	<!--- create subsets --->
			         
    <cfloop query="select">
		
	  <cfset mid = replaceNoCase(SelectId,"-","","ALL")>
			  
      <cfset q = "tmp#SESSION.acc#_#fileNo#_#mid#"> 
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	 	 		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	      SELECT DISTINCT PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#_#fileNo#_FunAll
          WHERE  tmp#SESSION.acc#_#fileNo#_FunAll.FunctionId = '#SelectId#'
	  </cfquery>
	      
	  <cfif From is "">  
    	  <cfset From  = q> 
		  <cfset Whs   = q>
	  <cfelse>
    	  <cfset From  = "#From#,#q#">
          <cfif Where is "">
             <cfset Where = "Where "&#whs#&".PersonNo = "&#q#&".PersonNo">
          <cfelse>
             <cfset Where = #Where#&" AND "&#whs#&".PersonNo = "&#q#&".Person">
          </cfif>		  
	  </cfif>
    
    </cfloop>
  
    <cfoutput>	 
	 
	   <!--- combine subsets --->
		 
	   <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_FunAll">
	   <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_FunSelect">
		 
	   <cfquery name = "ResultFun" 
		    datasource = "AppsQuery" 
		    username   = "#SESSION.login#" 
	        password   = "#SESSION.dbpw#">		
	         SELECT DISTINCT #q#.PersonNo
			 INTO   tmp#SESSION.acc#_#fileNo#_FunSelect
	         FROM   #From#
	         #Where#
	   </cfquery>
	    	 
	   <cfloop query="select">
	   
	   		<cfset mid = replaceNoCase(SelectId,"-","")>			 
		    <cfset q = "tmp#SESSION.acc#_#fileNo#_#mid#">  
		  	<CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
	   </cfloop>
  
   	</cfoutput>

</cfif>

