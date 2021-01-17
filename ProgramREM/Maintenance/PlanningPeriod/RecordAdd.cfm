<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Period Definition" 
			  layout="webapp" 
			  banner="gray"
  			  menuAccess="Yes" 
              systemfunctionid="#url.idmenu#">

<cfquery name="Get"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Parameter
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

	<table width="94%" align="center" class="formpadding formspacing">
	
	    <TR class="labelmedium2">
	    <TD>Code:</TD>
	    <TD>
	  	   <cfinput type="text" name="Period" value="" message="Please enter a period" required="Yes" size="10" maxlength="10" class="regularxxl">
	    </TD>
		</TR>	
		
		<cf_calendarscript>
		
		<TR class="labelmedium2">
	    <TD>Period:</TD>
	    <TD>
			<table cellspacing="0" cellpadding="0">
			  <tr>
				  <td>
				 <cf_intelliCalendarDate9
					FieldName="DateEffective" 
					Default=""
					class="regularxxl"
					AllowBlank="False">
				</td>
				
				<td align="center" width="20">-</td>
				
				<td>
				 <cf_intelliCalendarDate9
				FieldName="DateExpiration" 
				Default=""
				class="regularxxl"
				AllowBlank="False">	
				</td>
				
				</tr>
			</table>
	    </TD>
		</TR>
			
		<TR class="labelmedium2">
	    <TD>Class:</TD>
	    <TD>
	  	   <cfinput type="text" name="PeriodClass" value="Standard" message="Please enter a class" required="Yes" size="10" maxlength="10" class="regularxxl">
	    </TD>
		</TR>
			
		<TR class="labelmedium2">
	    <TD>Description:</TD>
	    <TD>
	  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="50" maxlength="50" class="regularxxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium2">
	    <td>Menu Selection:</td>
		<td>
	  	  <input type="radio" class="radiol" name="IncludeListing" value="1" checked>Yes
		  <input type="radio" class="radiol" name="IncludeListing" value="0">No
	    </TD>
		</TR>	
		
		<TR class="labelmedium2">
	    <td width="100"><cf_UIToolTip tooltip="Defines if this period will be shown as a period for grouping of requisition, purchaseorder and invoices. Shown in the left panel for selection">Procurement&nbsp;Grouping:</cf_UIToolTip></td>
		<td width="70%">
	  	  <input type="radio" class="radiol" name="Procurement" value="1" checked>Yes
		  <input type="radio" class="radiol" name="Procurement" value="0">No
	    </TD>
		</TR>
		
		
		<TR>
		    <td width="100" class="labelmedium2">Mode:</td>
			<td width="70%">
			<table>
			 <tr class="labelmedium2">
			  <td><input type="radio" name="isPlanningPeriod" value="0" onclick="document.getElementById('planperiod').className='hide'"></td>
			  <td>Execution</td>
			  <td><input type="radio" name="isPlanningPeriod" value="1" checked onclick="document.getElementById('planperiod').className='regular'"></td>
			  <td>Execution- and Plan Period </td>
			 		
			 <cfset cl = "regular">	   
			 
			  <td id="planperiod" class="#cl#">
			  <table>
				  <tr class="labelmedium2"><td style="padding-left:3px;padding-right:3px">covers until:</td>
				  	<td>
					  <cf_intelliCalendarDate9
						FieldName="isPlanningPeriodExpiry" 
						Default=""
						class="regularxxl"
						AllowBlank="True">	
					</td>
				  </tr>
			  </table>
			  </td>	 
			  </tr>
			</table> 
		    </TD>
		</TR>
			
		<tr>	
			
		<td align="center" height="30" colspan="2">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" value="Submit">
		
		</td>	
		</tr>
			
	</TABLE>
</CFFORM>

<cf_screenbottom layout="innerbox">