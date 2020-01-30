
<!--- make options available --->

<script>
 
     try {
	 document.getElementById('menujob').disabled = true      } catch(e) {}
	 try {
	 document.getElementById('menupo').disabled = true	     } catch(e) {}	
	 try {
	 document.getElementById('menuposition').disabled = false } catch(e) {}	
	 try {
	 document.getElementById('menucontract').disabled = true } catch(e) {}	
	 try {
	 document.getElementById('menutravel').disabled = true	 } catch(e) {}	  	 
 	 set_style();   
		 
</script>

<cfparam name="form.reqNo" default="">

<cfset Session.reqNo = FORM.reqNo>

<cfif form.reqno neq "">
	
	<!--- check job --->
	
	<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      RequisitionLine L
		WHERE     L.ActionStatus IN ('2k') 
				
		AND       (L.PersonNo is NULL or L.PersonNo = '') 
		
		AND       L.ItemMaster NOT IN (SELECT I.Code 
		                               FROM   ItemMaster I, 
										      Ref_EntryClass R
									   WHERE  I.EntryClass = R.Code
									   AND    
									       
										        (
												  R.CustomDialog IN ('Contract','Travel') <!--- AND I.CustomForm = 1	--->
												)
										   
										      <!---
										      OR
											  									   
										        I.CustomDialogOverwrite = 'Contract'								  										  
												--->
										     
											 
								   )	   
		
		
		AND       RequisitionNo IN (#preservesinglequotes(form.reqno)#)	
		
				
	</cfquery>
	
	
	<cfif Job.recordcount gte "1">
		
		<script>					
		    try { document.getElementById('menujob').disabled =  false} catch(e) {}
			try { document.getElementById('menupo').disabled  =  false} catch(e) {}			
		    set_style();
		</script>	
	
	</cfif>
			
	<!--- check for a contract job on a position --->
		
	<cfquery name="ContractJob" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      RequisitionLine L
		WHERE     L.ActionStatus IN ('2k') 
					
		AND       L.ItemMaster IN (SELECT I.Code 
	                               FROM   ItemMaster I, Ref_EntryClass R
								   WHERE  I.EntryClass = R.Code
								   AND    
								       
									        (
											  R.CustomDialog = 'Contract' 									
										    )
									   
									        <!---
									        OR		SSA longterm => dialog = travel show not show  not 							   
									      
										      I.CustomDialogOverwrite = 'Contract'								  										  
											  --->
									      
										
								   )	   
		
		
		AND       RequisitionNo IN (#preservesinglequotes(form.reqno)#)				
	</cfquery>
	
	<cfif ContractJob.recordcount gte "1">
	
		<script>	
				
		    try { document.getElementById('menuposition').disabled = false } catch(e) {}		
  		    set_style();
		</script>	
				
	</cfif>	
	
	<!--- check for a contractor selection job (SSA)  --->
	
	<cfquery name="ContractJob" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      RequisitionLine
		WHERE     ActionStatus IN ('2k') 
					
		AND       ItemMaster IN (SELECT I.Code 
	                               FROM   ItemMaster I, Ref_EntryClass R
								   WHERE  I.EntryClass = R.Code
								   AND    
								       
									        (
											  R.CustomDialog = 'Travel' <!--- AND I.CustomForm = 1	not a condition --->
										    )
									   									
								   )	   
		
		
		AND       RequisitionNo IN (#preservesinglequotes(form.reqno)#)				
	</cfquery>
	
	
	<cfif ContractJob.recordcount gte "1">
	
		<script>
			try { document.getElementById('menucontract').disabled = false  } catch(e) {}
		    set_style();			
		</script>	
				
	</cfif>	
	
	<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    L.*
		FROM      RequisitionLine L
		WHERE     L.ActionStatus IN ('2k') 
		AND       L.PersonNo IN (SELECT PersonNo 
		                         FROM   Employee.dbo.Person
							     WHERE  PersonNo = L.PersonNo)
		AND       L.RequisitionNo IN (#preservesinglequotes(form.reqno)#)				
	</cfquery>	
	
	<cfif Job.recordcount gte "1">
	
		<script>			
		    try { document.getElementById('menutravel').disabled = false } catch(e) {}	
			set_style();		
		</script>	
	
	</cfif>

</cfif>


