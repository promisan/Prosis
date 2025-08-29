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
<cfquery name="Parameter" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Parameter
</cfquery>

<cf_tl id="Undefined" var="1">
<cfset vUndefined="#lt_text#">

<cf_tl id="not submitted" var="1">
<cfset vNotSubmitted="#lt_text#">

<cf_tl id="Count" var="1">
<cfset vCount="#lt_text#">

<cf_tl id="Base" var="1">
<cfset vBase="#lt_text#">

<cf_tl id="Remarks" var="1">
<cfset vRemarks="#lt_text#">

<cf_tl id="Ratio" var="1">
<cfset vRatio="#lt_text#">

<cfoutput>
<script>

function historylog(id) {
	
	se = document.getElementById("blog"+id)
	
	if (se.className == "regular") {	
		se.className = "hide"
	} else {
	   	se.className = "regular"		
		ColdFusion.navigate('#SESSION.root#/programrem/application/indicator/audit/IndicatorAuditLog.cfm?id='+id,'log'+id)
	}

	}

</script>
</cfoutput>


<cfoutput query="Indicator" group="ProgramCode">

<cfif url.mode eq "Submission" or object.ObjectKeyValue4 neq "">
	<tr>
		<td bgcolor="e3e3e3" colspan="9" height="28" align="center" class="labelit">
			<font face="Calibri" size="3" color="000000"><b>#ProgramName#
		</td>
	</tr>
<tr><td colspan="9" class="line" height="1"></td></tr>
</cfif>

