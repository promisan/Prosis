
<CFSET Value   = Attributes.FieldValue>
<CFSET Operator  = Attributes.FieldStatus>
<CFSET tbl = "SCH">

<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfif #Operator# is "ANY">

<cfoutput>

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">

  <cfquery name="Result" 
   datasource="AppsEmployee" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT PersonNo
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#Select
       FROM  PersonContract P
	   WHERE P.SalarySchedule IN 
	         (SELECT SelectId
        		FROM PersonSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'SalaryGroup')
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
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT PersonNo, SalarySchedule
       INTO  userQuery.dbo.tmp#SESSION.acc##tbl#All
       FROM  PersonContract P
	   WHERE P.SalarySchedule IN 
	         (SELECT SelectId
        		FROM PersonSearchLine
		        WHERE SearchId = '#Value#'
        		  AND SearchClass = 'SalaryGroup'
  
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
   
   </cfoutput>	 
   
   <cfquery name = "Select" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   PersonSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = 'SalaryGroup'
    </cfquery>              
       
      <cfloop query="select">
		   
      <cfoutput>		
      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	 
          SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc##tbl#All
          WHERE  tmp#SESSION.acc##tbl#All.SalarySchedule = '#Select.SelectId#'
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
	 
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#All">
	 <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc##tbl#Select">
	 
     <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		
         SELECT Distinct #q#.PersonNo
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