<cfparam name="URL.Mission"   default="">
<cfparam name="URL.Box"       default="">
<cfparam name="Prior"         default="">
<cfparam name="URL.RequestId" default="">

<cfif url.box neq "">

	<!--- dialog embedded --->
    <cf_screentop height="100%" jquery="Yes" html="no" user="no" label="User Authorization" scroll="no" validateSession="No" layout="webapp" banner="gray">
	
<cfelse>

	<cf_screentop height="100%" jquery="Yes" html="no" user="no" Band="No" label="User Authorization" validateSession="Yes"
	              scroll="no" layout="webapp" banner="gray">
				  
</cfif>

<cf_dialoglookup>

<cfoutput>
	
<script language="JavaScript">
	
	function show(mis) {	
		se = document.getElementById(mis);
		if (se.className == "regular")		
			{ se.className = "hide" }
		else
			{ se.className = "regular" }
	}
	
	function showentity(mis,no,lvl) {	
		try {			
			document.getElementById("i_"+mis).className = "hide";		
			document.getElementById("s_"+mis).className = "regular";
		} catch(e) {}
	    ptoken.navigate('UserAccess_Entity.cfm?mode=query&acc=#URL.ACC#&mission='+mis+'&ms='+no+'&id=#URL.ID#&access='+lvl,'s_'+mis)
	}
	
	function showaccess(lvl,box) {
		
		try {			
			document.getElementById("i_"+box).className = "hide";		
			document.getElementById("s_"+box).className = "regular";
		} catch(e) {}
		
	    ptoken.navigate('UserAccess_EntityToggle.cfm?action='+lvl+'&box='+box,'s'+box)
	}
	
	function ClearRow(row,itm) {
	
		try {
		
		if (itm == "I") {
		  try { mis = document.getElementById(row+"_mis"); mis.className = "hide" } catch(e) {}
		} else {
		  try { mis = document.getElementById(row+"_mis"); mis.className = "regular" } catch(e) {}
		}		
		
		rw = document.getElementById(row+"I")
		rw.style.fontWeight='normal';
		rw.style.background='white';
		count = 0
		while (count < 5) {
		
			try {
			rw = document.getElementById(row+count)
			rw.style.fontWeight='normal';
			rw.style.background='white';
			
			} catch(e) {}
			count++
		
		}		
				
		rw = document.getElementById(row+itm)
		rw.style.fontWeight='bold';
		rw.style.background='yellow';
		
		}
		
		catch(e) {}
	}
			
	ie = document.all?1:0
	ns4 = document.layers?1:0
		
	function hl(itm,fld,rw){			 
	     if (ie){
          while (itm.tagName!="TD")
          {itm=itm.parentElement;}
	     }else{
          while (itm.tagName!="TD")
          {itm=itm.parentNode;}
	     }
		 	 	
		 if (fld != false){				
		 itm.className = "highlight";			 
		 }else{				
	     itm.className = "regular";		
		 }		
	 }	  
	  
	function selectall(chk,val,pr) {
	
	var count=1;
	
	var itm = new Array();
	var fld = new Array();
	
	while (count < 100) {    
	 				 
		 itm2  = 'Selected_'+count
		 se2  = 'Sel_'+count
		 var se  = document.getElementsByName(se2)
	 	 var fld = document.getElementsByName(itm2)
		 var itm = document.getElementsByName(itm2)
			 	 
		 if (pr == "0") {
		 
			 se[val].value = "1";
			 fld[val].checked = true;
				 			
		     if (ie){
			      itm1=itm[val].parentElement; 
				  itm1=itm1.parentElement; 
				  }
		     else{
		          itm1=itm[val].parentElement; 
				  itm1=itm1.parentElement; }		
				
			 	
			 itm1.className = "highLight1";
			 window.roster.prior.value = "1";
	    	 
		 } else {
		 
			 fld[val].checked = false;
			 se[val].value = "0";
				 			
		     if (ie){
			     itm1=itm[val].parentElement; 
				 itm1=itm1.parentElement; 
			 }else{
		         itm1=itm[val].parentElement; 
				 itm1=itm1.parentElement; }				
			 	
			 itm1.className = "regular";
			 window.roster.prior.value = "0";	
			 	 	 
		 }
		
	    count++;
	   }	
	
	}
 
