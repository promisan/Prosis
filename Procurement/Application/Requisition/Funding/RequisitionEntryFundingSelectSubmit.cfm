
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="Form.ProgramPeriod" default="">
<cfparam name="Form.ObjectCode"    default="">

<cfset url.period = form.ProgramPeriod>

<cfquery name="Line" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM RequisitionLine
	 WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="Prior" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM RequisitionLineFunding 
	 WHERE RequisitionNo = '#URL.ID#'
</cfquery>

<cfif Form.ObjectCode neq "">

	<cfif url.id neq "">
	
	<cftransaction action="BEGIN">
	
	    <cfquery name="Clear" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     DELETE FROM RequisitionLineFunding 
			 WHERE  RequisitionNo = '#URL.ID#'
			 AND    ProgramPeriod = '#url.period#'
			 </cfquery>
			 
		<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     SELECT *
			 FROM RequisitionLineFunding 
			 WHERE  RequisitionNo = '#URL.ID#'			
			 </cfquery> 
			 
		<cfset cnt = Check.recordcount>
			 		 
		<cfloop index="itm" 
		        list="#Form.ObjectCode#" 
				delimiters=",">
				
				<cfset cnt = cnt+1>
									
				<cfset x = ListToArray(itm, "-")>
				<cfset ProgramCode = x[1]>
				<cfset ObjectCode  = x[2]>
				<cfset Fund        = x[3]>
			
		</cfloop>	
		
		<cfset per = int(100/cnt)>
				
		<cfloop index="itm" 
		        list="#Form.ObjectCode#" 
				delimiters=",">
											
				<cfset x = ListToArray(itm, "-")>
				<cfset ProgramCode = x[1]>
				<cfset ObjectCode  = x[2]>
				<cfset Fund        = x[3]>
					
			    <cfif objectcode neq "">
				
					<cfset cnt = cnt - 1>
					
					<cfif cnt eq "0">
					
						<cfquery name="Check" 
						  datasource="AppsPurchase" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
							  SELECT sum(Percentage) as Percentage
							  FROM   RequisitionLineFunding 
							  WHERE  RequisitionNo = '#URL.ID#'
						 </cfquery>
						 
						 <cfif Check.Percentage eq "">
						     <cfset Check.Percentage = "0">
						 </cfif>
						 	 
						 <cfif Check.Percentage neq "1">
							  <cfset per = 100 - Check.Percentage*100>
						 </cfif>
					 
					</cfif> 
									    	
					<cfquery name="InsertFunding" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
						     INSERT INTO RequisitionLineFunding 
							         (RequisitionNo,
									 Fund,
									 ObjectCode,
									 ProgramPeriod,
									 ProgramCode,
									 Percentage,
									 OfficerUserId,
									 OfficerLastName,
									 OfficerFirstName)
						      VALUES ('#URL.ID#',
									  '#Fund#',
									  '#ObjectCode#',
									  '#url.period#',
									  '#ProgramCode#',							 
									  '#per/100#',
									  '#SESSION.acc#',
							    	  '#SESSION.last#',		  
								  	  '#SESSION.first#')
					</cfquery>
					   
				</cfif>
				
		</cfloop>
		
		</cftransaction>
		
		<!--- capture the action if there was already a funding previously --->		
		
		<cfif prior.recordcount gte "1">
		
			<cf_assignId>
						
			<cfsavecontent variable="content">
			    <cfinclude template="../Requisition/RequisitionEditLog.cfm">							
			</cfsavecontent>
					
			<cfquery name="InsertAction" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT  INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionId,
					  ActionStatus, 
					  ActionDate, 
					  ActionMemo,
					  ActionContent,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
			     VALUES
				     ('#URL.ID#', 
				      '#rowguid#',						 
					  '#Line.ActionStatus#',						
					   getdate(), 
					   'Resubmit Funding',
					   '#Content#',
					   '#SESSION.acc#', 
					   '#SESSION.last#', 
					   '#SESSION.first#')
			</cfquery>
		
		</cfif>					
	
	
	</cfif>

</cfif>

	
<script>
    try {
    parent.opener.document.getElementById('fundingrefresh').click()
	} catch(e) {}
    parent.window.close()
</script>	



   
