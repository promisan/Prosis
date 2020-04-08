
<table border="0" align="center" width="100%" height="100%">

	<tr><td colspan="<cfoutput>#tblr#</cfoutput>" valign="top">

		   <table width="100%" cellspacing="0" cellpadding="0">
		      
			   <tr>
			  
			   <td style="height:30px;padding-left:13px;padding-top: 4px;" class="labelit">
									
					<cfoutput><cf_tl id="Matrix was cached, it was last updated on">: 
					
					<a href="javascript:reloadroster()">
					<font size="3" color="0080C0">
					<b>#dateformat(now(),CLIENT.DateFormatShow)# #timeformat(now(),"HH:MM")#</b>&nbsp;&nbsp;&nbsp;-&nbsp;&nbsp;<cf_tl id="Press to refresh">
                    <img height="18" width="18" align="absmiddle" style="position:relative;top:-2px;" src="#SESSION.root#/Images/Refresh-Orng.png" alt="Refresh" border="0"></a>
					</cfoutput>										
				
				</td>
				
				<td align="right">
				
				
				</td>
			  </tr>
				 
		  </table>		  
		  </td>
   </tr>
   
   <tr><td height="5">
   	   	  
	<cfinclude template="RosterViewHeader.cfm">
	
	</td></tr>
	   
	<cf_tl id="Add bucket" var="1">
	<cfset tAddRosterBucket = "#Lt_text#">
	   
	<cf_tl id="Summary" var="1">
	<cfset tSummary = "#Lt_text#">
	
	 <!--- check if user has any access --->
						
	 <cfinvoke component = "Service.Access"  
   	 	 method          = "Roster" 	  	 
	     Role            = "'AdminRoster'"														 
   		 Owner           = "#URL.Owner#"
		 returnvariable  = "AccessBucket">	
		 
	 <cfquery name="check"
		   datasource="AppsQuery"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT DISTINCT description
		   FROM  dbo.#SESSION.acc#RosterViewL#FileNo# V 
		   WHERE Total is not NULL
	   </cfquery>	
	 	 
	<cfif check.recordcount gte "20">
        <cfset list = "T,L">
	<cfelse>
		<cfset list = "T">		
	</cfif>	 
	
	<tr style="vertical-align:top;"><td colspan="<cfoutput>#tblr#</cfoutput>" valign="top" height="100%">
	
	<cf_divscroll overflowy="scroll">
	
	<table width="97%" height="100%" align="center">
	   
	<cfloop index="Tbl" list="#list#" delimiters=",">
				
	   <cfquery name="SearchResult"
		   datasource="AppsQuery"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT * 
		   FROM  dbo.#SESSION.acc#RosterView#Tbl##FileNo# V 		  
		   WHERE Total is not NULL
	   </cfquery>	  
	   
	   <cfif SearchResult.recordcount lte "10">
	   
		   <!--- 13/5/2016 this is likely a start-up roster so we need to show data at least --->
		   
		   <cfquery name="SearchResult"
			   datasource="AppsQuery"
			   username="#SESSION.login#"
			   password="#SESSION.dbpw#">
			   SELECT * 
			   FROM  dbo.#SESSION.acc#RosterView#Tbl##FileNo# V 		  		  
		   </cfquery>	
	   
	   </cfif>
	   	   	   		 	      
	   <cfif SearchResult.recordcount lt "1" and Tbl eq "T" and (AccessBucket eq "EDIT" or AccessBucket eq "ALL")>
	   
			<cfoutput>
			  <tr><td colspan="#tblr#" align="left" colspan="4" style="height:35px" class="labelmedium">			   
				   <a href="javascript:recordadd('','','','','','','','','#url.edition#')">
				   <font color="0080C0"><cf_tl id="Add a bucket"></font></a>				  
				 </td>
			  </tr>
			</cfoutput>			
	   
	   </cfif>
	  	   
	   <cfoutput query="SearchResult">
	   	   
	   <cfset sp = "0"> 		
						           	 
		<cfif Tbl eq "T">	
			
			<cfset occ = "roster">				
					
			<cfif check.recordcount gte "20">
						
				<tr> 
				<td width="20" valign="bottom" style="padding-bottom:4px">
			
			       <cfif Total lte "100" or Tbl neq "T">				 
				   
					<img src="#SESSION.root#/Images/portal_max.jpg" alt="See buckets" 
						id="d#Occ#Exp" 
						border="0" 
						align="absmiddle" class="regular" style="cursor: pointer;" 
						onClick="listing('#occ#','show','only','','','#URL.Status#','','#url.exerciseclass#')">
						 
					<img src="#SESSION.root#/Images/portal_min.jpg" 
						id="d#Occ#Min" alt="Hide buckets" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="listing('#occ#','hide','only','','','#URL.Status#','','#url.exerciseclass#')">
						
					</cfif>	
									
				</td>
			   	
				<cfif Total lte "100" or Tbl neq "T">
			    <td style="cursor:pointer;height:40px" valign="bottom" class="labellarge" onClick="listing('#occ#','show','only','','','#URL.Status#','','#url.exerciseclass#')">	
				#tSummary#</font>
				</td>		
				<cfelse>
				<td>	
				</cfif>						
			    
				</td>	

				</tr>			
			</cfif>	
			
		<cfelse>
		 
		 	<tr>
		 
		    <cfset occ = OccupationalGroup>		
			
			<td width="20" valign="bottom" style="padding-bottom:4px">
		
		       <cfif Total lte "100" or Tbl neq "T">
			   
				<img src="#SESSION.root#/Images/portal_max.jpg" alt="See buckets" 
					id="d#Occ#Exp" 
					border="0" 
					align="absmiddle" class="regular" style="cursor: pointer;" 
					onClick="listing('#occ#','show','only','','','#URL.Status#','','#url.exerciseclass#')">
					 
				<img src="#SESSION.root#/Images/portal_min.jpg" 
					id="d#Occ#Min" alt="Hide buckets" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="listing('#occ#','hide','only','','','#URL.Status#','','#url.exerciseclass#')">
					
				</cfif>	
								
		    </td>
		 
			<cfif Total lte "100" or Tbl neq "T">
		   	    <td width="95%" valign="bottom" class="labelmedium" style="cursor:pointer;height:40px" onClick="listing('#occ#','show','only','','','#URL.Status#','','#url.exerciseclass#')">			
			<cfelse>
				<td width="95%" valign="bottom" class="labelmedium">	
			</cfif>
			<b>#Description#</b>
			</td>
			
			</tr>
		</cfif>	
		
		
		
		<tr style="vertical-align:top; height:0;">
		 		 
		<td align="right" colspan="2">
						 
		 <table width="100%" align="right" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		 		 	  
			<tr>
			
			      <td style="width:100%;border:1px solid silver;padding-left:8px" class="labelmedium"><cf_space spaces="36"><cf_tl id="Roster Buckets"></td>
				   
	 	  	      <td align="right" style="border:1px solid silver">
				  				  				 				 				    				
					 <cfset sp = "24">					 
										 
					 <cfif Total neq "">
					 	 <cf_space spaces="#sp#" class="labelmedium" padding="0" align="right" label="#numberformat(Total,'_,_')#&nbsp;">								
					 <cfelse>
					     <cf_space spaces="#sp#" class="labelmedium" padding="0" align="right" label="">							
					 </cfif>				
			      </td>
			    
			      <cfloop index="item" from="1" to="#Resource.RecordCount#" step="1">
				  
				  		<cfif Evaluate("Grade_" & item) neq "">
							<cfset cl = "1">
						<cfelse>
						    <cfset cl = "0">
						</cfif>	
						
				  		<cfif find("-"&item&"-", SubT)>
						
						    <cfif cl eq "1">
							
								<td align="right" 								
								id="cl#Occ#"
								style="cursor: pointer;border:1px solid silver" 
								onClick="javascript: listing('#Occ#','show','all','#columnParent[item]#','subtotal','#URL.Status#',this,'#url.exerciseclass#')">
								
							<cfelse>
							
								<td align="right" style="border:1px solid silver">							
													
							</cfif>
													
							<cfset sp = "20">											 
														
							<cfif Evaluate("Grade_" & item) neq "">
								<cf_space spaces="#sp#" class="labelmedium" padding="0" align="right" label="#numberformat(Evaluate('Grade_' & item),'_,_')#&nbsp;">
							<cfelse>
								<cf_space spaces="#sp#" class="labelmedium" padding="0" align="right" label="">
							</cfif>
								
						<cfelse>
						
							<cfif cl eq "1">
						
							<td align="right" style="border:1px solid silver" style="cursor: pointer" id="cl#Occ#"
							onClick="listing('#Occ#','show','all','#column[item]#','grade','#URL.Status#',this,'#url.exerciseclass#')"> 	
							
							<cfelse>
							
							<td align="right" style="border:1px solid silver"> 					
							
							</cfif>
							
							<cfset sp = "16">					 
							 						
							<cfif Evaluate("Grade_" & item) neq "">
								<cf_space spaces="#sp#" class="labelmedium" padding="0" align="right" label="#numberformat(Evaluate('Grade_' & item),'_,_')#&nbsp;">
							<cfelse>
								<cf_space spaces="#sp#" class="labelmedium" padding="0" align="right" label="">
							</cfif>
							
						</cfif>
										
					</td>
			      </cfloop>
						  
			  </tr>
			  
			  <cfquery name="Status" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">				
					SELECT   *
					FROM     Ref_StatusCode
					WHERE    Owner = '#URL.Owner#'
					AND      Id = 'FUN'
					AND      ShowRoster = '1'
					ORDER BY Status
			 </cfquery>
			 
			 <cfset statusList = "">
			 
			 <cfloop query="Status">
			 
			    <!--- check if user has access --->
								
				<cfparam name="access_#Status#" default="">
				
				<cfif evaluate("Access_#status#") eq "">
								
					<cfinvoke component="Service.Access.Roster"  
			   	 	 method         = "RosterStep" 
				  	 returnvariable = "access_#Status#"
				     Status         = "#Status#"												
					 Process        = "Search"
			   		 Owner          = "#URL.Owner#">	
			
				</cfif>	
				 
			   <cfif evaluate("Access_#status#") eq "1">	 
			 
				   <cfif statusList eq "">
				       <cfset statusList = "#Status#">
				   <cfelse>
				       <cfset statusList = "#StatusList#,#Status#">
				   </cfif>
				   
			   </cfif>	   
			   
			 </cfloop>
			  
			  <!--- initial tracks --->
			  
			  <cfloop index="st" list="#statusList#" delimiters=",">
			  
			 	 <cfquery name="Get" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_StatusCode
					WHERE  Owner  = '#URL.Owner#'
					AND    Id     = 'FUN'
					AND    Status = '#st#'
				  </cfquery>
			  
				  <cfset cl   = "#Get.ShowRosterColor#">
				  <cfset ac   = "#Get.TextHeader#">
				  <cfset tool = "#Get.Meaning#">
									  
		          <tr bgcolor="#cl#" class="labelmedium">
				  
				     <td width="40" bgcolor="f4f4f4" style="border:1px solid silver;padding-left:8px">
						 <table>
						 <tr class="labelmedium">
						 <td>#ac#<cf_space spaces="10"></td>
						 <td style="border-left:1px solid silver;padding-left:4px">#get.Meaning#<cf_space spaces="40"></td>
						 </tr>
						 </table>
					 </td>						  
		 		     <td align="right" bgcolor="E6EFD6" style="border:1px solid d3d3d3">
									
					   <cfif Evaluate("Total" & st) neq "">					  
							#numberformat(Evaluate("Total" & st),'_,-')#&nbsp;
							<cfelse>-
						</cfif>
							 	  
		    	     </td>
				      			  	  
				     <cfloop index="item" from="1" to="#Resource.RecordCount#" step="1">
					  
					  		<cfif evaluate("Grade" & st & "_" & item) neq "">
								<cfset cl = "1">
							<cfelse>
							    <cfset cl = "0">
							</cfif>	
				  
					   		 <cfif find("-"&item&"-", SubT)>
							 
							 	 <cfif cl eq "1">	
													
								<td align="right" bgcolor="E6EFD6" id="cl#Occ#"
									style="border:1px solid silver;cursor: pointer;padding-right:4px" 
									onClick="javascript: listing('#Occ#','show','all','#columnParent[item]#','subtotal','#URL.Status#',this,'#url.exerciseclass#')">
								
								<cfelse>
								
									<td align="right" style="border:1px solid silver;padding-right:4px"	bgcolor="E6EFD6">								
								
								</cfif>
								
							<cfelse>
							
								 <cfif cl eq "1">	
							
								<td align="right" style="border:1px solid silver;cursor: pointer;padding-right:4px"
								id="cl#Occ#" onClick="javascript: listing('#Occ#','show','all','#column[item]#','grade','#URL.Status#',this,'#url.exerciseclass#')"> 	
								
								<cfelse>
								
								<td align="right" style="border:1px solid silver;padding-right:4px"> 
								
								</cfif>
								
							</cfif>
					 			    
							<cfif Evaluate("Grade" & st & "_" & item) neq "">							
							#numberformat(Evaluate("Grade" & st & "_" & item),'_,_')#
							<cfelse>
							</cfif>
							
						</td>
			          </cfloop>
			      			 
		       </TR> 
		   
		   </cfloop>
		      	   	   	     	  	   
		</table>
		
		</td>   
		
		</tr>
		
		<cfif check.recordcount gte "20">
		
			<tr class="hide" id="d#Occ#" colspan="2">
				<td colspan="#tblr#" id="i#Occ#" style="padding-top:15px;">		
			</td>
			</tr>
			
		<cfelse>
		
			<tr class="regular" id="d#Occ#" colspan="2" style="vertical-align:top;">
				<td colspan="#tblr#" id="i#Occ#" style="padding-top:15px;"></td>
			</tr>
			
			<script>
				listing('#occ#','show','only','','','#URL.Status#','','#url.exerciseclass#')			
			</script>
		
		</cfif>	
					 		
	</CFOUTPUT>
			
	</cfloop>
		
	</table>
	
	</cf_divscroll>
	
	</td></tr>
	
	</table>
	
