
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


<cfif url.filter neq "">
 <script>
 	document.getElementById('etmaal').checked = true		
	document.getElementById('view').value     = "show"		
 </script>
</cfif>


<cfset diff = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<cfquery name="Logon" 
datasource="AppsSystem">
	SELECT   *
	
	FROM     UserStatus U INNER JOIN
	         UserNames N ON U.Account = N.Account LEFT OUTER JOIN
             Ref_ModuleControl R ON U.SystemFunctionId = R.SystemFunctionId
			 
	WHERE 	 1=1	
	<cfif url.find neq "">
		AND (N.LastName LIKE '%#url.find#%' or 
	    	 U.HostName LIKE '%#url.find#%' or 
			 N.Account LIKE '%#url.find#%')
	</cfif>	 
	 <cfif URL.Filter eq "">
		<cfif URL.View eq "Hide">
		AND  ActionTimeStamp > #diff#
		</cfif>		 
	</cfif>
	<cfif URL.Filter neq "">
		<cfif url.filter eq "Framework">
		AND TemplateGroup IN ('System','Portal','Tools','Component')
		<cfelse>
		AND U.SystemFunctionId IN (SELECT     SystemFunctionId
								 FROM       Ref_ModuleControl C INNER JOIN
					                        Ref_ApplicationModule AM ON C.SystemModule = AM.SystemModule INNER JOIN
						                    #Client.LanPrefix#Ref_Application R ON AM.Code = R.Code
								WHERE       C.Operational = '1' 
								AND         R.Usage = 'System' 
								AND         R.Description = '#URL.Filter#')			 
		</cfif>
	</cfif> 
	ORDER BY R.SystemModule, N.LastName, U.NodeIp, U.HostName	 
</cfquery>		

<table width="99%" class="formpadding">

<tr>
<td>

	<table width="100%" border="0" cellspacing="0" cellpadding="0"  class="navigation_table">
	<tr class="labelit line">
	<td height="21"><b>No.</td>
	<td>Module</td>
	<td>Account</td>
	<td>Name</td>
	<td></td>
	<td>Ses.</td>
	<td>IP</td>
	<td>Server</td>
	<td>Last action</td>
	<td>Active since</td>
	<td></td>
	</tr>
	
	<cfset usr = 0>
	<cfoutput query="Logon" group="SystemModule">
		<cfset usr = usr + 1>
		<tr><td height="1" colspan="11" class="line clsFilterRow"></td></tr>
		<tr class="navigation_row line clsFilterRow">
		<td height="18" class="labelit ccontent">#usr#</td>
		<td class="labelit ccontent"><cfif systemModule neq "">#SystemModule#<cfelse>Other</cfif></td>
	
	<cfset rw = 0>
		<cfoutput group="LastName">
			<cfoutput group="NodeIP">
				<cfoutput group="HostName">
				<cfif rw eq "1">			    
					<tr class="navigation_row line clsFilterRow">
					<td colspan="2"></td>
				<cfelse>
				    <cfset rw = "1">
				</cfif>
				
				<cfset diff = DateDiff("n", "#Logon.ActionTimeStamp#", "#now()#")>
				<cfif diff gt CLIENT.Timeout or ActionExpiration eq "1">
				  <cfset cl = "red">
				<cfelse>
				  <cfset cl = "black">
				</cfif>  
				<td class="ccontent"><cfif Drill.recordcount gt "0">
				     <a href="javascript:ShowUser('#Account#','audit')">#Account#</a>
				    <cfelse>
					#Account#
					</cfif>	 
				</td>
				<td class="ccontent">
				<cfif Drill.recordcount gt "0">
					<a href="javascript:EditPerson('#RTrim(IndexNo)#')">#Lastname#, #FirstName#
				<cfelse>	
					#Lastname#, #FirstName#
				</cfif>
				</td>
				<td></td>
				<td class="ccontent" height="18"><font color="#cl#">#CurrentRow#</td>  
				<td class="ccontent" height="18"><font color="#cl#">#NodeIP#</td>
				<td class="ccontent" height="18"><font color="#cl#">#HostName#</td>
				<td class="ccontent"><font color="#cl#"><cfif #diff# lte "3"><b>now</b><cfelse>#diff# min.</cfif></td>
				<td class="ccontent"><font color="#cl#">
				<cfif DateFormat(now(),CLIENT.DateFormatShow) eq DateFormat(Created, CLIENT.DateFormatShow)>
				#TimeFormat(Created, "HH:MM")#</td>
				<cfelse>
				#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(ActionTimestamp, "HH:MM")#</td>
				</cfif>
				<td id="#account#_#NodeIP#" class="ccontent">
					<cfif cl neq "red" and Drill.recordcount gt "0">
					   <a href="javascript:ptoken.navigate('setSessionExpiry.cfm?id=#account#&id1=#NodeIP#','#account#_#NodeIP#')"><cf_tl id="Expire"></a>
					</cfif>
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