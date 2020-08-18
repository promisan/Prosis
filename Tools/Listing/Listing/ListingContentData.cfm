
<cfset vContentHeight = "100%">		

<cfset orderset = 0>
<cfset col      = 0>
<cfset total    = 0>
<cfset showrows = 1>	

<cf_divscroll id="_divContentFields" height="#vContentHeight#">

	<cfoutput>
	   		   
		<table style="width:98.5%">
							
			<cfif searchresult.recordcount eq "0">					
							    								
				<tr><td style="height:50" align="center" colspan="#cols#" class="labelmedium"><cf_tl id="NoRecords" var="tlNoRecords">#tlNoRecords#.</td></tr>							
			
			<cfelse>
						 					
			 <cfinclude template="ListingHeader.cfm">
				
			</cfif>							
			
			<cfloop query="SearchResult" startrow="1" endrow="#last#">
						
				<cfset currrow = currrow + 1>										
				<cfif currrow gte first and currrow lte last>
					
				    <cfif evaluate(url.listgroupfield) neq lst>		
							   										
					  <cfset val = ltrim(rtrim(evaluate(url.listgroupfield)))>
					  <cfset val = Replace( val, "'", "''", "ALL" )>	
					  <cfset aggregate = "">												
																	
					  <cftry>			  	
						  
						  <!--- get sum fields --->
						  
						  <cfloop array="#attributes.listlayout#" index="fields">
						  			  
								<cfparam name="fields.aggregate"   default="">					
								<cfparam name="fields.searchfield" default="">
								<cfparam name="fields.searchalias" default="">
								
								<cfif fields.aggregate eq "SUM">	
																
										<cfset aggregate = "SUM(#fields.field#) as #fields.field#">													
										<cfset aggregateformat = fields.formatted>		
										<cfset aggregateformat = replaceNoCase(aggregateformat,fields.field,"subtotal.#fields.field#")> 				
														
								</cfif>
				
						  </cfloop>
						 						  			  								  
						  <cfquery name="subtotal"       
					         dbtype="query">
							 SELECT COUNT(*) as counted <cfif aggregate neq "">,#aggregate#</cfif>
							 FROM   SearchResult
							 WHERE  #url.listgroupfield# = '#val#'			 
						  </cfquery>			  
						  
						  <cfif subtotal.recordcount eq "0"> 						  
						  			  								  
							  <cfquery name="subtotal"       
						         dbtype="query">
								 SELECT COUNT(*) as counted <cfif aggregate neq "">,#aggregate#</cfif>
								 FROM   SearchResult
								 WHERE  #url.listgroupfield# LIKE '#val#%'			 
							  </cfquery>			  
						  
						   </cfif>
						  
						  <!--- query of query does not mix integer and strings --->	
								  
						  <cfcatch>		
						  
						  	<cfif val eq "">
								 <cfset val = 0>
							 </cfif>
						    	
							 <cfquery name="subtotal"       
							    dbtype="query">
								 SELECT  COUNT(*) as counted <cfif aggregate neq "">,#aggregate#</cfif>
								 FROM    SearchResult
								 WHERE   #url.listgroupfield# = #val#									 					 
							  </cfquery>	
																			  
						  </cfcatch>
					  
					  </cftry>		
					  
					  <!--- grouping record --->
																
					  <tr class="line fixrow2">
					  <td colspan="#cols-3#" class="labellarge" style="font-weight:bold;padding-left:5px;height:30px">	
					      
						   <cfif findNoCase('00:00',evaluate(url.listgroupfield))>
							 #dateformat(evaluate(url.listgroupfield),CLIENT.DateFormatShow)#
						   <cfelse>		  
							   <cfif evaluate(url.listgroupfield) neq "">
								 #evaluate(url.listgroupfield)#
							   <cfelse>
								 #evaluate(url.listgroup)#
							   </cfif>															 
						   </cfif>				 
						   </td>		
						   <cfif aggregate eq "">		 
						   <td align="right" colspan="3" class="labelmedium" style="font-weight:bold;padding-top:4px;padding-bottom:2px;padding-right:10px">#subtotal.counted#</td>				 
						   <cfelse>
						   <td align="right" colspan="3" class="labelmedium" style="font-weight:bold;padding-top:4px;padding-bottom:2px;padding-right:10px">
						   <cfif subtotal.counted gt "1">
						   (#subtotal.counted#)&nbsp;
						   </cfif>#evaluate(aggregateformat)#</td>	
						   </cfif>
					  </tr>		
											
					  <cfset lst = evaluate(url.listgroupfield)>
					
					</cfif>
							
					<cfset row = row + 1>
					
					<cfif attributes.drillrow eq "Yes" and drilltemplate neq "">
					      <cfset s = evaluate(drillkey)>						  
					<cfelse>
					      <cfset s = currentrow>
					</cfif>  
					
					<cfset dkey = evaluate(drillkey)>
																				
					<!--- ------------------ --->
					<cfset rowspan = showrows>
					<cfset rowspan = "1">
					<!--- ------------------ ---> 
															
					<cfif showrows eq "1">								   
					   <tr class="#attributes.classsub#" id="r#row#" keyvalue="#s#" name="f#box#_#dkey#">					
					<cfelse>
					   <tr class="#attributes.classsub#" id="r#row#" keyvalue="#s#" name="f#box#_#dkey#">
					</cfif>
															
					<cfif rowspan eq "1">																	   
						<td style="padding-left:12;height:21px" class="labelnormal" id="#s#">#currentrow#.</td>		   
					<cfelse>
						<td style="padding-left:12;height:21px" class="labelnormal" rowspan="#rowspan#" id="#s#">#currentrow#.</td>	
					</cfif>
					   
					<!--- to be checked 1/9/2013 --->
					  
					   <cfif attributes.selectmode eq "Checkbox">		   
						   <td rowspan="#rowspan#"><input type="checkbox" name="ListSelect" id="ListSelect" value="#s#"></td>		   		   
					   <cfelseif attributes.selectmode eq "Radio">		   		   
						   <td rowspan="#rowspan#"><input type="radio"    name="ListSelect" id="ListSelect" value="#s#"></td>	
					   <cfelseif attributes.navtemplate neq "">
					        <input id="nav#row#" type="hidden" onclick="navtarget('#session.root#/#attributes.navtemplate#?ajax=yes&ajaxid=#s#','#attributes.navtarget#')"> 	   	   		   
					   </cfif>						   			   				   
																			
					   <cfif attributes.listtype eq "Directory">
							
							<td align="center" rowspan="#rowspan#" style="padding-top:1px">
							
								<cfif row eq "1" and client.browser eq "Explorer"><cf_space spaces="5"></cfif>
								<cf_img icon="open" id="img0_#currentrow#" onclick="showtemplate('#attributes.listpath#','#attributes.listquery#\\#name#')">
							</td>
									  							
					   <cfelseif drillmode eq "">
						
							<td align="center" rowspan="#rowspan#" style="padding-top:1px">
								<cfif row eq "1" and client.browser eq "Explorer"><cf_space spaces="5"></cfif>
							</td>
							<!--- do not show drill --->
														
					   <cfelseif drillmode eq "Embed" or drillmode eq "EmbedXT" or drillmode eq "Workflow">
					   
					        <cfif drillmode eq "EmbedXT">
								<cfset tdrillmode ="Embed">
							<cfelse>
								<cfset tdrillmode = drillmode>								
							</cfif>
						
						   <cfset cl = "toggledrill('#lcase(tdrillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">
							
						   <td align="center" rowspan="#rowspan#" style="padding-top:1px;padding-left:5px">
						   
						   <img style="cursor:pointer" name="exp#dkey#" id="exp#dkey#" 
						     class="regular" src="#client.VirtualDir#/Images/arrowright.gif" align="absmiddle" alt="Expand" height="9" width="7" onclick="#cl#" border="0"> 	
							 
						   <img style="cursor:pointer" name="col#dkey#" id="col#dkey#" 
						     class="hide" src="#client.VirtualDir#/Images/arrowdown.gif" align="absmiddle" height="10" width="9" alt="Hide" onclick="#cl#" border="0"> 
						   </td>
							 
						<cfelse>						
												
						   <cfset cl = "toggledrill('#lcase(drillmode)#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">			  					 
						   
						   <td align="center" rowspan="#rowspan#" onclick="#cl#">
							   <cfif row eq "1" and client.browser eq "Explorer"><cf_space spaces="5"></cfif>
							   <cf_img id="exp#currentrow#" icon="open">							   
							</td>
													 
						</cfif>  		
						
						<!--- ------------------------------------------------------------------- --->
						<!--- -------------------------SHOW FIELD CONTENT------------------------ --->				
						<!--- ------------------------------------------------------------------- --->			
						<cfset rowshow = 1><cfinclude template="ListingContentField.cfm">			
						<!--- ------------------------------------------------------------------- --->	
						<!--- ------------------------------------------------------------------- --->																				
												
						<cfif attributes.listtype eq "Directory">			
							<td style="border-left:1px dotted ##C0C0C0;"><input type="checkbox" value="#attributes.listquery#\#name#"></td>			
						</cfif>
												
						<cfif annotation neq "">		
							
							<td id="note#dkey#" align="center">									    
							   	<cfif doc.entityKeyField4 neq "">				
									<cf_annotationshow entity="#annotation#" keyvalue4="#dkey#" docbox="note#dkey#">					   
								<cfelse>				
									<cf_annotationshow entity="#annotation#" keyvalue1="#dkey#" docbox="note#dkey#">				
								</cfif>											
							</td>									
							
						</cfif>			
												
						<cfif deletetable neq "">							
								
							<td align="right" style="padding-top:2px;padding-right:5px;padding-left:3px">	
							     <img src="#session.root#/images/delete.png" 
								   id="del#row#" style="height:17px;cursor:pointer" alt="Remove record" border="0" 
								   onclick="deleterow('#row#','#attributes.datasource#','#deletetable#','#drillkey#','#dkey#')">	
								 <!---								
							     <cf_img icon="delete" id="del#row#" onclick="deleterow('#row#','#attributes.datasource#','#deletetable#','#drillkey#','#dkey#')">		
								 --->
							</td>											
						</cfif>					
						
					</tr>
					
					<!--- determine if we need to show a second row --->
					
					<cfif showrows gte "2"> 	
					
						<cfset hascontent = "No">														
						<tr onclick="listshowRow('#row#');" name="f#box#_#dkey#" id="s#row#" class="<cfif showrows eq "2">#attributes.classheader#<cfelse>#attributes.classsub#</cfif>">	  
						    <td colspan="2"></td>							
						   	<cfset rowshow = "2">								
							<cfinclude template="ListingContentField.cfm">
							<cfif hascontent eq "No">
								<cfset ajaxOnLoad("function(){ $('##s#row#').removeClass('#attributes.classheader#').addClass('hide'); }")>
							</cfif>		
						</tr>					
					</cfif>							
					
					<!--- determine if we need to show a third row --->
					
					<cfif showrows eq "3">		
					
					    <cfset hascontent = "No">					    				
						<tr onclick="listshowRow('#row#')" name="f#box#_#dkey#" id="t#row#" class="<cfif showrows eq "3">#attributes.classheader#<cfelse>#attributes.classsub#</cfif>">
							<td colspan="2"></td>								  		
						    <cfset rowshow = "3">
							<cfinclude template="ListingContentField.cfm">	
							<cfif hascontent eq "No">
								<cfset ajaxOnLoad("function(){ $('##t#row#').removeClass('#attributes.classheader#').addClass('hide'); }")>
							</cfif>			
						</tr>		
												
					</cfif>		
					
					<cfif drilltemplate neq "" and drillkey neq "" and drillmode neq "">					

						 <cfset divId = replace(evaluate(drillkey)," ","","ALL")>
					
						   <input type="hidden" 	  	   
							   id="workflowlink_c<cfoutput>#divId#</cfoutput>"
							   value="<cfoutput>#SESSION.root#</cfoutput>/tools/listing/listing/ListingDialog.cfm">	  
						  
							<tr class="hide" id="box#divId#" name="f#box#_#dkey#">
							      <TD></TD>
							      <td align="center" style="padding:4px" id="c#divId#" colspan="#cols+1#"></td>
							</tr>
						
					</cfif>					
								
				</cfif>			
							
			</cfloop>
		
		</table>		
	
	</cfoutput>			    			
		
</cf_divscroll>