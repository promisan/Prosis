<!--- generate entries if they do not exist --->

<!--- ------------------------------------- --->
<!--- generate entries if they do not exist --->
<!--- ------------------------------------- --->

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ModuleControl">	

<cfquery name="Check" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     M.SystemFunctionId, L.Code, M.FunctionName, M.FunctionMemo
	INTO       userquery.dbo.#SESSION.acc#ModuleControl
	FROM       Ref_ModuleControl M CROSS JOIN
	           Ref_SystemLanguage L
	WHERE      1=1		   
	<cfif url.find neq "">
	AND        M.FunctionName LIKE '%#URL.Find#%'
	<cfelse>
	AND        M.SystemModule = '#URL.Module#'
	AND        M.FunctionClass = '#URL.FunctionClass#'
	AND        M.MainMenuItem = '#URL.Main#'
	</cfif>		   
</cfquery>		

<cftry>   

<cfquery name="Insert" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO Ref_ModuleControl_Language
	            (SystemFunctionId, LanguageCode, FunctionName, FunctionMemo)
	SELECT      I.SystemFunctionId, I.Code, I.FunctionName, I.FunctionMemo
	FROM        userQuery.dbo.#SESSION.acc#ModuleControl I LEFT OUTER JOIN Ref_ModuleControl_Language M ON I.SystemFunctionId = M.SystemFunctionId
	  AND       I.Code = M.LanguageCode
	GROUP BY    I.SystemFunctionId, I.Code, I.FunctionName, I.FunctionMemo, M.LanguageCode
	HAVING      M.LanguageCode is NULL
</cfquery>		

<cfcatch></cfcatch>   

</cftry>
	
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#ModuleControl">		

<!--- show records --->

<cfset FileNo = round(Rand()*10)>
   
<cfif SESSION.isAdministrator eq "No">  
 
	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT M.*, S.Description
	<cfif lcase(url.module) eq 'selfservice' or (lcase(url.module) eq 'portal' and lcase(url.functionClass) eq 'portal') or lcase(url.module) eq 'pmobile'>
	FROM  #client.LanPrefix#Ref_ModuleControl M, 
	<cfelse>
	FROM  xl#client.languageId#_Ref_ModuleControl M, 
	</cfif>
	      Ref_SystemModule S
	WHERE M.SystemModule = S.SystemModule
	<cfif lcase(url.module) neq 'selfservice' and (lcase(url.module) neq 'portal' and lcase(url.functionClass) neq 'portal') and lcase(url.module) neq 'pmobile'>
	AND   M.Mission = '' <!--- generic --->
	</cfif>
	AND   S.RoleOwner IN (SELECT ClassParameter 
	                           FROM Organization.dbo.OrganizationAuthorization
							   WHERE UserAccount = '#SESSION.acc#'
							   AND   Role = 'AdminSystem')
	<cfif url.find neq "">
	AND   M.FunctionName LIKE '%#URL.Find#%'
	<cfelse>
	AND   M.SystemModule = '#URL.Module#'
	AND   M.FunctionClass = '#URL.FunctionClass#' 
	AND   M.MainMenuItem = '#URL.Main#' 
	</cfif>
	
	ORDER BY M.MenuClass, M.MenuOrder, M.SystemFunctionId
	</cfquery>
		
<cfelse>

	<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT M.*, S.Description
	<cfif lcase(url.module) eq 'selfservice' or (lcase(url.module) eq 'portal' and lcase(url.functionClass) eq 'portal') or lcase(url.module) eq 'pmobile'>
	FROM  #client.LanPrefix#Ref_ModuleControl M, 
	<cfelse>
	FROM  xl#client.languageId#_Ref_ModuleControl M, 
	</cfif>
	      Ref_SystemModule S
	WHERE M.SystemModule = S.SystemModule
	<cfif lcase(url.module) neq 'selfservice' and (lcase(url.module) neq 'portal' and lcase(url.functionClass) neq 'portal') and lcase(url.module) neq 'pmobile'>
	AND   M.Mission = '' <!--- generic --->
	</cfif>
	<cfif url.find neq "">
	AND   M.FunctionName LIKE '%#URL.Find#%'
	<cfelse>
	AND   M.SystemModule = '#URL.Module#'	
	AND   M.FunctionClass = '#URL.FunctionClass#' 	
	AND   M.MainMenuItem = '#URL.Main#' 
	</cfif>	
	<cfif FunctionClass eq "Inquiry">
	ORDER BY M.Created DESC
	<cfelse>
	ORDER BY M.MenuClass,M.MenuOrder, M.SystemFunctionId 
	</cfif>
	</cfquery>

