
<!--- this defines first, last, counted and pages --->
<cf_PageCountN count="#Searchresult.recordcount#" show="#CLIENT.PageRecords#">

<cfset counted = Searchresult.recordcount>

<!--- ---------------------- --->
<!--- update navigation only --->
<!--- ---------------------- --->

<cfif url.content eq "nav">
	 <cfinclude template="ListingNavigation.cfm">	
	 <cfabort>
</cfif>


<cfparam name="cl" default="regular">

<!--- counts cols --->
	
<cfset cols = 2>
	
<cfloop array="#attributes.listlayout#" index="current">

    <cfparam name="current.display" default="1">	
    <cfif current.display eq "1">
		<cfset cols = cols+1>	
	</cfif>
    
</cfloop>

<cfif attributes.selectmode neq "">
       <cfset cols = cols+1>	
</cfif>
		
<cfif attributes.listtype eq "Directory">
	   <cfset cols = cols+1>
</cfif>   

<!--- define columns to be shown --->

<cfif deletetable neq "">
   	   <cfset cols = cols+1>
</cfif>

<cfif annotation neq "">
       <cfset cols = cols+1>
</cfif>

<!--- 14/6/2016 : changed from client to session as client has limitation in size --->

<cfif attributes.drillkey neq "">

	<cfset session.trafilter = evaluate("quotedvalueList(searchresult.#attributes.drillkey#)")>
			
</cfif>	

<cfif url.content eq "1">

	<table width="100%" height="100%">		
	  <tr><td height="100%">
	  <cfinclude template="ListingContent.cfm"></td></tr>
	</table> 
	
