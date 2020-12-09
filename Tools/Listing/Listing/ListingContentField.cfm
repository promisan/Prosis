
<!--- we save the content into a field --->

<cfset cnt = 0>	
<cfparam name  = "rowshow" default="1">

<cfset dkey = evaluate(drillkey)>

	<cfoutput> 		
								
		<cfloop array="#attributes.listlayout#" index="current">	
								
			<cfparam name="current.display"     default="yes">		
			<cfparam name="current.style"       default="">
			<!--- row to be shown : row 1, row 2 etc. --->
			<cfparam name="current.rowlevel"    default="1">
			<!--- colspan for the field, only for row 2 and 3 --->
			<cfparam name="current.colspan"     default="1">
			<cfparam name="current.processmode" default="">
		
			<cfif (current.display eq "Yes" or current.display eq "1") and current.rowlevel eq rowshow>
													
				<cfset colspan = current.colspan>
							
				<cfparam name="last2nd" default="">	
									
				<cfif rowshow eq "2" and last2nd eq current.label>
						   
				   <!--- fill the cols of the second row --->
				   <!--- <cfset colspan = col - (cols2nd-current.colspan) +1> This formula didn't work - Nery Nov 29th '11--->
		   		   <!--- +1 added for the last column annotation --->
				   <cfset colspan = cols2nd-current.colspan> 
				   
				</cfif>		
				
				<cfparam name="last3rd" default="">	
				
				<cfif rowshow eq "3" and last3rd eq current.label>		
							
				   <!--- fill the cols of the second row --->
				    <cfset colspan = cols3rd-current.colspan> 
					<!---
				   <cfset colspan = col - (cols3rd-current.colspan)>		   
				   --->
				   <!--- +1 added for the last column annotation --->		   
				</cfif>
				
			    <cfset cnt = cnt+1>
														
				<cfparam name="current.formatted"      default="#current.field#">						
				<cfparam name="current.functionscript" default="">
				<cfparam name="current.drilltemplate"  default="">
				<cfif current.formatted eq "">
					<cfset current.formatted = "#current.field#">
				</cfif>
				<cfparam name="current.align" default="left">							
						
				<!--- edit field:  and evaluate(accesslevel) gte "1" --->		
				
				<cfif current.processmode neq "" and current.processtemplate neq "" >
						  
						<cfparam name="current.processstring" default="">
				
						<td align="#current.align#" style="#current.style#;padding-right:5px;padding-left:3px">										
						
						<cfif current.processmode eq "text">
						
							<CFSET hascontent="Yes">
						
							<cfif url.ajaxid eq "content">	
																				
								<input type="input" style="width:#current.width*10#" 
								   id="#current.field#_#dkey#" 
								   value="#evaluate(current.field)#" 
								   class="regular" 
								   onchange="processrow('#current.processtemplate#','#dkey#','#current.processstring#',this.value)">				 
							
							<cfelse>
							
								<script>							    				 
									se = document.getElementById('#current.field#_#dkey#')
									se.value = "#evaluate(current.field)#"							
								</script>  					
							
							</cfif>
						
						<cfelseif current.processmode eq "checkbox">
						
							<CFSET hascontent="Yes">
						
							<cfif url.ajaxid eq "content">	
							
								<cfif findNoCase(evaluate(current.field),current.processlist)>					
								<input type="checkbox" id="#current.field#_#dkey#" checked onclick="processrow('#current.processtemplate#','#dkey#','#current.processstring#',this.checked)">												
								<cfelse>					
								<input type="checkbox" id="#current.field#_#dkey#" <cfif evaluate(current.field) neq "">checked</cfif> onclick="processrow('#current.processtemplate#','#dkey#','#current.processstring#',this.checked)">												
								</cfif>										 
							
							<cfelse>
							
								<cfif current.processlist neq "">
							
									<script>							    				 
										se = document.getElementById('#current.field#_#dkey#')
										<cfif findNoCase(evaluate(current.field),current.processlist)>
										    se.checked = true
										<cfelse>
										    se.checked = false
										</cfif>
									</script>  
								
								<cfelse>
								
									<script>							    				 
										se = document.getElementById('#current.field#_#dkey#')
										<cfif evaluate(current.field) neq "">
										    se.checked = true
										<cfelse>
										    se.checked = false
										</cfif>
									</script> 					
								
								</cfif>						
							
							</cfif>
							
						<cfelseif current.processmode eq "radio">	
						
							<CFSET hascontent="Yes">
						
							<table><tr>						
								
								<cfset pcnt = "0">
																	
								<cfloop index="itm" list="#current.processlist#" delimiters=","> 
											
									<cfset pcnt = pcnt+1>									
									<cfset prc  = 1>
									
									<cfloop index="val" list="#itm#" delimiters="="> 
									
										<cfif url.ajaxid eq "content">
																							
											<cfif prc eq 1>		
														
												<td style="#current.style#;padding-bottom:2px">		
																											
												<input type    = "radio" 
												       name    = "#current.field#_#dkey#" 
												       style   = "height:14px;width:14px"
												       id      = "#current.field#_#dkey#_#pcnt#" <cfif evaluate(current.field) eq val>checked</cfif> 
													   onclick = "processrow('#current.processtemplate#','#dkey#','#current.processstring#','#val#')">
													
												</td>
												
											<cfelseif prc eq "2">																
											
												<td class="cellcontent" style="#current.style#;padding-left:5px;padding-right:4px">#val#</td>
												
											</cfif>	
																			
										<cfelse>	
										
											<cfif prc eq 1>									
										
												<script>											  	    				 
													se = document.getElementById('#current.field#_#dkey#_#pcnt#')
													<cfif evaluate(current.field) eq val>
													    se.checked = true
													<cfelse>
													    se.checked = false
													</cfif>
												</script>  
											
											</cfif>
																	
										</cfif>
										
										<cfset prc=prc+1>								
									
									</cfloop>
								
								</cfloop>	
								
								</tr>
							</table>			
							
						</cfif>	
							 
						</td>	
						
				<!--- presentation of the line --->			
						
				<cfelseif current.formatted eq "Class">		
				
					<CFSET hascontent="Yes">	
				
				    <!--- we set the class of the row --->
					
					<cfparam name="current.classlist" default="">
					<cfset setclass = "0">
					<cfset class="labelnormal">
									
					<cfloop list="#current.classlist#" index="rec" delimiters=",">
					
					  <cfloop index="itm" list="#rec#" delimiters="=">
								
							<cfif setclass eq "0">
													   				   
			   					<cfif evaluate(current.field) eq itm>						   
								       <cfset setclass = "1">					   
								</cfif>						   
	
							<cfelse>					
							
							  <cfset class  = "#itm#">
							  <cfset setclass = "0">
								  
							</cfif>   						   
							   
					   </cfloop>
							
					</cfloop>				
					<td>						
					<table height="20"><tr><td height="100%" bgcolor="0080C0" style="width:1px"></td></tr></table>									
					</td>
									
				<!--- rating box --->	
						
				<cfelseif current.formatted eq "Rating">	
				
						<CFSET hascontent="Yes">
				
						<cfparam name="current.ratinglist" default="">
						<cfset setcolor = "0">
						<cfset color = "white">
						 								
						<cfloop list="#current.ratinglist#" index="rec">	
									   									
						    <cfloop index="itm" list="#rec#" delimiters="=">
												   
							   <cfif setcolor eq "0">	
							   				   
			   					   <cfif evaluate(current.field) eq itm>						   
								        <cfset setcolor = "1">					   
								   </cfif>						   
		
								<cfelse>					
								
								    <cfset color  = "#itm#">
								    <cfset setcolor = "0">
									  
								</cfif>   						   
							   
							</cfloop>
											
						</cfloop>
										
					<cfif url.ajaxid eq "content">	
					<td align="center" colspan="#colspan#" class="#attributes.classcell#">
					    <table class="formpadding"><tr><td id="f#box#_#dkey#_#cnt#" width="8" height="10" style="border: 1px solid Gray; background-color:#color#;"></td></tr></table>
					</td>					
					<cfelse>
																								
						<script>								
							se = document.getElementById('f#box#_#dkey#_#cnt#')						
							se.style.backgroundColor = "#color#"						
						</script>  																
							
					</cfif>			
					
				<!--- standard content --->														
				
				<cfelseif cnt eq "1" and drilltemplate neq "" and drillkey neq "" and attributes.drillrow eq "No">
				
					<CFSET hascontent="Yes">
								
					 <cfif rowshow eq "1">
					 	 <cfset fontcolor = "##00000050">
					 <cfelse>
					 	 <cfset fontcolor = "##80808050">
					 </cfif>
											
					 <cfif url.ajaxid eq "content">																			
		
		<td <cfif currentalign neq "left">align="#current.align#"</cfif> class="#attributes.classcell#" <cfif colspan neq "left">colspan="#colspan#"</cfif> style="color:#fontcolor#;#current.style#"					   
		id="f#box#_#dkey#_#rowshow#_#cnt#" onclick="toggledrill('#drillmode#','box#dkey#','#drilltemplate#','#dkey#','#argument#','#drillbox#','#drillstring#')">#evaluate(current.formatted)#</td>					
		
					 <cfelse>
					 				
							<script language="JavaScript">																	
							se = document.getElementById('f#box#_#dkey#_#rowshow#_#cnt#')																		
							if (se) { 
							   try { 
							   
							    // _cf_loadingtexthtml='';														
								// first we set the value in a formfield that is is listingshow
								// document.getElementById('f#box#_fieldvalue').value = '#urlencodedformat(inner)#'												
								// output that value in doing a post on that form
								// ptoken.navigate('#session.root#/Tools/Listing/Listing/setValue.cfm?field=f#box#_fieldvalue','f#box#_#dkey#_#rowshow#_#cnt#','','','POST','mylistform')						 								
							    // se.className = "#class#" indicate it is updated 
								
								$('##'+'f#box#_#dkey#_#rowshow#_#cnt#').html('#inner#');
								
								} catch(e) {}	
							}											
							</script> 	
																																			
					 </cfif>
																					
				<cfelse>	
				
					<cfset cellstyle  = "">
					<cfset fontcolor = "">			
					<cfset inner = evaluate(current.formatted)>													 
					<cfif inner neq "" and current.functionscript neq "" and url.ajaxid eq "content"> <!--- somehow the inner would not work for a refresh --->
						
						 <cfparam name="current.functionfield" default="">
						 <cfif current.functionfield neq "">
							 							   
								<cfset cellclick = "#current.functionscript#('#evaluate(current.functionfield)#','#url.systemfunctionid#','#current.functioncondition#')">												
								
						 <cfelse>
							 							 	
							    <cfset cellclick = "#current.functionscript#('#evaluate(current.field)#','#url.systemfunctionid#','#current.functioncondition#')">
															
						 </cfif>	 
							  
					<cfelseif inner neq "" and current.drilltemplate neq "">
											 				 
						 	  <cfset cellstyle = "text-decoration: underline;">
							  <cfset cellclick = "toggledrill('embed','box#dkey#','#current.drilltemplate#','#evaluate(current.functionfield)#','','','')">	  
						 						  
					<cfelse>
					
							<cfif rowshow eq "1">								
							 	 <!--- no change ---> 
							 <cfelseif rowshow eq "2">						 
							 	 <!--- no change --->
							 <cfelseif rowshow eq "3">
							 	 <cfset cellstyle = "color:gray">							    
							</cfif>
						 					 	
						 	<cfset cellclick  = "">	 
							 
					</cfif>		 							   		   		   									
																					
					<cfif url.ajaxid eq "content">	
					
						<cfif rowshow gte "2" and len(inner) gte "2">
							<cfset hascontent = "Yes">															
						</cfif>		
																												
						<cfif colspan eq "1">		
							<cfif current.align eq "left">				
							<td id="f#box#_#dkey#_#rowshow#_#cnt#" class="#attributes.classcell#" style="#cellstyle#;#current.style#"><cfif cellclick neq ""><span onClick="#cellclick#"><a>#inner#</a></span><cfelse>#inner#</cfif></td>										
							<cfelse>
							<td id="f#box#_#dkey#_#rowshow#_#cnt#" class="#attributes.classcell#" style="#cellstyle#;#current.style#" align="#current.align#"><cfif cellclick neq ""><span onClick="#cellclick#"><a>#inner#</a></span><cfelse>#inner#</cfif></td>													
							</cfif>						
						<cfelse>					
							<td id="f#box#_#dkey#_#rowshow#_#cnt#" class="#attributes.classcell#" style="#cellstyle#;#current.style#" <cfif current.align neq "left">align="#current.align#"</cfif> colspan="#current.colspan#" onclick="#cellclick#"><cfif cellclick neq ""><a>#inner#</a><cfelse>#inner#</cfif></td>														
						</cfif>		
							
					<cfelse>	
									
						<!--- instead of showing we update the field in listingshow.cfm line 379 and then we display that info --->				   																		
					    <script language="JavaScript">																		
						
							se = document.getElementById('f#box#_#dkey#_#rowshow#_#cnt#')																																			
							if (se) { 	
																		
							   try {								   						    																				
								// first we set the value in a formfield that is is listingshow							
								// document.getElementById('f#box#_fieldvalue').value = '#urlencodedformat(inner)#'																			
								// output that value in doing a post on that form
								// _cf_loadingtexthtml='';								
								//ptoken.navigate('#session.root#/Tools/Listing/Listing/setValue.cfm?field=f#box#_fieldvalue','f#box#_#dkey#_#rowshow#_#cnt#','','','POST','mylistform')						 								
							    // se.className = "#class#" 				
								
								 $('##'+'f#box#_#dkey#_#rowshow#_#cnt#').html('#inner#');
								
								} catch(e) {}	
							}		
																
						</script> 									
																						
					</cfif>		
										
				</cfif>
							
			</cfif>	
			
		</cfloop>	
	
	</cfoutput>
