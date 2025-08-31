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
<cfquery name="Program" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM    Program P, ProgramPeriod Pe, ProgramIndicator PI, Ref_Indicator R
	WHERE   PI.TargetId    = '#URL.TargetId#'
	AND     PI.ProgramCode   = Pe.ProgramCode
	AND     PI.Period        = Pe.Period
	AND     Pe.ProgramCode   = P.ProgramCode
	AND    PI.IndicatorCode = R.IndicatorCode
</cfquery>

<cfquery name="Parameter" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMission
	WHERE   Mission = '#Program.Mission#'
</cfquery>	

<cfquery name="Param" 
datasource="AppsProgram"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Parameter	
</cfquery>	

<cfquery name="Org" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Organization
	WHERE   OrgUnit = '#Program.OrgUnit#' 
</cfquery>

<cfquery name="Audit" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Audit
	WHERE   AuditId = '#URL.AuditId#' 
</cfquery>

<cfquery name="Target" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramIndicatorTarget
	WHERE   SubPeriod = '#Audit.SubPeriod#' 
	AND     Targetid = '#URL.TargetId#'
</cfquery>

<cfquery name="AuditValue" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    ProgramIndicatorAudit
	WHERE   AuditId = '#URL.AuditId#' 
	AND     Targetid = '#URL.TargetId#'
</cfquery>

<cfoutput>

<cfparam name="URL.Print" default="0">

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

	<cfif url.print eq "1">

		<tr class="noprint"><td align="center"><input type="button" value="Close" name="Close" onClick="window.close()"class="button10g"></td></tr>

	</cfif>
	 
	<tr>
	   <td height="24" class="labellarge">#Program.ProgramName#  #Org.OrgUnitName#</td>
	</tr>

	<tr><td style="padding:10px">

	<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<tr>
	   <td class="labelit" width="20%">Indicator:</td>
	   <td class="labelmedium">#Program.IndicatorDescription#</td>
	</tr>
	
	<tr><td colspan="2" bgcolor="d8d8d8"></td></tr>
	
	<tr>
	   <td class="labelit" width="20%">Explanation:</td>
	   <td>
		   <table width="100%" cellspacing="0" cellpadding="0">
		   <tr>
		   <td class="labelmedium">#Program.IndicatorMemo#</td>	  
		   </tr>
		   </table>
	   </td>
	</tr>
	  
	<cfif Program.LocationCode neq "">  
	<tr><td colspan="2" bgcolor="d8d8d8"></td></tr>
	<tr>
	   <td class="labelit">Location:</td>
	   <td>#Program.LocationCode#</td>
	</tr>
	</cfif>
	<tr><td colspan="2" bgcolor="d8d8d8"></td></tr>
	<tr>
	   <td class="labelit">Measurement date:</td>
	   <td>#DateFormat(Audit.AuditDate,CLIENT.DateFormatShow)#</td>
	</tr>
	<tr><td colspan="2" bgcolor="d8d8d8"></td></tr>
	
	<!--- audt --->
	
	  <cfif Target.TargetValue neq "" and AuditValue.AuditStatus neq "0">
	    <cfif Program.TargetDirection eq "Up">
		
		<cfif AuditValue.AuditTargetValue lt Target.TargetValue>
		
			  <cfset color = "FF8080">
			<cfelse>
			  <cfset color = "DDFFDD">
		    </cfif>
			
		<cfelse>
		
		   <cfif AuditValue.AuditTargetValue lt Target.TargetValue>
			  <cfset color = "DDFFDD">
			<cfelse>
			  <cfset color = "FF8080">
		    </cfif>
			
		</cfif>
		
	  <cfelse> 
	  
	  	<cfset color = "white">	
	  
	  </cfif>
	  
	<tr>
	   <td class="labelit">Target:</td>
	   <td class="labelit">
	   
	   <cfset p = "">
		<cfif Program.IndicatorPrecision gt 0>
		  	<cfset p = ".">
		</cfif>
		<cfloop index="i" from="1" to="#Program.IndicatorPrecision#" step="1">
		  <cfset p = #p#&"_">
		</cfloop> 
	   
	    <cfif Target.TargetValue neq "">
		    <cfif Program.IndicatorType eq "0001">
				   <b>#numberFormat(Target.TargetValue,"__,__#p#")#</b>
			<cfelse>
				   <b>#numberFormat(Target.TargetValue*100,"__,__._")#%</b>
		 	</cfif>
		</cfif>
		      
	   </td>
	</tr>  
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<cfloop query="AuditValue">
	
	<tr>
	   <td height="20">Measurement 
	   
	   <cfif source eq "manual">
	    <b>#Parameter.IndicatorLabelManual#:</b>
	   <cfelse>
	   	<b>#auditvalue.source#:</b>
	   </cfif>
		</td>
	   <td bgcolor="#color#">
	   
	   <cfset p = "">
		<cfif Program.IndicatorPrecision gt 0>
		  	<cfset p = ".">
		</cfif>
		<cfloop index="i" from="1" to="#Program.IndicatorPrecision#" step="1">
		  <cfset p = "#p#_">
		</cfloop> 
		
		<cfif #AuditValue.AuditTargetValue# neq "">
	   
		    <cfif Program.IndicatorType eq "0001">
				  <cfif #AuditValue.AuditStatus# eq "0">
				  <font color="FF8080">&nbsp;[not submitted]</font>
				  <cfelse>
				   <b>&nbsp;#numberFormat(AuditValue.AuditTargetValue,"__,__#p#")#</b>
				  </cfif>
		    <cfelse>
				<cfif #AuditValue.AuditStatus# eq "0">
				<font color="FF8080">&nbsp;[not submitted]</font>
		    	<cfelse>&nbsp;
				 <b>#numberFormat(AuditValue.AuditTargetValue*100,"__,__._")#%</b>
				 &nbsp;
				 [#numberFormat(AuditValue.AuditTargetCount,"__,__")# /
				 #numberFormat(AuditValue.AuditTargetBase,"__,__")# ]
				</cfif>  
			</cfif>
		
		</cfif>
		
		&nbsp;#Program.IndicatorUoM#
	      
	   </td>
	</tr>
	
	<cfif currentrow eq recordcount>
	
	<tr>
	   <td colspan="2">
						   
			    <cf_filelibraryN
					DocumentPath="#Param.DocumentLibrary#"
					SubDirectory="#Org.OrgUnit#_#Program.IndicatorCode#_#AuditValue.AuditId#" 
					Filter=""
					Box="audit1"
					Insert="no"
					Remove="no"
					width="100%"
					Highlight="no"
					Listing="yes">
						  				   
		</td>
	</tr>
	
	</cfif>
	
	</cfloop>
	
	</table>
	
	</td></tr>
	
</table>

</cfoutput>

