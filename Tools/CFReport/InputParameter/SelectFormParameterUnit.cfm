
<cfset flyfilter = "">


<cfif LookupMultiple eq "0">
				
	<cfif CriteriaInterface neq "Combo">		
	
		<cfoutput>
		
		<table cellspacing="0" border="0" id="#fldid#_box" class="#cl#" class="formpadding">
		<tr><td>
				
		<cf_selectOrgUnitBase 
			controlid    = "#controlid#" 
			criteriaName = "#criteriaName#"
			mission      = "#mission#">
			
		<cfquery name="listquery"
				datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				 SELECT DISTINCT Org.OrgUnit, 
		                   Org.OrgUnitCode, 
						   Org.HierarchyCode, 
						   Org.Mission, 
						   <cfif LookupFieldShow eq "0">
						   Org.OrgUnitName as OrgUnitName 
						   <cfelse>
						   Org.OrgUnitCode+' '+Org.OrgUnitName as OrgUnitName 
						   </cfif>				
			    FROM   Organization Org
				<cfif selectedorg neq "all" and selectedorg neq "">
					WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
				<cfelse>
					WHERE Mission = '#mission#'
				</cfif>
				<cfif LookupUnitParent eq "1">
				AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
				</cfif>
				AND      DateEffective  < getdate()
				AND      DateExpiration > getDate()
				
		</cfquery>		
		
		<!--- check if defeault value exists --->
		
		<cfquery name="check"
				datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT * 	
			    FROM   Organization 
				<cfif selectedorg neq "all" and selectedorg neq "">
					WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
				<cfelse>
					WHERE Mission = '#mission#'
				</cfif>
				AND    #LookupFieldValue# = '#DefaultValue#'	
							
		</cfquery>		
		
		<cfif Check.recordcount eq "0">
		
			<cfquery name="check"
				datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				SELECT * 	
			    FROM   Organization
				<cfif selectedorg neq "all" and selectedorg neq "">
					WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
				<cfelse>
					WHERE 1=1
				</cfif>
				AND    OrgUnitCode = '#DefaultValue#'				
		    </cfquery>		
			
			<cfset selunit = check.orgunit>
			
		<cfelse>
		
			<cfset selunit = defaultValue>				
				
		</cfif>		
		
		<cfif cl eq "regular">
		 <cfset cl = "regularXXL">
		</cfif>
				
		<cfif ajax eq "0">		
	
			<cfselect name  = "#CriteriaName#" 
				selected        = "#selunit#"
		    	size            = "1" 
				class           = "#cl#"
				id              = "#fldid#"					
				multiple        = "No"
			    message         = "#Error#" 
			   	required        = "#ob#"
				style           = "width: #SizeU*8#;"				
				tooltip         = "#CriteriaMemo#"
				width           = "#sizeU#"			
				query           = "listquery"
				queryPosition   = "below"
				value           = "OrgUnit"
				display         = "OrgUnitName">
				<cfif LookupEnableAll eq "1" and listquery.recordcount gte "2">					      
					  <option value="all">--- All ---</option>
				</cfif>  
			</cfselect>
		
		<cfelse>

			<select name  = "#CriteriaName#" 			
	    	size            = "1" 
			class           = "#cl#"
			id              = "#fldid#"								
		    message         = "#Error#" 		   
			style           = "width: #SizeU*8#;"			
			width           = "#sizeU#">
			
			<cfif LookupEnableAll eq "1" and listquery.recordcount gte "2">								      
				  <option value="all">--- All ---</option>				  
			</cfif>  
			
				<cfloop query="listquery">
					<option value="#OrgUnit#" <cfif orgunit eq selunit>selected</cfif>>#OrgUnitName#</option>
				</cfloop>
				
			</select>
					
		</cfif>
			
		<input type="hidden" name="#CriteriaName#_list" id="#CriteriaName#_list" value="#QuotedValueList(listquery.orgunit)#">
		</cfoutput>
		</td></tr>
		</table>
		
	<cfelse>
	  
		<cfoutput>						
									
			<!--- new code 15/5/2006 --->
			
			<table border="0" cellspacing="0" cellpadding="0" class="formpadding">
			<tr><td style="height:25px">	
						
			<table cellspacing="0" 
			    border="0" 				
				class="#cl#" 
				id="#fldid#_box">
			 
			<tr><td>
			
				 <!--- correction in case default has more than one selected value --->
				 
				 <!--- check if default value exists --->
				 
				 <cf_selectOrgUnitBase 
					controlid="#controlid#" 
					criteriaName="#criteriaName#"
					mission="#mission#">
					
					 <cfif findNoCase(",",defaultvalue)>
					 	<cfset def = "">
					 <cfelse>
					 	<cfset def = defaultvalue>	
					 </cfif> 					 					 
		
					 <cfquery name="check"
							datasource="appsOrganization" 
						    username="#SESSION.login#" 
						    password="#SESSION.dbpw#">
							SELECT * 	
						    FROM   Organization 
							<cfif selectedorg neq "all" and selectedorg neq "">
							WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
							<cfelse>
							WHERE 1=1
							</cfif>
							AND    #LookupFieldValue# = '#def#'												
					 </cfquery>		
						
					 <cfif Check.recordcount eq "0">
						
							<cfquery name="check"
								datasource="appsOrganization" 
							    username="#SESSION.login#" 
							    password="#SESSION.dbpw#">
								SELECT * 	
							    FROM   Organization
								<cfif selectedorg neq "all" and selectedorg neq "">
								WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
								<cfelse>
								WHERE 1=1
								</cfif>
								AND    OrgUnitCode = '#def#'				
						    </cfquery>		
							
							<cfset selunit = check.orgunit>
							
					 <cfelse>
						
							<cfset selunit = defaultValue>				
								
					 </cfif>				
				 
					 <cfquery name="query#CriteriaName#" 
					    datasource="appsOrganization" 
					    username="#SESSION.login#" 
					    password="#SESSION.dbpw#">
					     SELECT  #LookupFieldValue#,
					             CONVERT(varchar, #LookupFieldValue#) as PK,  
					             OrgUnitName as Display, *			 	
						 FROM    Organization			 
						 WHERE   OrgUnit = '#selunit#'
					</cfquery> 	
																
				 <cfset display = "#evaluate('query#CriteriaName#.Display')#"> 
				 <cfset pk      = "#evaluate('query#CriteriaName#.PK')#"> 
				 
				 <cfif LookupFieldShow eq "1">
				   <cfset show = "#pk# - #display#">
				 <cfelse>
				   <cfset show = "#display#"> 
				 </cfif>
				 
				 <cfif ajax eq "0">
											 							 							
				  <cfinput type="Text" 
				   name      = "#CriteriaName#_des" 
				   value     = "#show#"
				   message   = "#Error#" 
				   maxlength = "800"
				   size      = "#sizeU#"
				   style     = "width: #SizeU*8#;"
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
				   style      = "width: #SizeU*8#;"
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
			   
			   <td width="26" align="right" style="padding-top:1px;padding-bottom:1px">
			   			   
			   	   <img src="#SESSION.root#/Images/OpenWindow.png"
				     name="img0_#currentrow#"
				     id="img0_#currentrow#"
					 height="23"
				     border="0"
					 align="absmiddle"
				     style="cursor: pointer; padding-left:5px;"
				     onClick="combo('#CriteriaName#','#display#','#LookupFieldShow#','#mission#')"
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
		
			  <cf_selectOrgUnitBase 
				controlid="#controlid#" 
				criteriaName="#criteriaName#"
				mission="#mission#">			
						
			 <cfquery name="listquery"
				datasource="appsOrganization" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				 SELECT DISTINCT 
				           Org.OrgUnit, 
		                   Org.OrgUnitCode, 
						   Org.HierarchyCode, 
						   Org.Mission, 
						   <cfif LookupFieldShow eq "0">
						   Org.OrgUnitName as OrgUnitName
						   <cfelse>
						   Org.OrgUnitCode+' '+Org.OrgUnitName as OrgUnitName
						   </cfif>				
			    FROM   Organization Org
				<cfif selectedorg neq "all" and selectedorg neq "">
					WHERE  OrgUnit IN (#preservesinglequotes(selectedorg)#)
				<cfelse>
					WHERE Mission = '#mission#'
				</cfif>
				
				<cfif LookupUnitParent eq "1">
				AND (ParentOrgUnit = '' or ParentOrgUnit is NULL or Autonomous = 1)
				</cfif>
				ORDER BY HierarchyCode
				
			</cfquery>	
	
			<cfoutput>
			<table cellspacing="0" bordercolor="6688aa" id="#fldid#_box" class="#cl#">
			
				<tr>
				<td>
				<table width="100%">
					<tr><td bgcolor="f4f4f4" style="width: #SizeU*8-1#;border-top:1px solid silver;border-left:1px solid silver; border-right:1px solid silver;padding-left:3px" class="labelmedium">#selectedman#</td></tr>
				</table>
				</td>
				</tr>
			
				<tr><td>
				
				<cfif cl eq "regular">
					<cfset cl = "regularXXL">
				</cfif>
				
				<cfif ajax eq "0">		
				
					<cfif criteriadefault eq "">
						
							<cfset def = defaultvalue>
						
					<cfelse>
					
							<cfset def = criteriadefault>
							
					</cfif>	
									
					<cfselect name  = "#CriteriaName#" 				
			    	size            = "#s#" 
					class           = "#cl#"
					id              = "#fldid#"
					multiple        = "Yes"
				    message         = "#Error#" 
				   	required        = "#ob#"
					tooltip         = "#CriteriaMemo#"
					width           = "#sizeU#"
					style           = "border:0px;height:180;width: #SizeU*8#;"
					label           = "#CriteriaDescription#:">
					
					<cfloop query="ListQuery">				    
						<option value="#OrgUnit#" <cfif find(orgunit,def)>selected</cfif>>#hierarchyCode# #OrgUnitName#</option>
					</cfloop>
					
					</cfselect>
				
				<cfelse>

					<select name  = "#CriteriaName#" 			
			    	size          = "#s#" 
					class         = "#cl#"
					id            = "#fldid#"					
					multiple 		   	   
					style         = "height:180;width: #SizeU*8#;"			
					width         = "#sizeU#">
					
						<cfif criteriadefault eq "">
						
							<cfset def = defaultvalue>
						
						<cfelse>
					
							<cfset def = criteriadefault>
							
						</cfif>	
								
						<cfloop query="listquery">
							<option value="#OrgUnit#" <cfif find(orgunit,def)>selected</cfif>>#hierarchyCode# #OrgUnitName#</option>
						</cfloop>
						
					</select>			
				
				</cfif>
				
				</td>
				</tr>
			</table>
									
			<input type  = "hidden" 
			       name  = "#CriteriaName#_list" 
				   id    = "#CriteriaName#_list"
			       value = "#QuotedValueList(listquery.orgunit)#">
				   
			</cfoutput>	
					
					
	 <cfelse>	 					 

			<!--- Combo box new code 25/5/2006 --->
							
			<cfoutput>   
			
			<table border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr><td>
																												
			<table cellspacing="0" 
			    border="0"
				cellspacing="0"
				cellpadding="0" 
				class="#cl# formpadding" 
				id="#fldid#_box" 
				style="width: #SizeU*8#;">
																												  						
			<tr>
			<td height="20" id="combo#CriteriaName#">	
																																
				<cfset form.multivalue = defaultvalue>									
				<cfset mode     = "view">					
				<cfset url.fly = mission>																		
				<cfinclude template="../HTML/FormHTMLComboMultiSelected.cfm">
																																
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
				   style="height:1;width: 1;"
				   id="#fldid#"								   								 
				   required="#ob#">  
				   
			<cfelse>

				<input type="Text" 
				   name="#CriteriaName#" 
				   value="#DefaultValue#"
				   message="#Error#" 
				   maxlength="800"
				   size="#sizeU#"
				   style="height:1;width: 1;"
				   id="#fldid#"								   								  
				   required="#ob#">  
			
			</cfif>	   
			
			</td>
		    <td width="15" align="right" valign="top">				
				
			   <img src   = "#SESSION.root#/Images/OpenWindow.png"
			     name     = "img0_#currentrow#"
			     id       = "img0_#currentrow#"
			     border   = "0"		
				 height   = "23"
				 align    = "absmiddle"
			     style    = "cursor: pointer; border:0px solid silver; padding-left:5px;"
			     onClick  = "combomulti('#CriteriaName#',document.getElementById('#CriteriaName#').value,'#mission#')"
			     onMouseOver = "document.img0_#currentrow#.src='#SESSION.root#/Images/OpenWindow.png'"
			     onMouseOut  = "document.img0_#currentrow#.src='#SESSION.root#/Images/OpenWindow.png'">
		    													  					   
		    </td>
		    </tr>
			
			</table>
			</td></tr></table>
   
   		</cfoutput>			
				
	</cfif>
	
</cfif>
