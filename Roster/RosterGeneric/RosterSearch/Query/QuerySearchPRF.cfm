
<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET FileNo  = Attributes.FileNo>
   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_PrfSelect">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_PrfSelect
       FROM  ApplicantBackgroundField, ApplicantSubmission S 
       WHERE ApplicantBackgroundField.Status IN ('0','1','2')
	   <!--- only enabled submission --->
	   AND   S.RecordStatus = '1'
	   AND   S.ApplicantNo = ApplicantBackgroundField.ApplicantNo  
	   AND   ApplicantBackgroundField.ExperienceFieldId IN 
	         (SELECT SelectId
        		FROM RosterSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Profession')
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
		  		   
   SELECT DISTINCT S.PersonNo
          ApplicantBackgroundField.ApplicantNo,
          ApplicantBackgroundField.ExperienceFieldId
   INTO	  userQuery.dbo.tmp#SESSION.acc#_#fileNo#_PrfAll	
   FROM   ApplicantBackgroundField, ApplicantSubmission S  
   WHERE  ApplicantBackgroundField.Status IN ('0','1','2')
   <!--- only enabled submission --->
    AND   S.RecordStatus = '1'
    AND   S.ApplicantNo = ApplicantBackgroundField.ApplicantNo  
	AND   ApplicantBackgroundField.ExperienceFieldId IN 
	           (SELECT SelectId
        		FROM RosterSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Profession')
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
      AND  SearchClass = 'Profession'
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
	      FROM   tmp#SESSION.acc#_#fileNo#_PrfAll
          WHERE  tmp#SESSION.acc#_#fileNo#_PrfAll.ExperienceFieldId = '#Select.SelectId#'
	  </cfquery>
      </cfoutput>
	   
     <cfoutput>    
	 <cfif From is "">  
    	  <cfset From  = q> 
		  <cfset Whs   = q>
	 <cfelse>
    	  <cfset From  = "#From#,#q#">
          <cfif Where is "">
             <cfset Where = "WHERE #whs#.PersonNo = #q#.PersonNo">
          <cfelse>
             <cfset Where = "#Where# AND #whs#.PersonNo = #q#.PersonNo">
          </cfif>		  
	 </cfif>
     </cfoutput>
     </cfloop>
  
     <cfoutput>	 
	 
	 <!--- combine subsets --->
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_PrfAll">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_PrfSelect">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">		
         SELECT Distinct #q#.PersonNo
		 INTO   tmp#SESSION.acc#_#fileNo#_PrfSelect
         FROM    #From#
         #Where#
	 </cfquery>
    	 
      <cfloop query="select">
		 
	      <cfset q = "tmp#SESSION.acc#_#fileNo#_#Select.SelectId#">  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
      </cfloop>
  
   	  </cfoutput>
</cfif>