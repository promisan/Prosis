
<CFSET Value   =   FieldValue>
<CFSET Operator  = FieldStatus>
<CFSET FileNo  = Attributes.FileNo>
   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_DegSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT Fun.PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_DegSelect
       FROM  ApplicantBackgroundField F, ApplicantSubmission S,
	         userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun
       WHERE S.PersonNo = Fun.PersonNo
	   AND   F.Status IN ('0','1','2')
	   AND   S.ApplicantNo = F.ApplicantNo  
	   <!--- only enabled submission --->
	   AND   S.RecordStatus = '1'
	   AND   F.ExperienceFieldId IN 
	         (SELECT SelectId
        		FROM RosterSearchLine
		        WHERE SearchId = '#Value#' 
        		  AND SearchClass = 'Degree')
   </cfquery>
   
</cfoutput>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>

   <cfoutput>   
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_PrfAll">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		  		   
   SELECT DISTINCT S.PersonNo,
          F.ApplicantNo,
          F.ExperienceFieldId
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_DegAll	
   FROM   ApplicantBackgroundField F, ApplicantSubmission S, 
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun  
   WHERE  Fun.PersonNo = S.PersonNo
    AND   F.Status IN ('0','1','2')
	<!--- only enabled submission --->
    AND   S.RecordStatus = '1'
    AND   S.ApplicantNo = F.ApplicantNo  
	AND   F.ExperienceFieldId IN 
	           (SELECT SelectId 
        		FROM RosterSearchLine  
		        WHERE SearchId = '#Value#' 
        		  AND SearchClass = 'Degree') 
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
      AND  SearchClass = 'Degree'
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
	      FROM   tmp#SESSION.acc#_#fileNo#_DegAll
          WHERE  tmp#SESSION.acc#_#fileNo#_DegAll.ExperienceFieldId = '#Select.SelectId#'
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
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_DegAll">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_DegSelect">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT Distinct #q#.PersonNo
		 INTO   tmp#SESSION.acc#_#fileNo#_DegSelect
         FROM    #From#
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>