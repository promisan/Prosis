

<cfoutput>

		<cfset vTextStyle       = "color:##FAFAFA; font-size:14px;">		      
		
	
		<cfif Actions.ActionFlowOrder lte CheckNext.ActionFlowOrder or CheckNext.ActionFlowOrder eq "">
		
			<cfif ActionStatus eq "1">
				<cfset cl = "##F7FFCF">
				<cfset action = "1">
				<cfset box = "##FAC87D">
													
			<cfelseif (ActionStatus eq "2" or Attributes.DocumentStatus eq "9") and EnableQuickProcess eq "0">
			    <cfset cl = "">
				<cfset box = "rgba(174, 192, 108,0.6)">
				<cfset action = "0">	
										
			<cfelseif ActionStatus eq "2Y">
			    <cfset cl = "">
				<cfset box = "rgba(174, 192, 108,0.6)">			
				<cfset action = "0">	
                    
                <cfif currentrow eq "1"><!--- Approved Final --->
                    <cfset box = "rgba(174, 192, 108,1)">			
                </cfif>
                    
           <cfelseif ActionStatus eq "2N">
               
			    <cfset cl = "">
				<cfset box = "rgba(205, 57, 57,0.8)">			
				<cfset action = "0">	
                    
                <cfif currentrow neq "1"><!--- skip --->
                    <cfset box = "rgba(129, 168, 145,0.7)">			
                </cfif>
                    
			<cfelseif NextAction.ActionFlowOrder eq "" 
			     and FirstDue.ActionFlowOrder eq ActionFlowOrder>
				 
				<cfset cl = "##FFEBCF">
				<cfset box = "##D35400">
				<cfset action = "1">               
               						
			<cfelseif (NextAction.ActionFlowOrder eq ActionFlowOrder or Concurrent.ActionParent eq ActionParent) and ActionStatus neq "2">
						
				<cfset cl = "##f4f4f4">
				<cfset box = "##EDB800">
				<cfset action = "1">
					
			<cfelseif NextAction.ActionFlowOrder eq ActionFlowOrder
						and ActionStatus eq "2"
						and EnableQuickProcess eq "1">
																			
				<cfset cl = "##f4f4f4">
				<cfset box = "##F5D76E">
				<cfset action = "1">	
				
			<!---	
								
			<cfelseif ActionType eq "Decision">
			    <cfset cl     = "">
				<cfset box    = "4ED4CA">
				<cfset action = "0">
				
			--->
								
			<cfelseif ActionStatus eq "9">
			
			    <cfset cl     = "">
				<cfset box    = "##87C6BB">
				<cfset action = "1">	
			
			<cfelse>	
			
			    <cfset cl     = "ffffff">
				<cfset box    = "rgba(174, 192, 108,0.6)">
				<cfset action = "0">				
								
			</cfif>			
			
		<cfif ActionStatus eq "0" 
			   or ActionStatus eq "1" 
			   or EnableQuickProcess eq "1">
			  													
				 <cfinvoke component = "Service.Access"  
					method         =   "AccessEntity" 
					objectid       =   "#ObjectId#"
					actioncode     =   "#ActionCode#" 
					mission        =   "#attributes.mission#"
					orgunit        =   "#Attributes.OrgUnit#" 
					entitygroup    =   "#EntityGroup#" 
					returnvariable =   "entityaccess">		
														
				 <cfset reopenAccess = entityAccess>							
				
			<cfelse>
			
				<cfif currentrow eq "1">
			
					<cfinvoke component = "Service.Access"  
						method         =   "AccessEntity" 
						objectid       =   "#ObjectId#"
						actioncode     =   "#ActionCode#" 
						mission        =   "#attributes.mission#"
						orgunit        =   "#Attributes.OrgUnit#" 
						entitygroup    =   "#EntityGroup#" 
						returnvariable =   "entityaccess">	
						
					<cfset reopenAccess = entityAccess>		
														
				</cfif>
			
			  	 <cfset EntityAccess = "NONE">	
				
			</cfif>	
			
			<cfif attributes.allowProcess eq "No">
				<cfset EntityAccess = "NONE">	
			</cfif>
			
			<cfif actionStatus gte "2">
			
			 <cfif actionCompletedColor neq "Default">
			    <cfset box = actionCompletedColor>		 
			 </cfif>
			
			</cfif>
																									
			<tr bgcolor="#cl#">
						   				
				<cfset ht = attributes.rowheight - 10>
				
				<cfif attributes.subflow eq "No" and showaction eq "1">
				
					<cfset ln = "5">														
                    <td>
														
				<cfelse>
	
					<cfset ln = "2">							
                    <td align="right" style="height:30px">
																			
				</cfif>
									
					<table style="width:100%">
																														
					<cfif Action eq "1" and (EntityAccess eq "EDIT" OR EntityAccess eq "READ")>
					
					 <cfset vSquareStyle     = "padding:0px 0 0;border-radius:8px 0 0 8px;max-width:100%">		  
										
						<cfif attributes.hideprocess eq "0" and ActionTrigger eq "">
						    <cfif attributes.subflow eq "No">
						    <cfset pr = "javascript:process('#ActionId#','#attributes.preventProcess#','#attributes.ajaxid#','#ProcessMode#')">
							<cfelse>												
							<cfset pr = "javascript:process('#ObjectId#','#attributes.preventProcess#','#attributes.ajaxid#','#ProcessMode#')">							
							</cfif>
						<cfelse>
						    <cfset pr = "">
						</cfif>
						
						<!--- correction --->
						<cfif EntityAccess eq "READ">
						   <cfset pr = "">
						</cfif>
						
						<cfif attributes.subflow eq "Yes">
							<cfset box = "silver">
						</cfif>
						
						<cfparam name="ActionCompleted" default="">
						<cfparam name="ActionDenied" default="">
						
						<cfquery name="Dialog" 
							 datasource="AppsOrganization"
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">
							 	SELECT *
								 FROM  Ref_EntityDocument D
								 WHERE EntityCode  = '#EntityCode#' 
								 AND   DocumentCode = '#ActionDialog#'
						</cfquery>													
													
							<tr style="background-color:E17100;height:25px">
																							
								<cfparam name="ActionProcess" default="Do it">
								
								<cfset proctext = "#ActionProcess#">
								<cfif proctext eq "">
									<cfset proctext = "Do it">
								</cfif>
								
								<cfoutput>  
								
								 <cfif EnableQuickProcess eq "1">
								 
								 	<cfif ActionStatus eq "0" and EntityAccess eq "EDIT" and Action eq "1">		
												 
										<td id="quick#ActionId#" name="quick#ActionId#">				
										<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and object_op is 1>		
											<input type="checkbox" class="radiol" name="confirmwf" id="confirmwf" style="display:none;" value="#ActionId#" checked onclick="toggleaction('#ActionId#')">		
										    <a id="d#ActionId#" href="javascript:submitwfquick('#ActionId#','#attributes.ajaxid#')">#ActionDescription#</a>  			
										 </cfif>		
									 	</td>		
										
									</cfif>
									
								 <cfelse>
								  				
									 <cfif object_op is 1 and Action eq "1" and (EntityAccess eq "EDIT" or EntityAccess eq "READ")>	 			
									 
										 <td align="center">			 		
											<cfif attributes.hideprocess eq "0" and actionTrigger eq "" and showaction is 1>		
											    <cfif Dialog.DocumentMode eq "Popup" and DisableStandardDialog eq "1" >				
												   <cfif EntityAccess eq "EDIT">
													  <a href="javascript:#Dialog.DocumentTemplate#('#ActionCode#','#ActionId#')"><font color="FFFFFF">#ActionDescription#</a>
													</cfif>   															
												<cfelse>				
													<cfif Attributes.Subflow eq "No">
														<a href="javascript:process('#ActionId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')"><font color="FFFFFF">#ActionDescription#</a>
													<cfelse>														   						
														<a href="javascript:process('#ObjectId#','#attributes.preventProcess#','#Attributes.ajaxid#','#ProcessMode#')"><font color="FFFFFF">#ActionDescription#</a>							   
													</cfif>	   								 										
												</cfif>	
											</cfif>
										 </td>	                       
									  </cfif>
								
								  </cfif> 
									  
								</cfoutput>
															
							</tr>
																
					<cfelse>
					
						<cfset vSquareStyle     = "padding:5px 0 0;border-radius:8px;max-width:95%">   
					
						<cfif ActionDialogContent neq "">
						    <cfset pr = "javascript:actionlog('#ActionId#')">
						<cfelse>
						    <cfset pr = "">
						</cfif>		
						
						<cfif box eq "C7FECB">
							<cfset boxend = "##77C97D">
						<cfelseif box eq "##C9EDF1">
							<cfset boxend = "##7DC9D1">
						<cfelse>
							<cfset boxend = "gray">
						</cfif>							
					
						<tr><td style="max-width:360px;background-color:#boxend#;cursor: pointer;color:white;" align="center">		
																																			
																
								<cfparam name="ActionCompleted" default="">
								<cfparam name="ActionDenied" default="">
								
								<cfif actionStatus eq "2Y" and ActionCompleted neq "">
								#ActionCompleted#
								<cfelseif actionStatus eq "2" and ActionCompleted neq "">
								#ActionCompleted#
								<cfelseif actionStatus eq "2N" and ActionDenied neq "">
								#ActionDenied#
								<cfelse>
								#ActionDescription#
								</cfif>
								
								<!---																											
													
								<table width="100%" height="100%" onClick="#pr#"
									 style="max-width:360px;<cfif pr neq "" or SESSION.isAdministrator eq 'Yes'>cursor: pointer;</cfif> background-color:#box#; #vSquareStyle#;"
									 ondblClick="<cfif SESSION.isAdministrator eq "Yes">javascript:stepedit('#Actions.EntityCode#','#Actions.EntityClass#','#Actions.ActionPublishNo#','#ActionCode#')</cfif>">
										<tr>
											<td style="min-width:5px"></td>
											<td align="center" class="labelmedium" style="width:100%;font-size:14px;line-height:14px;cursor: pointer;color:rgba(0,0,0,0.7);font-weight:400;text-transform: capitalize;">
																																												
											<cfparam name="ActionCompleted" default="">
											<cfparam name="ActionDenied" default="">
											
											<cfif actionStatus eq "2Y" and ActionCompleted neq "">
											#ActionCompleted#
											<cfelseif actionStatus eq "2" and ActionCompleted neq "">
											#ActionCompleted#
											<cfelseif actionStatus eq "2N" and ActionDenied neq "">
											#ActionDenied#
											<cfelse>
											#ActionDescription#
											</cfif>
											
											</td>											
											<td style="min-width:5px"></td>
										</tr>
								</table>
								
								--->
							
						</td>
						</tr>
						
					</cfif>
															
					<!--- line connecting --->
										
					</table>
																	
				</td>		
												
			</tr>	
										
		</cfif>	
					
</cfoutput>

