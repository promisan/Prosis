 
 
<cfparam name="Attributes.destination1" default="RequisitionViewBuyerOpen.cfm">	
<cfparam name="Attributes.destination2" default="RequisitionViewPOOpen.cfm">	

<cfoutput>

  ['Outstanding','null',   	
	  		
	  <cfquery name="JobType" 
	  datasource="AppsPurchase" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT DISTINCT JobType 
	    FROM  UserQuery.dbo.#SESSION.acc#RequisitionSet
		WHERE JobStatus = 'Active'
	  </cfquery>
	  	  
	  <cfloop query="JobType">
  
		  <cfset Job = JobType.JobType>
						  
			['#Job#', null,
			
			<cfquery name="Job" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   SELECT * 
			   FROM   UserQuery.dbo.#SESSION.acc#RequisitionSet
			   WHERE  JobStatus = 'Active'
			   AND    JobType = '#Job#'
			   ORDER BY Created DESC
			 </cfquery>
			
			  <cfloop query="Job">
			       <cfif caseno neq "">
				    ['#CaseNo#','#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#'],
				   <cfelse>
				    ['#JobNo#','#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#'],
				   </cfif>
			  	    
			  </cfloop> 
			  			  
			 ],
				  
	  </cfloop>	
		  
     ['Prepared Purchase',null, 

	 <cfquery name="PO" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT DISTINCT PurchaseNo
	     FROM  UserQuery.dbo.#SESSION.acc#PurchaseSet
	     WHERE ActionStatus = '0'
	 </cfquery>
					
	  <cfloop query="PO">
	  	    ['#PurchaseNo#','#Attributes.destination2#?ID=PO&ID1=#PurchaseNo#'],
	  </cfloop> 
	  
	  <!---

		<cfquery name="StatusPO" 
		    datasource="AppsPurchase" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT DISTINCT Description, ActionStatus 
		    FROM  UserQuery.dbo.#SESSION.acc#PurchaseSet 
			ORDER BY ActionStatus 
		</cfquery>
		   
		  <cfloop query="StatusPO">
		  
		  <cfset #Description# = #StatusPO.Description#>
		         
			    ['#Description#',null,
				
					<cfquery name="PO" 
					 datasource="AppsPurchase" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					 SELECT DISTINCT PurchaseNo
			         FROM  UserQuery.dbo.#SESSION.acc#PurchaseSet
				     WHERE Description = '#Description#'
					 AND StatusAction = '1'
					 </cfquery>
							
					  <cfloop query="PO">
					  	    ['#PurchaseNo#','#Attributes.destination2#?ID=PO&ID1=#PurchaseNo#'],
					  </cfloop> 
								
				 ],
				 
					   		 
		  </cfloop> 	
		  
		 --->
      
	],

]

</cfoutput>








