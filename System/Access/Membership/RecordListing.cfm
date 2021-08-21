<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop 
   	   height="100%"
	   scroll="no" 
	   html="No" 
	   jQuery="Yes"	   
	   menuaccess="yes" 
	   systemfunctionid="#url.idmenu#">

<cf_dialogStaffing>

<cfajaximport tags="cfdiv">
<cfparam      name="client.box" default="">

<cfoutput>

<cfparam name="URL.Search" default="">
<cfparam name="URL.Application" default="">

<script language="JavaScript">
	
	function broadcast(grp) {	     
		  ptoken.open("#SESSION.root#/Tools/Mail/Broadcast/BroadCastUsergroup.cfm?group="+grp, "broadcast", "status=yes, height=850px, width=920px, center=yes, scrollbars=no, toolbar=no, resizable=no");
	}
	
	function maximize(itm,icon){
		
		 se   = document.getElementById(itm)
		 icM  = document.getElementById(itm+"Min")
		 icE  = document.getElementById(itm+"Exp")
		 
		 if (se.className == "regular") {
		 se.className = "hide";
		 icM.className = "hide";
		 icE.className = "regular";
			
		 } else {
		 se.className = "regular";
		 icM.className = "regular";
		 icE.className = "hide";	
		 }
	  }  
	  
	function recordadd(grp) { 
	      ptoken.open("../user/UserEntry.cfm?mode=&ID=group","user","left=20, top=20, width=770, height=730, status=yes, toolbar=no, scrollbars=no, resizable=no");			
	}	
	 
		  
	function purgegroup(acc) {
		if (confirm("Do you want to remove this group and the inherited access of its members?")) {
		    search  = document.getElementById("find").value
			mission = document.getElementById("mission").value
			app     = document.getElementById('Application').value 
			Prosis.busy('yes')		
			ptoken.navigate('GroupPurge.cfm?idmenu=#url.idmenu#&id='+acc+'&search='+search+'&mission='+mission + '&application=' + app,'result')
		}
	}	
	
	function reload(search) {	
	      _cf_loadingtexthtml='';	
		  Prosis.busy('yes')
		  app = document.getElementById('Application').value 
		  mis = document.getElementById('mission').value	     	        
	      ptoken.navigate('RecordListingResult.cfm?idmenu=#url.idmenu#&search=' + search + '&mission=' + mis + '&application=' + app,'result'); 
		}
	
	function more(bx,row,enf) {	  	
		se   = document.getElementById(row);				 		 
		if (se.className == "hide" || enf == "enforce") {
		   	se.className  = "regular";			
		 	ptoken.navigate('RecordListingDetail.cfm?mod='+bx+'&row='+row,'s'+row);		
		} else {	   	 	
	    	se.className  = "hide"
		}
			 		
	  }
	  
	function purgemember(grp,acc,row) {
		if (confirm("Do you want to remove this member ?")) {	
		Prosis.busy('yes')				
		_cf_loadingtexthtml='';				
		ptoken.navigate('MemberPurge.cfm?row='+row+'&mode=dialog&id1='+grp+'&acc=' + acc,'s'+row)		
		_cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";	
		}
	}	
	
	w = #CLIENT.width# - 200;
	h = #CLIENT.height# - 250;
	
	function showroleG(role) {
		ptoken.open("#SESSION.root#/System/Access/Global/OrganizationRolesView.cfm?Class=" + role, role)
	}
	
	function showrole(role,mission) {
		ptoken.open("#SESSION.root#/System/Organization/Access/OrganizationRolesView.cfm?Mission=" + mission + "&Class=" + role, role)
	}
	
	function sync(grp,row) {
	    Prosis.busy('yes')
	    document.getElementById("sync"+grp).disabled = true 	
		ptoken.navigate('MemberSynchronize.cfm?reload=0&role=' + grp ,'a'+grp)
		document.getElementById("sync"+grp).disabled = false			
	}  	
			
	function clearno() { document.getElementById("find").value = "" }

	function search(e) {
	  
	   se = document.getElementById("find");	   
	   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 						
	   if (keynum == 13) {
	      document.getElementById("searchbutton").click();
	   }		
				
    }
	
