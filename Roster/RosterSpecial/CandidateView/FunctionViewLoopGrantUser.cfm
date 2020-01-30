
<cfparam name="URL.RosterAction" default="0">

<cfinvoke component="Service.Access"  
	   method="useradmin" 
	   returnvariable="access">	

<cfoutput>

<cfparam name="url.source" default="Manual">

	<cfquery name="Officer" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  A.*, N.*
	FROM    RosterAccessAuthorization A, 
	        System.dbo.UserNames N
	WHERE   A.UserAccount = N.Account
	AND     A.FunctionId = '#URL.Id#'
	AND     A.AccessLevel = '#URL.Status#' 
	<cfif URL.source eq "manual">
	AND     A.Source = 'Manual'
	<cfelse>
	AND     A.Source = 'Manager' 
	</cfif>
	ORDER BY LastName
	</cfquery>
			
	<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">
			
	<tr><td>
	
		<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="ffffff" class="formpadding">
		
		<cfif Officer.recordcount eq "0">
		
		<tr><td align="center" class="labelit" height="20">No records to show in this view</td></tr>
		
		</cfif>
				
		<cfloop query="Officer">
				
			<tr class="labelmedium navigation_row linedotted">
			
			<cfif Access eq "EDIT" or Access eq "ALL">
			 
				<td width="5%" align="center">
				
					<img src="#SESSION.root#/Images/access1.gif" 
					onMouseOver="document.img0_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
					onMouseOut="document.img0_#currentrow#.src='#SESSION.root#/Images/access1.gif'"
					alt="User profile" name="img0_#currentrow#" 
					id="img0_#currentrow#" border="0" align="middle" 
					onClick="javascript:process('#Account#')">
					
				</td>
					
				<td width="10%" style="padding-left:10px"><a href="javascript:ShowUser('#URLEncodedFormat(Account)#')"><font color="0080C0">#Account#</a></td>
			
			<cfelse>
			
				<td colspan="2" width="10%" style="padding-left:10px;padding-right:10px">#Account#</a></td>
			
			</cfif>
			
			<td width="30%">#LastName#, #FirstName#</td>
			
			<td width="80">
			
				<cfif URL.RosterAction eq "1">
				
				<table cellspacing="0" cellpadding="0"><tr class="labelit" ><td>
				
					<cfquery name="Check" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    * 
						FROM      RosterAccessAuthorization
						WHERE     FunctionId  = '#FunctionId#'
						AND       UserAccount = '#UserAccount#' 
						AND       AccessLevel = '#url.status#'
					</cfquery>	
					
					<input type="radio" class="radiol" name="AccessCondition#CurrentRow#" value="Full" <cfif Check.accessCondition neq "Limited">checked</cfif> 
					onclick="_cf_loadingtexthtml='';ColdFusion.navigate('FunctionViewLoopGrantSave.cfm?rosteraction=#url.rosteraction#&accesscondition=default&Mode=update&Status=#url.status#&id=#url.id#&acc=#account#&row=#url.row#','i#url.row#')">
					</td><td style="padding-left:3px;padding-right:3px" class="labelit">Default</td><td>
					<input type="radio" class="radiol" name="AccessCondition#CurrentRow#" value="Limited" <cfif Check.accessCondition eq "Limited">checked</cfif> 
					onclick="_cf_loadingtexthtml='';ColdFusion.navigate('FunctionViewLoopGrantSave.cfm?rosteraction=#url.rosteraction#&accesscondition=limited&Mode=update&Status=#url.status#&id=#url.id#&acc=#account#&row=#url.row#','i#url.row#')">
					</td><td style="padding-left:3px;padding-right:3px" class="labelit"><font color="FF0000">Excl.&nbsp;Denial&nbsp;(9)</td></tr>
				
				</table>			
				
				</cfif>
			</td>
			<td width="20%" style="padding-left:7px"><cfif URL.source eq "manual">#OfficerFirstName# #OfficerLastName#</cfif></td>
			<td width="10%">#DateFormat(Created, CLIENT.DateFormatShow)#</td>
			<td width="4%" align="left" style="padding-left:4px">
			
				<cfif URL.source eq "manual">
				
					<cf_img icon="delete" 
					   onclick="_cf_loadingtexthtml='';	ColdFusion.navigate('FunctionViewLoopGrantSave.cfm?rosteraction=#url.rosteraction#&Mode=delete&Status=#url.status#&id=#url.id#&acc=#account#&row=#url.row#','i#url.row#')">
				
				</cfif>
				
			</tr>
					
		</cfloop>
				
		<cfif URL.source eq "manual">		
				
				<tr>
			
			       <td colspan="8">
			       <table width="100%" border="0" cellspacing="0" cellpadding="0">
				   <tr>
			     
			       <td height="25" colspan="3" align="left" valign="middle" class="labelmedium">
				   
				   <cf_tl id="Grant access" var="lbl">
				   	  	  
					 <cfset link = "FunctionViewLoopGrantSave.cfm?rosteraction=#url.rosteraction#||Mode=#url.mode#||Status=#url.status#||id=#url.id#||row=#url.row#">
													
							<cf_selectlookup
						    box          = "i#url.row#"
							title        = "#lbl#"
							link         = "#link#"
							button       = "No"
							close        = "No"
							class        = "user"
							des1         = "acc">			
						
			       </td>
			       </table>
			       </td>
				
			     </tr>
				 
		 </cfif>		 
				
	    </table>
		 
	</tr>
	
	<tr><td height="5" bgcolor="ffffff"></td></tr>		 
	
	</table>
	  			
</cfoutput>	

<cfset ajaxonload("doHighlight")>



