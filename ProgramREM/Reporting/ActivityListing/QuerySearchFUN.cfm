<!--- Program Funding --->

<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET tbl = "FUN">

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
       FROM  ProgramAllotmentDetail PC, ProgramPeriod P
	   WHERE PC.ProgramCode = P.ProgramCode
	    AND  PC.Period      = P.Period
	     AND PC.Fund IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Funding')
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
   SELECT DISTINCT ProgramId, Fund
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#All
       FROM  ProgramAllotmentDetail PC, ProgramPeriod P
	   WHERE PC.ProgramCode = P.ProgramCode
	   AND   PC.Period      = P.Period
	   AND   PC.Fund IN 
	         (SELECT SelectId
        		FROM ProgramSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'Funding')
  
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
      AND  SearchClass = 'Funding'
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
          WHERE  tmp#SESSION.acc##tbl#All.Fund = '#Select.SelectId#'
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

<!--- IMPORTANT Since program funding is defined on the program component level 
NO need to include the program components here as well --->