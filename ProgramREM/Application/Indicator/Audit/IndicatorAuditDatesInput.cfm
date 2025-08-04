<!--
    Copyright © 2025 Promisan

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

<cf_screenTop height="100%" jquery="Yes" banner="gray" html="No" layout="webapp" label="Maintain Indicators (Batch Entry)" band="No" scroll="no">

<cf_tl id="Value" var="1">
<cfset vValue=lt_text>

<cfoutput>

<cfparam name="URL.Mode" default="Edit">
<cfparam name="URL.Layout" default="">
<cfparam name="gh" default="240">

<script language="JavaScript">

    function hideN(ref,chk)	{
		document.getElementById("TargetValue"+ref).className = chk
		document.getElementById("TargetValue"+ref).value = ""
	}					
	  	
	function hideR(ref,chk) {
		document.getElementById("Target"+ref).className = chk
		document.getElementById("TargetCount"+ref).value = ""
		document.getElementById("TargetBase"+ref).value = ""
		document.getElementById("TargetValue"+ref).value = ""
	}		
		
	function div(cnt,base,ratio) {

	x = document.getElementById(cnt)
	y = document.getElementById(base)
	z = document.getElementById(ratio)
	if (y.value != "0") {
        z.value = " " + Math.round((x.value/y.value) * 1000)/10 + "%" }
		else
		{
		z.value = "NaN"}

	}

</script>

</cfoutput>

<!--- JavaScript program form calls (in Tools tag directory)--->

<cf_divscroll>

<cfform action="IndicatorAuditDatesSubmit.cfm" method="POST" name="TargetEntry">

<cfoutput>
	<input type="hidden" name="TargetId" id="TargetId" value="#URL.Targetid#">
	<input type="hidden" name="Period" id="Period" value="#URL.Period#">
</cfoutput>

<cfquery name="Target"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT   PI.*, 
	         Pe.OrgUnit, 
			 P.ProgramName, 
			 R.IndicatorDescription, 
			 0 as TargetValue, 
			 R.IndicatorType
	FROM     ProgramIndicator PI, 
	         Ref_Indicator R,
			 ProgramPeriod Pe, 
			 Program P
	WHERE    PI.IndicatorCode = R.IndicatorCode
	AND      PI.ProgramCode = P.ProgramCode
	AND      PI.ProgramCode = Pe.ProgramCode
	AND      PI.Period = Pe.Period
	AND      TargetId = '#URL.TargetId#'
</cfquery>

<cfquery name="Org"
datasource="AppsOrganization"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Organization 
	WHERE    OrgUnit = '#Target.OrgUnit#'
</cfquery>

<cfquery name="Indicator"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_Indicator R
	WHERE    R.IndicatorCode = '#Target.IndicatorCode#'
</cfquery>

<cfset p = "">
<cfif Indicator.IndicatorPrecision gt 0>
	<cfset p = ".">
</cfif>

<cfloop index="i" from="1" to="#Indicator.IndicatorPrecision#" step="1">
    <cfset p = #p#&"_">
</cfloop> 

<cfquery name="Period"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
	SELECT    Period, DateEffective as Start, DateExpiration EndDate
	FROM      Ref_Period
	WHERE     Period = '#URL.Period#'
</cfquery>

<cfquery name="Audit"
datasource="AppsProgram"
username="#SESSION.login#"
password="#SESSION.dbpw#">
   SELECT   *
     FROM   Ref_Audit
    WHERE   Period = '#URL.Period#'
	  AND   AuditDate <= getDate()+15
   ORDER BY AuditDate 
</cfquery>

<table width="100%" border="0">
<tr><td>

<cfoutput>
	<input type="hidden" name="date" id="date" value="#Audit.recordcount#">
