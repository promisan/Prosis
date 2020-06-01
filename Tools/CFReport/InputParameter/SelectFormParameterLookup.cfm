
<!---  23/2/2012

- If criteriarole = 1 AND name = 'mission' AND report has one or more roles defined
    - Define all the missions a user has access to based on the roles defined for this report and put this into a variable
    - use this variable to filter the dropdown/multi-select
--->	


<cfif SESSION.isAdministrator eq "Yes">

	<cfset missionaccessfilter = "">	

<cfelse>	

	<cfif CriteriaRole eq "1" and CriteriaName eq "mission">

			<cfquery name="getRoles"
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT  *
				FROM    Ref_ReportControlRole
				WHERE   ControlId = '#url.controlid#' 				
			</cfquery>			
			
			<cfif getRoles.recordcount gte "1">
			
				<cfquery name="getMission"
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT  DISTINCT Mission
					  FROM    Organization.dbo.OrganizationAuthorization A
					  WHERE   Role IN
					            (SELECT  Role
					             FROM    Ref_ReportControlRole
					             WHERE   ControlId = '#url.controlid#'
								 AND     Role = A.Role) 
				     AND      UserAccount = '#SESSION.acc#'		
					 
					 UNION 
					 
					 SELECT    DISTINCT G.AccountMission
					 FROM      Ref_ReportControlUserGroup R INNER JOIN
					           UserNames G ON R.Account = G.Account INNER JOIN
					           UserNamesGroup U ON G.Account = U.AccountGroup
					 WHERE     U.Account = '#SESSION.acc#'
					 AND       R.ControlId = '#url.controlid#'
										 		
				 </cfquery>
				 				 
				 <cfset missionaccessfilter = QuotedValueList(getMission.Mission)>	 
				 <cfif missionaccessfilter eq "">
				 	<cfset missionaccessfilter = "none">
				 </cfif>
				 
			<cfelse>
						
			    <!--- no roles defined for the report; in that case full access --->			
				<cfset missionaccessfilter = "">	 
			
			</cfif>		
			
			<cfif missionaccessfilter eq "none">
						
				<cfoutput>		
				<script>
					ptoken.navigate('#session.root#/Tools/CFReport/NoAccessGranted.cfm','reportcriteria')
				</script>
				</cfoutput>
				<cfabort>
							
			</cfif>
				
	<cfelse>
	
		<cfset missionaccessfilter = "">				
	
	</cfif>	
	
</cfif>	




<cfparam name="flyfilter" default="">

<cfset val = replaceNoCase(url.val,"'","","ALL")>
				
<cfloop index="itm" list="#val#" delimiters=",">
    <cfif flyfilter eq "">
     <cfset flyfilter = "'#itm#'">
 <cfelse>
	 <cfset flyfilter = "#flyfilter#,'#itm#'">
 </cfif>	 
</cfloop> 
	 
<cfif flyfilter eq "">
      <cfset flyfilter = "''">
</cfif>

<cfset Crit = replaceNoCase("#CriteriaValues#", "@userid", "#SESSION.acc#" , "ALL")>
<cfset Crit = replaceNoCase(Crit,"@manager", SESSION.isAdministrator,"ALL")>

<cfif flyfilter neq "'all'">
	<cfset Crit = replaceNoCase("#Crit#", "@parent", "#flyfilter#" , "ALL")>
<cfelse>
	<cfset Crit = replaceNoCase("#Crit#", "IN (@parent)", "NOT IN ('')" , "ALL")>
</cfif>	

	
<cfset orderby   = "">
<!--- add field to the SELECT clause --->
<cfset addselect = "">	 
<cfset t = 0>

<cf_tl id="All" var="1">
<cfset vAll = lt_text>
								
