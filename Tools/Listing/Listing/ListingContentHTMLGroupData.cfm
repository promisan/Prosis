<cfset val = ltrim(rtrim(evaluate(url.listgroupfield)))>
<cfset val = Replace( val, "'", "''", "ALL" )>	

<!--- ----------------------------------------- --->
<!--- --------     get group label    --------- --->
<!--- ----------------------------------------- --->
    			   					   
 <cfif evaluate(url.listgroupfield) neq "">							 
    <cfset groupfield = url.listgroupfield>								 
 <cfelse>							   
    <cfset groupfield = url.listgroup>																 
 </cfif>		
  
<cfloop array="#attributes.listlayout#" index="itm">		

	<cfif itm.field eq groupfield>		
		<cfset groupname = evaluate(groupfield)>		
		<!---						
		<cfif itm.formatted neq "" and itm.formatted neq "Rating">
			<cfset groupname = evaluate(itm.formatted)>
		<cfelse>
			<cfset groupname = evaluate(groupfield)>
		</cfif>																	
		--->	
	</cfif>
  	
</cfloop>	
   
<!--- ----------------------------------------- --->
<!--- -------- get cell summary content ------- --->
<!--- ----------------------------------------- --->

<cfset agg = session.listingdata[box]['aggregate']>	

<cfif agg neq "">

	<!--- we get the total of the records found in the group query result which has 1, 2 or more (later) dimensions prepared 
	if we have one dimension the below summing is not really needed as it is already grouped on this level but we do it anyway for
	generic purpises --->

	<cftry>	
	  	  
	  <cfquery name="subtotal" dbtype="query">
		 SELECT #preservesingleQuotes(agg)#, sum(total) as Records
		 FROM   SearchGroup
		 WHERE  #url.listgroupfield# = '#val#'			 	 
	  </cfquery>	
	  	  
	  <cfif subtotal.recordcount eq "0"> 						  
	  			  								  
		  <cfquery name="subtotal" dbtype="query">
			 SELECT #preservesingleQuotes(agg)#, sum(total) as Records
			 FROM   SearchGroup
			 WHERE  #url.listgroupfield# LIKE '#val#%'			 
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
	 
	 <!---	 	 
	 <cfoutput>#cfquery.executiontime#</cfoutput>	 
	 --->
	 		 
	 <!--- --------------------------------------------------------------- ---> 
	 <!--- pass this into the correct cell value for the group to be shown --->	 
	 
	 <cfset col = 0>
	 <!--- which column needs the first summary --->	 
		  
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
	  
  <cfelse>	    
	  
	   <cfquery name="subtotal" dbtype="query">
			 SELECT  sum(total) as Records
			 FROM    SearchGroup
			 WHERE   #url.listgroupfield# = '#val#'									 					 
	   </cfquery>	
   
  </cfif> 	 						  			  								  
	 	  
 <cfoutput>
    
 <!--- standard count metric : count which we only run if not yet for aggegrate --->      

 <cfset counted = subtotal.records>	 

 <cfif url.ajaxid neq "append">  
  
        <!--- grouping record with class for adding records --->
	 
	  <cfset rowdata = "#box#_group1_#currrow#">
	
	  <cfif navmode neq "manual">											
	     <tr class="line fixrow240 navigation_row labelmedium2">		  
	  <cfelse>		  		
	     <tr class="line navigation_row labelmedium2">		
	  </cfif>		
		   			   
		   <cfif navmode eq "manual">		   
	           <td colspan="#headercols#" style="height:25px;" onclick="listgroupshow('#GroupKeyValue#','#rowdata#')">
		   <cfelse>
		       <td colspan="#headercols#" style="height:25px;">
		   </cfif>			   
		   			   
			   <table>
			   <tr class="labelmedium">
				   <td style="padding-left:4px">					   
				   <cfif navmode eq "manual">	
				   <img src="#client.virtualdir#/Images/Logos/System/ListCollapsed.png" id="#rowdata#_exp" class="regular" style="height:21px">															
				   <img src="#client.virtualdir#/Images/Logos/System/ListExpanded.png"	id="#rowdata#_col" class="hide"    style="height:21px"> 				   
				   </cfif>					   
				   </td>
				   <td style="font-size:16px;padding-left:5px;height:30px">#groupname# (#counted#)</td>
			   </tr>
			   </table>
		   			   
		   </td>				  			  	   
		 			   			   
		   <cfif session.listingdata[box]['firstsummary'] gte "3" or session.listingdata[box]['firstsummary'] eq "0">	<!--- we have space on the same line --->
		   			  
		       <cfif session.listingdata[box]['colnfield'] neq "" and navmode eq "manual">
					   			     		   
			   	   <td colspan="#cols-headercols#" align="right" style="border-right: 1px solid silver;background-color:white">							    				   		   
				    <cfset attributes.mode = "Line">	
				    <cfinclude template="ListingContentHTMLColumn.cfm"> 		   
				   </td>
			   
			   <cfelse>
			  			   			   
				  <cfloop index="itm" from="#headercols-pre+1#" to="#cols-pre#">
					   <cfparam name="grp[#itm#]" default="">			   
					   <cfif grp[itm] eq "">
					       <td colspan="1"></td>	
					   <cfelse>
						   <td align="right" style="border-left:1px solid silver;border-right:0px solid d3d3d3;font-size:14px;padding:1px">
						   <table style="height:99%;width:100%">
						         <tr><td align="right" style="padding-left:10px;width:90%;background-color:ffffaf;font-size:16px;padding-right:3px;border:1px solid silver">#grp[itm]#</td></tr>
						   </table>					   
						   </td>	
					   </cfif>
				   </cfloop>	
			   
			   </cfif>
			   				   				   
			   </tr>
			   
		   <cfelse>	   	 
		   
			   </tr>  	
			   
			  <!--- ---------------------------------------- --->
			  <!--- optional second line to hold the summary --->
			  <!--- ---------------------------------------- --->
			  
			  <cfif session.listingdata[box]['firstsummary'] gte "1" and session.listingdata[box]['firstsummary'] lte "2"> <!--- we have no space on the first line as it will bother presentation of the group itself --->
			  
				  <tr class="line navigation_row labelmedium2" style="background-color:f1f1f1">
				  		       
					   <cfloop index="itm" from="1" to="#cols#">
					   <cfparam name="grp[#itm#]" default="">			   
					   <cfif grp[itm] eq "">
					   <td colspan="1"></td>	
					   <cfelse>
					   <td align="right" colspan="1" style="border-left:1px solid silver;border-right:1px solid silver;font-size:14px;padding-right:4px">				  
					    <table style="width:100%"><tr><td align="right" style="padding-left:10px;height:26px;width:90%;background-color:ffffaf;font-size:16px;padding-right:4px;border:1px solid silver">#grp[itm]#</td></tr></table>					   					 				   
					   </td>	
					   </cfif>
					   </cfloop>			 			   
				  </tr>
			  
			  </cfif>	   
		  			   
		  </cfif>		
			 		  
		  <!--- data is added aobe this record one by one --->
		  <tr class="#rowdata#"><td colspan="#cols#"></td></tr>
		  								
		  <cfset lst = evaluate(url.listgroupfield)>	 
		  
   <cfelse>
   
   		<!--- ajax --->   				 			   
		  
   </cfif>		
   
   </cfoutput>  