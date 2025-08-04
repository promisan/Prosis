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

<cfset actionform = 'Travel'>

<cfquery name="Travel" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
    FROM  	stTravel 
	WHERE 	DocumentNo = '#URL.ID#'
	 AND    PersonNo   = '#URL.ID1#'
</cfquery>

<cfoutput>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffff" bordercolor="e4e4e4">
     
  <tr>
    <td colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			
	<tr>
	
	<cfloop index="itm" list="Passport,UNLP" delimiters=",">
	
	<td>
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<TR>
    <td width="15%" valign="top"><b>#itm#</td>
    		
		<td colspan="3" align="center">
		
		<cfquery name="Person" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   DISTINCT P.PersonNo
			FROM     Applicant.dbo.Applicant A INNER JOIN
                     Person P ON A.IndexNo = P.IndexNo
			WHERE    A.PersonNo = '#URL.ID1#'
		</cfquery>	
		
		<cfif Person.Recordcount eq "1">
						
			<cfquery name="Document" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT TOP 1 *
			    FROM PersonDocument S
				WHERE PersonNo = '#Person.PersonNo#'
				AND DocumentType = '#itm#'
			</cfquery>
			
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
			
					<input type="hidden" name="#itm#_DocumentType" value="#Itm#">
					
					<cfquery name="Nation" 
					datasource="AppsSystem" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM Ref_Nation
						WHERE Code = '#Document.IssuedCountry#'
					</cfquery>
					
					<TR>
				    <TD>Country:</TD>
				    <TD>
					    
						#Nation.Name#
												
					</TD>
					</TR>
					
					<TR>
				    <TD width="100" >Document No:</TD>
				    <TD>
						#Document.DocumentReference#
					</TD>
					</TR>
					 
				    <TR>
				    <TD>Effective date:</TD>
				    <TD>
					
						#Dateformat(Document.DateEffective, CLIENT.DateFormatShow)#
					
					</TD>
					</TR>
					
					<TR>
				    <TD>Expiration date:</TD>
				    <TD>					
						#Dateformat(Document.DateExpiration, CLIENT.DateFormatShow)#	
							
					</TD>
					</TR>
																	
					<TR>
				        <td>Remarks:</td>
				        <TD>
						#Document.Remarks#
				        </TD>
					</TR>
			
			
			</table>
			
			</cfif>
						
		</td>
		
	</TR>	
	
	
	</table>
	</td>
	
	</cfloop>
			
	<td>
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				
		<TR>
	    <td width="15%" valign="top"><b>ETA</td>
		
		<td colspan="3">
		
		<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
		
		    <tr>
			
			    <TD width="100">City:</td>
				<td>#Travel.ArrivalPlace#</td>
				</tr>
			
			<TR>
		    <TD>Date:</td>
			<td>
			
				#Dateformat(Travel.ArrivalDateTime, '#CLIENT.DateFormatShow#')#
					
			</td>
			</tr>
			
			<TR>
		    <TD>Time:</td>
			<td>
			
			   #Timeformat(Travel.ArrivalDateTime, 'HH')#:#Timeformat(Travel.ArrivalDateTime, 'MM')#
			
			
		 	</td>
			</tr>
			
			<TR>
		    <TD>Airline: </td>
			<td>#Travel.AirlineName#</td>
			</tr>
			
			<TR>
		    <TD>Flight No:</td>
			<td>#Travel.AirlineFlightNo#</td>
			</tr>
			
		  </table>
		  
		</td>
		</tr>
		
	</table>
	</td>	
	
</cfoutput>
		
</TABLE>

</td>

</tr>

</table>
