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
<cfparam name="URL.Mission" default="OICT">

<cfquery name="Parameter" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
</cfquery>	

<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT count(*) as total
	FROM   Item
</cfquery>

<cf_menuscript>
<cfajaximport tags="cfform,cflayout-tab,CFINPUT-DATEFIELD">
<cfinclude template="RequestScript.cfm">

<cfparam name="URL.Status" default="1">
<cfparam name="URL.Mode" default="regular">

 <table width="94%" align="center" border="0" cellspacing="0" cellpadding="0">
            
      <tr><td>
            
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
            
            <tr><td height="12" colspan="2"></td></tr>
            						
            <tr>
                <td colspan="3" height="49">
                
                <table width="100%" border="0" class="formpadding">
                                           						
					<cfquery name="Cart" 
						datasource="AppsWorkOrder" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					    SELECT    C.ServiceItemUnit, 
					              C.Reference, 
								  C.DateEffective, 
								  C.DateExpiration, 
								  C.Currency, 
								  C.Amount, 
								  C.Remarks, 
								  C.ActionStatus, 
								  C.Mission, 
								  C.ServiceItem, 
					              C.CartId, 
								  S.Description AS ServiceItemDescription, 
								  U.UnitDescription
					    FROM      Cart AS C INNER JOIN
					              ServiceItem AS S ON C.ServiceItem = S.Code INNER JOIN
					              ServiceItemUnit AS U ON C.ServiceItem = U.ServiceItem AND C.ServiceItemUnit = U.Unit
						WHERE     C.OfficerUserId = '#SESSION.acc#'
					</cfquery>
					                    
                    <tr>
					
					<cfoutput>
                        
                    <td align="left" height="26">
					
						<table cellspacing="0" cellpadding="0">
						<tr><td>
	                    
	                    <INPUT style="width:150px;" class="regularxl" id="find" onkeyup="search()" TITLE="Enter Criteria" MAXLENGTH="255" VALUE="">
	                    <cf_tl id="Search" var="1">
						
						</td>
						<td>
	                    <cf_tl id="Go" var="1">
	                    <input type="button" value="#lt_text#" class="button10s" style="height:25;width:40" onClick="javascript:list('1')">
	                  						
						</td></tr>
						</table>
                    </td>
					
					</cfoutput>
                    
                    <td align="right" width="70%"></td>
                        
                    <cfoutput>		
                    <input type="hidden" name="mission" id="mission" value="#URL.Mission#">					
                    <input type="hidden" name="class" id="class" value="all">
                    
                    <td id="cartshow"
                        style="cursor: pointer;"
                        onClick="cart()">
                                <cfif cart.recordcount neq "0">			
                                <img src="#SESSION.root#/images/refresh.png" alt="" onclick="cart()" align="absmiddle" border="0">
                                </cfif>
                    </td>
                    <td>
                    <cfif cart.recordcount neq "0">			
                                [#Cart.recordCount#&nbsp;item<cfif #Cart.RecordCount# gt "1">s</cfif>]
                    </cfif>
                    </td>	
                            
                    <cfquery name="Pending" 
                    datasource="AppsMaterials" 
                    username="#SESSION.login#" 
                    password="#SESSION.dbpw#">
                    SELECT     top 1 Reference
                    FROM       Request R
                    WHERE      R.Status IN ('i','1','2','2b')
                      AND      R.OfficerUserId = '#SESSION.acc#'  
                    </cfquery>
                            
                    <cfif Pending.recordcount gte "1">
                    
                        <td align="right" onclick="reqstatus('pending')"  style="cursor: pointer;">
                        <img src="#SESSION.root#/images/pending.gif" align="absmiddle" alt="" border="0">					
                        </td>
                    
                    </cfif>
										                    
                    <cfquery name="Shipped" 
                    datasource="AppsMaterials" 
                    username="#SESSION.login#" 
                    password="#SESSION.dbpw#">
                        SELECT     TOP 1 Reference
                        FROM       Request R
                        WHERE      R.Status IN ('3')
                          AND      R.OfficerUserId = '#SESSION.acc#'  
                    </cfquery>
                            
                    <cfif Shipped.recordcount gte "1">
                    
                        <td align="right" onclick="reqstatus('shipped')"  style="cursor: pointer;">
                        <img src="#SESSION.root#/images/Submit.png" align="absmiddle" alt="Shipped Orders" border="0">					
                        </td>
                    
                    </cfif>					
                            
                    </cfoutput>
                        
                    </tr>
					                    
                    </table>
                
                </tr>
                
                <tr><td height="1" colspan="3" class="line"></td></tr>
					                    
                <td>
                    
                    <td align="left" width="40%" valign="top">
                    
                        <table border="0" width="100%" height="100%" class="formpadding" cellspacing="0" cellpadding="0">
                         
	                        <tr>
							<td width="200" height="29" class="labellarge">                       
	                        <b>&nbsp;&nbsp;<cf_tl id="My"><cf_tl id="favorite">5<cf_tl id="services">&nbsp;&nbsp;&nbsp;&nbsp;</b></td>
							</tr>
	                        <tr><td height="1" class="line"></td></tr>
							
	                        <tr><td>
	                    
	                        <cfquery name="top5" 
	                        datasource="AppsWorkOrder" 
	                        username="#SESSION.login#" 
	                        password="#SESSION.dbpw#">
								SELECT     TOP 5 I.Code, I.Description
								FROM         Request R INNER JOIN
								                      RequestLine RL ON R.RequestId = RL.RequestId INNER JOIN
								                      ServiceItem I ON RL.ServiceItem = I.Code
								WHERE     R.OfficerUserId = '#SESSION.acc#'
								GROUP BY   I.Code, I.Description
								ORDER BY COUNT(*) DESC						
	                        </cfquery>
	                    
	                            <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="left">
	                           
	                               <tr><td height="1"></td></tr>
	                               <cfoutput query="top5">                               
	                                <TR>
	                                    <td width="20" align="center"><img src="#SESSION.root#/images/pointer.gif" alt="#Description#" border="0"></td>
	                                    <td height="22" class="labelmedium">
	                                    <A href="javascript:add('#code#','0000')">#Description#</td>
	                                </TR>					
	                               </cfoutput>
	                         
	                            </table> 
	                        
	                        </td></tr>
                            
                        </table>  
                                       
                    </td>
                    
                    <td width="59%"
                        align="right"
                        valign="top"
                        style="border-left: 1px dotted Silver">
                    
                        <table width="100%" border="0" class="formpadding" cellspacing="0" cellpadding="0" align="right">
						
                        <tr><td height="14">
                       
						<!---&nbsp;
                        <b><cf_tl id="List Items"> <cf_tl id="by service type"></b></td>
						--->
						</tr>
						<!---
                        <tr><td height="1" bgcolor="silver"></td></tr>
						--->
                                    
                        <cfquery name="ServiceClass" 
                            datasource="AppsWorkOrder" 
                            username="#SESSION.login#" 
                            password="#SESSION.dbpw#">
                            SELECT    *
                            FROM     ServiceItemClass 
                            WHERE    Code IN (SELECT ServiceClass 
                                              FROM   ServiceItem 
                                              WHERE Code IN (SELECT ServiceItem 
                                                             FROM   ServiceItemMission 
                                                             WHERE  Operational = 1
															 AND    Mission = '#url.mission#'))			
                            ORDER BY ListingOrder
                        </cfquery>
                        
                        <cfoutput>
						
                        <input type="hidden" name="searchgroup" id="searchgroup" value="#ServiceClass.recordcount#">
						
                        </cfoutput>
                        
                        <tr><td>
                             <table width="100%" cellspacing="0" cellpadding="0">  
							    		 
                              <cfoutput query="ServiceClass">
							  
                              <cfif CurrentRow Mod 2><TR></cfif>
                                <td id="1_#Currentrow#" width="4%" align="center" height="22">
                                    <img src="#SESSION.root#/images/point_small.JPG" align="absmiddle" alt="" width="10" height="11" border="0">
                                </td>
                                <td width="41%" class="labelmedium" id="2_#Currentrow#" 
								   style="cursor:pointer;" onClick="catsel('#Code#','#currentRow#')">#Description#</td>
                              <cfif CurrentRow Mod 2><cfelse></tr>
                                  <cfif CurrentRow neq Recordcount>
                                      <tr><td colspan="4" class="line"></td></tr>
                                  </cfif>
                              </cfif>
                              </cfoutput>		

                              </table>     

                         </td></tr>	 
                      </table>
                        
                    </td>		
                    </tr>	
					
					<tr class="line"><td colspan="3"></td></tr>
                
                    <tr><td colspan="3" align="center" id="reqtop" style="padding-top:4px"></td></tr>
                            
                    <tr><td colspan="3" align="center" style="padding-top:4px" id="reqmain">	
                                      
                        <cfif URL.Mode eq "history">
					
                           <cfinclude template="HistoryList.cfm">
						   
                        <cfelseif URL.Mode eq "Cart">
					
                           <cfinclude template="Cart.cfm">   
						   
                        </cfif>		
                                                           
                    </td></tr>                            
                      
	            </table>
            
        </td></tr>
           
    </table>
			