</cfif>

<cf_divscroll style="height:100%">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfoutput>
<!--- added button to trigger a refresh --->
<input class="hide" type="button" id="listing_refresh" onclick="more('#url.Module#','#url.main#','#url.functionClass#','#url.find#')">
</cfoutput>

<tr><td>

	<table width="100%" border="0" class="navigation_table">
	
	 <cfif lcase(url.module) eq "selfservice" or lcase(url.module) eq "pmobile">
	 	<cfoutput>
		   <tr>
		   <td colspan="7" align="left" height="20">
				<table class="formpadding">
				  <tr><td height="4"></td></tr>
				  <tr><td colspan="2" class="labellarge">
				  	<img onclick="addportal('#url.Module#','#url.main#','#url.functionClass#','#url.find#')" src="#SESSION.root#/Images/webportal.png" alt="" border="0" align="absmiddle">		
					<cfset vTitleNew = "Portal"> 
					<cfif lcase(url.module) eq "pmobile">
						<cfset vTitleNew = "Prosis Mobile"> 
					</cfif>
				  	<a href="javascript:addportal('#url.Module#','#url.main#','#url.functionClass#','#url.find#')">Create a new #vTitleNew# Instance</a>
				  </td>
				  </tr>		
			    </table>
		  </td>
		  </tr>
		</cfoutput>
	</cfif>
	
	<cfoutput query="SearchResult" group="SystemModule">
	
	<cfif url.find neq "">	  
	
	   <tr><td colspan="7" class="labellarge">#SystemModule#</td></tr>
	   
	<cfelse>
	
	   <cfif url.main eq "1">
	   
		   <cfif FunctionClass eq "Manuals">
		   
		   <tr>
		   <td colspan="7" align="left" height="20">
				<table cellspacing="0" cellpadding="0" class="formpadding">
				  <tr><td height="7"></td></tr>
				  <tr><td colspan="2" width="20">		  
				  <img onclick="addmanual('#url.Module#','#url.main#','#url.functionClass#','#url.find#')" src="#SESSION.root#/Images/manual.png" height="31" width="31" alt="" border="0" align="absmiddle">		  
				  </td>
				  <td style="padding-left:8px;padding-top:6px"><a href="javascript:addmanual('#url.Module#','#url.main#','#url.functionClass#','#url.find#')"><b>Add a Manual</a>
				  </td>
				  </tr>
				  <tr><td height="2"></td></tr>
				  <tr>
				  <td>&nbsp;&nbsp;&nbsp;</td>
				  <td colspan="2" class="labelmedium">
				  <font color="gray">Manuals are externally prepared (PDF) documents that refer to application functions as supported by the system.
				  </td>
				  </tr>
			    </table>
		  </td>
		  </tr>
		   
		  <cfelseif FunctionClass eq "Inquiry" or FunctionClass eq "Application">
		      
		   <tr>
		   <td colspan="7" align="left" height="20">
				<table cellspacing="0" cellpadding="0" class="formpadding">
				  <tr><td height="4"></td></tr>
				  <tr>				 
				  	<td class="labellarge" style="font-size:20px">		  				  	  
					  <a href="javascript:add('#url.Module#','#url.main#','#url.functionClass#','#url.find#')"><cf_tl id="Add a custom Listing"></a>
					  </td>
				  </tr>				 
				  <tr>				  
					  <td class="labelmedium" style="padding-left:4px">
					  <font color="gray">Listings may be created by developers and can then be deployed in exactly the same way as any other #SESSION.welcome# application function.
					  </td>
				  </tr>
			    </table>
		  </td>
		  </tr>
		  
		  </cfif>
	  
	  </cfif>
	  	    
	</cfif>
	
	<cfoutput group="FunctionClass">
	
	<cfif url.find neq "">
		<tr class="line"><td colspan="7" class="labellarge" style="padding-left:10px;height:35">#FunctionClass#</td></tr>
		
	</cfif>
	
	<cfif currentrow eq "1">
		<tr class="labelmedium line fixrow"> 
		    <td width="20"></td>
		    <TD style="min-width:200px"><cf_tl id="Name"></TD>
			<TD width="25%"><cf_tl id="Template"></TD>		
			<TD style="min-width:80px"><cf_tl id="Entered"></TD>
			<TD style="min-width:20px" align="center">O</TD>	
			<TD width="45%"><cf_tl id="Role"> / <cf_tl id="Usergroup"></TD>				
		</TR>		
	</cfif>
	
	<cfoutput group="MainMenuItem">
	
		<cfoutput group="MenuClass">
		
			<tr class="line">
			
				<td colspan="6" style="padding-left:10px;font-weight:200;padding-top:5px;height:56px;font-size:31px" class="labelmedium">
					<cfif SystemModule eq "Portal" and FunctionClass eq "Portal" and MenuClass eq "Topic">
						<a href="javascript: maintaintopics('#SystemModule#','0','#FunctionClass#','');" title="Click to maintain topics">#MenuClass#</a>
					<cfelse>
						#MenuClass#
					</cfif>
				</td>
			</tr>
			
			<cfoutput group="SystemFunctionId">					
							
			    <cfif Operational eq "0" and MenuClass neq "Builder">
					<tr bgcolor="e4e4e4" class="navigation_row lined">
				<cfelseif MenuClass eq "Builder">	
					<tr bgcolor="fafafa" id="line#SystemFunctionId#" class="navigation_row line">
				<cfelse>
					<tr bgcolor="white" class="navigation_row line">
				</cfif>			    
					
					<cfif systemmodule eq "selfservice" or systemmodule eq "pmobile">
					
						<td height="20" 
							style="padding-left:14px;padding-top:2px;padding-right:6px"
							class="navigation_action"
							onClick="portaledit('#SystemFunctionId#','#systemmodule#','#url.functionClass#')">
							
						<cf_img icon="edit">
											
					<cfelseif menuclass eq "Builder">
						<td height="20" 
							style="padding-left:14px;padding-top:2px;padding-right:6px"
							class="navigation_action"
							onClick="functionedit('#SystemFunctionId#')">
							
					   	  <cf_img icon="edit">

					<cfelse>
						<td height="20" 
							style="padding-left:14px;padding-top:2px;padding-right:6px"
							class="navigation_action"
							onClick="functionedit('#SystemFunctionId#')">							
	
						 <cf_img icon="edit">		
						  
					</cfif>	  
					
				</td>
				<TD style="width:100%">
				
				<cfif url.find neq "">
					<cfset cc = replaceNocase(FunctionName,  URL.Find,  "<b><u><font color='0080C0'>#URL.Find#</font></u></b>" ,  "ALL")>
					#cc#
				<cfelse>
				   <cfif mainmenuitem eq "0"></cfif>#FunctionName#
				</cfif>
				
				</TD>
				<td style="padding-left:4px;padding-right:4px">
				
				<cfif menuclass eq "Builder">					
					#OfficerLastname#						
				<cfelse>				
					<cfif FunctionPath eq ""><b>jv:</b>&nbsp;#ScriptName#
					<cfelse>
						<cfif len(FunctionPath) gt 44>#left(FunctionPath,30)#...<cfelse>#FunctionPath#</cfif>
					</cfif>
				
				</cfif>
				
				</td>
				
				<TD style="padding-right:4px">#Dateformat(Created, "DD/MM/YY")#</TD>
				
				<TD style="min-width:20px;padding-right:5px" id="status#SystemFunctionId#" align="center">				
				   <cfif Operational eq "0"><font color="FF0000">D</font><cfelse></cfif>
			    </TD>	
					
				<TD id="role#SystemFunctionId#" style="min-width:480px">
				    <cfif systemmodule neq "selfservice" or systemmodule eq "pmobile">
						<cfset url.id = "#SystemFunctionId#">
						<cfinclude template="RecordListingRole.cfm">		
					</cfif>
				</TD>
				
				
			    </TR>						
										
			</CFOUTPUT>	
			
		</CFOUTPUT>	
	
	</CFOUTPUT>	
	
	</CFOUTPUT>	
	
	</CFOUTPUT>	
	
	</TABLE>

</td></tr>

</table>

</cf_divscroll>

<cfset AjaxOnLoad("doHighlight")>

