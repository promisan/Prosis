
<cfquery name="Mission" 
datasource="AppsEPas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE Mission IN (SELECT Mission 
	                  FROM   Organization.dbo.Ref_MissionModule 
					  WHERE  SystemModule IN ('Staffing'))							 
				  
</cfquery>

<cfquery name="Class" 
datasource="AppsEPas" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ContractClass
	WHERE Operational = 1
	ORDER BY ListingOrder 				  
</cfquery>

<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
	  scroll="Yes" 
	  label="Set evaluation Period" 
	  layout="webapp" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">
	  
<cf_calendarscript>	  
			  
<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST">

<table width="93%" align="center" class="formpadding formspacing">

	<tr><td id="process"></td></tr>
	
	<cfoutput>
	
	<TR>
	    <TD style="width:100px" class="labelmedium2"><cf_tl id="Entity">:</TD>
    	<TD>		
		<select name="mission" id="mission" class="regularxxl" onchange="ptoken.navigate('setContractPeriodDate.cfm?mission='+this.value+'&class='+document.getElementById('contractclass').value,'process')">
        	<cfloop query="Mission">
        	<option value="#Mission#">#Mission#</option>
         	</cfloop>
	    </select>				
		</TD>
	</TR>
	
	<cfquery name="Class" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ContractClass
		WHERE    Operational = 1
		ORDER BY ListingOrder 				  
	</cfquery>
	
	<TR class="labelmedium2">
	    <TD><cf_tl id="Class">:</TD>
	    <TD>
		<select name="contractClass" id="contractclass" class="regularxxl" 
		    onchange="ptoken.navigate('setContractPeriodDate.cfm?mission='+document.getElementById('mission').value+'&class='+this.value,'process')">
	       	<cfloop query="Class">
	       	  <option value="#Code#">#Description#</option>
	       	</cfloop>
		</select>
		</TD>
	</TR>
	
	<cfquery name="Last" 
	datasource="AppsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ContractPeriod
		WHERE    Mission = '#mission.mission#'
		AND      ContractClass = '#class.code#'
		ORDER BY PASPeriodStart DESC
	</cfquery>
	
	<cfif last.recordcount gte "1">
	
		<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat(last.PASPeriodEnd,CLIENT.DateFormatShow)#">	
		<cfset STR = dateAdd("d",1,dateValue)>
		<cfset END = dateAdd("yyyy",1,dateValue)>
	
		<cfset st = dateformat(STR,client.dateformatshow)>
		<cfset ed = dateformat(END,client.dateformatshow)>
	<cfelse>
		<cfset st = "">	
		<cfset ed = "">
	</cfif>
			
	<TR class="labelmedium2">
	    <TD><cf_tl id="Code">:</TD>
	    <TD><cfinput type="Text" name="Code" message="Please record a code" required="Yes" visible="Yes" enabled="Yes" size="6" maxlength="6" class="regularxxl"></TD>
	</TR>
	
	<TR class="labelmedium2">
	    <TD><cf_tl id="Start">:</TD>
	    <TD>
		
		<cf_intelliCalendarDate9
			FieldName="PASPeriodStart" 
			Manual="True"		
			class="regularxxl"								
			Default="#st#"
			AllowBlank="False">	
		
		</TD>
	</TR>
	
	<TR class="labelmedium2">
	    <TD><cf_tl id="End">:</TD>
	    <TD>
		
		<cf_intelliCalendarDate9
			FieldName="PASPeriodEnd" 
			Manual="True"		
			class="regularxxl"								
			Default="#ed#"
			AllowBlank="False">	
		
		</TD>
	</TR>
	
	<TR class="labelmedium2">
	    <TD><cf_tl id="Midterm">:</TD>
	    <TD>
		
		<cf_intelliCalendarDate9
			FieldName="PASEvaluation" 
			Manual="True"		
			class="regularxxl"	
			Default="#st#"										
			AllowBlank="False">	
		
		</TD>
	</TR>	
	
	</cfoutput>
	
	
	
	<!---
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Period">:</TD>
	<TD><cfdiv bind="url:SelectPeriod.cfm?mission={mission}" id="boxperiod"></TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Edition">:</TD>
    <TD><cfdiv bind="url:SelectEdition.cfm?mission={mission}" id="boxedition"></TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Memo">:</TD>
    <TD><cfinput type="text" name="Memo" value="" message="please enter a description" size="30" maxlenght= "90" class= "regularxl"></TD>
	</TR>	
	
	--->
	
	<tr><td></td></tr>
	<tr><td colspan="2" class="line"></td></tr>	
					
	<tr>	
	<td colspan="2" align="center" height="40">			
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Add">	
	</td>		
	</tr>
	
		
</TABLE>

</CFFORM>

