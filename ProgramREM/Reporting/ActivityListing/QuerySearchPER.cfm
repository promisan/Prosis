<!--- Program Period --->

<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET tbl = "PER">

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
       FROM  ProgramPeriod P
	   WHERE P.Period IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Period')
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
   SELECT DISTINCT ProgramId, Period 
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#All
       FROM  ProgramPeriod P
	   WHERE P.Period IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Period')
  
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
      AND  SearchClass = 'Period'
    </cfquery>          
       
	  <cfset cnt = 1> 
      <cfloop query="select">
		   
      <cfoutput>		
      <cfset q = "tmp"&#SESSION.acc#&#cnt#>
	  <cfset cnt = #cnt#+1> 
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	      SELECT Distinct ProgramId
		  INTO   #q#
	      FROM   tmp#SESSION.acc##tbl#All
          WHERE  tmp#SESSION.acc##tbl#All.Period = '#Select.SelectId#'
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
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">
	 
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

<!--- IMPORTANT Since program periods are defined on the program + program component level 
NO need to include the program components here as well --->