<cfelse>

  <cfoutput>

   <cfif listclass eq "Listing">
              	   
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
		  						
		  	<cfif attributes.filtershow eq "Yes">		
			  	<cf_layoutArea position="top" name="listingMenu" maxsize="35" size="35px" collapsible="false">
			  		<cfinclude template="ListingMenu.cfm">				
				</cf_layoutArea>
		  	</cfif>
			
			<input type="hidden"  name="mylink"         id="mylink"         value="#url.link##sign#">
            <input type="hidden"  name="mylinkform"     id="mylinkform"     value="#url.linkform#">    
            <input type="hidden"  name="gridbox"        id="gridbox"        value="#attributes.box#_content">    
            <input type="hidden"  name="ajaxbox"        id="ajaxbox"        value="#attributes.box#_ajax">    
            <input type="hidden"  name="selectedfields" id="selectedfields" value="">
					  	
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
					<cfdiv id="divListingMenuTree" style="height:100%; width:100%" bind="url:#session.root#/tools/listing/listing/ListingTree.cfm?height=#url.height#&box=#attributes.box#_content&systemfunctionid=#url.systemfunctionid#&FunctionSerialNo=1">					
				</cf_layoutArea>
			</cfif>
			
			<cf_layoutArea position="center" name="content" style="padding:5px; height:70%; min-height:70%;" overflow="hidden">				 						
					<cfinclude template="ListingShowContent.cfm">								
			</cf_layoutArea>
			
			<cf_tl id="Fields" var="tlFields">
			<cf_layoutArea position="right" name="filtering" collapsible="true" title="#tlFields#" size="150px" minsize="100px" maxsize="350px" initcollapsed="true" style="padding:5px;">
				<cfinclude template="ListingFields.cfm">
			</cf_layoutArea>
		
		</cf_layout>
			   	   
	<cfelse>	
												
			<cfif attributes.screentop eq "yes">		
					
			    <cf_screentop html="#attributes.html#" height="#attributes.tableheight#" scroll="#scroll#"> 			
			
			</cfif>			
													
			<table width="#attributes.tablewidth#" 
			    height="#attributes.tableheight#" 				
				align="center" 				
				onKeyUp="listnavigateRow()">
														 
	 		  <cfif attributes.banner neq "">   
			   <tr class="line"><td>#attributes.banner#</td></tr>				   			  
			  </cfif>
			  						  			  
			  <!--- ajaxbox --->   
			  
			   <tr class="hide">
				   <td>   
			   
			   		<input type="hidden" name="mylink"     id="mylink"     value="#url.link##sign#">
					<input type="hidden" name="mylinkform" id="mylinkform" value="#url.linkform#">
			   
			   		<input type="hidden" 
					       name="gridbox" 
						   id="gridbox" 
						   value="#attributes.box#_content">
						   
					<input type="hidden" 
					       name="ajaxbox" 
						   id="ajaxbox"
						   value="#attributes.box#_ajax">	   	   
						   
					<input type="hidden" 
					       name="selectedfields" 
						   id="selectedfields" 
						   value="">					      
			   
			   		</td>
				</tr>	
						
				<input type="hidden" name="treefield"      id="treefield"       value="">
				<input type="hidden" name="treevalue"      id="treevalue"       value="">
				<input type="hidden" name="listorder"      id="listorder"       value="#url.listorder#">	
				<input type="hidden" name="listorderfield" id="listorderfield"  value="#url.listorderfield#">	
				<input type="hidden" name="listorderalias" id="listorderalias"  value="#url.listorderalias#">	
				<input type="hidden" name="listorderdir"   id="listorderdir"    value="#url.listorderdir#">	
								
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
					  
					      <table cellspacing="0" cellpadding="0" class="formspacing">
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
										<font color="6688aa"><u>#option.label#</font>
										</td>
									</tr>
									</table>
									</td>										
									
								</cfif>
								
							  </cfloop>		
						  
						  </cfif>							  	 	
						  						  
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
						  						  
						  <td id="menuprocess"></td>						  						  
						  														  
						  </tr>
								  
						  </table>	
											  
						</td>						
																	
					</tr>	
															
					</cfif>			
											
					<tr>
					
						<td bgcolor="#attributes.headercolor#" colspan="2">
						
							<table width="100%" cellspacing="0" cellpadding="0" align="right">
							
								<tr>	
								
																
								<td id="locate#attributes.box#" name="locate#attributes.box#" width="100%" class="#cl#">								
								 <cfinclude template="ListingFilter.cfm"> 																
								</td>
											
								<td align="right" valign="top" style="padding:2px;z-index:1; position:relative;">
								
									<cfif Attributes.ExcelShow eq "No" and not isArray(attributes.menu)>
																	
										<img src="#SESSION.root#/images/up6.png" 
										    id="locate#attributes.box#_col"
											name="locate#attributes.box#_col"
											onclick="listingshow('locateme')" 
											class="#cl#"
											style="border: 0px solid Silver;cursor:pointer">
											
										<img src="#SESSION.root#/images/down6.png" 		    
											id="locate#attributes.box#_exp" name="locate#attributes.box#_exp"
											onclick="listingshow('locateme')" 
											class="#cla#"
											style="border: 0px solid Silver;cursor:pointer">
										
									</cfif>	
																		
								</td>				
								
								</tr>
								
							</table>
						
						</td>
					</tr>
																											
				</cfif>		
				
				<!--- added for Evelyn to support --->
				<!--- box to hold value to be posted upon updating the line in the background --->				
				
				<tr class="hide"><td>
				
				  <cfoutput>					  
					<form name="mylistform" method="post">				
						<input type="text" name="f#attributes.box#_fieldvalue" id="f#attributes.box#_fieldvalue">			
					</form>
				  </cfoutput>
				  
				</td></tr>
												   			 
				<tr class="hide"><td style="height:1px" id="#attributes.box#_ajax"></td></tr>  		
						
			    <tr>
				    <td height="100%" colspan="2">	
																																						
						<cf_divscroll overflowx="auto" overflowy="hidden" style="height:100%">						
							<cfdiv id="#attributes.box#_content" style="height:100%">												
								<cfinclude template="ListingContent.cfm">					
							</cfdiv>						
						</cf_divscroll>					
										
					</td>
				</tr>		  		   
		 </table>		 
		 	
	</cfif>   
        
   </cfoutput>
    
</cfif>  


<cfif attributes.html is "yes">
	<cf_screenbottom html="#attributes.html#">
</cfif>
 