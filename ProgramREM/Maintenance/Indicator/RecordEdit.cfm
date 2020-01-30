
<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 

<cfquery name="IndicatorType" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_IndicatorType
</cfquery>

<cfquery name="Source" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_MeasureSource
WHERE Code != 'Manual'
</cfquery>
  
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM #CLIENT.LanPrefix#Ref_Indicator
WHERE IndicatorCode = '#URL.ID1#' 
</cfquery>

<cfquery name="GetSource" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_IndicatorSource
WHERE IndicatorCode = '#URL.ID1#' 
AND Source != 'Manual'
</cfquery>

<script language="JavaScript">

function recordclose() {
		window.close()
	}	
	
function ask() {
	if (confirm("Do you want to remove this Indicator?")) {	
	return true 	
	}	
	return false	
}	

function togglename(val) {
	  se = document.getElementsByName("base")
	  ch = document.getElementById("chart")
	  c = 0
	  while (se[c]) {
		  if (val == "0001") { 
		  	se[c].className = "hide" 			
			ch.className = "regular"
		  } else {
		    se[c].className = "regular"
			ch.className = "hide"
		  }	  
	  c++
	  }
	  	  
	}
	
  function measuresource(cls) {
		
	se = document.getElementById("source")
		
	if (cls == "external")
	   {se.className = "regularxl"}
	else
	   {se.className = "hide"}
	}
	
	function template(cls) {
		
	se = document.getElementById("template")
	
	if (cls == "1") {
	   se.className = "regularxl"
    } else {
	   se.className = "hide"
    }
	
	}            

</script>

