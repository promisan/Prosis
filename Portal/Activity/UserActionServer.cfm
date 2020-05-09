
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


<cfif drill.recordcount gte "1">
  <cfset access = "Full">
<cfelse>
  <cfset access = "Limited">  
</cfif>

<cfset diff = DateAdd("n", "-#CLIENT.Timeout#", "#now()#")>

<cfquery name="Logon" 
datasource="AppsSystem">
SELECT   *
FROM     UserStatus U INNER JOIN
         UserNames N ON U.Account = N.Account
WHERE    1=1		
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
AND     (N.LastName LIKE '%#url.find#%' or 
         U.HostName LIKE '%#url.find#%' or 
		 U.ApplicationServer LIKE '%#url.find#%' or 
    	 N.Account LIKE '%#url.find#%')
</cfif>	 		 
 <cfif URL.Filter eq "">
		<cfif URL.View eq "Hide">
		AND  ActionTimeStamp > #diff#
		</cfif>		 
	</cfif>
ORDER BY U.HostName, N.LastName, U.NodeIp	 
</cfquery>		

<table width="99%" class="formpadding">
<tr>
<td>
<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table">

<tr class="labelmedium line fixrow">
	<td><cf_tl id="No"></td>
	<td><cf_tl id="Host"></td>
	<td></td>
	<td><cf_tl id="Account"></td>
	<td><cf_tl id="Name"></td>
	<td></td>
	<td><cf_tl id="Group"></td>
	<td><cf_tl id="S"></td>
	<td><cf_tl id="IP"></td>
	<td><cf_tl id="Browser"></td>
	<td><cf_tl id="Last action"></td>
	<td><cf_tl id="Active"></td>
	<td></td>
</tr>

<cfset usr = 0>

<cfoutput query="Logon" group="HostName">

		<cfset usr = usr + 1>

		<tr class="navigation_row labelit clsFilterRow">
	
		<td class="line" class="ccontent">#usr#</td>
		<td class="line" class="ccontent">#HostName#</td>
	
		<cfset rw = 0>
	
		<cfoutput group="LastName">
			<cfoutput>
			
			    <cfif rw eq "1">    
				<tr class="navigation_row labelit clsFilterRow">
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
				
				<td align="center">
				    <cf_img icon="expand" toggle="yes" onclick="listing('#currentrow#','show','#Account#','#HostName#','#HostSessionNo#')">
				</td>
				
				<td class="line ccontent"><cfif access eq "Full">
				    <a href="javascript:ShowUser('#Account#','audit')"><font color="6688aa" >#Account#</font></a>
				    <cfelse>
					#Account#
					</cfif>	 
				</td>
				
				<td class="line ccontent">
				<cfif access eq "Full">
					<a href="javascript:EditPerson('#RTrim(IndexNo)#')">#Lastname#, #FirstName#
				<cfelse>	
					#Lastname#, #FirstName#
				</cfif>
				</td>
				
				<td class="line ccontent"></td>
				<td class="line ccontent">#AccountGroup#</td>
				<td class="line ccontent" style="height:22px"><font color="#cl#">#CurrentRow#</td>  
				<td class="line ccontent" height="18"><font color="#cl#"><cfif access eq "Full">#NodeIP#</cfif></td>
				<td class="line ccontent">
				
					<cfinvoke component = "Service.Process.System.Client"  
					   method           = "getBrowser"
					   browserstring    = "#NodeVersion#"
					   minIE            = "10"
					   minFF            = "20"	  
					   returnvariable   = "userbrowser">	   
						
					<cfif userbrowser.pass eq "0" and userbrowser.name neq "android" and userbrowser.name neq "iPhone"><font color="FF0000"></cfif>#UserBrowser.Name# #userbrowser.release#
				
				</td>
				
				<td class="line ccontent"><font color="#cl#"><cfif diff lte "3"><b>now</b><cfelse>#diff#'</cfif></td>
				<td class="line ccontent"><font color="#cl#">
				
				<cfif DateFormat(now(),CLIENT.DateFormatShow) eq DateFormat(Created, CLIENT.DateFormatShow)>
				#TimeFormat(Created, "HH:MM")#
				<cfelse>
				#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(ActionTimestamp, "HH:MM")#
				</cfif>
				
				</td>
				
				<td class="line ccontent" style="padding-right:3px" id="#account#_#NodeIP#">
					<cfif cl neq "red" and Drill.recordcount gt "0">
					   <a href="javascript:ptoken.navigate('setSessionExpiry.cfm?id=#account#&id1=#NodeIP#','#account#_#NodeIP#')"><font color="6688aa"><cf_tl id="Expire"></a>
					</cfif>
				</td>
				
			 </tr>
			 
			 <tr class="hide clsFilterRow" id="d#currentrow#">
			     <td colspan="2"></td>
				 <td colspan="11">
				    <cfdiv id="i#currentrow#">
				 </td>
			 </tr>
			</cfoutput>
		</cfoutput>	
	</cfoutput>
	
	</table>
	</td>
	</tr>
	
</table>

<cfset AjaxOnLoad("doHighlight")>	