</script> 

</cfoutput>

<cfparam name="URL.ID"  default = "role">
<cfparam name="URL.ID1" default = "global">
<cfparam name="URL.ID2" default = "">
<cfparam name="URL.ID3" default = "">
<cfparam name="URL.ID4" default = "">
<cfparam name="URL.Mission" default="">

<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    UserNames
	WHERE   Account = '#url.acc#' 
</cfquery>

<cfif URL.ID1 neq "Object">

	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM    Organization
		WHERE   OrgUnit = '#url.id2#' 
	</cfquery>

</cfif>

<cfquery name="Role" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM    Ref_AuthorizationRole
WHERE   Role = '#URL.ID#' 
</cfquery>

<cfif URL.ID1 neq "Object">
	 <!--- regular ---> 
	 <cfset link = "UserAccessSubmit.cfm">
<cfelse>
	 <!--- workflow access on the fly --->	
	 <cfset link = "UserAccessSubmitFly.cfm">
</cfif>

<table width="100%" height="99%">

<tr><td>

<table width="98%" height="100%" align="center">
             
	<tr><td height="100%">
		
	<cfform action="#link#?box=#url.box#&Mission=#URL.Mission#&ID=#URL.ID#&ACC=#URL.ACC#&ID2=#URL.ID2#&ID4=#URL.ID4#&requestid=#url.requestid#" 
	   method="POST" name="formaccess" target="resulting" style="height:100%">
		
		<cfoutput>
		<table width="100%" height="100%" align="center">
		
		<tr class="line">
		   <td height="10" colspan="4" style="padding-top:4px">
		  
		   <table width="100%" align="center">
		    <tr>
			   <td align="center" width="10%">
				   <img src="#SESSION.root#/Images/user_login.png" alt="Role" border="0" align="absmiddle">
			   </td>
			   <td width="40%">
				   <table cellspacing="0" cellpadding="0">
					   <tr class="labelmedium2" style="height:20px">
					   <td style="font-size:18px;font-weight:bold">#Role.systemModule#</td></tr>					  
					   <tr class="labelmedium2" style="height:20px"><td height="20">#Role.Description# &nbsp;<font size="2">(#Role.Role#)</b></td></tr>
				   </table>
			   </td>
			   <cfif Role.RoleMemo neq "">
			   <td width="50%" align="center" valign="top" class="labelmedium" style="height:20px;padding:4px;">#Role.RoleMemo#</td>
			   </cfif>
		    </tr>
			
			</table>
			</td>
		</tr>	
				
		<cfset child = 1>
		
		<tr><td height="5"></td></tr>
		<TR height="10" class="labelmedium2">
		    <td width="15%" style="padding-left:13px"><cf_tl id="Owner">:</td>
			<td width="35%"><cfif Role.RoleOwner eq ""><font color="808080">multiple</font><cfelse>#Role.RoleOwner#</cfif></td>
			
			<cfif URL.ID1 neq "Object">
			
				<td width="15%" style="padding-left:3px"><cf_tl id="Scope">:</td>
				<td width="35%">
				 <table cellspacing="0" cellpadding="0"><tr><td width="30">
				 <tr><td>
				 
					 <cfif Role.OrgUnitLevel eq "Global">					 
					     <img height="20" src="#SESSION.root#/Images/overview.gif" alt="Global" align="absmiddle">
					 <cfelseif Role.OrgUnitLevel eq "Tree" or Role.OrgUnitLevel eq "Parent">					 
					     <img height="20" src="#SESSION.root#/Images/tree3.gif" alt="Tree" align="absmiddle">	 
					 <cfelseif Role.OrgUnitLevel eq "All">
					     <img height="20" src="#SESSION.root#/Images/org_unit.gif" alt="OrgUnit" align="absmiddle">	 
					 </cfif>
				 
		        </td>
				<td class="labelmedium2">
				<cfif Role.OrgUnitLevel eq "Global">
				    <b><cf_tl id="Global"></b>
				<cfelse>
					<cfif URL.ID2 neq "">#Org.OrgUnitName#
					<cfelse>
					<cfif URL.Mission neq "undefined">#URL.Mission#</cfif> <cfif url.id4 neq "">/ #URL.ID4#<cfelse>All staffing periods/units
					<cfset child = 0>				
					</cfif></b>
						
					</cfif>
					
				</cfif>	
				</tr>
				</table>
				</td>
				
			<cfelse>	
			
				<td width="15%" style="padding-left:3px" height="15"><cf_tl id="Object">:</td>
				<td width="35%" style="padding-left:3px"><cf_tl id="Direct access"></td>
				
			</cfif>
		</tr>	
			
		<TR class="labelmedium2">
		    <td style="padding-left:13px"><cf_tl id="User Name">:</td>
			<td><a href="javascript:ShowUser('#get.Account#')">#Get.FirstName# #Get.LastName# [#get.account#]</a></td>
		    <td style="padding-left:3px"><cf_tl id="IndexNo">:</td>
			<td><cfif get.IndexNo eq ""><font color="C0C0C0"><cf_tl id="not set"><cfelse>#Get.IndexNo#</cfif></td>
		</tr>
			
		<TR class="labelmedium2">
		    <td style="padding-left:13px;"><cf_tl id="LDAP Name">:</td>
			<td><cfif get.MailServerAccount eq ""><font color="C0C0C0"><cf_tl id="not set"></font><cfelse>#Get.MailServerAccount#</cfif></td>
			<cfif Role.Parameter neq "Entity">
				<td style="min-width:100px;padding-left:3px"><cf_tl id="Batch overwrite">:</td>
				<td>
				    <input type="radio" name="RecordStatus"    id="RecordStatus" value="0" checked>&nbsp;Allow
					<input type="radio" name="RecordStatus"    id="RecordStatus" value="5">&nbsp;Disabled			
					<img src="#SESSION.root#/Images/locked.jpg" alt="" align="absmiddle" border="0">
				</td>
			<cfelse>
				   <td></td>
				   <td></td>
				   <input type="hidden" name="RecordStatus"     id="RecordStatus" value="0">
				   <input type="hidden" name="RecordStatus_old" id="RecordStatus_old" value="0">
			</cfif>
		</tr>
		
		<cfif get.AccountType eq "Individual">
				
			<cf_dialogMail>
			
			<TR class="labelmedium2 line">
			    <td style="padding-left:13px"><cf_tl id="eMail">:</td>
				<td>
					<cfif Get.eMailAddress neq "">
				     <a href="javascript:email('#Get.eMailAddress#','','','','User','#Get.Account#')">				 
				    </cfif>#Get.eMailAddress#
				</td>
				<td style="padding-left:3px"><cf_tl id="eMail external">:</td>
				<td>
					<cfif Get.eMailAddressExternal neq "">
				    <a href="javascript:email('#Get.eMailAddressExternal#','','','','User','#Get.Account#')">				
				    </cfif>#Get.eMailAddressExternal#
				</td>
			</tr>	
		
		</cfif>	
					
		</cfoutput>
			
		<tr><td height="100%" colspan="4">
		
			<cf_divscroll>
					
			<table width="97%" align="center" class="navigation_table">
			
			<cfif Role.Parameter eq "Entity">
				<input type="hidden" name="ClassIsAction" id="ClassIsAction" value="1">
			<cfelse>
			    <input type="hidden" name="ClassIsAction" id="ClassIsAction" value="0">
			</cfif>			
																
			<cfif (Role.OrgUnitLevel eq "Tree" OR Role.OrgUnitLevel eq "Parent" OR Role.OrgUnitLevel eq "All") 
				 AND Role.GrantAllTrees eq "0" 
				 AND URL.ID1 eq "Global">	
				 
				 				 				 			 												 
				 <!--- triggered through global, but tree is part of role scope --->
		
				<cfquery name="Mission" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					
						SELECT DISTINCT M.Mission,
						       M.MissionName, 
							   M.MissionType,
							   M.MissionStatus, 
							   R.Mission as Selected
							   
						FROM   Ref_Mission M LEFT OUTER JOIN
				               OrganizationAuthorization R ON M.Mission = R.Mission AND  R.UserAccount = '#URL.ACC#' 
																					AND  R.Role = '#URL.ID#'
																					AND  R.Mission is not NULL 
																					AND  R.OrgUnit is NULL 		
						WHERE   M.Mission IN (SELECT Mission 
						                      FROM   Ref_MissionModule 
										      <cfif Role.SystemModule neq "System">
										      WHERE  SystemModule = '#Role.SystemModule#' 
										      </cfif>) 
											  
						AND    M.Operational = 1 
						
						<!--- only for ownership for which the user is authorised --->
						
						<cfif SESSION.isAdministrator eq "No">
						
						AND     (
						        M.MissionOwner IN (SELECT DISTINCT ClassParameter 
									              FROM   OrganizationAuthorization
												  WHERE  Role        = 'AdminUser'
												  AND    UserAccount = '#SESSION.acc#')
							
							   OR
							   
							   <!--- added on 28/1/2012 --->
							
							   M.Mission IN (SELECT DISTINCT Mission 
									              FROM   OrganizationAuthorization
												  WHERE  Role        = 'OrgUnitManager'
												  AND    UserAccount = '#SESSION.acc#')					  
												  
								)				  
						</cfif>		
						
						<!--- ------------------------------------------------------ --->
						<!--- filter the mission based on the mission of the account --->
						<!--- ------------------------------------------------------ --->
						
						<cfif url.id1 neq "Global"> <!--- correction to show mission if the access it driven from global --->
							<cfif get.AccountMission neq "" and get.AccountMission neq "Global" and Role.SystemModule neq "System">																		
							AND    M.Mission = '#get.AccountMission#' 
							</cfif>		
						</cfif>
						
						ORDER BY MissionType, MissionName	
								
				</cfquery>	
						
										
				<input type="hidden" name="misrow" id="misrow"  value="<cfoutput>#Mission.recordcount#</cfoutput>">
				
				<input type="hidden" name="grantalltrees" id="grantalltrees" value="0">
								
				<CF_DropTable dbname="AppsQuery" tblname="#SESSION.acc#Mission"> 	
				
				<cfif Mission.recordcount eq "0">
				   <tr class="labelmedium"><td colspan="12" align="center">
				    There are no entities/trees belonging to an owner for which you were granted user admin rights  <cfoutput>(#Role.SystemModule#)</cfoutput>
				   </td>
				   </tr>			  
				   <cfabort>
				</cfif>
				
				<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#TreeAccess"> 
				
				<cfquery name="AccessList" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT 
					        A.Mission, 						
					        A.ClassParameter, 
							A.GroupParameter,
							MAX(A.RecordStatus) as RecordStatus,
							MAX(A.AccessLevel) as AccessLevel, 
							count(*) as Number
					INTO    userQuery.dbo.#SESSION.acc#TreeAccess	
					FROM    OrganizationAuthorization A
					WHERE   A.AccessLevel < '8'
					AND     A.OrgUnit is NULL 
					AND     A.Mission > ''
					AND     A.UserAccount = '#URL.ACC#' 
					AND     A.Role        = '#URL.ID#'
					GROUP BY A.Mission, A.ClassParameter, A.GroupParameter  
				</cfquery>
							
				<!--- grant access through a tree structure --->
				
				<cfset tree     = "1">		
				<cfset setclass = "1">															
			
				<cfoutput query="Mission" group="MissionType">
				
				<tr><td style="height:35" class="labellarge">#MissionType#</td></tr>
				
				<cfoutput>
				
					<!--- ---------------------- --->
					<!--- show mission selection --->
					<!--- ---------------------- --->
										
						 <cfif Role.Parameter neq "Entity">
						 
						 	<tr id="#mission#selected"  class="labelmedium navigation_row line" style="height:22px">
						 
						    <td colspan="2" height="18" style="padding-left:14px">
												
							    <table><tr>
								   <td style="padding-left:8px" class="labelmedium2">								   								   								
								    <a href="javascript:show('s_#mission#')" 
								      title="Click to hide/show options">#Mission#&nbsp;<cfif MissionStatus eq "1"><font color="gray">:static</cfif></a> 
									  
								</td></tr>
								</table>	  
								
							</td>
							<td><a href="javascript:show('s_#mission#')" title="Click to hide/show options">#MissionName#</a></td>
							
							</tr>
													
						<cfelse>
						
							<tr id="#mission#selected" class="labelmedium2 navigation_row line">
						
							  <td colspan="2" height="20" class="labelmedium2" style="padding-left:14px">
							  												
							  		<a href="javascript:show('s_#mission#')">#Mission#</a>&nbsp;<cfif MissionStatus eq "1"><font color="gray">:<i>static</i></cfif> 
								
							 </td>
							 <td align="right" colspan="2">#MissionName#</td>		
													
							</tr>											
													
						</cfif>
						
					<tr class="labelmedium2" style="border-top:1px solid silver;height:1px">
					
						<cfset URL.Mission = "#Mission#">
						<cfset ms          = "#currentRow#">
						
						<input type="hidden" name="#ms#_Mission"      id="#ms#_Mission"      value="#Mission#">  
						<input type="hidden" name="#ms#_MissionCheck" id="#ms#_MissionCheck" value="#Mission#">
											
						<!--- class is regular to support hide/show --->
						
						 <cfquery name="AccessGranted" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   SELECT   TOP 1 *
						   FROM     OrganizationAuthorization
						   WHERE    Mission     = '#url.mission#'
						   AND      Role        = '#Role.Role#'	
						   AND      UserAccount = '#get.account#'					   				
					   </cfquery>		
					   					   					   
					    <cfif AccessGranted.recordcount gte "1">
						
						<td colspan="4" id="s_#mission#" class="labelmedium2" style="padding-left:6px" width="93%" align="right">
												
						<cfelse>
						
						<td colspan="4" id="s_#mission#" class="hide" style="padding-left:6px" width="93%" align="right">
						
						
						</cfif>
												
						    <!--- present the input screen which is driven by the parameter --->						
							<cfset missionname = mission>		
																					
							<cfinclude template="UserAccessLocation.cfm">							
							
							<cfif class gt setclass>
								<cfset setclass = class>						   
							</cfif>						
							
						</td>	
						
						<cfif Role.Parameter neq "Entity">
						
							<cfif currentrow eq "1">
							
								<cfif AccessList.RecordStatus eq "5">
					   
									   <script>
							   			   se = document.getElementsByName("RecordStatus")
										   se[1].checked = true
					      			   </script>
									   <input type="hidden" name="recordstatus_old" id="recordstatus_old" value="5">
									   
							     <cfelse>
							   
							   	 	 <input type="hidden" name="recordstatus_old" id="recordstatus_old" value="0">  
					   
							     </cfif>
							 
							 </cfif>	
						 			 
						 </cfif>	
					 
					 </tr>
					 
				</cfoutput>
				
				</cfoutput>
				
				<cfoutput>			
				     <!--- this will contain the iterations for saving --->		
				     <input type="hidden" name="row" id="row" value="#setclass#">			
				</cfoutput>
						
			<!--- global mission as attributes, independent variable --->
				
			<cfelseif (Role.OrgUnitLevel eq "Tree" OR Role.OrgUnitLevel eq "Parent" OR Role.OrgUnitLevel eq "All") 
				 AND Role.GrantAllTrees eq "1" 
				 AND URL.ID1 eq "Global">	
				 			 			 			 
				 <!--- allow for easy entry all all tries in this view --->
				 		
				<input type="hidden" name="grantalltrees" id="grantalltrees" value="<cfoutput>#Role.GrantAllTrees#</cfoutput>">
					 
				<cfset tree = "1">
				
				 <!--- triggered through global, but tree is part of role scope --->
		
				<cfquery name="MissionList" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT M.Mission, 
					       M.MissionStatus, 
						   R.Mission as Selected 
					FROM   Ref_Mission M LEFT OUTER JOIN
			               OrganizationAuthorization R ON M.Mission = R.Mission AND  R.UserAccount = '#URL.ACC#' 
																				AND  R.Role        = '#URL.ID#'
																				AND  R.Mission is not NULL 
																				AND  R.OrgUnit is NULL 		
					WHERE   M.Mission IN (SELECT Mission 
					                      FROM   Ref_MissionModule 
									      <cfif Role.SystemModule neq "System">
									      WHERE  SystemModule = '#Role.SystemModule#' 
									      </cfif>) 
					AND    M.Operational = 1 
					<!--- only for ownership for which the user is authorised --->
					<cfif SESSION.isAdministrator eq "No">
					AND    M.MissionOwner IN (SELECT DISTINCT ClassParameter 
								              FROM   OrganizationAuthorization
											  WHERE  Role        = 'AdminUser'
											  AND    UserAccount = '#SESSION.acc#') 
					</cfif>					  
				</cfquery>		
							
				<cfif MissionList.recordcount eq "0">
				
				      <tr class="labelmedium"><td colspan="12" align="center">There are no missions/trees belonging to an owner for which you were granted user admin rights  <cfoutput>(#Role.SystemModule#)</cfoutput></td></tr>    			  
		    		  <cfabort>
					  
				<cfelse>
						
					<cfset varmis = quotedValueList(missionlist.mission)>
								
				</cfif> 
								
				<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#TreeAccess">
				
													
				<cfquery name="AccessList" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT 
					        A.Mission, 
					        A.ClassParameter, 
							A.GroupParameter,
							MAX(A.RecordStatus) as RecordStatus, 
							MAX(A.AccessLevel) as AccessLevel, 
							count(*) as Number
					INTO    userQuery.dbo.#SESSION.acc#TreeAccess	
					FROM    OrganizationAuthorization A
					WHERE   A.AccessLevel < '8'
					AND     A.OrgUnit is NULL 
					AND     A.Mission     IN (#preservesinglequotes(varmis)#)
					AND     A.UserAccount = '#URL.ACC#' 
					AND     A.Role        = '#URL.ID#'
					GROUP BY A.Mission, A.ClassParameter, A.GroupParameter  
				</cfquery>
				
				<cfparam name="url.mission" default="">										
			    <cfset tree = "1">
															
				<tr><td colspan="4" id="s_<cfoutput>#URL.Mission#</cfoutput>">
											
				   <cfset ms   = 1>	
				   <cfset show = 1>		
				   	   				   	   
				   <cfinclude template="UserAccessLocation.cfm">
					
				   <cfif AccessList.RecordStatus eq "5">
		   
					   <script>
			   			   se = document.getElementsByName("RecordStatus")
						   se[1].checked = true
	      			   </script>
						 
				   </cfif>
					
				</td>
				</tr>		
				
				<!--- select missions --->
								
				<tr><td height="1" class="line" colspan="4"></td></tr>
				
				<tr>
				    <td colspan="4" height="24" valign="top" style="padding-left:16">
						<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/join.gif" alt="Authorization" border="0" align="absmiddle">
						Authorization to be applied for following entities:
					</td>
				</tr>
				<tr>	
					<td colspan="4" style="padding-right:10px">
										
						<table width="94%" align="right">
							
							<cfset cnt = 0>		
																							
							<cfoutput query="MissionList">					
											     
								<cfset ms = currentrow>		
										 
								<cfif cnt eq "6"><tr></cfif>
								<td width="2%" style="padding-right:4px" bgcolor="<cfif selected neq ''>ffffaf</cfif>">
								<input type="hidden" name="#ms#_Mission" id="#ms#_Mission" value="#Mission#">
								<input type="checkbox" <cfif selected neq "">checked</cfif> name="#ms#_MissionCheck" id="#ms#_MissionCheck" value="#Mission#">
								</td>
								<td width="12%" bgcolor="<cfif selected neq ''>ffffaf</cfif>">#Mission#</td>
								<cfset cnt = cnt+1>
								<cfif cnt eq "6">
									</tr>
									<tr><td colspan="12" class="line"></td></tr>	
									<cfset cnt = 0>
								</cfif>						
											
							</cfoutput>					
							
						</table>
					
					</td>
					
				</tr>
															
				<input type="hidden" name="misrow" id="misrow" value="<cfoutput>#MissionList.recordcount#</cfoutput>">		
				<input type="hidden" name="row" id="row"    value="<cfoutput>#class#</cfoutput>">
																		
			<cfelse>		
							
			    <!--- triggered from tree access already --->
								
			    <cfset tree = "0">
		
		       									
				<input type="hidden" name="misrow" id="misrow" value="1">
				
				<cfset ms = "1">
				<cfoutput>
				<input type="hidden" name="#ms#_Mission" id="#ms#_Mission" value="#URL.Mission#">
				<cfif tree eq "0">
				<input type="hidden" name="#ms#_MissionCheck" id="#ms#_MissionCheck" value="global">
				<cfelse>
				<input type="hidden" name="#ms#_MissionCheck" id="#ms#_MissionCheck" value="#Mission#">
				</cfif>
				</cfoutput>
				
				<tr><td height="100%" valign="top" colspan="4" id="s_<cfoutput>#URL.Mission#</cfoutput>" 
				  style="padding:1px">
											  			
				   <cfinclude template="UserAccessLocation.cfm">
				   				   		  								
				   <cfif AccessList.RecordStatus eq "5">
		   
						   <script>
				   			   se = document.getElementsByName("RecordStatus")
							   se[1].checked = true
		      			   </script>
						   <input type="hidden" name="recordstatus_old" id="recordstatus_old" value="5">
						   
				   <cfelse>
				   
				   	 	 <input type="hidden" name="recordstatus_old" id="recordstatus_old" value="0">  
		   
				   </cfif>
				   
					
				</td>
				</tr>
							
				<input type="hidden" name="row" id="row" value="<cfoutput>#class#</cfoutput>">
				
				<tr><td height="2"></td></tr>
				
			  </cfif>	
					
			</table>
			
			</cf_divscroll>
								
		</td></tr>	
		
		<!--- provision for orgunit --->
		
		<cfif Role.OrgUnitLevel eq "All" 
			and (URL.ID2 neq "" or url.id4 neq "")
			and URL.ID1 neq "Object" 		
			and child eq "1">
							
			<tr>	
					
			   <td colspan="4">
				
				<table>
				<tr>
				
				 <td colspan="1" height="30" class="labelmedium" style="padding-left:10px">				
				  Roll access down to unit (childen) within the staffing period
				 </td>
				
				 <td align="right" style="padding-left:10px;padding-right:20px" colspan="2" class="labelmedium">
					<table><tr><td>
					<input type="radio" style="height:18px;width:18px" name="Rolldown" id="Rolldown" value="1" ></td>
					<td class="labelmedium" style="padding-left:5px"><cf_tl id="Yes"></td>
					<td style="padding-left:7px">
					<input type="radio" style="height:18px;width:18px"  name="Rolldown" id="Rolldown" value="0" checked></td>
					<td class="labelmedium" style="padding-left:5px;padding-right:10px"><cf_tl id="No"></td>
					</tr>
					</table>
				 </td>
				
				</tr>
				</table>	
				
				</td>
				
			</TR>
			
			
		<cfelse>	
		
			<input type="hidden" name="Rolldown" id="Rolldown" value="0">
		
		</cfif>
				
		<tr><td colspan="4" height="23" align="center" style="padding-top:10px">
				
			<table width="100%" align="center">
			<tr><td align="center" id="accessresults" class="line" style="padding-top:3px">
			    <table>
			    <tr><td>
			    
				<cfif URL.ID1 neq "Object">				
				<input type="button" class="button10g" name="close" id="close" value="Close" onClick="try {parent.parent.ProsisUI.closeWindow('myaccess') } catch(e) { parent.ProsisUI.closeWindow('myaccess') }">
				<cfelse>				
				<input type="button" class="button10g" name="close" id="close" value="Close" onClick="try {parent.parent.ProsisUI.closeWindow('userdialog') } catch(e) { parent.parent.ProsisUI.closeWindow('userdialog') }">
				</cfif>
				
				</td><td style="padding-left:2px">
				   	<input type="submit" class="button10g"  style="height:25px;width:200px" value="Apply" onclick="Prosis.busy('yes');">			
					</td>
				</tr>
				</table>				
				</td>		
		    </tr>
			</table>				
		
		</td></tr>
		
		<!--- -------------------------------------------------------- --->
		<!--- processing box use this box for trouble shooting queries --->
		<!--- -------------------------------------------------------- --->
		
		<tr><td class="hide" colspan="6">
						
			<iframe name="resulting"
			   id="resulting"
			   width="100%"
			   height="100%"
			   scrolling="yes"
			   frameborder="1"></iframe>
					
		</td></tr>
		
		<tr><td style="padding:6px"></td></tr>
		
		</table>	
		
	</CFFORM>	
	
	</td></tr>
	
	</table>	
		
</table>
	
<cf_screenBottom layout="webapp">
