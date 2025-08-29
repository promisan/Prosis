<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
			<cfparam name="fields.precision" default="">
	
		    <cfset col = col + 1> 	
													
			<cfif fields.aggregate eq "SUM">	
									
			    <cfif session.listingdata[box]['firstsummary'] eq "0">								
					<cfset session.listingdata[box]['firstsummary'] = col>  <!--- which column needs the first summary --->
				</cfif>  
				
				<cfset aggregateformat = fields.formatted>	
				
				<cfif findNoCase("[precision]",aggregateformat)>
				
					<cfif fields.precision neq "">																		
						<cf_precision number="1">					
						<cfset aggregateformat = replaceNoCase("#aggregateformat#","[precision]","#pformat#")>										
					<cfelse>					
						<cfset aggregateformat = replaceNoCase("#aggregateformat#","[precision]",",")>						
					</cfif>
														
				</cfif>
												
				<cfset aggregateformat = replaceNoCase(aggregateformat,fields.field,"subtotal.#fields.field#")>
								
				<cfset grp[col] = "#evaluate(aggregateformat)#">	
				 
			<cfelse>			
			
				<cfset grp[col] = "">		
						 
				 
			</cfif>	
			
		  </cfif>	 
			
	  </cfloop>				  

  </cfif> 
   