</script>

</cfoutput>

<cfset Page         = "0">
<cfset add          = "1">
<cfset menu         = "1"> 
<cfset save         = "0"> 

<table height="100%" width="100%" align="center">

<tr><td height="20">
<cfinclude template = "../HeaderMaintain.cfm"> 
</td></tr>
  
<!--- define if the group has any roles assigned, if so then check the owner
of the roles to define if the user (useradmin = owner) that is logged in may assign members
to this group. If a group is no roles, no membership is allowed --->

<cfquery name="MissionList" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM   Organization.dbo.Ref_Mission
		WHERE  Mission IN (SELECT AccountMission FROM UserNames	WHERE  AccountType = 'Group')
		AND   Operational = 1						  
</cfquery>

<cfquery name="ApplicationList" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     Ref_Application	
		WHERE    Usage = 'System'	
		ORDER BY ListingOrder  
</cfquery>
	
<cfoutput>

<tr><td style="height:20px;padding-left:20px" colspan="2">

	<table height="100%" class="formpadding">
		
		<tr style="height:36px">
		 <td></td>
		 <td bgcolor="white" style="height:37px;padding-left:10px">	

			 <table>
			 
			 <tr>			 
			 		
				<td class="labelmedium" style="padding-left:10px;padding-right:6px;border-left:1px solid silver;border-top:1px solid silver;border-bottom:1px solid silver">
				
				<select name="Mission" id="mission" style="height:32px;border:0px;" class="regularxxl" onChange="reload(document.getElementById('find').value)">
				    <option value=""><cf_tl id="All"></option>
					<cfloop query="MissionList">
						<option value="#Mission#">#Mission#</option>
					</cfloop>
				</select>
				
				</td>	
				
				<td class="labelmedium" style="padding-left:10px;padding-right:6px;border-left:1px solid silver;border-top:1px solid silver;border-bottom:1px solid silver">
				
				<select name="Application" id="Application" style="height:32px;border:0px;" class="regularxxl" onChange="reload(document.getElementById('find').value)">
				    <option value=""><cf_tl id="All"></option>
					<cfloop query="ApplicationList">
						<option value="#Code#">#Description#</option>
					</cfloop>
				</select>
				
				</td>							 
			 	
			    <td style="border-left:1px solid silver;border-top:1px solid silver;border-bottom:1px solid silver">
			
				   <input  type      = "text"
				      	   name      = "find"
						   id        = "find"
						   class     = "regularxl"
				    	   size      = "25"
						   style     = "border:0px;padding-left:4px;padding-top:3px"
						   value     = "#URL.search#"
						   onClick   = "clearno()" 
						   onKeyUp   = "search(event)"
					       maxlength = "25"
					       class     = "regular3">
				   
				</td>				   
				
				<td class="hide">				  				   
				    <input type="button" id="searchbutton" onclick= "reload(document.getElementById('find').value)">					
				</td>	
				   
				<td align="center" style="padding-right:1px;border-right:1px solid silver;border-top:1px solid silver;border-bottom:1px solid silver;padding-right:0px">
				  
				    <img src="#CLIENT.virtualdir#/Images/search.png" 
							  alt    = "Search for a group name or owner" 
							  name   = "locate" 	
							  id     = "locate"			
							  style  = "cursor: pointer;"	
							  height = "25"
							  width  = "25"			 
							  border = "0" 
							  align  = "absmiddle" 
							  onclick= "reload(document.getElementById('find').value,document.getElementById('mission').value)">
							  
				   </td>		  					
				
			  </table>
		  </td> 	   	      
		</tr>
	
	</table>

</cfoutput>

</td>
</tr>
  
<tr>

	<td height="100%" colspan="2" style="padding-left:30px;padding-right">
		
	<cf_divscroll id="result">
	<cfinclude template="RecordListingResult.cfm">
	</cf_divscroll>
	</td>
</tr>

</TABLE>

