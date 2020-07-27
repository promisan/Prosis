
<cfparam name="Attributes.destination1" default="RequisitionViewBuyerOpen.cfm">	
<cfparam name="Attributes.destination2" default="RequisitionViewPOOpen.cfm">	

<cfquery name="Last" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT TOP 1 JobNo
    FROM      UserQuery.dbo.#SESSION.acc#RequisitionSet
	WHERE     JobStatus = 'Active'
	ORDER BY  Created DESC	
</cfquery>

<cfset openReference = "">
<cf_tl id="Procurement Jobs" var="vJob">

	<cf_UItree id="root" title="<span style='font-size:16px;padding-bottom:3px'>#vJob#</span>" expand="Yes">
       
    <cfoutput>
	
	<cf_tl id="Outstanding Jobs" var="vOutstanding">
	
	   <cf_UItreeitem value="Job"
	        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#vOutstanding#</span>"
			parent="root"									
	        expand="Yes">			
			
	</cfoutput>  	   	
	  		
	  <cfquery name="JobType" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT   *
		    FROM     UserQuery.dbo.#SESSION.acc#RequisitionSet
			WHERE    JobStatus = 'Active'
			ORDER BY JobType, Created
		  </cfquery>
	  	  
	  <cfoutput query="JobType" group="JobType">
	  
	  		<cfquery name="Class" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT *
			    FROM   Ref_OrderClass
				WHERE  Code = '#JobType#'			
		  </cfquery>
		  
		  <cf_UItreeitem value="#jobType#_regular"
		        display="<span class='labelit' style='font-size:14px'>#class.description# #jobType#</span>"
				parent="Job"
				target="right" expand="Yes">	
									
			<cfoutput>		
							
				       <cfif caseno neq "">		
					   
					     <cf_UItreeitem value="#jobNo#" id="#JobNo#"
		        display="<span class='labelit' style='font-size:13px;'>#CaseNo#</span>"
				parent="#JobType#_regular"
				href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
				target="right">		   
					 				  
					   <cfelse>
					   
					   <cf_UItreeitem value="#jobNo#" id="#JobNo#"
		        display="<span class='labelit' style='font-size:13px;'>#JobNo#</span>"
				parent="#JobType#_regular"
				href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
				target="right">		  				   
												   
					   </cfif>
					   					 					   
					  <cfif last.jobNo eq jobNo>
						  <cfif caseno neq "">
					  	  	<cfset openReference = CaseNo>
					      <cfelse>
							 <cfset openReference = JobNo>
						  </cfif>
						  <cfset OpenJobNo = JobNo>
					  </cfif>					  
			  	    
			</cfoutput> 
							  
	  </cfoutput>	
	  
<!--- ----------- --->	  
<!--- halted jobs --->
<!--- ----------- --->
  		  
<cfquery name="JobCancel" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT *
    FROM  UserQuery.dbo.#SESSION.acc#RequisitionSet
	WHERE JobStatus = 'Stalled'
	ORDER BY JobType, Created
</cfquery>	  	

<cfif JobCancel.recordcount gte "1"> 		

		<cf_tl id="Stalled Jobs" var="vStalled">
		
	    <cf_UItreeitem value="JobS"
	        display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#vStalled#</span>"
			parent="root"									
	        expand="Yes">					
					
		 <cfoutput query="JobCancel" group="JobType">
	  
	  		<cfquery name="Class" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
				SELECT *
			    FROM   Ref_OrderClass
				WHERE  Code = '#JobType#'			
		    </cfquery>
			
			 <cf_UItreeitem value="#jobType#_stall"
		        display="<span class='labelit' style='font-size:14px'>#class.description# #jobType#</span>"
				parent="JobS"
				target="right" expand="No">	
  										
			<cfoutput>		
						
			    <cfif caseno neq "">		
					   
					  <cf_UItreeitem value="#jobNo#" id="#JobNo#"
		        display="<span class='labelit' style='color:red;font-size:13px'>#CaseNo#</span>"
				parent="#JobType#_stall"
				href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
				target="right">		   
					 				  
				<cfelse>
					   
					  <cf_UItreeitem value="#jobNo#" id="#JobNo#"
		        display="<span class='labelit' style='color:red;font-size:13px'>#JobNo#</span>"
				parent="#JobType#_stall"
				href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
				target="right">		  				   
												   
				</cfif>
						       				   
				<cfif last.jobNo eq jobNo>					  
				 	  <cfset openJobNo = JobNo>					  
				</cfif>		
			  	    
			</cfoutput> 
							  
	  </cfoutput>		 
		
		
