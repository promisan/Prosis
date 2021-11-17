
<cfquery name="Parameter" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Parameter 
</cfquery>

<!--- This is the other log of templates visited

<cfquery name="Log" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   TOP 20 *
	FROM     UserStatusLog UR  
	WHERE    UR.Account = '#URL.Account#'
	AND      UR.HostName  = '#URL.HostName#'
	AND      UR.HostSessionNo = '#URL.HostSessionNo#' 
	AND      ActionTimeStamp > getdate()-4
	ORDER BY  ActionTimeStamp DESC
</cfquery>

      <table width="97%" align="center" cellspacing="0" cellpadding="0" class="formspacing">
         <cfoutput query="log">
 		 <tr class="linedotted">  
		   <td width="5%"></td>
		   <td width="5%" class="labelit">#CurrentRow#.</td> 		   
	   			<cfset v = ReplaceNoCase("#ActionTemplate#","/#Parameter.VirtualDirectory#/","", "ALL")>
		   <td width="80" class="labelit">#TemplateGroup#</td>			
		   <td width="60%" class="labelit">
		   <cfif findNoCase("Default.cfm","#v#")><b>#SESSION.welcome# logon</b><cfelse>#v#</cfif>
		   </td>
		   <td width="10%" class="labelit">#DateFormat(ActionTimeStamp,CLIENT.DateFormatShow)#</td>
		   <td width="10%" class="labelit">#TimeFormat(ActionTimeStamp,"HH:MM:SS")#</td>		
		 </tr>				
		 </cfoutput>
	  </table> 
 
 --->
  
<cfquery name="Log" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 
	 SELECT   DISTINCT TOP (20) ModuleActionId, 
	          SystemModule, 
			  FunctionClass, 
			  NodeIP, 
			  HostName, 
			  M.SystemFunctionId, 
			  M.FunctionName, 
			  Mission, 
			  ActionObject,
			  ActionObjectKeyValue1,
			  ActionQueryString, 
			  ActionDescription, 
			  ActionTimeStamp
	 FROM     UserActionModule U, Ref_ModuleControl M
	 WHERE    U.SystemFunctionId = M.SystemFunctionId
	 AND      HostSessionId      IN (SELECT HostSessionId FROM UserStatus WHERE UserStatusId = '#URL.drillid#')	 
	 AND      ActionTimeStamp > getdate()-1
	 ORDER BY ActionTimeStamp DESC

</cfquery>

<table width="97%" align="center" class="navigation_table">

	<cfif log.recordCount eq 0>
		<tr>
			<td class="labelmedium2" style="padding:10px; color:red;" align="center">
				[ <cf_tl id ="No log records to show"> ]
			</td>
		</tr>
	</cfif>
	
	<cfoutput query="log">
		<tr class="labelmedium2 navigation_row clsFilterRow line fixlengthlist" style="height:14px;">  
		<td></td>
		<td>#CurrentRow#.</td> 	
		<td class="ccontent">#SystemModule#</td>			   	   	   			
		<td class="ccontent">#FunctionName# [#FunctionClass#]</td>		
		<td class="ccontent">#Mission#</td>	
		<td class="ccontent"><cfif ActionObject eq "">#ActionDescription#<cfelse>#ActionObject#:#ActionObjectKeyValue1#</cfif></td>		   
		<td class="ccontent">#DateFormat(ActionTimeStamp,CLIENT.DateFormatShow)# #TimeFormat(ActionTimeStamp,"HH:MM:SS")#</td>		   
		</tr>				
	</cfoutput>
	
</table> 

<cfset ajaxOnload("doHighlight")>


 