<cfif LookupFieldShow eq "0">
	
	<cfif FindNoCase("ORDER BY", "#preserveSingleQuotes(Crit)#")>
	   <cfset start = FindNoCase("ORDER BY", "#preserveSingleQuotes(Crit)#")>
	   
	   <cfset s = len(crit) - (start+8)>
	   <cfset sub = right(Crit,s)>
	   <cfset sub = replaceNoCase("#sub#","ORDER BY","","ALL")>	  
	   
	   <cfif findNoCase(" DESC",sub)>
	     <cfset sub = replaceNoCase("#sub#"," DESC","","ALL")>	  
	   </cfif>   
	   
	   <cfif findNoCase(" ASC",sub)>
	     <cfset sub = replaceNoCase("#sub#"," ASC","","ALL")>	  
	   </cfif>   
	   
	   <cfset sub = replaceNoCase(sub," ","","ALL")>
	 		   	    
	   <cfloop index="fld" list="#sub#" delimiters=",">
	   
		    <cfif fld eq LookupFieldValue>
				<cfset t = 1>
			<cfelseif fld neq LookupFieldValue 
			      and fld neq LookupFieldDisplay>			
			    <cfset addselect = "#addselect#,#fld#">
			</cfif>
				
 	   </cfloop>	   
	   	   
	   <cfset dis = "DISTINCT">	 
	   					   
	<cfelse>
	
	   <cfset dis = "DISTINCT">
	   <cfset t = "0">
	   <cfif LookupFieldSorting neq "">
	  	 <cfset orderby = "ORDER BY #LookupFieldSorting#">
	   <cfelse>
	   	 <cfset orderby = "ORDER BY #LookupFieldDisplay#">
	   </cfif>
		  
	</cfif>      

<cfelse>

		<!--- too complicated in case two fields are selected --->
		<cfset dis = "">
		<cfset t = "0">
		
</cfif> 
							
