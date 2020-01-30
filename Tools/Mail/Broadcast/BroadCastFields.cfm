
<cfquery name="Broadcast" 
	   datasource="AppsSystem" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		  SELECT *
		  FROM  Broadcast
		  WHERE BroadcastId = '#URL.ID#'
	</cfquery>
	
<!--- -------------------------------------------------------- --->    
<!--- generate the listing content and publish it as a view -- --->
<!--- -------------------------------------------------------- --->
		
<cfset url.systemFunctionId = BroadCast.systemFunctionId>
<cfset url.FunctionSerialNo = BroadCast.FunctionSerialNo>
<cfset url.showlist = "No">
		
<cf_inquiryContent>

<cfquery name="Listing" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 	
			SELECT * 
			FROM   Ref_ModuleControlDetail
			WHERE  SystemFunctionId = '#Broadcast.systemfunctionid#'		
			AND    FunctionSerialNo = '#Broadcast.functionserialNo#'			
		</cfquery>		
				
<!--- define the fields in the table that can be used --->
		
<cfquery name="Fields" 
	datasource="#Listing.QueryDataSource#">
	SELECT   C.name, C.userType 
    FROM     SysObjects S, SysColumns C 
	WHERE    S.id = C.id
	AND      S.name = 'vwListing#SESSION.acc#'		
	ORDER BY C.ColId
</cfquery>			

<table width="98%" cellspacing="0" cellpadding="0" class="formpadding">

	<tr><td height="4"></td></tr>
	<tr><td colspan="2"><i><font color="808080">The following dynamic fields are available:</font></i></td></tr>
    <tr><td height="3"></td></tr>
	<cfset cnt = 1>  
	<cfoutput query="fields">

		<cfif cnt eq "1">
			<tr class="linedotted">		
		</cfif>
		<td>&nbsp;</td>
		<td>@#Name#</td>
		<td><cfif usertype eq "12">[date]<cfelseif usertype eq "8">[number]<cfelse>[text]</cfif></td>
		<cfif cnt eq "3">
			</tr>
			
			<cfset cnt = 1>
		<cfelse> 
		   <cfset cnt = cnt+1>
	    </cfif>
		

	</cfoutput>

</table>
