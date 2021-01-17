
<!--- this defines first, last, counted and pages --->
<cf_PageCountN count="#Searchresult.recordcount#" show="#attributes.show#">
<cfset countedrows = Searchresult.recordcount>

<cfparam name="cl" default="regular">

<!--- 14/6/2016 : changed from client to session as client has limitation in size 

<cfif attributes.drillkey neq "">
	<cfset session.trafilter = evaluate("quotedvalueList(searchresult.#attributes.drillkey#)")>			
</cfif>	

--->
	
<cfif url.content eq "1">

    <!--- -------------------------------------------------- --->
	<!--- only content because apply/refresh/sort is pressed --->
				
	<cfinclude template="ListingContentHTML.cfm">	
	
<cfelse>

  <cfoutput>  

   <cfif listclass eq "Listing">
   
   	    <!--- menu listing --->
              	   
   	   <cf_layout type="border">
	   
	   		<cfquery name="system" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_ModuleControl R
					WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
			</cfquery>
	   
	   		<cfif url.webapp eq "Backoffice" and system.functionTarget neq "Right">	
			
				<cfquery name="Menu" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   xl#Client.LanguageId#_Ref_ModuleControl R
					WHERE SystemFunctionId = '#URL.SystemFunctionId#'	
				</cfquery>
			
				<cf_layoutArea position="header" name="listingheader" maxsize="30" size="30">	
					<cf_ViewTopMenu label="Listing: #Menu.FunctionName#">
				</cf_layoutArea>
			
			</cfif>
		  						
		  				
			<!--- take these fields by selecting another filter to apply --->
						
			<input type="hidden"  name="mylink"         id="mylink"         value = "#url.link##sign#">
            <input type="hidden"  name="mylinkform"     id="mylinkform"     value = "#url.linkform#">   
			
			<!--- to run the listing content into ---> 
            <input type="hidden"  name="gridbox"        id="gridbox"        value = "#attributes.box#_content">   
			
			<!--- to run the listing refresh into ---> 
            <input type="hidden"  name="ajaxbox"        id="ajaxbox"        value = "#attributes.box#_ajax">    
            <input type="hidden"  name="selectedfields" id="selectedfields" value = "">
			
			<input type="hidden" name="treefield"      id="treefield"       value = "">
			<input type="hidden" name="treevalue"      id="treevalue"       value = "">
				
					  	
		  	<cfquery name="tree" 
	            datasource="AppsSystem" 
	            username="#SESSION.login#" 
	            password="#SESSION.dbpw#">
	                SELECT *
	                FROM  Ref_ModuleControlDetailField
	                WHERE SystemFunctionId = '#url.SystemFunctionId#'
	                AND   FunctionSerialNo = '1'
	                AND   FieldTree = 1		
	        </cfquery>
												
			<cfif attributes.filtershow neq "No" and tree.recordcount gte "1">
				<cf_tl id="Filter" var="tlOptions">
				<cf_layoutArea position="left" overflow="hidden" name="mytree" collapsible="true" size="190px" minsize="190px" maxsize="260px">					   												
					<cfdiv id="divListingMenuTree" style="height:100%; width:100%" 
					   bind="url:#session.root#/tools/listing/listing/ListingTree.cfm?height=#url.height#&box=#attributes.box#_content&systemfunctionid=#url.systemfunctionid#&FunctionSerialNo=1">					
				</cf_layoutArea>
			</cfif>
			
			<cf_layoutArea position="center" name="content" style="padding:5px; height:70%; min-height:70%;" overflow="hidden">	
				
				<cfform name="listfilter" method="POST" onsubmit="return false" style="height:100%"> 
														
					<table width="100%" height="100%" onkeyup="listnavigateRow('#box#')">   
										
						<input type="hidden" name="listorder"             id="listorder"             value = "#url.listorder#">	
						<input type="hidden" name="listorderfield"        id="listorderfield"        value = "#url.listorderfield#">	
						<input type="hidden" name="listorderalias"        id="listorderalias"        value = "#url.listorderalias#">	
						<input type="hidden" name="listorderdir"          id="listorderdir"          value = "#url.listorderdir#">							
						<input type="hidden" name="listcolumn1_type"      id="listcolumn1_type"      value = "#url.listcolumn1_type#">
						<input type="hidden" name="listcolumn1_typemode"  id="listcolumn1_typemode"  value = "#url.listcolumn1_typemode#">
							
						<cfif attributes.filtershow neq "No"> 
						   
							<tr>
								<td height="30">
																			
									<table width="100%" cellspacing="0" cellpadding="0" align="right">    
										<cf_tl id="Filter" var="tlFilter">    
										<tr>
											<td height="28" style="padding-left:10px" class="labelmedium">#tlFilter#</td>
											
											<td align="right">
											<cfinclude template="ListingMenu.cfm">		
											</td>
											
											<td align="right" height="100%" width="23" style="style:width:30px;cursor:pointer;border-left:dotted 1px silver;">
						
												<cfif attributes.filtershow eq "hide">						  
							                    	<cfset cl = "hide">
							                    	<cfset cla = "regular">
							                    <cfelse>
							                   		<cfset cl = "regular">
							                    	<cfset cla = "hide">
							                    </cfif>
																										
						                        <cf_space spaces="8">
												
						                        <img src="#SESSION.root#/images/up6.png" 
						                        	id="locate#attributes.box#_col"	
						                       		height="22"
						                        	width="23"
						                        	align="absmiddle"
						                        	onclick="listingshow('locate#attributes.box#')"								
						                        	class="#cl#">
						                            
						                        <img src="#SESSION.root#/images/down6.png" 		    
						                        	id="locate#attributes.box#_exp" 
						                        	height="22"
						                        	width="23"
						                        	align="absmiddle"
						                        	onclick="listingshow('locate#attributes.box#')" 								
						                        	class="#cla#">
						
											</td>						
										</tr>    
										<tr>
						                	<td height="1" colspan="2" class="line">
						                    </td>
						                </tr> 														
										<cfset getMissingFilter = "1">									
						                <tr>									  					
											<td class="#cl#" id="locate#attributes.box#" name="locate#attributes.box#" colspan="2" width="100%">
												<!--- show filter options --->																										
												<cfinclude template="ListingFilter.cfm">																															
											</td>    										
										</tr>  								
										<tr><td colspan="2"><cfinclude template="ListingPivot.cfm"></td></tr>
										
									</table>
									
									
								</td>
							</tr>   
							
						</cfif>  
						
						<tr class="xxhide">
						   	<td style="height:1px" id="#attributes.box#_ajax"></td>
						</tr>		
																
						<tr>
						   	<td style="padding:3px;height:100%" width="100%" id="#attributes.box#_content">																				   			     						
								<cfinclude template="ListingContentHTML.cfm">						  				  																		
							</td>
						</tr>					 
							   
					</table> 
				
				</cfform>
														
			</cf_layoutArea>
														
			<cf_tl id="Fields" var="tlFields">
			<cf_layoutArea position="right" name="filtering" collapsible="true" title="#tlFields#" size="150px" minsize="100px" maxsize="350px" initcollapsed="true" style="padding:5px;">
				<cfinclude template="ListingFields.cfm">
			</cf_layoutArea>
						
		
		</cf_layout>
			   	   
	<cfelse>	
	
			<!--- application embedded listing --->
																			
			<cfparam name="scroll" default="No">									
			<cfif attributes.screentop eq "yes">					
			    <cf_screentop html="#attributes.html#" height="#attributes.tableheight#" scroll="#scroll#"> 						
			</cfif>		
			
			<cfform name="listfilter" method="POST" onsubmit="return false" style="height:#attributes.tableheight#"> 	

				<table width="#attributes.tablewidth#" height="#attributes.tableheight#" align="center" onKeyUp="listnavigateRow('#box#')">
															 
		 		  <cfif attributes.banner neq "">   
				   <tr class="line"><td>#attributes.banner#</td></tr>				   			  
				  </cfif>
				  						  			  
				  <!--- ajaxbox --->   
				  
				   <tr class="hide">
					   <td>   
				   
				   		<input type="hidden" name="mylink"     id="mylink"     value="#url.link##sign#">
						<input type="hidden" name="mylinkform" id="mylinkform" value="#url.linkform#">
				   
				   		<input type="hidden" name="gridbox"    id="gridbox"    value="#attributes.box#_content">							   
						<input type="hidden" name="ajaxbox"    id="ajaxbox"	   value="#attributes.box#_ajax">	   	   
								      
				   
				   		</td>
					</tr>	
							
					<input type="hidden" name="treefield"             id="treefield"             value="">
					<input type="hidden" name="treevalue"             id="treevalue"             value="">
					<input type="hidden" name="selectedfields"        id="selectedfields"        value="">
					
					<input type="hidden" name="listorder"             id="listorder"             value = "#url.listorder#">	
					<input type="hidden" name="listorderfield"        id="listorderfield"        value = "#url.listorderfield#">	
					<input type="hidden" name="listorderalias"        id="listorderalias"        value = "#url.listorderalias#">	
					<input type="hidden" name="listorderdir"          id="listorderdir"          value = "#url.listorderdir#">							
					<input type="hidden" name="listcolumn1_type"      id="listcolumn1_type"      value = "#url.listcolumn1_type#">
					<input type="hidden" name="listcolumn1_typemode"  id="listcolumn1_typemode"  value = "#url.listcolumn1_typemode#">
									
					<cfif attributes.filtershow neq "No">
					
						<cfif attributes.filtershow eq "hide">						  
						     <cfset cl = "hide">
							 <cfset cla = "regular">
						<cfelse>
						      <cfset cl = "regular">
							  <cfset cla = "hide">
						</cfif>
					
						<cfparam name="url.systemfunctionid" default="">
						<cfparam name="url.functionserialno" default="">
															
						<cfsavecontent variable="selectme">
						        style="cursor: pointer; height:24"
								onMouseOver="this.className='highlight2'"
								onMouseOut="this.className='labelit'"
						</cfsavecontent>													
						
						<cfif Attributes.ExcelShow eq "Yes" or isArray(attributes.menu)>
											
						<tr>
						   <td width="99%" style="padding-top:2px">
						  
						      <table class="formspacing">
							  <tr>
							  
							  <td align="left" style="padding-top:2px;padding-left:3px;padding-right:5px">
												
								<img src="#SESSION.root#/images/up6.png" 
									   id="locate#attributes.box#_col"
									   onclick="listingshow('locate#attributes.box#')" 
									   style="border: 0px solid Silver;cursor: pointer;"
									   class="#cl#">
									   
									   
								<img src="#SESSION.root#/images/down6.png" 		    
										id="locate#attributes.box#_exp"
										onclick="listingshow('locate#attributes.box#')" 
										style="border: 0px solid Silver;cursor: pointer;"
										class="#cla#">
							
							</td>	
							
													
							<!--- *** LISTING PRINT FUNCTION **** --->
							<cfinclude template="ListingPrint.cfm">
							
							<td style="border-left: 1px solid Silver;"></td>		  					
							  
							   <cfif Attributes.ExcelShow eq "Yes">
							  
							   <td class="labelit" style="height:28px;padding-left:6px;padding-right:3px">						 						  
															  
							   	<cf_tl id="Export to Excel" var="excel">																		  
																				
							 	<cfinvoke component="Service.Analysis.CrossTab"  
									  method      = "ShowInquiry"		
									  buttonclass = "button10g"						 				  						 
									  buttonText  = "#excel#"		
									  buttonstyle = "width:180px"				 
									  reportPath  = "Tools\Listing\Listing\"
									  queryString = "box=#attributes.box#&systemfunctionid=#url.systemfunctionid#"
									  SQLtemplate = "ListingExcel.cfm"						 
									  dataSource  = "#attributes.datasource#" 
									  module      = "SelfService"										  								  
									  reportName  = "#attributes.header#"
									  table1Name  = "#attributes.header#"
									  data        = "1"
									  ajax        = "2"
									  filter      = "1"
									  olap        = "0" 
									  excel       = "1"> 
									  																 																  
							   </td>
							  
							  </cfif>
							 
							   <cfif isArray(attributes.menu)>	 	
							  
								  <cfloop array="#attributes.menu#" index="option">
								  
								  <cfparam name="option.icon" default="">
								
									<cfif option.label neq "">
									
										<td style="border-left: 1px solid Silver;"></td>	
										<td height="30" #selectme# onclick="#option.script#" style="padding-left:6px;padding-right:6px;border:1px transparent Solid;">
										<table class="formspacing">
										<tr>
											<td style="padding-left:3px">
											<cfif option.icon neq "">
											<img src="#SESSION.root#/images/#option.icon#" height="16" width="16" alt="" border="0" align="absmiddle">
											</cfif>
											</td>
											<td class="labelmedium" style="font-size:16px;padding-left:3px;padding-right:9px">
											<font color="6688aa">#option.label#</font>
											</td>
										</tr>
										</table>
										</td>										
										
									</cfif>
									
								  </cfloop>		
							  
							  </cfif>	
							  
							  <!--- deprecated as flash no longer is supported 						  	 	
							  						  
							  <cfif Attributes.AnalysisModule neq "">		
							  				  
								  <td style="padding-left:4px;border-right: 1px solid Silver;"></td>							  
								  <td style="padding-left:2px;padding-right:2px">		
																  							  							  						  							 															
									  <cfinvoke component = "Service.Analysis.CrossTab"  
											  method      = "ShowInquiry"
											  buttonName  = "Inquiry"
											  buttonClass = "td"
											  buttonIcon  = "#SESSION.root#/images/rolap.gif"
											  buttonText  = "&nbsp;<font color='black'>ROLAP</font>"								  								  
											  reportPath  = "#attributes.AnalysisPath#"
											  SQLtemplate = "#attributes.AnalysisTemplate#"		
											  QueryString = "#attributes.QueryString#" 							  			  	  
											  ajax        = "1"
											  style       = "padding-left:4px;width:130px;padding-right:4px"
											  dataSource  = "#attributes.datasource#" 
											  module      = "#attributes.analysismodule#"
											  reportName  = "#attributes.analysisReportName#"
											  olap        = "1"
											  table1Name  = "Transactions"
											  filter      = "1"> 								 
																		  
								  </td>
							  
							  </cfif>
							  
							  --->
							  						  
							  <td id="menuprocess"></td>						  						  
							  														  
							  </tr>
									  
							  </table>	
												  
							</td>						
																		
						</tr>	
																
						</cfif>		
												
						<tr>
						
							<td bgcolor="#attributes.headercolor#" colspan="2">
												
								<table width="100%" align="right">							
									<tr>																	
									<td id="locate#attributes.box#" width="100%" class="#cl#">																				
									 	<cfinclude template="ListingFilter.cfm"> 															
									</td>		
																		
									<td align="right" valign="top">								
										<cfif Attributes.ExcelShow eq "No" and not isArray(attributes.menu)>																	
											<img src="#SESSION.root#/images/up6.png" 
											    id="locate#attributes.box#_col"	onclick="listingshow('locateme')" class="#cl#"	style="cursor:pointer">											
											<img src="#SESSION.root#/images/down6.png" 		    
												id="locate#attributes.box#_exp" onclick="listingshow('locateme')" class="#cla#" style="cursor:pointer">										
										</cfif>																			
									</td>									
									</tr>	
									
									<cfif url.systemfunctionid neq "" and group eq "Yes">
									<tr style="border-top:1px solid silver">
									<td colspan="2"><cfinclude template="ListingPivot.cfm"></td>
									</tr>
									</cfif>
																
								</table>
														
							</td>
						</tr>
																												
					</cfif>		
												
				    <tr>
					    <td height="100%" id="#attributes.box#_content" colspan="2" valign="top">																			
							<cfinclude template="ListingContentHTML.cfm">	   																	
						</td>
					</tr>	
					
					<tr class="xhide"><td style="height:1px" id="#attributes.box#_ajax"></td></tr>	  		   
									
			 </table>
		 
		 </cfform>
		 	
	</cfif>   
        
   </cfoutput>
    
</cfif>  

<cfif attributes.html is "yes">
	<cf_screenbottom html="#attributes.html#">
</cfif>


<cfset ajaxonload("doHighlight")>
<cfset ajaxonload("doScroll")> 