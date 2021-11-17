
<cfparam name="Object.ObjectKeyValue1"  default="">

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue1 neq "">
	<cfset url.id = Object.ObjectKeyValue1>	
</cfif>

<!--- temp provision only on request of FMS/OICT --->

<!--- end temp provision --->

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*
    FROM   RequisitionLine L
	WHERE  RequisitionNo = '#URL.ID#'
</cfquery>

<cfquery name="EntryClass" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   ItemMaster I,
	       Ref_EntryClass L
	WHERE  I.EntryClass = L.Code
	AND    I.Code = '#Line.ItemMaster#'
</cfquery>

<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_DialogREMProgram>


<cfinclude template="../Travel/TravelScript.cfm">

	<cfinclude template="RequisitionEditPrepare.cfm">
			
	<cfoutput>		
	<input type="hidden" name="serviceinput" id="serviceinput" value="No">
	<input type="hidden" name="mission" id="mission" value="#Line.Mission#">
	</cfoutput>
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#Line.Mission#' 
	</cfquery>
	
	<cfquery name="Mandate" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_MissionPeriod
		WHERE  Mission = '#Line.Mission#' 
		AND    Period = '#Line.Period#'
	</cfquery>

	<cfif Parameter.EnableRequisitionEdit eq "1" and url.mode neq "workflow">

	  <!--- ------------------------------ --->
	  <!--- always allow for editing lines --->
	  <!--- ------------------------------ --->
	  
	  <cfset Access = "Edit">    
	  
	</cfif>
	
	<cfif url.mode eq "Budget" and Line.ActionStatus lt "3">
		<cfset Access = "Limited">
	</cfif>
			
	<cfif Line.JobNo neq "" and Access eq "Edit" and (Line.ActionStatus eq "2k" or Line.ActionStatus eq "2q")>
	      <!--- at job/buyer level only limited changes can be made ---> 
	      <cfset Access = "Limited">
	</cfif>
	
	<cfinvoke component = "Service.Access"  
	   method           = "RoleAccess" 
	   SystemFunction   = "Requisition"
	   Mission          = "#Line.Mission#"
	   AccessLevel      = "'1','2'" 	  
	   returnvariable   = "accessmodule">		
	   	   		
	<cfif (Line.ActionStatus gte "3" or (accessModule eq "DENIED" and access neq "limited"))>
	     <!--- purchase order created or user has no access, then we limit no matter what  --->
	     <cfset Access = "View">    
		 
	</cfif>
		
	<!--- 18/5/2009 allow for limited substantive changes once the requisition is access for workflow
	processing --->		
			
	<cfif url.mode eq "workflow" and access eq "view">
	
	    <!--- -------------------------------------------------------------------------------- --->
	    <!--- if accessed through the workflow determin the access rights based on open action --->
		<!--- -------------------------------------------------------------------------------- --->

	    <cf_workflowformaccess 
	        entityCode="ProcReview" 
			objectkey1="#Line.requisitionNo#">
	 
	    <cfif wfformaccess eq "EDIT">	  
	       <cfset access = "Limited">
	    <cfelse>
	       <cfset access = "View">	
	    </cfif>
	  
	</cfif>	
					
	<cfif url.archive eq "1">
		<cfset access = "view">
	<cfelse>	
		<cfinclude template="RequisitionEditScript.cfm">
	</cfif>
	
	<cf_tl id="Beneficiaries" var="lblBeneficiaries">
	
	<cfoutput>
		<script>
			function selectBeneficiary(per, w) {
				ptoken.navigate('#session.root#/procurement/application/requisition/travel/beneficiary/setBeneficiary.cfm?requisitionno=#Line.requisitionNo#&access=#access#&personno='+per, 'divGetBeneficiary');
				w.close();
			}
			
			function removeBeneficiary(id) {
				ptoken.navigate('#session.root#/procurement/application/requisition/travel/beneficiary/beneficiarypurge.cfm?requisitionno=#Line.requisitionNo#&access=#access#&beneficiaryid='+id, 'divBeneficiary');
			}
			
			function editBeneficiary(id) {
				ProsisUI.createWindow('dialogbeneficiary', '#lblBeneficiaries#', '',{x:100,y:100,height:400,width:600,resizable:true,modal:true,center:true});
				ptoken.navigate('#session.root#/procurement/application/requisition/travel/beneficiary/beneficiaryedit.cfm?requisitionno=#Line.requisitionNo#&access=#access#&beneficiaryid='+id,'dialogbeneficiary');
			}
		</script>
	</cfoutput>

<cf_divscroll>	


						
<table width="100%" height="100%">

