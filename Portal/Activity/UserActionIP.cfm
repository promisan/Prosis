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
	WHERE UserAccount = '#SESSION.acc#'
	AND Role = 'AdminUser'
	</cfquery>

</cfif>


<cfif url.filter neq "">
 <script>
 	document.getElementById('etmaal').checked = true		
	document.getElementById('view').value     = "show"		
 </script>
</cfif>


<cfset diff = DateAdd("n", "-400", "#now()#")>	

<cfquery name="Logon" 
datasource="AppsSystem">
DELETE  FROM  UserStatus  
WHERE ActionTimeStamp < #diff#
</cfquery>		

<cfset diff = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<cfquery name="Logon" 
datasource="AppsSystem">
SELECT   *
FROM     UserStatus U INNER JOIN
         UserNames N ON U.Account = N.Account
WHERE 1=1		 
 <cfif URL.Filter eq "">
		<cfif URL.View eq "Hide">
		AND  ActionTimeStamp > #diff#
		</cfif>		 
	</cfif>
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
AND (N.LastName LIKE '%#url.find#%' or 
     U.HostName LIKE '%#url.find#%' or 
	 U.ApplicationServer LIKE '%#url.find#%' or 
	 N.Account LIKE '%#url.find#%')
</cfif>	 
ORDER BY U.NodeIP, N.LastName, U.HostName		 
</cfquery>		

<table width="99%">

	<tr>
	<td>
	
	<table width="100%" class="navigation_table">
	
	<tr class="labelmedium2 line fixrow">
		<td height="21">No.</td>
		<td>IP</td>
		<td>Browser</td>
		<td>Account</td>
		<td>Name</td>
		<td></td>
		<td>Group</td>
		<td>Ses.</td>
		<td>Server</td>
		<td>Last action</td>
		<td>Active since</td>
		<td></td>
	</tr>
		
		
	<cfparam name="access" default="Limited">	
	
	<cfset usr = 0>
	<cfoutput query="Logon" group="NodeIP">
	
	<cfset usr = usr + 1>
		
	<tr class="navigation_row line labelmedium2 clsFilterRow" style="height:14px">
		
		<td class="ccontent" style="padding-left:3px">#usr#</td>
		<td class="ccontent">#NodeIP#</td>
		<td class="ccontent">
		
		<cfinvoke component = "Service.Process.System.Client"  
		   method           = "getBrowser"
		   browserstring    = "#NodeVersion#"
		   minIE            = "10"
		   minFF            = "20"	  
		   returnvariable   = "userbrowser">	   
			
			<cfif userbrowser.pass eq "0"><font color="FF0000"></cfif>#UserBrowser.Name# #userbrowser.release#
					
		</td>
		
		<td class="ccontent"><cfif access eq "Full">
		     <a href="javascript:ShowUser('#Account#','audit')"><font color="0080FF">#Account#</font></a>
		    <cfelse>
			#Account#
			</cfif>	 
		</td>
		
		<td class="ccontent">
		
		<cfif access eq "Full">
			<a href="javascript:EditPerson('#RTrim(IndexNo)#')"><font color="0080FF">#Lastname#, #FirstName#</font>
		<cfelse>	
			#Lastname#, #FirstName#
		</cfif>
		
		</td>
		
		<td></td>
		
		<td class="ccontent">#AccountGroup#</td>
		
			<cfset rw = 0>
			
			<cfoutput group="LastName">
			
				<cfoutput group="HostName">
				<cfif rw eq "1">
				    <tr style="height:1px" class="clsFilterRow">
						<td colspan="6"></td>
						<td colspan="6" class="line"></td>
					</tr>
					<tr class="navigation_row labelit clsFilterRow">
					<td colspan="7"></td>
				<cfelse>
				    <cfset rw = "1">
				</cfif>
				
				<cfset diff = DateDiff("n", "#Logon.ActionTimeStamp#", "#now()#")>
				<cfif diff gt CLIENT.Timeout or ActionExpiration eq "1">
				  <cfset cl = "red">
				<cfelse>
				  <cfset cl = "black">
				</cfif>  
				<td height="18" class="ccontent"><font color="#cl#">#CurrentRow#</td>  
				<td height="18" class="ccontent"><font color="#cl#">#HostName#</td>
				<td class="ccontent"><font color="#cl#"<cfif diff lte "3"><b>now</b><cfelse>#diff#'</cfif></td>
				<td class="ccontent"><font color="#cl#">
				<cfif DateFormat(now(),CLIENT.DateFormatShow) eq DateFormat(Created, CLIENT.DateFormatShow)>
				#TimeFormat(Created, "HH:MM")#</td>
				<cfelse>
				#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(ActionTimestamp, "HH:MM")#</td>
				</cfif>
				<td style="padding-right:3px" id="#account#_#NodeIP#" class="ccontent">
					<cfif cl neq "red" and Drill.recordcount gt "0">
					   <a href="javascript:ptoken.navigate('setSessionExpiry.cfm?id=#account#&id1=#NodeIP#','#account#_#NodeIP#')"><cf_tl id="Expire"></a>
					</cfif>
				</td>
				</tr>
				</cfoutput>
				
			</cfoutput>
		
		</cfoutput>
		
		</table>
	
		</td></tr>
	
</table>


<cfset AjaxOnLoad("doHighlight")>	