</cfif>		 

	   
<!--- -------------- --->	  
<!--- cancelled jobs --->
<!--- -------------- --->	  	
	  
<cfquery name="JobCancel" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT    *
    FROM      UserQuery.dbo.#SESSION.acc#RequisitionSet
	WHERE     JobStatus = 'Cancelled'
	ORDER BY  JobType, Created
</cfquery>	  	

<cfif JobCancel.recordcount gte "1"> 	

	<cf_tl id="Cancelled Jobs" var="vCancelled">
		
	<cf_UItreeitem value="JobC"
	       display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#vCancelled#</span>"
			parent="root"									
	        expand="Yes">		
		
		 <cfoutput query="JobCancel" group="JobType">
	  
	  		<cfquery name="Class" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT *
		    FROM  Ref_OrderClass
			WHERE Code = '#JobType#'			
		  </cfquery>
		  
		   <cf_UItreeitem value="#jobType#_cancel"
		        display="<span class='labelit' style='font-size:14px'>#class.description# #jobType#</span>"
				parent="JobC"
				target="right" expand="no">	  		  
		 								
			<cfoutput>		
									
			<cfif caseno neq "">		
					   
					  <cf_UItreeitem value="#jobNo#" id="#JobNo#"
		        display="<span class='labelit' style='color:red;font-size:13px;'>#CaseNo#</span>"
				parent="#JobType#_cancel"
				href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
				target="right">		   
					 				  
			<cfelse>
					   
					  <cf_UItreeitem value="#jobNo#" id="#JobNo#"
		        display="<span class='labelit' style='color:red;font-size:13px;'>#JobNo#</span>"
				parent="#JobType#_cancel"
				href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
				target="right">		  				   
												   
			</cfif>			
			       				  
			<cfif last.jobNo eq jobNo>					  
			  <cfset openJobNo = JobNo>
			</cfif>					
			  	    
			</cfoutput> 
							  
	  </cfoutput>		 
		
		
</cfif>		
		  
<cfquery name="PO" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT  DISTINCT PurchaseNo
      FROM    UserQuery.dbo.#SESSION.acc#PurchaseSet P	 
      WHERE   ActionStatus = '0'
	  <!--- hide headers that do not have a line anymore --->
	  AND     EXISTS (SELECT PurchaseNo FROM Purchase.dbo.PurchaseLine WHERE PurchaseNo = P.PurchaseNo)
</cfquery>
		 
<cfif PO.recordcount gte "1"> 

	<cf_tl id="Pending Purchase" var="vPen">
	
	<cf_UItreeitem value="JobP"
	       display="<span class='labelit' style='padding-bottom:4px;padding-top:4px;font-size:17px;font-weight:bold'>#vPen#</span>"
			parent="root"									
	        expand="Yes">	
												
		  <cfoutput query="PO">
		  
		  	  <cf_UItreeitem 
			    value        = "#PurchaseNo#"
		        display      = "<span class='labelit' style='font-size:13px'>#PurchaseNo#</span>"
				parent       = "JobP"
				href         = "../../Requisition/RequisitionView/#Attributes.destination2#?ID=PO&ID1=#PurchaseNo#"
				target       = "right">	  
		  
		  </cfoutput> 	  
	  
</cfif>		 
	 
</cf_UItree>

<cfparam name="openJobNo" default="">

<cfoutput>

  <script>
	<cfset AjaxOnLoad("function(){ProsisUI.doOpenTree('root','#openReference#');}")>
     ptoken.open("#Attributes.destination1#?ID=JOB&ID1=#OpenJobNo#&ID2=#Period#","right")
  </script>
  
</cfoutput>  

