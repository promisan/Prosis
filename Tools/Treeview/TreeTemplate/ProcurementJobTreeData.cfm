
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
    
<cftree name="root"
   font="calibri"
   fontsize="13"		
   bold="No"   
   format="html"    
   required="No">  
   
    <cfoutput>
	
	<cf_tl id="Outstanding Jobs" var="vOutstanding">
		
	<cftreeitem value="Job"
        display="<span style='padding-bottom:4px' class='labelmedium'>#vOutstanding#</span>"
		parent="Root"					
        expand="Yes">
		
	</cfoutput>  	   	
	  		
	  <cfquery name="JobType" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT *
		    FROM  UserQuery.dbo.#SESSION.acc#RequisitionSet
			WHERE JobStatus = 'Active'
			ORDER BY JobType, Created
		  </cfquery>
	  	  
	  <cfoutput query="JobType" group="JobType">
	  
	  		<cfquery name="Class" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT *
		    FROM  Ref_OrderClass
			WHERE Code = '#JobType#'			
		  </cfquery>
  		  
		  <cftreeitem value="#jobType#_regular"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: gray;' class='labelmedium'>#class.description# (#jobType#)</span>"
			parent="Job"				
			expand="No">	
								
			<cfoutput>		
			
			<cfif last.jobNo eq jobNo>
				<cfset cl = "<b>">
			<cfelse>
			    <cfset cl = "">
			</cfif>		
			
			       <cfif caseno neq "">			   
				   
				   <cftreeitem value="#JobNo#"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: 6688aa;' class='labelit'>#cl##CaseNo#</span>"
			parent="#JobType#_regular"	
			img="#SESSION.root#/Images/select.png"
			href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
			target="right">	
				  
				   <cfelse>
				   
				   <cftreeitem value="#JobNo#"
	        display="<span style='padding-top:3px;padding-bottom:3px;color: 6688aa;' class='labelit'>#cl##JobNo#</span>"
			parent="#JobType#"	
			img="#SESSION.root#/Images/select.png"
			href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
			target="right">	
							   
				   </cfif>
				   
				  <cfif last.jobNo eq jobNo>
				  
				  <script>
				     ptoken.open("#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#","right")										
				  </script>
				  
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

<cftreeitem value="dummy"
	        display=""
			parent="Root">		  

		<cf_tl id="Cancelled Jobs" var="vCancelled">
			
<cftreeitem value="Job"
        display="<span style='padding-bottom:4px' class='labelmedium'><font color='FF0000'>#vCancelled#</span>"
		parent="Root"					
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
  		  
		  <cftreeitem value="#jobType#_cancel"
	        display="#class.description# (#jobType#)"
			parent="Job"	
			img="#SESSION.root#/Images/folder_close.png"
			imgopen="#SESSION.root#/Images/folder_open.png"			
			expand="No">	
								
			<cfoutput>		
			
			<cfif last.jobNo eq jobNo>
				<cfset cl = "<b>">
			<cfelse>
			    <cfset cl = "">
			</cfif>		
			
			       <cfif caseno neq "">			   
				   
				   <cftreeitem value="#JobNo#"
	        display="<font color='red'>#cl##CaseNo#</font>"
			parent="#JobType#_cancel"	
			img="#SESSION.root#/Images/select.png"
			href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
			target="right">	
				  
				   <cfelse>
				   
				   <cftreeitem value="#JobNo#"
	        display="<font color='red'>#cl##JobNo#</font>"
			parent="#JobTpe#_cancel"	
			img="#SESSION.root#/Images/select.png"
			href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
			target="right">	
							   
				   </cfif>
				   
				  <cfif last.jobNo eq jobNo>
				  
				  <script>
				     window.open("#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#","right")										
				  </script>
				  
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
	SELECT *
    FROM  UserQuery.dbo.#SESSION.acc#RequisitionSet
	WHERE JobStatus = 'Cancelled'
	ORDER BY JobType, Created
</cfquery>	  	

<cfif JobCancel.recordcount gte "1"> 	

	<cftreeitem value="dummy"
	        display=""
			parent="Root">						 

			<cf_tl id="Cancelled Jobs" var="vCancelled">
			
<cftreeitem value="Job"
        display="<span class='labelmedium' style='padding-bottom:4px'><font color='FF0000'>#vCancelled#</b></span>"
		parent="Root"					
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
  		  
		  <cftreeitem value="#jobType#"
	        display="#class.description# (#jobType#)"
			parent="Job"	
			img="#SESSION.root#/Images/folder_close.png"
			imgopen="#SESSION.root#/Images/folder_open.png"			
			expand="No">	
								
			<cfoutput>		
			
			<cfif last.jobNo eq jobNo>
				<cfset cl = "<b>">
			<cfelse>
			    <cfset cl = "">
			</cfif>		
			
			       <cfif caseno neq "">			   
				   
				   <cftreeitem value="#JobNo#"
	        display="<font color='red'>#cl##CaseNo#</font>"
			parent="#JobType#"	
			img="#SESSION.root#/Images/select.png"
			href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
			target="right">	
				  
				   <cfelse>
				   
				   <cftreeitem value="#JobNo#"
	        display="<font color='red'>#cl##JobNo#</font>"
			parent="#JobTpe#"	
			img="#SESSION.root#/Images/select.png"
			href="#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#"
			target="right">	
							   
				   </cfif>
				   
				  <cfif last.jobNo eq jobNo>
				  
				  <script>
				     window.open("#Attributes.destination1#?ID=JOB&ID1=#JobNo#&ID2=#Period#","right")										
				  </script>
				  
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
	  
	<cf_tl id="Purchase To Issue" var="vPending">
	
	<cftreeitem value="Purchase"
	        display="<span style='color:black;font-size:16px;padding-bottom:4px'>#vPending#</span>"
			parent="Root"						
	        expand="No">	
										
		  <cfoutput query="PO">
              		  
		    <cftreeitem value = "#PurchaseNo#"
		        display       = "<span style='font-size:12px;padding-bottom:4px'>#PurchaseNo#</span>"
				parent        = "Purchase"	
				img           = "#SESSION.root#/Images/po.png"
				href          = "../../Requisition/RequisitionView/#Attributes.destination2#?ID=PO&ID1=#PurchaseNo#"
				target        = "right">	
		  
		  </cfoutput> 
	  
</cfif>		  
	 
</cftree>

