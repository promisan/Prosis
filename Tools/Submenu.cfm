
<cfparam name="scope" default="standard">

<cfif scope eq "standard">
	<cf_screentop html="No">
</cfif>

<cfparam name="presentation" default="1">

<cfparam name="CLIENT.Languageid" default="">
<cfif CLIENT.LanguageId eq "">
	 <cfset CLIENT.languageId = "ENG">
</cfif>
<cfparam name="CLIENT.Browser" default="Explorer">

<!--- removed by Armin as it is duplicated from SubmenuMission.cfm 7/21/2013 
<link href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>" rel="stylesheet" type="text/css">
--->

<style>

	table.highLightT {
		BACKGROUND-COLOR: dddddd;
	}
	
	table.regularT1 {
		BACKGROUND-COLOR: ffffff;
	}

	table.regularZ {
		BACKGROUND-COLOR: ffffff;
	}
	
</style>

<cfparam name="Attributes.heading"     default="">
<cfparam name="Attributes.granted"     default="No">
<cfparam name="Attributes.module"      default="">
<cfparam name="Attributes.selection"   default="">
<cfparam name="Attributes.dir"         default="">
<cfparam name="Attributes.loadscript"  default="Yes">
<cfparam name="Attributes.class"       default="'main'">

<cfif attributes.heading neq "">

	<cfset heading   = "#Attributes.heading#">
	<cfset module    = "#Attributes.module#">
	<cfset selection = "#Attributes.selection#">
	<cfset dir       = "#Attributes.dir#">
	<cfset class     = "#Attributes.class#">

</cfif>

<!--- ----------- --->
<!--- script file --->
<!--- ----------- --->

<cfif attributes.loadscript eq "Yes">
	 <cfinclude template="SubmenuScript.cfm">
	 <cfinclude template="SubmenuScriptLoad.cfm">
</cfif>
 
<cfparam name="class" default="'Main'">

<cfif class eq 'Main'>

	<table width="100%">
	<tr>
	<td colspan="3" style="font-weight:340;font-size:23px"><cfoutput>#Heading#</cfoutput></td>
	<TD></TD>
	</table>
	<hr>

</cfif>

<!--- ---------------------- --->
<!--- create views if needed --->
<!--- ---------------------- --->

<cftry>

    <cfquery name="SearchResultX" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#"> 
		SELECT   TOP 1 *, FunctionVirtualDir 
		FROM     xl#Client.LanguageId#_Ref_ModuleControl 
	</cfquery>
							
	<cfcatch>						
		<cfinclude template="../System/Language/View/GenerateViews.cfm">						
    </cfcatch>
		
</cftry>

<cfparam name="passtru" default="">

<cfif find("Mission",class) and selection neq "favorite">

	<cf_licenseCheck module="#preserveSingleQuotes(Module)#" 
	    mission="'#Heading#'" 
		message="No">
	
<cfelse>

	<cfset license = 1>
	
</cfif> 
	
