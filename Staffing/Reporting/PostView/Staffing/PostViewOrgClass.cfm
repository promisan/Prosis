   	
 <script language="JavaScript">
		
	function showclass() {
	
		se = document.getElementById("classExpand")
				
		if (se.className == "regular") {			
			document.getElementById("classExpand").className = "hide";
			document.getElementById("classMin").className = "regular";
			document.getElementById("orgunitclass").className = "regular";
		} else {
			document.getElementById("classExpand").className = "regular";
			document.getElementById("classMin").className = "hide";
			document.getElementById("orgunitclass").className = "hide";
		}			
	}
		
</script>
         
<cfset lvl = "1">  
   
<cf_treeUnitList
	 mission   = "#URL.Mission#"
	 mandateno = "#url.Mandate#"
	 role      = "'HROfficer','HRAssistant','HRPosition', 'HRLoaner', 'HRLocator','HRInquiry'"
	 tree      = "0">	
	 
<cfinclude template="PostViewHeader.cfm">		 
	 	 
   <cfif accesslist eq "" or accesslist eq "full">
         
		 <!--- ,orgunitclass --->
	   <cfloop index="Tbl" list="Mission" delimiters=",">
	   
	   <cfif tbl eq "Mission">
	     <cfset cl = "regular">
	   <cfelse>
	     <cfset cl = "hide"> 	 
	   </cfif>
	  		   
	   		   	   
	  	   
	   <cfquery name="SearchResult"
		   datasource="AppsQuery"
		   username="#SESSION.login#"
		   password="#SESSION.dbpw#">
		   SELECT     #tbl#, 
		              Class, 
					  PostGradeBudget, 
					  PostOrderBudget, 
					  ListOrder, 
					  ViewOrder, 
					  SUM(TotalCum) AS Total
					  
		   FROM       #SESSION.acc#Grade2_#FileNo# F
		   
		   WHERE 	  EXISTS (
						SELECT 'X'
						FROM   #SESSION.acc#Grade2_#FileNo#
						WHERE  Code             = F.Code
						AND    PostGradeBudget != 'SubTotal'
						AND    Class            = F.Class
						)
		  			
		   AND       Mission = '#url.mission#'  
		   GROUP BY  #tbl#, Class, ListOrder, ViewOrder, PostOrderBudget, PostGradeBudget	   
		   ORDER BY  #tbl#, ListOrder, ViewOrder, PostOrderBudget, PostGradeBudget 	   
	   </cfquery>
	              
	   <cfquery name="Count"
		 datasource="AppsQuery"
		 username="#SESSION.login#"
		 password="#SESSION.dbpw#">
		 SELECT     DISTINCT #tbl#
		 FROM       #SESSION.acc#Grade2_#FileNo#
	   </cfquery>
		   
	   <cfif count.recordcount gte "2" or tbl eq "Mission">
	   
	   <cfif Param.StaffingViewMode eq "Extended">				
			<cfset span="7">
		<cfelse>
			<cfset span="4">		
		</cfif> 
	      	
	   <cfoutput query="SearchResult" group="#tbl#">
	         
		   <cfif Class neq "" or tbl eq "Mission">
		                	           	 
			 <cfif Tbl eq "Mission">	
			 	 				
			    <tr class="<cfoutput>#cl#</cfoutput>" id="<cfoutput>#tbl#</cfoutput>">
				
			    <td style="height:100%;width:100%;padding-right:20px" valign="top" rowspan="#span#" class="labellarge">
							
					<table bgcolor="FDFEDE" style="width:100%;height:100%;height:80px">
					
					<tr>
					<td valign="top" style="padding-left:10px;padding-top:5px;border:1px solid silver;border-right:0px">
																	
					<img src="#session.root#/Images/Logos/Staffing/OrgUnit.png" 
						alt="Click to access classe under." height="60"
						id="classExpand" border="0" class="regular" 
						align="absmiddle" style="cursor: pointer; border : 0px solid silver;" 
						onClick="showclass()">
					
					<img src="#session.root#/Images/Logos/Staffing/OrgUnit.png" height="60"
						id="classMin" alt="Click to hide units" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer; border : 0px solid silver;" 
						onClick="showclass()">
					
					</td>
					<td valign="top" style="border:1px solid silver;border-left:0px;min-width:268px;max-width:268px;font-weight:200;width:100%;font-size:31px;padding-top:17px" class="labellarge">		
						#Mission#  			
					</td>
					</tr>
					
					</table>					
					 
				</td>
				
			 <cfelse>
			 			    
			    <tr class="<cfoutput>#cl#</cfoutput>" id="<cfoutput>#tbl#</cfoutput>">
				
				<td rowspan="#span#" class="cellcontent" style="min-width:268px;width:100%;padding-left:30px;font-size:30px;padding-right:20px">				 
				 #OrgUnitClass#
				</td>
				
			 </cfif>	
			 
			 <cfset row = 0>
			 	 	 
			 <cfoutput group="ListOrder">
			 
			 		<cfset row = row+1>			 
			 					 				  
					  <cfif ListOrder LE 4>
					  	<cfset fgc = "000000">
					  	<cfset bgc = "FFFFFF">
					  <cfelse>
					  	<cfset fgc = "FF5555">
					  	<cfset bgc = "FFF4F4">
					  </cfif>
					  
					   <td style="height:28px;font-size:12px;padding-left:2px;cursor:pointer;min-width:40;border-bottom:1px solid gray">
					  					  
					   <cfif Client.LanguageId eq "ESP">
					   
						  		<cfswitch expression="#Left(class, 1)#">
									   <cfcase value="A"> 
												A		
									   </cfcase> 
									   <cfcase value="N"> 
												N		
									   </cfcase> 
									   <cfcase value="I"> 
												O		
									   </cfcase> 
									   <cfcase value="V"> 
												V		
									   </cfcase> 
								</cfswitch>
								
						<cfelse>
						
							<cfswitch expression="#Left(class, 1)#">
								   <cfcase value="A"> 
											<a style="padding-left:2px" title="Budgeted Positions">EST.</a>	
								   </cfcase> 
								   <cfcase value="N"> 
											<a style="padding-left:2px" title="Non-staff Positions">NON.</font></a>		
								   </cfcase> 
								   <cfcase value="I"> 
											<a style="padding-left:2px" title="Incumbents">..Inc</a>		
								   </cfcase> 
								   <cfcase value="V"> 
											<a style="padding-left:2px" title="Vacant Positions">..Vac</a>		
								   </cfcase> 
								   <cfcase value="G"> 
											<a title="Extra budgetairy positions">XB</a>		
								   </cfcase> 
							</cfswitch>
						
						</cfif>						
					  
				       </td>				 			
					      
					  	  <cfoutput>
						  
					      <cfif ListOrder eq "1">
						      <cfset cl = "F1F1F1">
						  <cfelseif ListOrder eq "2">
						      <cfset cl = "F6F6F6">	  
						  <cfelseif ListOrder eq "3">	
						     <cfset cl = "EEF3E2">	 
						  <cfelseif ListOrder eq "4">	
						     <cfset cl = "FFFFCF">	  
						  <cfelseif ListOrder eq "5">	
						     <cfset cl = "FFF4F4">	  
						  <cfelseif ListOrder eq "5">	
						     <cfset cl = "FFF3E2">	  
						  <cfelse>
						     <cfset cl = "FFE0E0">	 
					      </cfif>		
						  			  
						  <cfif PostGradeBudget eq "Total" or PostGradeBudget eq "Subtotal">
						  
						     <cfif Total eq "0" or Total eq "">
								  <cfset clt = "ffffff">
							 <cfelse>
							      <cfset clt = "EEFDF1">
							 </cfif>	
							    
							 <td align="center" bgcolor="#clt#" style="font-size:14px;border:1px solid gray;min-width:#cellspace#px">
							 
						   		<cfif Total gt "0">
									<font color="#fgc#">#Total#</font></td>
								<cfelse>
											
								</cfif>
							  </td>
							  
						  <cfelse>
						  
						     <td align="center" bgcolor="#cl#" style="font-size:14px;border:1px solid gray;min-width:#cellspace#px">	
									 
						       <cfif Total gt "0">
							 	  <font color="#fgc#">#Total#</font></td>
							   <cfelse>
							   	  
							   </cfif>
						     </td>
							 
						  </cfif>
						  		 
						  </cfoutput>
			  

					  </tr>
				  
				  </cfoutput>
					
			</cfif>
			
		</CFOUTPUT>
		
		</cfif>
		
	</cfloop>
		
</cfif>	