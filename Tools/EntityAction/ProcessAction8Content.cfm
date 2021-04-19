<table width="100%" height="100%">
	
	<tr><td colspan="2" style="padding-left:15px;padding-right:15px;">
   	
	<table width="100%" height="100%">
		
	<cfparam name="URL.Mode" default="">	
	<cfparam name="url.id"  default="{00000000-0000-0000-0000-000000000000}">
		
	<cfif Action.recordcount eq "0">
		<cf_message text="Problem, please contact your administrator">
		<cfabort>
	</cfif>
	
	<cfoutput query="action">	
			
	  <cfif ActionReferenceShow eq "1"> 
				   
		  <tr><td style="background-color:white" colspan="2" valign="top">		
		  <table width="100%" align="center">
			  
		    <!--- Element 1b of 3 about --->	
														   
			    <tr class="labelmedium line" style="background-color:white">
				
				<cfquery name="Person" 
					datasource="appsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	
				    SELECT    *
					FROM      Person
					WHERE     PersonNo = '#Object.PersonNo#'						
				</cfquery>
				
				<cfif Person.recordcount eq "1">
				
					 <cfquery name="Person" 
							datasource="appsEmployee" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">	
						    SELECT    *
							FROM      Person
							WHERE     PersonNo = '#Object.PersonNo#'						
					</cfquery>
				
					<td style="width:70px" style="background-color:white;font-size:16px;padding-left:10px">
						
						  <cfset size = "60px">
						  <cfset pict = "">    
						  
						  <!---	removed to isolate performance issue 					  			   
						  <cfif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Person.IndexNo#.jpg") and indexNo gt "0"> 						                            		
								<cfset pict = Person.IndexNo>     				    
						  <cfelseif FileExists("#SESSION.rootDocumentPath#\EmployeePhoto\#Person.Personno#.jpg")>   						  
								<cfset pict = Person.Personno>	   				  						   
						  </cfif>
						  --->
						  						  
						  <cfif FileExists("#SESSION.rootPath#\CFRStage\EmployeePhoto\#Person.IndexNo#.jpg") and indexNo gt "0"> 						                            		
								<cfset pict = Person.IndexNo>     				    
						  <cfelseif FileExists("#SESSION.rootPath#\CFRStage\EmployeePhoto\#Person.Personno#.jpg")>   						  
								<cfset pict = Person.Personno>	   				  						   
						  </cfif>
						  
						  <cfif pict neq "">	
						  
						    <!--- 
						    <cffile action="COPY" 
							    source="#SESSION.rootDocumentpath#\EmployeePhoto\#vPhoto#.jpg" 
				  		    	destination="#SESSION.rootPath#\CFRStage\EmployeePhoto\#vPhoto#.jpg" nameconflict="OVERWRITE">
								
								--->
												
					  		  <cfset vPhoto = "#SESSION.root#\CFRStage\EmployeePhoto\#pict#.jpg">						
						  					  
						  <cfelse>												
						  						  			  					  
							  <cfif Person.Gender eq "Female">
								  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-female.png">
							  <cfelse>
								  <cfset vPhoto = "#session.root#/Images/Logos/no-picture-male.png">
							  </cfif>					  
							  
						  </cfif>	
						  						  						  			 
						  <img src="#vPhoto#" class="img-circle clsRoundedPicture" style="height:#size#; width:#size#;">
						 
													
					</td>
					<td style="background-color:white;padding-bottom:4px" valign="bottom">			
						
						<table width="100%">
							<tr class="labelmedium">
							<td style="font-size:18px;background-color:white">
							#Person.FirstName# #Person.LastName# (#Person.Gender#)
							<cfif Person.IndexNo neq "">
							<span style="font-size:14px"><br>IndexNo ## #Person.IndexNo#</span>
							</cfif>
							<cfif Object.ObjectReference2 neq ""><br><span style="font-size:14px">#Object.ObjectReference2#</span></cfif>
							</td>					
							<td align="right" style="background-color:white">
							
								<cfif getAdministrator("#Object.Mission#") eq "1">
							
								<img src="#SESSION.root#/Images/Workflow-Methods.png"
									 alt="Show Workflow"
									 border="0"
									 width="32"
									 height="32"
									 align="absmiddle"
									 valign="center"
									 style="cursor: pointer;"
								     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
									 
								</cfif>	 
									 
							 </td>
							</tr>
						</table>
						
					</td>
								
				<cfelse>
				
				    <td height="34" width="24%" style="background-color:white;font-size:16px;padding-left:10px">#Object.EntityDescription#:</td>
					<td style="background-color:white">			
					
						<table width="100%">
							<tr class="labelmedium">
							<td style="font-size:16px;background-color:white">
							#Object.EntityClassName# /
							#Object.ObjectReference# <cfif Object.ObjectReference2 neq "">(#Object.ObjectReference2#)</cfif>
							</td>					
							<td align="right" style="background-color:white">
							
								<cfif getAdministrator("#Object.Mission#") eq "1">
							
									<img src="#SESSION.root#/Images/Workflow-Methods.png"
										 alt="Show Workflow"
										 border="0"
										 width="32"
										 height="32"
										 align="absmiddle"
										 valign="center"
										 style="cursor: pointer;"
									     onClick="workflowshow('#Object.ActionPublishNo#','#Object.EntityCode#','#Object.EntityClass#','#ActionCode#','#Object.ObjectId#')">
										 
								</cfif>	 
									 
							 </td>
							</tr>
						</table>
						
					</td>
					
				</cfif>
			   </tr>	
			   
		  </table>
		  </td></tr> 	
			  
	   </cfif>	
	
	</cfoutput>
	
	<cfset processhide = "No">
	<cfset showProcess = "1">
	<cfset def         = "0">	
			
	<tr class="line">
	<td valign="top" colspan="2" height="30" id="menutabs">	
		<table width="100%">
		<tr>		
			<cfset menumode = "menu">
			<cfinclude template="ProcessAction8Tabs.cfm">
			<td width="10%"></td>			
	    </tr>
		</table>	
	</td></tr>
		
	<tr><td height="100%" valign="top" style="border:0px solid silver">
		<table width="100%" height="100%">				
		<cfset menumode = "content">
		<cfinclude template="ProcessAction8Tabs.cfm">
		</table>		
	</td></tr>
	
</table>

</td></tr>

</table>