<cfif LookupMultiple eq "0">
									  					
	<cfquery name="query#CriteriaName#" 
     datasource="#LookupDataSource#" >
	     SELECT #dis# #LookupFieldValue#,
		        #LookupFieldValue# as Grouping,
		        CONVERT(varchar(36), #LookupFieldValue#) as PK,  
				<cfif LookupFieldSorting neq "">
				  #LookupFieldSorting# as Sorting,
				</cfif>
		        <cfif LookupFieldShow eq "0">
		          #LookupFieldDisplay# as Display
				<cfelse>
				  CONVERT(varchar, #LookupFieldValue#) +  ' - ' + CONVERT(varchar, #LookupFieldDisplay#) as Display
				</cfif>
				<cfif addSelect neq "">
				#addSelect#
				</cfif>
		 <cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#") or Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#") gte 20>
		 
		 FROM #LookupTable#
		 
		 </cfif>	
		  
		 <cfif CriteriaInterface neq "Combo">
		 
		 	 <cfif crit eq "">
			 
				  <cfif missionaccessfilter neq "">
				 	WHERE   #LookupFieldValue# IN (#preserveSingleQuotes(missionaccessfilter)#)
				  </cfif>		
			 
			 <cfelse>
			
			  #preserveSingleQuotes(Crit)# 
			  
				  <cfif missionaccessfilter neq "">
				 	AND  #LookupFieldValue# IN (#preserveSingleQuotes(missionaccessfilter)#)
				  </cfif>	
			  
			  </cfif>
			  
		 <cfelse>
		 
		 	<cfset row = 1>	
			<cfloop index="itm" list="#defaultvalue#" delimiters=",">
				   <cfif row eq "1">
				      	<cfset defaultvalue = itm>
					<cfset row = 2>
				   </cfif>							   
			</cfloop>	
		 
		    <!--- this is part of the dialog --->
		    WHERE #LookupFieldValue# = '#DefaultValue#'
			
			<cfif missionaccessfilter neq "">
			 	AND    #LookupFieldValue# IN (#preserveSingleQuotes(missionaccessfilter)#)
			</cfif>		
			
		 </cfif>	
		 
		 #orderby# 
		 
	</cfquery>			
								
	<cfif Default.DefaultValue neq "">
				
		 <cfset tmp  = "">
		 <cfset rest = "0">
         <cfloop index="itm" list="#Default.DefaultValue#,#CriteriaDefault#" delimiters=",">
		 
		      <cfif itm eq "*">
					 <cfset rest = "1">
			  <cfelse>	
	        	     <cfif tmp eq "">
			    	    <cfset tmp = "'#itm#'">
				     <cfelse>
				        <cfset tmp = "#tmp#,'#itm#'">
				     </cfif>
			  </cfif>
			  
         </cfloop>				 
				 
		 <cfif tmp neq "">
	 					
			 <cfquery name="query#CriteriaName#" 
				dbtype="query">
				
				SELECT *
				FROM   query#CriteriaName#
				WHERE  PK IN (#preserveSingleQuotes(tmp)#)			
				
				<cfif rest eq "1">
				
				UNION ALL
				
					SELECT *
					FROM   query#CriteriaName#
					WHERE  PK NOT IN (#preserveSingleQuotes(tmp)#)
									
				</cfif>
				
			</cfquery> 	
		
		</cfif>
	
    </cfif>		
	
						
	<cfif CriteriaInterface neq "Combo"> 		
	
		<cfoutput>
				
		<table class="#cl#" id="#fldid#_box" style="width:100%" class="formpadding">
		<tr><td style="width;100%">
																
		<cfif ajax eq "0">	
						
			<cfif CriteriaName eq "Mission">
			
				<!--- 10/10/214 : adding the mission type to the query object in order to group the dropdown --->
				
				<cfloop query="query#CriteriaName#">
				
					<cfquery name="getMission"
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						  SELECT  *
						  FROM    Ref_Mission
						  WHERE   Mission = '#mission#'									 		
					 </cfquery>					
				
					<cfset temp = querysetcell(queryMission, "Grouping",getMission.MissionType,currentrow)>
					
				</cfloop>	
								
				 <cfquery name="query#CriteriaName#" dbtype="query">
						SELECT *
						FROM   query#CriteriaName#
						ORDER BY Grouping,Display		
				</cfquery>
				
				<cfset qValues = evaluate("query#CriteriaName#")> 

				<cf_UIselect name = "#CriteriaName#"
							selected       = "#DefaultValue#"
							size           = "1"
							class          = "#cl# regularXXL"
							id             = "#fldid#"
							message        = "#Error#"
							required       = "#ob#"
							width          = "#sizeU#"
							style          = "width:100%"
							tooltip        = "#CriteriaMemo#"
							label          = "#CriteriaDescription#:"
							group          = "Grouping"
							query          = "#qValues#"
							queryPosition  = "below"
							value          = "PK"
							display        = "Display">
								<cfif LookupEnableAll eq "1">
								  <option value="all">--- #vall# ---</option>
								</cfif>
				</cf_UIselect>
			
			<cfelse>
			
				<cfset qValues = evaluate("query#CriteriaName#")> 
	
				<cf_UIselect name = "#CriteriaName#"
					selected       = "#DefaultValue#"
			    	size           = "1" 
					class          = "#cl# regularXXL"
					id             = "#fldid#"
					multiple       = "No"
					message        = "#Error#" 
				   	required       = "#ob#"
					width          = "#sizeU#"
					style          = "width:100%"
					tooltip        = "#CriteriaMemo#"
					label          = "#CriteriaDescription#:"
					query          = "#qValues#"
					queryPosition  = "below"
					value          = "PK"
					display        = "Display">
						<cfif LookupEnableAll eq "1">
						  <option value="all">--- #vall# ---</option>
						</cfif>  
					</cf_UIselect>
				
			</cfif>		
		
		<cfelse>		

		   		   
		   <cfset qValues = evaluate("query#CriteriaName#")> 
		   		   					
		   <CF_UIselect name   = "#CriteriaName#"
		        size           = "1"
		        class          = "regularxxl"
				id             = "#fldid#"
				selected       = "#DefaultValue#"
		        style          = "width:100%"
				query          = "#qValues#"
				queryPosition  = "below"
				value          = "PK"
				display        = "Display">

				<cfif LookupEnableAll eq "1">
				  <option value="all">--- #vall# ---</option>
				</cfif>  
				<cfloop query="query#CriteriaName#">
				 <option value="#PK#" <cfif DefaultValue eq PK>selected</cfif>>#Display#</option>
				</cfloop>
											
			</CF_UIselect>
					
		</cfif>
								
		</td></tr>
		</table>
		</cfoutput>
	
	<cfelse>
				
		<!--- COMBO box, single --->
							
		<cfoutput>						
								
		<!--- new code 15/5/2006 --->
						
		<table class="formpadding">
		<tr><td>												
				
		<table class="#cl#" id="#fldid#_box">
		 
		<tr><td>
						
			 <!--- correction in case default has more than one selected value --->			
															
			 <cfset display = "#evaluate('query#CriteriaName#.Display')#"> 
			 <cfset pk      = "#evaluate('query#CriteriaName#.PK')#"> 
			 
			 <cfset show = display> 
			 			 									 
			 <cfif ajax eq "0">
										 							 							
				  <cfinput type="Text" 
				   name      = "#CriteriaName#_des" 
				   value     = "#display#"
				   message   = "#Error#" 
				   maxlength = "800"
				   size      = "#sizeU#"
				   style     = "border:1px solid silver;width: #SizeU*8#;"
				   class     = "regularXXL"
				   readonly
				   label     = "#CriteriaDescription#:">  								   
			   
			 <cfelse>			 	
						 
				  <input type = "Text" 
				   name       = "#CriteriaName#_des" 
				   id         = "#CriteriaName#_des"
				   value      = "#show#"
				   maxlength  = "800"
				   size       = "#sizeU#"
				   style      = "border:1px solid silver;width: #SizeU*8#;"
				   class      = "regularXXL"
				   readonly>  				 
			 
			 </cfif>  
	   
	   	   </td>
			
		   <td width="1" class="hide">	
		   
		   	 <cfif ajax eq "0">
		   						    
			    <cfinput type="Text" 
				   name="#CriteriaName#" 
				   value="#DefaultValue#"
				   message="#Error#" 							  
				   style="height:1;width:1;"							   
		    	   required="#ob#">  
			   
			 <cfelse>
			 			  			 
			   <input type="Text" 
				   name="#CriteriaName#" 
				   id="#CriteriaName#"
				   value="#DefaultValue#"
				   message="#Error#" 							  
				   style="height:1;width:1;"							  					   							 					   
		    	   required="#ob#">  							 
			 
			 </cfif>  
		   
		   </td>
		   
		   <cfset fly = replace(flyfilter, ",", '$', 'ALL')>  					
		   <cfset fly = replace(fly, "'", ';', 'ALL')>  			
		   
		   <td width="26">
		   		   		  	
			   <!--- replace the value of the flyfilter with an ajax compatible structure --->	   
				   		   
	   		   <img src="#SESSION.root#/Images/OpenWindow.png"
			     name="img0_#currentrow#"
			     id="img0_#currentrow#"
			     border="0"
				 height="23" 
				 align="absmiddle"
			     style="cursor: pointer; padding-left:5px;"
			     onClick="combo('#CriteriaName#','#display#','#LookupFieldShow#','#fly#')"
			     onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/OpenWindow.png'"
			     onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/OpenWindow.png'">							  									 
			   
		   </td>
		   </tr>
		 </table>
		 
		 </td></tr>
		 
		 </table>
																
	</cfoutput>
																																														
	</cfif>
															
<cfelse>	


	<cfif CriteriaInterface neq "Combo">	
							
			<CF_DropTable dbName="#LookupDataSource#" full="Yes" tblName="#SESSION.acc#_#criterianame#"> 
																				      				
			<cfquery name="tmp" 
		     datasource="#LookupDataSource#">
			     SELECT #dis# #LookupFieldValue# as PK, 
						<cfif LookupFieldSorting neq "">
				  			#LookupFieldSorting# as Sorting,
						</cfif>				 
			     
						<cfif LookupFieldShow eq "0">
				            #LookupFieldDisplay# as Display
						<cfelse>
							CONVERT(varchar, #LookupFieldValue#) +  ' - ' + CONVERT(varchar, #LookupFieldDisplay#) as Display
						</cfif>
						<cfif addSelect neq "">
						#addSelect#
						</cfif>
						
				 INTO   #SESSION.acc#_#criterianame#
				 <cfif not Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#") or Find("FROM ", "#preserveSingleQuotes(CriteriaValues)#") gte 20>
				 FROM   #LookupTable#
				 </cfif>	
				        #preserveSingleQuotes(Crit)#
				        #orderby#				  
			</cfquery>	
												
			<cfif t eq "1">
			
			     <cftry>
			
					 <cfquery name="pk" 
					  datasource="#LookupDataSource#">
						ALTER TABLE #SESSION.acc#Tmp ADD CONSTRAINT
						PK_pk PRIMARY KEY CLUSTERED 
						( PK ) ON [PRIMARY]
					 </cfquery>
				 
				 	<cfcatch></cfcatch>
				 
				 </cftry>
			
			</cfif>			
											 					 
			 <cfset tmp = "">
	         <cfloop index="itm" list="#CriteriaDefault#" delimiters=",">
	       	     <cfif tmp eq "">
		    	    <cfset tmp = "'#itm#'">
			     <cfelse>
			        <cfset tmp = "#tmp#,'#itm#'">
			     </cfif>
	         </cfloop>
			 
			 <cfif tmp eq "">
			   <cfset tmp = "''">
			 </cfif>
			 
			 <cfif Default.DefaultValue eq "">
			 			 			 
			 	<cftry>
			 	
					 <cfquery name="query#CriteriaName#" 
				     datasource="#LookupDataSource#">
						 SELECT *
						 FROM   #SESSION.acc#_#criterianame#
						 WHERE  PK IN (#preserveSingleQuotes(tmp)#)
						 <cfif missionaccessfilter neq "">
						 AND    PK IN (#preserveSingleQuotes(missionaccessfilter)#)
						 </cfif>		
						 UNION ALL
						 SELECT *
						 FROM   #SESSION.acc#_#criterianame#
						 WHERE  PK NOT IN (#preserveSingleQuotes(tmp)#)	
						 <cfif missionaccessfilter neq "">
						 AND    PK IN (#preserveSingleQuotes(missionaccessfilter)#)
						 </cfif>		
					 </cfquery>							
				
				 <cfcatch>				
				 
					<cfoutput>
					<script>
						alert('#cfcatch.message#');
						window.location.reload();
					</script>
					</cfoutput>
					<cfabort>	
									
				 </cfcatch>		 
				
				</cftry>		  	
							
			<cfelse>
														
				 <cfset def = "">
				 <cfset rest = "0">
		         <cfloop index="itm" list="#Default.DefaultValue#" delimiters=",">
				 
			         <cfif itm eq "*">
						 <cfset rest = "1">
					 <cfelse>	
						 <cfif def eq "">
				    	    <cfset def = "'#itm#'">
					     <cfelse>
					        <cfset def = "#def#,'#itm#'">
					     </cfif>
					 </cfif>
		        	    
		         </cfloop>
				
				 <cftry>				 
						 					
					 <cfquery name="query#CriteriaName#" 
					     datasource="#LookupDataSource#">
						 
							 SELECT *
							 FROM #SESSION.acc#_#criterianame#
							 WHERE PK IN (#preserveSingleQuotes(tmp)#)
							 
							 <cfif missionaccessfilter neq "">
							 	AND    PK IN (#preserveSingleQuotes(missionaccessfilter)#)
							 </cfif>							 
							 
							 UNION 
							 
							 SELECT *
							 FROM #SESSION.acc#_#criterianame#
							 WHERE PK IN (#preserveSingleQuotes(def)#)	 
							 
							 <cfif missionaccessfilter neq "">
							 	AND    PK IN (#preserveSingleQuotes(missionaccessfilter)#)
							 </cfif>								 
							 
							 <cfif rest eq "1">
							 
							   	UNION 
								
								SELECT *
								FROM   #SESSION.acc#_#criterianame#
								WHERE  PK NOT IN (#preserveSingleQuotes(def)#) 
								
								<cfif missionaccessfilter neq "">
							    	AND    PK IN (#preserveSingleQuotes(missionaccessfilter)#)
								</cfif>	
								
							 </cfif>									 							 
							 
					   </cfquery> 
					 					   
					   <cfcatch>
					   
						    <cfquery name="query#CriteriaName#" 
						     datasource="#LookupDataSource#">
							 	 SELECT *
								 FROM #SESSION.acc#_#criterianame#	
								  <cfif missionaccessfilter neq "">
								 	AND    PK IN (#preserveSingleQuotes(missionaccessfilter)#)
								 </cfif>															 							 
						    </cfquery> 	
														
					   </cfcatch>
				   								   
				   </cftry>
			
		    </cfif>
	
			<CF_DropTable dbName="#LookupDataSource#" tblName="#SESSION.acc#_#criterianame#">  
						
			<cfoutput>							
			
			<table style="width:100%" id="#fldid#_box" class="#cl#">
			 
		 	<tr><td style="width:100%">
															
			<cfif ajax eq "0">
			
			   <cfif Parent.recordcount gte "1" and defaultValue eq "">
					
					<!--- we presect the values from the query --->					
					<cfset listsel = "">
					<cfloop query="query#criterianame#">
						<cfset listsel = "#listsel#,#pk#">
					</cfloop>						
					
				<cfelse>
				
					<cfset listsel = DefaultValue>						
									
				</cfif>		
							
				<!---
												
				<cfif s gt evaluate("query#CriteriaName#.recordcount")>
					<cfset s = evaluate("query#CriteriaName#.recordcount")>
					<cfif s lte 1>
						<cfset s = 2>
					</cfif>
				</cfif>
				<cfset s = s+1>				
				<cfset ht = s*20+10>
				
				--->
				
				<cfset qValues = evaluate("query#CriteriaName#")> 
								
				<cf_UIselect name   = "#CriteriaName#"
					selected        = "#listsel#"			    	
					class           = "regularxxl"							
					multiple        = "Yes"
				    message         = "Please select #CriteriaDescription#" 
				   	required        = "#ob#"
					width           = "#sizeU#"
					style           = "width:100%"
					tooltip         = "#CriteriaMemo#"
					label           = "#CriteriaDescription#:"
					query           = "#qValues#"
					value           = "PK"
					display         = "Display"/>
					
					<!---
					size            = "#s#" 
					style           = "height:#ht#;width:#SizeU*8#;"
					--->
									
			<cfelse>	
			
				<!---	
									
				<cfif s gt evaluate("query#CriteriaName#.recordcount")>
					<cfset s = evaluate("query#CriteriaName#.recordcount")>
					<cfif s lte 1>
						<cfset s = 2>
					</cfif>					
				</cfif>		
				
				<cfset ht = s*20+10>	
				
				--->
																				
				 <cf_UIToolTip  tooltip="#CriteriaMemo#">
				 
				 		<cfset qValues = evaluate("query#CriteriaName#")> 
																		
						 <cf_UIselect
							 name           = "#CriteriaName#"							 						 
							 multiple       = "yes"
							 query          = "#qValues#"
							 style          = "min-width:100%"
							 queryposition  = "below"
							 class          = "regularXXL"
							 selected       = "#defaultValue#"
							 value          = "PK"
							 display        = "Display"/>
				
				</cf_UIToolTip>
										
			</cfif>
																
			</td></tr>
			</table>
			</cfoutput>
										
		<cfelse>
	
		    <!--- Combo box new code 25/5/2006 --->
									
			<cfoutput>   
			
			<table cellspacing="0" cellpadding="0" style="height:25px;width:100%;">
			
			<tr><td style="height:25px">
																																					
			<table class="#cl#" id="#fldid#_box" style="height:29px;width:100%;">
																														  						
			<tr>
			
			<cfset form.multivalue = defaultvalue>								
			<cfset mode     = "view">		
			
			<td style="width:100%;height:100%" id="combo#CriteriaName#">																			
				<cfinclude template="../HTML/FormHTMLComboMultiSelected.cfm">																																					
	   	    </td>		
			
		    <td valign="top" style="padding-top:0px;padding-bottom:1px;cursor: pointer;combomulti('#CriteriaName#',document.getElementById('#CriteriaName#_listselect').value,'#fly#')">	
			
				<cfset fly = replace(flyfilter, ",", '$', 'ALL')>  					
				<cfset fly = replace(fly, "'", ';', 'ALL')>  	
						
										   
			    <img src="#SESSION.root#/Images/OpenWindow.png"
				     name="img0_#currentrow#"
				     id="img0_#currentrow#"
				     border="0"
					 height="23"
					 align="absmiddle"
				     style="cursor: pointer; padding-left:5px;"
				     onClick="combomulti('#CriteriaName#',document.getElementById('#CriteriaName#').value,'#fly#')"
				     onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/OpenWindow.png'"
				     onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/OpenWindow.png'">
		    													  					   
		    </td>
			
			<td width="1" class="hide">
									
			<!--- important field do not disable --->
						
			<cfif ajax eq "0">
								
				<cfinput type="Text" 
				   name="#CriteriaName#" 
				   value="#DefaultValue#"
				   message="#Error#" 
				   maxlength="800"
				   size="#sizeU#"
				   style="height:1;width:1;"		   								 
				   id="#fldid#">  
				   
			<cfelse>
						
				<input type="Text" 
				   name="#CriteriaName#" 
				   value="#DefaultValue#"
				   message="#Error#" 
				   maxlength="800"
				   size="#sizeU#"
				   style="height:1;width:1;"
				   id="#fldid#">  
			
			</cfif>	   
			
			</td>
			
		    </tr>
			
			</table>
			</td>
			</tr>
			</table>
		   
		   </cfoutput>			
		   							
	</cfif>		
						
</cfif>