<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfoutput>

<cfset op = Line.Operational>

<cfif master eq "0">
	<!--- prevent any changes on non production --->
	<cfset op = "1">	
</cfif>

<!--- ---------------------------------------------------------------- --->
<!--- determine of report workflow is enabled for this report (module) --->
<!--- ---------------------------------------------------------------- --->

<cfquery name="Workflow" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *
	FROM      Ref_EntityClassPublish
	WHERE     EntityCode = 'SysReport' 
	AND       EntityClass = '#Line.SystemModule#' 
 </cfquery>

<cfset direxist = "0">

<cfif Line.reportPath neq "">

		<cfif DirectoryExists("#rootpath#/#Line.reportPath#")>
	    	<cfset direxist = "1">			
		</cfif>		  
	
</cfif>

<script language="JavaScript">

	function dbscript() {
	     ptoken.open("DatabaseExport.cfm?id=<cfoutput>#URL.ID#</cfoutput>&mode=Export","sql","width=800, height=800, toolbar=no, scrollbars=no, resizable=no")
	}
	
	function dbreplica() {
	     ptoken.open("DatabaseExport.cfm?id=<cfoutput>#URL.ID#</cfoutput>&mode=Replica","sql","width=800, height=800, toolbar=no, scrollbars=no, resizable=no")
	}	
	
	function emailrep() {
		ptoken.open("#SESSION.root#/Tools/Mail/Mail.cfm?ID1=Export files for: #Line.FunctionName#&Source=ReportConfig&Sourceid=#URL.ID#","blank", "width=800, height=600, status=yes, toolbar=no, scrollbars=no, resizable=no");
	}

</script>

<cfform action="RecordSubmit.cfm?ID=#URL.ID#" 
	  method="POST" 
	  name="entry" 
	  id="entry"
	  style="height:96%"
	  onSubmit="javascript:check()">
	  
<table width="100%" height="99%" align="center">

<tr>		
 <td height="35" style="padding-right:10px;padding-left:15px">
		 		 		 			  
	  	<table width="100%" class="formspacing">
	  
		 <input type="hidden" name="pass" id="pass" value="#client.reportview#" required="No" visible="Yes" enabled="Yes">

		 <tr>
		 
		 	<td width="80%" style="font-weight:200;font-size:27px" class="labelmedium">
						 
			 <!--- check if there is a pending workflow object for this report --->
			 
			 <cfinvoke component = "Service.EntityAction.Workflow"  
			   method            = "wfPending" 
			   entitycode        = "SysReport" 
			   ObjectKeyValue4   = "#Line.ControlId#"
			   returnvariable    = "wfstatus">	
			 
			 <cfif "0" eq Line.Operational>
			 
				 &nbsp;<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/workinprogress.gif" 
				 alt="Under development" 
				 border="0" 
				 align="absmiddle">
				 Under Development			 			 
			 
			 <cfelseif wfstatus eq "Yes">			 
			      &nbsp;<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/light_yellow.gif" alt="Deployed" border="0" align="absmiddle">	
			     This report is being reviewed 				 
			 <cfelse>
			 &nbsp;<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/light_green2.gif" alt="Deployed" border="0" align="absmiddle">
			 This report is deployed
			 </cfif>
			 &nbsp;
			 </td>
		   
			
			<cfif direxist eq "1" and Line.Operational eq "1">
			
				<td>	
					<button class="button10g" type="button" style="width:150;height:26" name="aboutreport1" id="aboutreport1" onclick="javascript:dbscript()">						
						Definition
					</button>
				</td>
			
				<td>
						<!--- Only when operational is 1 then I am allowing to clone the report, which means that the
						report is currently operating, September 04, 2010 --->
						<button class="button10g" type="button" style="width:150;height:26;" name="aboutreport3" id="aboutreport3" onclick="javascript:dbreplica()">
							<img src="#SESSION.root#/Images/deploy.gif" align="absmiddle" alt="" border="0">
							Replica Script 
						</button>
				</td>
			
			
				<td style="padding-left:10px">			
				<button class="button10g" type="button" style="width:160;height:26" name="aboutreport2" id="aboutreport2" onclick="javascript:emailrep()">
				<img src="#SESSION.root#/Images/export2.gif" align="absmiddle" alt="" border="0">
					Mail Definition Files
				</button>
				</td>

			</cfif>
						
			
			
		 </tr>
		 </table>
		
	 </td>
	 
	 </tr>
	 
	 <cfinclude template="RecordDeployment.cfm">
	 
	 <tr><td class="linedotted"></td></tr>

    <cfif Find("1", "#CLIENT.reportView#")>
	     <cfset s = "show">
	     <cfset cl = "regular">
	<cfelse>
		 <cfset s = "show">
	     <cfset cl = "regular">
	</cfif>
		
	<tr id="1" class="#cl#"><td colspan="2">
	
</td></tr>
 	
<tr><tr><td align="center" height="100%" style="padding-left:10px;padding-right:10px">	
    
		<cfinclude template="RecordEditFieldsTab.cfm">			
		
	</td>
</tr>		 
	 		 
</table> 	
 
</cfform>	
 	
</cfoutput>	 