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
<cfoutput>

	<cfquery name="TripCost" 
	 datasource="AppsPayroll" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT *
		 FROM   ClaimEventIndicatorCost
		 WHERE  ClaimEventId = '#URL.ID1#'
		   AND  IndicatorCode  = '#IndicatorCode#' 
		   AND  CostLineNo = '#ln#'
	</cfquery>
										
	<tr>
	<td height="28" width="20" align="center">#ln#</td>
	
	<td>
			
     <cfif TripCost.InvoiceDate eq "">
	 
	 
	       <cfinput type="Text"
		       name="InvoiceDate_#IndicatorCode#_#ln#"
		       value="#Dateformat(now(), CLIENT.DateFormatShow)#"
		       width="5"
		       message="Please enter a valid date"
		       validate="eurodate"
		       required="No"
		       visible="Yes"
			   style="text-align: center;"
		       enabled="Yes"
		       size="9">
									
	 <cfelse>
	
			
		   <cfinput type="Text" 
			 name="InvoiceDate_#IndicatorCode#_#ln#" 
			 value="#Dateformat(TripCost.InvoiceDate, CLIENT.DateFormatShow)#" 
			 validate="eurodate" 
			 message="Please enter a valid date"
			 required="No" 
			 width="5"
			 size="9"
			 style="text-align: center;"
			 visible="Yes" 
			 enabled="Yes">
												
	</cfif>
							
	</td>

	<td>
	    <input
		 type="text" 
	     name="Description_#IndicatorCode#_#ln#" 
		 value="#TripCost.Description#"
	     size="25" 
		 maxlength="50">
	</td>
	<td>
		 <input 
	     type="text" 
		 value="#TripCost.InvoiceNo#"
		 name="InvoiceNo_#IndicatorCode#_#ln#" 
		 size="25" 
		 maxlength="30">
	</td>

	<td align="right">
	<select name="InvoiceCurrency_#IndicatorCode#_#ln#" style="text-align: center;">
		<cfif #TripCost.InvoiceCurrency# eq "">
			<cfloop query="Currency">
			      <option value="#Currency#" <cfif Base.Currency eq "#Currency#">selected</cfif>>
				  #Currency#
				  </option>
			</cfloop>
		
		<cfelse>
			<cfloop query="Currency">
			      <option value="#Currency#" <cfif #TripCost.InvoiceCurrency# eq "#Currency#">selected</cfif>>
				  #Currency#
				  </option>
			</cfloop>
		</cfif>
	</select>
		
	&nbsp;
	<cfinput type="Text"
       name="InvoiceAmount_#IndicatorCode#_#ln#"
       value="#TripCost.InvoiceAmount#"
       message="Please enter a valid amount"
       validate="float"
       required="No"
       visible="Yes"
       enabled="Yes"
       size="10"
	   maxlength="15">
	   
	</td>
</tr>

</cfoutput>