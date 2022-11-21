
<cfparam name="URL.view" default="1">
<cfparam name="URL.del" default="">

<cfif url.del neq "">
	
	<cfquery name="Del" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM UserReport
		WHERE ReportId = '#url.del#'
	</cfquery>

</cfif>

<table width="99%" height="100%" align="center">

<tr><td valign="top">

<table width="100%" align="right">
	 
<cfset FileNo = round(Rand()*100)>  
    
<cfquery name="SearchResult" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   U.*, 
	         R.*, 
			 L.TemplateReport, 
			 L.LayoutName, 
			 S.Description, 
				 (SELECT   MAX(Created)
				  FROM     UserReportDistribution
				  WHERE    BatchId is NULL
		          AND      Account = '#SESSION.acc#' 
				  AND      ReportId = U.ReportId) as LastDate
	FROM     UserReport U,
	         Ref_ReportControlLayout L,
	         Ref_ReportControl R, 
	         Ref_SystemModule S
	WHERE    U.LayoutId     = L.LayoutId
	AND      L.ControlId    = R.ControlId
	AND      R.SystemModule = S.SystemModule
	AND      (
	           U.Account      = '#SESSION.acc#' 
	           OR
			   U.AccountGroup IN (
                       SELECT AccountGroup
                       FROM   UserNamesGroup
					   WHERE  Account = '#SESSION.acc#' 
					   AND    AccountGroup = U.AccountGroup)
	         )
	AND      R.ControlId    = '#url.ControlId#'	
	AND      L.Operational  = '1'
	AND      S.Operational  = '1'
	AND      U.Status NOT IN ('5','6')
	<!--- disabled not needed 
	<cfif URL.View eq "1">
	AND      U.ShowPopular = '1'
	</cfif>
	--->
	ORDER BY R.SystemModule, 
	         R.MenuClass, 
			 R.FunctionName, 
			 DistributionSubject, 
			 U.DateExpiration
</cfquery>

<tr><td colspan="2">

<table width="100%" align="center" class="formpadding;navigation_table">

<cfif SearchResult.recordcount eq "0">
	
	<tr><td align="center" class="labelmedium" height="30"><cf_tl id="No saved variants were found">.</b></td></tr>

<cfelse>

		<cfoutput query="SearchResult">
		
			<cfif url.reportid eq reportid>
			  <cfset  color = "f6f6f6">
			  <cfset  ft = "a0a0a0">
			  <cfset  st = "<i>">
			<cfelse>
			  <cfset  color = "transparent">
			  <cfset  ft = "black">
			   <cfset st = "">
			</cfif>									
						
			<TR id="#currentrow#1" style="background-color:#color#" class="navigation_row labelmedium fixlengthlist">
						
			<td width="30" align="center" style="background-color:#color#">
		
				<img src="#SESSION.root#/Images/arrowright.gif" alt="View criteria" 
					id="#currentrow#_subExp" border="0" class="show" 
					align="middle" style="cursor: pointer;" 
					onClick="more('#reportId#','show','#Currentrow#_sub')">
						
				<img src="#SESSION.root#/Images/arrowdown.gif" 
					id="#currentrow#_subMin" alt="Hide criteria" border="0" 
					align="middle" class="hide" style="cursor: pointer;" 
					onClick="more('#reportId#','hide','#currentrow#_sub')"> 
								
			</td>
			
			<td width="10" align="center" style="background-color:#color#">
						 
			     <cfif url.reportid neq reportid>				 
					   <cf_img icon="print" onClick="reportme('#ReportId#')"> 				  				  
				 </cfif>
			
			</td>
			
			<td width="10" align="center" style="background-color:#color#">
			
				<cfif url.reportid neq reportid>
				    <cf_img icon="edit" navigation="Yes" onClick="resetme('#controlid#','#ReportId#')">					
				</cfif>
							  
			</td>				
									
			<td width="10" align="center" style="padding-top:2px;background-color:#color#">
			
			    <cfif url.reportid neq reportid>
				 <cf_img icon="delete" onClick="purge('#ReportId#','#url.controlid#','#url.reportid#')">				 				
				</cfif>
				
			</td>
			
			<td style="background-color:#color#"><font color="#ft#">#st#
			<cfif LayoutName eq "Export Fields to MS-Excel"><cf_tl id="Analysis"><cfelse>#LayoutName#</cfif></td>
			<TD style="background-color:#color#"><font color="#ft#">#st##DistributionSubject#</TD>
			<TD style="background-color:#color#"><font color="#ft#">#st#<cfif DistributionPeriod neq "Manual">#DistributionPeriod# <cfif DistributionPeriod eq "Weekly">[#DistributionDOW#]<cfelseif DistributionPeriod eq "Monthly"><cfif DistributionDOM eq "1">[1st]<cfelse>[#DistributionDOM#th]</cfif></cfif></cfif></TD>
			<TD style="background-color:#color#"><font color="#ft#">#st##FileFormat# (#lcase(left(DistributionMode,3))#)</TD>
			<TD style="background-color:#color#"><font color="#ft#">#st##Dateformat(DateEffective, CLIENT.DateFormatShow)#-#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</TD>					 
			<TD title="Last run" style="background-color:#color#"><font color="#ft#">
			<cfif LastDate lt now() - 30 >
			<img src="#SESSION.root#/Images/caution.gif" alt="Report was never launched" border="0"> 
			Never<cfelse>#st##Dateformat(LastDate, CLIENT.DateFormatShow)#</cfif></TD>
			<td title="Subscription date" style="background-color:#color#"><font color="#ft#">#st##Dateformat(Created, CLIENT.DateFormatShow)#</td>
												
		    </TR>
			
			<tr id="#currentrow#_sub" class="hide" bgcolor="white">
			  <td align="right" colspan="1" valign="top"><img src="#SESSION.root#/Images/join.gif" alt="" border="0"></td>
			  <td colspan="7" id="s#currentrow#_sub"></td>
			  <td colspan="6"></td>
			</tr>
			
			<tr class="<cfif currentrow neq recordcount>line</cfif>"><td></td><td colspan="7">
			
				<table width="98%" align="center">
														
					<cfset link = "#SESSION.root#/Tools/CFReport/HTML/FormHTMLSubscriptionUser.cfm?reportid=#reportid#">
							
					<tr><td height="20" colspan="2" align="left" class="labelmedium2">
					
					   <cf_selectlookup
						    class    = "User"
						    box      = "box#reportid#"
							title    = "Publish this report variant to another user"
							icon     = "share.png"						
							link     = "#link#"			
							dbtable  = "System.dbo.UserReport"
							des1     = "Account">
								
					</td>
					</tr> 	
															
					<tr>
					    <td width="100%" colspan="2">						
							<cf_securediv bind="url:#link#" id="box#reportid#"/>						
						</td>
					</tr>  
				
			    </table>
			  						
			</td>
			<td colspan="6"></td>
			</tr>
																													
		</CFOUTPUT>	
					
	</cfif>		

	</TABLE>

	</td>
</tr>

</TABLE>

</td>
</tr>

</TABLE>

<cfset ajaxonload("doHighlight")>