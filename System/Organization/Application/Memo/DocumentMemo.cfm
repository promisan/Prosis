
<cfparam name="url.memoid" default="">
<cfparam name="form.MemoContent" default="">
<cfparam name="url.MemoContent" default="">
<cfparam name="url.Action" default="">
<cfparam name="url.Header" default="1">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfoutput>
		
	<cfswitch expression="#Trim(url.action)#"> 
	    <cfcase value="delete"> 
			<cfquery name="Check" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM OrganizationMemo
				WHERE OrgUnit = '#URL.ID#'
				AND    MemoId = '#memoid#' 
			</cfquery>
			<cfset memoid="">
			<cfset url.memoid="">
			
	    </cfcase> 
	</cfswitch> 
		
	<cfif form.MemoContent neq "">
	
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  OrganizationMemo
			WHERE OrgUnit = '#URL.ID#'
				AND    MemoId = '#memoid#' 
		</cfquery>
		
		<cfif Check.recordcount eq "0">
	
			<cfquery name="Memo" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO OrganizationMemo
				(OrgUnit, MemoId, Owner, MemoContent, OfficerUserId, OfficerLastName, OfficerFirstName)
				VALUES
				('#URL.ID#','#memoid#','#url.owner#','#form.MemoContent#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
			</cfquery>
				
		<cfelse>
		
			<cfquery name="update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE OrganizationMemo
				SET    MemoContent = '#Form.MemoContent#'
				WHERE  OrgUnit     = '#URL.ID#'
				AND    MemoId      = '#memoid#'						
			</cfquery>	
		
		</cfif>
		
		<cfset url.memoid = "">
		
		</cfif>
	
		<cfquery name="Memo" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   OrganizationMemo
			WHERE  OrgUnit  = '#URL.Id#'
			AND    Owner    = '#URL.Owner#'
			ORDER BY Created DESC
		</cfquery>
		
		<cfinvoke component="Service.Presentation.Presentation"
		       method="highlight" class="highlight4"
		    returnvariable="stylescroll"/>
	
	   
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
			
		<cfif url.header eq "999">
			<tr>
			    <td width="16"></td>
				<td width="70%"><b><cf_tl id="Memo"></td>
				<td><b><cf_tl id="Officer"></td>
				<td><b><cf_tl id="Date">/<cf_tl id="Time"></td>
				<td align="center"></td>
			
			</tr>
		</cfif>
		
		<cfloop query="Memo">
		
		<cfif url.memoid eq memoid and url.MemoContent eq "" and SESSION.acc eq OfficerUserId>
				
				<tr>
				    <td valign="top" style="padding-top:2px" width="20">#currentrow#.</td>
					<td colspan="4" align="center" width="95%">
					<form name="formmemo" id="formmemo">	
						<textarea name="MemoContent" class="regular2" style="border:0px;background-color:f1f1f1;padding:3px;font-size:14px;width: 100%;height:75">#MemoContent#</textarea>
					</form>
					</td>
				</tr>
				
				<tr><td colspan="5" align="center">
					<button name="savem" id="savem" class="button10g" 
						onclick="ptoken.navigate('../memo/DocumentMemo.cfm?owner=#url.owner#&id=#OrgUnit#&memoid=#memoid#','imemo','','','POST','formmemo');">
					     <cf_tl id="Save">
					</button>			
				</td>
				</tr>		
		
		<cfelse>
			  
				<tr class="navigation_row">
					
				    <td valign="top" style="padding-left:4px" width="20" class="labelit">#currentrow#.</td>
					<td width="60%" class="labelit">#paragraphformat(MemoContent)#</td>
					<td valign="top" width="20%" class="labelit">#OfficerFirstName# #OfficerLastName#</td>
					<td valign="top"  width="120" class="labelit">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
					<td align="center" valign="top" style="padding-top:2px;padding-right:4px">
					   
					    <cfif SESSION.acc eq officeruserid or SESSION.isAdministrator eq "Yes">
						    <table cellspacing="0" cellpadding="0">
								<tr>
								<td style="padding-top:1px">
								 <cf_img icon="open" navigation="Yes" onclick="ptoken.navigate('../memo/DocumentMemo.cfm?owner=#url.owner#&id=#OrgUnit#&memoid=#memoid#&Action=edit','imemo')">
								</td>
								<td style="padding-top:2px;padding-left:2px">
								  <cf_img icon="delete" onclick="ptoken.navigate('../memo/DocumentMemo.cfm?owner=#url.owner#&id=#OrgUnit#&memoid=#memoid#&Action=delete','imemo')">
								</td>
								</tr>
							</table>	
						</cfif>
					</td>
				
				</tr>
		
		</cfif>
		
		</cfloop>
		
		<cfinvoke component="Service.Access" 
			      method="org"  
				  orgunit="#URL.ID#" 
				  returnvariable="access">	
			
		<cfif access eq "EDIT" or access eq "ALL">
		
			<cfif url.memoid eq "">
			
				<cf_assignId>
				<cfset memoid = rowguid>			
							
					<tr bgcolor="ffffff">
						<td valign="top" width="20" style="padding-top:2px;padding-left:4px" class="labelit"><cfoutput>#memo.recordcount+1#.</cfoutput></td>
						<td colspan="4" align="center" width="95%">
						<form name="formmemo" id="formmemo">
						<textarea name="MemoContent" class="regular" style="border:0px;background-color:f1f1f1;padding:3px;font-size:14px;width:100%;height:75"></textarea>
						</form>
						</td>
					</tr>
						
					<tr><td colspan="5" align="right">
						   
						    <cfoutput>
							<button name="savem" id="savem" class="button10g" 
							onclick="ptoken.navigate('../memo/DocumentMemo.cfm?owner=#url.owner#&id=#url.id#&memoid=#memoid#','imemo','','','POST','formmemo');">		
								<cf_tl id="Add">
							</button>
							</cfoutput>
							
						</td>
					</tr>
					
			</cfif>
		
		</cfif>
	
	</table>

</cfoutput>


<cfset ajaxonload("doHighlight")>