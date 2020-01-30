<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Grade" 
			  banner="gray"
			  line="No"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *,replace(PostGrade,'-','_')PostGrade1
	FROM   Ref_PostGrade
	WHERE  PostGrade = '#URL.ID1#'
</cfquery>

<cfquery name="Parent"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostGradeParent
	ORDER BY Description
</cfquery>

<!--- edit form --->

<table width="92%" align="center" class="formpadding">
	
	<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

	<tr><td height="6"></td></tr>
	
    <cfoutput>
    <TR>
    <TD class="labelmedium" width="100"><cf_tl id="Code">:</TD>
    <TD width="65%">
  	   <input type="text" name="PostGrade" value="#get.PostGrade#" size="10" maxlength="10"class="regularxl">
	   <input type="hidden" name="PostGradeOld" value="#get.PostGrade#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Display">:</TD>
    <TD>
  	   <cfinput type="Text" name="PostgradeDisplay" value="#Get.PostGradeDisplay#" message="Please enter a display description" required="Yes" size="20" maxlength="30" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Budget code">:</TD>
    <TD>
  	   <cfinput type="Text" name="PostgradeBudget" value="#Get.PostGradeBudget#" message="Please enter a budget code" required="Yes" size="10" maxlength="10"class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Listing order">:</TD>
    <TD>
  	   <cfinput type="Text" name="PostOrder" value="#Get.PostOrder#" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Parent">:</TD>
    <TD >
	   <select name="PostGradeParent" class="regularxl">
	   <cfloop query="Parent">
	   <option value="#Parent.Code#" <cfif #Get.PostGradeParent# eq "#Parent.Code#">selected</cfif>>#Parent.Description#</option>
	    </cfloop>
	   </select>
    </TD>
	</TR>
	
	<tr><td height="3"></td></tr>	
		
	<TR>
	<cf_UIToolTip tooltip="Use Grade for Position Grade">
    <td class="labelmedium"><cf_tl id="Enable Position Grade">:</b></td>
	</cf_UIToolTip>
    <TD class="labelmedium">	
	<input type="radio" name="PostGradePosition" <cfif Get.PostGradePosition eq "1">checked</cfif> value="1">Enabled
	<input type="radio" name="PostGradePosition" <cfif Get.PostGradePosition eq "0">checked</cfif> value="0">Disabled	
    </td>
    </tr>	
	
	<tr><td height="3"></td></tr>	
		
	<TR>
	<cf_UIToolTip tooltip="Use Grade for Recruitment track">
    <td class="labelmedium"><cf_tl id="Enable recruitment track">:</b></td>
	</cf_UIToolTip>
    <TD class="labelmedium">	
	<input type="radio" name="PostGradeVactrack" <cfif Get.PostGradeVactrack eq "1">checked</cfif> value="1">Enabled
	<input type="radio" name="PostGradeVactrack" <cfif Get.PostGradeVactrack eq "0">checked</cfif> value="0">Disabled	
    </td>
    </tr>	
	
	<tr><td height="3"></td></tr>	
	
	<TR>
	<cf_UIToolTip tooltip="Use Grade for Contract registration">
    <td class="labelmedium"><cf_tl id="Enable Contract Level">:</b></td>
	</cf_UIToolTip>
    <TD class="labelmedium">	
	<input type="radio" name="PostGradeContract" <cfif Get.PostGradeContract eq "1">checked</cfif> value="1">Enabled
	<input type="radio" name="PostGradeContract" <cfif Get.PostGradeContract eq "0">checked</cfif> value="0">Disabled	
    </td>
    </tr>	
	
	<tr><td height="3"></td></tr>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Total Steps">:</TD>
    <TD>
	 <table><tr><td>
  	   <cfinput type="Text" name="PostGradeSteps" value="#Get.PostGradeSteps#" range="1,20" validate="integer" style="text-align:center;width:40" required="Yes" visible="Yes" enabled="Yes" size="3" maxlength="2" class="regularxl">
	   </td>
	   <td class="labelmedium" style="padding-left:10px">Default increment:</td>
	   <td class="labelmedium">
	   <input type="radio" name="PostGradeStepInterval" <cfif Get.PostGradeStepInterval neq "2">checked</cfif> value="1">1
		<input type="radio" name="PostGradeStepInterval" <cfif Get.PostGradeStepInterval eq "2">checked</cfif> value="2">2	
	   </td>
	   </tr></table>
    </TD>
	</TR>


	<tr><td height="3"></td></tr>	
	
	<TR>
    <TD valign="top" style="padding-top:1px" class="labelmedium"><cf_tl id="Steps Interval mapping">:</TD>
    <TD>

	<!----check if there are interval already defined ----->
	<cfquery name="GetMax" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT MAX(DateEffective) as MaxDateEffective
			FROM   Ref_PostGradeStep
			WHERE  PostGrade = '#URL.ID1#'
		</cfquery>

	<cfquery name="GetIntervals" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_PostGradeStep
			WHERE    PostGrade = '#URL.ID1#'
			AND      DateEffective = '#GetMax.MaxDateEffective#'
			ORDER BY Step ASC 
		</cfquery>
	
    <table width="75%">
    	<tr>
    		<td>Step</td><td>Interval:</td>
    	</tr>
		
    	<cfif getIntervals.Recordcount gte 1>

    		<cfloop query ="getIntervals" >
			    	<tr>
		    			<td>#Step#
		    			</td>
		    			<td>
			    			<cfinput type="Text" id="PostOrder_#Get.postGrade1#_#Step#" name="PostOrder_#Get.postGrade1#_#Step#" value="#GetIntervals.StepInterval#" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl">
			    			<cfinput type="hidden" id="PostOrder_#Get.postGrade1#_#Step#_action" name="PostOrder_#Get.postGrade1#_#Step#_action" value="update">
			    		</td>
		    		</tr>
		    	</cfloop>

    		<cfelse>
    			<cfset thisIndex = 1>
		    	<cfloop condition = "thisIndex lte Get.PostGradeSteps">
			    	<tr>
			    		<cfif thisIndex lte 9>
		    			<td>0#thisIndex#
		    			</td>
		    			<td>
		    				<cfinput type="Text" id="PostOrder_#Get.postGrade1#_0#thisIndex#" name="PostOrder_#Get.postGrade1#_0#thisIndex#" value="#Get.PostGradeStepInterval#" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl">
			    			<cfinput type="hidden" id="PostOrder_#Get.postGrade1#_0#thisIndex#_action" name="PostOrder_#Get.postGrade1#_0#thisIndex#_action" value="insert">
			    		<cfelse>
			    				<td>#thisIndex#
		    					</td>
		    					<td>
			    					<cfinput type="Text" id="PostOrder_#Get.postGrade1#_#thisIndex#" name="PostOrder_#Get.postGrade1#_#thisIndex#" value="#Get.PostGradeStepInterval#" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxl">
			    				<cfinput type="hidden" id="PostOrder_#Get.postGrade1#_#thisIndex#_action" name="PostOrder_#Get.postGrade1#_#thisIndex#_action" value="insert">
			    			</td>
		    			</cfif>
		    		</tr>
		    		<cfset thisIndex = thisIndex +1>
		    	</cfloop>
    	</cfif>
    </table>
	
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line">
		<cf_dialogBottom option="Edit" delete="Post Grade">
	</td></tr>		
	
	</cfoutput>
	
	</CFFORM>
		
</TABLE>

<cf_screenbottom layout="innerbox">
