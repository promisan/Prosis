<cfparam name="url.idmenu" default="">

<cfset l = "Enter Performance Indicator">

<cf_screentop height="100%" 
			  label="#l#" 
			  layout="webapp" 
			  banner="gray" 
			  scroll="Yes"
  			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_droptable dbname="AppsProgram" tblname="tmp#SESSION.acc#Category"> 

<cfquery name="IndicatorType" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_IndicatorType
</cfquery>

<cftry>
<cfquery name="Source" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
INSERT INTO Ref_MeasureSource
(Code,Description)
VALUES ('Manual','Manual')
</cfquery>
<cfcatch></cfcatch>
</cftry>

<cfquery name="Source" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_MeasureSource
WHERE Code != 'Manual'
</cfquery>

<cfquery name="Parent" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
INTO   tmp#SESSION.acc#Category
FROM   Ref_ProgramCategory
WHERE  (Parent is NULL or Parent = '')
AND    Code IN (SELECT Category FROM Ref_ParameterMissionCategory 
                WHERE  Mission = '#URL.Mission#')
</cfquery>

<cfform action="RecordSubmit.cfm?mission=#url.mission#" method="POST" enablecab="Yes" name="dialog">
   
<table width="91%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">
    
    <tr><td></td></tr>
    <TR class="labelmedium">
    <td width="130">Id:</td>
    <TD>
  	   <cfinput type="text" name="Indicatorcode" value="" message="Please enter a code" required="Yes" size="6" maxlength="6" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <td>Display:</td>
    <TD>
  	   <cfinput type="text" name="IndicatorcodeDisplay" value="" message="Please enter a display code" required="Yes" size="6" maxlength="6" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:&nbsp;</TD>
    <TD>
			
		<cf_LanguageInput
			TableCode       = "Ref_Indicator" 
			Mode            = "Edit"
			Name            = "IndicatorDescription"
			Value           = ""
			Key1Value       = ""
			Type            = "Input"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "80"
			Size            = "50"
			Class           = "regularxl">
			
				
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD height="26">Program area:</TD>
    <TD>
				   
		<cfquery name="Category" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_ProgramCategory
		WHERE  (Parent is NULL or Parent = '')
		AND    Code IN (SELECT Category 
		                FROM   Ref_ParameterMissionCategory 
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
		   
		   <cfoutput query="Category">
		   
		   <option value="#Code#"> <cfif Parent neq "">&nbsp;&nbsp;&nbsp;&nbsp;</cfif>
		   #Code# 
		   <cfif Len(Description) gt 38>
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
				 <option value="#Code#">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   #Code# 
					   <cfif Len(Description) gt 38>
						   	#Left(Description, 38)#...
				       <cfelse>
						    #Description#
				       </cfif>
				</option>
				</cfloop>
			
			</cfif>
				   
		   </cfoutput>
		   
		   </select>
		   
	  </cfif>	   
	   
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Alternate description:</TD>
    <TD>
  	   <cfinput type="text" name="IndicatorDescriptionAlternate" value="" size="60" maxlength="100" class="regularxl">
    </TD>
	</TR>
		
	<TR class="labelmedium">
    <TD>UOM type:</TD>
    <TD>
	   <select name="IndicatorType" class="regularxl">
	   <cfoutput query="IndicatorType">
	   <option value="#Code#">#Description#</option>
	   </cfoutput>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>UoM description:</TD>
    <TD>
  	   <cfinput type="text" name="IndicatorUoM" value="" message="Please enter a UoM" required="Yes" size="60" maxlength="200" class="regularxl">
    </TD>
	</TR>
		
	<TR class="labelmedium">
    <TD>Target mode:</TD>
    <TD>
	    <INPUT class="radiol" type="radio" name="ZeroBase" value="0" checked> Default
		<INPUT class="radiol" type="radio" name="ZeroBase" value="1"> Zero based
		<input class="radiol" type="radio" name="ZeroBase" value="2" disabled> Cumulative
	</TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Target direction:</TD>
    <TD><cfoutput>
	    <INPUT type="radio" class="radiol" style="padding-left:4px"name="TargetDirection" value="Up" checked> Up
		<img src="#SESSION.root#/Images/arrow-up.gif" alt="" border="0">
		<INPUT type="radio" class="radiol" name="TargetDirection" value="Down" > Down
		<img src="#SESSION.root#/Images/arrow-down.gif" alt="" border="0">
		<INPUT type="radio" class="radiol" name="TargetDirection" value="None" > None
		<img src="#SESSION.root#/Images/arrow-steady.gif" height="10" width="10" alt="" border="0">
		</cfoutput>
	</TD>
	</TR>
		
	<TR class="labelmedium">
    <TD style="cursor: pointer;"><cf_UIToolTip tooltip="Audit Value within the range will be acceptable">Target range:</cf_UIToolTip></TD>
    <TD>
	    <cfinput type="Text" name="TargetRange" class="regularxl" style="text-align: center;" value="0" range="0,30" message="Enter a valid range" validate="integer" required="Yes" size="4" maxlength="4"> %
	</TD>
	</TR>
		
	<TR class="labelmedium">
    <TD>Precision:</TD>
    <TD>
	    <cfinput type="Text" name="IndicatorPrecision" value="0" range="0,3" message="Enter a valid number between 0 and 3" validate="integer" required="Yes" visible="Yes" enabled="Yes" size="1" maxlength="1" class="regularxl" style="text-align: center;"> digit
	</TD>
	</TR>
		
		
	<TR class="labelmedium">
    <TD>Audit class:</TD>
    <TD>
	    <table cellspacing="0" cellpadding="0">
		<tbody>
	    <td style="padding-left:0px"><INPUT type="radio" class="radiol" name="AuditClass" value="A" checked></td>
		<td class="labelmedium">A</td>
		<td style="padding-left:4px"><INPUT type="radio" class="radiol" name="AuditClass" value="B"></td> 
		<td class="labelmedium">B</td>
		<td style="padding-left:4px"><INPUT type="radio" class="radiol" name="AuditClass" value="C"></td>
		<td class="labelmedium">C</td>
		<td style="padding-left:4px"><INPUT type="radio" class="radiol" name="AuditClass" value="D"></td>
		<td class="labelmedium">D</td>
		</tbody>
		</table>
	</TD>
	</TR>
	
	<script language="JavaScript">
	
	function measuresource(cls) {
		
	    se = document.getElementById("source")		
		if (cls == "regular")
		   {se.className = "regularxl"}
		else
		   {se.className = "hide"}
	}      
		
	</script>
	
	<TR class="labelmedium">
    <TD class="labelmedium">Source:</TD>
    <TD>
	    <INPUT type="radio" class="radiol" name="AuditSource" value="Manual" checked onclick="javascript:measuresource('hide')"> Manual
		<INPUT type="radio" class="radiol" name="AuditSource" value="External" onclick="javascript:measuresource('regular')"> External
				
		 <select name="source" class="hide">
	   
		   <cfoutput query="Source">
			   <option value="#Code#"> #Description#</option>
		   </cfoutput>
		   
		 </select>  
		
	   </TD>
	</TR>
	
	<script language="JavaScript">
	
		function template(cls) {		
			se1 = document.getElementById("template")		
			if (cls == "regular") {
			  se1.className = "regular labelmedium"		
		    } else {
			  se1.className = "hide"		
			}
		}      
			
	</script>
	
	<TR class="labelmedium">
    <TD style="height:26px">Template drilldown:</TD>
    <TD>
	<table cellspacing="0" cellpadding="0">
	   <tr><td class="labelmedium">
	   <INPUT type="radio" class="radiol" name="IndicatorDrilldown" value="0" checked onclick="javascript:template('hide')"> No
	   <input type="radio" class="radiol" name="IndicatorDrilldown" value="1" onClick="javascript:template('regular')"> Yes
	   </td>
	   <td id="template" class="hide">
	   :
	   <input type="text" name="indicatortemplate" value="" size="30" maxlength="50" class="regularxl">
	   ?param=
       <input type="text" name="IndicatorCriteriaBase" value="" size="5" maxlength="10" class="regularxl">
	   <input type="checkbox" class="radiol" name="indicatortemplateajax" value="1">Ajax
	   </td>
	   </tr>
	   </table>
    </TD>
	</TR>
	
	<cfquery name="Mission" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission IN (SELECT Mission 
	                   FROM   Organization.dbo.Ref_MissionModule 
				  	   WHERE  SystemModule = 'Program' )
	</cfquery>
	
	<tr class="labelmedium">
		 <td valign="top" style="padding-top:4px">Entity:<cf_space spaces="50"></td>
		 <td>
		 
		 <cfoutput query="Mission">
		 	<input type="checkbox" class="radiol" name="Mission" value="#Mission#" <cfif url.mission eq mission>checked</cfif>>&nbsp;#Mission#	 
		 </cfoutput>
		 </td>	
	</tr>
		
	<TR class="labelmedium">
    <td valign="top" height="100%">Memo:</td>
    <TD>
	    <textarea style="width:99%;height:95%;font-size:13px;padding;3px" class="regular" name="IndicatorMemo"></textarea>
	</TD>
	</TR>	
	
	<tr><td colspan="2" class="line"></td></tr>	
	
	<cfif Category.recordcount eq "0">
	
	<tr><td colspan="2" align="center" class="labelmedium"><font color="FF0000">No Classifications were defined for this entity</font></td></tr>
	
	<cfelse>
	
		<tr>  
				
		<td align="center" colspan="2">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value=" Submit ">
		
		</td>	
		
		</tr>
	
	</cfif>
		
</TABLE>

</CFFORM>

<cf_screenbottom layout="webapp">