<tr><td height="100%" valign="top" style="padding-top:4px;padding-right:20px">
   		
	<table width="98%" class="formspacing" border="0">
		
	<tr><td style="min-width:170px"></td><td width="100%"></td></tr>
	
	<tr class="xhide"><td id="process"></td></tr>

	<!--- --------------------------------- --->
	<!--- --- 1 - 4 Standard Fields-------- --->
	<!--- --------------------------------- --->
						
	<tr class="labelmedium">
	<cfoutput>
	
	<cfif Access eq "View" or Access eq "Limited">
		
		<td><cf_tl id="Period">:</td>
		<TD>#Line.Period#</td>
						
		<input type="hidden" name="period" id="period" value="#Line.Period#">
		
	<cfelse>
	
		<cfquery name="Check" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	       SELECT * 
		   FROM   Ref_Period
		   WHERE  Period = '#url.Period#' 
		   AND    IncludeListing = 1
	    </cfquery>
			
		<cfquery name="PeriodList" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		  SELECT  R.*, M.MandateNo 
	      FROM    Ref_Period R, 
		          Organization.dbo.Ref_MissionPeriod M
	      WHERE   IncludeListing = 1
		 
		  AND   (
		  
		  		 (
					M.EditionId != ''  <!--- meant for budget execution --->				
					     AND     
					R.Procurement = 1 <!--- this period is defined as a procurement period ---> 
				 )
		  
		        OR   
		  
		  	    R.Period IN (SELECT Period as Period
		                        <!--- period is indeed used --->
		                       FROM   Purchase.dbo.RequisitionLine
							   UNION 
							    <!--- period is default --->
							   SELECT DefaultPeriod as Period
							   FROM   Purchase.dbo.Ref_ParameterMission 
							   WHERE  Mission = '#Line.Mission#' 
							   )
				)			   
							   
	      AND     M.Mission = '#Line.Mission#'
	      AND     R.Period = M.Period		
		
	    </cfquery>
		
		<cfif url.period eq "">
		
		   <cfset url.period = periodList.period>		   
					   
			<cfquery name="set" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequisitionLine 
				SET    Period = '#url.period#'
				WHERE  RequisitionNo = '#URL.ID#'
			</cfquery>
			
		</cfif>
								
		<TD><cf_tl id="Period">:</TD>
		
		<TD width="85%">
		  <cfif (Check.recordcount eq "0" or Line.actionStatus gt "2") and getAdministrator(line.mission) eq "0">
		  
		  	#Line.Period#
			<input type="hidden" name="period" id="period" value="#Line.Period#">
		  
		  <cfelse>
		  
			  <select name="period" id="period" class="regularxxl enterastab" 
				  onChange="changeperiod('#URL.ID#',this.value,'#access#')">
			  	  <cfloop query="PeriodList">
			    	 <option value="#Period#" <cfif url.Period eq Period> SELECTED</cfif>>#Period#</option>
				  </cfloop>
		      </select>
			  
		  </cfif>
	    </td>
	</cfif>
	</cfoutput>
	</tr>
				
	<TR class="labelmedium">
	
    <TD>	
	
	    <cfif Line.OrgUnit eq "" and Line.ActionStatus gte "1">
        	<font color="FF0000"><b>* <cf_tl id="Funding Unit">:<font color="FF0000">*</font>
		<cfelse>
			<cf_tl id="Funding Unit">: <font color="FF0000">*</font>
		</cfif>
	</TD>
	
	<TD>	
	
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Organization 
		WHERE  OrgUnit   = '#Line.OrgUnit#'
	</cfquery>

	<cfoutput>
	
		<cfif Access eq "View" or Access eq "Limited">
		
			#Org.Mission# - #Org.orgunitName#
			
		<cfelse>
		
			<table>
			
			<tr>
			 	
			 <td>
            
				 <input type="text"   name="orgunitname1"  id="orgunitname1" class="regularxxl enterastab" value="#Org.orgunitName#" size="65" maxlength="80" readonly>					  
				 <input type="hidden" name="mission1"      id="mission1"      value="#Org.Mission#"> 
				 <input type="hidden" name="orgunitcode1"  id="orgunitcode1"  value="#Org.orgunitcode#">
			   	 <input type="hidden" name="orgunitclass1" id="orgunitclass1" value="#Org.orgunitclass#"> 
			 
			 </td>
			 
			  <td style="padding-left:1px">		
			       
			  <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
				  onMouseOver="document.img0.src='#SESSION.root#/Images/search.png'" 
				  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
				  style="cursor: pointer;border:1px solid silver;height:26px" alt="" width="25" height="25"  align="absmiddle" 
				  onClick="selectorgroleN('#mis#','',document.getElementById('period').value,'ProcReqEntry','orgunit','applyorgunit','1','modal','enable')"> 
				 				  
			 </td>
			 
			 <td style="padding-left:5px;">
			 	<cf_tl id="Show Projects" var="1">				
				<cf_img icon="open" onclick="showProjectListing('#line.mission#','#line.period#');" tooltip="#lt_text#">
			 </td>			
			 
			 </tr>
			 
			 </table>
		 
		</cfif>
		
		<input type="hidden" name="orgunit1" id="orgunit1"  value="#Org.orgunit#">
		
	</cfoutput>
	
	</TD>
	</tr>	
		
	<cfquery name="Org" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Organization 
		<cfif Line.OrgUnitImplement eq "">
		WHERE  OrgUnit   = '#Line.OrgUnit#'
		<cfelse>
		WHERE  OrgUnit   = '#Line.OrgUnitImplement#'
		</cfif>
	</cfquery>
	
	<TR  class="labelmedium">
	
    <TD>	
	
	    <cfif Line.OrgUnitImplement eq "" and Line.ActionStatus gte "1">
        	<font color="FF0000"><b>* <cf_tl id="Implementing Unit">:<font color="FF0000">*</font>
		<cfelse>
			<cf_tl id="Implementing Unit">: <font color="FF0000">*</font>
		</cfif>
	</TD>
	
	<TD>	

	<cfoutput>
	
		<cfif Access eq "View" or Access eq "Limited">
		
			#Org.Mission# - #Org.orgunitName#
			
		<cfelse>
		
			<table>
			<tr>
						 
			 <td>
            
				 <input type="text"   name="orgunitname2"  id="orgunitname2" class="regularxxl" value="#Org.orgunitName#" size="65" maxlength="80" readonly>					  
				 <input type="hidden" name="mission2"      id="mission2"      value="#Org.Mission#"> 
				 <input type="hidden" name="orgunitcode2"  id="orgunitcode2"  value="#Org.orgunitcode#">
			   	 <input type="hidden" name="orgunitclass2" id="orgunitclass2" value="#Org.orgunitclass#"> 
			 
			 </td>
			 
			  <td style="padding-left:1px">			
			       
			  <img src="#SESSION.root#/Images/search.png" alt="Select implementing unit" name="img9" 
			  onMouseOver="document.img9.src='#SESSION.root#/Images/search.png'" 
			  onMouseOut="document.img9.src='#SESSION.root#/Images/search.png'"
			  style="cursor: pointer;border:1px solid silver;height:26px" alt="" width="25" height="25" align="absmiddle" 
			  onClick="selectorgroleN('#mis#','',document.getElementById('period').value,'ProcReqEntry','orgunit','applyorgunit','2','modal','disable')">
			  
			 </td>
			
			 
			 </tr>
			 </table>
		 
		</cfif>
		
		<input type="hidden" name="orgunit2" id="orgunit2"  value="#Line.OrgUnitImplement#">
		
	</cfoutput>
	
	</TD>
	</tr>	
		
	<cfif Parameter.enableCaseNo eq "1">
				
		<cfif Access eq "View" or Access eq "Limited">
			
			   <cfif Line.caseNo neq "">
			
					<tr class="labelmedium">
					<td><cf_tl id="CaseNo">:</td>		
					<td> 
						<cfoutput>
						  #Line.CaseNo#<input type="hidden" name="CaseNo" id="CaseNo" value="#Line.CaseNo#" maxlength="20">
						</cfoutput>
					</td>
					</tr>
				
			   </cfif>	
						
		<cfelse>
			
			<tr class="labelmedium">
		
			<td><cf_tl id="CaseNo">: <font color="FF0000">*</font></td>		
		
			<td>
			
				<table>
				
					<tr class="labelmedium">
						
						<td>
					
							<cfif Parameter.ExecutionRequestReferenceCheck eq "1">
						    	<cfset sc = "ptoken.navigate('#SESSION.root#/procurement/application/requisition/requisition/RequisitionCaseNoCheck.cfm?caseno='+this.value+'&requisitionno=#url.id#','casenocheck')">		 
							<cfelse>		
							    <cfset sc = "">		 
							</cfif>
						  
							<cfoutput>	
								
								<input type="text" name="CaseNo" id="CaseNo" class="regularxl" value="#Line.CaseNo#" size="20" onchange="#sc#" maxlength="20">
								 
							</cfoutput>
						
						</td>	
											
						<td>&nbsp;</td>						
						
						<td id="casenocheck"></td>
						
					</tr>
					
				</table>
			
			</td>
			</tr>
						
		</cfif>	
			
	<cfelse>

		<cfoutput>								
			<input type="hidden" name="CaseNo" id="CaseNo" value="#Line.CaseNo#">
		</cfoutput>	
	
    </cfif>	
			
	<tr class="labelmedium" style="height:30px">
	
	    <td><cf_tl id="Submission Date">: <font color="FF0000">*</font></td>
		
		<td style="z-index:2; position:relative;" class="labelmedium">		
				
		<cfif Access eq "View">
		
			<cfoutput>
				#Dateformat(Line.RequestDate, CLIENT.DateFormatShow)#						
				<input type="hidden" name="RequestDate" id="RequestDate" value="#Dateformat(Line.RequestDate, CLIENT.DateFormatShow)#">
			</cfoutput>
					
		<cfelse>
		
		<cfif line.RequestDate eq "">
			 <cfset def = "#Dateformat(now(), CLIENT.DateFormatShow)#">
		<cfelse>
			 <cfset def = "#Dateformat(Line.RequestDate, CLIENT.DateFormatShow)#">
		</cfif>
			
	  	<cf_intelliCalendarDate9
				FieldName="RequestDate" 
				Class="regularxxl"
				Default="#def#"
				AllowBlank="False">	
			
		</cfif>	
			
		</td>
	</TR> 		
		
	<cfif parameter.EnableDueDate eq "1">	
		
		<tr class="labelmedium" style="height:30px">
		    <td><cf_tl id="Due Date">:</td>
			<td style="z-index:1; position:relative;">
			
			<cfif Access eq "View">
			
				<cfoutput>
				<cfif Line.RequestDue eq "">
				>> Undefined <<
				<input type="hidden" name="RequestDue" id="RequestDue" value="">
				<cfelse>
				#Dateformat(Line.RequestDue, CLIENT.DateFormatShow)#
				<input type="hidden" name="RequestDue" id="RequestDue" value="#Dateformat(Line.RequestDue, CLIENT.DateFormatShow)#">
				</cfif>
				</cfoutput>
						
			<cfelse>
			
				    <cfparam name="client.duedate" default="">
				
					<cfif line.RequestDue eq "">
					
						 <cf_intelliCalendarDate9
							FieldName="RequestDue"
							Class="regularxxl" 
							Default="#Dateformat(client.duedate, CLIENT.DateFormatShow)#"
							AllowBlank="True">	
					
					<cfelse>
					
					 <cf_intelliCalendarDate9
							FieldName="RequestDue"
							Class="regularxxl" 
							Default="#Dateformat(Line.RequestDue, CLIENT.DateFormatShow)#"
							AllowBlank="True">	
						
					</cfif>	
			
			</cfif>
			
			</td>
		</TR> 
			
	</cfif>
	
	<tr><td></td></tr>
	<tr class="line"><td colspan="2"></td></tr>
	<tr><td></td></tr>
	
	<TR class="labelmedium <cfif access neq 'edit'>line</cfif>">
    <TD>
	<cfif Master.Description eq "" and Line.ActionStatus gte "1">
        <font color="FF0000"><b>* <cf_tl id="Request Class">: <font color="FF0000">*</font>
	<cfelse>
		<cf_tl id="Request Class">: <font color="FF0000">*</font>
	</cfif>
	</TD>
   
    <TD colspan="2">

	<cfoutput>
			
		<cfif Access eq "View" or (Access eq "Limited" and Parameter.EnforceObject eq "1")>
				<b>(#Master.Code#)</b>
				#Master.Description#				
				<input type="hidden" name="itemmaster" id="itemmaster" value="#Master.Code#">
					
		<cfelse> 
		
			  <cfif Parameter.enableCurrency eq "0">	
				  <cfset fldcostprice = "requestcostprice">
			  <cfelse>
 		          <cfset fldcostprice = "requestcurrencyprice">
			  </cfif>
		
			  <table style="min-width:400px;width:99%;border:1px solid silver">
			  <tr>
			  
			   <td style="padding-left:5px;padding-right:5px;max-width:30px;border-right:1px solid silver">
		
				 <img src="#SESSION.root#/Images/search.png" 
				      alt="Select item master" 
					  name="img3" 					 
					  style="cursor: pointer" 
					  width="28" height="29" border="0"
					  align="absmiddle" 
					  onClick="selectmas('itemmaster','#url.mission#',document.getElementById('period').value,'#URL.id#')">
					  					  
				 </TD>
			  					  
				 <TD style="padding-left:2px;width:78%;background-color:e8e8e8">
				 
					   <input type  = "text" 
					      name      = "itemmasterdescription" 
						  id        = "itemmasterdescription" 
						  value     = "#Master.Description#" 
						  style     = "width:100%;border:0px;background-color:transparent"  
						  maxlength = "80"  
						  class     = "regularxxl" readonly> 
					  
				 </TD>
				 
				 <TD style="border-left:1px solid silver;;background-color:e8e8e8"> 		
				 					  
					   <input type  = "text" 
					      name      = "itemmaster" 
						  id        = "itemmaster" 
						  value     = "#Master.Code#" 
						  size      = "10"  
						  maxlength = "12"  					 
						  class     = "regularxxl" 
						  readonly 
						  style     = "text-align: right;min-width:60px;border:0px;background-color:transparent"> 			  
						  
				 </TD>		 
				
								 			  
			  <cfif Master.code eq "">
			  			  
				  <cfquery name="Last" datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
				    	    SELECT   TOP 1 I.Code, I.Description, I.EnforceWarehouse,R.CustomDialog 
					   		FROM     RequisitionLine L INNER JOIN
			                         ItemMaster I ON L.ItemMaster = I.Code INNER JOIN
			                         Ref_EntryClass R ON I.EntryClass = R.Code
						    WHERE    L.Mission = '#url.mission#' 
							AND      L.OfficerUserId = '#SESSION.acc#'
							AND      L.ActionStatus != '0'
							ORDER BY L.Created DESC
			  	  </cfquery>
				  
				  <cfif last.recordcount eq "1">
				  
				     <TD style="padding-left:0px;padding-right:5px;background-color:e8e8e8">				 					
				 
					 <button name = "Take last" 
					    id        = "Take last"
				        value     = "inherit"
				        type      = "button"
				        class     = "button10g"
				        style     = "width:50;height:25"
				        onClick   = "processmas('#last.code#','#fldcostprice#','0','#last.customdialog#','#last.enforcewarehouse#')"> 
						    <table align="center">
							<tr>
							<td><img src="#SESSION.root#/images/revert.png" height="13" width="13" alt="Inherit the prior selections"></td>							
							</tr>
							</table>
					</button>	
					
					</TD>						
				
				  </cfif>
			 
			 </cfif>
			 
			</tr>
			</table>			 
			  	  
		</cfif>  
				 
	</cfoutput>
	</TD>
	</TR>
				
	<cfif entryclass.customdialog eq "Materials">
	     <cfset cl = "regular">
	<cfelse>
	     <cfset cl = "hide"> 
	</cfif>	
			
	<!--- --------------------------------------------------------------------- --->	
	<!--- --- Request description and dialog driven by entry class ------------ --->
	<!--- --------------------------------------------------------------------- --->
	
	<!--- 	
	1. Contract : definition of positions
	2a. Travel : Itinerary
	2b. SSA : entery of start and end dates
	3. Materials => Specific items : selection of item
	4. Materials => Non classified item or Other : description and optional detail lines defined by system parameters	
	--->
		
	<!--- ---------------------------------------- --->
	<!--- ---custom entry driven by entry class--- --->
	<!--- ---------------------------------------- --->
				
	<tr style="height:0px">
		<td colspan="2">	
			 			
			<cfif Access eq "View" or (Access eq "Limited" and Parameter.EnforceObject eq "1")>
			
				<cf_securediv id="custom" 
				 bind="url:#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditFormCustom.cfm?mode=view&id=#url.id#&mission=#line.mission#&master=#line.itemmaster#">
						  	
			<cfelse>
						
				<cf_securediv id="custom" 
				 bind="url:#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditFormCustom.cfm?mode=edit&id=#url.id#&mission=#line.mission#&master=#line.itemmaster#">
					
			</cfif>	
			
		</td>
	</tr>
	
	
	<!--- --------------------------------- --->
	<!--- --2 of 4 - Materials selection -- --->
	<!--- --------------------------------- --->
	
	<cfoutput>
						
	<TR id="itemtypeselect" class="#cl#">
	    <TD style="height:34px;;" class="labelmedium"><cf_tl id="Item Type">:</TD>
	    <TD>
		
			<table>
			<tr class="labelmedium">
									
			<cfif Access eq "View" or operational eq "0">
			         
					 <cfif "Regular" eq Line.RequestType>
						<cf_tl id="REQ018">
					 <cfelse>
						<cf_tl id="REQ019">
					 </cfif>
				   
					 <input type="hidden" 
					       name="requesttype"  id="regulartype"
					       value="#Line.RequestType#">
						   						   
			<cfelse>
			
					<cfset description = HtmlEditFormat(line.RequestDescription)>
					<cfset description = replace(description,"'","\'","ALL")>
					
					<cfif Master.enforceWarehouse eq "1">
						<cfset cl = "hide">
					<cfelse>
						<cfset cl = "regular">
					</cfif>
					
					<td id="requesttypereg" class="#cl#">	
				      <table>
					  <tr class="labelmedium">
					  <td>
					  <input type   = "radio" 
				           onclick = "reqclass('regular','#access#','#description#',document.getElementById('itemmaster').value); requom('regular','#access#','#line.RequestQuantity#','#line.QuantityUom#','#line.WarehouseUom#')" 
					       name    = "requesttype" 
						   class   = "radiol"
						   id      = "regulartype"
					       value   = "Regular" <cfif "Regular" eq Line.RequestType or Line.RequestType eq "">checked</cfif>></td>
					  <td style="padding-left:4px"><cf_tl id="REQ018"></td>
					  </tr>
					  </table>  					   
					 </td>
				
				<cfif Operational eq "1">
				
					<td id="requesttypewhs" style="padding-left:9px" class="labelmedium">
					 <table><tr class="labelmedium"><td>
					   <input type  = "radio" 
					       name     = "requesttype" 
                           id       = "requesttype"
						   class    = "radiol"
						   onclick  = "reqclass('warehouse','#access#','#line.WarehouseItemNo#',document.getElementById('itemmaster').value);requom('warehouse','#access#',document.getElementById('requestquantity').value,'#line.QuantityUom#','#line.WarehouseUom#');"
						   value    = "Warehouse" 
						   <cfif "Warehouse" eq Line.RequestType>checked</cfif>>
						  </td><td style="padding-left:4px"> 
					   <cf_tl id="REQ019">
					    </td></tr>
					 </table>  
					   
					 </td>
					   
				</cfif>
				
			</cfif>
							
			</tr>
			</table>		
		</TD>
	</TR>	
	
	</cfoutput>	
		
	<tr><td></td></tr>		
								
	<TR>
	
	    <cfif access eq "View">
		<TD valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Request">:</TD>
		<cfelse>
	    <TD valign="top" style="padding-top:3px" class="labelmedium"><cf_tl id="Request">: <font color="FF0000">*</font></TD>
		</cfif>
	    <TD class="labelmedium">	
								
			<cfoutput>	
			
				<cfdiv id="reqcls1">	
																					
				 <cfset url.itemmaster = line.itemmaster>
				 <cfset url.reqid      = url.id> 
				 <cfset url.mis        = line.mission> 
				 <cfset url.option     = "itm">
				 <cfset url.access     = access>
				 <cfset url.des        = line.requestdescription>
				 <cfset url.item       = line.WarehouseItemNo>
				 						   		
					<cfif Line.RequestType eq "regular">	
					     <!--- this template will show a variety of possible interfaces for services 
						 throiugh RequisitionEditDetail.cfm --->			
						 <cfinclude template="RequisitionEntryInterface.cfm">												  			
					<cfelse>									
					     <!--- this template is geared for request stock items --->
						 <cfinclude template="RequisitionEntryWarehouse.cfm">						 										
					</cfif>
				
				 </cfdiv>
				 								
			</cfoutput>
		
		</TD>
	</TR>
	
					
	<cfif Line.RequestType eq "warehouse" or (parameter.RequestDescriptionMode eq "0" and (entryclass.customdialog eq "" or entryclass.customdialog eq "contract"))>
	     <cfset cl = "regular"> 	    
	<cfelse>
		 <cfset cl = "hide"> 
	</cfif>		
						 	 
	<TR id="uombox" class="<cfoutput>#cl#</cfoutput>">
    <TD class="labelmedium"><cf_tl id="UoM">:</TD>
   	<td id="reqcls2"  class="labelmedium">
				
		<cfoutput>		
									
			<cfif Line.RequestType eq "regular">
				<script>
					requom('regular','#access#','#line.RequestQuantity#','#line.QuantityUom#','#line.WarehouseUom#')
				</script>
			<cfelse>	
				<script>				
					requom('warehouse','#access#','#line.RequestQuantity#','#line.QuantityUom#','#line.WarehouseUoM#')
				</script>
			</cfif>
							
		</cfoutput>
						
	</td>
	</tr>	
		
	<cfif Line.JobNo neq "" and line.actionStatus lt "3">
		<cfset acc = "Edit">
	<cfelse>   
		<cfset acc = Access>
	</cfif>
	
	<cfquery name="Check" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   RequisitionLineService 
		WHERE  RequisitionNo = '#URL.id#'
    </cfquery>
						
	<cfif parameter.EnableBeneficiary eq "0" or check.recordcount gte "1">
										
		<TR id="quantitybox" class="<cfoutput>#cl#</cfoutput>">
		    <TD style="height:30px;" class="labelmedium"><cf_tl id="Quantity">:</TD>
		    <TD class="labelmedium">
										
				<cfoutput>
				
				<cfif Access eq "View">
				
					 #Line.RequestQuantity#
					 <input type="hidden" name="requestquantity" id="requestquantity" value="#Line.RequestQuantity#"> 
				
				<cfelse>
				
					<cfif Parameter.enableCurrency eq "0">				 		
						
					 <input type = "Text" 
					    name     = "requestquantity" 
                        id       = "requestquantity"
					    value    = "#Line.RequestQuantity#" 
						class    = "regularxxl" 
						size     = "4" 
						style    = "text-align: right;" 
						onChange = "base2('#url.id#',document.getElementById('requestcostprice').value,this.value);"> 
						
					<cfelse>
					
					 <input type = "Text" 
					    name     = "requestquantity" 
                        id       = "requestquantity"
					    value    = "#Line.RequestQuantity#" 
						class    = "regularxxl" 
						size     = "4" 
						style    = "text-align: right;" 
						onChange = "base2('#url.id#',document.getElementById('requestcurrencyprice').value,this.value);"> 
					
					</cfif>	
										
				</cfif>		
				
				</cfoutput>	
					
			</td>		
		</tr>
	
	<cfelse>
			
	  <tr id="quantitybox" class="<cfoutput>#cl#</cfoutput>">
	  <td class="labelmedium" style=";"><cf_tl id="Quantity">:</td>
	  <td class="labelmedium">
	 
		  <cfset url.requisitionNo = url.id>
		  <cfinclude template="../Beneficiary/Unit.cfm">
	  </tr>
		  
	</cfif>
			
	<!--- base currency only --->
		
	<cfif Parameter.enableCurrency eq "0">	
	
		<tr id="pricebox" class="<cfoutput>#cl#</cfoutput>">	
			<td height="23" class="labelmedium">
			
			<cfif Line.RequestCostPrice eq "0" and Line.ActionStatus gte "1">
			<font color="FF0000"><b>* <cf_tl id="REQ020"> in <cfoutput>#APPLICATION.BaseCurrency#</cfoutput> :&nbsp;
			<cfelse>
			<cf_tl id="REQ020"> in <cfoutput>#APPLICATION.BaseCurrency#</cfoutput> :&nbsp;
			</cfif>
			
			</td>
			<td  class="labelmedium">
			
			<cfoutput>
						
			<cfif Access eq "View" or (Access eq "Limited" and Parameter.EnforceObject eq "1")>
			
				<input type="hidden" name="requestcostprice" id="requestcostprice" value="#Line.RequestCostPrice#"> 
				
				<cfif Line.RequestCostPrice lte 0.01>
					#numberFormat(Line.RequestCostPrice,",__._____")# 
				<cfelse>
					#numberFormat(Line.RequestCostPrice,",__.__")# 
				</cfif>
				
			<cfelse>
			
				<cfif Line.RequestCostPrice lte 0.01>
					<cfset prc = numberFormat(Line.RequestCostPrice,',._____')>
				<cfelse>
					<cfset prc = numberFormat(Line.RequestCostPrice,',.__')>
				</cfif>
						
				<input type="text"
			       name   = "requestcostprice"
                   id     = "requestcostprice"
			       value  = "#prc#"
			       size   = "15"
			       class  = "regularxxl"
			       style  = "text-align: right;padding-right:5px"
			       onChange="base2('#url.id#',this.value,requestquantity.value);"> 
							
			</cfif>
			</cfoutput>
			</td>
			
		</tr>	
	
	<cfelse>
	
		<!--- ---------------------- --->
		<!--- enabled currency entry --->
		<!--- ---------------------- --->
	
		<tr id="pricebox" class="<cfoutput>#cl#</cfoutput>">	
			<td class="labelmedium">
						
			<cfquery name="Currency" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   Currency
				WHERE  EnableProcurement = 1
			</cfquery>
			
			<cfif Line.RequestCostPrice eq "0" and Line.ActionStatus gte "1">
				<font color="FF0000"><b>* <cf_tl id="REQ020">:&nbsp;
			<cfelse>
				<cf_tl id="REQ020"> :&nbsp;
			</cfif>
			
			</td>
						
			<cfoutput>
												
			<cfif Access eq "View">
			
				<td  class="labelmedium">		
					
					<input type="hidden" name="requestcostprice" id="requestcostprice" value="#Line.RequestCurrencyPrice#"> 
					<input type="hidden" name="requestcurrency"  id="requestcurrency"  value="#Line.RequestCurrency#"> 				
				
					#Line.RequestCurrency#
					
					<cfif Line.RequestCurrencyPrice lte 0.01>
						#numberFormat(Line.RequestCurrencyPrice,",__.______")#
					<cfelse>
						#numberFormat(Line.RequestCurrencyPrice,",__.__")#
					</cfif>
						
				</td>
				
			<cfelse>
			
				<td>
				
				<table cellspacing="0" cellpadding="0">
				
					<tr><td style="padding-right:2px">
				
					    <cfif Line.RequestCurrency eq "">
						
							<cfif Parameter.DefaultCurrency neq "">
								<cfset cur = Parameter.DefaultCurrency>
							<cfelse>
								<cfset cur = APPLICATION.BaseCurrency>
							</cfif>
							
						<cfelse>
						    <cfset cur = Line.RequestCurrency>
						</cfif>				
								
						<select name="requestcurrency" id="requestcurrency" class="regularxxl" size="1" onChange="base2('#url.id#',requestcurrencyprice.value,requestquantity.value);">
				   			<cfloop query="currency">
								<option value="#Currency#" <cfif Currency eq cur>selected</cfif>>#Currency#</option>
							</cfloop>
					    </select>
					
					</td>
					
					<td>			
					
						<cfif Line.RequestCurrencyPrice lte 0.01>
							<cfset prc = numberFormat(Line.RequestCurrencyPrice,',.______')>
						<cfelse>
							<cfset prc = numberFormat(Line.RequestCurrencyPrice,',.__')>
						</cfif>		
														
						<cfinput type="Text" 
							name="requestcurrencyprice" 
							value="#prc#" 
							message="Enter a valid amount" 
							validate="float" 
							required="Yes" 
							class="regularxxl"
							size="10" 
							style="text-align: right;height:30px" 
							onFocus = "this.select();"
							onChange="base2('#url.id#',this.value,document.getElementById('requestquantity').value);"> 
					
					</td>
					
					</tr>
					
				</table>
							
			</cfif>
			
			</cfoutput>
			
		</tr>		
		
	</cfif>	
		
	<tr><td class="labelmedium" style="height:30px">	
		<cf_tl id="REQ021"> in <cfoutput>#APPLICATION.BaseCurrency#&nbsp;:</cfoutput>
		</td>
		
		<td id="amountbox">		
				
		  <table cellspacing="0" cellpadding="0">
		  
		  <tr>
		
		  <cfoutput>
		  
		  	<td align="right" class="labellarge" bgcolor="ffffaf" style="height:27px;padding-left:25px;padding-right:5px;border:1px solid silver;">		     
			<input type="hidden" name="requestcostprice" id="requestcostprice" value="#Line.RequestCurrencyPrice#"> 
			<input type="hidden" name="requesttotal"     id="requesttotal"     value="#Line.RequestAmountBase#"> 	
			#numberFormat(Line.RequestAmountBase,",.__")# 			
			</td>
			
			<td align="right" class="labellarge" bgcolor="f4f4f4" style="padding-left:15px;padding-right:5px;border:1px solid silver;">
			<cfif Parameter.EnableCurrency eq "1" and Line.RequestCurrency neq APPLICATION.BaseCurrency><font size="1">#Line.RequestCurrency#</font> #numberformat(Line.RequestCurrencyPrice*Line.RequestQuantity,",.__")#</cfif>
			</td>			
		
		 </cfoutput>
			 
		 
		 </tr>
		 
		 </table>
		 
		 </td>
	</TR> 	
	
	<!--- new feature for some entry classes only  budget control --->
			
	<cfquery name="BudgetLines" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   RequisitionLineBudget 
			WHERE  RequisitionNo = '#URL.ID#'
	</cfquery>	
			
	<tr class="hide"><td>
		<cf_securediv id="budgetentry"
	    	bind="url:#SESSION.root#/Procurement/Application/Requisition/Requisition/RequisitionEditFormBudget.cfm?requisitionno=#url.id#&mission=#line.mission#&period=#line.period#&itemmaster=#line.itemmaster#">
	</td></tr>
	
	<tr class="hide" id="budgetentry1"><td height="0" colspan="2"></td></tr>
		
	<TR id="budgetentry2"><td id="budgetrefresh" style=";" class="labelmedium" onclick="budget()">
	
		<cfif BudgetLines.Recordcount eq "0" and Line.ActionStatus gte "1">
        <font color="FF0000"><b>* <cf_tl id="Budget">:&nbsp;
		<cfelse>
		<cf_tl id="Budget">:
		</cfif>
    	</td>
	    <TD height="23" width="85%" id="budgetbox">
												
			<script>
				budget()
			</script>
							
	    </TD>
			
	</TR>	
			
	<cfif parameter.EnableReqTag eq "1">
	
	    <!--- embed the labeling script --->
				
		<cf_ObjectListingScript entitycode="REQ">
					
		<tr class="labelmedium">
		<td valign="top" style="height:30px;padding-top:8px"><cf_tl id="Cost Tagging">:</td>
		<td colspan="1" id="label" style="padding-top:2px">
			
			  <cf_ObjectListing 
			    TableWidth       = "100%"
				Label            = "No"
			    EntityCode       = "REQ"
				ObjectReference  = "Requisition"
				ObjectKey        = "#URL.ID#"
				Mission          = "#Line.Mission#"
				Amount           = "#Line.RequestAmountBase#" 
				Entry            = "Multiple"
				Object           = "Purchase.dbo.RequisitionLineFunding"  
				Currency         = "#APPLICATION.BaseCurrency#">
			
			</td>
		</tr>  
		
	</cfif>
	
	<!--- ---------------------------------------- --->
	<!--- determine if the funding should be shown --->
	<!--- ---------------------------------------- --->	
												
	<tr class="hide" id="funding1"><td height="0" colspan="2"></td></tr>	
				
	<TR id="funding2" class="labelmedium  <cfif access neq 'edit'>line</cfif>">
	
	        <td id="fundingrefresh" valign="top" style=";cursor:pointer;font-size:14px;padding-top:4px" onclick="funding('')">			
			<cf_tl id="Funding">:								
	    	</td>
			
		    <TD height="23" id="fundbox" style="padding-right:20px">			
				<script>funding('')</script>														
				
		    </TD>
				
	</TR>		
	
			
	<cfoutput>
			
	<TR style="<cfif access neq 'edit'>border-top:1px solid silver</cfif>">
        <td valign="top" style="padding-top:5px;height:30px" class="labelmedium"><cf_tl id="Attachments">:</td>
		<TD style="padding-right:20px">
		     <cfinclude template="RequisitionEntryAttachment.cfm">
		</TD>
	</TR>
				
 	</cfoutput>
	
	<cfif Access eq "Edit" or Access eq "Limited">		
	 
	    <TR>     
		
						 				 
			 <td id="memo" colspan="2" style="padding-right:20px">
			 
				<cfif Parameter.RequisitionTextMode eq "1">
											
						<cf_textarea name = "Remarks"                 				             
						 height          = "100"																		 						 
						 toolbar         = "mini"
						 width           = "100%"
						 init            = "Yes"
						 color           = "ffffff"><cfoutput>#Line.Remarks#</cfoutput></cf_textarea>
							
				<cfelse>		
				
					<textarea class="regular" name = "Remarks" style="font-size:13px;padding:3px;width:99%;height:99%"><cfoutput>#Line.Remarks#</cfoutput></textarea>
				
				</cfif>						
			 
			 </td>
			 
		</tr>	
	 
	 <cfelse>
										   
		<TR>     
				
		 	<td valign="top" style="padding-top:5px" class="labelmedium">										
					<cf_tl id="REQ022">:											
			 </td>
			 
			 <td id="memo" style="padding-top:2px">	 		  				
					<input type="hidden" name="Remarks" value="<cfoutput>#Line.Remarks#</cfoutput>">			
						
					<cfinclude template="RequisitionEditMemoShow.cfm">								 
			 </td>
			 
		</tr>	
		
	</cfif>	
	
	<cf_tl id="Undo" var="1">
	<cfset vUndo=lt_text>
	
	<cf_tl id="Remove" var="1">
	<cfset vRemove=lt_text>	
	
	<cf_tl id="Cancel" var="1">
	<cfset vCancel=lt_text>		
	
	<cf_tl id="Save" var="1">
	<cfset vSave=lt_text>	
		
	<cf_tl id="Close" var="1">
	<cfset vClose=lt_text>	
	
	<cf_tl id="Reinstate" var="1">
	<cfset vReinstate=lt_text>	

	<cf_tl id="To Requester" var="1">
	<cfset vToRequester=lt_text>	
	
	<cf_tl id="Save" var="1">
	<cfset vUpdate=lt_text>	
	
	<cf_tl id="Clone" var="1">
	<cfset vClone=lt_text>	

	<cf_tl id="Cancel" var="1">
	<cfset vCancel=lt_text>		
						
	<cfif back eq "1" and (AccessModule eq "GRANTED" or access eq "Limited")>
				
		<tr id="reqaction" name="reqaction" class="hide">
		    <td colspan="2" class="labellarge" style="padding-bottom:5px;padding-top:6px;font-size:29px;height:50px"><cf_tl id="Cancel">/<cf_tl id="Send back"></td></tr>
	
	    <tr name="reqaction"  class="hide" id="reqaction"><td colspan="2" class="line" height="5"></td></tr>
		
		<tr name="reqaction" id="reqaction" class="hide">	
		   <td height="20" colspan="1" class=" labelmedium" style="padding-left:9px"><cf_tl id="Subject">:</td>
		   <td><input type="text" name="ActionMemo" id="ActionMemo" size="60" class="regularxl" maxlength="100" style="width:90%"></td>
		</tr>
				
		<tr name="reqaction" id="reqaction" class="hide">	
		   <td colspan="1" class="labelmedium" style="padding-left:9px"><cf_tl id="Remarks">:</td>
		   <td><textarea style="width:90%;font-size:13px;padding:3px" rows="4" class="regular" id="ActionContent" name="ActionContent"></textarea></td>
		</tr>
	
	</cfif>
					
	<cfif Object.ObjectKeyValue1 eq "" and (AccessModule eq "GRANTED" or access eq "Limited")>	
	
	    <!--- standard mode, no workflow enabled --->		
		
		<cfif url.mode eq "Budget">
		
		<cfoutput>
		<tr class="line" id="submitline">
		    <td colspan="2" align="center">
			<table><tr>
				   						  
					<td style="padding-right:2px">
					<input class="button10g" style="width:140;height:26px;font-size:13px" type="button" name="purge" id="purge" value="#vRemove#" onclick="askpurge()"></td>	
					</td>	
					 <td>			
					   <input class="button10g" type="button" style="width:140;height:26px;font-size:13px" onclick="updateTextArea();Prosis.busy('yes');ptoken.navigate('RequisitionEditSubmit.cfm?ID=#URL.ID#&Mode=#URL.Mode#&refer=#url.refer#','resultsubmit','','','POST','processaction')"
					  id="save" name="save" value="#vUpdate#">		
					</td>		  
			      </tr>
		   </table>
		   </td>	
					
		</tr>
		</cfoutput>										
				
		<cfelseif (Line.JobNo neq "" and (Line.ActionStatus eq "1p")) 
		 or Line.ActionStatus eq "1f"
		 or line.ActionStatus eq "2"		  
		 or line.ActionStatus eq "2a"
		 or line.ActionStatus eq "2b"		
		 or line.ActionStatus eq "2f"
		 or line.ActionStatus eq "2i" 
		 or Line.ActionStatus eq "2k"		
		 or Line.ActionStatus eq "2q">		
				 
		  <!--- 10/4/2011 : added 2q condition for erica --->
		  
			<cfquery name="Check" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			       SELECT *
				   FROM   PurchaseLine
				   WHERE  RequisitionNo = '#URL.ID#'  
			 </cfquery>  
			 						 
		    <cfif Check.recordcount eq "0">		 
		     
			<tr class="hide" name="reqaction" id="reqaction">
			    <td class="labelmedium" valign="top" style="padding-left:9px;padding-top:6px"><cf_tl id="Reasons">:</td>
				<td>
					<cf_securediv bind="url:../Process/RequisitionProcessReason.cfm?row=1&requisitionno=#Line.requisitionno#&statusclass=requisition&status=9">
				</td>
			</tr>				
									
			<script language="JavaScript">
			
			function sendback() {
				se = document.getElementsByName("reqaction")
				document.getElementById("sendback1").className = "hide"
				count = 0
				while (se[count]) {
				    se[count].className = "regular"
				    count++
				}
			}
			
			</script>			
										
			<tr class="line"><td colspan="2" align="center" height="40">
						
				<cfoutput>		
				
					<table border="0">
					<tr>
					
					<cf_tl id="Send back" var="vSendBack">
						
					<td id="sendback1" class="labellarge">
										
						 <input type="button" 
					        name="cancel" 
                            id="cancel"
							value="#vCancel# / #vSendBack#" 
							style="font-size:12px;width:180px;height:29px;" 
							class="button10g"
							onClick="sendback()">	
							
							 
				    </td>			
					
					<td class="hide" id="reqaction" name="reqaction" align="center">
																
					<cfif access neq "Limited">		
																  
					 	 <input type="button" 
					        name="cancel" 
                            id="cancel"
							value="#vCancel#" 
							style="font-size:12px;width:120px;height:29px;" 
							class="button10g"
							onClick="askcancel('warning')">	
							
					</cfif> 
										
						<input type="button" 
					       name="Revert" 
                           id="Revert"
						   value="#vToRequester#" 
						   class="button10g"  
						   style="font-size:12px;width:120px;height:29px;" 
						   onClick="asksendback('warning')">
											   
					</td>	
					
					<td style="padding-left:3px">
														   
					<cfif Access neq "View">
								
					    <input class="button10g"
						   type="button" 
						   name="save" 
                           id="save"
						   style="font-size:12px;width:120px;height:29px;" 
						   value="#vSave#" 
						   onclick="Prosis.busy('yes');ptoken.navigate('RequisitionEditSubmit.cfm?ID=#URL.ID#&Mode=#URL.Mode#','resultsubmit','','','POST','processaction')">		  				 
						   
					</cfif>		   
										
					</td>					
										
					</tr>
					</table>
					 							  
				</cfoutput>	  
					
			  </td></tr>
		  
		    </cfif> 
		
	<cfelse>		
	
	    <!--- workflow enabled --->
			
			<tr id="submitline">	
			   <td align="center" colspan="2" height="35">
			   
			       <table class="formpadding">
				   <tr>
			   
			   	   <cfoutput>				   
				   		   
				   <cfif Access eq "Edit" or Access eq "Limited">
				   
				   	<!--- check if PO was created --->
									
					 <cfif Line.actionStatus neq "9">
					 
						 <cfquery name="Check" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
					       SELECT *
						   FROM   PurchaseLine
						   WHERE  RequisitionNo = '#URL.ID#'
					    </cfquery>
						
						 <cfif Check.recordcount eq "0">
						 
						   <cfif Access eq "Edit">			
						   						   						   						   
							   <cfif Line.OrgUnit neq "">						   	 			   	
							       <cfif Line.ActionStatus eq "1">
								     <td><input class="button10g" style="width:140;height:28px;font-size:13px" type="button" name="purge" id="purge" value="#vRemove#" onclick="askpurge()"></td>
								   <cfelseif Line.ActionStatus eq "1f">
								     <td style="padding-left:1px"><input class="button10g" style="width:140;height:28px;font-size:13px" type="button" name="purge" id="purge" value="#vRemove#" onclick="askpurge()"></td>
									 <td style="padding-left:1px"><input class="button10g" style="width:140;height:28px;font-size:13px" type="button" name="cancelselect" id="cancelselect" value="#vCancel#" onclick="cancelreq()"></td> 						  
								   <cfelseif Line.ActionStatus eq "1p" and Parameter.RequestPurge eq "1"> 
								     <td style="padding-left:1px"><input class="button10g" style="width:140;height:28px;font-size:13px" type="button" name="purge" id="purge" value="#vRemove#" onclick="askpurge()"></td>
								   <cfelse>										  
								     <cfif url.mode neq "Entry">
									     <td style="padding-left:1px"><input class="button10g" style="width:140;height:28px;font-size:13px" type="button" name="cancelselect" id="cancelselect" value="#vCancel#" onclick="cancelreq()"></td>
									 </cfif>
								   </cfif>
							   </cfif>
							  						   
						   </cfif>	
						  	
							
					  	   <cfif Line.ActionStatus eq "1">
						   		<td style="padding-left:1px">
									 <input class="button10g" type="button" name="clone" id="clone"  style="width:140;height:28px;font-size:13px" value="#vClone#" onclick="askclone()">
								</td>
						   </cfif>
							
							 <td style="padding-left:1px">			
							
							   <input class="button10g" type="button" style="width:140;height:28px;font-size:13px" onclick="updateTextArea();Prosis.busy('yes');ptoken.navigate('RequisitionEditSubmit.cfm?ID=#URL.ID#&Mode=#URL.Mode#&refer=#url.refer#','resultsubmit','','','POST','processaction')"
								  id="save" name="save" value="#vUpdate#">		
								 							  
							  </td>
						   
						   
						  </cfif> 
					  
					  </cfif>

					  <cfif Line.ActionStatus eq "9" and getAdministrator(line.mission) eq "1"> 
					   						   
						   <cfset funds = "Yes">
						   
						   <cfif funds eq "Yes">   
						   
						       <td>
							   							   
							   <input type="button" class="button10g" style="width:140;height:25px;font-size:13px" name="reinstate" id="reinstate" value="#vReinstate#" onclick="askreinstate()">
							   </td>
							
						   </cfif>
					   	   
					   </cfif>				
				  				   
				   <cfelse>
				   
				   	   <cfif url.mode neq "workflow">
				      
					  	   <td>
						   <input type="button" class="button10g" style="width:140;height:28px;font-size:13px" name="Close" id="Close" value="#vClose#" onClick="window.close()">
						   </td>
						   
						   <cfif Line.ActionStatus eq "9" and getAdministrator(line.mission) eq "1" and Line.Recordcount gte "1"> 
						   					   							   
							   <cfset funds = "Yes">
							   
							   <cfif funds eq "Yes">   
								   <td style="padding-left:3px">							   
								   <input type="button" class="button10g" style="width:140;height:28px;font-size:13px" name="reinstate" id="reinstate" value="#vReinstate#" onclick="askreinstate()">
								   </td>								
							   </cfif>
						   	   
						   </cfif>
					   
					   </cfif>
					   		   
				   </cfif>
				   
				   </cfoutput>
				   
				   </tr></table>
				  
			   </td>
			</tr>					
			
			<tr id="reqaction" name="reqaction" class="hide">
			    <td>
								
  			    <input type="button" 
					name="cancel" 
					class="button10g"
                    id="cancel"
					style="width:140;height:28px;font-size:13px"
					value="Cancel Line" 
					onclick="askcancel('reqaction')">
				</td>
				<td>				
					<cf_securediv bind="url:../Process/RequisitionProcessReason.cfm?row=1&requisitionno=#Line.requisitionno#&statusclass=requisition&status=9">
				</td>
			</tr>	
		
		</cfif>
	
	</cfif>
	
	<!--- ------------------------------------ --->
	<!--- define if the workflow will be shown --->
	<!--- ------------------------------------ --->
	
	<cfif Object.ObjectKeyValue1 eq "">
	
		<cfquery name="FlowSetting" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
				SELECT   S.*
				FROM     RequisitionLine R INNER JOIN
		                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
		                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
				WHERE    (R.RequisitionNo = '#Line.RequisitionNo#')
		</cfquery>		
		
		<cfif FlowSetting.EnableFundingClear eq "0">
			  <!--- final step in workflow will set to 2f --->
		      <cfset wfs = "1p,2">		  
		<cfelse>
		      <!--- final step in workflow will set to 2 --->
		      <cfset wfs = "1p"> 
		</cfif>
				
		<cfquery name="EntrySetting" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   Ref_ParameterMissionEntryClass
			WHERE  Mission    = '#Line.Mission#' 
			AND    EntryClass = '#EntryClass.EntryClass#'
			AND    Period     = '#Line.Period#'
		</cfquery>
				
		<cfquery name="Object" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   OrganizationObject
			WHERE  ObjectKeyValue1 = '#Line.RequisitionNo#' 
			AND    EntityCode      = 'ProcReq'			
		</cfquery>		

		<cfif Line.actionStatus eq "1">
				<!--- collaboration --->
			 		 			
				<cf_workflowenabled 
				     mission="#line.mission#" 
					 entitycode="ProcReq">
			
				<cfif workflowenabled eq "1" and line.actionstatus gte "0" and (EntrySetting.Collaboration eq "1" or Object.Recordcount eq "1")>
				
				   <!--- collaboration flow --->
				
				   <tr>					  
				  	<td align="center" height="35" colspan="2">	
				 			
						<cf_ActionListingScript>
						<cf_FileLibraryScript>
						
						<cfoutput>
					
						  <input type="hidden" 
					   		name="workflowlink_prepare_#url.id#" 
	                        id="workflowlink_prepare_#url.id#"
						    value="RequisitionEditFlow.cfm">	
							
						  <input type="hidden" 
					   		name="workflowlinkprocess_prepare_#url.id#" 
	                        id="workflowlinkprocess_prepare_#url.id#"
						    onclick="ptoken.navigate('RequisitionEditStatus.cfm?requisitionno=#url.id#','reqstatus')">
							
						</cfoutput>
							
						<cf_securediv bind="url:#SESSION.root#/procurement/application/requisition/requisition/RequisitionEditFlow.cfm?ajaxid=prepare_#URL.ID#" id="prepare_#URL.ID#">					
										 
					</td>					
				   </tr>				   
							
				</cfif> 
								 				 
		 <cfelseif find(Line.actionStatus,wfs)>	
		 
		 		<!--- review --->
			
			 	<cfquery name="Check" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 SELECT  P.EntityClass
					 FROM    ItemMaster IM INNER JOIN
		                     RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
			                 Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
						 AND L.Mission = P.Mission 
						 AND L.Period = P.Period
					 WHERE   (L.RequisitionNo = '#URL.ID#')
				</cfquery>		
							
				<cfif check.entityclass neq "">	
			 
				 	 <!--- review flow --->	 
					
					 <tr>	
					   <td align="center" height="35" colspan="2">	 
					
						<cf_ActionListingScript>
						<cf_FileLibraryScript>
						
						<cfoutput>
					
						  <input type="hidden" 
					   		name   = "workflowlink_review_#url.id#" 
                            id     = "workflowlink_review_#url.id#"
						    value  = "RequisitionReviewFlow.cfm">	
							
						  <input type="button" class="hide"
					       name    = "workflowlinkprocess_review_#url.id#"
                           id      = "workflowlinkprocess_review_#url.id#"
					       onClick = "ptoken.navigate('RequisitionEditStatus.cfm?requisitionno=#url.id#','reqstatus')">
						
						</cfoutput>
							
						<cf_securediv bind="url:#SESSION.root#/procurement/application/requisition/requisition/RequisitionReviewFlow.cfm?ajaxid=review_#URL.ID#" id="review_#URL.ID#">					
										 
						</td>
					 </tr>	
				
				</cfif>
					
		</cfif>	 
		
	</cfif>	
			
	<cfoutput>
		<input name="Key1" id="Key1"  type="hidden"  value="#URL.ID#">
		<input name="savecustom" id="savecustom" type="hidden"  value="Procurement/Application/Requisition/Requisition/RequisitionEditSubmit.cfm">
		<input name="savetext" id="savetext"   type="hidden"  value="0">
	</cfoutput>	
	
	<tr><td height="1" colspan="2" id="warning"></td></tr>	 
		   
    </table>
			
	</td></tr>
	
</table>

</cf_divscroll>

	