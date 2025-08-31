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
<cfparam name="SESSION.reqNo" default="">
<cfset url.selected = SESSION.reqNo>

<cfif url.selected eq "">

	<cfabort>

</cfif>

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfquery name="Employee" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     DISTINCT P.PersonNo, P.IndexNo, P.FirstName, P.LastName
	FROM       RequisitionLine L INNER JOIN
	           Employee.dbo.Person P ON L.PersonNo = P.PersonNo 
	WHERE      L.RequisitionNo IN (#preservesinglequotes(url.selected)#)
	AND        L.ItemMaster IN (SELECT I.Code 
	                            FROM   ItemMaster I, Ref_EntryClass R
								WHERE  I.EntryClass = R.Code
								AND    (								       
									    R.CustomDialog IN ('Travel','Contract')										  										  
									   )	
								)	   															
	AND        L.ActionStatus = '2k' 
</cfquery>

<cfparam name="URL.PersonNo" default="#Employee.PersonNo#">

<cfform method="POST" name="trvform" style="height:100%">
		
<table height="100%" border="0" width="98%" align="center" style="border-top:1px solid silver">
	
	<tr><td height="8" id="trvresult" colspan="2"></td></tr>
				
	<tr><td height="3" colspan="2"></td></tr>
		
	<tr class="labelmedium">
	   <td width="10%"><cf_tl id="Obligation">:</td>
	   
	    <td style="padding-left:63px"><table>
	       <tr class="labelmedium">
	       <td><input type="radio" name="Select" class="radiol" id="Select" value="add" checked onClick="show('add')"></td>
		   <td style="padding-left:4px"><cf_tl id="New Obligation"></td>
		   <td style="padding-left:8px">
		   <input type="radio" name="Select" class="radiol" id="Select" value="exist" onClick="show('exist');selectedtraveler(document.getElementById('selpersonno').value)">
		   </td>
		   <td style="padding-left:4px"><cf_tl id="Add funds to existing obligation"></td>
		   </tr>
		   </table>
	   </td>
	  
	</tr>

	<tr><td height="3" colspan="2"></td></tr>
	
	<tr id="exist" class="hide">		   	  
 	   <td id="selection" colspan="2" style="padding-left:57px;padding-right:60px"></td>
	</tr>	
		
	<tr id="add" class="regular" height="10" width="100%">
	
	  <td colspan="2">
	  
		<table border="0" class="formpadding">
							
		<tr>
		   <td class="labelmedium" style="width:200px"><cf_tl id="Employee">:</td>
		   <td>
		   
		    <select name="selpersonno" id="selpersonno" class="regularxl" style="font-size:18px;width:290px;height:30px">		
			      <option value="">All</option>		
				  <cfoutput query="Employee">
				     <option value="#PersonNo#" <cfif URL.PersonNo eq PersonNo> SELECTED</cfif>>#IndexNo# #FirstName# #LastName#</option>
				  </cfoutput>
		    </select>
		   
		   </td>
		</tr>
				
		<tr><td height="4"></td></tr>	
		<tr><td height="1" class="line" colspan="2"></td></tr>
		<tr><td height="4"></td></tr>		
			
		<cfquery name="OrderClass" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	    	  SELECT   *
		      FROM     Ref_OrderClass
			  WHERE    (Mission = '#URL.Mission#' OR Mission is NULL)
			  AND      PreparationMode = 'Travel'
			  ORDER BY ListingOrder
		</cfquery>
	
		<tr>
		   <td class="labelmedium" style="width:200px"><cf_tl id="Class">:</td>
		   <td>
		   <table>
	       <tr class="labelmedium">
	       
		   <cfoutput query="OrderClass">
		   <td><input type="radio" name="OrderClass" class="radiol" id="OrderClass" value="#Code#" <cfif currentrow eq "1">checked</cfif>></td>
		   <td style="font-size:18px;padding-left:5px;padding-right:10px"><a href="javascript:workflow('ProcJob','#code#')" title="Preview workflow">#Description#</a></td>	   		   
		   </cfoutput>
		   </tr>
		   </table>
			 
		   </td>
		</tr>
		
		<tr><td height="3"></td></tr>
		
		<cfquery name="OrderType" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
	    	  SELECT *
		      FROM   Ref_OrderType
			  WHERE  Code = '#Parameter.PayrollOrderType#'
		</cfquery>
	
		<tr class="labelmedium">
		   <td><cf_tl id="Order Type">:</td>
		   <td>
		   
		   <select class="regularxl" name="Ordertype" id="Ordertype" style="font-size:18px;width:290px;height:35px">		      
			  <cfoutput query="OrderType" >
			     <option value="#Code#">#Description#</option>
			  </cfoutput>
		   </select>
			 
		   </td>
		</tr>
		
		<cfquery name="GetCustom" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_CustomFields
		</cfquery>
		
		<cfoutput>
		
		<cfif getCustom.PurchaseReference1 neq "">
			
			<tr class="labelmedium">			   
			    <td><font color="808080">#getCustom.PurchaseReference1#:</td>
				<td><cfinput type="Text" name="UserDefined1" value="" required="No" size="30" style="font-size:18px;width:290px;height:35px" class="regularxl"></td>			   
			</tr>
			
			<cfelse>
			
			<input type="hidden" name="Userdefined1" id="Userdefined1" value="">
			
			</cfif>
			
			<cfif getCustom.PurchaseReference2 neq "">
			
			<tr class="labelmedium">
			   
			    <td><font color="808080">#getCustom.PurchaseReference2#:</td>
				<td><cfinput type="Text" name="UserDefined2" value="" required="No" size="30" style="font-size:18px;width:290px;height:35px" class="regularxl"></td>
			   
			</tr>
			
			<cfelse>
			
			<input type="hidden" name="Userdefined2" id="Userdefined2" value="">
			
			</cfif>
			
			<cfif getCustom.PurchaseReference3 neq "">
			
			<tr class="labelmedium">
			   
			    <td><font color="808080">#getCustom.PurchaseReference3#:</td>
				<td><cfinput type="Text" name="UserDefined3" value="" required="No" size="30" style="font-size:18px;width:290px;height:35px" class="regularxl"></td>
			   
			</tr>
			
			<cfelse>
			
			<input type="hidden" name="Userdefined3" id="Userdefined3" value="">
			
			</cfif>
			
			<cfif getCustom.PurchaseReference4 neq "">
			
			<tr class="labelmedium">
			   
			    <td><font color="808080">#getCustom.PurchaseReference4#:</td>
				<td><cfinput type="Text" name="UserDefined4" value="" required="No" size="30" style="font-size:18px;width:290px;height:35px" class="regularxl"></td>
			   
			</tr>
			
			<cfelse>
			
			<input type="hidden" name="Userdefined4" id="Userdefined4" value="">
			
			</cfif>
		
		</cfoutput>
							
		</table>	
				
	</td></tr>
					
	<cfoutput>
	<cf_tl id="Issue Travel Authorization" var="1">
	<cfset vCJ=lt_text>
		
	</cfoutput>
		
	<tr><td colspan="2" style="height:100%" valign="top">
			
		<cfdiv id="travelpending" style="height:100%" 
		  bind="url:SelectLines.cfm?mode=travel&mission=#url.mission#&period={period}&personno={selpersonno}">	
					
	</td></tr>
	
	<cfoutput>
	<tr id="#url.mode#_submit">
	<td colspan="2" style="padding-top:5px;padding-bottom:15px" align="center" id="trvresult">
		
	   <input type="button" 
	     name   = "trvsubmit" 
         id     = "trvsubmit"
		 value  = "#vCJ#" 
		 class  = "button10g" 
		 style  = "height:30;width:260;font-size:14px"
		 onclick= "ptoken.navigate('JobCreateTravelSubmit.cfm?Mission=#URL.Mission#&period=#URL.Period#','trvresult','','','POST','trvform')">
		
	</td>
	</tr>
	</cfoutput>
	
</td></tr>

</table>

</cfform>

