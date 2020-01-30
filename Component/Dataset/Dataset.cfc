
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "DataSet">

	<cffunction access="public" name="RegisterDataset" 
		         output="true" 
				 returntype="string" 
				 displayname="Register datasets">
	
	<cfargument name="Module"       type="string" required="yes"   default="">		 
	<cfargument name="FunctionName" type="string" required="yes"   default="">			 
	<cfargument name="QueryPath"    type="string" required="yes"   default="">			 
		
	<!--- generate an general report entry --->
	
	<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    ControlId
			FROM      Ref_ReportControl R
		    WHERE     FunctionName = '#FunctionName#'
			AND       TemplateSQL  = 'Application' 
			AND       SystemModule = '#Module#' 
		</cfquery>
		
	<cfif Check.recordcount eq "0">	
	
			<cf_AssignId>
			
			<cfset controlid = "#rowguid#">
			
			<cfquery name="Insert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ReportControl
			(ControlId,
			 SystemModule, 
			 FunctionClass, 
			 FunctionName, 
			 ReportPath,
			 TemplateSQL, 
			 OfficerUserId, 
			 OfficerLastName, 
			 OfficerFirstName)
			 VALUES ('#rowGuid#',
			         '#Module#',
			         'Reports',
					 '#FunctionName#',
					 '#QueryPath#',
					 'Application',
			         '#SESSION.acc#',
					 '#SESSION.last#',
					 '#SESSION.first#')
			</cfquery>
			
	<cfelse>
			
			<cfset controlid = "#check.controlid#">			
			
	</cfif>		
	
	<cfquery name="Layout" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT    ControlId
			FROM      Ref_ReportControlLayout R
		    WHERE     ControlId = '#ControlId#'
			AND       TemplateReport = 'Excel'
		</cfquery>
		
		<cfif Layout.recordcount eq "0">
			
			<cfquery name="Insert" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO Ref_ReportControlLayout
						(ControlId, 
						 LayoutName, 
						 TemplateReport, 
						 OfficerUserId, 
						 OfficerLastName, 
						 OfficerFirstName) 
					 VALUES
					 ('#controlId#',
					  'Export Fields to MS-Excel',
					   'Excel',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')
					</cfquery>
					
		</cfif>	
		
		<cfreturn controlid>
		
	</cffunction>	
	
	<cffunction access="public" name="Listing" 
		         output="true" 
				 returntype="string" 
				 displayname="Register datasets">
	
	<cfargument name="ControlId"    type="string" required="yes"   default="">		 
	<cfargument name="FunctionName" type="string" required="yes"   default="">			 
	<cfargument name="QueryPath"    type="string" required="yes"   default="">	
	
	<cfoutput>
		<script src="#SESSION.root#/Tools/Ajax/AjaxRequest.js" type="text/javascript"></script> 
	
		<script language="JavaScript">
	
			function extract(id,string)
			
			{
			se  = document.getElementById("detail");
			bu  = document.getElementById("busy");
					
			se.className = "hide"; 
			bu.className = "regular";
						
			url = "#SESSION.root#/Component/Dataset/DataSetQuery.cfm?controlid="+id+"&"+string
					   		  	
				AjaxRequest.get(					
				{
				'url':url,
				   'onSuccess':function(req) 
					{
					    se.className = "regular";
						bu.className = "hide";
						se.innerHTML = req.responseText;
					},
				   'onError':function(req) 
					{ 
						se.className = "regular";
						bu.className = "hide";
						se.innerHTML = req.responseText;
					}	
				}
				);			
			}
			
			
			function facttable(id,tbl,rec)
			{
		    w = #CLIENT.widthfull# - 80;
		    h = #CLIENT.height# - 110;
						
			window.open("#SESSION.root#/Tools/CFReport/Analysis/SelectSource.cfm?outputid="+id+"&table="+tbl+"&NoRec="+rec, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", menubar=no, location=0, status=yes, toolbar=no, scrollbars=no, resizable=yes");
			
			}
			
		</script>	
			
	</cfoutput>		
			
				
		<table height="100%" width="100%">
		
		<tr><td bgcolor="EAEAEA" height="1"></td></tr>
		<tr><td height="85%" colspan="2">
		<table width="99%"
		       height="100%"
			   style="border: thin ridge F4F4F4;"
		       cellspacing="0"
		       cellpadding="0"
			   class="formpadding"
		       align="center"
		       bordercolor="C0C0C0"
		       bgcolor="FFFFFF">
					   
		<tr>
		<td valign="top">
					
				<table width="100%">
				<tr bgcolor="f4f4f4">
				   <td height="20">&nbsp;</td>
				   <td>Name</td>
				   <td>Date created</td>
				   <td>Officer</td>
				   <td>Query string</td>
				   <td>Records</td>
				   <td>Action</td>
				</tr>
				<tr>
				   <td height="1" colspan="7" bgcolor="C0C0C0"></td>
				</tr>
				
				<cfquery name="DataSet" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      Ref_ReportControlOutput
					WHERE     ControlId = '#ControlId#'
				</cfquery>
				
				<cfoutput query="Dataset">
				
					<cftry>
					
						<cfquery name="DataSet" 
						datasource="AppsOLAP" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT    count(*) as Records
							FROM      #VariableName#
						</cfquery>
						
						<cfset st = "#DataSet.Records#">
					
						<cfcatch>
							<cfset st = "Not available">
						</cfcatch>
						
					</cftry>
					
					<tr>
					   <td height="20">&nbsp;</td>
					   <td>#OutputName#</td>
					   <td>#DateFormat(Created,CLIENT.DateFormatShow)# #TimeFormat(Created,"HH:MM")#</td>
					   <td>#OfficerFirstName# #OfficerLastName#</td>
					   <td>#OutputQueryString#</td>
					   <td><cfif #st# eq "Not available"><font color="FF0000"></cfif>#st#</td>
					   <td>
						   <cfif #st# eq "Not available">
						   <button style="width:120px" name="Write" class="button10s" onClick="javascript:extract('#controlid#','#outputQueryString#')">
						   Generate
					    	&nbsp;<img align="absmiddle" src="#SESSION.root#/images/dataset_prepare.gif" border="0">
						   </button>
						   <cfelse>
						   <button style="width:120px" name="Inquiry" class="button10s" onClick="javascript:facttable('#outputid#','#variablename#','#st#')">
						   Inquiry
						   	&nbsp;<img align="absmiddle" src="#SESSION.root#/images/dataset.gif" border="0">
						   </button>
						   </cfif>
					   </td>
					</tr>
					<tr><td colspan="7" bgcolor="e4e4e4"></td></tr>
				
				</cfoutput>	
				
				</table>
		
		</td>
		</tr>
		</table>
		</td></tr>
		</table>
		
	</cffunction>
	
</cfcomponent>	