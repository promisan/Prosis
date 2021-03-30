
<cfparam name="attributes.systemfunctionid"	    default="">
<cfparam name="attributes.id"			        default="">
<cfparam name="attributes.height"		        default="250px">
<cfparam name="attributes.width"		        default="300px">
<cfparam name="attributes.style"		        default="">
<cfparam name="attributes.headerStyle"	        default="height:20px; font-weight:normal;">
<cfparam name="attributes.headerPadding"	    default="2px">
<cfparam name="attributes.iconSet"		        default="red">
<cfparam name="attributes.iconHeight"		    default="32px">
<cfparam name="attributes.iconStyle"		    default="">
<cfparam name="attributes.filterValue"	        default="">
<cfparam name="attributes.customFilter"		    default="">
<cfparam name="attributes.label"	            default="">
<cfparam name="attributes.source"		        default="">
<cfparam name="attributes.mission"	            default="">
<cfparam name="attributes.units"		        default="0">
<cfparam name="attributes.unitsMultiple"	    default="No">
<cfparam name="attributes.period"	            default="">
<cfparam name="attributes.option"	            default="">
<cfparam name="attributes.DefaultOrgUnit"	    default="0">
<cfparam name="attributes.DefaultPeriod"	    default="">
<cfparam name="attributes.selectlist"	        default="">
<cfparam name="attributes.DefaultList"	        default="">
<cfparam name="attributes.showRefresh"	        default="1">
<cfparam name="attributes.showPrint"	        default="0">
<cfparam name="attributes.PrintCallback"        default="">
<cfparam name="attributes.showSeparator"	    default="1">
<cfparam name="attributes.onClick"			    default="">
<cfparam name="attributes.transition"		    default="fade"> <!--- none, fade, slideHorizontal, slideVertical --->
<cfparam name="attributes.transitionTime"	    default="1500">
<cfparam name="attributes.transitionEase"	    default="swing"> <!--- http://api.jqueryui.com/easings/ --->

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>

<cfset parentPane = getbasetagdata("CF_PANE")>
<cfset parentId   = parentPane.attributes.id>

<cfif find("?",attributes.source)>
	<cfset targeturl = "#attributes..source#&">
<cfelse>
    <cfset targeturl = "#attributes..source#?">
</cfif>

<cfif attributes.customFilter neq "">
	<cfif find("?",attributes.customFilter)>
		<cfset customFilterUrl = "#attributes..customFilter#&">
	<cfelse>
	    <cfset customFilterUrl = "#attributes..customFilter#?">
	</cfif>
<cfelse>
    <cfset customFilterUrl = "">
</cfif>

<cfset parentId = replace(parentId, "-", "", "ALL")>
<cfset attributes.id = replace(attributes.id, "-", "", "ALL")>