<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		
		SELECT  M.Description as ModuleDescription, 
		        M.menuOrder as ModuleOrder, 
				R.*,				
				
				( SELECT TOP 1 S.ActionTimeStamp
					FROM   UserActionModule S
				    WHERE  S.SystemFunctionId = R.SystemFunctionId
				    ORDER BY S.ActionTimeStamp DESC
				) as Log,															 
				
				(  SELECT count(*)
				   FROM   System.dbo.UserFavorite
				   WHERE  Account          = '#SESSION.acc#'
				   AND    SystemFunctionId = R.SystemFunctionId) 
				  as Favorite
				
				<cfif selection eq "Favorite">
				
					,F.Condition as ConditionRevised
					,F.Owner
					
				<cfelse>
				
					,'' as ConditionRevised 
					,'' as Owner
					
				</cfif>				
				
		FROM    xl#Client.LanguageId#_Ref_ModuleControl R
		        <cfif Client.LanguageId eq "ENG">
					,Ref_SystemModule M
				<cfelse>
					,xl#Client.LanguageId#_Ref_SystemModule M
				</cfif>		
				<cfif selection eq "Favorite">    				   
					,UserFavorite  F 
				</cfif>
				
		WHERE   R.SystemModule = M.SystemModule		

		<!--- default --->
		AND     R.Mission = ''
		
		<cfif selection eq "Favorite">
		
		    AND R.SystemFunctionId = F.SystemFunctionId
			AND F.Account = '#SESSION.acc#'
			<cfif find("Mission",class)>
			AND    F.Mission = '#Heading#'			
			<cfelse>
			AND    F.Mission is NULL
			</cfif> 
						
		<cfelse>
		
			<cfif module neq "">	
			AND     R.SystemModule  =  #PreserveSingleQuotes(module)#  
			</cfif>
			
			<cfif class neq "any" and class neq "">
			AND     R.MenuClass     IN (#PreserveSingleQuotes(class)#)					
			</cfif>
		
			<cfif selection neq "">				   
			AND     R.FunctionClass IN (#PreserveSingleQuotes(selection)#)						
			</cfif>
			
		</cfif>
				
		AND     R.Operational   = '1'
		
		<cfif find("Mission",class) or find("Detail",class)>	
		AND 	R.SystemFunctionId NOT IN (SELECT   SystemFunctionId
									       FROM     Ref_ModuleControlDeny 
									       WHERE    Mission = '#Heading#')  
		</cfif>								   
        ORDER BY M.MenuOrder, R.FunctionClass, R.MenuOrder
		      
</cfquery>
	
<cfif SearchResult.recordcount eq "0">	
	<cfinclude template="../System/Modules/Functions/ModuleControl/ModuleLanguage.cfm">
</cfif>

<!--- Search form --->

<cfset row = 0>

<cfif Searchresult.recordcount gt "0">

	<cfif Module neq "'Portal'" and not find("Mission",class)>	
		<table width="94%"   align="center" border="0" bgcolor="white">
	<cfelseif find("Mission",class) or find("Detail",class)>	
		<table width="100%"  align="center" border="0" bgcolor="white">
	<cfelse>
		<table width="96%"   align="center" border="0" bgcolor="white">
	</cfif>

<tr class="hide"><td id="modulelog"></td></tr>

<tr><td style="padding-left:15px;padding-right:15px" valign="top">

<table width="100%" valign="top" align="center" bgcolor="white">

<cfif not find("Mission",class) and selection eq "Favorite">
     <cfset grp = "ModuleOrder">
<cfelse>
     <cfset grp = "FunctionClass"> 	 
</cfif>

<cfif selection eq "Favorite" and not find("Mission",class) and not find("Detail",class)>

	   <cfoutput>	   
	   	  		   	   
		   <tr class="xxxhide" id="m#heading#"><td colspan="6">
		   
			   <table width="458" border="0" cellspacing="0" cellpadding="0">
				 	<tr>
					<td width="100%" height="40">
						<table border="0" cellspacing="0" cellpadding="0">
						  <tr><td class="labellarge" style="font-weight:340;font-size:23px;padding-left:20px">
						  #Heading# 
						  </td></tr>
					    </table>
				    </td>
					</tr>  
			   </table>	
			   
		   </td></tr>
		   
		   <tr id="m#heading#" class="hide"><td height="1" colspan="6" bgcolor="e4e4e4"></td></tr>
	   
	   </cfoutput>

</cfif>


	<cfoutput query="searchresult" group="#grp#">	
				
		<cfif grp eq "ModuleOrder">		
			
			  <tr id="m#grp#1" class="hide"><td height="4"></td></tr>
			   <tr class="hide" id="m#grp#2"><td colspan="6">
			  
				   <table width="323" border="0" cellspacing="0" cellpadding="0">
					 	<tr>
						<td width="100%" height="18">
							<table border="0" cellspacing="0" cellpadding="0">
							  <tr><td class="labelit" style="padding-left:20px;font-weight:340;font-size:20px">
							  #ModuleDescription#  
							  </td></tr>
						    </table>
					    </td>
						</tr>  
				   </table>	
				   
			   </td></tr>
			   
			   <tr id="m#grp#3" class="xhide"><td height="1" colspan="6"></td></tr>
			   
		<cfelseif find("Detail",class)>	   
			   	
		<cfelseif not find("Mission",class)>
									
		   <cfif Heading neq "">			   
		      	  
			   <tr id="m#heading#1" class="hide"><td height="5"></td></tr>			   
			   <tr class="hide" id="m#heading#2"><td colspan="6">		   
				   <table width="458" border="0" cellspacing="0" cellpadding="0">
					 	<tr><td>							
							<table border="0" cellspacing="0" cellpadding="0">
							  <tr>
							  <td style="padding-left:4px;height:40px;font-size:26px;font-weight:340;" class="labellarge">#Heading#</td>
							  </tr>
						    </table>
					    	</td>
						</tr>  
				   </table>					   
			   </td></tr>			   
			   <tr id="m#heading#3" class="hide"><td height="1" colspan="6"></td></tr>
		     
		   </cfif>
		    	  
		<cfelse>
					
			<!--- Mission --->
		
			<cfquery name="MissionHeader" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_Mission
				WHERE  Mission = '#Heading#' 
			</cfquery>
					   
		    <tr style="display:block;">
			  <td colspan="6" style="padding-top:14px">
			 			 			  	
				  <table width="100%">						
					  <tr>					  
					    <cfif getAdministrator("#Heading#") eq "1">
						 <td style="font-size:28px;font-weight:340" class="labelmedium tSearch"><a href="javascript:editentity('#heading#')">#Heading#</a> <font size="2" color="808080"><cfif MissionHeader.MissionName neq Heading>#MissionHeader.MissionName#</cfif></td>
						<cfelse>
						 <td style="font-size:28px;font-weight:340" class="labelmedium tSearch">#Heading# <cfif MissionHeader.MissionName neq Heading><font size="2" color="808080">#MissionHeader.MissionName#</cfif></td>
						</cfif>
					  </tr>						  
				  </table>
									  
			  </td>
			</tr>				
					  
		</cfif>
	
		<cfoutput>		
				
			<cfset access = "DENIED">
			
			<cfif findNoCase("Mission",class) or findNoCase("Detail",class)>
			
			    <cfset Mode = Heading>	
				
				<!--- --------------------------------  07/07/2014  ------------------------------- --->
				<!--- we grant administrators and local administrator access to the function always --->
				<!--- ----------------------------------------------------------------------------- --->
				
				<cfif getAdministrator("*") eq "1">			
					<cfset access = "GRANTED">
				</cfif>	
					
			 <cfelse>
			 
			    <cfset Mode = ScriptConstant>
				
			</cfif>	
		
			<cfparam name="passtru" default="">
			
			<!--- ---------------------------------------  07/07/2014  ------------------------------- --->
			<!--- if access is not set we are checking if the user has access to the function based on 
			any if he/her roles set for the function to make it visible------------------------------- --->
			<!--- ------------------------------------------------------------------------------------ --->
						
			<cfif access eq "DENIED">
					 		  
				<cfif FunctionName neq "Staffing Table">				
									
					<cfif attributes.granted eq "No">
					
						 <cfinvoke component="Service.Access"  
					        method="function"  
							SystemFunctionId="#SystemFunctionId#" 
							returnvariable="access">	
							
						 			  		  
					<cfelse>
					
						<cfset access = "GRANTED">
					
					</cfif>		
						
				<cfelse>
								
					<!--- special granted access to be check for favorites --->
									      
					<cfinvoke component="Service.Access"  
					      method="StaffingTable" 
						  mission="#Heading#" 
				   		  returnvariable="access">	 
					  
					  <cfif access neq "NONE">
					       <cfset access = "GRANTED">
					  </cfif>		
										  
				</cfif>		
				
			</cfif>					
					  			  	
			<CFIF access is "GRANTED"> 
			
				<cfset row = row + 1>
			
			     <!--- ------------------------------ --->
			     <!--- define if browser is supported --->
				 <!--- ------------------------------ --->
				 				 
				<cfif (CLIENT.browser eq "Explorer" and (BrowserSupport eq "1" or BrowserSupport eq "2")) 
					    or ((CLIENT.browser eq "Edge" or CLIENT.browser eq "Firefox"  or CLIENT.browser eq "Safari" or CLIENT.browser eq "Chrome") and BrowserSupport eq "2")>
								
				     <cfset functionsupport = "1">		
				 
				<cfelse>		
				
					<cfif functionClass eq "Maintain" or functionClass eq "System" or functionClass eq "Listing">			
						 <cfset functionsupport = "1">					
					<cfelse>		 
					     <cfset functionsupport = "0">		 			 
					</cfif> 
					 
				</cfif>		 
				
				<script>
		
					count = 1
					while (count != 4) {		
					  try {	  
					  document.getElementById('m#heading#'+count).className = "regular"	} catch(e) {}
					  count++
					} 
		
				</script>	
						
				<cfif ((FunctionClass neq "Application") and FunctionClass neq "Roster" and FunctionClass neq "Inquiry") or 
					  MenuClass eq "Special"                                        or
					  MenuClass eq "Audit"                                          or
					  (FunctionClass eq "Application" and SystemModule is "Roster") or
					  MenuClass eq "Builder"                                        or
					  Find("Mission",class)                                         or 
					  Find("Detail",class)                                          or
					  Presentation eq "2"                                           or
					  Selection eq "Favorite">		
					 					  					 					  		  								
					 <cfif Selection eq "Favorite">
					 			  			
						<cf_licenseCheck module="'#systemmodule#'" 
							    mission="'#Heading#'" 
								message="No">								
						
					 </cfif>					
										 			 	
				     <cfif row MOD 2>
					 					 									
						<TR>		
								 
					 </cfif>
					 			 		
					     <td style="width:<cfif row eq "2">50%</cfif>" valign="top" colspan="3" align="center">						
						 			 			 			 	 	 	 
						 <cfset condition = FunctionCondition>
						 	 
						 <cfif ConditionRevised neq "" and ConditionRevised neq "undefined">
						       <cfset condition = ConditionRevised>
						 </cfif>
								 
						 <cfif passtru neq "">
							 <cfset condition = passtru>
						 </cfif>
							 	 	 
						 <cfif find("Mission",class) or find("Detail",class)>
						 
						 	 <cfset selmission = heading>
					   		
							 <cfif condition eq "">
							    <cfset condition = "Mission=#Heading#">
							  <cfelse>	
							    <cfset condition = "#condition#&Mission=#Heading#">
							 </cfif>
							 
						 <cfelse>
						 	
							 <cfset selmission = "">	 
								 	 	 
						 </cfif>		
						 						 															 
						 <cfif functionsupport eq "1">
									
							 <cfif ScriptName eq "">
														 		
							     <table width="98%" align="center" class="regularZ formpadding" 
								     onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
																	  																						 
							     <cfset go = "modulelog('#systemfunctionid#','#selmission#');loadformI('#FunctionPath#','#condition#','#FunctionTarget#','#FunctionDirectory#','#systemFunctionId#','#Heading#','#EnforceReload#','#FunctionVirtualDir#','#FunctionHost#')">
				 				
							  <cfelse>
							  							  							  	 
								 <table width="98%" align="center" class="regularZ formpadding" onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
																										 									 					  					  
									  <cfif conditionRevised eq "" or conditionRevised eq "undefined">				  	  
									  
									     <cfset go = "modulelog('#systemfunctionid#','#selmission#');#ScriptName#('#mode#','#systemFunctionId#','#Heading#','#EnforceReload#','#functiontarget#')">																 
									  <cfelse>		 				    									  
										 <cfset go = "modulelog('#systemfunctionid#','#selmission#');#ScriptName#('#condition#','#systemFunctionId#','','','#functiontarget#')">															 
									  </cfif>					
												  	  
							  </cfif>	
							 						  
						<cfelse>
												  
						      <table width="98%" align="center" bordercolor="FFFFF4"  class="regularZ">							
							  <cfset go = "">
								  			  
						</cfif>								
												 			    	  
						<cfif find("Mission",class)>	
																		  	 			  
						      <tr bgcolor="<cfif license eq 0>FFCACA</cfif>">
							  
						        <td style="width:50px;padding-left:0px" align="center" rowspan="2" onclick="<cfif License eq 1>#go#</cfif>"> 																
									<cfinclude template="SubmenuImages.cfm">					
						   	    </td>	
								
								<td align="left" class="labelmedium" style="font-weight:340;height:18px;font-size:20px" valign="middle" onclick="<cfif License eq 1>#go#</cfif>">
																 								 
								   <!--- determine if we take another label here driven by the mission/entity --->
								    
								   <cfquery name="Alternate" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT FunctionName, FunctionMemo
										FROM   xl#Client.LanguageId#_Ref_ModuleControl
										WHERE  Mission = '#Heading#' 
										AND    SystemFunctionId = '#SystemFunctionId#'
								  </cfquery>
								   
								  <cfif Alternate.recordcount eq "1" and Alternate.functionname neq "">
								      <cfset nm  = Alternate.FunctionName>						  
								  <cfelse>
								      <cfset nm =  FunctionName>									 		   
								  </cfif>						
								   
								  <cfif Alternate.recordcount eq "1" and Alternate.functionmemo neq "">					   
									  <cfset st =  Alternate.FunctionMemo>						  
								  <cfelse>					   
									  <cfset st =  FunctionMemo> 							 		   
								  </cfif>		
								  							  					  
			 					  <cfif functionsupport eq "1">
									 <a>#nm#</a>
								  <cfelse>						
									 #nm#<font size="1" color="FF0000">&nbsp [#client.browser# is not supported]</font>
								  </cfif>
			
								  <cfif license eq 0>					  	
									<font size="3" color="FF0000"><cf_tl id="License Expired. Please contact your administrator"></font>
								  </cfif>			
									
								</td>  					
								
								<td rowspan="2" align="right"> 
																
									<cfif license eq 1>
									
									    <table align="right" class="formpadding">
											<tr>			
											
											<td>				
									
												<cfif SESSION.isAdministrator eq "Yes">
																						
													<cfquery name="CheckLogging" 
														datasource="AppsSystem" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															SELECT TOP 1 *
															FROM   UserActionModule 
															WHERE  SystemFunctionId = '#systemFunctionId#'					
													</cfquery>	
													
													<cfif CheckLogging.recordCount gt 0>
														<button type="button" class="button3" onClick="logging('#systemFunctionId#','#heading#')">    						 
												 			 <img src="#SESSION.root#/Images/info2.gif" alt="Function logging" height="16" width="16" border="0"
														   	  style="cursor: pointer;" alt="" border="0" align="absmiddle">										  
														</button>
													</cfif>
												</cfif>
											
											</td>		
																			
											<td>													
												<cfif SESSION.isAdministrator eq "Yes">	
												    <button class="button3" type="button" onClick="recordedit('#systemFunctionId#','#heading#')">     
											 		 <img src="#SESSION.root#/Images/configure.gif" alt="Function configuration" height="16" width="16" border="0"
													   	  style="cursor: pointer;" border="0" align="absmiddle">
													</button> 	
												</cfif>											
											</td>											
											<td style="padding-right:9px" id="fav_#systemFunctionId#_#heading#">																			
											<cfif favorite gte "1">											
											     <button type="button" type="button"  class="button3" onClick="favorite('0','#systemFunctionId#','#Heading#')">     
										 		 	<img src="#SESSION.root#/Images/favorite.gif" alt="Remove as Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
												 </button> 												 
											<cfelse>											
												 <button type="button" type="button"  class="button3" onClick="favorite('1','#systemFunctionId#','#Heading#')">     
										 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" alt="Add to Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
												 </button> 												
											</cfif>
											
											</td>
											</tr>
																		
										</table>
										
									</cfif>
								</td>	 
						      </tr>		
							  						    
							  <tr bgcolor="<cfif license eq 0>FFCACA</cfif>">

						        <td class="labelit" align="left" valign="middle" style="padding-left:8px" onclick="<cfif License eq 1>#go#</cfif>">
																
								<cfif st neq "">
								<font size="2">#st#</font><br>
								</cfif>
																		
								<cfif MenuClass eq "Builder">
								  						
									 <cfquery name="Log" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT   TOP 1 *
											FROM     Ref_ModuleControlDetailLog
											WHERE    SystemFunctionId = '#SystemFunctionId#'
											ORDER BY Created DESC			
									 </cfquery>
										
									 <cfif Log.recordcount eq "1">
										&nbsp;<font>Listing configured:</i> <font size="1" color="808080"> #DateFormat(Log.Created, CLIENT.DateFormatShow)# #TimeFormat(Log.Created, "HH:MM")#</font>		
									 </cfif>
															
								</cfif>											
								
								</td>   
								
						      </tr>		
							  
						 <cfelseif find("Detail",class)>
						 
						 <tr bgcolor="<cfif license eq 0>FFCACA</cfif>">
							  
						        <td style="width:50px;padding-left:0px" align="center" rowspan="2" onclick="<cfif License eq 1>#go#</cfif>"> 																
									<cfinclude template="SubmenuImages.cfm">					
						   	    </td>	
								
								<td align="left" class="labelmedium" style="font-weight:340;height:18px;font-size:16px" 
								 valign="middle" onclick="<cfif License eq 1>#go#</cfif>">
																 								 
								   <!--- determine if we take another label here driven by the mission/entity --->
								    
								   <cfquery name="Alternate" 
									datasource="AppsSystem" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT FunctionName, FunctionMemo
										FROM   xl#Client.LanguageId#_Ref_ModuleControl
										WHERE  Mission = '#Heading#' 
										AND    SystemFunctionId = '#SystemFunctionId#'
								  </cfquery>
								   
								  <cfif Alternate.recordcount eq "1" and Alternate.functionname neq "">
								      <cfset nm  = Alternate.FunctionName>						  
								  <cfelse>
								      <cfset nm =  FunctionName>									 		   
								  </cfif>						
								   
								  <cfif Alternate.recordcount eq "1" and Alternate.functionmemo neq "">					   
									  <cfset st =  Alternate.FunctionMemo>						  
								  <cfelse>					   
									  <cfset st =  FunctionMemo> 							 		   
								  </cfif>		
								  							  					  
			 					  <cfif functionsupport eq "1">
									 <a>#nm#</a>&nbsp;<br><font size="2" color="808080">#st#</font>
								  <cfelse>						
									 #nm#<font size="1" color="FF0000">&nbsp [#client.browser# is not supported]</font>
								  </cfif>
			
								  <cfif license eq 0>					  	
									<font size="3" color="FF0000"><cf_tl id="License Expired. Please contact your administrator"></font>
								  </cfif>			
									
								</td>  					
								
								<td align="right"> 
																
									<cfif license eq 1>
									
									    <table align="right" class="formpadding">
											<tr>	
											
											<td>				
									
												<cfif SESSION.isAdministrator eq "Yes">
																						
													<cfquery name="CheckLogging" 
														datasource="AppsSystem" 
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
															SELECT TOP 1 *
															FROM   UserActionModule 
															WHERE  SystemFunctionId = '#systemFunctionId#'					
													</cfquery>	
													
													<cfif CheckLogging.recordCount gt 0>
														<button type="button" class="button3" onClick="logging('#systemFunctionId#','#heading#')">    						 
												 			 <img src="#SESSION.root#/Images/info2.gif" alt="Function logging" height="16" width="16" border="0"
														   	  style="cursor: pointer;" alt="" border="0" align="absmiddle">										  
														</button>
													</cfif>
												</cfif>
											
											</td>		
																							
											<td>													
												<cfif SESSION.isAdministrator eq "Yes">	
												    <button class="button3" type="button" onClick="recordedit('#systemFunctionId#','#heading#')">     
											 		 <img src="#SESSION.root#/Images/configure.gif" alt="Function configuration" height="16" width="16" border="0"
													   	  style="cursor: pointer;" border="0" align="absmiddle">
													</button> 	
												</cfif>											
											</td>											
											<td style="padding-right:9px" id="fav_#systemFunctionId#_#heading#">																			
											<cfif favorite gte "1">											
											     <button type="button" type="button"  class="button3" onClick="favorite('0','#systemFunctionId#','#Heading#')">     
										 		 	<img src="#SESSION.root#/Images/favorite.gif" alt="Remove as Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
												 </button> 												 
											<cfelse>											
												 <button type="button" type="button"  class="button3" onClick="favorite('1','#systemFunctionId#','#Heading#')">     
										 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" alt="Add to Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
												 </button> 												
											</cfif>
											
											</td>
											</tr>
																		
										</table>
										
									</cfif>
								</td>	 
						      </tr>		
							  				  		  				  	
							  			  	 	       
						 <cfelse>
						 									 				 
						    <tr>
														
					        <td align="center" valign="middle" style="width:50px" onclick="#go#">																				
								<cfinclude template="SubmenuImages.cfm">																	
					       	</td>																	
				
							<td onclick="#go#">
																												
								<table cellspacing="0" cellpadding="0">
																
								<tr><td class="labelmedium" style="font-weight:340;height:20px;font-size:19px">	
																																		
									<cfif functionsupport eq "1">
										<cfif owner neq "">#Owner# </cfif><a>#FunctionName#</a>
									<cfelse>						
										<cfif owner neq "">#Owner# </cfif>#FunctionName# <font color="FF0000">: [#client.browser# not supported]</font>
									</cfif>									
									
									</td>
								</tr>	
																		
								<cfif functionMemo neq "">								
									<tr><td class="cellcontent" style="font-weight:340;height:15px;padding-left:8px">#FunctionMemo#</td></tr>									
								</cfif>							
								
								<cfif MenuClass eq "Builder">
								  						
									 <cfquery name="Log" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT    TOP 1 *
											FROM      Ref_ModuleControlDetailLog
											WHERE     SystemFunctionId = '#SystemFunctionId#'
											ORDER BY  Created DESC			
									 </cfquery>
										
									 <cfif Log.recordcount eq "1">		
									 <tr><td class="labelit" style="font-weight:340;height:15px;padding-left:9px">					
										<font color="808080">#Log.OfficerLastName# [#DateFormat(Log.Created, CLIENT.DateFormatShow)# #TimeFormat(Log.Created, "HH:MM")#]	
										</td>
									 </tr>	
									 </cfif>
															
								</cfif>				
								
								</table>
								
							</td>   
							
							<td align="right" width="5%" style="padding-right:9px">
																 
							 	<table border="0" align="right" class="formpadding">
									<tr>
																	
									<cfif log neq "">
									
										<cfset diff = dateDiff("d", log, now())>
										<td style="width:20px">
										<cfif diff gte 40>
											<table><tr><td style="border:1px solid black;width:14px;height:14px;background-color:red"></tr></table>
										</cfif>
										</td>				
										
									<cfelse>
									
										<td></td>	
										
									</cfif>				
									
									<td>				
									
										<cfif SESSION.isAdministrator eq "Yes">
																				
											<cfquery name="CheckLogging" 
												datasource="AppsSystem" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT TOP 1 *
													FROM   UserActionModule 
													WHERE  SystemFunctionId = '#systemFunctionId#'					
											</cfquery>												
																						
											<cfif CheckLogging.recordCount gt 0>
												<button type="button" class="button3" onClick="logging('#systemFunctionId#','')">    						 
										 			 <img src="#SESSION.root#/Images/info2.gif" alt="Function logging" height="16" width="16" border="0"
												   	  style="cursor: pointer;" alt="" border="0" align="absmiddle">										  
												</button>
											</cfif>
										</cfif>
									
									</td>							
									
									<td>		
									
									<cfif (getAdministrator("*") eq "1" and MenuClass eq "Builder") or SESSION.isAdministrator eq "Yes">		
														 					  
								  	<button type="button" class="button3" onClick="recordedit('#systemFunctionId#','')">     
									 
							 			 <img src="#SESSION.root#/Images/configure.gif" alt="Function configuration" height="16" width="16" border="0"
									   	  style="cursor: pointer;" alt="" border="0" align="absmiddle">
										  
									</button> 	  
									
									</cfif>
									</td>
									
									<td id="fav_#systemFunctionId#_">	
															
									<cfif favorite gte "1">
									
									     <button type="button" class="button3" onClick="favorite('0','#systemFunctionId#','')">     
								 		 	<img src="#SESSION.root#/Images/favorite.gif" alt="Remove as Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
										 </button> 	
									 
									<cfelse>
									
										 <button type="button" class="button3" onClick="favorite('1','#systemFunctionId#','')">     
								 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" alt="Add to Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
										 </button> 	
									
									</cfif>
									
									</td>
									
								</tr>
								</table>
						 					
							</td>
					        </tr>
												       			 
						 </cfif>
											     
					     </table>
						 	   
					     </td>
						
				     <cfif row MOD 2>
					 
					   <cfif SearchResult.recordcount eq "1">
					   
					  	  <td width="50%" colspan="3" align="center">	
						  
					   </cfif>
					 
					 <cfelse>		 											
									 
					    </TR>
										 
					 </cfif> 							
				
				<cfelseif FunctionClass eq "Portal">
				
				    <cfset condition = FunctionCondition>
					
					<cfif passtru neq "">
						 <cfset condition = passtru>
					</cfif>
					
					<td height="100%">
				
				    <cfif FunctionPath neq "">			  
						  
				     <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="regularZ"  
						  onClick="modulelog('#systemfunctionid#','');loadformI('#FunctionPath#','#condition#','#FunctionTarget#','#dir#','#systemFunctionId#','#Heading#','#EnforceReload#','#FunctionVirtualDir#','#FunctionHost#')" 
					      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
					 
					  <cfelse>
					  	  
					  <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="regularZ"		      
						  onClick="modulelog('#systemfunctionid#','');#ScriptName#('#mode#','#systemFunctionId#','#Heading#','#EnforceReload#','#functiontarget#')" 
					      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
					  	  	  
					 </cfif>
					  
					  <tr>			  
					  <td style="width:50%" height="25" align="center" bgcolor="FFFFFF">					 
					    <button type="button" class="button3"><cfinclude template="SubmenuImages.cfm"></button>
				      </td>			  
					  <td style="font-weight:340;padding-left:10px"><font size="1" color="0080C0">#FunctionName#</td>			  
					  </tr>
					    	  	 	 	 
					 </table>
					 
					 </td>
					 
				<cfelseif functionclass eq "Roster">
						
				   <cfif row MOD 2><TR><td height="3" colspan="6"></td></TR><TR></cfif>	 
				   
				   <td width="50%" colspan="3" align="center">
				   
				    <cfset condition = FunctionCondition>
						
					 <cfif passtru neq "">
						 <cfset condition = passtru>
					 </cfif>
					 	 	 		 			 
					 <cfif FunctionPath neq "">
					 
					      <cfset load = "loadformI('#FunctionPath#','#condition#','#FunctionTarget#','#FunctionDirectory#','#systemFunctionId#','#Heading#','#EnforceReload#','#FunctionVirtualDir#','#FunctionHost#')">
								 	 		  		  
					     <table width="98%"class="regularZ formpadding" align="center" 			     
					      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
					  
					  <cfelse>
					  			  	  
						  <cfif passtru neq "">
							 <cfset condition = passtru>
						  <cfelse>
						   	 <cfset condition = mode> 
						  </cfif>
						  
						  <cfset load = "#ScriptName#('#condition#','#systemFunctionId#','#Heading#','#EnforceReload#','#functiontarget#')">
						    				  	  	 	  	  	  	  	  
						  <table width="98%" border="0" cellspacing="0" cellpadding="0" 
							  class="regularZ formpadding" align="center"   			     						  
						      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
						  	  	 
					  </cfif>
					       	
						   <tr>
						        <td width="47" align="left" style="padding-left:5px" valign="middle">
								   <button class="button3" type="button"><cfinclude template="SubmenuImages.cfm"></button>
								</td>
								
								<cfquery name="Alternate" 
								datasource="AppsSystem" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT FunctionName, FunctionMemo
									FROM   xl#Client.LanguageId#_Ref_ModuleControl
									WHERE  Mission = '#Heading#' 
									AND    SystemFunctionId = '#SystemFunctionId#'
							    </cfquery>
							   
							    <cfif Alternate.recordcount eq "1" and Alternate.functionname neq "">
							        <cfset nm  = Alternate.FunctionName>					  
							    <cfelse>
							       <cfset nm =  FunctionName>									 		   
							    </cfif>						
							   
							    <cfif Alternate.recordcount eq "1" and Alternate.functionmemo neq "">					   
								    <cfset st =  Alternate.FunctionMemo>						  
							    <cfelse>					   
								    <cfset st =  FunctionMemo> 							 		   
							    </cfif>				
														
								<td width="92%" onclick="modulelog('#systemfunctionid#','#heading#');#load#">
									<table>
										<tr><td class="labellarge" style="font-weight:340;padding-left:5px;font-size:22px;height:20px"><a>#nm#</a></td></tr>
										<tr><td class="labelmedium" style="font-weight:340;height:20px;padding-left:9px;font-size:13px">#st#</td></tr>
									</table>						
								</td>   
								
								<td rowspan="2" align="right" width="20"> 
								
									<table class="formpadding">
									<tr>
									<td id="fav_#systemFunctionId#_">	
																														
									<cfset cond = replace(condition,"&","|","ALL")> 
														
									<cfif favorite gte "1">
									
								     <button type="button" class="button3" onClick="favorite('0','#systemFunctionId#','','#heading#','#cond#')">     
							 		 	<img src="#SESSION.root#/Images/favorite.gif" alt="Remove as Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
									 </button> 	
									 
									<cfelse>
									
									 <button type="button" class="button3" onClick="favorite('1','#systemFunctionId#','','#heading#','#cond#')">     
							 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" alt="Add to Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
									 </button> 	
									
									</cfif>
									
									</td>
									
									<td>		
									
									<cfif SESSION.isAdministrator eq "Yes">	
									
									 <!---
										  <cfinvoke component="Service.AccessReport"  
								          method="editreport"  
									  ControlId="#ControlId#" 
									  returnvariable="accessedit">
									  
									  <CFIF accessedit is "EDIT" or accessedit is "ALL"> 
									  --->
								  
								  	 <button type="button" class="button3" onClick="recordedit('#systemFunctionId#','#Heading#')">     
							 		     <img src="#SESSION.root#/Images/configure.gif" alt="Function configuration" height="16" width="16" border="0"
									   	  style="cursor: pointer;" alt="" border="0" align="absmiddle">
									 </button> 	
									  
									</cfif>
									
									</td>
									</tr>
									</table>
								
							    </td>	 
						    </tr>		
					     </table>					 
					 </td>	
					 
					 <cfif row MOD 2><cfelse></TR>
						 <cfif CurrentRow neq SearchResult.recordcount>
							 <tr><td height="3" colspan="6" bgcolor="white"></td></tr>
							 <tr><td height="1" colspan="6" bgcolor="E5E5E5"></td></tr>
						 </cfif>	 
					 </cfif> 	
					
				<cfelse>	
															
				     <tr><td height="1" colspan="6"></td></tr>				 
				     <tr>
					 <td align="center" colspan="6" height="1" style="padding-left:20px">
								
				     <cfset condition = FunctionCondition>
					 
					 <cfif ConditionRevised neq "" and ConditionRevised neq "undefined">
						       <cfset condition = ConditionRevised>
					 </cfif>
					 						
					 <cfif passtru neq "">
						 <cfset condition = passtru>
					 </cfif>
					 
					 <cfif find("Mission",class)>
						 
					 	 <cfset selmission = heading>
				   		
						 <cfif condition eq "">
						    <cfset condition = "Mission=#Heading#">
						  <cfelse>	
						    <cfset condition = "#condition#&Mission=#Heading#">
						 </cfif>
						 
					 <cfelse>
					 	
						 <cfset selmission = "">	 
							 	 	 
					 </cfif>		
					 	 		 			 
					 <cfif FunctionPath neq "">
					 	 		  		  
					     <table width="98%" border="0" cellspacing="0" cellpadding="0" class="regularZ formpadding" align="center"  			       
					      onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">	
						 			  						  
						   <cfset go="modulelog('#systemfunctionid#','#selmission#');loadformI('#FunctionPath#','#condition#','#FunctionTarget#','#FunctionDirectory#','#systemFunctionId#','#Heading#','#EnforceReload#','#FunctionVirtualDir#','#FunctionHost#')">
					  
					  <cfelse>
					  					  	  
						  <cfif passtru neq "">
							 <cfset condition = passtru>
						  <cfelse>
						   	 <cfset condition = mode> 
						  </cfif>
					  	  	 	  	  	  	  	  
						  <table width="98%" border="0" cellspacing="0" cellpadding="0" class="regularZ formpadding" align="center"
						    onMouseOver="hl(this,true,'#FunctionName#')" onMouseOut="hl(this,false,'')">
												   
						     <cfset go="modulelog('#systemfunctionid#','');#ScriptName#('#condition#','#systemFunctionId#','#Heading#','#EnforceReload#','#functiontarget#')">						
							 		  	  	 
					  </cfif>
				       	
				     <tr>
					 	   
				     <td width="45" style="padding-left:3px;padding-right:6px" align="center" onclick="#go#">
				    	 <cfinclude template="SubmenuImages.cfm">
					  </td>
					  			  
				     <td width="75%" onclick="#go#">
					 
					     <table  class="formpadding">
						 <tr>
						 <td class="labelmedium" style="font-weight:340;height:20px;font-size:19px"><a>#FunctionName#</a></td>
						 </tr>
						 
						 <cfif functionMemo neq "">
						 
						 <tr><td style="padding-left:8px;font-weight:340;">
							 <font size="2" color="808080">#FunctionMemo#</font>
							 </td>
						 </tr>		 					 
						  <cfif MenuClass eq "Builder">					 																				  
							<cfif Log neq "">							
							<tr><td class="cellcontent">
							<font color="0080FF" size="2">Last updated on: #DateFormat(ActionTimeStamp, CLIENT.DateFormatShow)# - </font>	
							</td></tr>								
							</cfif>					
						  </cfif>
							 
						 </cfif>
						 
						 </table>
						 
					 </td>
					 
					     <td width="300" align="right" style="padding-right:18px">
						 	 
						 		<table cellspacing="0" cellpadding="0" class="formpadding">
									<tr>								
									<td class="labelit">	
										
									<cfif getAdministrator("*") eq "1">	
																  
									  	 <button type="button" class="button3" onClick="recordedit('#systemFunctionId#','')">     
								 		     <img src="#SESSION.root#/Images/configure.gif" alt="Function configuration" height="16" width="16" border="0"
										   	    style="cursor: pointer;" alt="" border="0" align="absmiddle">
										 </button> 	
									
									<cfelse>
									
										 <font size="1">						
											 <cfif MenuClass eq "Builder">									 		
											 <cfelse>							
											 <font color="gray">&nbsp;Published:</font>&nbsp;#DateFormat(Created, CLIENT.DateFormatShow)#&nbsp;</font>		 									 
											 </cfif>
										 </font>
									  
									</cfif>
									
									</td>
									
									<td id="fav_#systemFunctionId#_" align="right">	
																
									<cfif favorite gte "1">
									
								     <button type="button" class="button3" onClick="favorite('0','#systemFunctionId#','')">     
							 		 	<img src="#SESSION.root#/Images/favorite.gif" alt="Remove as Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
									 </button> 	
									 
									<cfelse>
									
									 <button type="button" class="button3" onClick="favorite('1','#systemFunctionId#','')">     
							 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" alt="Add to Favorites" height="14" width="14" border="0" style="cursor: pointer;" border="0" align="absmiddle">
									 </button> 	
									
									</cfif>
									
									</td>													
									
									</tr>
								</table>
						 			 
						 </td>
				     </tr>    	 	    
				     </table>    
				     </td></tr> 
					 	 
					 <cfif CurrentRow neq SearchResult.recordcount>
					 	
						<tr><td height="2" colspan="6"></td></tr>
						<tr><td colspan="6"></td></tr>
						
					 </cfif>
					 					 
				 </cfif>	 
		 
		 	</cfif>
		  
		</cfoutput>
	
	</cfoutput>

</TABLE>

</td>
</tr>
</table>

</cfif>
