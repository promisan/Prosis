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
<cfoutput>

	<table align="center" cellspacing="0" cellpadding="0" class="formspacing">
		<tr>
			
			<cfif vSearch eq "Yes">
			
				<td>&nbsp;</td>				
				<td width="120">
				
				   <table cellspacing="0" cellpadding="0" border="0">
				     
					 <tr>
				  
					  <td><cf_space spaces="45">				 				 
						  <input type="text" name="criteria" class="regular3" id="criteria">
					  </td>
					  <td width="30" align="center" bgcolor="f4f4f4">
					    <cf_space spaces="10">	
						<img src="#SESSION.root#/Images/locate3.gif" 
							alt="Search" 
							border="0" 
							height="11" 
							width="11"
					        align="absmiddle" 
							style="cursor: pointer;" 
							onClick="searchobject()">		
					   </td>
				   
				     </tr>
				   
				   </table>
						
				</td>				
				<td width="2"></td>
			
			</cfif>	
			
			<td>
									
				<cf_tl id="Refresh" var="1">
				
				<input type="button" 
		           class="button10g" 
				   style="height:25;width:140px;font-size:13px" 
				   onclick="history.go()"
				   name="Submit" 
				   value="#lt_text#">
				 
				<!--- show save only if some of the modes are direct entry mode --->				   
				
				<cf_tl id="View" var="1">
				   
				 <input type="button" 
		           class="button10g" style="height:25;width:140px;font-size:13px" 
				   name="View" 
				   onclick="viewallot()"
				   value="#lt_text#">  				   			 
			  
			</td>				
			
			
			 <cfif objectfilter eq "0"> 	 
						 
			      <td align="right" style="padding-right:1px">
				  
				  <cf_calendarscript>
		
					<cf_intelliCalendarDate9
					FieldName="TransactionDate" 
					Manual="True"	
					class="regularxl"						
					DateValidStart="#Dateformat(Period.DateEffective, 'YYYYMMDD')#"
					DateValidEnd="#Dateformat(Period.DateExpiration, 'YYYYMMDD')#"
					Default="#dateformat(now(),client.dateformatshow)#"
					AllowBlank="False">	
				  
				  </td>			  				  
			 
			 	  <td align="right" style="padding-right:1px">
									
				  <cf_tl id="#ActionString#" var="1">
					
				  <input type="submit" 
			           class="button10g" style="height:25;width:140px;font-size:13px" 
					   name="Submit" 
					   value="#lt_text#">				   
					   
				  </td> 
				   
			</cfif>    
						
		</tr>
	</table>
	
</cfoutput>	