

<!--- create --->


<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

	SELECT  *
    FROM    Applicant
	WHERE   PersonNo = '#url.personNo#'	
</cfquery>
	
<cfif get.recordcount eq "1"> 
			  
   <cfquery name="InsertSubmission" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  	   INSERT INTO WorkOrder.dbo.Customer
	       	(PersonNo,
		 	Mission,
			Reference,
	  	 	CustomerName, 					 		 	
		 	eMailAddress,					 	
		 	OfficerUserId,
		 	OfficerLastName,
		 	OfficerFirstName,	
		 	Created)
      	VALUES ('#get.PersonNo#',
	       	'#url.Mission#', 
			'#get.IndexNo#',
           	'#get.firstname# #get.middlename# #get.lastname# #get.lastname2#',				  		  	
		  	'#get.eMailAddress#',						
		  	'#SESSION.acc#',
    	  	'#SESSION.last#',		  
	  	  	'#SESSION.first#',
		  	getDate())
  </cfquery>
  
  <cfoutput>
   <img src="#session.root#/images/checkmark.png" alt="" border="0">
  </cfoutput>
  
</cfif>	   
		