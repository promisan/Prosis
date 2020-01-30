
<cfparam name="url.filter" default="">
<cfparam name="url.find" default="">

<cfif url.find eq "undefined">
	<cfset url.find = "">
</cfif>

<cfif getAdministrator("*") eq "1">

	<cfset Drill.recordcount = "1">
	
<cfelse>

	<cfquery name="Drill" 
	datasource="AppsOrganization">
		SELECT   *
		FROM     OrganizationAuthorization
		WHERE    UserAccount = '#SESSION.acc#'
		AND      Role = 'AdminUser'
	</cfquery>

</cfif>

<cfif drill.recordcount gte "1">
  <cfset access = "Full">
<cfelse>
  <cfset access = "Limited">  
</cfif>

<cfif url.filter neq "">
 <script>
 	document.getElementById('etmaal').checked = true		
	document.getElementById('view').value     = "show"		
 </script>
</cfif>

<cfset daterecent = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<cfquery name="Logon" 
datasource="AppsSystem">
	SELECT   *
	FROM     UserStatus U,UserNames N 
	WHERE    1=1
	AND      U.Account = N.Account 
	<cfif URL.Filter neq "">
		<cfif url.filter eq "Framework">
    	AND TemplateGroup IN ('System','Portal','Tools','Component')
		<cfelse>		
		AND SystemFunctionId IN (SELECT     SystemFunctionId
								 FROM       Ref_ModuleControl C INNER JOIN
					                        Ref_ApplicationModule AM ON C.SystemModule = AM.SystemModule INNER JOIN
						                    #Client.LanPrefix#Ref_Application R ON AM.Code = R.Code
								WHERE       C.Operational = '1' 
								AND         R.Usage = 'System' 
								AND         R.Description = '#URL.Filter#')					
    	</cfif>
	</cfif>  
	
	<cfif url.find neq "">
	AND  (N.LastName LIKE '%#url.find#%' or 
	      U.HostName LIKE '%#url.find#%' or 
		  U.ApplicationServer LIKE '%#url.find#%' or 
		  N.Account LIKE '%#url.find#%')
	</cfif>	 
	
    <cfif URL.Filter eq "">
		<cfif URL.View eq "Hide">
		AND  ActionTimeStamp > #daterecent#
		</cfif>		 
	</cfif>
		
	ORDER BY N.LastName, N.Account, U.NodeIP, U.HostName		
	
</cfquery>		

<table width="99%" border="0" ellspacing="0" cellpadding="0" class="formpadding">

<tr>
<td>