<cfoutput>

	<!--- define period --->
	
			
	<cfif Indicator.ZeroBase eq "1">
		<cfset rat = Audit.ZeroBaseRatio>
	<cfelse>
		<cfset rat = 1>
	</cfif>
	
	<cfquery name="Target" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    *, TargetValue*#rat# as TargetValue
	FROM      dbo.#SESSION.acc#Indicator_#FileNo#
	WHERE     IndicatorCode = '#IndicatorCode#'
	   AND    ProgramCode   = '#ProgramCode#'
	   AND    LocationCode  = '#Loc#'
	   AND    SubPeriod     = '#Audit.Subperiod#' 
	</cfquery>   	
	
	<cfif Target.TargetId eq "">
		<cfoutput>
			<cf_tl id="Problem with indicator setup" var="1">
			<cfset vMsg1=#lt_text#>
			<cf_tl id="please contact your administrator" var="1">
			<cfset vMsg2=#lt_text#>
			
			<cf_message text="#vMsg1#, #vMsg2#" return="no">
		</cfoutput>
		<cfabort>
	
	</cfif>
	
	<cfquery name="AuditValue" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   ProgramIndicatorAudit P
	   WHERE  TargetId = '#Target.TargetId#'
	   AND    AuditId  = '#URL.AuditId#'
	   AND    Source   = 'Manual'
	</cfquery>
			
	<cfset p = "">
	<cfif Indicator.IndicatorPrecision gt 0>
		<cfset p = ".">
	</cfif>
	
	<cfloop index="i" from="1" to="#Indicator.IndicatorPrecision#" step="1">
		 <cfset p = #p#&"_">
	</cfloop> 
			
	<cfif URL.Mode neq "Edit">
	 			
		<tr>
		  <td align="center">		  
		  #CurrentRow#.</td>
		  <td>
		  
			<img src="#SESSION.root#/Images/arrowright.gif" alt="Show graph" 
			id="#lor#_#CurrentRow#Exp" border="0" class="show" 
			align="absmiddle" style="cursor: pointer;" height="9" width="9"
			onClick="ppidrill('#lor#_#CurrentRow#','show','#Target.TargetId#')">
			
			<img src="#SESSION.root#/Images/arrowdown.gif" 
			id="#lor#_#CurrentRow#Min" alt="" border="0" 
			align="absmiddle" class="hide" style="cursor: pointer;" height="9" width="9"
			onClick="ppidrill('#lor#_#CurrentRow#','hide','#Target.TargetId#')">
	
		  </td>
		  
		 		  
		  <td class="labelit"><a href="javascript:ppidrill('#lor#_#CurrentRow#','hide','#Target.TargetId#')">#IndicatorDescription#</a>
		  
		  <cfif TargetDirection eq "up">
				<img src="#SESSION.root#/Images/arrow-up.gif" align="absmiddle" alt="#IndicatorCode#">		
			<cfelseif TargetDirection eq "down">
				<img src="#SESSION.root#/Images/arrow-down.gif" align="absmiddle" alt="#IndicatorCode#">		
			<cfelse>
				<img src="#SESSION.root#/Images/arrow-steady.gif" align="absmiddle" alt="#IndicatorCode#">					
			</cfif>		
		  
		  </td>
		 
		  
		  <!--- target --->
		  
		  <td align="left" class="regular">
		     <cfif Target.TargetValue eq ""><font color="FAD5CB">#vUndefined#</font>
			 <cfelse>
				 <cfif Indicator.IndicatorType eq "0001">
				 #numberFormat(Target.TargetValue,"__,__#p#")#
				 <cfelse>
				 #numberFormat(Target.TargetValue*100,"__,__._")#%
				 </cfif>
			 </cfif>
		  </td>
		 		 		   
		  <!--- audt --->
		  <cfif Target.TargetValue neq "">
		  
		    <cfif TargetDirection eq "Up">
			  	<cfif AuditValue.AuditTargetValue gte Target.TargetValue>
				  <cfset color = "DDFFDD">
				<cfelseif AuditValue.AuditTargetValue gte Target.TargetValue-(Target.TargetValue*TargetRange/100)>
				  <cfset color = "FFAC59">  
				<cfelse>
				  <cfset color = "FF8080">
			    </cfif>
			<cfelse>
			   <cfif AuditValue.AuditTargetValue lte Target.TargetValue>
				  <cfset color = "DDFFDD">
			    <cfelseif AuditValue.AuditTargetValue lte Target.TargetValue+(Target.TargetValue*TargetRange/100)>
				  <cfset color = "FFAC59">  
				<cfelse>
				  <cfset color = "FF8080">
			    </cfif>
			</cfif>
		  </cfif>
		  
		  <cfif Indicator.IndicatorType eq "0001">
		 
			  <cfif AuditValue.AuditStatus eq "0" or AuditValue.AuditStatus eq "">
				  <td colspan="3" align="center"><font color="FF0000">#vNotSubmitted#</font></td> 
			  <cfelse>
				  <td colspan="3"> 
				   <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="gray" class="formpadding"><tr>
				    <td colspan="3" bgcolor="#color#" align="left" style="padding-left:4px">
					  <cfif Indicator.NameCounter neq "">#Indicator.NameCounter#<cfelse>#vCount#:</cfif>
				      <b>#numberFormat(AuditValue.AuditTargetValue,"__,__#p#")#</b></td>
				    </tr>
				   </table>	
			      </td>
			  </cfif>
			  
		  <cfelse>
		  
		  	<cfif AuditValue.AuditStatus eq "0" or AuditValue.AuditStatus eq "">
				  <td colspan="3" width="100" align="center"><font color="FF8080">#vNotSubmitted#</font></td>
			<cfelse>
				  <td colspan="3">
				  <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="808080" class="formpadding"><tr>
				  <td bgcolor="#color#"><cfif Indicator.NameCounter neq "">#Indicator.NameCounter#<cfelse>#vCount#</cfif>:</td>
				  <td bgcolor="#color#">#numberFormat(AuditValue.AuditTargetCount,"__,__#p#")#</td>
				  <td bgcolor="#color#"><cfif Indicator.NameBase neq "">#Indicator.NameBase#<cfelse>#vBase#</cfif>:</td>
				  <td bgcolor="#color#">#numberFormat(AuditValue.AuditTargetBase,"__,__#p#")#</td>
				  <td bgcolor="#color#">#vRatio#:</td>
				  <td bgcolor="#color#" style="padding-left:4px">
				  <cfif AuditValue.AuditTargetValue neq "">
				      #numberFormat(AuditValue.AuditTargetValue*100,"__,__.#p#")#%
				  </cfif>
				  </b></td>
				  </tr></table>	
				  </td>
			</cfif>  
		  </cfif>
		  <td><!--- #IndicatorUoM# ---></td>
		</tr>
						
		<cfif AuditValue.AuditStatus neq "0">
		
		<tr>
		<td></td>
		<td colspan="7" align="center" bgcolor="ffffff">		
			<cfif AuditValue.OfficerFirstName neq "" or AuditValue.OfficerLastName neq "">
			
			<table width="100%" cellspacing="0" cellpadding="0" align="center">			
			<tr class="labelmedium">
			<td width="25" height="20" align="center">
			<img src="#SESSION.root#/Images/history.png" alt="Activity Log" 
					id="log#currentRow#Exp" border="0" class="regular" 
					align="absmiddle" style="cursor: pointer;" height="12" width="12"
					onClick="historylog('#auditvalue.measurementid#')">
			</td>			
			<td class="labelmedium">
				<a href="javascript:historylog('#auditvalue.measurementid#')"><cf_tl id="Last submitted"></a>
			</td>
			<td>				
			    <font color="gray">#AuditValue.OfficerFirstName# #AuditValue.OfficerLastName#</font> <cf_tl id="on">:
				<font color="gray">#DateFormat(AuditValue.Created, CLIENT.DateFormatShow)# #TimeFormat(AuditValue.Created, "HH:MM")#				
			</td>
			
			</tr>
			<tr id="blog#auditvalue.measurementid#" class="hide">
				<td colspan="5"><cfdiv id="log#auditvalue.measurementid#"></td>
			</tr>
			
			</table>
			</cfif>		
		</td>
		
		</tr>	
		
		</cfif>

		<cf_filelibraryCheck
		   	DocumentURL  = "#Parameter.DocumentURL#"
			DocumentPath = "#Parameter.DocumentLibrary#"
			SubDirectory = "#orgunit#_#indicatorcode#_#AuditValue.AuditId#" 
			Filter       = "">
					
		<cfif files gte "1">	
					
		<tr>
		   <td></td>
		   <td></td>
    	   <td colspan="6">
		   		     					   
			    <cf_filelibraryN
					DocumentPath = "#Parameter.DocumentLibrary#"
					SubDirectory = "#orgunit#_#indicatorcode#_#AuditValue.AuditId#" 
					Filter       = ""
					Box          = "audit#currentrow#"
					Insert       = "no"
					Remove       = "no"
					LoadScript   = "no"
					width        = "100%"
					Highlight    = "no"
					Listing      = "yes">
					  				   
			</td>
		</tr>	
		
		</cfif>		
				
		<tr id="#lor#_#CurrentRow#" class="hide"><td colspan="9">
	       <iframe name="i#lor#_#CurrentRow#" 
		   id="i#lor#_#CurrentRow#" 
		   width="100%" 
		   height="#gh+40#" 
		   scrolling="no" 
		   frameborder="0"></iframe>
		   
		</td></tr>		
		
		<cfif currentRow neq Indicator.recordcount>
		
		<tr><td colspan="9" class="line"></td></tr>
		
		</cfif>	
			
	<cfelse>
		
	  <cfinclude template="IndicatorAuditDetailInput.cfm"> 
		  
	</cfif>	
	
</cfoutput>	
	
</cfoutput>



