
<!--- --------------------------------------------------------------------------------- --->  
<!--- obtain the data for this row in one query Instead of repeating this for each sum) --->
<!--- --------------------------------------------------------------------------------- --->
	    	
	<cfset aggregate    = "COUNT(*) as total">
	<cfset aggrfield    = "total">	
	<cfset colnfield    = "">
	<cfset col = 0>

	<cfloop array="#attributes.listlayout#" index="fields">
	  			  
			<cfparam name="fields.aggregate"   default="">	
			<cfparam name="fields.column"      default="">							
			<cfparam name="fields.display"     default="yes">	
			
			<!--- need to rework this a bit so we can have several different column dimension --->
						
			<cfif fields.display eq "Yes" and fields.field neq url.listgroupfield>  <!--- fields to be shown and is not grouping field itself --->
			
			    <cfset col = col + 1> 				
				<!--- SUM metric --->						
				<cfif fields.aggregate eq "SUM">					
				
					<cfif session.listingdata[box]['firstsummary'] eq "0">												
						<cfset session.listingdata[box]['firstsummary'] = col>														
					</cfif>					    
					<cfset aggregate = "#aggregate#,SUM(#fields.field#) as #fields.field#">
					<cfset aggrfield = "#aggrfield#,#fields.field#">												
				 </cfif>	
				 
				 <!--- need to rework this a bit so we can have several different column dimension --->
			
				 <cfif fields.column neq "">
				      <cfif fields.column eq "month">
					      <cfif colnfield eq "">						      
						      <cfset colnfield = "#fields.field#_mth">	
						  <cfelse>
						      <cfset colnfield = "#colnfield#,#fields.field#_mth">
						  </cfif>	  
					  </cfif>			 
				 </cfif>		
			
			</cfif>
					
	</cfloop>	
	
	<cfset session.listingdata[box]['aggregate']     = aggregate>
	<cfset session.listingdata[box]['aggrfield']     = aggrfield>
	<cfset session.listingdata[box]['colnfield']     = colnfield>
		
	<!--- we prepare a BASE query content  with both row (group) and column dimension which will speed up the presentation later ---> 								
																		
	<cfquery name="SearchGroup" dbtype="query">
		 SELECT   #url.listgroupfield#, 
		          #url.listgroupsort#, 
                  <!--- we add this field to present the correct sorting of the group as well --->
				  <cfif drillkey neq "">													  
				  MIN(#drillkey#) as GroupKeyValue, <!--- we take a random value of the key so we can easily find the content --->
				  </cfif>
				  <cfif colnfield neq "">
				  #colnfield#,				  
				  </cfif>				     
				  #preserveSingleQuotes(aggregate)#  <!--- totals and count --->
				  
		 FROM     SearchResult <!--- this is the base content which we generated or kept in memory --->
		
		 GROUP BY #url.listgroupsort#, 
				  <cfif colnfield neq "">
				  #colnfield#,				  
				  </cfif>		
		          #url.listgroupfield#	
				  
		 ORDER BY #url.listgroupsort#											
	</cfquery>
	
	<!--- also obtain the ranges of the column to be capped in showing month --->
 	
	<cfset session.listingdata[box]['datasetgroup']  = searchgroup>