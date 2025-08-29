<!--
    Copyright © 2025 Promisan B.V.

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
<cfif isDefined("Session.login")>

<!--- can be removed was loading double 
<cfoutput>
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/#client.style#">
	<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>
</cfoutput>
--->

<cfajaximport>

<cfset rand = round(Rand()*100)>

<cfparam name="target"    default="_top">
<cfparam name="searchbar" default="true">

<style>

	table.highLight {
		BACKGROUND-COLOR: #efefef;
		border-top : 1px solid gray;
		border-right : 1px dotted gray;
		border-left : 1px dotted gray;
		border-bottom : 1px dotted gray;
		cursor: pointer;		
	}
	table.regular {
		BACKGROUND-COLOR: #ffffff;
		border-top : 1px solid white;
		border-right : 1px solid white;
		border-left : 1px solid white;	
		border-bottom : 1px solid white;	
	}
	
</style>

<cfoutput>

	<script language="JavaScript">
	
	f = 0
	w = 0
	h = 0
	
	if (screen) {
		w = #CLIENT.width# - 25
		f = screen.width - 500		
		if (f < w) {
		    f = w
		}		 
		h = #CLIENT.height# - 110
	}
	
	function favorite(act,id,mis) {
	    ptoken.navigate('#SESSION.root#/Tools/Favorite.cfm?action='+act+'&systemfunctionid='+id+'&mission='+mis,'fav_'+id+'_'+mis)
	}
	
	function modulelog(id,mis) {	  
	    ptoken.navigate('#SESSION.root#/Tools/SubmenuLog.cfm?systemfunctionid='+id+'&mission='+mis,'modulelog')
	}
	
	function maintain(mis) {
	    ptoken.open("#SESSION.root#/Staffing/Application/Position/MandateView/InitView.cfm?mission="+mis+"&mandate=","maintain")
	}	
	
	function editentity(mis) {
		 ptoken.open("#SESSION.root#/System/Organization/Application/OrganizationView.cfm?mission="+mis,"left=10,top=10,width=" + f + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes")
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	function hlmenu(itm,fld,name){
			 
	     if (ie){
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentNode;}
	     }		 
		 	 		 	
		 if (fld != false){			
			 itm.className = "highLight1 formpadding";
			 itm.style.cursor = "pointer";	
		 }else{			
	    	 itm.className = "regularZ formpadding";		
			 itm.style.cursor = ""; 
		 }
	  }
	  
	function loadform(name,target) {	
						
		<cfif #Target# eq "mission" or #target# eq "_top">
		  // 	ptoken.open(name,  target, "left=18, top=18, width=" + f + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
			ptoken.open(name,  target);
		<cfelse>
		   	ptoken.open(name,  target, "left=18, top=18, width=" + f + ", height= " + h + ", status=yes, toolbar=no, scrollbars=no, resizable=yes");
		</cfif>
		
	}
	
	function home(url) {
		ptoken.open(url)
	}
	
	function minimize(itm,icon){
		 
		 se  = document.getElementById(itm)
		 icM  = document.getElementById(itm+"Min")
	     icE  = document.getElementById(itm+"Exp")
		 se.className = "hide";
		 icM.className = "hide";
		 icE.className = "regular";				 
	  }
	  
	function expand(itm,icon){
		 
		 se  = document.getElementById(itm)
		 icM  = document.getElementById(itm+"Min")
	     icE  = document.getElementById(itm+"Exp")
		 se.className = "regular";
		 icM.className = "regular";
		 icE.className = "hide";
				
	  }  	  

	<cfif searchbar>
	
		$(document).ready(function(){	
				   					
			if ($(".cSearch").length > 2) {
			
				$.extend($.expr[':'], {
					'contains': function(elem, i, match, array){
						return (elem.textContent || elem.innerText || '').toLowerCase().indexOf((match[3] || "").toLowerCase()) >=
						0;
					}
				});
				
				$("##iSearch").on('keyup', function(ev){
				
					var query = $(this).val();
					
					//cSearch = content search
					//tSearch = text search
					if (query != '') {
					
						$(".cSearch:not(:contains('" + query + "'))").each(function(){
							$(this).fadeOut();
						});						
						
						$(".cSearch:contains('" + query + "')").each(function(){						
							$specific = $(this).find(".tSearch");
							vtext = $specific.text();
							if (vtext.toLowerCase().indexOf(query.toLowerCase()) >= 0) {
								$(this).fadeIn();
							} else $(this).fadeOut();
						});
						
					} else $(".cSearch").fadeIn();
					
					if (ev.which == 13) {					
						ev.preventDefault();
						ev.stopPropagation();
					}
				});				
				$("##iSearch").focus();
				
			} else { $("##dSearchBar").remove(); }
						
		});
		
	</cfif>	
		
	</script>
	
</cfoutput>

<cfparam name="verifyArea"      default="">
<cfparam name="verifySource"    default="">
<cfparam name="selection"       default="">
<cfparam name="URL.Operational" default="1">

<cfquery name="SearchResultA" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	    <cfif target eq "mission">
		SELECT  *,
				 (SELECT count(*)
				  FROM   System.dbo.UserFavorite
				  WHERE  Account          = '#SESSION.acc#'
				  AND    SystemFunctionId = '#SystemModule.systemFunctionId#'
				  AND    Mission          = R.Mission) as Favorite 
		<cfelse>
		SELECT  *
		</cfif>		 
				 
		FROM    Ref_Mission R INNER JOIN Ref_AuthorizationRoleOwner O ON R.MissionOwner = O.Code
		WHERE   R.Operational = '#url.operational#'
		<cfif Selection eq "Favorite">
	    AND     Mission IN (SELECT Mission 
			                FROM   System.dbo.UserFavorite 
					        WHERE  Account = '#SESSION.acc#') 								 
								 <!--- PENDING additional filter to select only modules that are enabled --->  
		<cfelse>	
		
		    <cfif Module neq "">
			
			AND    Mission IN (SELECT  Mission 
			                     FROM  Ref_MissionModule 
								 WHERE SystemModule = #preserveSingleQuotes(Module)#)
			</cfif>					 
		</cfif>	
		
		<cfif FindNoCase('Manuals',selection) and Module neq "">
		AND  Mission NOT IN (SELECT Mission 
		                     FROM   System.dbo.Ref_ModuleControlDeny 
							 WHERE  SystemFunctionId IN (SELECT SystemFunctionId 
							                             FROM   System.dbo.Ref_ModuleControl 
														 WHERE  SystemModule = #preserveSingleQuotes(Module)#))
		</cfif>			
		
		ORDER BY MissionType, 
		         R.Operational DESC, 
				 OrderSort, 
				 Mission, 
				 MissionParent				 
				 
</cfquery>

<table width="93%" align="center">

<cfif searchresultA.recordcount neq "0">

<!--- ajax to run the logging --->
<tr class="hide"><td id="modulelog"></td></tr>

<cfoutput query="searchresultA" group="MissionType">

	<cfset show = "0">
	<cfset tpe  = "">
	<cfset row  = 0>
	<cfset cnt  = 0>
		
	<cfif VerifySource neq "">
	   <cfset role = "#preserveSingleQuotes(VerifySource)#">	   
	<cfelse>
	   <cfset role = "'OrgUnitManager'">
	</cfif>	
		
	<cfif SESSION.isAdministrator eq "Yes" or selection is "Favorite">	
		
		<cfquery name="GroupMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT   DISTINCT Mission
		 FROM     Ref_Mission
		 WHERE    Operational = '#Operational#' 
			AND   MissionType = '#MissionType#' 	
			AND   Mission IN (#QuotedValueList(SearchResultA.Mission)#) 
			
			<cfif Module neq "">
			
			AND    Mission IN (SELECT  Mission 
			                     FROM  Ref_MissionModule 
								 WHERE SystemModule = #preserveSingleQuotes(Module)#)
			</cfif>		
		
		 <cfif SESSION.isLocalAdministrator neq "No">
		 	
			 UNION
			
			 <!--- support mission access added 07/07/2015 --->
			
			 SELECT   Mission
			 FROM     Ref_Mission
			 
			 WHERE    Mission IN (#preserveSingleQuotes(SESSION.isLocalAdministrator)#) 	
			 AND      MissionType = '#MissionType#' 	
			 AND      Operational = '#Operational#'	
			 
			 <cfif Module neq "">
			
			 AND      Mission IN (SELECT  Mission 
			                     FROM  Ref_MissionModule 
								 WHERE SystemModule = #preserveSingleQuotes(Module)#)
			</cfif>		
		 
		 </cfif>
		 	 
		</cfquery>		
											
		<cfset Group = GroupMission.recordCount>	
		
					
	<cfelseif VerifyArea neq "">	
	
				
		<!--- roles under an area --->
			
		<cfquery name="GroupMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 SELECT   DISTINCT A.Mission
		 FROM     OrganizationAuthorization A, Ref_Mission M
		 WHERE    A.Mission     = M.Mission
			AND   M.Operational = '#Operational#'
			AND   M.MissionType = '#MissionType#'			
			AND   A.UserAccount = '#SESSION.acc#'
			AND   A.Role IN (SELECT Role 
			                 FROM   Ref_AuthorizationRole
			                 WHERE  Area = '#VerifyArea#') 	
			AND   A.Mission IN (#QuotedValueList(SearchResultA.Mission)#) 	
			
		 <cfif SESSION.isLocalAdministrator neq "No">
		 	
			 UNION
		
			 <!--- support mission access added 07/07/2015 --->
		
			 SELECT   Mission
			 FROM     Ref_Mission
			 WHERE    Mission IN (#preserveSingleQuotes(SESSION.isLocalAdministrator)#) 	
			 AND      MissionType = '#MissionType#'
			 AND      Operational = '#Operational#'
		 
		 </cfif>
						 				 
		</cfquery>		
					
		<cfset Group = GroupMission.recordCount>
							
	<cfelse> 
						
		<!--- roles --->
				
	    <cfquery name="GroupMission" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		  SELECT   DISTINCT M.Mission 
		  FROM     OrganizationAuthorization A, Ref_Mission M
		  WHERE    A.Mission     = M.Mission
		  AND      M.Operational = '#Operational#' 
		  AND      M.MissionType = '#MissionType#'
		  AND      A.Role IN (#preserveSingleQuotes(role)#) 
		  AND      A.UserAccount = '#SESSION.acc#'	
		  AND      M.Mission IN (#QuotedValueList(SearchResultA.Mission)#) 		
		
		  <!--- explicit access needed removed
		  
		  UNION
		
		  <!--- mission of the account --->
		
		  SELECT   DISTINCT AccountMission as Mission
		  FROM     System.dbo.UserNames
		  WHERE    Account = '#SESSION.acc#'	
		  
		  --->
		  
		  <cfif SESSION.isLocalAdministrator neq "No">
		  
		  UNION
		
		  <!--- support mission access added 07/07/2015 --->
		
		  SELECT   Mission
		  FROM     Ref_Mission
		  WHERE    Mission IN (#preserveSingleQuotes(SESSION.isLocalAdministrator)#) 
		  AND      MissionType = '#MissionType#'
		  AND      Operational = '#Operational#'
		  
		  </cfif>
		
	   	  UNION
		
		  <!--- fly access --->
		
		  SELECT   DISTINCT O.Mission
		  FROM     OrganizationObjectActionAccess AS OA INNER JOIN
                   OrganizationObject AS O ON OA.ObjectId = O.ObjectId
		  WHERE    OA.UserAccount = '#SESSION.acc#'
		  AND      O.Mission      IN (#QuotedValueList(SearchResultA.Mission)#) 
		  <!--- added condition for the role on Oct 4th 2014 --->
		  AND      O.EntityCode IN (SELECT EntityCode FROM Ref_Entity X WHERE X.Role IN (#preserveSingleQuotes(role)#))
					
		</cfquery>			
							
		<cfset Group = GroupMission.recordCount>		
						
	</cfif>	
														
	<cfif Group gte "1">	
			
		<tr>
		<td>
													
		<cfif not find("Mission",class)>	
								
			  <table width="100%">	
			  			  			 			  			   			   			   		   
			   <TR id="#MissionType#1" class="cSearch">
				   <td colspan="6" width="10%">
				   	  <table width="100%" border="0">
					    <tr>
						  <td colspan="1" style="height:55px;font-size:32px;padding-top:5px;padding-left:11px" class="labelmedium">
					   		#MissionType# <font size="3">## #groupmission.recordcount#</font>
						  </td>
						</TR>
					  </table> 
					</td>
			   </tr>
			  			  			  			  				
			   <cfset tpe = MissionType>							  											
						
		<cfelse>
					
			<table width="100%" border="0">
			
		</cfif>		
			
		<cfoutput>
																						
		<cfset Mis = searchresultA.Mission>
									
		<cfquery name="Check" dbtype="query">
			 SELECT *
			 FROM   GroupMission
			 WHERE  Mission     = '#Mis#'
		</cfquery>  
		
		<cfset Access = Check.recordCount>
						
		<cfif SESSION.isAdministrator eq "Yes">
		    <cfset Access = "1">
		</cfif>			
											
		<CFIF Access gte 1>		
											
			<cfif not find("Mission",class)>	
												
			    <cfset cnt = cnt + 1>				
				<cfset row = row + 1>				
						    			  
			    <TR class="cSearch">				
								
				<cfset missel = Mis>
				
				<td width="100%" style="padding-top:5px">
				
				<cfset show = "1">
																
				<table width="100%" class="formpadding">
													
				<tr onMouseOver="hlmenu(this,true,'#Mission#')"  onMouseOut="hlmenu(this,false,'')">	
									
				<cfset sel=Replace(missel,'-','','ALL')>	
						
					<cfif Access gte 1 or VerifySource eq "">			
																		 
						<td width="87%" height="100%" border="0" align="left">
						
						 <!--- we make sure the user may open this --->	
														
						 <cfinvoke component  = "Service.Process.System.UserController"  
						    method            = "RecordSessionTemplate"  
							SessionNo         = "#client.SessionNo#" 
							Force             = "Yes"
							ActionTemplate    = "#MenuTemplate#"
							ActionQueryString = "#missel#">	
							
							<cfif Module neq "">
								<cf_licenseCheck module="#preserveSingleQuotes(Module)#" mission="'#SearchResultA.Mission#'" message="No">
							<cfelse>
								<cf_licenseCheck module="'System'" mission="'#SearchResultA.Mission#'" message="No">
							</cfif>		
																										
							<cfset vModuleId = replace(Module,"'","","all")>							 
						    <table width="98%" align="center" bgcolor="<cfif License eq 0>FFCACA</cfif>">								 
						  	   	
						      <tr>
							  
						        <td width="98%" align="left" title="#MissionName#">																	
																									
									<table width="100%" border="0">
									<tr class="fixlengthlist">
														
									  <cfparam name="SystemModule.systemFunctionid" default="">
																  				
									  <td style="paddong-left:12px;font-size:28px;font-weight:340" class="tSearch labelmedium" 
									  onClick="modulelog('#SystemModule.systemFunctionId#','#missel#');loadform('#MenuTemplate#?systemfunctionid=#SystemModule.systemFunctionId#&mission=#missel#&module=#vModuleId#','#sel#');">								  				  															  
									    <a>#Mission#</a>&nbsp;<cfif MissionName neq Mission><font size="2" color="808080">#MissionName#</cfif>	
																
									  </td>										
									 </tr> 
									 <cfif license neq 1>	
										  <tr style="height:10px"><td style="padding-left:40px"><font size="3" color="FF0000"><cf_tl id="License Expired"></font></td></tr>
									 </cfif>												  		  
																										  
									</table>							
								
							    </td> 
						     </tr>
						 
						 </table>
						 
						 </td>
						 
						 <td width="30" align="left">
						 
						     <table><tr><td style="padding-left:6px;padding-right:6px;height:27px;border-radius:10px;background-color:D5E9FF;min-width:50px">
						 						 																		 								 					    							 						 
							 <table style="height:100%;">
							 <tr>
							 							 
								 <cfif getAdministrator("#Missel#") eq "1">
									 <td style="padding-top:1px">								 
									  <button class="button3" type="button" onClick="editentity('#missel#')">     
									  <img src="#SESSION.root#/Images/configure.gif" alt="Remove as Favorite" height="14" width="14" style="cursor: pointer;" border="0" align="absmiddle">
									  </button> 								
									</td>								 
								 </cfif>
							 
							 <cftry>
							
									<cfif SystemModule.systemFunctionId eq "">
									 
										<td></td>
										 
									<cfelse>
									
									 	<td id="fav_#SystemModule.systemFunctionId#_#Missel#">	
																												
										<cfif favorite eq "1">										
									     <button class="button3" type="button" onClick="favorite('0','#SystemModule.systemFunctionId#','#Missel#')">     
								 		 	<img src="#SESSION.root#/Images/favorite.gif" alt="Remove as Favorite" height="14" width="14" style="cursor: pointer;" border="0" align="absmiddle">
										 </button> 											 
										<cfelse>										
										 <button class="button3" type="button"  onClick="favorite('1','#SystemModule.systemFunctionId#','#Missel#')">     
								 		 	<img src="#SESSION.root#/Images/favoriteset1.gif" alt="Add to Favorites" height="14" width="14" style="cursor: pointer;" border="0" align="absmiddle">
										 </button> 											
										</cfif>
									
										</td>
										
									  </cfif>	
							  
							 	 <cfcatch>				  
								  <td><td>				  
								 </cfcatch>
							  
							  </cftry>
							 
							  <td>	
							 															  
								<cfif MissionURL neq "">
								  
									  <button class="button3" type="button"  onClick="home('#MissionURL#')">
										 <img src="#SESSION.root#/Images/weblink.gif" height="18" width="18" alt="Go to #Mission# home page" border="0" align="absmiddle">
									  </button>
									  
								</cfif>
							  
							  </td>		
							  
							  <td>				
									
								<cfif SESSION.isAdministrator eq "Yes" and systemmodule.systemfunctionid neq "">
																		
									<cfquery name="CheckLogging" 
										datasource="AppsSystem" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT TOP 1 *
											FROM   UserActionModule 
											WHERE  SystemFunctionId = '#systemmodule.systemFunctionId#'					
									</cfquery>	
									
									<cfif CheckLogging.recordCount gt 0>
										<button type="button" class="button3" onClick="logging('#systemmodule.systemFunctionId#','#missel#')">    						 
								 			 <img src="#SESSION.root#/Images/info2.gif" alt="Function logging" height="16" width="16" border="0"
										   	  style="cursor: pointer;" alt="" border="0" align="absmiddle">										  
										</button>
									</cfif>
								</cfif>
							
							</td>		
							  
							  <cfif License eq 1>
																						  
								 <cfif module eq "'Staffing'">
								  											      
									   <cfinvoke component="Service.Access"  
								          method="StaffingTable" 
										  mission="#Mission#" 
										  returnvariable="maintain">
																				  							  
									  <cfif maintain neq "NONE">	
									  	 						  
										  <td align="right" onClick="maintain('#mission#')" class="labelmedium" style="padding:2px;padding-right:5px;height:100%;cursor:pointer;min-width:50">
										  <table style="height:100%">
										  <tr>
										     <td><a href="" title="Shortcut to staffing maintenance"><cf_tl id="maintain"></a></td>
										  </tr>
										  </table>
										  </td>				  
										 																			  									  
									  </cfif>
																	  
								 </cfif>			
								 
							 </cfif>
							 						  					
							</tr>							 
														
							</table>	
							
							</td></tr></table>		
						
					   	</td>
							 
					<cfelse>
														
					 <cfinvoke component  = "Service.Process.System.UserController"  
						    method            = "RecordSessionTemplate"  
							SessionNo         = "#client.SessionNo#" 
							Force             = "Yes"
							ActionTemplate    = "#MenuTemplate#"
							ActionQueryString = "#Mission#">	
						 
						 <td width="30" style="min-width:30px"></td>		
						 <td width="40" align="left" valign="middle">
						 <cfif Class eq "'Time'">
					    	 <img src="#SESSION.root#/Images/timesheet.jpg" alt="" width="44" height="36" border="0">
						 <cfelse>
						    <img src="#SESSION.root#/Images/org1.jpg" alt="" width="20" height="20" border="0">
						 </cfif>
						 </td>				 
						
						<td width="90%" colspan="2" align="left" valign="top">
																	  
						     <table width="90%" align="center">	
							      <cfif getAdministrator("#Mission#") eq "1">
								  <tr><td class="labelit tSearch" width="90%" align="left"><a href="javascript:editentity('#mission#')">#Mission#</a></td></tr>				  
								  <cfelse>
								  <tr><td class="labelit tSearch" width="90%" align="left">#Mission# #MissionName#</td></tr>									  
								  </cfif>
						   	 </table>
						 
						 </td>
						 
					</cfif>
							 
					 </tr>
					 
			     </table>
				 
			 </td>
			 			 	
			 </TR>	
			 		 			 			 			 
			    <cfset heading    = "#Mission#">
				<cfset class      = "'Detail'">
				<cfset selection  = "'Application'">				
					
				<cfif module neq "">									
					<tr class="cSearch" style="border-top:0px solid silver">
					<td colspan="6">
																				
						<table width="100%">
						<tr class="hide"><td class="tSearch">#mission#</td></tr>
						<tr><td>
											
						<cfset scope       =  "mission">							
					    <cfinclude template = "Submenu.cfm"> 
						
						</td>
						</tr>
						</table>
						
					</td>
					</tr>	
				</cfif>
								
				<cfset class = "">		 
			 			 	 		
		<cfelse>	
														
			    <cfset heading = Mis>
																		
				<tr class="cSearch">
				<td colspan="6" class="tSearch">
																								
						<!--- added to prevent some behavior in the menu.cfm file --->
						<cfset scope = "mission">																							
					    <cfinclude template="Submenu.cfm"> 
					
				</td></tr>
								
		</cfif>	
			
	</cfif>

	</cfoutput>
		
	</td></tr>
	
	</table>
		
</cfif>

<cfif show eq "0">
	
	 <script>
	     try {	    
		 document.getElementById("#MissionType#1").className = "hide"} catch(e) {}
	 </script>
 
</cfif>

</cfoutput>

</cfif>

</TABLE>

</cfif>
