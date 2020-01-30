
<cfset actionform = 'Travel'>

<cfquery name="Travel" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
    FROM  	stTravel 
	WHERE 	DocumentNo = '#Object.ObjectKeyValue1#'
	 AND    PersonNo   = '#Object.ObjectKeyValue2#'
</cfquery>

<cfif Travel.recordcount eq "0">
	<cfset showProcess = "0">
</cfif>

<cfoutput>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="white">      
  
  <tr>
    <td colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
	<TR>
    <TD>&nbsp;<b>Travel Auth. No:</TD>
    		
		<td colspan="3">
    	<cfoutput>
		   <input type="text" name="TANumber" value="#Travel.TANumber#" class="regularH" size="20" maxlength="20">
		</cfoutput>
		</td>
		
	</TR>	
	
	<tr><td height="1" colspan="4" bgcolor="DFDFDF"></td></tr>
	
	<TR>
    <td valign="top" width="15%">&nbsp;<b><img src="#SESSION.root#/Images/claim/airplane.gif" alt="" align="absmiddle" border="0">
	&nbsp;&nbsp;ETA:</td>
	
	<td colspan="3">
	
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	    <tr>
		
		    <TD width="100">City:</td>
			<td> <input type="text" name="ArrivalPlace" value="#Travel.ArrivalPlace#" class="regularH" size="40" maxlength="40"></td>
			</tr>
		
		<TR>
	    <TD>Date:</td>
		<td style="z-index:10; position:relative;padding:0px">
		
		<cfif Travel.ArrivalDateTime eq "">
		
		<cf_intelliCalendarDate8
			FieldName="ArrivalDate" 
			class="regularH"
			Default="#Dateformat(now()+7, '#CLIENT.DateFormatShow#')#"
			AllowBlank="False">	
		
		<cfelse>
		
		<cf_intelliCalendarDate8
			FieldName="ArrivalDate" 
			class="regularH"
			Default="#Dateformat(Travel.ArrivalDateTime, '#CLIENT.DateFormatShow#')#"
			AllowBlank="False">	
			
		</cfif>	
		
		</td>
		</tr>
		
		<TR>
	    <TD>Time:</td>
		<td>
		
			<cfif #Timeformat(Travel.ArrivalDateTime, 'HH')# eq "">
			   <cfset tah = "12">
			   <cfset tam = "00">
			<cfelse>
			   <cfset tah = "#Timeformat(Travel.ArrivalDateTime, 'HH')#">
			   <cfset tam = "#Timeformat(Travel.ArrivalDateTime, 'MM')#">
			</cfif>
					
			<cfinput type="Text" 
				name="HourArrival" 
				range="1,23" 
				value="#tah#"
				message="Please enter a valid hour" 
				validate="integer" 
				required="Yes" 
				size="1" 
				maxlength="2" 
				class="regularH" 
				style="text-align: center;">
			:
			<cfinput type="Text" 
		         name="MinuteArrival" 
				 range="0,59" 
				 value="#tam#"
				 message="Please enter a valid minute 0-59" 
				 validate="integer" 
				 required="Yes" 
				 size="1" 
				 maxlength="2" 
				 style="text-align: center;" 
				 class="regularH">
	 	</td>
		</tr>
		
		<TR>
	    <TD>Airline: </td>
		<td> <input type="text" name="AirlineName" value="#Travel.AirlineName#" class="regularH" size="30" maxlength="30"></td>
		</tr>
		
		<TR>
	    <TD>Flight No:</td>
		<td> <input type="text" name="AirlineFlightNo" value="#Travel.AirlineFlightNo#" class="regularH" size="10" maxlength="10"></td>
		</tr>
		
	  </table>
	  
	</td>
	</tr>  	
	
	<tr><td height="1" colspan="4" bgcolor="DFDFDF"></td></tr>
	
	<cfset row = 1>
	
	<cfloop index="itm" list="Passport,UNLP" delimiters=",">
	
	<TR>
    <td valign="top" width="15%">&nbsp;<img src="#SESSION.root#/Images/hr_document.gif" alt="" align="absmiddle" border="0">
	&nbsp;<b>#itm#:</td>
    		
		<td colspan="3" align="center">
		
		<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   DISTINCT P.PersonNo
			FROM     Applicant.dbo.Applicant A INNER JOIN
                     Person P ON A.IndexNo = P.IndexNo
			WHERE    A.PersonNo = '#Object.ObjectKeyValue2#'
		</cfquery>	
		
		<cfquery name="Document" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
			    FROM PersonDocument S
				WHERE PersonNo = '#Person.PersonNo#'
				AND DocumentType = '#itm#'
			</cfquery>
			
			
		
		<cfif Person.Recordcount eq "1">
			
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
					<input type="hidden" name="#itm#_DocumentType" value="#Itm#">
					
					<cfquery name="Nation" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM Ref_Nation
					</cfquery>
					
					<TR>
				    <TD>Country:</TD>
				    <TD>
					   	<select name="#itm#_Country" required="No">
						<option value=""></option>
					    <cfloop query="Nation">
						<option value="#Code#" <cfif #Document.IssuedCountry# eq #Code#>selected</cfif>>
						#Name#
						</option>
						</cfloop>
					    
				   	</select>		
					</TD>
					</TR>
					
					<TR>
				    <TD width="100" >Document No:</TD>
				    <TD>
					<INPUT type="text" class="regularH" value="#Document.DocumentReference#" name="#itm#_DocumentReference" maxLength="30" size="30">
					</TD>
					</TR>
					
					<cfset row = row+1>
					 
				    <TR>
				    <TD>Effective date:</TD>
				    <TD style="z-index:#10-row#; position:relative;padding:0px">
					
						  <cf_intelliCalendarDate8
						FieldName="#itm#_DateEffective" 						
						Class="regularH"
						Default="#Dateformat(Document.DateEffective, CLIENT.DateFormatShow)#">	
					
					</TD>
					</TR>
					
					<cfset row = row+1>
					
					<TR>
				    <TD>Expiration date:</TD>
				    <TD style="z-index:#10-row#; position:relative;padding:0px">					
						  <cf_intelliCalendarDate8
						FieldName="#itm#_DateExpiration" 						
						Class="regularH"
						Default="#Dateformat(Document.DateExpiration, CLIENT.DateFormatShow)#">	
							
					</TD>
					</TR>
																	
					<TR>
				        <td>Remarks:</td>
				        <TD>
						<INPUT type="text" class="regularH" value="#Document.Remarks#" name="#itm#_Remarks" maxLength="80" size="60">
				        </TD>
					</TR>
			
			
			</table>
			
			<cfelse>		
			
			<font color="FF0000"><b>Problem, employee profile could not be identified!</b>			
			
			</cfif>
						
		</td>
		
	</TR>	
	
	<tr><td height="1" colspan="4" bgcolor="DFDFDF"></td></tr>
	
	</cfloop>
	
	<TR>
    <TD>&nbsp;<img src="#SESSION.root#/Images/hr_lumpsum.gif" alt="" align="absmiddle" border="0">&nbsp;&nbsp;<b>Lumpsum:</TD>
    		
		<td colspan="3">
		
		<input type="radio" name="LumpsumEnabled" value="0" onclick="lump('no')" <cfif #Travel.LumpsumEnabled# neq "1">checked</cfif>>No
		<input type="radio" name="LumpsumEnabled" value="1" onclick="lump('yes')" <cfif #Travel.LumpsumEnabled# eq "1">checked</cfif>>Yes
		&nbsp;
		<cfif Travel.LumpsumEnabled eq "1">
		  <cfset cl = "regularH">
		<cfelse>
		  <cfset cl = "hide">
		 </cfif>
		 
		 <script>
		 
		 function lump(st) {
			
			 fl = document.getElementById("LumpsumAmount")
			
			 if (st == "yes") {
			 fl.className = "regular"
			 } else {
			 fl.className = "hide"
			 }
		 }
		 
		 </script>
		
		   <cfinput type="Text" name="LumpsumAmount" value="#Travel.LumpsumAmount#" validate="float" required="No" class="#cl#" visible="Yes" enabled="Yes" size="20" maxlength="20">
		
		</td>
		
	</TR>	
	
	<tr><td height="1" colspan="4" bgcolor="DFDFDF"></td></tr>
			
	<input name="savecustom" type="xxxxhidden"  value="Vactrack/Application/Travel/DocumentSubmit.cfm">  
	   
   </cfoutput> 
		
</TABLE>
</td>
</tr>
</table>
