
<!--- we obtain the summary fields to be shown on the row level for the group --->
	  				
<cfset agg = session.listingdata[box]['aggregate']>	
	
<cfif agg neq "">

	<!--- we get the total of the records found in the group query result which has 1, 2 or more (later) dimensions prepared 
	if we have one dimension the below summing is not really needed as it is already grouped on this level but we do it anyway for
	generic purpises --->
	
	<cftry>	
				  	  		  
	  <cfquery name="subtotal" dbtype="query">
		 SELECT #preservesingleQuotes(agg)#, sum(total) as Records
		 FROM   SearchGroup
		 <cfif val eq "">
		 WHERE  #url.listgroupfield# IS NULL	
		 <cfelse>
		 WHERE  #url.listgroupfield# = '#val#'			 	 
		 </cfif>
	  </cfquery>	
	  	    	  
	  <cfif subtotal.recordcount eq "0"> 	
	  
	  	  <!--- sometimes the query-on-query needs a wider match to return data like NOEMI AGUILAR --->		  		  
	  	  		  								  
		  <cfquery name="subtotal" dbtype="query">
			 SELECT #preservesingleQuotes(agg)#, sum(total) as Records
			 FROM   SearchGroup
			 WHERE  #url.listgroupfield# LIKE '%#val#%'			 
		  </cfquery>			  
	  
	   </cfif>	     	  	 	
	  
	  <!--- query of query does not mix integer and strings --->	
		
	  <cfcatch>		 
	  	  
	  	 <cfif val eq "">
			 <cfset val = 0>
		 </cfif>
		 		 	    	
		 <cfquery name="subtotal" dbtype="query">
			 SELECT  #preservesingleQuotes(agg)#, sum(total) as Records
			 FROM    SearchGroup
			 WHERE   #url.listgroupfield# = #val#									 					 
		  </cfquery>	
		  														  
	  </cfcatch>
		    
	 </cftry>	
	 
	 <!--- <cfoutput>#cfquery.executiontime#</cfoutput> --->
	 
	 <cfset col = 0>
	 
	 <!--- --------------------------------------------------------------- ---> 
	 <!--- pass this into the correct cell value for the group to be shown --->
	 <!--- -ATTENTION ADJUST FOR FORMULA ----------------------------- --- --->	 
	 <!--- --------------------------------------------------------------- --->
	 
			 	 	 		  
     <cfloop array="#attributes.listlayout#" index="fields">
	 
		 <cfif fields.display eq "Yes" and fields.field neq url.listgroupfield>
		 
		    <cfparam name="fields.aggregate" default=""> 
	
		    <cfset col = col + 1> 	
													
			<cfif fields.aggregate eq "SUM">	
						
			    <cfif session.listingdata[box]['firstsummary'] eq "0">								
					<cfset session.listingdata[box]['firstsummary'] = col>  <!--- which column needs the first summary --->
				</cfif>  
								
			    <cfset aggregateformat = fields.formatted>		
				<cfset aggregateformat = replaceNoCase(aggregateformat,fields.field,"subtotal.#fields.field#")>
				<cfset grp[col] = "#evaluate(aggregateformat)#">			
				 
			<cfelse>			
			
				<cfset grp[col] = "">		 				 
				 
			</cfif>	
			
		  </cfif>	 
			
	  </cfloop>				  

  </cfif> 
   