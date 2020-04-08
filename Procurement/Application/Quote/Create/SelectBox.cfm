
<cf_menuscript library = "yes">

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>

<table width="100%" height="100%">
  
      <tr>
	  
	  <td width="100%">
	  	  
		    <table border="0" width="100%">
			
			<tr>
					
			<cfset ht = "64">
			<cfset wd = "64">
				
			<cfset itm = 1>
			
			<cf_tl id="Select Requisitions" var="1">
		    <cf_menutab item       = "1" 
			        iconsrc    = "Logos/System/Questionaire.png" 
					iconwidth  = "#wd#" 
					iconheight = "#ht#" 
					class      = "highlight1"
					source     = "SelectPending.cfm?mission=#url.mission#&period={period}"
					name       = "#lt_text#">		
					
			<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Ref_OrderClass
				  WHERE  PreparationMode = 'Job'
				  AND   (Mission = '#URL.Mission#' or Mission is NULL or Code IN (SELECT Code FROM Ref_OrderClassMission WHERE Mission = '#url.mission#'))		 
			</cfquery>	
			
			<cfif Check.recordcount gte "1"> 
			
				<cfset itm = itm + 1>		
				<cf_tl id="Competitive Bidding" var="1">
				
				<cf_menutab item   = "#itm#" 
				        tabid      = "job"
						button     = "yes"
						targetitem = "2"
				        iconsrc    = "Logos/Procurement/Bidding.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "#lt_text#"
						source     = "JobCreateJob.cfm?mission=#url.mission#&period={period}">					
				
			</cfif>
			
			<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Ref_OrderClass
				  WHERE  (Mission = '#URL.Mission#' or Mission is NULL or Code IN (SELECT Code FROM Ref_OrderClassMission WHERE Mission = '#url.mission#'))
				  AND   PreparationMode = 'Direct'
			  </cfquery>					
			 			
	    	<cfif Check.recordcount gte "1">
			
		    	<cfif Parameter.EnableExpressPurchase eq "1">
								
					<cfset itm = itm + 1>	
					<cf_tl id="Issue Obligation Document" var="1">
					
					<cf_menutab item       = "#itm#" 
					        tabid      = "po"
							button     = "yes"
							targetitem = "2"
					        iconsrc    = "Logos/Procurement/Purchase.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							name       = "#lt_text#"
							source     = "JobCreatePurchase.cfm?mode=quick&mission=#url.mission#&period={period}">		
							
				</cfif>
				
			</cfif>		
			
			<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Ref_OrderClass
				  WHERE  (
				         Mission = '#URL.Mission#' or
				         Mission is NULL or 
						 Code IN (SELECT Code FROM Ref_OrderClassMission WHERE Mission = '#url.mission#')
						 )
				  AND    PreparationMode = 'Travel'
			</cfquery>		
			
			<cfif Check.recordcount gte "1">	
			
				<cf_tl id="Issue Travel Authorization" var="1">
					
				<cf_menutab item       = "6" 
				        tabid      = "travel"
						button     = "yes"
						targetitem = "2"
				        iconsrc    = "Logos/Procurement/Travel.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "#lt_text#"
						source     = "JobCreateTravel.cfm?mode=travel&mission=#url.mission#&period={period}">							
				
			</cfif>		
			
					
			<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM   Ref_OrderClass
				  WHERE  PreparationMode = 'SSA'
				  AND   (Mission = '#URL.Mission#' or 
				         Mission is NULL or 
					     Code IN (SELECT Code FROM Ref_OrderClassMission WHERE Mission = '#url.mission#'))		 
			</cfquery>		
			

			<cfif Check.recordcount gte "1"> 	
			
				<cfset itm = itm + 1>		
				<cf_tl id="Individual Contractor" var="1">
				
				<cf_menutab item   = "#itm#" 
				        tabid      = "contract"
						button     = "yes"
						targetitem = "2"
				        iconsrc    = "Logos/Procurement/Contractor.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "#lt_text#"
						source     = "JobCreateJob.cfm?mode=ssa&mission=#url.mission#&period={period}">	
									
			</cfif>			
			
			<cfquery name="Check" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			      SELECT *
			      FROM Ref_OrderClass
				  WHERE PreparationMode = 'Position'
				  AND  (Mission = '#URL.Mission#' or Mission is NULL or Code IN (SELECT Code FROM Ref_OrderClassMission WHERE Mission = '#url.mission#'))		 
			</cfquery>		
			
			<cfif Check.recordcount gte "1"> 	
			
				<cfset itm = itm + 1>		
				<cf_tl id="Fund a Staff Position" var="1">
				
				<cf_menutab item   = "#itm#" 
				        tabid      = "position"
						button     = "yes"
						targetitem = "2"
				        iconsrc    = "Logos/Procurement/Position-Funding.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "#lt_text#"
						source     = "JobCreateJob.cfm?mode=position&mission=#url.mission#&period={period}">	
									
			</cfif>			
			
			
							
		</tr>
		
		</table>
	
	</td>
	
	</tr>
	
</tr>	

<tr><td height="100%" style="padding-left:6px;padding-right:6px">
    
    <table width="100%" height="100%" border="0">
			
	<cf_menucontainer item="1" class="regular">	       
	         <cfset url.mode = "pending">
			 <cfinclude template="SelectPending.cfm"> 				 
	</cf_menucontainer>	 
	
	<cf_menucontainer item="2" class="hide">
			
	</table>
		
</td></tr>

</table>