<cfoutput>

	<div class="pane_clsSummaryPanelItem pane_clsSummaryPanelItem_#parentId#" style="border:0px;height:#attributes.height#; width:#attributes.width#; #attributes.style#" onclick="#attributes.onClick#">
	
	     <table border="0" style="width:100%">
		 
		 <tr>
		 	<td class="labellarge" style="font-size:20px;padding:#attributes.headerPadding#; #attributes.headerStyle#" id="paneTitle_#parentId#_#attributes.id#">						
		 		 #Attributes.Label#
				 <div style="display:none;" class="pane_clsPaneFilterContent pane_clsPaneFilterContent_#parentId#">#attributes.filterValue#</div>
			</td>
			<td align="right" style="padding-right:7px; #attributes.headerStyle#; text-align:right;">
						
				<table align="right">
					<tr>
										
						<cfif attributes.showRefresh eq 1>
						
							<td>
								<div style="text-align:right; #attributes.iconStyle#" class="pane_clsSummaryPanelItemRefresh">								
																
									<cfif attributes.transition eq "none">																
									
										<cfsavecontent variable="refreshJSFunction">
											<cfif attributes.customFilter neq "">
												ptoken.navigate('#customFilterUrl#orgunit='+$('###attributes.id#_#parentId#_org').val()+'&period='+$('###attributes.id#_#parentId#_period').val(),'paneCustomFilter_#parentId#_#attributes.id#');
											</cfif>   
											ptoken.navigate('#targeturl#orgunit='+$('###attributes.id#_#parentId#_org').val()+'&period='+$('###attributes.id#_#parentId#_period').val()+'&selectmode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#');
										</cfsavecontent>
										
									<cfelse>							
										
										<cfsavecontent variable="refreshJSFunction">
											_cf_loadingtexthtml='';

											<cfif attributes.customFilter neq "">

												window.__paneCustomFilterCallback_#parentId#_#attributes.id# = function() {
													Prosis.presentation('##paneCustomFilter_#parentId#_#attributes.id#','#attributes.transition#','on','#attributes.transitionTime#','#attributes.transitionEase#',function(){});
												}
												
												Prosis.presentation('##paneCustomFilter_#parentId#_#attributes.id#','#attributes.transition#','off','#attributes.transitionTime#','#attributes.transitionEase#',function(){
													ptoken.navigate('#customFilterUrl#orgunit='+$('###attributes.id#_#parentId#_org').val()+'&period='+$('###attributes.id#_#parentId#_period').val(),'paneCustomFilter_#parentId#_#attributes.id#', '__paneCustomFilterCallback_#parentId#_#attributes.id#', null, null, null);
												});
												
											</cfif>  
											
											window.__paneFilterCallback_#parentId#_#attributes.id# = function() {
												Prosis.presentation('##pane_#parentId#_#attributes.id#','#attributes.transition#','on','#attributes.transitionTime#','#attributes.transitionEase#',function(){});
											}
											
											Prosis.presentation('##pane_#parentId#_#attributes.id#','#attributes.transition#','off','#attributes.transitionTime#','#attributes.transitionEase#',function(){
												ptoken.navigate('#targeturl#orgunit='+$('###attributes.id#_#parentId#_org').val()+'&period='+$('###attributes.id#_#parentId#_period').val()+'&mode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#', '__paneFilterCallback_#parentId#_#attributes.id#', null, null, null);
											});
											
										</cfsavecontent>
									</cfif>
																															
									<cf_tl id="Refresh" var="1">	
									
									<img id="content_#replace(attributes.systemfunctionid,'-','','ALL')#_#attributes.id#_refresh"
										title="#lt_text#"
										src="#session.root#/Images/Refresh_#attributes.iconSet#.png" 
										style="height:#attributes.iconHeight#; cursor:pointer;"
										onclick="#preserveSingleQuotes(refreshJSFunction)#">
									
								</div>
							</td>
						</cfif>
						
						<cfif attributes.showPrint eq 1>
							<td style="padding-left:5px;" valign="top">
								<div style="text-align:right; #attributes.iconStyle#" class="pane_clsSummaryPanelItemPrint">
								
									<cf_tl id="Print" var="1">

									<img id="content_#attributes.id#_refresh"
										title="#lt_text#"
										src="#session.root#/Images/print_#attributes.iconSet#.png" 
										style="height:#attributes.iconHeight#; cursor:pointer;" 
										onclick="Prosis.webPrint.print('##paneTitle_#parentId#_#attributes.id#', '##pane_#parentId#_#attributes.id#', true, function() { #attributes.PrintCallback# });">
										
								</div>
							</td>
						</cfif>
					</tr>
				</table>
				
			</td>
		 </tr>		
		 
		 <!---
		 <cfif attributes.showSeparator eq 1>
		 <tr><td colspan="2" class="line"></td></tr> 	
		 </cfif>
		 --->
		 
		 <cfparam name="url.mission" default="">	
		 			
		 <cfif attributes.mission neq "">
		 
		 <tr><td colspan="2">
		 		 
			 <table style="width:100%;">
			 <tr style="background-color:fbfbfb">	
			 			 			 
			 		<cfset linksave = "#session.root#/Tools/Listing/Pane/setSelection.cfm?systemfunctionid=#attributes.systemfunctionid#&conditionfield=mission&conditionvalue=#attributes.mission#">
			 					<!--- select mission branch --->
														 			
					<cfif attributes.option eq "Parent">
							 					
						<td style="padding-left:7px;width:400px;padding;2px">
																						 
						 	<cfquery name="Mandate" 
						     datasource="AppsOrganization" 
					    	 username="#SESSION.login#" 
						     password="#SESSION.dbpw#">	 
								 SELECT * 
								 FROM   Ref_Mandate
								 WHERE  Mission       = '#attributes.mission#'
								 ORDER BY MandateDefault DESC
							 </cfquery>
							 							 												 
							 <cfif customFilterUrl eq "">
							 	  <cfset cus = "">								  
							 <cfelse>							 
							 	  <cfset cus = "_cf_loadingtexthtml='';ptoken.navigate('#customFilterUrl#orgunit='+$('###attributes.id#_#parentId#_org').val()+'&period='+$('###attributes.id#_#parentId#_period').val(),'paneCustomFilter_#parentId#_#attributes.id#')">							  
							 </cfif>
							 
							 <cfquery name="getOrg" 
						     datasource="AppsOrganization" 
					    	 username="#SESSION.login#" 
						     password="#SESSION.dbpw#">	 
									 SELECT    * 
									 FROM      Organization 
									 WHERE     Mission   = '#attributes.mission#'
									 AND       MandateNo = '#Mandate.MandateNo#'
									 AND      (ParentOrgunit is NULL or ParentOrgunit = '' or Autonomous = 1)		
									 
									 <cfif attributes.units neq "0" and attributes.units neq "">									 										
									 AND   OrgUnit IN (#attributes.units#)								 																												 
									 </cfif>								 
									 
									 ORDER BY  HierarchyCode 								 
							 </cfquery>																												
							 
							 <cfif getOrg.recordcount gte "1">
							 							 
									 <cf_UIselect name = "#attributes.id#_#parentId#_org"	
										    onchange       = "ptoken.navigate('#linksave#&conditionvalueattribute1='+$('###attributes.id#_#parentId#_org').val(),'panesave_#parentId#_#attributes.id#');ptoken.navigate('#targeturl#period='+$('###attributes.id#_#parentId#_period').val()+'&orgunit='+$('###attributes.id#_#parentId#_org').val()+'&mode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#');#cus#"
											class          = "regularXXL"
											id             = "#attributes.id#_#parentId#_org"		
											multiple       = "#attributes.UnitsMultiple#"													
											style          = "border:0px;background-color:f1f1f1"											
											query          = "#getOrg#"
											queryPosition  = "below"
											selected       = "#attributes.DefaultOrgUnit#"
											value          = "OrgUnit"
											display        = "OrgUnitName">
											
										<cfif attributes.units eq "0" or attributes.units eq "" and attributes.OrgUnitsMultiple neq "multiple">									
											 <option value="">All</option>
										</cfif> 
									
									</cf_UISelect>
							 							 
							 <cfelse>
							 							 
								  <cfquery name="getOrg" 
							     datasource="AppsOrganization" 
						    	 username="#SESSION.login#" 
							     password="#SESSION.dbpw#">	 
										 SELECT    * 
										 FROM      Organization 
										 WHERE     Mission   = '#attributes.mission#'
										 AND       MandateNo = '#Mandate.MandateNo#'								 																	 										
										 AND       OrgUnit IN (#attributes.units#)	
										 ORDER BY  HierarchyCode 								 
								 </cfquery>
								 
								 <cfif getorg.recordcount eq "0">
								 
								    <cfquery name="getOrg" 
								     datasource="AppsOrganization" 
							    	 username="#SESSION.login#" 
								     password="#SESSION.dbpw#">	 
											 SELECT    * 
											 FROM      Organization 
											 WHERE     Mission   = '#attributes.mission#'
											 AND       MandateNo = '#Mandate.MandateNo#'								 																	 																				 
											 ORDER BY  HierarchyCode 								 
									 </cfquery>									 																		 									 				 
								 
								 </cfif>
								 
								  <cf_UIselect name = "#attributes.id#_#parentId#_org"	
									       onchange       = "ptoken.navigate('#linksave#&conditionvalueattribute1='+$('###attributes.id#_#parentId#_org').val(),'panesave_#parentId#_#attributes.id#');ptoken.navigate('#targeturl#period='+$('###attributes.id#_#parentId#_period').val()+'&orgunit='+$('###attributes.id#_#parentId#_org').val()+'&mode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#');#cus#"											
										   class          = "regularXXL"
											id             = "#attributes.id#_#parentId#_org"		
											multiple       = "#attributes.UnitsMultiple#"													
											style          = "border:0px;background-color:f1f1f1"											
											query          = "#getOrg#"											
											selected       = "#attributes.DefaultOrgUnit#"
											value          = "OrgUnit"
											display        = "OrgUnitName">
											
									</cf_UISelect>	
							 
							 </cfif>
						 				 
						 </td>	
						 
					<cfelseif attributes.option eq "unit">
					
						<td style="padding-left:7px;padding:2px">
																						 
						 	<cfquery name="Mandate" 
						     datasource="AppsOrganization" 
					    	 username="#SESSION.login#" 
						     password="#SESSION.dbpw#">	 
								 SELECT * 
								 FROM   Ref_Mandate
								 WHERE  Mission = '#attributes.mission#'
								 ORDER BY MandateDefault DESC								
							 </cfquery>
							 
							 <!--- "Prosis.busyRegion('yes','pane_#parentId#_#attributes.id#') --->
														 
							 <cfif customFilterUrl eq "">
							 	  <cfset cus = "">								  
							 <cfelse>							 
							 	  <cfset cus = "_cf_loadingtexthtml='';ptoken.navigate('#customFilterUrl#orgunit='+$('###attributes.id#_#parentId#_org').val()+'&period='+$('###attributes.id#_#parentId#_period').val(),'paneCustomFilter_#parentId#_#attributes.id#')">							  
							 </cfif>
							 
							 <cfquery name="getOrg" 
						     datasource="AppsOrganization" 
					    	 username="#SESSION.login#" 
						     password="#SESSION.dbpw#">	 
									 SELECT    * 
									 FROM      Organization 
									 WHERE     Mission   = '#attributes.mission#'
									 AND       MandateNo = '#Mandate.MandateNo#'
									 
									 <cfif attributes.units neq "0" and attributes.units neq "">									 										
									 AND   OrgUnit IN (#attributes.units#)								 																												 
									 </cfif>								 
									 
									 ORDER BY  HierarchyCode 								 
							 </cfquery>
							 
							 <cfif getOrg.recordcount gte "1">							 
							 
							  		<cf_UIselect name = "#attributes.id#_#parentId#_org"	
											onchange       = "ptoken.navigate('#linksave#&conditionvalueattribute1='+$('###attributes.id#_#parentId#_org').val(),'panesave_#parentId#_#attributes.id#');ptoken.navigate('#targeturl#period='+$('###attributes.id#_#parentId#_period').val()+'&orgunit='+$('###attributes.id#_#parentId#_org').val()+'&mode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#');#cus#"									
											class          = "regularXXL"
											id             = "#attributes.id#_#parentId#_org"		
											multiple       = "#attributes.UnitsMultiple#"													
											style          = "border:0px;background-color:f1f1f1"											
											query          = "#getOrg#"
											queryPosition  = "below"
											selected       = "#attributes.DefaultOrgUnit#"
											value          = "OrgUnit"
											display        = "OrgUnitName">
											
										<cfif attributes.units eq "0" or attributes.units eq "" and attributes.OrgUnitsMultiple neq "multiple">									
											 <option value="">All</option>
										</cfif> 
									
									</cf_UISelect>					 		
							 
							 <cfelse>
							 
								  <cfquery name="getOrg" 
							     datasource="AppsOrganization" 
						    	 username="#SESSION.login#" 
							     password="#SESSION.dbpw#">	 
										 SELECT    * 
										 FROM      Organization 
										 WHERE     Mission   = '#attributes.mission#'
										 AND       MandateNo = '#Mandate.MandateNo#'								 																	 										
										 AND       OrgUnit IN (#attributes.units#)	
										 ORDER BY  HierarchyCode 								 
								 </cfquery>
								 
								 <cf_UIselect name = "#attributes.id#_#parentId#_org"	
										onchange       = "ptoken.navigate('#linksave#&conditionvalueattribute1='+$('###attributes.id#_#parentId#_org').val(),'panesave_#parentId#_#attributes.id#');ptoken.navigate('#targeturl#period='+$('###attributes.id#_#parentId#_period').val()+'&orgunit='+$('###attributes.id#_#parentId#_org').val()+'&mode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#');#cus#"
										class          = "regularXXL"
										id             = "#attributes.id#_#parentId#_org"		
										multiple       = "#attributes.UnitsMultiple#"													
										style          = "border:0px;background-color:f1f1f1"											
										query          = "#getOrg#"
										queryPosition  = "below"
										selected       = "#attributes.DefaultOrgUnit#"
										value          = "OrgUnit"
										display        = "OrgUnitName"/>																 
															 
							 </cfif>
						 				 
						 </td>	 
					 
					 <cfelse>
					 					 					
					   <input type="hidden" id="#attributes.id#_#parentId#_org" value=""> 										
					 
					 </cfif>	
					 
					 <!--- select period --->	
					 
					
										
					<cfif customFilterUrl eq "">										
					  <cfset cus = "Prosis.busyRegion('yes','pane_#parentId#_#attributes.id#');">					  
					 <cfelse>					 										
					  <cfset cus = "_cf_loadingtexthtml='';ptoken.navigate('#customFilterUrl#period='+this.value+'&orgunit='+$('###attributes.id#_#parentId#_org').val(),'paneCustomFilter_#parentId#_#attributes.id#')">					 
					 </cfif>								
					 
					 <cfif attributes.Period neq "">						
					 
						 <td style="padding-left:7px;">
						 						 
						 <select id="#attributes.id#_#parentId#_period" 
						    class="regularxxl" style= "border:0px;background-color:f1f1f1"
							onchange="ptoken.navigate('#linksave#&conditionvalueattribute2='+$('###attributes.id#_#parentId#_period').val(),'panesave_#parentId#_#attributes.id#');ptoken.navigate('#targeturl#period='+this.value+'&orgunit='+$('###attributes.id#_#parentId#_org').val()+'&mode='+$('###attributes.id#_#parentId#_selectmode').val(),'pane_#parentId#_#attributes.id#');#cus#">						
							 <cfloop index="per" list="#Attributes.Period#">
							 
							 	<cfif attributes.DefaultPeriod eq "">
								   <cfset attributes.DefaultPeriod = per>					
								</cfif>
								
							    <option value="#per#" <cfif attributes.DefaultPeriod eq per>selected</cfif>>#Per#</option>
							 </cfloop>			 
						 </select>
						 
						 </td>
						 
					<cfelse>	
					
					   <input type="hidden" id="#attributes.id#_#parentId#_period" value=""> 
														 
					</cfif>		
					 
					 <!--- custom mode for the topics --->	 
					 
					 <cfif attributes.selectList neq "">
						 
						 <cfoutput>
						 
						     <cfset row = 0>							 
						    
							 <cfloop index="itm" list="#attributes.selectList#">
							 
							 	  <cfset row = row+1>
								  								  
								  <cfif row eq "1">
								     <cfif attributes.DefaultList eq "">
									   <input type="hidden" id="#attributes.id#_#parentId#_selectmode" value="#itm#"> 
									 <cfelse>
									   <input type="hidden" id="#attributes.id#_#parentId#_selectmode" value="#attributes.DefaultList#"> 
									 </cfif>
								  </cfif>
								  
								  <td style="padding-left:10px">								 
								  
								  <input type="radio" name="#attributes.id#_#parentId#_selectmodename" <cfif row eq "1" or Attributes.DefaultList eq itm>checked</cfif> value="#itm#" onclick="ptoken.navigate('#linksave#&conditionvalueattribute3='+this.value,'panesave_#parentId#_#attributes.id#');$('###attributes.id#_#parentId#_selectmode').val(this.value);ptoken.navigate('#targeturl#period='+$('###attributes.id#_#parentId#_period').val()+'&orgunit='+#attributes.id#_#parentId#_org+'&mode=#itm#','pane_#parentId#_#attributes.id#');"></td>
								  <td style="padding-left:4px" class="labelmedium2">#itm#</td>
								  
							 </cfloop>
						 
						 </cfoutput>
						 
					 <cfelse>
					 
					 	  <input type="hidden" id="#attributes.id#_#parentId#_selectmode" value=""> 
					 					 					 
					 </cfif>	
					 
					 <cfif attributes.customFilter neq "">
						 <td style="padding-left:5px;">						 
						 	<cfset mid = oSecurity.gethash()/> 						
						 	<cfdiv id="paneCustomFilter_#parentId#_#attributes.id#" bind="url:#customFilterUrl#orgunit=#attributes.defaultorgunit#&period=#attributes.defaultPeriod#&mid=#mid#">
						 </td>			
					 </cfif>	
				 
				 </tr>					
			 
			 </table>
		 
		 </td>			
				
		 </tr>		
						 	 
		 </cfif>		
		 
		 <tr class="hide"><td colspan="2"><cfdiv id="panesave_#parentId#_#attributes.id#"></td></tr>			 	
		 		
		 <tr><td colspan="2" style="padding-top:2px">			
			<cfset mid = oSecurity.gethash()/>  						
			<cfdiv id="pane_#parentId#_#attributes.id#" 
			   bind="url:#targeturl#orgunit=#attributes.defaultorgunit#&period=#attributes.defaultPeriod#&mode=#attributes.DefaultList#&mid=#mid#">					   
			</td>
		
		 </tr>
		
		</table>
		
	</div>
	
</cfoutput>