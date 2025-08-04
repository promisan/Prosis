<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->


<cfquery name="Host" 
		datasource="AppsInit" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   * 
		FROM     Parameter
		WHERE    HostName = '#CGI.HTTP_HOST#'
</cfquery>

<cfset hosts = quotedvaluelist(host.applicationserver)>

<cfparam name="url.owner"   default = "">
<cfparam name="url.module"  default = "">
<cfparam name="url.portal"  default = "0">

<cfset owner     = replace(owner,"|","'","ALL")>
<cfset module    = replace(module,"|","'","ALL")>
<cfset selection = replace(selection,"|","'","ALL")>
<cfset menuclass = replace(menuclass,"|","'","ALL")>

<cfif url.selection is "my"> 

		<cfoutput>		
			<cfdiv bind="url:#SESSION.root#/System/Modules/Subscription/RecordListing.cfm?systemfunctionid=#url.systemfunctionid#&view=1&portal=1" id="mylist">	
		</cfoutput>

<cfelse>	
	 
	<style>
	
		table.highLight {
			BACKGROUND-COLOR: #f9f9f9;		
			border-top : 1px solid silver;
			border-right : 1px solid silver;
			border-left : 1px solid silver;
			border-bottom : 1px solid silver;
			cursor:pointer;
		}
		table.rptnormal {
			BACKGROUND-COLOR: #ffffff;
			border-top : 1px solid white;
			border-right : 1px solid white;
			border-left : 1px solid white;
			border-bottom : 1px solid white;
		}
		
	</style>
		
	<cfset rand = round(Rand()*100)>
		
	<cfif owner neq "">
	
		<cfparam name="Heading" default="">		
		
		<!--- from the portal --->
							
		<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_ReportControl C, Ref_ReportMenuClass R
			WHERE    Operational   = '1'		
			
			<cfif url.Owner neq "||">			
			AND      C.Owner  = #PreserveSingleQuotes(owner)# 
			</cfif>
			<cfif url.Module neq "||">
			AND      C.SystemModule  IN (#PreserveSingleQuotes(module)#)
			</cfif>
			<cfif url.portal eq "1">
			AND      EnablePortal = 1
			AND		 EXISTS (SELECT LayoutId FROM Ref_ReportControlLayout WHERE ControlId = C.ControlId AND Operational = 1 AND UserScoped = 1)
			</cfif>
			AND      C.SystemModule =  R.SystemModule
			AND      C.MenuClass    =  R.MenuClass
						
			AND      FunctionClass in (#PreserveSingleQuotes(selection)#) 
			AND      (LanguageCode  = '#Client.LanguageId#' or EnableLanguageAll = '1')
			AND      Operational   = '1'			
			AND      (ReportHostName is NULL or ReportHostName = '' or ReportHostName IN (#preservesinglequotes(hosts)#))
			
			AND      (
				
						TemplateSQL != 'Application' 
							OR
					    (TemplateSQL = 'Application'
							AND ControlId IN (SELECT ControlId 
							                  FROM Ref_ReportControlOutput 
											  WHERE OutputClass = 'Table'))
					  ) 
							  	
			ORDER BY ListingOrder, Description,MenuOrder 
						
		</cfquery>
		
			
	<cfelse>
	
		<!--- regular menu --->
				
		<cfparam name="Heading" default="#selection#">
		<cfset heading = replace(heading,"'","","ALL")>
				
		<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   C.*, R.Description, R.ListingOrder,
			         CASE WHEN R.MenuClass = 'Main' THEN ('Main') ELSE ('Other') END as ReportClass
			      
			FROM     Ref_ReportControl C, Ref_ReportMenuClass R
			WHERE    C.SystemModule  = #PreserveSingleQuotes(module)#
			AND      C.SystemModule =  R.SystemModule
			AND      C.MenuClass    =  R.MenuClass
			AND      C.FunctionClass in (#PreserveSingleQuotes(selection)#)
			AND      (C.LanguageCode  = '#Client.LanguageId#' or C.EnableLanguageAll = '1')
			AND      C.Operational   = '1'	
			AND      (ReportHostName is NULL or ReportHostName = '' or ReportHostName IN (#preservesinglequotes(hosts)#))
			
			AND     
			         (
					  R.MenuClass in (#PreserveSingleQuotes(menuclass)#) 
			          <cfif menuclass eq "'main'">
					  OR R.MenuClass != 'Main'					  
					  </cfif> 
					  )
			AND      (
				        (TemplateSQL != 'Application') 
						OR
					    (TemplateSQL = 'Application'
							AND ControlId IN (SELECT ControlId 
							                  FROM   Ref_ReportControlOutput 
											  WHERE  OutputClass = 'Table')
						)
					  ) 
			
			ORDER BY FunctionClass DESC,ListingOrder,Description,MenuOrder 
			
		</cfquery>
		
		
	</cfif>		

	<!--- group the output by functionclass and then by description of the template --->
	
	<cfif searchresult.recordcount neq "0">
		
		<!--- Search form --->
		
		<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="white" class="formpadding">
						
		<cfset cnt = 0>
		
		<cfoutput query="searchresult" group="FunctionClass">
			
		<cfoutput group="Description">
						
			<tr><td>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
			   <cfif url.portal eq "1">
			   
			   		<tr>
					   <td style="padding-top:9px" colspan="6" id="#MenuClass#" name="#MenuClass#">
						   <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
							 	<tr>
								<td width="100%" height="23">
								<!--- background="#SESSION.root#/Images/headermenu1b_long_fat4_v2.jpg" --->
									<table border="0" cellspacing="0" cellpadding="0" width="100%">
								  	  <tr>
									  <td height="23" style="font-size:27px;font-weight:250" width="400" class="labellarge">								  		
										#Description#
								  	  </td>
									  </tr>								  
								    </table>
							     </td>
								 </tr>
						   </table>
					   </td>
					   </tr> 
				  
				  	   <tr><td colspan="6" height="1" id="#MenuClass#" name="#MenuClass#" class="linedotted"></td></tr>				   
			   
			   <cfelseif owner neq "">			   		   
			   
				   <!--- no header in case of the system function --->
				   
				   <cfif functionclass neq "System">
					   <tr class="line">
					   <td style="padding-top:4px" colspan="6" id="#MenuClass#" name="#MenuClass#">
						   <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
							 	<tr>
								<td width="100%" height="28">
									<table border="0" cellspacing="0" cellpadding="0" width="100%" class="formpadding">
								  	  <tr>
									  <td width="400" style="padding-left:10px;font-weight:250;font-size:29px" class="labellarge">
								  		
										<cfif menuclass neq "main" and menuclass neq "">
									  		#Description# 
										<cfelse>
											#Heading#
										</cfif>
								  	  </td>
									  </tr>								  
								    </table>
							     </td>
								 </tr>
						   </table>
					   </td>
					   </tr> 
				  					   
				   <cfelse>
				   
				   	 <tr class="line">
					   <td style="padding-top:4px" colspan="6" id="#MenuClass#" name="#MenuClass#">
						   <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
							 	<tr>
								<td width="100%" height="23">								
									<table border="0" cellspacing="0" cellpadding="0" width="100%">
								  	  <tr><td height="28" style="padding-left:10px;font-weight:250;font-size:27px" width="400" class="labellarge"><cf_tl id="General"></td></tr>								  
								    </table>
							     </td>
								 </tr>
						   </table>
					   </td>
					   </tr> 
				     					   
				   </cfif>				   
				  
			  </cfif>	
			
			  <cfset hide = "1">		
			  <cfset row = 0 >
					
			  <cfoutput>
										
				<cfset Mode = Heading>
				<cfset prior = "close">
				
				<cfinvoke component="Service.AccessReport"  
				          method="report"  
						  ControlId="#ControlId#" 
						  Owner="#Owner#"
						  returnvariable="access">								 									 
					
					<cfif FunctionClass eq "System" or access is "GRANTED">
							
					     <cfset hide = "0">
						 
						 <cfif prior eq "open">
							 <td width="50%"></td>
							 </tr>
						 </cfif>
										 				     
						 <cfif row eq "0"><tr>
							 <cfset prior = "open">
						 </cfif>
						 
						 <cfset vWidth = "50%">
						 <cfif FunctionClass eq "System">
						 	<cfset vWidth = "100%">
						 </cfif>
						 				 
						 <td align="center" colspan="3" width="#vWidth#" style="border-bottom:1px dotted silver; padding-bottom:1px; padding-top:1px">
												 		      	 	  	  
							  <table width="98%"							     
								  align="center" 						  								  
							      onMouseOver="hl(this,true,'')" 
								  onMouseOut="hl(this,false,'')">
							       	
							     <!--- <tr> --->
								 
								 <cfset id = ControlId>
								 
								 <cfif FunctionClass eq "System">
								 
									 <cfquery name="Defaults" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT   U.ReportId
									FROM     Ref_ReportControlLayout L, UserReport U
									WHERE    L.ControlId = '#ControlId#'
									AND      L.LayoutId  = U.LayoutId
									AND      U.OfficerUserId = '#SESSION.acc#'  
									</cfquery>
																
									<cfif Defaults.recordcount gte "1">			
									   <cfset id = "#Defaults.ReportId#">			
									</cfif>
									
								 </cfif>									
								
								 <td style="height:54px" onClick="load('#id#','#FunctionClass#','#templateSQL#','#url.portal#')">
																
								 <table border="0" cellspacing="0" cellpadding="0" width="100%">
								 
									 <tr>									 	
									 <td width="35" style="padding-left:3px" align="center">							 	 
								    	 <cfinclude template="submenuImages.cfm">							     			
								     </td>										
								     <td align="left" height="21">
									    
										 <table cellspacing="0" cellpadding="0">										
											 <tr>
											 	<td style="padding-left:10px;font-size:20px;height:20px" class="labelmedium">
												    <cfif ReportLabel neq "">
													<a>#ReportLabel#</a>
													<cfelse>
													<a>#FunctionName#</a>
													</cfif>													
													<cfif FunctionClass neq "System" and client.languageid neq languagecode><font size="2" color="gray">[#languagecode#]</cfif>
												</td>
											</tr>										 
											 <cfif FunctionMemo neq "">										 
												 <tr><td style="padding-left:20px;height:20px" class="labelmedium">
												    #FunctionMemo# <font size="2" color="808080">[#owner#]	
												 </td></tr>										 
											 <cfelse>										 
											 	 <tr><td style="padding-left:16px;height:20px;font-size:14px" class="labelmedium">
												    <font color="808080"><cf_tl id="no subtitle"></font>
												 </td></tr>										 										 
											 </cfif>	
										 </table>	
										 	 
									 </td>
									
									 </tr>
												 
								 </table>
								
								 </td>
									 		 
							 	<td width="10%" height="17" align="right" style="padding-right:10px;">
							 
								 <cfset v = replace(menuclass," ","","ALL")>
														 
								 <cfinvoke component="Service.AccessReport"  
							          method="editreport"  
									  ControlId="#ControlId#" 
									  returnvariable="accessedit">
									  
									  <cfif accessedit is "EDIT" or accessedit is "ALL"> 
									  
									  	 <button class="button3" onClick="reportedit('#ControlId#')">     
								 			 <img src="#SESSION.root#/Images/configure.gif" alt="Report configuration" name="img0_#v#_#currentrow#" 
											  onMouseOver="document.img0_#v#_#currentrow#.src='#SESSION.root#/Images/configure.gif'" 
											  onMouseOut="document.img0_#v#_#currentrow#.src='#SESSION.root#/Images/configure.gif'"
											  style="cursor: pointer;" height="15" width="15"  border="0" align="absmiddle">
										</button> 	  						  
											  
									  </cfif>
							 
							 	</td> 
								
						    	 </tr> 
								 
								 <cfif functionClass eq "system">
									<tr>
										<td colspan="2" id="tdSystemVars"></td>
									</tr>
								 </cfif>							
							 			 		 	    
						     	</table>
						 	    
					     </td>
						 
						 <cfset row = row+1>
														 
						 <cfif row eq "2">
						 	<cfset prior = "close">
						  	 </tr>					
						 </cfif>				 
						 						 				 					 
					 </cfif>	
					 
					 <cfif row eq "2">
						 <cfset row = "0">
					 </cfif> 
				   
		 </cfoutput>		
		
		 <cfif prior eq "open">
				 <td width="50%"></td>
				 </tr>
		 </cfif>
						
		</TABLE>
		
		</td></tr>			
				
		<cfif hide eq "1">
			<cfset h = "hide">
		<cfelse>
		    <cfset h = "">
		</cfif>  
				 
		<script language="JavaScript">
	       se = document.getElementsByName("#MenuClass#")		
		   cnt = 0
		   while (se[cnt]) {
		       se[cnt].className = "#h#"
			   cnt++
		   }	    		  
		</script>			
			
		</cfoutput>
		
	 </cfoutput>
			
		</table>
		
	</cfif>	
	
</cfif>