<cfset l = "Edit Performance Indicator #get.IndicatorCode#">

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              label="#l#" 
			  banner="gray" 
			  layout="webapp" 
			  scroll="Yes"
			  jquery="Yes"
  			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm?mission=#url.mission#" name="dialog">
	
		
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	    <cfoutput>
		
		<tr><td></td></tr>
	  		
		<TR>
	    <td class="labelmedium" width="140">Display:<cf_space spaces="50"></td>
	    <TD>
			<table cellspacing="0" cellpadding="0">
			<tr>
			<td>
		  	   <cfinput type="text" name="IndicatorcodeDisplay" value="#get.IndicatorCode#" 
			      message="Please enter a display code" required="Yes" size="6" maxlength="6" class="regularxl">
			   <input type="hidden" name="IndicatorCode" value="#get.IndicatorCode#" size="20" maxlength="20"class="regular">    	   
		    </TD>
		    <TD style="padding-left:4px">About this indicator:</TD>
		    <TD>
			     <cf_helpfile 
					 code     = "Program" 
					 class    = "Indicator"
					 id       = "#get.IndicatorCode#"
					 name     = "#get.IndicatorDescription#"
					 display  = "Icon"
					 edit     = "1"
					 showText = "0">
			</TD>
			</TR>
			</table>
		</td>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Program Classiciation:</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <TR><TD>
		  
		   	   
			<cfquery name="Category" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ProgramCategory
			WHERE  (Parent is NULL or Parent = '')
			AND    Code IN (SELECT Category FROM Ref_ParameterMissionCategory 
			                WHERE  Mission = '#URL.Mission#')
			UNION
			<!--- level 1 --->
			SELECT *
			FROM   Ref_ProgramCategory
			WHERE  Parent IN (SELECT Code
			                  FROM    Ref_ProgramCategory
							  WHERE  (Parent is NULL or Parent = '')
							  AND     Code IN (SELECT Category 
							                   FROM   Ref_ParameterMissionCategory 
			                				   WHERE  Mission = '#URL.Mission#')
							)				   
				   
			
			ORDER BY CODE
			</cfquery>
			
			<cfif Category.recordcount eq "0">
			
			   <font color="FF0000">No [Program Classification] were enabled for this entity</font>		
			   
			<cfelse>
		   
			   <select name="ProgramCategory" class="regularxl">
			   
			   <cfloop query="Category">
			 
				   <option value="#Code#" <cfif get.ProgramCategory eq "#Code#">selected</cfif>> <cfif Parent neq "">&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
					   #Code# 
					   <cfif Len(#Description#) gt 38>
					   	#Left(Description, 38)#...
				    	<cfelse>
					    #Description#
				       </cfif>
				   </option>
				   
				    <cfquery name="Detail" 
						datasource="AppsProgram" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Ref_ProgramCategory
							WHERE  Parent = '#Code#'
					</cfquery>		
					
					<cfif Detail.recordcount neq "0">
						
						<cfloop query="Detail">
						 <option value="#Code#" <cfif get.ProgramCategory eq Code>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							   #Code# 
							   <cfif Len(Description) gt 38>
								   	#Left(Description, 38)#...
						       <cfelse>
								    #Description#
						       </cfif>
						</option>
						</cfloop>
					
					</cfif>
							   
				   </cfloop>
				   
				   </select>
		   
		   </cfif>
		   
		   </TD>
		   <td>&nbsp;</td>
		  </table>
		   
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
		<cf_LanguageInput
				TableCode       = "Ref_Indicator" 
				Mode            = "Edit"
				Name            = "IndicatorDescription"
				Value           = "#get.IndicatorDescription#"
				Key1Value       = "#get.IndicatorCode#"
				Type            = "Input"
				Required        = "Yes"
				Message         = "Please enter a description"
				MaxLength       = "80"
				Size            = "50"
				Class           = "regularxl">
		   </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Alternate description:</TD>
	    <TD class="labelmedium">
	  	   <cfinput type="text" name="IndicatorDescriptionAlternate" value="#get.IndicatorDescriptionAlternate#" 
		     size="70" maxlength="100" class="regularxl">
	    </TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium">UOM type:</TD>
	    <TD >
		   <select name="IndicatorType" onchange="togglename(this.value)" class="regularxl">
		   <cfloop query="IndicatorType">
		   	<option value="#Code#" <cfif get.IndicatorType eq "#Code#">selected</cfif>>#Description#</option>
		   </cfloop>
	    </TD>
		</TR>
		
			
		<tr>
		<td class="labelmedium">Counter:</td>
		<td>
		<table width="100%" cellspacing="0" cellpadding="0">
			<tr><td>
			  	<cfinput type="Text" name="NameCounter" value="#get.NameCounter#" required="No" size="20" maxlength="30" class="regularxl">
				</td>
				<cfif get.IndicatorType eq "0001">
				<cfset cl = "hide">
				<cfelse>
				<cfset cl = "labelmedium">
				</cfif>
				<td id="base" name="base" class="#cl#">Base:</td>
				<td id="base" name="base" class="#cl#">
				<cfinput type="Text" name="NameBase" value="#get.NameBase#" required="No" size="20" maxlength="30" class="regularxl">
				</td>
			</tr>
		</table>
		</td>
		</tr>
		
		<TR>
	    <TD class="labelmedium">UoM description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="IndicatorUoM" value="#get.IndicatorUoM#" message="Please enter a UoM" 
		      required="Yes" size="60" maxlength="200" class="regularxl">
	    </TD>
		</TR>
		
			
		<TR>
	    <TD class="labelmedium">Zero based:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="ZeroBase" value="0"  <cfif get.ZeroBase eq "0">checked</cfif>> Default
			<INPUT type="radio" class="radiol" name="ZeroBase" value="1"  <cfif get.ZeroBase eq "1">checked</cfif>> Zero based
			<input type="radio" class="radiol" name="ZeroBase" value="2" disabled  <cfif get.ZeroBase eq "2">checked</cfif>> Cumulative
		</TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Indicator Weight:</TD>
	    <TD>
		    <cfinput type="Text" name="IndicatorWeight" style="text-align: center;" class="regularxl" value="#get.IndicatorWeight#" range="1,20" message="Enter a relative weight" validate="integer" required="Yes" size="2" maxlength="2">
		</TD>
		</TR>
		
		<TR>
		<TR>
	    <TD class="labelmedium" style="cursor: pointer;"><cf_UIToolTip tooltip="Audit Value within the range will be acceptable">Target direction:</cf_UIToolTip></TD>
	   
	    <TD>
		 <table cellspacing="0" cellpadding="0" class="formpadding"><tr>
		    <td style="padding-left:0px">
	    	<INPUT type="radio" class="radiol" name="TargetDirection" value="Up" <cfif get.TargetDirection eq "Up">checked</cfif>>
			</td>
			<td style="padding-left:4px" class="labelmedium">Up</td>
			<td style="padding-left:9px">
			<INPUT type="radio" class="radiol" name="TargetDirection" value="Down" <cfif get.TargetDirection eq "Down">checked</cfif> >
			</td>
			<td class="labelmedium" style="padding-left:4px">Down</td>
			<td style="padding-left:9px">
			<INPUT type="radio" class="radiol" name="TargetDirection" value="None" <cfif get.TargetDirection eq "None">checked</cfif>>
			</td>
			<td style="padding-left:4px" class="labelmedium">None</td>		
	
			<td width="10">&nbsp;</td>
			<TD class="labelmedium">Target range:</TD>
			<TD>
			    <cfinput type="Text" name="TargetRange" style="text-align: center;" class="regularxl" 
				 value="#get.TargetRange#" range="0,30" message="Enter a valid range" validate="integer" required="Yes" size="4" maxlength="4">%
			</TD>
			</tr>		
		</table>	
		</TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium">Precision:</TD>
	    <TD class="labelmedium">
		    <cfinput type="Text" class="regularxl" name="IndicatorPrecision" range="0,3" message="Enter a valid number between 0 and 3" value="#get.IndicatorPrecision#" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="1" style="text-align: center;"> digit
		</TD>
		</TR>
		
		
		<TR>
	    <TD class="labelmedium">Audit class:</TD>
	    <TD>
		    <table cellspacing="0" cellpadding="0">
			<tbody>
		    <td style="padding-left:0px"><INPUT class="radiol" type="radio" name="AuditClass" value="A" <cfif #get.AuditClass# eq "A">checked</cfif>></td>
			<td class="labelmedium">A</td>
			<td style="padding-left:4px"><INPUT class="radiol" type="radio" name="AuditClass" value="B" <cfif #get.AuditClass# eq "B">checked</cfif>></td> 
			<td class="labelmedium">B</td>
			<td style="padding-left:4px"><INPUT class="radiol" type="radio" name="AuditClass" value="C" <cfif #get.AuditClass# eq "C">checked</cfif>></td>
			<td class="labelmedium">C</td>
			<td style="padding-left:4px"><INPUT class="radiol" type="radio" name="AuditClass" value="D" <cfif #get.AuditClass# eq "D">checked</cfif>></td>
			<td class="labelmedium">D</td>
			</tbody>
			</table>
		</TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium">Source:</TD>
	    <TD class="labelmedium">
		    <INPUT type="radio" class="radiol" name="AuditSource" value="Manual" <cfif get.AuditSource eq "Manual">checked</cfif> onclick="measuresource('manual')"> Manual
			<INPUT type="radio" class="radiol" name="AuditSource" value="External" <cfif get.AuditSource eq "External">checked</cfif> onclick="measuresource('external')"> External
			&nbsp;
			
			<cfif get.AuditSource eq "External">
		     <cfset cl = "regularxl">
		    <cfelse>
		     <cfset cl = "hide"> 	 
		    </cfif>
			
			 <select name="source" id="source" class="#cl#">
		   
			   <cfloop query="Source">
				   <option value="#Code#" <cfif #GetSource.Source# eq #Code#>selected</cfif>> #Description#</option>
			   </cfloop>
			   
			 </select>  
		</TD>
		</TR>
		
		<cfif get.IndicatorType eq "0002">
			<cfset cl = "hide">
		<cfelse>
			<cfset cl = "labelmedium">
		</cfif>
		
		<tr><td colspan="3" class="labelmedium"><b>Chart</td></tr>
		
		<tr>
		 <td style="padding-left:20px" class="labelmedium">style:</td>
		 <td colspan="3" class="labelmedium">
		    <table cellspacing="0" cellpadding="0">
			<tbody>
			<tr  class="labelmedium">
		    <td style="padding-left:0px"><input type="radio" class="radiol" name="ChartType" value="Line" <cfif get.Charttype eq "Line">checked</cfif>></td>
			<td style="padding-left:4px">Line</td>
			<td style="padding-left:9px"><input type="radio" class="radiol" name="ChartType" value="Bar" <cfif get.Charttype eq "Bar">checked</cfif>></td>
			<td style="padding-left:4px">Bar</td>
			</tr>
			</table>
	 	 </td>
		</tr>
				
		<tr>
		 <td style="padding-left:20px" class="labelmedium">color:</td>
		 <td colspan="3">
			 <table cellspacing="0" cellpadding="0" class="formpadding formspacing">
			 <tr>
			 <td class="labelmedium">Target</td>
			 <td style="padding-left:4px"><input type="text" name="ChartColorTarget" class="regularxl" value="#get.ChartColorTarget#" size="4" maxlength="10"></td>
			 <td class="labelmedium">Upload</td>
			 <td style="padding-left:4px"><input type="text" name="ChartColorUpload" class="regularxl" value="#get.ChartColorUpload#" size="4" maxlength="10"></td>	
			 <td class="labelmedium">Manual</td>
			 <td style="padding-left:4px"><input type="text" name="ChartColorManual" class="regularxl" value="#get.ChartColorManual#" size="4" maxlength="10"></td>	
			 </tr>	 
			 </table>
		 </td>
	    </tr>
				
		<tr id="chart" class="#cl#">
		 <td class="labelmedium" style="padding-left:20px">scale from:</td>
		 <td><table cellspacing="0" cellpadding="0">
		     <tr class="labelmedium">
			   	<td>
				<cfif get.ChartScaleFrom eq "">
				  <cfset i = "">
				<cfelse>
				  <cfset i = get.chartscalefrom>
				</cfif>  
				
				<cfinput type="Text"
	       name="ChartScaleFrom" size="5" style="text-align:center"
	       value="#i#"
	       validate="float" class="regularxl"></td>
		   
		   		<cfif get.ChartScaleTo eq "">
				  <cfset i = "">
				<cfelse>
				  <cfset i = get.chartscaleto>
				</cfif>  
				
				<td class="labelmedium" style="padding-left:4px;padding-right:4px">to:</td>
				<td><cfinput type="text" style="text-align:center" size="3" value="#i#" name="ChartScaleTo" validate="float" class="regularxl"></td>
				
				<cfif get.ChartLines eq "0">
				  <cfset i = "">
				<cfelse>
				  <cfset i = get.chartLines>
				</cfif>  
				
				<td>&nbsp;Lines:&nbsp;</td>
				<td><cfinput type="Text" class="regularxl"  name="ChartLines" style="text-align:center"  value="#i#" size="2" validate="integer"></td>
			</tr>
			</table>
		</td>
		</tr>
				
		<TR>
	    <TD class="labelmedium">Template drilldown:</TD>
	    <TD>
		   <table cellspacing="0" cellpadding="0">
		   <tr>
		   <td class="labelmedium">
		   <INPUT type="radio" class="radiol" name="IndicatorDrilldown" value="0" <cfif get.IndicatorDrilldown eq "0">checked</cfif> onclick="javascript:template('0')"> No
		   <input type="radio" class="radiol" name="IndicatorDrilldown" value="1" <cfif get.IndicatorDrilldown eq "1">checked</cfif> onClick="javascript:template('1')"> Yes
		   <cfif get.IndicatorDrilldown eq "1">
		     <cfset cl = "regularxl">
		   <cfelse>
		     <cfset cl = "hide"> 	 
		   </cfif>
		   </td>
		   <td style="padding:10px"></td>
		   
		   <cfif get.IndicatorTemplateAjax eq "1">
		   	   
			   <cfif not FileExists("#SESSION.rootPath#\Custom\#get.IndicatorTemplate#Listing.cfm")>
			   <td width="80%">
			   <cfelse>
			   <td width="80%">
			   </cfif>
		   
		   <cfelse>
		   
		   	  <cfif not FileExists("#SESSION.rootPath#\Custom\#get.IndicatorTemplate#")>
			   <td width="80%">
			   <cfelse>
			   <td width="80%">
			   </cfif>
		   
		   </cfif>
		   
			   <table id="template" class="#cl#" border="0" cellspacing="0" cellpadding="0">
				   <tr>
					   <td class="labelmedium">	   
					   <input type="text"     name="indicatortemplate"     value="#get.IndicatorTemplate#"     class="regularxl" size="36" maxlength="50">		   
					   </td>
					   <td class="labelmedium">?param=</td>
					   <td class="labelmedium">
				       <input type="text"     name="IndicatorCriteriaBase" value="#get.IndicatorCriteriaBase#" class="regularxl" size="10" maxlength="200">
					   </td>
					   <td class="labelmedium">
					   <input type="checkbox" class="radiol" name="indicatortemplateajax" value="1" <cfif get.IndicatorTemplateAjax eq "1">checked</cfif> >
					   </td>
					   <td class="labelmedium">
					   Ajax
				       </td>
				   </tr>
			   </table>	
			   
		   </td></tr>
		   </table>
	    </td>
		</TR>
		
		
		<cfquery name="Mission" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission IN (SELECT Mission 
		                  FROM   Organization.dbo.Ref_MissionModule 
						  WHERE SystemModule = 'Program' )
		</cfquery>
		
		<tr>
		 <td>
		 	<table cellspacing="0" cellpadding="0">
				 <tr><td height="24" class="labelmedium">
				 <cf_UIToolTip tooltip="Define a tree for which this indicator will be made available">
				 Tree:
				 </cf_UIToolTip>
				 </td></tr>
				 <tr><td height="24" class="labelmedium">
				 <cf_UIToolTip tooltip="Define a code to be used in conjunction with the workflow to enter indicator values">
				 Auth. Class:
				 </cf_UIToolTip>
				 </td></tr>
		    </table>
		 </td>
		 
		 <script>
		 
			 function auth(val,mission) {
			 if (val == true) {
			   document.getElementById("box"+mission).className = "regularxl"
			   } else {
			   document.getElementById("box"+mission).className = "hide"
			   }
			 }	 
		 
		 </script>
		 
		 <td >
		 <table cellspacing="0" cellpadding="0">
			 <tr>		
				 
				 <td style="height:32px">
				 
				 <table cellspacing="0" cellpadding="0">
				 
				 <cfset cnt = 0>
				 
				 <cfloop query="Mission">			
							 
					 <cfif cnt eq "0">
					 <tr>
					 </cfif>
				 
				 	 <cfset cnt = cnt+1>
					 
					<cfquery name="Check" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM Ref_IndicatorMission
						WHERE IndicatorCode = '#get.IndicatorCode#'
						AND Mission = '#Mission#'
					</cfquery>
					<td class="labelmedium">
					<input type="checkbox" 
						name="Mission" <cfif check.recordcount eq "1">checked</cfif> 
						value="#Mission#"
						class="radiol" 
						onclick="auth(this.checked,'#mission#')"></td><td style="padding-left:4px" class="labelmedium">#Mission#</td>				 
				    </td>
				 
					 <cfif check.recordcount eq "1">
						  <cfset cl="regularxl">
					 <cfelse>
						  <cfset cl="hide"> 
					 </cfif>
					 
					 <td width="80" style="padding-left:4px;padding-right:10px">			   
						    <cfinput type="Text" 
							  id="box#Mission#" class="#cl#"
							  name="#Mission#AuthorizationClass" 
							  value="#check.AuthorizationClass#" 
							  size="5" 
							  maxlength="10"
							  style="text-align: center;"> 	
					 </td>
					 
					 <cfif cnt eq "3">
						 </tr>
						 <cfset cnt = 0>
					 </cfif>
		
				  </cfloop>
				 </table>
				 
				 </td> 
				
			 </tr>
		 </table>
		
		</tr>
		
		<tr><td class="labelmedium">Operational</td>
		<td><input class="radiol" type="checkbox" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>></td>
		</tr>
		
		<TR>
	    <TD class="labelmedium">Memo:</TD>
	    <TD><textarea class="regular" style="width:99%" rows="4" name="IndicatorMemo">#get.IndicatorMemo#</textarea>
		</TD>
		</TR>
					
		</cfoutput>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
		
		<cfif Category.recordcount gte "1">
		
			<tr>	
			<td colspan="2" align="center">
			
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="recordclose()">
			
			<cfquery name="Delete" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE  ProgramIndicator
				FROM    ProgramIndicator P
				WHERE   Indicatorcode = '#get.Indicatorcode#'
				AND     RecordStatus = '9'
				AND     TargetId NOT IN (SELECT TargetId 
				                         FROM  ProgramIndicatorAudit
										 WHERE TargetId = P.TargetId)
		    </cfquery>
		
		    <cfquery name="CountRec" 
		      datasource="AppsProgram" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
			      SELECT   *
			      FROM     ProgramIndicator
			      WHERE    IndicatorCode  = '#get.IndicatorCode#' 
		    </cfquery>
		    
		    <cfif CountRec.recordCount eq 0>			
			<input class="button10g" style="height:25px" type="submit" name="Delete" value="Delete" onclick="return ask()">			
			</cfif>			
			<input class="button10g" style="height:25px" type="submit" name="Update" value="Update">
			
			</td>	
			</tr>
		
		</cfif>
			
	</TABLE>
	
</CFFORM>
		
<cf_screenbottom layout="innerbox">	