</cfoutput>

	<table width="100%" border="0" cellspacing="0" cellpadding="0" frame="all">
	  
	<tr>
	<td width="100%" colspan="2">
	
	   <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	   
	      <cfset lor = 0>
		  
		  <cfoutput>
		  	  
			<tr>
			  <td ></td>
			  <td><b>#Org.OrgUnitName# #Target.IndicatorDescription#</b></td>
			  <td align="center"><b>&nbsp;
			     <cfif #Target.TargetValue# eq ""><font color="FF8080">Undefined</font>
				 <cfelse>
					 <cfif #Indicator.IndicatorType# eq "0001">
					 #numberFormat(Target.TargetValue,"__,__#p#")#
					 <cfelse>
					 #numberFormat(Target.TargetValue*100,"__,__._")#%
					 </cfif>
				 </cfif>
			  </td>
			 			 
			  <td colspan="1"><b>#Indicator.IndicatorUoM#</b></td>
			
			</tr>
			<tr>
			  <td align="center"></td>
			  <td colspan="3">#Indicator.IndicatorMemo#			  
			</tr>			
					
			<tr><td colspan="4"></td></tr>
					
			 <cfquery name="Last" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM   ProgramIndicatorAudit 
				WHERE  AuditTargetValue > 0
				AND    TargetId = '#URL.TargetId#'
				ORDER BY Created DESC
			</cfquery>
				
			<cfif Last.recordcount eq "0">
			
			<tr>
			    <td colspan="4" bgcolor="ffffcf" height="20" style="padding-left:5px">
				<font color="67665A"><b><cf_tl id="Measurements have not been updated yet" class="Message">.</b>
				</td>
			</tr>
			
			<cfelse>
						
				<tr>
				<td colspan="4" bgcolor="ffffcf" height="20" style="padding-left:20px">
				<cf_tl id="Last updated">: <b>#Last.OfficerfirstName# #Last.OfficerlastName#</b> 
				on #DateFormat(Last.Created, CLIENT.DateFormatShow)# #TimeFormat(Last.Created, "HH:MM")#
				</td>
				</tr>
			
			</cfif>	
			
			<tr bgcolor="f4f4f4"><td height="2" colspan="4"></td></tr>		
			<tr><td height="4"></td></tr>	
									
		  </cfoutput>	
		  
		  <cfquery name="DefaultEntries" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ProgramIndicatorAudit 
				(TargetId, AuditId, Source, AuditTargetValue)
				SELECT   '#Target.TargetId#', AuditId, 'Manual',''
				      FROM    Ref_Audit 
				WHERE  AuditId NOT IN (SELECT AuditId 
				                       FROM   ProgramIndicatorAudit 
									   WHERE  TargetId = '#Target.TargetId#') 
				</cfquery>
	
		  <cf_tl id="Counted" var="1">
		  <cfset vCounted=#lt_text#>
		  	  
		  <cf_tl id="Base" var="1">
		  <cfset vBase=#lt_text#>
	
		  <cf_tl id="Ratio" var="1">
		  <cfset vRatio=#lt_text#>
	
		  <cf_tl id="Measurement" var="1">
		  <cfset vMeasurement=#lt_text#>
	
		  <cfoutput query="Audit">
		  
		   <tr><td colspan="4">
		   <table width="97%" align="center">
		  
		   <tr><td width="7%">Date:</td>
		       <td width="12%"><b>#dateFormat(Audit.AuditDate, CLIENT.DateFormatShow)#</b></td>	
			   	  	
			  <cfquery name="AuditValue" 
			 datasource="AppsProgram" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			   SELECT AuditTargetValue, AuditTargetCount,AuditTargetBase,AuditStatus,AuditRemarks
			   FROM   ProgramIndicatorAudit P
			   WHERE  TargetId = '#Target.TargetId#'
			   AND    AuditId  = '#Audit.AuditId#'
			   AND    Source   = 'Manual'
			 </cfquery>	 		
			
				<cfinvoke component="Service.Access"
			Method         = "indicator"
			OrgUnit        = "#Target.OrgUnit#"
			Indicator      = "'#Target.IndicatorCode#'"
			Role           = "ProgramAuditor"
			ReturnVariable = "AccessEdit">
					 
			<cfif accessEdit eq "NONE" or accessEdit eq "READ"> 			    
				<cfset access = "0">					
			<cfelse>			
				<cfset access = "1">		
			</cfif>
			
			<!--- if the auditstatus is set to 2 you can not any longer change the value --->
			
			<cfif AuditValue.AuditStatus eq "2">
		    	<cfset access = "0">
			</cfif>
				
			<cfif Access eq "0">
			
		   		<input type="Hidden" name="Access_#lor#_#CurrentRow#" id="Access_#lor#_#CurrentRow#" value="0">
				
				<cfif Indicator.IndicatorType eq "0001">
				
				  <td width="10%">#vCounted#:</td>
				  <td colspan="5">
					 #numberFormat(AuditValue.AuditTargetValue,"__,__#p#")#
			   	  </td>
			   		  	
				<cfelse>
				
			      <td width="10%">#vCounted#:</td>
				  <td width="10%" align="right">
			     	#numberFormat(AuditValue.AuditTargetCount,"__,__#p#")#
			      </td>
			   
			      <td width="10%" align="right">#vBase#:</td>
				  <td width="10%" align="right">
				    #numberFormat(AuditValue.AuditTargetBase,"__,__#p#")#
			      </td>
			  
			      <td width="10%" align="right">#vRatio#:</td>
				  <td width="10%" align="right">
				   #numberFormat(AuditValue.AuditTargetValue*100,"__,__._")#%
			      </td>
			    </tr>
				
				</cfif>
				
				<tr>
			      <td></td><td colspan="4"><td>
				      #AuditValue.AuditRemarks#
			      </td>
	            </tr>
				
				<tr><td colspan="10" bgcolor="e5e5e5"></td></tr>
			
				<cfelse>
		
		    	<input type="Hidden" name="Access_#lor#_#CurrentRow#" id="Access_#lor#_#CurrentRow#" value="1">
				
				<cfif AuditValue.AuditStatus neq "1">
						   <cfset cl = "hide">
						<cfelse>
						   <cfset cl = "amount">
						</cfif>      
								 			  
				<cfif Indicator.IndicatorType eq "0001">
					    <td width="90" align="right">#vMeasurement#:&nbsp;</td>
					    <td colspan="2">
						<table align="left" cellspacing="0" cellpadding="0" class="formpadding"><tr>
						    <td>&nbsp;&nbsp;&nbsp;</td>
							<cfif AuditValue.AuditStatus eq "0">
							<cfset color = "FF8080">
							<cfelse>
							<cfset color = "">
							</cfif>
							<td bgcolor="#color#">															
							<input type="radio" name="Status_#lor#_#CurrentRow#" value="0" tabindex="0"
							<cfif AuditValue.AuditStatus eq "0">checked</cfif>
							onclick="javascript: hideN('_#lor#_#CurrentRow#', 'hide')"> 
						    <td>
							
							<td>						
							<cf_UItooltip tooltip="Select if Information is not available (yet)">
							N/Avail.
							</cf_UItooltip>
							
							</td>
							<cfif #AuditValue.AuditStatus# eq "9">
							<cfset color = "AFCFE0">
							<cfelse>
							<cfset color = "">
							</cfif>
							<td bgcolor="#color#">
						<input type="radio" name="Status_#lor#_#CurrentRow#" value="9" tabindex="0"
						<cfif #AuditValue.AuditStatus# eq "9">checked</cfif>
						onclick="javascript: hideN('_#lor#_#CurrentRow#', 'hide')"> 
						    </td>
							
							<td>	
							<cf_UItooltip tooltip="Select if Information is not applicable">
						    N/Appl.	
							</cf_UItooltip>
							</td>
							<td>
						<input type="radio" name="Status_#lor#_#CurrentRow#" value="1" tabindex="9999"
						<cfif #AuditValue.AuditStatus# eq "1">checked</cfif>
						onclick="javascript: hideN('_#lor#_#CurrentRow#', 'amount')"> 
						     </td>
							 <td>
							#vValue#							
											
					   	<cfinput type="Text"
						       name="TargetValue_#lor#_#CurrentRow#"
						       value="#AuditValue.AuditTargetValue#"
						       message="Please enter a valid target"
						       validate="float"
						       required="No"
						       visible="Yes"
							   class="#cl#"
						       size="8"
						       maxlength="12">
							   
						</table>	   
								
					    </td>
					  										  	
				<cfelse>
																
						<td colspan="3">
						<table align="left" cellspacing="0" cellpadding="0"><tr>
						    <td>&nbsp;&nbsp;&nbsp;</td>
							<cfif #AuditValue.AuditStatus# eq "0">
							<cfset color = "FF8080">
							<cfelse>
							<cfset color = "">
							</cfif>
							<td bgcolor="#color#">
							<input type="radio" name="Status_#lor#_#CurrentRow#" value="0" tabindex="9999" 
							<cfif #AuditValue.AuditStatus# eq "0">checked</cfif>
							onclick="javascript: hideR('_#lor#_#CurrentRow#', 'hide')"> 
							</td>
							<td bgcolor="#color#">
							<a href="##" title="Information is not available" tabindex="9999" >N/A</a>
							&nbsp;
							</td>
							<cfif AuditValue.AuditStatus eq "9">
							<cfset color = "AFCFE0">
							<cfelse>
							<cfset color = "">
							</cfif>
							<td bgcolor="#color#">
							<input type="radio" name="Status_#lor#_#CurrentRow#" value="9" tabindex="0" 
							<cfif AuditValue.AuditStatus eq "9">checked</cfif>
							onclick="javascript: hideR('_#lor#_#CurrentRow#', 'hide')"> 
							</td>
							<td bgcolor="#color#">
							<a href="##" title="Information is not applicable" tabindex="9999" >N/Ap</a>
							&nbsp;
							</td>
							<td>
							<input type="radio" name="Status_#lor#_#CurrentRow#" value="1" tabindex="9999"
							<cfif AuditValue.AuditStatus eq "1">checked</cfif>
							onclick="javascript: hideR('_#lor#_#CurrentRow#', 'amount')"> 
							</td>
							<td id="Target_#lor#_#CurrentRow#" class="#cl#" tabindex="9999">
							    <table cellspacing="0" cellpadding="0">
								<tr>		      
								<td>&nbsp;&nbsp;#vCounted#:&nbsp;</td>
								<td>
						     	<cfinput type="Text" name="TargetCount_#lor#_#CurrentRow#" 
								  value="#AuditValue.AuditTargetCount#" 
								  message="Please enter a valid counted amount/number" 
								  validate="float" 
								  required="No" 
								  size="8" 
								  maxlength="8" 
								  onchange="javascript: div('TargetCount_#lor#_#CurrentRow#','TargetBase_#lor#_#CurrentRow#','TargetValue_#lor#_#CurrentRow#')"
								  class="amount">
								  
								</td>
						     	<td>&nbsp;&nbsp;#vBase#:&nbsp;</td>
								<td colspan="1">
							  	<cfinput type="Text" name="TargetBase_#lor#_#CurrentRow#" 
								 value="#AuditValue.AuditTargetBase#" message="Please enter a valid base amount/number" validate="float" 
								 onchange="javascript: div('TargetCount_#lor#_#CurrentRow#','TargetBase_#lor#_#CurrentRow#','TargetValue_#lor#_#CurrentRow#')"
								 required="No" size="8" maxlength="8" class="amount">
							    </td>
							  
								<td>&nbsp;&nbsp;#vRatio#:&nbsp;</td>
								<td>
							   	   	<input type="text" class="regular" name="TargetValue_#lor#_#CurrentRow#" 
									value="<cfif AuditValue.AuditTargetValue neq "">#numberFormat(AuditValue.AuditTargetValue*100,'__,__#p#')#%</cfif>" size="5" maxlength="8" 
									readonly style="font: text-align: center;" tabindex="9999"> 
									
							    </td>
							
							    </tr>
							    </table>
							</td>	
							</table>  
					  </td>	
								
						</cfif>
						
						<tr><td colspan="10" bgcolor="e5e5e5"></td></tr>
						
						<!---
														
						<tr>
					      <td>Remarks:</td><td colspan="5">
						  <input type="text" class="regular" name="Remarks_#lor#_#CurrentRow#" value="#AuditValue.AuditRemarks#" size="60" maxlength="80" class="regular" cols="70" rows="1">
					      </td>
						</tr>
						
						--->
											
		    </cfif>	
			
			  </table>
						</td></tr>	
						
						<tr><td height="4"></td></tr>
			   
		  </cfoutput>
		  
		  <tr><td colspan="4" class="line" height="1"></td></tr>
		  
		  <tr><td height="30" colspan="4" align="center">
			
				<cfinvoke component="Service.Access"
				Method="indicator"
				OrgUnit="#Target.OrgUnit#"
				Indicator="'#Target.IndicatorCode#'"
				Role="ProgramAuditor"
				ReturnVariable="Access">
						
				<cfif Access eq "EDIT" or Access eq "ALL">
					<cfoutput>
						<cf_tl id="Reset" var="1">
					    <input type="reset" name="Reset" value="#lt_text#" class="button10g">
						<cf_tl id="Save" var="1">					
					    <input type="submit" name="Submit" value="#lt_text#" class="button10g">
						<cf_tl id="Save & Close" var="1">					
					    <input type="submit" name="Close" value="#lt_text#" class="button10g">
					</cfoutput>
				</cfif>
		
			</td></tr>
	
	
	</TABLE>
	
	</td> </tr>
	
	</table>

</table>

</cfform>
</cf_divscroll>
