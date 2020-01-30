<cfparam name="SESSION.reqNo" default="">
<cfset url.selected = SESSION.reqNo>

<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_ParameterMission
	  WHERE  Mission = '#URL.Mission#'
</cfquery>

<cfform method="POST" name="poform" style="height:100%">

	<table width="100%" style="height:100%">
		
		<tr><td height="8" id="poresult"></td></tr>
					
		<tr><td height="3"></td></tr>
			
		<tr class="regular">
			
		  <td colspan="2">
		  
			<table border="0" cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr><td height="1" colspan="2" class="line"></td></tr>
			
			<tr><td height="4"></td></tr>		
			
			<tr>
			<td class="labelmedium" width="200"><cf_tl id="Vendor">:</b></td>
			<td>
			
				<cfoutput>
						
					<cfquery name="GetVendor" DataSource="AppsPurchase">
						SELECT TreeVendor 
						FROM   Ref_ParameterMission
						WHERE  Mission = '#URL.Mission#'
					</cfquery>
					
					<table><tr>
						<td style="padding-right:2px"> 					  
							   <input type="text" name="vendororgunitname" id="vendororgunitname" value="" class="regularxl enterastab" size="60" maxlength="60" readonly>
							   <input type="hidden" name="vendororgunitmission" id="vendororgunitmission">
						   	   <input type="hidden" name="vendororgunit" id="vendororgunit" value="">
					    </td>
						<td>
									
				     <img src="#SESSION.root#/Images/search.png" alt="Select Unit" name="img1" 
						  onMouseOver="document.img1.src='#SESSION.root#/Images/search.png'" 
						  onMouseOut="document.img1.src='#SESSION.root#/Images/search.png'"
						  class="enterastab"					  
						  style="cursor: pointer;border-radius:2px" alt="" width="26" height="25" border="0" align="absmiddle" 
						  onclick="selectorgN('#GetVendor.TreeVendor#','operational','vendororgunit','applyorgunit','','1','modal')">
									  
						</td>
						
						</tr>
					</table>		   					   
							   
				</cfoutput>		   
			
			</td></tr>			
			
			<tr class="labelmedium">
			   <td><cf_tl id="Purchase Order">:</td>
			   <td>
				   <input type="radio" name="Select" class="radiol" id="Select" value="add" checked onClick="show('add')"><cf_tl id="New">
				   <input type="radio" name="Select" class="radiol" id="Select" value="exist" onClick="show('exist');selected(document.getElementById('vendororgunit').value)"><cf_tl id="Existing">		   
			   </td>
			</tr>
			
			<tr id="exist" class="hide">				
			   <td></td>	  
		 	   <td id="selection"></td>
			</tr>	
						
			<cfquery name="OrderClass" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
		    	  SELECT   *
			      FROM     Ref_OrderClass R
				  WHERE    (Mission = '#URL.Mission#' or Mission is NULL)
				  AND      PreparationMode = 'Direct'
				  AND      Code IN (SELECT Code 
				                  FROM   Ref_OrderClassMission 
							      WHERE  Mission = '#url.mission#'
							      AND    Code = R.Code)	
				  ORDER BY ListingOrder
			</cfquery>
			
			<cfif OrderClass.recordcount eq "0">
			
				<cfquery name="OrderClass" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  SELECT    *
			      FROM      Ref_OrderClass R
				  WHERE    (
				             Mission = '#URL.Mission#' 
							 OR Mission is NULL 
							 OR Mission IN (SELECT Mission FROM Ref_OrderClassMission WHERE Code = R.Code)
						   )	 
				  AND      PreparationMode = 'Direct'
				  ORDER BY ListingOrder
				 </cfquery> 
					
			</cfif>
					
			<tr id="add">
			
			   <td class="labelmedium"><cf_tl id="Class">:</td>
			   
			   <td>
			   
			   <table>
			   
			   <tr>
			   
			   <!--- only if the person has access to this class as ProcManager or ProcApprover --->
			   
			   <cfinvoke component      = "Service.Access"
						   Method         = "RoleAccess"
						   Mission        = "#url.mission#"
						   Role           = "'ProcManager'"
						   AccessLevel    = "'EDIT','ALL'"				   					  
						   ReturnVariable = "ManagerAccess">	
						   
			   <cfset show = "0">
						   
			   <cfoutput query="OrderClass">
			   
			       <cfinvoke component="Service.Access"
					   Method         = "procApprover"
					   Mission        = "#url.mission#"
					   OrderClass     = "#code#"
					   ReturnVariable = "ApprovalAccess">	
						   
				   <cfif ApprovalAccess eq "EDIT" or ApprovalAccess eq "ALL" or ManagerAccess eq "GRANTED">		
				   
				       <cfset show = "1">	
						   
					   <td><input type="radio" 
					             class="radiol enterastab" 
								 name="OrderClass" 
								 id="OrderClass" 
								 value="#Code#" <cfif currentrow eq "1">checked</cfif>></td>
					   <td style="padding-left:4px;padding-right:10px" class="labelmedium">
						   <a href="javascript:workflow('ProcJob','#code#')" title="Preview workflow">#Description#</a>	   
					   </td>
				   
				   </cfif>
				   			   
			   </cfoutput>  
			   
			   <!--- --------------------------------------------------------------------------- --->
			   <!--- if nothing is shown we make sure we show any to have backward compatibility --->
			   <!--- --------------------------------------------------------------------------- --->
				   
			   <cfif show eq "0">
				   
				    <cfoutput query="OrderClass">
					
					   <td>	<input type="radio" 
					           class  = "radiol enterastab" 
							   name   = "OrderClass" 
							   id     = "OrderClass" 
							   value  = "#Code#" <cfif currentrow eq "1">checked</cfif>>
					   </td>
					   
					   <td style="padding-left:4px;padding-right:10px" class="labelmedium">
						   <a href="javascript:workflow('ProcJob','#code#')" title="Preview workflow">#Description#</a>	   
					   </td>
					   
				    </cfoutput>
								   
			   </cfif>
				
							
			<cfquery name="OrderType" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   Ref_OrderType R
				WHERE  Code IN (SELECT Code 
				                FROM   Ref_OrderTypeMission 
							    WHERE  Mission = '#url.mission#'
							    AND    Code = R.Code)	
				ORDER  BY R.ListingOrder
			</cfquery>
			
			<cfif OrderType.recordcount eq "0">
			
				<!--- show all --->
				
				<cfquery name="OrderType" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_OrderType R	
					ORDER  BY R.ListingOrder
				</cfquery>
			
			</cfif>		
						
			   <td class="labelmedium" style="padding-left:10px;padding-right:10px"><cf_tl id="Order Type">:</b></td>
			   <td>
			   
			   <select name="Ordertype" id="Ordertype" class="regularxl enterastab">
				  <cfoutput query="OrderType" >
				     <option value="#Code#">#Description#</option>
				  </cfoutput>
			   </select>
				 
			   </td>
				
			   <td class="labelmedium" style="padding-left:10px;padding-right:10px"><cf_tl id="Issue"> <cf_tl id="Currency">:</b></td>
			   <td id="currencybox">
			   
			   <cfquery name="CurrencyList" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT    *
				FROM      Accounting.dbo.Currency
				WHERE     EnableProcurement = '1'
			</cfquery>
			   
			   <select name="Currency" id="Currency" class="regularxl enterastab">
				  <cfoutput query="CurrencyList">
				     <option value="#Currency#" <cfif currency eq Application.baseCurrency>selected</cfif>>#Currency#</option>
				  </cfoutput>
			   </select>
				 
			   </td>
			   
			   <td style="padding-left:10px;padding-right:10px"><cf_tl id="Unit">:</td>
			   <td>
			   
			   <cfquery name="Root" 
			 	datasource="AppsOrganization" 			
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   Org.OrgUnit, Org.OrgUnitName
					FROM	 Ref_MissionPeriod P INNER JOIN
				             Ref_Mandate M ON P.Mission = M.Mission AND P.MandateNo = M.MandateNo INNER JOIN
				             Organization Org ON M.Mission = Org.Mission AND M.MandateNo = Org.MandateNo
					WHERE    P.Mission = '#URL.Mission#'
					AND      P.Period  = '#URL.Period#'
					AND      (ParentOrgUnit is NULL or ParentOrgUnit = '' or Autonomous = 1)
					ORDER BY HierarchyCode
				</cfquery>		
				
				<cfquery name="DefaultRoot" 
			 	datasource="AppsPurchase" 			
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    TOP 1 Parent.OrgUnit
					FROM      RequisitionLine L INNER JOIN
			                  Organization.dbo.Organization O ON L.OrgUnit = O.OrgUnit INNER JOIN
		    	              Organization.dbo.Organization Parent ON O.Mission = Parent.Mission AND O.MandateNo = Parent.MandateNo AND O.HierarchyRootUnit = Parent.OrgUnitCode
					WHERE     L.RequisitionNo IN (#preserveSingleQuotes(url.selected)#)
					ORDER    BY Parent.Created	
				</cfquery>				
				
				<select name="OrgUnit" class="regularxl">
					<cfoutput query="root">
						<option value="#OrgUnit#"<cfif defaultRoot.OrgUnit eq Orgunit>selected</cfif>>#OrgUnitName#</option>
					</cfoutput>
				</select>
				
				</td>
			   
				</tr>
				
				</table> 
				
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
				
				<tr>
				   
				    <td class="labelmedium"><font color="808080">#getCustom.PurchaseReference1#:</td>
					<td>
					    <cfinput type="Text" name="UserDefined1" value="" required="No" size="30" maxLength="30" style="text-align: left" class="regularxl enterastab">		   
					</td>
				   
				</tr>
				
				<cfelse>
				
				<input type="hidden" name="Userdefined1" id="Userdefined1" value="">
				
				</cfif>
				
				<cfif getCustom.PurchaseReference2 neq "">
				
				<tr>
				   
				    <td class="labelmedium">#getCustom.PurchaseReference2#:</td>
					<td>
					    <cfinput type="Text" name="UserDefined2" value="" required="No" size="30" maxLength="30" style="text-align: left" class="regularxl enterastab">		   
					</td>
				   
				</tr>
				
				<cfelse>
				
				<input type="hidden" name="Userdefined2" id="Userdefined2" value="">
				
				</cfif>
				
				<cfif getCustom.PurchaseReference3 neq "">
				
				<tr>
				   
				    <td class="labelmedium">#getCustom.PurchaseReference3#:</td>
					<td>
					    <cfinput type="Text" name="UserDefined3" value="" required="No" size="30"  maxLength="30" style="text-align: left" class="regularxl enterastab">		   
					</td>
				   
				</tr>
				
				<cfelse>
				
				<input type="hidden" name="Userdefined3" id="Userdefined3" value="">
				
				</cfif>
				
				<cfif getCustom.PurchaseReference4 neq "">
				
				<tr>
				   
				    <td class="labelmedium">#getCustom.PurchaseReference4#:</td>
					<td>
					    <cfinput type="Text" name="UserDefined4" value="" required="No" size="30" maxLength="30" style="text-align: left" class="regularxl enterastab">		   
					</td>
				   
				</tr>
				
				<cfelse>
				
				<input type="hidden" name="Userdefined4" id="Userdefined4" value="">
				
				</cfif>
			
			</cfoutput>
								
			</table>	
					
		</td></tr>
				
		<tr class="line"><td height="1" colspan="2"></td></tr>	
			
		<cfoutput>
		<cf_tl id="Record Obligation" var="1">
		<cfset vCJ="#lt_text#">
			
		</cfoutput>
			
		<tr><td style="height:100%;border:0px solid silver" colspan="2" valign="top">
										
		<cfdiv id="popending" style="height:100%"
		    bind="url:SelectLines.cfm?mode=quick&mission=#url.mission#&period={period}">	
							
		</td></tr>
		
		<cfoutput>
		
		<tr><td colspan="2" align="center" id="poresult" style="padding-top:4px">
			
		<cfset sel = replace(url.selected,"'",":",  "all")> 
			
		   <input type="button" 
		     name="posubmit" 
	         id="posubmit"
			 value="#vCJ#" 
			 style="font-size:13px;width:240;height:28"
			 class="button10g" 
			 onclick="ptoken.navigate('JobCreatePurchaseSubmit.cfm?Mission=#URL.Mission#&period=#URL.Period#','poresult','','','POST','poform')">
			 
		</td></tr>
		
		</cfoutput>
		
	</td></tr>
	
	</table>

</cfform>
