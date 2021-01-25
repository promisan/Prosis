<!--- we loop through the record with its query field row values --->	

<cfoutput>
	 	
	<cfset cols  = session.listingdata[box]['columns']>	 
	<!--- we obtain the grouped data as well --->
	
	<cfif url.listgroupfield neq "">	
		<cfset searchgroup = session.listingdata[box]['datasetgroup']>
	</cfif>
	
	<cfset pre = session.listingdata[box]['colprefix']>	
	<cfset agg = session.listingdata[box]['aggregate']>	

	<!--- GROUP / PIVOT PRESENTATION --->
	
	<cfset headercols = pre+session.listingdata[box]['firstsummary']-1>	
	<cfset headercols = pre+3>				   
			
	<cfset lst = "">
						
	<cfloop query="SearchResult" startrow="#start#" endrow="#end#">	
		
	     <!--- group presenting only supported if full listing is done and the listing mode not longitudinal --->
	
		<cfif rowdatatarget eq "r">
				    			 
			<cfif evaluate(url.listgroupfield) neq lst>		
						
			  <cfinclude template="ListingContentHTMLGroupShow.cfm">	  
			  					   					
			  <cfset pre1     = "<td colspan='#headercols#' style='font-size:16px;padding-left:5px;height:30px'>#groupname# (#counted#)</td>">			  
			  <cfset data1     = "">
			  
			   <cfloop index="itm" from="#headercols-pre+1#" to="#cols-pre#">
			  			  			   
				   <cfparam name="grp[#itm#]" default="">			   
				   
				   <cfif grp[itm] eq "">
				       <cfset data1 = "#data1#<td colspan='1'></td>">	
				   <cfelse>
				       <cfset data1 = "#data1#<td style='border-left:1px solid silver;border-right:0px solid d3d3d3;font-size:14px;padding:1px'><table style='height:99%;width:100%'><tr><td align='right' style='padding-left:10px;width:90%;background-color:ffffaf;font-size:16px;padding-right:3px;border:1px solid silver'>#grp[itm]#</td></tr></table></td>">				
				   </cfif>
			   
		       </cfloop>	
			  	  
			  <script>
			   var markup = "<tr class='line fixrow240 navigation_row labelmedium2'>#pre1##data1#</tr>";			 
			   $('###attributes.box#_table').append(markup) 					 				 
		      </script>
			  
			  <!---
			  			  			  			  		  		  
			  <cfif session.listingdata[box]['firstsummary'] lte "2">
			  
			  	   <cfset content = "">
			  		  		  		       
				   <cfloop index="itm" from="1" to="#cols#">
				   
				  	   <cfparam name="grp[#itm#]" default="">						   		   
					   <cfif grp[itm] eq "">
					   <cfset content = "#content#<td colspan='1'></td>">	
					   <cfelse>
					   <cfset content = "#content#<td align='right' colspan='1' style='border-left:1px solid silver;border-right:1px solid silver;font-size:14px;padding-right:4px'>#grp[itm]#</td>">	
					   </cfif>
					   
				   </cfloop>	
				   
				   <script>
					  var markup = "<tr class='line navigation_row labelmedium2' style='background-color:e1e1e1'>#content#</tr>";			 
					  $('###attributes.box#_table').append(markup) 					 				 
			      </script>		 			   
			  		  
			  </cfif>
			  
			  --->
			  								
			  <cfset lst = evaluate(url.listgroupfield)>		 
			
			</cfif>		
			
			
		</cfif>	
	
	    <!--- ---------------------- --->
		<!--- only the first row yet --->
		
		<cfif drillmode eq "">			
		   <cfset myicon = "">			
		<cfelseif drillmode eq "Embed" or drillmode eq "EmbedXT" or drillmode eq "Workflow"> 			
		    <cf_img icon="expand" var="myicon" toggle="Yes">			
		<cfelse>			
			<cf_img icon="open"   var="myicon">			
		</cfif>
							
		<cf_img icon="delete" var="mydelete">
											
		<cfscript>
		
			/* row cells */			
			color    = "#iif(currentrow MOD 2,DE('fafafa'),DE('efefef'))#"
			dkey     = evaluate(drillkey)
			listrow  = "class='#attributes.classheader# navigation_row line #rowdatatarget#_data' name='f#attributes.box#_#dkey#' style='background-color:#color#'"
				
		    /* prefix cells */				
			pre1     = "<td align='right' style='padding-right:4px;height:21px'>#currentrow#.</td>"
		
			drillfun = "toggledrill('#lcase(drillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')"
			
			if (drillmode eq 'Embed' or drillmode eq 'EmbedXT' or drillmode eq 'Workflow') { 
			pre2     = "<td style='padding-top:8px' class='navigation_action' onclick=#drillfun#>#myicon#</td>"
			} else {
			pre2     = "<td style='padding-top:4px' class='navigation_action' onclick=#drillfun#>#myicon#</td>"
			}					
					
			/* row content cells */				
			for ( rowshow=1;rowshow<=1;rowshow++ ) {	
			    include "ListingContentGetCell.cfm";							    			
			}	
										
			content = ""				
			for ( itm=1;itm<=cnt;itm++ ) {				
			    param name="boxcontent[itm]" default="";				    
				content = "#content# #boxcontent[itm]#"						
			}	
			
			/* suffix cells */ 				
			suf = ""				
			if (annotation NEQ "") {
			   suf = "#suf#<td style='padding:3px' id='note#dkey#' align='center'></td>"
			}
			
			if (deletetable NEQ "") {
			   del  = "deleterow('#box#','#attributes.datasource#','#deletetable#','#drillkey#','#dkey#')"				   
			   suf = "#suf#<td style='padding-top:1px' onclick=#del#>#mydelete#</td>"
			}
					
			if (deletescript NEQ "") {
			   del  = "#deletescript#('#box#','#dkey#')"				   
			   suf = "#suf#<td style='padding-top:1px' onclick=#del#>#mydelete#</td>"
			}
			
			/* final cells */				
			tdcells = "#pre1##pre2##content##suf#"	
		
		</cfscript>
					
		<!--- content row 1 --->
		
		<cfif rowdatatarget eq "r">
							
			<script>
			 var markup = "<tr #listrow#>#tdcells#</tr>";			 
			 $('###attributes.box#_table').append(markup) 					 				 
		    </script>
			
		<cfelse>	
		
			<script>										
			 var markup = "<tr #listrow#>#tdcells#</tr>";	
			 $('.#rowdatatarget#').closest('tr').before(markup) ;							 
		    </script>
								
		</cfif>	
						
		<!--- content row 2 --->
		
		<!--- content row 3 --->
		
		
		<!---
		
		<cfif hasContent2 eq  "Yes"> 	
		
			<cfset listrow = "name='f#box#_#dkey#' style='background-color:##FCFFE0;border-top:1px dotted silver;border-bottom:1px' class='#attributes.classheader#'">
																											
			<cfset pre1 = "<td style='background-color:#color#'></td>">
			<cfset pre2 = "<td style='background-color:#color#'></td>">
			
			<cfset endcell = "1">
			
			<cfset post = "">				
			<cfloop index="itm" from="1" to="#endcell#">
				<cfset post = "#post#<td style='background-color:#color#'></td>">
			</cfloop>	
			
			<cfset tdcells = "#pre1##pre2##content##post#">						
			<script>
			 var markup = "<tr #listrow#>#tdcells#</tr>";
			 $('###attributes.box#_table').append(markup) 				
	    	</script>			
							
		</cfif>					
					
		<cfif hasContent3 eq "Yes">															    				    				
													
		</cfif>		
		
		--->					
				
		
		<!--- drill content row 4 --->
		
		<cfif drilltemplate neq "" and drillkey neq "" and drillmode neq ""> 
		
			<cfscript>	
		 
			  divId = replace(evaluate(drillkey)," ","","ALL")
			  if (drillmode eq "workflow") {
			     cell1 = "<td id='workflowlink_c#divId#' value='#SESSION.root#/tools/listing/listing/ListingDetailWorkflow.cfm'></td>"				 
			  } else {
			     cell1 = "<td></td>"
			  }
		      cell2 = "<td align='center' style='padding:4px' id='c#divId#' colspan='#cols-1#'></td>"				  
			  tdcells = "#cell1##cell2#"
			  
		  	</cfscript>
			
			<cfif rowdatatarget eq "r">
			
				<script>
				 	var markup = "<tr class='hide' id='box#divId#' name='f#box#_#dkey#'>#tdcells#</tr>";
					 $('###attributes.box#_table').append(markup) 					 				 
				</script>		
			
			<cfelse>
			
				<script>					    			    				 
				 	var markup = "<tr class='hide #rowdatatarget#_data' id='box#divId#' name='f#box#_#dkey#'>#tdcells#<td></td></tr>";
					$('.#rowdatatarget#').closest('tr').before(markup) ;							 				 				
				</script>			
			
			</cfif>
		
		</cfif>			
							
		<!---
		
		<cfif annotation NEQ "">		
			<cfset ajaxOnLoad("function(){ ptoken.navigate('#session.root#/tools/listing/listing/setAnnotation.cfm?entity=#attributes.annotation#&key=#dkey#','note#dkey#') }")>	
		</cfif>
		
		--->		
									
		
	</cfloop> 
		
		
	<cfif SearchResult.recordcount lte end>
		<cfset end = searchResult.recordcount>
	</cfif>
	
	<!--- we update the navigation with the number of records in the grid --->
	<!--- we replace this in the SetTime script --->
	
	<script>			 		 
		 se = document.getElementsByName('#attributes.box#_rowshown')
		 i = 0			 	 					 
		 while (se[i]) { se[i].innerHTML = '#end#'; i++ }					
    </script>
	
	<!--- we keep the last record shown in memory --->
	<cfset session.listingdata[box]['recshow'] = end>		
					
	<cfset ajaxonload("doHighlight")>		
			
</cfoutput>	