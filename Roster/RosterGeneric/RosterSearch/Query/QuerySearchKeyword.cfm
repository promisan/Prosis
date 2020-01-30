
<CFSET Value     = FieldValue>
<CFSET Operator  = FieldStatus>
   
<!--- to retrieve only certain status --->	   

<!--- ---- --->
<!--- -OR- --->
<!--- ---- --->

<cfquery name="getClass" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	   SELECT * 
	   FROM   Ref_ExperienceParent
	   WHERE  Parent = '#class#'
</cfquery> 

<cfif Operator is "ANY">

  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#PAR#Select">

  <cfquery name="Result" 
   datasource="AppsSelection" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT DISTINCT Fun.PersonNo
       INTO   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_#PAR#Select
       FROM   skApplicantKeyWord K,
	          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun
       WHERE  K.PersonNo = Fun.PersonNo
	   <!--- --------------------------------------------------------------------- --->
	   <!--- Hanno  22/5/2013 added to search within the scope of the search owner --->
	   <!--- --------------------------------------------------------------------- --->
	   <cfif RosterSearch.Owner neq "" and Owner.SelectId eq "1">
	   	AND    K.Owner = '#RosterSearch.Owner#'  
	   <cfelse>
	    AND    K.Owner = 'ANY'
	   </cfif>	   
	 
	   AND   K.FieldId IN 
		         (SELECT  SelectId
    	    		FROM  RosterSearchLine
			        WHERE SearchId    = '#Value#' 
        			  AND SearchClass = '#Class#') 		
					  
		<cfif getClass.PeriodEnable eq "1">
		
		 <!--- --------------------------------------------------------------------- --->
	     <!--- tuned to take into consideration the mininum duration --------------- --->
	     <!--- --------------------------------------------------------------------- --->   
		
		 AND   K.Period >=  
		         (SELECT  ISNULL(SelectParameter,0)
    	    		FROM  RosterSearchLine
			        WHERE SearchId    = '#Value#' 
        			  AND SearchClass = '#Class#'
					  AND Selectid    = K.FieldId) 
		
		</cfif>		
		
		  
   </cfquery>

<!--- ---- --->
<!--- AND- --->
<!--- ---- --->

<cfelse>
      
  <!--- all valid potential combinations to be used for querying--->
  
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#PAR#All">
   
  <cfquery name = "All" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT DISTINCT K.PersonNo, K.FieldId
   INTO   userQuery.dbo.tmp#SESSION.acc#_#fileNo#_#PAR#All
   FROM   skApplicantKeyWord K, 
          userQuery.dbo.tmp#SESSION.acc#_#fileNo#_FunSelect Fun  
   WHERE  Fun.PersonNo = K.PersonNo
   <!--- Hanno  22/5/2013 added to search within the scope of the search owner --->
   <cfif RosterSearch.Owner neq "" and Owner.SelectId eq "1">
   	AND   K.Owner = '#RosterSearch.Owner#' 
   <cfelse>
    AND   K.Owner = 'ANY'
   </cfif>
   <!--- --------------------------------------------------------------------- --->   
	AND   K.FieldId IN 
	           (SELECT SelectId 
        		FROM   RosterSearchLine  
		        WHERE  SearchId    = '#Value#' 
        		  AND  SearchClass = '#Class#') 
				  
	<cfif getClass.PeriodEnable eq "1">
		
		 <!--- --------------------------------------------------------------------- --->
	     <!--- tuned to take into consideration the mininum duration --------------- --->
	     <!--- --------------------------------------------------------------------- --->   
		
		 AND   K.Period >=  
		         (SELECT  ISNULL(SelectParameter,0)
    	    		FROM  RosterSearchLine
			        WHERE SearchId    = '#Value#' 
        			  AND SearchClass = '#Class#'
					  AND Selectid    = K.FieldId) 
		
		</cfif>					  
  </cfquery>  

  <cfset From  = "">
  <cfset Where = "">
      
  <cfquery name = "Select" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	SELECT SelectId
    FROM   RosterSearchLine
    WHERE  SearchId = '#Value#'
      AND  SearchClass = '#Class#'
  </cfquery>              
       
  <cfloop query="select">		   
     
      <cfset q = "tmp#SESSION.acc#_#fileNo#_#Select.SelectId#">
	  
	  <!--- create subsets --->
	  
	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
		  
      <cfquery name="#q#" datasource="AppsQuery" 
	     username="#SESSION.login#" 
         password="#SESSION.dbpw#">
	      SELECT Distinct PersonNo
		  INTO   #q#
	      FROM   tmp#SESSION.acc#_#fileNo#_#PAR#All
          WHERE  tmp#SESSION.acc#_#fileNo#_#PAR#All.FieldId = '#Select.SelectId#'
	  </cfquery>
   	  	 
		 <cfif From is "">  
	    	  <cfset From  = q> 
			  <cfset Whs   = q>
		 <cfelse>
	    	  <cfset From  = #From#&","&#q#>
	          <cfif Where is "">
	             <cfset Where = "Where "&#whs#&".PersonNo = "&#q#&".PersonNo">
	          <cfelse>
	             <cfset Where = #Where#&" AND "&#whs#&".PersonNo = "&#q#&".PersonNo">
	          </cfif>		  
		 </cfif>
		 
  </cfloop>
  	 
  <!--- combine subsets --->
	 
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#PAR#All">
  <CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#_#fileNo#_#PAR#Select">
	 
  <cfquery name="Result" datasource="AppsQuery" 
	    username="#SESSION.login#" 
       password="#SESSION.dbpw#">
	     SELECT  DISTINCT #q#.PersonNo
		 INTO    tmp#SESSION.acc#_#fileNo#_#PAR#Select
         FROM    #From#
         #WHERE# 
  </cfquery>
    	 
  <cfloop query="select">
		 
	      <cfset q = "tmp"&#SESSION.acc#&#Select.SelectId#>  
	  	  <CF_DropTable dbName="AppsQuery" tblName="#q#">
	  
  </cfloop>
  	  
</cfif>