<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

	<tr class="labelmedium line">
	<td height="21"></td>
	<td><cf_tl id="Account"></td>
	<td><cf_tl id="Owner"></td>
	<td><cf_tl id="Name"></td>	
	<td><cf_tl id="Entity"></td>
	<td><cf_tl id="S"></td>
	<td></td>
	<td><cf_tl id="Site"></td>	
	<td><cf_tl id="IP"></td>
	<td><cf_tl id="Browser"></td>
	<td><cf_tl id="Last"></td>
	<td><cf_tl id="Active"></td>
	<td></td>
	</tr>
	
	<cfset usr = 0>
	<cfoutput query="Logon" group="Account">
	<cfset usr = usr + 1>
	
	<tr class="navigation_row labelmedium line clsFilterRow">
	<td style="height:21px;padding-left:3px" class="labelit ccontent">#usr#.</td>
	
	<td class="ccontent"><cfif access eq "Full">
	     <a href="javascript:ShowUser('#Account#','audit')">#Account#</a>
        <cfelse>
		#Account# 
		</cfif>	 
	</td>
	<td style="padding-left:2px" class="ccontent"><cfif AccountMission neq "Global">#AccountMission#<cfelse>..</cfif></td>
	<td style="padding-left:2px" class="ccontent">
	<cfif access eq "Full">
		<a href="javascript:EditPerson('#RTrim(IndexNo)#')">#Lastname#, #FirstName#</font>
	<cfelse>	
		#Lastname#, #FirstName#
	</cfif>
	<font color="804000">/#AccountGroup#</font>
	</td>
		
	<cfset rw = 0>
	<cfoutput group="NodeIP">
	<cfoutput group="HostName">
	<cfoutput group="HostSessionId">
	<cfif rw eq "1">
	    <tr class="clsFilterRow">
			<td colspan="4"></td>
			<td colspan="9"></td>
		</tr>
		<tr class="navigation_row labelmedium line clsFilterRow">
		<td colspan="4"></td>
	<cfelse>
	    <cfset rw = "1">
	</cfif>
	
	<td class="ccontent"><cfif mission eq "">..<cfelse>#Mission#</cfif></td>
	
	<cfset diff = DateDiff("n", "#Logon.ActionTimeStamp#", "#now()#")>
	
	<cfif diff gt CLIENT.Timeout or ActionExpiration eq "1">
	  <cfset cl = "red">
	<cfelse>
	  <cfset cl = "black">
	</cfif>  
	<td height="18" style="font-size:10px;padding-right:2px" class="ccontent"><font color="#cl#">#CurrentRow#</td>  
	<td width="20" style="padding-top:4px" align="center" class="ccontent">	
	   <cf_img icon="expand" toggle="yes" onclick="listing('#currentrow#','show','#Account#','#HostName#','#HostSessionNo#')">				
	</td>
	<td height="27" style="padding-left:2px" class="ccontent">
	<font color="#cl#">
	<cfset hst = "">
	<cfloop index="itm" list="#HostName#" delimiters=".">
	<cfif hst eq "">
		<cfset 	hst = itm>
	</cfif>
	</cfloop>#hst#
	</td>
	<td style="padding-left:2px" class="ccontent">
	<cfif access eq "full"> 
		<cfif cl neq "red" and Drill.recordcount gt "0">
		<font color="#cl#">#NodeIP#
		</cfif>
	</cfif>
	</td>
	<td class="ccontent">
	
	<cfinvoke component = "Service.Process.System.Client"  
	   method           = "getBrowser"
	   browserstring    = "#NodeVersion#"
	   minIE            = "10"
	   minFF            = "30"	  
	   returnvariable   = "userbrowser">	   
		
	<cfif userbrowser.pass eq "0" and userbrowser.name neq "android" and userbrowser.name neq "iPhone"><font color="FF0000"></cfif>#left(UserBrowser.Name,8)# #userbrowser.release#
	</td>
	<td style="padding-right:5px" class="ccontent"><font color="#cl#"><cfif diff lte "3"><b>now</b><cfelse>#diff#'</cfif>
		<cfif currentrow eq "1"><cf_space spaces="12"></cfif>
	</td>
	<td class="ccontent"><font color="#cl#">
	
	<cfif DateFormat(now(),CLIENT.DateFormatShow) eq DateFormat(Created, CLIENT.DateFormatShow)>
		#TimeFormat(Created, "HH:MM")#
	<cfelse>
		#DateFormat(Created, "DD/MM")# #TimeFormat(ActionTimestamp, "HH:MM")#
	</cfif>
	<cf_space spaces="10">
	</td>
	<td align="right" style="width:50;padding-right:3px" id="#account#_#NodeIP#" class="ccontent">
		<cfif cl neq "red" and access eq "full" and HostSessionid neq "">
		   <a title="Expire session" href="javascript:ptoken.navigate('setSessionExpiry.cfm?id=#account#&id1=#NodeIP#&ID2=#HostSessionId#','#account#_#NodeIP#')"><font color="6688aa"><u><cf_tl id="Expire"></a>
		</cfif>
	</td>
	</tr>
	
	 <tr class="hide clsFilterRow" id="d#currentrow#">
		 <td colspan="13">
		    <cfdiv id="i#currentrow#">		
		 </td>
	 </tr>

</cfoutput>		 

</cfoutput>
</cfoutput>
</cfoutput>
</table>

</td></tr>
</table>

<cfset AjaxOnLoad("doHighlight")>	