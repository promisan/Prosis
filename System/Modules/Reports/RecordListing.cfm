<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop html="No" scroll="Yes" jQuery="yes" height="100%" menuaccess="Yes" systemfunctionid="#url.idmenu#">

<cfoutput>

<!--- cleaning 8/8/2010 --->

<cfquery name="Clean" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	DELETE 
	FROM   Ref_ReportControl
	WHERE  Operational = '0' 
	AND    FunctionName = ''
</cfquery>	

<cfparam name="URL.Class"   default="report">
<cfparam name="URL.Search"  default="">
<cfparam name="URL.Filter"  default="">
<cfparam name="URL.Only"    default="0">
<cfparam name="URL.Invalid" default="1">

<cfset FileNo = round(Rand()*100)>

<!--- extract reports under development workflow --->

<cf_wfPending entityCode="SysReport" IncludeCompleted="No" MailFields="No" table="#SESSION.acc#_ReportPending">

<cfajaximport tags="cfdiv">
<cf_dialogStaffing>
	
<script language="JavaScript">

	function schedule(id) {
	    w = #CLIENT.width# - 35;
	    h = #CLIENT.height# - 40;
		window.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?id=" + id, "_blank");
	}

	function listing(row,act,id)  {
     		
		icM  = document.getElementById("d"+row+"Min");
	    icE  = document.getElementById("d"+row+"Exp");
		se   = document.getElementById("d"+row);
		frm  = document.getElementById("i"+row);		
		
		if (act=="show") {
		
			ColdFusion.navigate('SubscriptionDetail.cfm?row=' + row + '&id=' + id,'i'+row)
				icM.className = "regular";
			    icE.className = "hide";
				se.className  = "regular";				
		   }  else {
			    icM.className = "hide";
			    icE.className = "regular";
		     	se.className  = "hide";
		   }
		   
	}		 		 
	      
	function reload(filter,only,cls,search,invalid)	{
	     Prosis.busy('yes')		 
	     window.location="RecordListing.cfm?idmenu=#url.idmenu#&class="+cls+"&only=" + only + "&filter=" + filter + "&search=" + search + "&invalid=" + invalid; 
	}
	
	function recordadd(id) {
          ptoken.open("RecordAdd.cfm?idmenu=#url.idmenu#&ID=" + id, "Add", "left=40, top=15, width=1090, height=930, toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function recordedit(id1) {
          ptoken.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID=" + id1, "Edit Report");
	}
	
	function usage(id) {
		w = #CLIENT.width# - 40;
	    h = #CLIENT.height# - 30;
	         window.open("Distribution.cfm?Controlid=" + id, "Edit", "left=40, top=15, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function load(id) {
	    w = #CLIENT.width# - 40;
	    h = #CLIENT.height# - 30;
		window.open("#SESSION.root#/tools/cfreport/SubmenuReportView.cfm?id=" + id+"&source=Library", "_blank", "left=10, top=10, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=no, resizable=yes");
	}
	
	function search(e) {
	  
	   se = document.getElementById("find");	   
	   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 						
	   if (keynum == 13) {
	      document.getElementById("locate").click();
	   }		
				
    }

</script>

<cf_distributer>

<table width="95%" height="100%" align="center" cellspacing="0" cellpadding="0">
	   
  <tr><td height="18"></td></tr>	   
	   
  <tr class="noprint">
    <td style="padding-left:4px;font-size:31px;padding-top:5px;height:45;font-weight:200" class="labelmedium">
	
		<cfoutput>			
			<cfif master eq "0">Production Server<cfelse>Deployment</cfif> Report Library</font></b>
		</cfoutput>
		
    </td>
	<td align="right">
		 <cfif master eq "1">
			 <button class="button10g" style="height:25px;font-size:12px;width:170px" onClick="javascript:recordadd('')"><cf_tl id="Add new Report"></button>
		 </cfif>
	</td>
  </tr> 
      
  <CF_Droptable dbName="AppsQuery"  tblName="#SESSION.acc#Subscription_#fileno#">

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">  
	SELECT     COUNT(*) as Subscriptions, L.ControlId
	INTO       userQuery.dbo.#SESSION.acc#Subscription_#fileno#
	FROM       UserReport U INNER JOIN
               Ref_ReportControlLayout L ON U.LayoutId = L.LayoutId
	WHERE      Status = '1'		
	AND        DateExpiration >= getdate()
	GROUP BY   L.ControlId    	
	</cfquery>
	 
<cfif SESSION.isAdministrator eq "No">  
 
 	<!--- System Admin --->
	
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  DISTINCT R.Owner, 
	      	S.MenuOrder, 
			R.ControlId, 
			R.Operational, 
		    R.SystemModule, 
		    R.FunctionClass, 
		    R.FunctionName, 
		    R.MenuClass, 
		    R.MenuOrder, 
            R.EnableMailingList, 
			R.Reportroot, 
			R.ReportPath,
		   (SELECT count(*) FROM userQuery.dbo.#SESSION.acc#_ReportPending E WHERE E.ObjectkeyValue4 = R.ControlId) as Deployment,		 	
		    R.FunctionMemo, 
			R.Created, 
			R.OfficerFirstName, 
			R.OfficerLastName, 
			R.TemplateSQL, 
			R.ReportPath, 
		    S.Description, 
			(SELECT Subscriptions FROM UserQuery.dbo.#SESSION.acc#Subscription_#fileno# WHERE ControlId = R.ControlId) as Subscriptions,
            R.Created
	FROM  Ref_ReportControl R, 
	      Ref_SystemModule S, 
		  Organization.dbo.OrganizationAuthorization A
	WHERE R.SystemModule = S.SystemModule
	AND   A.ClassParameter = R.Owner
	AND   A.UserAccount    = '#SESSION.acc#'
	AND   A.Role           = 'AdminSystem'
	AND   R.FunctionClass != 'System'
	AND   S.Operational    = '1'
	<cfif URL.Only eq "1">
	AND   R.OfficerUserId = '#SESSION.acc#'
	</cfif>
	<cfif URL.Filter eq "0w">
	AND   R.ControlId IN (SELECT ObjectkeyValue4 
	                      FROM   userQuery.dbo.#SESSION.acc#_ReportPending
						  WHERE  ObjectKeyValue4 = R.ControlId)		 
	<cfelseif URL.Filter eq "0" or URL.filter eq "1">
	AND   R.Operational = '#URL.Filter#'
	</cfif>
	<cfif URL.Class eq "Report">
	AND TemplateSQL != 'Application'
	<cfelse>
	AND TemplateSQL  = 'Application'
	</cfif>   
	<cfif URL.Search neq "">
	AND   R.FunctionName LIKE '%#URL.Search#%'
	</cfif>
		
	UNION
	
	<!--- Report Manager --->
	
	SELECT  DISTINCT R.Owner, S.MenuOrder, R.ControlId, R.Operational, R.SystemModule, R.FunctionClass, R.FunctionName, R.MenuClass, R.MenuOrder, 
           R.EnableMailingList, R.Reportroot, R.ReportPath,
		   (SELECT count(*) FROM userQuery.dbo.#SESSION.acc#_ReportPending E WHERE E.ObjectkeyValue4 = R.ControlId) as Deployment,		 	
		   R.FunctionMemo, R.Created, R.OfficerFirstName, R.OfficerLastName, R.TemplateSQL, R.ReportPath, 
		   S.Description, 
		   (SELECT Subscriptions FROM UserQuery.dbo.#SESSION.acc#Subscription_#fileno# WHERE ControlId = R.ControlId) as Subscriptions,
		   R.Created
	FROM   Ref_ReportControl R, 
	       Ref_SystemModule S, 
		   Organization.dbo.OrganizationAuthorization A
	WHERE R.SystemModule = S.SystemModule
	AND   A.GroupParameter = R.Owner
	AND   A.UserAccount    = '#SESSION.acc#'
	AND   A.Role           = 'ReportManager'
	AND   A.AccessLevel    = '1'
	AND   R.FunctionClass != 'System'
	AND   S.Operational    = '1'
	<cfif URL.Only eq "1">
	AND   R.OfficerUserId = '#SESSION.acc#'
	</cfif>
	<cfif URL.Filter eq "0w">
	AND   R.ControlId IN (SELECT ObjectkeyValue4 
	                    FROM   userQuery.dbo.#SESSION.acc#_ReportPending
						WHERE  ObjectKeyValue4 = R.ControlId)		 
	<cfelseif URL.Filter eq "0" or URL.filter eq "1">
	AND   R.Operational = '#URL.Filter#'
	</cfif>
	<cfif URL.Class eq "Report">
	AND TemplateSQL != 'Application'
	<cfelse>
	AND TemplateSQL  = 'Application'
	</cfif>   
	<cfif URL.Search neq "">
	AND   (R.FunctionName LIKE '%#URL.Search#%' OR S.SystemModule LIKE '%#URL.Search#%')
	</cfif>
		
	ORDER BY S.MenuOrder, R.SystemModule, R.FunctionClass, R.MenuClass, R.MenuOrder, R.FunctionName, R.Created
	</cfquery>

<cfelse>

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT R.Owner,
			       S.MenuOrder, 
				   R.ControlId, 
				   R.Operational, 
				   R.SystemModule, 
				   R.FunctionClass, 
				   R.FunctionName, 
				   R.MenuClass, 
				   R.MenuOrder, 
			       R.EnableMailingList, 
				   R.Reportroot, 
				   R.ReportPath,
				   (SELECT count(*) 
				    FROM   userQuery.dbo.#SESSION.acc#_ReportPending E 
				    WHERE  E.ObjectkeyValue4 = R.ControlId) as Deployment,		 			  
		           R.FunctionMemo, 
				   R.Created, 
				   R.OfficerFirstName, 
				   R.OfficerLastName, 
				   R.TemplateSQL, 
				   R.ReportPath, 
				   S.Description, 
				    (SELECT Subscriptions 
				    FROM   UserQuery.dbo.#SESSION.acc#Subscription_#fileno#  
				    WHERE  ControlId = R.ControlId) as Subscriptions,						 
				   R.Created
	FROM   Ref_ReportControl R, 
	       Ref_SystemModule S 
	WHERE  R.SystemModule = S.SystemModule
	AND    S.Operational = '1'	
	AND    R.FunctionClass != 'System'
	<cfif URL.Only eq "1">
	AND    R.OfficerUserId = '#SESSION.acc#'
	</cfif>
	<cfif URL.Filter eq "0w">
	AND    R.ControlId IN (SELECT ObjectkeyValue4 
	                    FROM   userQuery.dbo.#SESSION.acc#_ReportPending)		 
	<cfelseif URL.Filter eq "0" or URL.filter eq "1">
	AND    R.Operational = '#URL.Filter#'
	</cfif>
	<cfif URL.Search neq "">
	AND   (R.FunctionName LIKE '%#URL.Search#%' OR S.SystemModule LIKE '%#URL.Search#%')
	</cfif>
	<cfif URL.Class eq "Report">
	AND TemplateSQL != 'Application'
	<cfelse>
	AND TemplateSQL  = 'Application'
	</cfif>   	
	ORDER BY S.MenuOrder, 
	         R.SystemModule, 
			 R.FunctionClass, 
			 R.MenuClass, 
			 R.MenuOrder, 
			 R.FunctionName, 
			 R.Created 
	</cfquery>

</cfif>

<CF_Droptable dbName="AppsQuery"  tblName="#SESSION.acc#Subscription_#fileno#">

<tr><td colspan="2" height="100%">

	<table height="100%" width="100%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">
	
	<tr>
	
	<td colspan="7" height="40">
	
		<table height="100%" cellspacing="0" cellpadding="0">
		
		<tr>
		
		<td style="height:45px">&nbsp;</td>
		<td>
			
			<table cellspacing="0" cellpadding="0">
			<tr>
			 <td style="border: 1px solid silver;">	
			 
			    <cf_space spaces="43">
			 
			    <table style="width:100%" cellspacing="0" cellpadding="0"><tr><td>	 	
			 
			 	<input type   = "text" 
			        name      = "find" 
					id        = "find"
					value     = "#URL.search#" 
					size      = "18" 
					maxlength = "25" 
					class     = "regularxl" 
					style     = "height:30px;font-size:20;width:100;border:0px; background-color: ffffff;" 
					onClick   = "clearno()" 
					onKeyUp   = "search(event)">
					</td>
					
				  <!--- Change by Armin on 2/23/2017 ---->
				  <td align="right" style="padding-right:4px" id= "locate" onclick="reload('#URL.Filter#',only.value,'#URL.Class#',$('##find').val())" style="border-left: 1px solid silver;" width="24" align="center">
				   
				 <img src         = "#SESSION.root#/Images/search.png" 
					  alt         = "Search for report or module" 					  
					  width       = "21" 
					  height      = "21"
					  onMouseOver = "document.locate.src='#SESSION.root#/Images/contract.gif'" 
					  onMouseOut  = "document.locate.src='#SESSION.root#/Images/search.png'"
					  style       = "cursor: pointer;" 
					  border      = "0" 
					  align       = "absmiddle">
					  
					  </td></tr></table>
				 
			  </td> 			     
				      
			</tr>
			</table>
		
		</td>
		<td>&nbsp;</td>
		<td height="25" style="padding:3px">
			<table class="formspacing" cellspacing="0" cellpadding="0">
			<tr class="labelmedium">
			<cfparam name="URL.Class" default="report">
			<td><input type="radio" class="radiol" name="class" id="class" onclick="reload('#URL.Filter#',only.checked,'report',document.getElementById('find').value,'')" value="Report" <cfif URL.Class eq "Report">checked</cfif>></td>
			<td><cfif URL.Class eq "Report"><font color="6688aa"></cfif>Report/View</b></td>
			<td><input type="radio" class="radiol" name="class" id="class" onclick="reload('#URL.Filter#',only.checked,'dataset',document.getElementById('find').value,'')" value="Dataset" <cfif Class eq "Dataset">checked</cfif>></td>
			<td><cfif URL.Class eq "Dataset"><font color="6688aa"></cfif>Tag</b></td>
			<cfparam name="URL.Filter" default="">
			<cfif URL.Class neq "Dataset">
			<td style="border-right:1px solid silver">&nbsp;&nbsp;</td>
			<td style="padding-left:3px"><input type="radio" class="radiol" name="filter" id="filter" onclick="reload('0',only.checked,'#URL.Class#',document.getElementById('find').value,'')" value="0" <cfif URL.Filter eq "0">checked</cfif>></td>
			<td><cfif URL.Filter eq "0"><font color="gray"></cfif>Development</td>
			<td style="padding-left:3px"><input type="radio" class="radiol" name="filter" id="filter" onclick="reload('0w',only.checked,'#URL.Class#',document.getElementById('find').value,'')" value="0w" <cfif URL.Filter eq "0w">checked</cfif>></td>
			<td><cfif URL.Filter eq "0w"><font color="gray"></cfif>Pending</td>
			<td style="padding-left:3px"><input type="radio" class="radiol" name="filter" id="filter" onclick="reload('1',only.checked,'#URL.Class#',document.getElementById('find').value,'')" value="1" <cfif URL.Filter eq "1">checked</cfif>></td>
			<td><cfif URL.Filter eq "1"><font color="gray"></cfif>Deployed</td>
			<td style="padding-left:3px"><input type="radio" class="radiol" name="filter" id="filter" onclick="reload('',only.checked,'#URL.Class#',document.getElementById('find').value,'')" value="" <cfif URL.Filter eq "">checked</cfif>></td>
			<td><cfif URL.Filter eq ""><font color="gray"></cfif>All</b></td>
			<td style="padding-left:3px;border-right:1px solid silver"></td>
			</cfif>
			</table>
		</td>	
		<td  align="right" style="padding:3px">
			<table class="formpadding"  cellspacing="0" cellpadding="0">
			<tr class="labelmedium">
			<td style="padding-left:4px"><input type="checkbox" class="radiol" name="only" id="only" onclick="reload('#URL.Filter#',this.checked,'#URL.Class#',document.getElementById('find').value,'#url.invalid#')" <cfif #URL.Only# eq "1">checked</cfif>></td>
			<td style="padding-left:2px"><cf_tl id="My Reports"></td>			
			<td style="padding-left:4px"><input type="checkbox" class="radiol" name="invalid" id="invalid" onclick="reload('#URL.Filter#','#url.only#','#URL.Class#',document.getElementById('find').value,this.checked)" <cfif #URL.Invalid# eq "1">checked</cfif>></td>
			<td style="padding-left:2px"><cf_tl id="Invalid Reports"></td>
			</tr>
			</table>
		</tr>
		</table>
	</td></tr>
	
	<script language="JavaScript">
	
	function clearno() { 
	    document.getElementById("find").value = "" }
	
	function search() {
	
		se = document.getElementById("find")		 
		 if (window.event.keyCode == "13")
			{	document.getElementById("locate").click() }
							
	    }
		
	</script>
	
	</cfoutput>
	
	<tr><td colspan="8" class="line"></td></tr>
	
	<cfif url.class eq "Dataset">
	
	<tr class="line"><td colspan="8" height="30" bgcolor="ffffcf">
		<table width="98%" align="center" cellspacing="0" cellpadding="0">
			<tr><td class="labelit">Tag generated reports are report instances created by the designated custom TAG embedded in the application or to generate menu based data set inquiry to present context sensitive reporting.
			Instances will be automatically be recreated in the case the instance is removed.
			</td></tr>
		</table>
	</td></tr>
		
	</cfif>
	
	<tr><td colspan="8" height="100%" valign="top">
	
	<cf_divscroll>
	
	<table width="100%">
	
	<tr class="labelmedium line">
	    <td height="20" align="left"></td>
		<td>Owner</td>
		<td width="30%">Name</td>
		<td width="80">Subscribers</td>
		<td width="17%">Officer</td>
		<td align="center">Inception</td>	
		<td width="20"></td>
		<td width="20"></td>
	</tr>
	
	<tr><td height="2"></td></tr>	
	
	<cfoutput query="SearchResult" group="SystemModule">
	
		<cfquery name="Total"
	         dbtype="query">
			SELECT count(DISTINCT FunctionName) as Total
			FROM  SearchResult
			WHERE SystemModule = '#SystemModule#'				
			</cfquery>
	
	<tr>
	  <td height="21" colspan="4" class="labelmedium" style="font-weight:400;height;31;font-size:16px;padding-left:20px">#Description#&nbsp;&nbsp;<font size="2">[#Total.Total#]</font></td>
	  <td colspan="4" align="right">
	  
	  	<cfquery name="Global"
	         dbtype="query">
			SELECT count(DISTINCT FunctionName) as Total
			FROM  SearchResult
			WHERE SystemModule = '#SystemModule#'		
			AND FunctionClass = 'System'			
		</cfquery>
	  	
	    <cfif Global.recordcount eq "1">
	
	      <a href="javascript:recordedit('#Global.ControlId#')">Global parameters</a>&nbsp;
		  
		</cfif>  
		  
		</td>
	</tr>  
	
	<tr><td height="2"></td></tr>	
	<tr><td colspan="8" height="1" class="line"></td></tr>
	<tr><td height="3"></td></tr>	
	
	<cfset prior = "">
	
	<cfoutput group="FunctionClass">
	
	<cfquery name="Total"
	    dbtype="query">
		SELECT count(DISTINCT FunctionName) as Total
		FROM   SearchResult
		WHERE  SystemModule = '#SystemModule#'
		AND    FunctionClass = '#FunctionClass#'				
	</cfquery>		
	
	<tr><td colspan="8" class="labelmedium" style="padding-top:5px;padding-bottom:2px;padding-left:20px">/#FunctionClass#/ [#total.total#]</b></font></td></tr>
		
	<cfoutput group="MenuClass">
	
	<!---
	<tr><td colspan="6" height="1" bgcolor="d1d1d1"></td></tr>
	<tr><td colspan="6" height="20">&nbsp;&nbsp;<img src="#SESSION.root#/images/arrow.gif" alt="" border="0" align="absmiddle">#MenuClass#</td></tr>
	--->
	
	<cfoutput>
	
		<!--- check directory --->
		
		<cfif Reportroot eq "Application" or Reportroot eq "">
		   <cfset rootpath  = "#SESSION.rootpath#">
		<cfelse>
		   <cfset rootpath  = "#SESSION.rootreportPath#">
		</cfif>
			
		<cfset direxist = "1">
			
		<cfif not DirectoryExists("#rootpath#/#reportPath#")>
		    <cfset direxist = "0">
		</cfif>
		
		<cfset rowClass = "regular">	
		
		<cfif FunctionClass eq "System">
		 <cfset color = "E5E5E5">
		 <cfset icon = "light_none2.gif">
		<cfelseif direxist eq "0" and url.class neq "Dataset">
		  <cfset color = "e8e8e8">
		  <cfset icon = "light_red1.gif">
		  <cfif url.invalid eq "0">
		  	<cfset rowClass = "hide">
		  </cfif>
		<cfelseif Operational eq "0">	
		   <cfset color = "FFFFff">
		   <cfset icon = "pointer.gif">
		<cfelseif Deployment gte "1">	
		   <cfset color = "ffffaf">
		   <cfset icon = "workflow2.gif">
		<cfelseif Operational neq "1">	
		   <cfset color = "ffffff">
		   <cfset icon = "pointer.gif"> 
		<cfelse>
		 <cfset color = "white"> 
		 <cfset icon = "light_green1.gif">
		</cfif>   	
		<cfif TemplateSQL neq "SQL.cfm">
		 <cfset color = "ffffff">
		</cfif> 	
				
		<tr bgcolor="#color#" class="navigation_row labelmedium line" style="height:22px">
		
		<td width="6%" align="center" height="15" class="navigation_action" onclick="<cfif functionName neq prior>javascript:recordedit('#ControlId#')</cfif>">
		
			<cfif functionName neq prior>	
			
				 <img src="#SESSION.root#/Images/#icon#" alt="Maintain report" name="img0_#currentrow#" 
					  onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/#icon#'"
					  style="cursor: pointer;" align="absmiddle" height="9" width="9">
					  
			</cfif>			  
			
		</td>
		
		<td>#owner#</td>		
		<td>
	
		<a href="javascript:recordedit('#ControlId#')" title="Maintain report">
		
		<cfif functionName neq prior>
			
		<cfif TemplateSQL eq "Application"><b>Tag:</b>&nbsp;</cfif>
			<cfif operational eq "0"><font color="0080C0"></cfif>
				#MenuClass#/#FunctionName#
			
		<cfelse>
		
			<img src="#SESSION.root#/Images/join.gif" align="absmiddle" alt="" border="0">
			<font color="0080C0">
			<cfif operational neq "1">
				Development version
			<cfelse>
				Production version
			</cfif>
		</cfif>
		</a>
		
		</td>
		
		<td>
		
		<cfif functionName neq prior>
		
			<cfif Subscriptions gt "0">
			
			
			   	<img src="#SESSION.root#/Images/arrowright.gif" alt="View subscribers" 
						name="d#currentrow#Exp" id="d#currentrow#Exp" 
						border="0" height="11" width="11"
						align="absmiddle" class="regular" style="cursor: pointer;" 
						onClick="listing('#currentrow#','show','#controlId#')">
						 
					<img src="#SESSION.root#/Images/arrowdown.gif" 
						id="d#currentrow#Min" alt="Hide subscriptions" border="0" 
						align="absmiddle" class="hide" style="cursor: pointer;" 
						onClick="listing('#currentrow#','hide','#controlId#')">
						
						
			</cfif>		
			
			#Subscriptions#	
		
		</cfif>
		</td>
					
		<td>#left(OfficerFirstName,1)#. #OfficerLastName#</td>
		<td align="center">#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
					
		<td width="3%" align="center">
			
		<cfif TemplateSQL neq "Application">	
			
			   <cf_img icon="open" onclick="load('#ControlId#')">
			  
		</cfif>
		</td>
		
		<td width="3%">
		
		<cfif TemplateSQL neq "Application">
		
			<button class="button3" onClick="javascript: usage('#ControlId#')">
			    <img src="#SESSION.root#/Images/period.gif" alt="Usage" border="0" align="absmiddle" height="14" width="13">
			</button>
		
		</cfif>
					
		</td>			
	    </tr>
		
		<cfif functionName neq prior>
		 <tr class="hide" id="d#currentrow#"><td colspan="6" id="i#currentrow#"></td></tr>
		</cfif>
				 
		<cfif functionName neq prior>	
		<cfset prior = FunctionName>
		
		</cfif>
				
	</CFOUTPUT>	
	
	</CFOUTPUT>	
	
	</CFOUTPUT>	
	
	<tr bgcolor="FFFFFF"><td height="7"></td></tr>
	
	</CFOUTPUT>
	
	</table>
	
	</cf_divscroll>	

</td>
</tr>

</table>


</td>
</tr>

</table>

<cf_screenbottom html="No">
